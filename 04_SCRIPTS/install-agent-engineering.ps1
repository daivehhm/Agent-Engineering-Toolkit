[CmdletBinding(SupportsShouldProcess=$true)]
param(
    [string]$ToolkitSourceRoot = (Split-Path -Parent $PSScriptRoot),
    [string]$InstallRoot = (Join-Path $HOME ".agent-engineering"),
    [switch]$UpgradeCanonical,
    [switch]$IntegrateCodexOverride,
    [switch]$ForceManagedSkillOverwrite
)

$ErrorActionPreference = "Stop"

function Get-CodexHome {
    if ($env:CODEX_HOME) { return $env:CODEX_HOME }
    return (Join-Path $HOME ".codex")
}
function Get-ClaudeHome {
    if ($env:CLAUDE_CONFIG_DIR) { return $env:CLAUDE_CONFIG_DIR }
    return (Join-Path $HOME ".claude")
}
function Backup-FileIfExists([string]$Path) {
    if (-not (Test-Path $Path)) { return $null }
    if ($WhatIfPreference) {
        Write-Host "WhatIf: would backup $Path"
        return $null
    }
    $stamp = Get-Date -Format "yyyyMMdd-HHmmss"
    $backup = "$Path.agent-engineering-backup-$stamp"
    Copy-Item $Path $backup -Force
    Write-Host "Backup: $backup"
    return $backup
}
function Backup-DirectoryIfExists([string]$Path) {
    if (-not (Test-Path $Path)) { return $null }
    if ($WhatIfPreference) {
        Write-Host "WhatIf: would backup directory $Path"
        return $null
    }
    $stamp = Get-Date -Format "yyyyMMdd-HHmmss"
    $parent = Split-Path -Parent $Path
    $leaf = Split-Path -Leaf $Path
    $backup = Join-Path $parent "$leaf.agent-engineering-backup-$stamp"
    Copy-Item $Path $backup -Recurse -Force
    Write-Host "Backup: $backup"
    return $backup
}
function Set-MarkerBlock {
    param([string]$Path, [string]$Block)

    if ($WhatIfPreference) {
        Write-Host "WhatIf: would update Toolkit marker block in $Path"
        return
    }

    $begin = "<!-- AGENT-ENGINEERING-TOOLKIT:BEGIN -->"
    $end = "<!-- AGENT-ENGINEERING-TOOLKIT:END -->"
    New-Item -ItemType Directory -Force -Path (Split-Path -Parent $Path) | Out-Null
    $existing = if (Test-Path $Path) { Get-Content $Path -Raw -Encoding UTF8 } else { "" }
    $pattern = [regex]::Escape($begin) + "(?s).*?" + [regex]::Escape($end)

    if ([regex]::IsMatch($existing, $pattern)) {
        $newText = [regex]::Replace($existing, $pattern, [System.Text.RegularExpressions.MatchEvaluator]{ param($m) $Block })
    } else {
        $prefix = if ([string]::IsNullOrWhiteSpace($existing)) { "" } else { $existing.TrimEnd() + "`r`n`r`n" }
        $newText = $prefix + $Block + "`r`n"
    }
    Set-Content -Path $Path -Value $newText -Encoding UTF8
}
function Copy-DirectoryFresh {
    param([string]$Source, [string]$Destination)
    if ($WhatIfPreference) {
        Write-Host "WhatIf: would replace $Destination from $Source"
        return
    }
    if (Test-Path $Destination) { Remove-Item $Destination -Recurse -Force }
    New-Item -ItemType Directory -Force -Path (Split-Path -Parent $Destination) | Out-Null
    Copy-Item $Source $Destination -Recurse -Force
}

if ($env:OS -ne "Windows_NT") {
    throw "This installer targets native Windows user configuration. Do not run it from WSL/Linux."
}

Write-Host "Agent Engineering Toolkit installer"
Write-Host "Source: $ToolkitSourceRoot"
Write-Host "InstallRoot: $InstallRoot"

if (-not (Test-Path $ToolkitSourceRoot)) { throw "Toolkit source root not found: $ToolkitSourceRoot" }

$sourceVersionFile = Join-Path $ToolkitSourceRoot "VERSION"
if (-not (Test-Path $sourceVersionFile)) { throw "VERSION missing from package." }

$sourceVersion = (Get-Content $sourceVersionFile -Raw -Encoding UTF8).Trim()
$existingVersionFile = Join-Path $InstallRoot "VERSION"
$installExists = Test-Path $InstallRoot
$existingVersion = if (Test-Path $existingVersionFile) { (Get-Content $existingVersionFile -Raw -Encoding UTF8).Trim() } else { $null }

if ($installExists -and -not $existingVersion -and -not $UpgradeCanonical) {
    throw "InstallRoot exists but has no trusted VERSION file. Treat it as a partial/unknown installation. Inspect it, then rerun with -UpgradeCanonical if replacement is intended."
}

if ($installExists -and -not $UpgradeCanonical -and $existingVersion -and $existingVersion -ne $sourceVersion) {
    throw "Installed Toolkit version '$existingVersion' differs from package '$sourceVersion'. Rerun with -UpgradeCanonical after reviewing the migration guide."
}

$usePackageCanonical = (-not $installExists) -or $UpgradeCanonical
if ($usePackageCanonical) {
    if ($installExists -and $UpgradeCanonical) { Backup-DirectoryIfExists $InstallRoot | Out-Null }

    if ($PSCmdlet.ShouldProcess($InstallRoot, "Install/upgrade canonical Toolkit")) {
        if (-not $WhatIfPreference) {
            New-Item -ItemType Directory -Force -Path $InstallRoot | Out-Null
            Copy-Item (Join-Path $ToolkitSourceRoot "VERSION") (Join-Path $InstallRoot "VERSION") -Force
            Copy-Item (Join-Path $ToolkitSourceRoot "01_CANONICAL\01_AGENT_ENGINEERING_INVARIANTS.md") `
                (Join-Path $InstallRoot "01_AGENT_ENGINEERING_INVARIANTS.md") -Force
            Copy-DirectoryFresh (Join-Path $ToolkitSourceRoot "01_CANONICAL") (Join-Path $InstallRoot "canonical")
            Copy-DirectoryFresh (Join-Path $ToolkitSourceRoot "02_SKILLS") (Join-Path $InstallRoot "skills")
            Copy-DirectoryFresh (Join-Path $ToolkitSourceRoot "03_ADAPTERS\PROJECT_TEMPLATES") (Join-Path $InstallRoot "project-templates")
            Copy-Item (Join-Path $ToolkitSourceRoot "03_ADAPTERS\CODEX_COMPATIBILITY_TEMPLATE.md") `
                (Join-Path $InstallRoot "project-templates\CODEX_COMPATIBILITY_TEMPLATE.md") -Force
            $scriptsDest = Join-Path $InstallRoot "scripts"
            if (Test-Path $scriptsDest) { Remove-Item $scriptsDest -Recurse -Force }
            New-Item -ItemType Directory -Force -Path $scriptsDest | Out-Null
            Copy-Item (Join-Path $ToolkitSourceRoot "04_SCRIPTS\*.ps1") $scriptsDest -Force
        }
    }
} else {
    Write-Host "Existing same-version canonical installation detected. Canonical files are preserved."
}

# Resolve canonical content/source for both real install and -WhatIf fresh install.
$canonical = if ($usePackageCanonical -and $WhatIfPreference) {
    Join-Path $ToolkitSourceRoot "01_CANONICAL\01_AGENT_ENGINEERING_INVARIANTS.md"
} else {
    Join-Path $InstallRoot "01_AGENT_ENGINEERING_INVARIANTS.md"
}
$skillSource = if ($usePackageCanonical -and $WhatIfPreference) {
    Join-Path $ToolkitSourceRoot "02_SKILLS"
} else {
    Join-Path $InstallRoot "skills"
}
$syncScript = if ($usePackageCanonical -and $WhatIfPreference) {
    Join-Path $ToolkitSourceRoot "04_SCRIPTS\sync-agent-engineering.ps1"
} else {
    Join-Path $InstallRoot "scripts\sync-agent-engineering.ps1"
}

if (-not (Test-Path $canonical)) { throw "Canonical invariants missing: $canonical" }
if (-not (Test-Path $syncScript)) { throw "Sync script missing: $syncScript" }

$machineProfile = Join-Path $InstallRoot "MACHINE_EXECUTION_PROFILE.md"
$machineTemplate = if ($usePackageCanonical -and $WhatIfPreference) {
    Join-Path $ToolkitSourceRoot "01_CANONICAL\MACHINE_EXECUTION_PROFILE_TEMPLATE.md"
} else {
    Join-Path $InstallRoot "canonical\MACHINE_EXECUTION_PROFILE_TEMPLATE.md"
}
$refreshMachineScript = if ($usePackageCanonical -and $WhatIfPreference) {
    Join-Path $ToolkitSourceRoot "04_SCRIPTS\refresh-machine-profile.ps1"
} else {
    Join-Path $InstallRoot "scripts\refresh-machine-profile.ps1"
}

if (-not (Test-Path $machineProfile)) {
    if (-not (Test-Path $machineTemplate)) { throw "Machine profile template missing: $machineTemplate" }
    if ($PSCmdlet.ShouldProcess($machineProfile, "Create machine execution profile")) {
        if (-not $WhatIfPreference) { Copy-Item $machineTemplate $machineProfile -Force }
    }
}

if (-not $WhatIfPreference) {
    if (-not (Test-Path $refreshMachineScript)) { throw "Machine profile refresh script missing: $refreshMachineScript" }
    & $refreshMachineScript -InstallRoot $InstallRoot
}


# Sync Skills before touching global instruction adapters. Sync performs a conflict prescan.
& $syncScript -InstallRoot $InstallRoot -SkillSourceRoot $skillSource `
    -ForceManagedSkillOverwrite:$ForceManagedSkillOverwrite -WhatIf:$WhatIfPreference

$codexHome = Get-CodexHome
$claudeHome = Get-ClaudeHome
$geminiHome = Join-Path $HOME ".gemini"
$codexAgents = Join-Path $codexHome "AGENTS.md"
$codexOverride = Join-Path $codexHome "AGENTS.override.md"
$claudeMd = Join-Path $claudeHome "CLAUDE.md"
$geminiMd = Join-Path $geminiHome "GEMINI.md"

$canonicalPath = $canonical.Replace("\","/")
$canonicalText = Get-Content $canonical -Raw -Encoding UTF8

$codexBlock = @(
    "<!-- AGENT-ENGINEERING-TOOLKIT:BEGIN -->",
    "# Agent Engineering Global Rules",
    "",
    "Toolkit-Version: $sourceVersion",
    "",
    $canonicalText.Trim(),
    "",
    "Machine Execution Profile: $installedMachineProfilePath",
    "Before terminal/filesystem/process/network/GPU/long-runtime work, read it and perform Stage capability preflight.",
    "Machine availability is not proof of current Agent access.",
    "",
    "Reusable skills:",
    "- contract-impact-check",
    "- stage-execution",
    "- independent-review",
    "<!-- AGENT-ENGINEERING-TOOLKIT:END -->"
) -join "`r`n"

# When installing for real, imports point to installed canonical path.
$installedCanonicalPath = (Join-Path $InstallRoot "01_AGENT_ENGINEERING_INVARIANTS.md").Replace("\","/")
$installedMachineProfilePath = (Join-Path $InstallRoot "MACHINE_EXECUTION_PROFILE.md").Replace("\","/")
$claudeBlock = @(
    "<!-- AGENT-ENGINEERING-TOOLKIT:BEGIN -->",
    "@$installedCanonicalPath",
    "@$installedMachineProfilePath",
    "",
    "Toolkit-Version: $sourceVersion",
    "",
    "Reusable skills:",
    "- /contract-impact-check",
    "- /stage-execution",
    "- /independent-review",
    "<!-- AGENT-ENGINEERING-TOOLKIT:END -->"
) -join "`r`n"
$geminiBlock = @(
    "<!-- AGENT-ENGINEERING-TOOLKIT:BEGIN -->",
    "@$installedCanonicalPath",
    "@$installedMachineProfilePath",
    "",
    "Toolkit-Version: $sourceVersion",
    "",
    "Use contract-impact-check for semantic/contract changes.",
    "Use stage-execution for stage-level engineering work.",
    "Use independent-review for independent review.",
    "<!-- AGENT-ENGINEERING-TOOLKIT:END -->"
) -join "`r`n"

foreach ($f in @($codexAgents,$claudeMd,$geminiMd)) { Backup-FileIfExists $f | Out-Null }

Set-MarkerBlock $codexAgents $codexBlock
Set-MarkerBlock $claudeMd $claudeBlock
Set-MarkerBlock $geminiMd $geminiBlock

if (Test-Path $codexOverride) {
    $overrideText = Get-Content $codexOverride -Raw -Encoding UTF8
    if (-not [string]::IsNullOrWhiteSpace($overrideText)) {
        if ($IntegrateCodexOverride) {
            Backup-FileIfExists $codexOverride | Out-Null
            Set-MarkerBlock $codexOverride $codexBlock
            Write-Host "Toolkit block integrated into active Codex AGENTS.override.md."
        } else {
            Write-Warning "Non-empty Codex AGENTS.override.md is active and can suppress global AGENTS.md. Inspect it and rerun with -IntegrateCodexOverride only if compatible."
        }
    }
}

Write-Host ""
if ($WhatIfPreference) {
    Write-Host "Dry-run complete. No Toolkit configuration or backup should have been created/changed."
} else {
    Write-Host "Install/update complete."
    Write-Host "Next: powershell -ExecutionPolicy Bypass -File `"$InstallRoot\scripts\verify-agent-engineering.ps1`""
}
