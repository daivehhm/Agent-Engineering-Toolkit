[CmdletBinding()]
param([string]$InstallRoot = (Join-Path $HOME '.agent-engineering'))

$ErrorActionPreference = 'Stop'
$fail = 0
$warn = 0
function Pass([string]$m) { Write-Host "[PASS] $m" }
function Fail([string]$m) { Write-Host "[FAIL] $m"; $script:fail++ }
function Warn([string]$m) { Write-Host "[WARN] $m"; $script:warn++ }
function Get-CodexHome { if ($env:CODEX_HOME) { return $env:CODEX_HOME }; return (Join-Path $HOME '.codex') }
function Get-ClaudeHome { if ($env:CLAUDE_CONFIG_DIR) { return $env:CLAUDE_CONFIG_DIR }; return (Join-Path $HOME '.claude') }
function Get-MarkerBlock([string]$Text) {
    $pattern = [regex]::Escape('<!-- AGENT-ENGINEERING-TOOLKIT:BEGIN -->') + '(?s).*?' + [regex]::Escape('<!-- AGENT-ENGINEERING-TOOLKIT:END -->')
    $m = [regex]::Match($Text, $pattern)
    if ($m.Success) { return $m.Value.Trim() }
    return $null
}
function Compare-Tree([string]$Source, [string]$Target) {
    if (-not (Test-Path $Source) -or -not (Test-Path $Target)) { return $false }
    $srcFiles = Get-ChildItem $Source -Recurse -File | ForEach-Object { $_.FullName.Substring($Source.Length).TrimStart('\') } | Sort-Object
    $dstFiles = Get-ChildItem $Target -Recurse -File | ForEach-Object { $_.FullName.Substring($Target.Length).TrimStart('\') } | Sort-Object
    if (($srcFiles -join "`n") -ne ($dstFiles -join "`n")) { return $false }
    foreach ($rel in $srcFiles) {
        $a = Get-Content (Join-Path $Source $rel) -Raw -Encoding UTF8
        $b = Get-Content (Join-Path $Target $rel) -Raw -Encoding UTF8
        if ($a -ne $b) { return $false }
    }
    return $true
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

if ($env:OS -ne 'Windows_NT') { Fail 'Verification is not running in native Windows PowerShell.' }

$inv = Join-Path $InstallRoot '01_AGENT_ENGINEERING_INVARIANTS.md'
$mp = Join-Path $InstallRoot 'MACHINE_EXECUTION_PROFILE.md'
$vf = Join-Path $InstallRoot 'VERSION'
$adapterRoot = Join-Path $InstallRoot 'adapters'
$skillsRoot = Join-Path $InstallRoot 'skills'

if (Test-Path $inv) {
    $it = Get-Content $inv -Raw -Encoding UTF8
    if ($it.Contains('FS_SEARCH_SAFETY_V1')) { Pass 'Canonical FS_SEARCH_SAFETY_V1 present' } else { Fail 'FS_SEARCH_SAFETY_V1 missing' }
    if ($it.Contains('search, discovery, inventory, or enumeration')) { Pass 'Filesystem safety covers broad traversal intents' } else { Fail 'Filesystem traversal intent coverage missing/stale' }
} else { Fail 'Canonical invariants missing' }

if (Test-Path $mp) {
    $mt = Get-Content $mp -Raw -Encoding UTF8
    foreach ($expected in @(
        'Profile-Schema-Version: 1.1',
        'filesystem_search_policy_id: FS_SEARCH_SAFETY_V1',
        'drive_root_recursive_search: explicit-user-authorization',
        'concurrent_large_tree_scans: prohibited-by-default',
        'indexed_search_preference: existing-healthy-index-preferred'
    )) {
        if ($mt.Contains($expected)) { Pass "Machine profile: $expected" } else { Fail "Machine profile missing/stale: $expected" }
    }
} else { Fail 'Machine profile missing' }

$ver = if (Test-Path $vf) { (Get-Content $vf -Raw -Encoding UTF8).Trim() } else { $null }
if ($ver) { Pass "Installed Toolkit version: $ver" } else { Fail 'VERSION missing' }
if (-not (Test-Path $adapterRoot)) { Fail 'Installed adapter templates missing; static drift verification cannot run.' }
if (-not (Test-Path $skillsRoot)) { Fail 'Installed canonical Skills missing.' }

$userProfileForward = $HOME.Replace('\','/')
function Expected-Adapter([string]$TemplateName) {
    $p = Join-Path $adapterRoot $TemplateName
    if (-not (Test-Path $p)) { return $null }
    $text = (Get-Content $p -Raw -Encoding UTF8).Replace('<USERPROFILE_FORWARD>',$userProfileForward)
    return (Get-MarkerBlock $text)
}

$codexHome = Get-CodexHome
$claudeHome = Get-ClaudeHome
$geminiHome = Join-Path $HOME '.gemini'
$codexAgents = Join-Path $codexHome 'AGENTS.md'
$codexOverride = Join-Path $codexHome 'AGENTS.override.md'
$claudeMd = Join-Path $claudeHome 'CLAUDE.md'
$geminiMd = Join-Path $geminiHome 'GEMINI.md'

$expectedCodex = Expected-Adapter 'CODEX_GLOBAL_AGENTS_TEMPLATE.md'
$expectedClaude = Expected-Adapter 'CLAUDE_GLOBAL_CLAUDE_TEMPLATE.md'
$expectedGemini = Expected-Adapter 'ANTIGRAVITY_GLOBAL_GEMINI_TEMPLATE.md'

$activeCodex = $codexAgents
if (Test-Path $codexOverride) {
    $ot = Get-Content $codexOverride -Raw -Encoding UTF8
    if (-not [string]::IsNullOrWhiteSpace($ot)) { $activeCodex = $codexOverride }
}
foreach ($check in @(
    @{ Name='Codex active adapter'; Path=$activeCodex; Expected=$expectedCodex },
    @{ Name='Claude adapter'; Path=$claudeMd; Expected=$expectedClaude },
    @{ Name='Antigravity adapter'; Path=$geminiMd; Expected=$expectedGemini }
)) {
    if (-not (Test-Path $check.Path)) { Fail "$($check.Name) missing: $($check.Path)"; continue }
    $text = Get-Content $check.Path -Raw -Encoding UTF8
    $actual = Get-MarkerBlock $text
    if (-not $actual) { Fail "$($check.Name) Toolkit marker missing"; continue }
    if (-not $check.Expected) { Fail "$($check.Name) installed template missing"; continue }
    if ($actual -eq $check.Expected) { Pass "$($check.Name) exactly matches installed template" } else { Fail "$($check.Name) drift/mismatch" }
    if ($ver -and $actual.Contains("Toolkit-Version: $ver")) { Pass "$($check.Name) version matches" } else { Fail "$($check.Name) version stale/missing" }
}

# Non-active Codex AGENTS.md still should remain Toolkit-managed if present.
if ((Test-Path $codexAgents) -and $activeCodex -ne $codexAgents) {
    $ct = Get-Content $codexAgents -Raw -Encoding UTF8
    if (Get-MarkerBlock $ct) { Pass 'Codex AGENTS.md retains Toolkit marker while override is active' } else { Warn 'Codex AGENTS.md lacks Toolkit marker, but active override is verified' }
}

$directoryTargets = @{
    'Codex' = (Join-Path $HOME '.agents\skills')
    'Claude' = (Join-Path $claudeHome 'skills')
    'Antigravity IDE' = (Join-Path $geminiHome 'config\skills')
}
$skills = @('contract-impact-check','stage-execution','independent-review')
foreach ($entry in $directoryTargets.GetEnumerator()) {
    foreach ($s in $skills) {
        $source = Join-Path $skillsRoot $s
        $target = Join-Path $entry.Value $s
        if (-not (Test-Path $target)) { Fail "$($entry.Key) missing Skill: $s"; continue }
        if (-not (Test-Path (Join-Path $target '.agent-engineering-managed'))) { Fail "$($entry.Key) Skill not Toolkit-managed: $s"; continue }
        if (Compare-Tree $source $target) { Pass "$($entry.Key) Skill matches canonical: $s" } else { Fail "$($entry.Key) Skill drift: $s" }
    }
}

$cliRoot = Join-Path $geminiHome 'antigravity-cli\skills'
foreach ($s in $skills) {
    $source = Join-Path $skillsRoot $s
    $flat = Join-Path $cliRoot "$s.md"
    $side = Join-Path $cliRoot "$s.agent-engineering-managed"
    if (-not (Test-Path $flat)) { Fail "Antigravity CLI flat Skill missing: $s"; continue }
    if (-not (Test-Path $side)) { Fail "Antigravity CLI managed sidecar missing: $s"; continue }
    $expected = Get-FlatSkill $source
    $actual = Get-Content $flat -Raw -Encoding UTF8
    if ($actual -eq $expected) { Pass "Antigravity CLI flat Skill matches canonical: $s" } else { Fail "Antigravity CLI flat Skill drift: $s" }
    $sideText = Get-Content $side -Raw -Encoding UTF8
    if ($ver -and $sideText.Contains("Toolkit-Version: $ver")) { Pass "Antigravity CLI sidecar version matches: $s" } else { Fail "Antigravity CLI sidecar version stale/missing: $s" }
}

foreach ($n in @('codex','claude','agy')) {
    if (Get-Command $n -ErrorAction SilentlyContinue) {
        Warn "$n executable exists; static verification does NOT prove the current/fresh session loaded the rules. Run 00_GUIDE/09_AGENT_LOADING_SMOKE_TEST.md."
    } else {
        Warn "$n executable not found; target cannot be runtime verified in this environment."
    }
}

Write-Host ''
if ($fail -gt 0) {
    Write-Host "Verification: FAIL ($fail issue(s), $warn warning(s))"
    exit 1
}
Write-Host "Verification: PASS_STATIC ($warn warning(s))"
Write-Host 'Runtime status remains CONFIGURED_NOT_RUNTIME_VERIFIED until fresh-session loading + behavioral smoke passes.'
exit 0
