[CmdletBinding(SupportsShouldProcess=$true)]
param(
    [string]$ToolkitSourceRoot = (Split-Path -Parent $PSScriptRoot),
    [string]$InstallRoot = (Join-Path $HOME '.agent-engineering'),
    [switch]$UpgradeCanonical,
    [switch]$IntegrateCodexOverride,
    [switch]$ForceManagedSkillOverwrite
)

$ErrorActionPreference = 'Stop'
if ($env:OS -ne 'Windows_NT') {
    throw 'Native Windows PowerShell required; do not configure Windows Agents from WSL/Linux.'
}

$script:BackedUpPaths = @{}

function Get-CodexHome {
    if ($env:CODEX_HOME) { return $env:CODEX_HOME }
    return (Join-Path $HOME '.codex')
}
function Get-ClaudeHome {
    if ($env:CLAUDE_CONFIG_DIR) { return $env:CLAUDE_CONFIG_DIR }
    return (Join-Path $HOME '.claude')
}
function Backup-Path([string]$Path) {
    if (-not (Test-Path $Path)) { return }
    $key = [System.IO.Path]::GetFullPath($Path).ToLowerInvariant()
    if ($script:BackedUpPaths.ContainsKey($key)) { return }
    $stamp = Get-Date -Format 'yyyyMMdd-HHmmss'
    $dst = "$Path.agent-engineering-backup-$stamp"
    if ($PSCmdlet.ShouldProcess($Path, "Backup to $dst")) {
        Copy-Item $Path $dst -Recurse -Force
        $script:BackedUpPaths[$key] = $true
    }
}
function Get-MarkerBlock([string]$Text) {
    $begin = '<!-- AGENT-ENGINEERING-TOOLKIT:BEGIN -->'
    $end = '<!-- AGENT-ENGINEERING-TOOLKIT:END -->'
    $pattern = [regex]::Escape($begin) + '(?s).*?' + [regex]::Escape($end)
    $m = [regex]::Match($Text, $pattern)
    if ($m.Success) { return $m.Value.Trim() }
    return $null
}
function Set-MarkerBlock([string]$Path, [string]$Block) {
    $begin = '<!-- AGENT-ENGINEERING-TOOLKIT:BEGIN -->'
    $end = '<!-- AGENT-ENGINEERING-TOOLKIT:END -->'
    $existing = if (Test-Path $Path) { Get-Content $Path -Raw -Encoding UTF8 } else { '' }
    $pattern = [regex]::Escape($begin) + '(?s).*?' + [regex]::Escape($end)
    if ([regex]::IsMatch($existing, $pattern)) {
        $replacement = $Block.Trim()
        $new = [regex]::Replace($existing, $pattern, [System.Text.RegularExpressions.MatchEvaluator]{ param($m) $replacement })
    } elseif ([string]::IsNullOrWhiteSpace($existing)) {
        $new = $Block.Trim() + "`r`n"
    } else {
        $new = $existing.TrimEnd() + "`r`n`r`n" + $Block.Trim() + "`r`n"
    }
    if ($existing -eq $new) { return }
    if (Test-Path $Path) { Backup-Path $Path }
    if ($PSCmdlet.ShouldProcess($Path, 'Update Toolkit marker block')) {
        $parent = Split-Path -Parent $Path
        if ($parent) { New-Item -ItemType Directory -Force -Path $parent | Out-Null }
        Set-Content -Path $Path -Value $new -Encoding UTF8
    }
}
function Get-FlatSkill([string]$SourceDir) {
    $main = Get-Content (Join-Path $SourceDir 'SKILL.md') -Raw -Encoding UTF8
    $main = [regex]::Replace($main, '(?ms)\r?\nRead:\s*\r?\n\s*`references/[^`]+`\s*', "`r`nThe detailed reference playbook is embedded below.`r`n")
    $parts = New-Object System.Collections.Generic.List[string]
    $parts.Add($main.Trim())
    $refs = Join-Path $SourceDir 'references'
    if (Test-Path $refs) {
        foreach ($ref in (Get-ChildItem $refs -File -Filter '*.md' | Sort-Object Name)) {
            $parts.Add("`r`n---`r`n## Embedded Reference: $($ref.Name)`r`n")
            $parts.Add((Get-Content $ref.FullName -Raw -Encoding UTF8).Trim())
        }
    }
    return ($parts -join "`r`n") + "`r`n"
}
function Test-ManagedDirectory([string]$Path) {
    return (Test-Path (Join-Path $Path '.agent-engineering-managed'))
}
function Test-ManagedFlatSkill([string]$FlatPath, [string]$SidecarPath) {
    if (-not (Test-Path $FlatPath)) { return $true }
    return (Test-Path $SidecarPath)
}
function Copy-ManagedSkill([string]$Source, [string]$Target) {
    if (Test-Path $Target) { Backup-Path $Target }
    if ($PSCmdlet.ShouldProcess($Target, "Install managed Skill from $Source")) {
        if (Test-Path $Target) { Remove-Item $Target -Recurse -Force }
        $parent = Split-Path -Parent $Target
        New-Item -ItemType Directory -Force -Path $parent | Out-Null
        Copy-Item $Source $Target -Recurse -Force
    }
}
function Merge-MachineProfileDefaults([string]$ProfilePath, [string]$TemplatePath) {
    if (-not (Test-Path $TemplatePath)) { throw "Machine profile template missing: $TemplatePath" }
    if (-not (Test-Path $ProfilePath)) {
        if ($PSCmdlet.ShouldProcess($ProfilePath, 'Create Machine Execution Profile from current template')) {
            Copy-Item $TemplatePath $ProfilePath -Force
        }
        return
    }

    $profile = Get-Content $ProfilePath -Raw -Encoding UTF8
    $template = Get-Content $TemplatePath -Raw -Encoding UTF8
    $templateSchema = [regex]::Match($template, '(?m)^Profile-Schema-Version:\s*(.+)$')
    if ($templateSchema.Success) {
        if ([regex]::IsMatch($profile, '(?m)^Profile-Schema-Version:\s*.+$')) {
            $profile = [regex]::Replace($profile, '(?m)^Profile-Schema-Version:\s*.+$', 'Profile-Schema-Version: ' + $templateSchema.Groups[1].Value.Trim(), 1)
        } else {
            $profile = 'Profile-Schema-Version: ' + $templateSchema.Groups[1].Value.Trim() + "`r`n" + $profile
        }
    }

    $requiredKeys = @(
        'filesystem_search_policy_id',
        'drive_root_recursive_search',
        'concurrent_large_tree_scans',
        'indexed_search_preference'
    )
    $templateFence = [regex]::Match($template, '(?s)## User Policy — PRESERVE ON REFRESH\s*```yaml\s*(.*?)\s*```')
    $profileFence = [regex]::Match($profile, '(?s)## User Policy — PRESERVE ON REFRESH\s*```yaml\s*(.*?)\s*```')
    if (-not $templateFence.Success -or -not $profileFence.Success) {
        throw 'Machine profile User Policy YAML block missing; refusing automatic migration.'
    }

    $body = $profileFence.Groups[1].Value.TrimEnd()
    foreach ($key in $requiredKeys) {
        if (-not [regex]::IsMatch($body, '(?m)^' + [regex]::Escape($key) + '\s*:')) {
            $m = [regex]::Match($templateFence.Groups[1].Value, '(?m)^' + [regex]::Escape($key) + '\s*:\s*.*$')
            if (-not $m.Success) { throw "Required machine policy default missing from template: $key" }
            $body += "`r`n" + $m.Value.Trim()
        }
    }

    $newFence = '## User Policy — PRESERVE ON REFRESH' + "`r`n" + '```yaml' + "`r`n" + $body.Trim() + "`r`n" + '```'
    $profile = [regex]::Replace($profile, '(?s)## User Policy — PRESERVE ON REFRESH\s*```yaml\s*.*?\s*```', [System.Text.RegularExpressions.MatchEvaluator]{ param($m) $newFence }, 1)
    if ((Get-Content $ProfilePath -Raw -Encoding UTF8) -eq $profile) { return }
    Backup-Path $ProfilePath
    if ($PSCmdlet.ShouldProcess($ProfilePath, 'Merge missing v1.6.1 machine policy defaults without weakening existing values')) {
        Set-Content -Path $ProfilePath -Value $profile -Encoding UTF8
    }
}

# ---- Source validation before any write ----
$versionFile = Join-Path $ToolkitSourceRoot 'VERSION'
if (-not (Test-Path $versionFile)) { throw 'VERSION missing from package.' }
$version = (Get-Content $versionFile -Raw -Encoding UTF8).Trim()
if (-not $version) { throw 'VERSION is empty.' }
$canonicalSrc = Join-Path $ToolkitSourceRoot '01_CANONICAL'
$skillsSrc = Join-Path $ToolkitSourceRoot '02_SKILLS'
$adapterSrc = Join-Path $ToolkitSourceRoot '03_ADAPTERS'
$scriptsSrc = Join-Path $ToolkitSourceRoot '04_SCRIPTS'
foreach ($p in @($canonicalSrc,$skillsSrc,$adapterSrc,$scriptsSrc)) {
    if (-not (Test-Path $p)) { throw "Required package path missing: $p" }
}

$codexHome = Get-CodexHome
$claudeHome = Get-ClaudeHome
$geminiHome = Join-Path $HOME '.gemini'
$codexAgents = Join-Path $codexHome 'AGENTS.md'
$codexOverride = Join-Path $codexHome 'AGENTS.override.md'
$claudeMd = Join-Path $claudeHome 'CLAUDE.md'
$geminiMd = Join-Path $geminiHome 'GEMINI.md'

# Active Codex override can suppress AGENTS.md. Fail before any mutation unless it is already managed or explicit integration is authorized.
if (Test-Path $codexOverride) {
    $overrideText = Get-Content $codexOverride -Raw -Encoding UTF8
    if (-not [string]::IsNullOrWhiteSpace($overrideText) -and -not $overrideText.Contains('AGENT-ENGINEERING-TOOLKIT:BEGIN') -and -not $IntegrateCodexOverride) {
        throw 'Active Codex AGENTS.override.md is non-empty and lacks the Toolkit marker. Re-run with -IntegrateCodexOverride after reviewing the file.'
    }
}

# Full conflict pre-scan: no writes occur before every Skill destination is known safe.
$skills = @('contract-impact-check','stage-execution','independent-review')
$skillTargets = @(
    @{ Name='Codex'; Root=(Join-Path $HOME '.agents\skills') },
    @{ Name='Claude'; Root=(Join-Path $claudeHome 'skills') },
    @{ Name='Antigravity IDE'; Root=(Join-Path $geminiHome 'config\skills') }
)
$conflicts = New-Object System.Collections.Generic.List[string]
foreach ($entry in $skillTargets) {
    foreach ($s in $skills) {
        $target = Join-Path $entry.Root $s
        if ((Test-Path $target) -and -not (Test-ManagedDirectory $target) -and -not $ForceManagedSkillOverwrite) {
            $conflicts.Add("$($entry.Name) unmanaged skill conflict: $target")
        }
    }
}
$cliRoot = Join-Path $geminiHome 'antigravity-cli\skills'
foreach ($s in $skills) {
    $flat = Join-Path $cliRoot "$s.md"
    $side = Join-Path $cliRoot "$s.agent-engineering-managed"
    if (-not (Test-ManagedFlatSkill $flat $side) -and -not $ForceManagedSkillOverwrite) {
        $conflicts.Add("Antigravity CLI unmanaged flat skill conflict: $flat")
    }
}
if ($conflicts.Count -gt 0) {
    throw ("Skill conflict pre-scan failed before any write:`r`n - " + ($conflicts -join "`r`n - "))
}

# ---- Existing install/version gate ----
if (Test-Path $InstallRoot) {
    $existingVersionFile = Join-Path $InstallRoot 'VERSION'
    $existingVersion = if (Test-Path $existingVersionFile) { (Get-Content $existingVersionFile -Raw -Encoding UTF8).Trim() } else { $null }
    if ($existingVersion -and $existingVersion -ne $version -and -not $UpgradeCanonical) {
        throw "Installed $existingVersion differs from package $version. Re-run with -UpgradeCanonical after WhatIf review."
    }
    if (-not $existingVersion -and -not $UpgradeCanonical) {
        throw 'Install root exists without trusted VERSION. Inspect it, then use -UpgradeCanonical only if replacement is intended.'
    }
    if ($UpgradeCanonical) { Backup-Path $InstallRoot }
}

# ---- Install canonical package ----
if ($PSCmdlet.ShouldProcess($InstallRoot, "Install Agent Engineering Toolkit $version")) {
    New-Item -ItemType Directory -Force -Path $InstallRoot | Out-Null
    Copy-Item (Join-Path $canonicalSrc '*') $InstallRoot -Recurse -Force
    Copy-Item $versionFile (Join-Path $InstallRoot 'VERSION') -Force
    foreach ($d in @('skills','project-templates','scripts','adapters')) {
        $managedDir = Join-Path $InstallRoot $d
        if (Test-Path $managedDir) { Remove-Item $managedDir -Recurse -Force }
        New-Item -ItemType Directory -Force -Path $managedDir | Out-Null
    }
    Copy-Item (Join-Path $skillsSrc '*') (Join-Path $InstallRoot 'skills') -Recurse -Force
    Copy-Item (Join-Path $adapterSrc 'PROJECT_TEMPLATES\*') (Join-Path $InstallRoot 'project-templates') -Recurse -Force
    Copy-Item (Join-Path $adapterSrc '*') (Join-Path $InstallRoot 'adapters') -Recurse -Force
    Copy-Item (Join-Path $scriptsSrc '*') (Join-Path $InstallRoot 'scripts') -Recurse -Force
}

# Preserve existing Machine Profile; only merge missing safety defaults.
$machineProfile = Join-Path $InstallRoot 'MACHINE_EXECUTION_PROFILE.md'
$machineTemplate = Join-Path $canonicalSrc 'MACHINE_EXECUTION_PROFILE_TEMPLATE.md'
Merge-MachineProfileDefaults $machineProfile $machineTemplate

# ---- Global adapters ----
$userProfileForward = $HOME.Replace('\','/')
$codexTemplate = (Get-Content (Join-Path $ToolkitSourceRoot '03_ADAPTERS\CODEX_GLOBAL_AGENTS_TEMPLATE.md') -Raw -Encoding UTF8).Replace('<USERPROFILE_FORWARD>',$userProfileForward)
$claudeTemplate = (Get-Content (Join-Path $ToolkitSourceRoot '03_ADAPTERS\CLAUDE_GLOBAL_CLAUDE_TEMPLATE.md') -Raw -Encoding UTF8).Replace('<USERPROFILE_FORWARD>',$userProfileForward)
$geminiTemplate = (Get-Content (Join-Path $ToolkitSourceRoot '03_ADAPTERS\ANTIGRAVITY_GLOBAL_GEMINI_TEMPLATE.md') -Raw -Encoding UTF8).Replace('<USERPROFILE_FORWARD>',$userProfileForward)
$codexBlock = Get-MarkerBlock $codexTemplate
$claudeBlock = Get-MarkerBlock $claudeTemplate
$geminiBlock = Get-MarkerBlock $geminiTemplate
if (-not $codexBlock -or -not $claudeBlock -or -not $geminiBlock) { throw 'Adapter template marker block missing; refusing installation.' }
Set-MarkerBlock $codexAgents $codexBlock
Set-MarkerBlock $claudeMd $claudeBlock
Set-MarkerBlock $geminiMd $geminiBlock
if (Test-Path $codexOverride) {
    $overrideText = Get-Content $codexOverride -Raw -Encoding UTF8
    if ($IntegrateCodexOverride -or $overrideText.Contains('AGENT-ENGINEERING-TOOLKIT:BEGIN')) {
        Set-MarkerBlock $codexOverride $codexBlock
    }
}

# ---- Skills ----
foreach ($s in $skills) {
    $src = Join-Path $ToolkitSourceRoot "02_SKILLS\$s"
    foreach ($entry in $skillTargets) {
        $target = Join-Path $entry.Root $s
        if ((Test-Path $target) -and -not (Test-ManagedDirectory $target) -and $ForceManagedSkillOverwrite) { Backup-Path $target }
        Copy-ManagedSkill $src $target
    }

    $flat = Join-Path $cliRoot "$s.md"
    $side = Join-Path $cliRoot "$s.agent-engineering-managed"
    if ((Test-Path $flat) -and -not (Test-Path $side) -and $ForceManagedSkillOverwrite) { Backup-Path $flat }
    if (Test-Path $flat) { Backup-Path $flat }
    if (Test-Path $side) { Backup-Path $side }
    if ($PSCmdlet.ShouldProcess($flat, 'Install Toolkit-managed Antigravity CLI flat Skill')) {
        New-Item -ItemType Directory -Force -Path $cliRoot | Out-Null
        Set-Content -Path $flat -Value (Get-FlatSkill $src) -Encoding UTF8
        Set-Content -Path $side -Value "managed-by: Agent-Engineering-Toolkit`r`nToolkit-Version: $version" -Encoding UTF8
    }
}

Write-Host "Install/upgrade planned/completed for Toolkit $version. Run refresh-machine-profile.ps1 and verify-agent-engineering.ps1 next."
