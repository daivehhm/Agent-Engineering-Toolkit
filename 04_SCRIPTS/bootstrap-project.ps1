[CmdletBinding(SupportsShouldProcess=$true)]
param(
    [Parameter(Mandatory=$true)][string]$ProjectRoot,
    [string]$InstallRoot = (Join-Path $HOME '.agent-engineering'),
    [switch]$IntegrateExisting
)

$ErrorActionPreference = 'Stop'
$tpl = Join-Path $InstallRoot 'project-templates'
if (-not (Test-Path $tpl)) { throw "Project templates missing: $tpl" }

function Set-ProjectRouterBlock([string]$Path, [string]$Content) {
    $begin = '<!-- AET-PROJECT-ROUTER:BEGIN -->'
    $end = '<!-- AET-PROJECT-ROUTER:END -->'
    $block = $begin + "`r`n" + $Content.Trim() + "`r`n" + $end
    $existing = if (Test-Path $Path) { Get-Content $Path -Raw -Encoding UTF8 } else { '' }
    $pattern = [regex]::Escape($begin) + '(?s).*?' + [regex]::Escape($end)
    if ([regex]::IsMatch($existing,$pattern)) {
        $replacement = $block
        $new = [regex]::Replace($existing,$pattern,[System.Text.RegularExpressions.MatchEvaluator]{ param($m) $replacement })
    } elseif ($existing.Trim() -eq $Content.Trim()) {
        # Existing file is an earlier AET-created raw router; normalize it once into a managed block.
        $new = $block + "`r`n"
    } elseif ([string]::IsNullOrWhiteSpace($existing)) {
        $new = $block + "`r`n"
    } else {
        $new = $existing.TrimEnd() + "`r`n`r`n" + $block + "`r`n"
    }
    if ($existing -eq $new) { return }
    if ($PSCmdlet.ShouldProcess($Path,'Integrate/update idempotent AET project router block')) {
        $parent = Split-Path -Parent $Path
        if ($parent) { New-Item -ItemType Directory -Force -Path $parent | Out-Null }
        Set-Content -Path $Path -Value $new -Encoding UTF8
    }
}

if (-not (Test-Path $ProjectRoot)) {
    if ($PSCmdlet.ShouldProcess($ProjectRoot,'Create project root')) {
        New-Item -ItemType Directory -Force -Path $ProjectRoot | Out-Null
    }
}

$routerFiles = @('AGENTS.md','CLAUDE.md','GEMINI.md','.agents\rules\engineering-contract-router.md')
foreach ($rel in $routerFiles) {
    $src = Join-Path $tpl $rel
    $dst = Join-Path $ProjectRoot $rel
    if (-not (Test-Path $src)) { throw "Project router template missing: $src" }
    if (Test-Path $dst) {
        if (-not $IntegrateExisting) { Write-Warning "Preserved existing: $dst"; continue }
        Set-ProjectRouterBlock $dst (Get-Content $src -Raw -Encoding UTF8)
    } else {
        if ($PSCmdlet.ShouldProcess($dst,'Create project router template')) {
            $parent = Split-Path -Parent $dst
            if ($parent) { New-Item -ItemType Directory -Force -Path $parent | Out-Null }
            Copy-Item $src $dst -Force
        }
    }
}

# ENGINEERING_CONTRACT.md is the project semantic source of truth. Never append a blank skeleton to an existing contract.
$contractSrc = Join-Path $tpl 'ENGINEERING_CONTRACT.md'
$contractDst = Join-Path $ProjectRoot 'ENGINEERING_CONTRACT.md'
if (Test-Path $contractDst) {
    Write-Warning "Preserved existing canonical project contract without modification: $contractDst"
} else {
    if ($PSCmdlet.ShouldProcess($contractDst,'Create project Engineering Contract skeleton')) {
        Copy-Item $contractSrc $contractDst -Force
    }
}
