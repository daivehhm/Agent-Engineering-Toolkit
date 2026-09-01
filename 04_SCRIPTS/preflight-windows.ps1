[CmdletBinding()]
param(
    [string]$InstallRoot = (Join-Path $HOME '.agent-engineering'),
    [switch]$TestWriteAccess
)
$ErrorActionPreference = 'Stop'
$fail = 0
function Pass([string]$m){Write-Host "[PASS] $m"}
function Fail([string]$m){Write-Host "[FAIL] $m";$script:fail++}
function Get-CodexHome { if($env:CODEX_HOME){return $env:CODEX_HOME}; return (Join-Path $HOME '.codex') }
function Get-ClaudeHome { if($env:CLAUDE_CONFIG_DIR){return $env:CLAUDE_CONFIG_DIR}; return (Join-Path $HOME '.claude') }

if($env:OS -ne 'Windows_NT'){Fail 'Not native Windows PowerShell'}else{Pass 'Native Windows detected'}
$targets=@($InstallRoot,(Get-CodexHome),(Get-ClaudeHome),(Join-Path $HOME '.gemini'))
foreach($t in $targets){
    $parent=if(Test-Path $t){$t}else{Split-Path -Parent $t}
    if(Test-Path $parent){Pass "Parent exists: $parent"}else{Fail "Parent missing: $parent"}
}
if($TestWriteAccess){
    foreach($t in $targets){
        $parent=if(Test-Path $t){$t}else{Split-Path -Parent $t}
        if(-not(Test-Path $parent)){continue}
        $probe=Join-Path $parent ('.aet-write-probe-'+[guid]::NewGuid().ToString('N'))
        try{Set-Content $probe 'probe' -Encoding ASCII;Remove-Item $probe -Force;Pass "Reversible write probe: $parent"}
        catch{Fail "Write probe failed: $parent :: $($_.Exception.Message)"}
    }
}
$override=Join-Path (Get-CodexHome) 'AGENTS.override.md'
if(Test-Path $override){
    $txt=Get-Content $override -Raw -Encoding UTF8
    if(-not[string]::IsNullOrWhiteSpace($txt) -and -not $txt.Contains('AGENT-ENGINEERING-TOOLKIT:BEGIN')){
        Write-Warning "Non-empty Codex AGENTS.override.md can suppress global AGENTS.md and is not AET-integrated: $override"
    }
}
if($fail){Write-Host "Preflight: FAIL ($fail)";exit 1}
Write-Host 'Preflight: PASS';exit 0
