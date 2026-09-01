[CmdletBinding()]
param([string]$ToolkitRoot = (Split-Path -Parent $PSScriptRoot))

$ErrorActionPreference = 'Stop'
$fail = 0
function Pass([string]$m) { Write-Host "[PASS] $m" }
function Fail([string]$m) { Write-Host "[FAIL] $m"; $script:fail++ }

$required = @(
    'VERSION',
    'README.md',
    '00_START_HERE_FOR_ANY_AGENT.md',
    '01_CANONICAL\01_AGENT_ENGINEERING_INVARIANTS.md',
    '01_CANONICAL\MACHINE_EXECUTION_PROFILE_TEMPLATE.md',
    '00_GUIDE\09_AGENT_LOADING_SMOKE_TEST.md',
    '03_ADAPTERS\CODEX_GLOBAL_AGENTS_TEMPLATE.md',
    '03_ADAPTERS\CLAUDE_GLOBAL_CLAUDE_TEMPLATE.md',
    '03_ADAPTERS\ANTIGRAVITY_GLOBAL_GEMINI_TEMPLATE.md',
    '04_SCRIPTS\install-agent-engineering.ps1',
    '04_SCRIPTS\verify-agent-engineering.ps1',
    '04_SCRIPTS\bootstrap-project.ps1'
)
foreach ($r in $required) {
    if (Test-Path (Join-Path $ToolkitRoot $r)) { Pass $r } else { Fail "Missing $r" }
}

$ver = (Get-Content (Join-Path $ToolkitRoot 'VERSION') -Raw -Encoding UTF8).Trim()
if ($ver -eq '1.6.3') { Pass 'VERSION 1.6.3' } else { Fail "Unexpected VERSION $ver" }

$inv = Get-Content (Join-Path $ToolkitRoot '01_CANONICAL\01_AGENT_ENGINEERING_INVARIANTS.md') -Raw -Encoding UTF8
if ($inv.Contains('FS_SEARCH_SAFETY_V1')) { Pass 'FS_SEARCH_SAFETY_V1 canonical' } else { Fail 'Filesystem safety policy missing' }
if ($inv.Contains('search, discovery, inventory, or enumeration')) { Pass 'Filesystem safety covers broad traversal intents' } else { Fail 'Filesystem safety intent coverage missing' }

$mp = Get-Content (Join-Path $ToolkitRoot '01_CANONICAL\MACHINE_EXECUTION_PROFILE_TEMPLATE.md') -Raw -Encoding UTF8
foreach ($expected in @(
    'Profile-Schema-Version: 1.1',
    'drive_root_recursive_search: explicit-user-authorization',
    'indexed_search_preference: existing-healthy-index-preferred'
)) {
    if ($mp.Contains($expected)) { Pass "Machine profile: $expected" } else { Fail "Machine profile missing: $expected" }
}

# Reject hidden control characters that can corrupt copy/paste commands.
$textExtensions = @('.md','.ps1','.json','.jsonl','.txt')
foreach ($file in (Get-ChildItem $ToolkitRoot -Recurse -File)) {
    if ($textExtensions -contains $file.Extension.ToLowerInvariant() -or $file.Name -eq 'VERSION') {
        $bytes = [System.IO.File]::ReadAllBytes($file.FullName)
        $bad = @($bytes | Where-Object { $_ -lt 32 -and $_ -ne 9 -and $_ -ne 10 -and $_ -ne 13 })
        if ($bad.Count -gt 0) { Fail "Illegal C0 control character(s): $($file.FullName)" }
    }
}
if ($fail -eq 0) { Pass 'No illegal C0 control characters in text package files' }

# Parse every PowerShell script with the native parser; syntax errors are release-blocking.
foreach ($ps1 in (Get-ChildItem (Join-Path $ToolkitRoot '04_SCRIPTS') -File -Filter '*.ps1')) {
    $tokens = $null; $errors = $null
    [void][System.Management.Automation.Language.Parser]::ParseFile($ps1.FullName,[ref]$tokens,[ref]$errors)
    if ($errors.Count -gt 0) {
        foreach ($e in $errors) { Fail "PowerShell parse error $($ps1.Name): $($e.Message)" }
    } else { Pass "PowerShell parse: $($ps1.Name)" }
}

# JSON and JSONL syntax.
foreach ($json in (Get-ChildItem $ToolkitRoot -Recurse -File -Filter '*.json')) {
    try { Get-Content $json.FullName -Raw -Encoding UTF8 | ConvertFrom-Json | Out-Null; Pass "JSON parse: $($json.FullName)" } catch { Fail "JSON invalid: $($json.FullName) :: $($_.Exception.Message)" }
}
foreach ($jsonl in (Get-ChildItem $ToolkitRoot -Recurse -File -Filter '*.jsonl')) {
    $lineNo = 0
    foreach ($line in (Get-Content $jsonl.FullName -Encoding UTF8)) {
        $lineNo++
        if ([string]::IsNullOrWhiteSpace($line)) { continue }
        try { $line | ConvertFrom-Json | Out-Null } catch { Fail "JSONL invalid: $($jsonl.FullName):$lineNo :: $($_.Exception.Message)" }
    }
    if ($fail -eq 0) { Pass "JSONL parse: $($jsonl.FullName)" }
}

# Adapter versions and deterministic canonical/machine references.
foreach ($name in @('CODEX_GLOBAL_AGENTS_TEMPLATE.md','CLAUDE_GLOBAL_CLAUDE_TEMPLATE.md','ANTIGRAVITY_GLOBAL_GEMINI_TEMPLATE.md')) {
    $p = Join-Path $ToolkitRoot "03_ADAPTERS\$name"
    $t = Get-Content $p -Raw -Encoding UTF8
    if ($t.Contains("Toolkit-Version: $ver")) { Pass "Adapter version: $name" } else { Fail "Adapter version mismatch: $name" }
    if ($t.Contains('.agent-engineering/01_AGENT_ENGINEERING_INVARIANTS.md') -and $t.Contains('.agent-engineering/MACHINE_EXECUTION_PROFILE.md')) {
        Pass "Adapter deterministic AET references: $name"
    } else { Fail "Adapter missing deterministic AET references: $name" }
}

# Start-here critical command references must resolve inside the package.
$start = Get-Content (Join-Path $ToolkitRoot '00_START_HERE_FOR_ANY_AGENT.md') -Raw -Encoding UTF8
foreach ($scriptName in @('self-test-toolkit.ps1','preflight-windows.ps1','install-agent-engineering.ps1','verify-agent-engineering.ps1')) {
    if ($start.Contains($scriptName)) { Pass "Start Here references $scriptName" } else { Fail "Start Here missing $scriptName" }
}

if ($fail -gt 0) { Write-Host "Self-test: FAIL ($fail)"; exit 1 }
Write-Host 'Self-test: PASS'
exit 0
