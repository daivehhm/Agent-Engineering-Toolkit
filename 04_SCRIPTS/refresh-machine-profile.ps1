[CmdletBinding(SupportsShouldProcess=$true)]
param(
    [string]$InstallRoot = (Join-Path $HOME ".agent-engineering"),
    [string]$ProfilePath = ""
)

$ErrorActionPreference = "Stop"

if ($env:OS -ne "Windows_NT") {
    throw "Machine Execution Profile refresh must run in native Windows PowerShell."
}

if ([string]::IsNullOrWhiteSpace($ProfilePath)) {
    $ProfilePath = Join-Path $InstallRoot "MACHINE_EXECUTION_PROFILE.md"
}

$template = Join-Path $InstallRoot "canonical\MACHINE_EXECUTION_PROFILE_TEMPLATE.md"
if (-not (Test-Path $template)) { throw "Machine profile template missing: $template" }

if (-not (Test-Path $ProfilePath)) {
    if ($PSCmdlet.ShouldProcess($ProfilePath, "Create Machine Execution Profile from template")) {
        if (-not $WhatIfPreference) {
            New-Item -ItemType Directory -Force -Path (Split-Path -Parent $ProfilePath) | Out-Null
            Copy-Item $template $ProfilePath -Force
        }
    }
}

if ($WhatIfPreference) {
    Write-Host "WhatIf: would refresh managed machine discovery block in $ProfilePath"
    exit 0
}

function Command-Path([string]$Name) {
    $cmd = Get-Command $Name -ErrorAction SilentlyContinue
    if ($cmd) { return $cmd.Source }
    return "<not-found>"
}
function Effective-CodexHome { if ($env:CODEX_HOME) { return $env:CODEX_HOME }; return (Join-Path $HOME ".codex") }
function Effective-ClaudeHome { if ($env:CLAUDE_CONFIG_DIR) { return $env:CLAUDE_CONFIG_DIR }; return (Join-Path $HOME ".claude") }

$begin = "<!-- MACHINE-DISCOVERY:BEGIN -->"
$end = "<!-- MACHINE-DISCOVERY:END -->"
$existing = Get-Content $ProfilePath -Raw -Encoding UTF8
$pattern = [regex]::Escape($begin) + "(?s).*?" + [regex]::Escape($end)

if (-not [regex]::IsMatch($existing, $pattern)) {
    throw "Machine profile discovery markers missing. Refusing to rewrite user policy: $ProfilePath"
}

$tools = @("rtk","git","python","py","ffmpeg","ffprobe","codex","claude","agy","nvidia-smi")
$rows = New-Object System.Collections.Generic.List[string]
$rows.Add($begin)
$rows.Add("Discovery-State: REFRESHED")
$rows.Add("Discovery-Generated-At: $(Get-Date -Format 'yyyy-MM-ddTHH:mm:ssK')")
$rows.Add("")
$rows.Add("| Fact | Observed Value |")
$rows.Add("|---|---|")
$rows.Add("| OS | $([System.Environment]::OSVersion.VersionString) |")
$rows.Add("| PowerShell Edition | $($PSVersionTable.PSEdition) |")
$rows.Add("| PowerShell Version | $($PSVersionTable.PSVersion) |")
$rows.Add("| USERPROFILE | $env:USERPROFILE |")
$rows.Add("| HOME | $HOME |")
$rows.Add("| Effective CODEX_HOME | $(Effective-CodexHome) |")
$rows.Add("| Effective Claude Config Home | $(Effective-ClaudeHome) |")
foreach ($tool in $tools) { $rows.Add("| command:$tool | $(Command-Path $tool) |") }
$rows.Add("")
$rows.Add("Interpretation: DISCOVERY_IS_MACHINE_FACT_ONLY_NOT_AGENT_PERMISSION")
$rows.Add($end)

$replacement = $rows -join "`r`n"
$newText = [regex]::Replace(
    $existing,
    $pattern,
    [System.Text.RegularExpressions.MatchEvaluator]{ param($m) $replacement }
)
Set-Content -Path $ProfilePath -Value $newText -Encoding UTF8
Write-Host "Machine Execution Profile refreshed: $ProfilePath"
