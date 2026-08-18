[CmdletBinding()]
param(
    [string]$ToolkitSourceRoot = (Split-Path -Parent $PSScriptRoot)
)

$ErrorActionPreference = "Stop"
$fail = 0
function Pass([string]$m) { Write-Host "[PASS] $m" }
function Fail([string]$m) { Write-Host "[FAIL] $m"; $script:fail++ }

$required = @(
    "VERSION",
    "00_START_HERE_FOR_ANY_AGENT.md",
    "00_GUIDE\11_ANY_AGENT_WINDOWS_INSTALLATION_PLAYBOOK.md",
    "01_CANONICAL\01_AGENT_ENGINEERING_INVARIANTS.md",
    "01_CANONICAL\02_CONTRACT_IMPACT_CHECK.md",
    "01_CANONICAL\03_STAGE_EXECUTION_TEMPLATE.md",
    "01_CANONICAL\04_INDEPENDENT_REVIEW_CHECKLIST.md",
    "01_CANONICAL\TEST_INTEGRITY_CONTRACT.md",
    "02_SKILLS\contract-impact-check\SKILL.md",
    "02_SKILLS\stage-execution\SKILL.md",
    "02_SKILLS\independent-review\SKILL.md",
    "04_SCRIPTS\preflight-windows.ps1",
    "04_SCRIPTS\install-agent-engineering.ps1",
    "04_SCRIPTS\sync-agent-engineering.ps1",
    "04_SCRIPTS\verify-agent-engineering.ps1",
    "04_SCRIPTS\bootstrap-project.ps1",
    "03_ADAPTERS\PROJECT_TEMPLATES\AGENTS.md",
    "03_ADAPTERS\PROJECT_TEMPLATES\CLAUDE.md",
    "03_ADAPTERS\PROJECT_TEMPLATES\GEMINI.md",
    "03_ADAPTERS\PROJECT_TEMPLATES\ENGINEERING_CONTRACT.md"
)
foreach ($rel in $required) {
    if (Test-Path (Join-Path $ToolkitSourceRoot $rel)) { Pass "Exists: $rel" } else { Fail "Missing: $rel" }
}

$version = (Get-Content (Join-Path $ToolkitSourceRoot "VERSION") -Raw -Encoding UTF8).Trim()
if ($version -eq "1.3.0") { Pass "Version is 1.3.0" } else { Fail "Unexpected version: $version" }

$invariants = Join-Path $ToolkitSourceRoot "01_CANONICAL\01_AGENT_ENGINEERING_INVARIANTS.md"
if (Test-Path $invariants) {
    $txt = Get-Content $invariants -Raw -Encoding UTF8
    if ($txt.Length -le 10000) { Pass "Global invariants remain concise" } else { Fail "Global invariants too large: $($txt.Length)" }
}

$skills = @("contract-impact-check","stage-execution","independent-review")
$names = @()
foreach ($skill in $skills) {
    $dir = Join-Path $ToolkitSourceRoot "02_SKILLS\$skill"
    $file = Join-Path $dir "SKILL.md"
    $marker = Join-Path $dir ".agent-engineering-managed"
    if (Test-Path $marker) { Pass "Managed marker: $skill" } else { Fail "Missing managed marker: $skill" }
    if (Test-Path $file) {
        $txt = Get-Content $file -Raw -Encoding UTF8
        $nameMatch = [regex]::Match($txt, "(?m)^name:\s*(.+)$")
        $descMatch = [regex]::Match($txt, "(?m)^description:\s*(.+)$")
        if ($nameMatch.Success) {
            $name = $nameMatch.Groups[1].Value.Trim(); $names += $name
            if ($name -eq $skill) { Pass "Skill name: $skill" } else { Fail "Skill name mismatch: $skill / $name" }
        } else { Fail "Skill name missing: $skill" }
        if ($descMatch.Success) { Pass "Skill description: $skill" } else { Fail "Skill description missing: $skill" }
    }
}
if (($names | Sort-Object -Unique).Count -eq $names.Count) { Pass "Skill names unique" } else { Fail "Duplicate Skill names" }

$installer = Get-Content (Join-Path $ToolkitSourceRoot "04_SCRIPTS\install-agent-engineering.ps1") -Raw -Encoding UTF8
$syncer = Get-Content (Join-Path $ToolkitSourceRoot "04_SCRIPTS\sync-agent-engineering.ps1") -Raw -Encoding UTF8
$bootstrap = Get-Content (Join-Path $ToolkitSourceRoot "04_SCRIPTS\bootstrap-project.ps1") -Raw -Encoding UTF8
$verifier = Get-Content (Join-Path $ToolkitSourceRoot "04_SCRIPTS\verify-agent-engineering.ps1") -Raw -Encoding UTF8

if ($installer -notmatch '\$contract-impact-check|\$stage-execution|\$independent-review') { Pass "No PowerShell skill-name interpolation regression" } else { Fail "Risky PowerShell skill-name interpolation found" }
if ($installer.Contains("native Windows") -and $installer.Contains("WhatIf: would backup")) { Pass "Installer has Windows guard and WhatIf-safe backup behavior" } else { Fail "Installer Windows/WhatIf safeguards missing" }
if ($installer.Contains("partial/unknown installation") -and $installer.Contains("-UpgradeCanonical")) { Pass "Installer fails closed on unversioned/partial canonical install" } else { Fail "Partial-install provenance guard missing" }
if ($syncer.Contains("Antigravity CLI requires flat Markdown skills") -and $syncer.Contains('"$skill.md"')) { Pass "Antigravity CLI flat-skill layout implemented" } else { Fail "CLI flat-skill layout missing" }
if ($syncer.Contains("Pass 1: fail closed") -and $syncer.Contains("No skill targets were modified")) { Pass "Skill conflict pre-scan implemented" } else { Fail "Skill conflict pre-scan missing" }
if ($bootstrap.Contains("Do not overwrite them first") -and $bootstrap.Contains("Preserve existing for marker integration")) { Pass "Existing project adapter integration is non-destructive" } else { Fail "Project integration overwrite safeguard missing" }
if ($bootstrap.Contains("dry-run complete; no project files/backups")) { Pass "Project WhatIf no-write contract documented in script" } else { Fail "Project WhatIf contract missing" }
if ($verifier.Contains("Antigravity CLI flat skill") -and $verifier.Contains("legacy directory-format")) { Pass "Verifier checks real CLI skill layout" } else { Fail "Verifier CLI layout check missing" }

$archives = Get-ChildItem $ToolkitSourceRoot -Recurse -File | Where-Object { $_.Extension -in @(".zip",".rar",".7z") }
if ($archives.Count -eq 0) { Pass "No nested archives" } else { Fail "Nested archives found" }

Write-Host ""
if ($fail -gt 0) { Write-Host "Toolkit Self-Test: FAIL ($fail issue(s))"; exit 1 }
Write-Host "Toolkit Self-Test: PASS"
exit 0
