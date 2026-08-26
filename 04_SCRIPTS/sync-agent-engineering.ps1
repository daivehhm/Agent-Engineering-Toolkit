[CmdletBinding(SupportsShouldProcess=$true)]
param(
    [string]$InstallRoot = (Join-Path $HOME ".agent-engineering"),
    [string]$SkillSourceRoot = "",
    [switch]$ForceManagedSkillOverwrite
)

$ErrorActionPreference = "Stop"

function Get-ClaudeHome {
    if ($env:CLAUDE_CONFIG_DIR) { return $env:CLAUDE_CONFIG_DIR }
    return (Join-Path $HOME ".claude")
}
function Backup-Directory([string]$Path) {
    if ($WhatIfPreference) {
        Write-Host "WhatIf: would backup directory $Path"
        return $null
    }
    $stamp = Get-Date -Format "yyyyMMdd-HHmmss"
    $parent = Split-Path -Parent $Path
    $leaf = Split-Path -Leaf $Path
    $backup = Join-Path $parent "$leaf.agent-engineering-backup-$stamp"
    Copy-Item $Path $backup -Recurse -Force
    return $backup
}
function Backup-File([string]$Path) {
    if ($WhatIfPreference) {
        Write-Host "WhatIf: would backup file $Path"
        return $null
    }
    $stamp = Get-Date -Format "yyyyMMdd-HHmmss"
    $backup = "$Path.agent-engineering-backup-$stamp"
    Copy-Item $Path $backup -Force
    return $backup
}
function Test-LegacyToolkitSkill([string]$Path, [string]$SkillName) {
    $skillFile = Join-Path $Path "SKILL.md"
    if (-not (Test-Path $skillFile)) { return $false }
    $txt = Get-Content $skillFile -Raw -Encoding UTF8
    switch ($SkillName) {
        "contract-impact-check" { return $txt.Contains("Contract Impact Check") -and $txt.Contains("standalone phase") }
        "stage-execution" { return $txt.Contains("Stage Execution") -and $txt.Contains("IMPLEMENTATION_COMPLETE_FOR_INDEPENDENT_REVIEW") }
        "independent-review" { return $txt.Contains("Independent Review") -and $txt.Contains("Canonical Evidence") }
        default { return $false }
    }
}
function Get-AntigravityCliSkillContent([string]$SourceDir) {
    $mainFile = Join-Path $SourceDir "SKILL.md"
    $main = Get-Content $mainFile -Raw -Encoding UTF8
    $main = [regex]::Replace(
        $main,
        '(?ms)\r?\nRead:\s*\r?\n\s*`references/[^`]+`\s*',
        "`r`nThe detailed reference playbook is embedded below.`r`n"
    )

    $parts = New-Object System.Collections.Generic.List[string]
    $parts.Add($main.Trim())

    $refsDir = Join-Path $SourceDir "references"
    if (Test-Path $refsDir) {
        foreach ($ref in (Get-ChildItem $refsDir -File -Filter "*.md" | Sort-Object Name)) {
            $parts.Add("`r`n---`r`n## Embedded Reference: $($ref.Name)`r`n")
            $parts.Add((Get-Content $ref.FullName -Raw -Encoding UTF8).Trim())
        }
    }
    return ($parts -join "`r`n") + "`r`n"
}

if ([string]::IsNullOrWhiteSpace($SkillSourceRoot)) {
    $SkillSourceRoot = Join-Path $InstallRoot "skills"
}
if (-not (Test-Path $SkillSourceRoot)) {
    throw "Canonical skill source missing: $SkillSourceRoot"
}

$claudeHome = Get-ClaudeHome
$geminiHome = Join-Path $HOME ".gemini"

$directoryTargets = [ordered]@{
    "Codex" = (Join-Path $HOME ".agents\skills")
    "Claude" = (Join-Path $claudeHome "skills")
    "Antigravity IDE" = (Join-Path $geminiHome "config\skills")
}
$cliRoot = Join-Path $geminiHome "antigravity-cli\skills"
$skills = @("contract-impact-check","stage-execution","independent-review")

# Pass 1: fail closed on every unmanaged conflict BEFORE modifying any target.
$conflicts = New-Object System.Collections.Generic.List[string]
foreach ($entry in $directoryTargets.GetEnumerator()) {
    foreach ($skill in $skills) {
        $dst = Join-Path $entry.Value $skill
        if (-not (Test-Path $dst)) { continue }
        $marker = Join-Path $dst ".agent-engineering-managed"
        if ((Test-Path $marker) -or (Test-LegacyToolkitSkill $dst $skill) -or $ForceManagedSkillOverwrite) { continue }
        $conflicts.Add("$($entry.Key): $dst")
    }
}
foreach ($skill in $skills) {
    $flat = Join-Path $cliRoot "$skill.md"
    $sidecar = Join-Path $cliRoot "$skill.agent-engineering-managed"
    $legacyDir = Join-Path $cliRoot $skill

    if ((Test-Path $flat) -and -not (Test-Path $sidecar) -and -not $ForceManagedSkillOverwrite) {
        $conflicts.Add("Antigravity CLI flat skill: $flat")
    }
    if (Test-Path $legacyDir) {
        $legacyManaged = Test-Path (Join-Path $legacyDir ".agent-engineering-managed")
        $legacyRecognized = Test-LegacyToolkitSkill $legacyDir $skill
        if (-not $legacyManaged -and -not $legacyRecognized -and -not $ForceManagedSkillOverwrite) {
            $conflicts.Add("Antigravity CLI legacy directory: $legacyDir")
        }
    }
}
if ($conflicts.Count -gt 0) {
    throw "Unmanaged skill conflict(s) found before sync. No skill targets were modified:`n - " + ($conflicts -join "`n - ")
}

# Pass 2: directory-format targets (Codex, Claude, Antigravity IDE).
foreach ($entry in $directoryTargets.GetEnumerator()) {
    $targetRoot = $entry.Value
    if (-not $WhatIfPreference) { New-Item -ItemType Directory -Force -Path $targetRoot | Out-Null }

    foreach ($skill in $skills) {
        $src = Join-Path $SkillSourceRoot $skill
        $dst = Join-Path $targetRoot $skill
        $srcMarker = Join-Path $src ".agent-engineering-managed"

        if (-not (Test-Path $src)) { throw "Skill missing: $src" }
        if (-not (Test-Path $srcMarker)) { throw "Canonical managed marker missing: $srcMarker" }

        if (Test-Path $dst) {
            $dstMarker = Join-Path $dst ".agent-engineering-managed"
            if (-not (Test-Path $dstMarker)) {
                $backup = Backup-Directory $dst
                if ($backup) { Write-Host "Backup existing skill before migration/force: $backup" }
            }

            if ($PSCmdlet.ShouldProcess($dst, "Replace Toolkit skill $skill for $($entry.Key)")) {
                Remove-Item $dst -Recurse -Force
            }
        }

        if ($PSCmdlet.ShouldProcess($dst, "Install directory-format skill $skill for $($entry.Key)")) {
            Copy-Item $src $dst -Recurse -Force
        }
    }
}

# Pass 3: Antigravity CLI requires flat Markdown skills, not <skill>/SKILL.md folders.
if (-not $WhatIfPreference) { New-Item -ItemType Directory -Force -Path $cliRoot | Out-Null }

foreach ($skill in $skills) {
    $src = Join-Path $SkillSourceRoot $skill
    $flat = Join-Path $cliRoot "$skill.md"
    $sidecar = Join-Path $cliRoot "$skill.agent-engineering-managed"
    $legacyDir = Join-Path $cliRoot $skill
    $content = Get-AntigravityCliSkillContent $src

    if (Test-Path $legacyDir) {
        $backup = Backup-Directory $legacyDir
        if ($backup) { Write-Host "Backup legacy Antigravity CLI directory skill: $backup" }
        if ($PSCmdlet.ShouldProcess($legacyDir, "Remove legacy CLI directory-format skill")) {
            Remove-Item $legacyDir -Recurse -Force
        }
    }

    if (Test-Path $flat) {
        $backup = Backup-File $flat
        if ($backup) { Write-Host "Backup existing CLI flat skill: $backup" }
    }

    if ($PSCmdlet.ShouldProcess($flat, "Install Antigravity CLI flat skill $skill")) {
        Set-Content -Path $flat -Value $content -Encoding UTF8 -NoNewline
        Set-Content -Path $sidecar -Value "Agent-Engineering-Toolkit managed skill: $skill" -Encoding ASCII
    }
}

Write-Host "Skill sync complete."
