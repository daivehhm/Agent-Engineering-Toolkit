[CmdletBinding()]
param(
    [string]$InstallRoot = (Join-Path $HOME ".agent-engineering")
)

$ErrorActionPreference = "Stop"
$fail = 0
$warn = 0

function Pass([string]$Message) { Write-Host "[PASS] $Message" }
function Fail([string]$Message) { Write-Host "[FAIL] $Message"; $script:fail++ }
function Warn([string]$Message) { Write-Host "[WARN] $Message"; $script:warn++ }
function Get-CodexHome { if ($env:CODEX_HOME) { return $env:CODEX_HOME }; return (Join-Path $HOME ".codex") }
function Get-ClaudeHome { if ($env:CLAUDE_CONFIG_DIR) { return $env:CLAUDE_CONFIG_DIR }; return (Join-Path $HOME ".claude") }

function Compare-Tree([string]$Source, [string]$Target) {
    if (-not (Test-Path $Source) -or -not (Test-Path $Target)) { return $false }
    $srcFiles = Get-ChildItem $Source -Recurse -File | ForEach-Object { $_.FullName.Substring($Source.Length).TrimStart("\") } | Sort-Object
    $dstFiles = Get-ChildItem $Target -Recurse -File | ForEach-Object { $_.FullName.Substring($Target.Length).TrimStart("\") } | Sort-Object
    if (($srcFiles -join "`n") -ne ($dstFiles -join "`n")) { return $false }
    foreach ($rel in $srcFiles) {
        $a = Get-Content (Join-Path $Source $rel) -Raw -Encoding UTF8
        $b = Get-Content (Join-Path $Target $rel) -Raw -Encoding UTF8
        if ($a -ne $b) { return $false }
    }
    return $true
}
function Get-AntigravityCliSkillContent([string]$SourceDir) {
    $main = Get-Content (Join-Path $SourceDir "SKILL.md") -Raw -Encoding UTF8
    $main = [regex]::Replace($main, '(?ms)\r?\nRead:\s*\r?\n\s*`references/[^`]+`\s*', "`r`nThe detailed reference playbook is embedded below.`r`n")
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

if ($env:OS -ne "Windows_NT") { Fail "Verification is not running in native Windows PowerShell." }

$canonical = Join-Path $InstallRoot "01_AGENT_ENGINEERING_INVARIANTS.md"
$versionFile = Join-Path $InstallRoot "VERSION"
if (Test-Path $canonical) { Pass "Canonical invariants exist" } else { Fail "Missing canonical invariants: $canonical" }
$installedVersion = if (Test-Path $versionFile) { (Get-Content $versionFile -Raw -Encoding UTF8).Trim() } else { $null }
if ($installedVersion) { Pass "Installed Toolkit version: $installedVersion" } else { Fail "Installed VERSION file missing" }

$codexHome = Get-CodexHome
$claudeHome = Get-ClaudeHome
$geminiHome = Join-Path $HOME ".gemini"
$codexAgents = Join-Path $codexHome "AGENTS.md"
$codexOverride = Join-Path $codexHome "AGENTS.override.md"
$claudeMd = Join-Path $claudeHome "CLAUDE.md"
$geminiMd = Join-Path $geminiHome "GEMINI.md"

foreach ($f in @($codexAgents,$claudeMd,$geminiMd)) {
    if (Test-Path $f) {
        $txt = Get-Content $f -Raw -Encoding UTF8
        if ($txt.Contains("AGENT-ENGINEERING-TOOLKIT:BEGIN")) { Pass "Toolkit marker exists: $f" } else { Fail "Toolkit marker missing: $f" }
    } else { Fail "Global adapter missing: $f" }
}

$activeCodexFile = $codexAgents
if (Test-Path $codexOverride) {
    $ot = Get-Content $codexOverride -Raw -Encoding UTF8
    if (-not [string]::IsNullOrWhiteSpace($ot)) {
        $activeCodexFile = $codexOverride
        if ($ot.Contains("AGENT-ENGINEERING-TOOLKIT:BEGIN")) {
            Pass "Active Codex AGENTS.override.md contains Toolkit block"
        } else {
            Fail "Active Codex AGENTS.override.md lacks Toolkit block; AGENTS.md is suppressed at global scope."
        }
    }
}
if ((Test-Path $activeCodexFile) -and (Test-Path $canonical)) {
    $activeText = Get-Content $activeCodexFile -Raw -Encoding UTF8
    $canonicalText = (Get-Content $canonical -Raw -Encoding UTF8).Trim()
    if ($activeText.Contains($canonicalText)) { Pass "Active Codex file contains current canonical invariant text" } else { Fail "Active Codex Toolkit block is stale/mismatched" }
    if ($installedVersion -and $activeText.Contains("Toolkit-Version: $installedVersion")) { Pass "Active Codex adapter version matches" } else { Fail "Active Codex adapter version stale/missing" }
}

$canonForward = $canonical.Replace("\","/")
if (Test-Path $claudeMd) {
    $ct = Get-Content $claudeMd -Raw -Encoding UTF8
    if ($ct.Contains("@$canonForward")) { Pass "Claude imports installed canonical invariants" } else { Fail "Claude canonical import missing/mismatched" }
    if ($installedVersion -and $ct.Contains("Toolkit-Version: $installedVersion")) { Pass "Claude adapter version matches" } else { Fail "Claude adapter version stale/missing" }
}
if (Test-Path $geminiMd) {
    $gt = Get-Content $geminiMd -Raw -Encoding UTF8
    if ($gt.Contains("@$canonForward")) { Pass "Antigravity global rule imports installed canonical invariants" } else { Fail "Antigravity canonical import missing/mismatched" }
    if ($installedVersion -and $gt.Contains("Toolkit-Version: $installedVersion")) { Pass "Antigravity adapter version matches" } else { Fail "Antigravity adapter version stale/missing" }
    if ($gt.Length -le 12000) { Pass "Antigravity GEMINI.md within 12,000-character limit" } else { Fail "Antigravity GEMINI.md exceeds 12,000 characters" }
}

$directoryTargets = [ordered]@{
    "Codex" = (Join-Path $HOME ".agents\skills")
    "Claude" = (Join-Path $claudeHome "skills")
    "Antigravity IDE" = (Join-Path $geminiHome "config\skills")
}
$skills = @("contract-impact-check","stage-execution","independent-review")

foreach ($entry in $directoryTargets.GetEnumerator()) {
    foreach ($skill in $skills) {
        $source = Join-Path $InstallRoot "skills\$skill"
        $target = Join-Path $entry.Value $skill
        if (-not (Test-Path $target)) { Fail "$($entry.Key) missing skill: $skill"; continue }
        if (-not (Test-Path (Join-Path $target ".agent-engineering-managed"))) { Fail "$($entry.Key) skill not Toolkit-managed: $skill"; continue }
        if (Compare-Tree $source $target) { Pass "$($entry.Key) skill matches canonical: $skill" } else { Fail "$($entry.Key) skill drift: $skill" }
    }
}

$cliRoot = Join-Path $geminiHome "antigravity-cli\skills"
foreach ($skill in $skills) {
    $sourceDir = Join-Path $InstallRoot "skills\$skill"
    $flat = Join-Path $cliRoot "$skill.md"
    $sidecar = Join-Path $cliRoot "$skill.agent-engineering-managed"
    $legacyDir = Join-Path $cliRoot $skill

    if (Test-Path $legacyDir) { Fail "Antigravity CLI legacy directory-format skill still exists: $legacyDir" }
    if (-not (Test-Path $flat)) { Fail "Antigravity CLI flat skill missing: $flat"; continue }
    if (-not (Test-Path $sidecar)) { Fail "Antigravity CLI managed sidecar missing: $sidecar"; continue }

    $expected = Get-AntigravityCliSkillContent $sourceDir
    $actual = Get-Content $flat -Raw -Encoding UTF8
    if ($actual -eq $expected) { Pass "Antigravity CLI flat skill matches canonical: $skill" } else { Fail "Antigravity CLI flat skill drift: $skill" }
}

foreach ($name in @("codex","claude","agy")) {
    if (Get-Command $name -ErrorAction SilentlyContinue) {
        Pass "$name executable is available for runtime smoke test"
    } else {
        Warn "$name executable not found; target cannot be runtime-loading verified in this environment."
    }
}

Write-Host ""
if ($fail -gt 0) {
    Write-Host "Verification: FAIL ($fail issue(s), $warn warning(s))"
    exit 1
}
if ($warn -gt 0) {
    Write-Host "Verification: PASS_WITH_WARNINGS ($warn warning(s))"
    exit 0
}
Write-Host "Verification: PASS"
exit 0
