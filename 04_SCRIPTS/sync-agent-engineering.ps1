[CmdletBinding(SupportsShouldProcess=$true)]
param(
    [string]$ToolkitSourceRoot=(Split-Path -Parent $PSScriptRoot),
    [string]$InstallRoot=(Join-Path $HOME '.agent-engineering'),
    [switch]$IntegrateCodexOverride,
    [switch]$ForceManagedSkillOverwrite
)
$params=@{
    ToolkitSourceRoot=$ToolkitSourceRoot
    InstallRoot=$InstallRoot
    UpgradeCanonical=$true
    WhatIf=$WhatIfPreference
}
if($IntegrateCodexOverride){$params.IntegrateCodexOverride=$true}
if($ForceManagedSkillOverwrite){$params.ForceManagedSkillOverwrite=$true}
& (Join-Path $PSScriptRoot 'install-agent-engineering.ps1') @params
if($LASTEXITCODE){exit $LASTEXITCODE}
