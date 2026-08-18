[CmdletBinding()]
param(
    [string]$ToolkitSourceRoot = (Split-Path -Parent $PSScriptRoot),
    [string]$ReportPath = (Join-Path (Get-Location) "agent-engineering-preflight.md"),
    [switch]$TestWriteAccess
)

$ErrorActionPreference = "Stop"
$issues = New-Object System.Collections.Generic.List[string]
$reviews = New-Object System.Collections.Generic.List[string]
$warnings = New-Object System.Collections.Generic.List[string]
$lines = New-Object System.Collections.Generic.List[string]

function Get-CodexHome {
    if ($env:CODEX_HOME) { return $env:CODEX_HOME }
    return (Join-Path $HOME ".codex")
}
function Get-ClaudeHome {
    if ($env:CLAUDE_CONFIG_DIR) { return $env:CLAUDE_CONFIG_DIR }
    return (Join-Path $HOME ".claude")
}
function Status([string]$Name, [string]$Value) {
    $script:lines.Add("| $Name | $Value |")
}
function Test-NonEmptyFile([string]$Path) {
    if (-not (Test-Path $Path -PathType Leaf)) { return $false }
    $txt = Get-Content $Path -Raw -Encoding UTF8
    return -not [string]::IsNullOrWhiteSpace($txt)
}
function Test-Write([string]$TargetPath) {
    $probeDir = $TargetPath
    while ($probeDir -and -not (Test-Path $probeDir -PathType Container)) {
        $probeDir = Split-Path -Parent $probeDir
    }
    if (-not $probeDir) { return $false }
    $tmp = Join-Path $probeDir (".agent-engineering-write-test-" + [guid]::NewGuid().ToString("N") + ".tmp")
    try {
        Set-Content -Path $tmp -Value "probe" -Encoding ASCII
        Remove-Item $tmp -Force
        return $true
    } catch {
        if (Test-Path $tmp) { Remove-Item $tmp -Force -ErrorAction SilentlyContinue }
        return $false
    }
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

function Get-CommandPath([string]$Name) {
    $cmd = Get-Command $Name -ErrorAction SilentlyContinue
    if ($cmd) { return $cmd.Source }
    return "<not-found>"
}

$isWindows = ($env:OS -eq "Windows_NT")
if (-not $isWindows) {
    $issues.Add("Not running in native Windows PowerShell. Do not install Windows user-profile configuration from WSL/Linux.")
}

$codexHome = Get-CodexHome
$claudeHome = Get-ClaudeHome
$geminiHome = Join-Path $HOME ".gemini"

$codexAgents = Join-Path $codexHome "AGENTS.md"
$codexOverride = Join-Path $codexHome "AGENTS.override.md"
$claudeMd = Join-Path $claudeHome "CLAUDE.md"
$geminiMd = Join-Path $geminiHome "GEMINI.md"

$lines.Add("# Agent Engineering Windows Preflight")
$lines.Add("")
$lines.Add("Generated: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss K')")
$lines.Add("")
$lines.Add("## Environment")
$lines.Add("")
$lines.Add("| Item | Value |")
$lines.Add("|---|---|")
Status "Native Windows" $isWindows
Status "PowerShell" $PSVersionTable.PSVersion.ToString()
Status "HOME" $HOME
Status "USERPROFILE" $env:USERPROFILE
Status "CODEX_HOME effective" $codexHome
Status "CLAUDE_CONFIG_DIR effective" $claudeHome
Status "Codex executable" (Get-CommandPath "codex")
Status "Claude executable" (Get-CommandPath "claude")
Status "Antigravity CLI executable (agy)" (Get-CommandPath "agy")

$lines.Add("")
$lines.Add("## Global adapter state")
$lines.Add("")
$lines.Add("| File | Exists | Toolkit marker |")
$lines.Add("|---|---:|---:|")
foreach ($f in @($codexAgents,$codexOverride,$claudeMd,$geminiMd)) {
    $exists = Test-Path $f
    $marker = $false
    if ($exists) {
        $txt = Get-Content $f -Raw -Encoding UTF8
        $marker = $txt.Contains("AGENT-ENGINEERING-TOOLKIT:BEGIN")
    }
    $lines.Add("| $f | $exists | $marker |")
}

if (Test-NonEmptyFile $codexOverride) {
    $txt = Get-Content $codexOverride -Raw -Encoding UTF8
    if (-not $txt.Contains("AGENT-ENGINEERING-TOOLKIT:BEGIN")) {
        $reviews.Add("Active non-empty Codex AGENTS.override.md lacks Toolkit block. Inspect for conflicts before using -IntegrateCodexOverride.")
    }
}

$directoryTargets = [ordered]@{
    "Codex" = (Join-Path $HOME ".agents\skills")
    "Claude" = (Join-Path $claudeHome "skills")
    "Antigravity IDE" = (Join-Path $geminiHome "config\skills")
}
$skills = @("contract-impact-check","stage-execution","independent-review")

$lines.Add("")
$lines.Add("## Skill conflict scan")
$lines.Add("")
$lines.Add("| Target | Skill | Existing | Managed | Status |")
$lines.Add("|---|---|---:|---:|---|")

foreach ($entry in $directoryTargets.GetEnumerator()) {
    foreach ($skill in $skills) {
        $dst = Join-Path $entry.Value $skill
        $exists = Test-Path $dst
        $managed = Test-Path (Join-Path $dst ".agent-engineering-managed")
        $status = "clear"
        if ($exists -and -not $managed) {
            if (Test-LegacyToolkitSkill $dst $skill) {
                $status = "recognized-legacy-Toolkit-migration"
            } else {
                $status = "UNMANAGED_CONFLICT"
                $reviews.Add("$($entry.Key) unmanaged same-name skill: $dst")
            }
        } elseif ($exists -and $managed) {
            $status = "Toolkit-managed"
        }
        $lines.Add("| $($entry.Key) | $skill | $exists | $managed | $status |")
    }
}

$cliRoot = Join-Path $geminiHome "antigravity-cli\skills"
foreach ($skill in $skills) {
    $flat = Join-Path $cliRoot "$skill.md"
    $sidecar = Join-Path $cliRoot "$skill.agent-engineering-managed"
    $legacyDir = Join-Path $cliRoot $skill
    $exists = Test-Path $flat
    $managed = Test-Path $sidecar
    $status = "clear"

    if ($exists -and -not $managed) {
        $status = "UNMANAGED_FLAT_CONFLICT"
        $reviews.Add("Antigravity CLI unmanaged same-name flat skill: $flat")
    } elseif ($exists -and $managed) {
        $status = "Toolkit-managed-flat"
    } elseif (Test-Path $legacyDir) {
        if (Test-Path (Join-Path $legacyDir ".agent-engineering-managed")) {
            $status = "Toolkit-v1.1-directory-migration"
        } else {
            $status = "UNMANAGED_LEGACY_DIRECTORY_CONFLICT"
            $reviews.Add("Antigravity CLI same-name directory exists and is not Toolkit-managed: $legacyDir")
        }
    }

    $lines.Add("| Antigravity CLI | $skill | $exists | $managed | $status |")
}

if ($TestWriteAccess) {
    $lines.Add("")
    $lines.Add("## Write-access probes")
    $lines.Add("")
    $lines.Add("| Target | Writable |")
    $lines.Add("|---|---:|")
    $writeTargets = [ordered]@{
        "Codex home" = $codexHome
        "Codex user skills parent" = (Join-Path $HOME ".agents")
        "Claude home" = $claudeHome
        "Gemini home" = $geminiHome
    }
    foreach ($entry in $writeTargets.GetEnumerator()) {
        $ok = Test-Write $entry.Value
        $lines.Add("| $($entry.Key) | $ok |")
        if (-not $ok) {
            $issues.Add("Write access unavailable for $($entry.Key): $($entry.Value)")
        }
    }
}

foreach ($name in @("codex","claude","agy")) {
    if ((Get-CommandPath $name) -eq "<not-found>") {
        $warnings.Add("$name executable not found. Files can be configured, but runtime loading for this target cannot be verified now.")
    }
}

$lines.Add("")
$lines.Add("## Findings")
$lines.Add("")
if ($issues.Count -eq 0) {
    $lines.Add("- BLOCKERS: none")
} else {
    foreach ($i in $issues) { $lines.Add("- BLOCKER: $i") }
}
if ($reviews.Count -eq 0) {
    $lines.Add("- REVIEW_REQUIRED: none")
} else {
    foreach ($i in $reviews) { $lines.Add("- REVIEW_REQUIRED: $i") }
}
if ($warnings.Count -eq 0) {
    $lines.Add("- WARNINGS: none")
} else {
    foreach ($i in $warnings) { $lines.Add("- WARNING: $i") }
}

$final = if ($issues.Count -gt 0) {
    "BLOCKED"
} elseif ($reviews.Count -gt 0) {
    "REVIEW_REQUIRED"
} elseif ($warnings.Count -gt 0) {
    "READY_WITH_WARNINGS"
} else {
    "READY"
}
$lines.Add("")
$lines.Add("## Preflight Result")
$lines.Add("")
$lines.Add("Result: $final")

$reportDir = Split-Path -Parent $ReportPath
if ($reportDir -and -not (Test-Path $reportDir)) {
    New-Item -ItemType Directory -Force -Path $reportDir | Out-Null
}
Set-Content -Path $ReportPath -Value ($lines -join "`r`n") -Encoding UTF8

Write-Host "Preflight report: $ReportPath"
Write-Host "Preflight Result: $final"

if ($issues.Count -gt 0) { exit 2 }
exit 0
