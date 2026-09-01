[CmdletBinding()]
param([string]$InstallRoot=(Join-Path $HOME '.agent-engineering'))
$ErrorActionPreference='Stop'
if($env:OS -ne 'Windows_NT'){throw 'Native Windows required'}
$profile=Join-Path $InstallRoot 'MACHINE_EXECUTION_PROFILE.md'; $template=Join-Path $InstallRoot 'MACHINE_EXECUTION_PROFILE_TEMPLATE.md'
if(-not(Test-Path $profile)){Copy-Item $template $profile -Force}
$txt=Get-Content $profile -Raw -Encoding UTF8
$tools=@('git','python','node','npm','rtk','codex','claude','agy','es')
$lines=@('Discovery-State: REFRESHED',"Refreshed-At: $((Get-Date).ToString('o'))",'OS: Windows_NT')
foreach($t in $tools){$c=Get-Command $t -ErrorAction SilentlyContinue; $lines += "$t`: " + $(if($c){$c.Source}else{'NOT_FOUND'})}
$block="<!-- MACHINE-DISCOVERY:BEGIN -->`r`n"+($lines -join "`r`n")+"`r`n<!-- MACHINE-DISCOVERY:END -->"
$pat='(?s)<!-- MACHINE-DISCOVERY:BEGIN -->.*?<!-- MACHINE-DISCOVERY:END -->'
if(-not [regex]::IsMatch($txt,$pat)){throw 'Machine profile discovery markers missing'}
Set-Content $profile ([regex]::Replace($txt,$pat,$block)) -Encoding UTF8
Write-Host "Refreshed: $profile"
