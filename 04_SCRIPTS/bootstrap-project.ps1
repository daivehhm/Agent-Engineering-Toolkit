[CmdletBinding(SupportsShouldProcess=$true)]
param(
    [Parameter(Mandatory=$true)]
    [string]$ProjectRoot,
    [string]$InstallRoot = (Join-Path $HOME ".agent-engineering"),
    [string]$TestCommand = "<TEST_COMMAND>",
    [string]$ContractVersion = "0.1.0",
    [switch]$IntegrateExisting,
    [switch]$IncludeCodexCompatibility,
    [switch]$Force
)

$ErrorActionPreference = "Stop"

function Backup-File([string]$Path) {
    if ($WhatIfPreference) {
        Write-Host "WhatIf: would backup $Path"
        return $null
    }
    $stamp = Get-Date -Format "yyyyMMdd-HHmmss"
    $backup = "$Path.agent-engineering-backup-$stamp"
    Copy-Item $Path $backup -Force
    return $backup
}
function Add-MarkerBlock {
    param([string]$Path, [string]$Block)
    if ($WhatIfPreference) {
        Write-Host "WhatIf: would integrate Toolkit project block into $Path"
        return
    }
    $begin = "<!-- AGENT-ENGINEERING-PROJECT:BEGIN -->"
    $end = "<!-- AGENT-ENGINEERING-PROJECT:END -->"
    $existing = if (Test-Path $Path) { Get-Content $Path -Raw -Encoding UTF8 } else { "" }
    $pattern = [regex]::Escape($begin) + "(?s).*?" + [regex]::Escape($end)
    if ([regex]::IsMatch($existing, $pattern)) {
        $new = [regex]::Replace($existing, $pattern, [System.Text.RegularExpressions.MatchEvaluator]{ param($m) $Block })
    } else {
        $prefix = if ([string]::IsNullOrWhiteSpace($existing)) { "" } else { $existing.TrimEnd() + "`r`n`r`n" }
        $new = $prefix + $Block + "`r`n"
    }
    Set-Content $Path $new -Encoding UTF8
}

$templates = Join-Path $InstallRoot "project-templates"
if (-not (Test-Path $templates)) { throw "Project templates not found: $templates" }

if (-not $WhatIfPreference) {
    New-Item -ItemType Directory -Force -Path $ProjectRoot | Out-Null
}
$projectName = Split-Path -Leaf ($ProjectRoot.TrimEnd("\","/"))

$items = @(
    "AGENTS.md",
    "CLAUDE.md",
    "GEMINI.md",
    "ENGINEERING_CONTRACT.md",
    ".agents\rules\engineering-contract-router.md"
)
$adapterFiles = @("AGENTS.md","CLAUDE.md","GEMINI.md")
$existedAtStart = @{}
foreach ($rel in $items) { $existedAtStart[$rel] = Test-Path (Join-Path $ProjectRoot $rel) }

foreach ($rel in $items) {
    $src = Join-Path $templates $rel
    $dst = Join-Path $ProjectRoot $rel
    if (-not (Test-Path $src)) { throw "Template missing: $src" }

    # Existing agent adapters are merged later when -IntegrateExisting is used.
    # Do not overwrite them first, even when -Force is also present.
    if ($IntegrateExisting -and $existedAtStart[$rel] -and ($adapterFiles -contains $rel)) {
        Write-Host "Preserve existing for marker integration: $dst"
        continue
    }

    if ((Test-Path $dst) -and -not $Force) {
        Write-Host "SKIP existing: $dst"
        continue
    }

    if ($PSCmdlet.ShouldProcess($dst, "Create project config")) {
        if (-not $WhatIfPreference) {
            if ((Test-Path $dst) -and $Force) {
                $backup = Backup-File $dst
                if ($backup) { Write-Host "Backup before overwrite: $backup" }
            }
            New-Item -ItemType Directory -Force -Path (Split-Path -Parent $dst) | Out-Null
            $text = Get-Content $src -Raw -Encoding UTF8
            $text = $text.Replace("<PROJECT_NAME>", $projectName)
            $text = $text.Replace("<CURRENT_ROOT>", $ProjectRoot)
            $text = $text.Replace("<TEST_COMMAND>", $TestCommand)
            $text = $text.Replace("<CONTRACT_VERSION>", $ContractVersion)
            Set-Content $dst $text -Encoding UTF8
            Write-Host "Created: $dst"
        }
    }
}

if ($IntegrateExisting) {
    $agentBlock = @'
<!-- AGENT-ENGINEERING-PROJECT:BEGIN -->
## Agent Engineering Project Router

Canonical project semantics live in `ENGINEERING_CONTRACT.md`.

For product/business semantic changes:
- read canonical contract;
- use `contract-impact-check`.

Before terminal/filesystem/network/GPU/long-runtime execution:
- read `%USERPROFILE%\.agent-engineering\MACHINE_EXECUTION_PROFILE.md` if installed;
- perform Stage capability preflight.

Workspace default:
- one active Builder writer per worktree;
- Reviewer read-only by default.

Use `stage-execution` for complete engineering stages.
Use `independent-review` for formal independent review.

Do not duplicate business thresholds/state semantics in this adapter.
<!-- AGENT-ENGINEERING-PROJECT:END -->
'@
    $claudeBlock = @'
<!-- AGENT-ENGINEERING-PROJECT:BEGIN -->
@AGENTS.md
Use /contract-impact-check for semantic changes.
Use /stage-execution for stage work.
Use /independent-review only for independent review.
<!-- AGENT-ENGINEERING-PROJECT:END -->
'@
    $geminiBlock = @'
<!-- AGENT-ENGINEERING-PROJECT:BEGIN -->
@AGENTS.md
Use contract-impact-check for semantic changes.
Use stage-execution for stage work.
Use independent-review only for independent review.
<!-- AGENT-ENGINEERING-PROJECT:END -->
'@

    $integrationTargets = @(
        @("AGENTS.md", (Join-Path $ProjectRoot "AGENTS.md"), $agentBlock),
        @("CLAUDE.md", (Join-Path $ProjectRoot "CLAUDE.md"), $claudeBlock),
        @("GEMINI.md", (Join-Path $ProjectRoot "GEMINI.md"), $geminiBlock)
    )

    foreach ($entry in $integrationTargets) {
        $rel = $entry[0]; $path = $entry[1]; $block = $entry[2]
        if (-not $existedAtStart[$rel]) {
            Write-Host "No merge needed; Toolkit template was new/nonexistent at start: $path"
            continue
        }
        if ($PSCmdlet.ShouldProcess($path, "Integrate Agent Engineering project block")) {
            if (-not $WhatIfPreference) {
                $backup = Backup-File $path
                if ($backup) { Write-Host "Backup before integration: $backup" }
                Add-MarkerBlock $path $block
            }
        }
    }
}

if ($IncludeCodexCompatibility) {
    $src = Join-Path $InstallRoot "project-templates\CODEX_COMPATIBILITY_TEMPLATE.md"
    $dst = Join-Path $ProjectRoot "CODEX.md"
    if (-not (Test-Path $src)) { throw "CODEX compatibility template missing: $src" }

    if ((Test-Path $dst) -and -not $Force) {
        Write-Host "SKIP existing: $dst"
    } elseif ($PSCmdlet.ShouldProcess($dst, "Create optional CODEX.md compatibility file")) {
        if (-not $WhatIfPreference) {
            if ((Test-Path $dst) -and $Force) {
                $backup = Backup-File $dst
                if ($backup) { Write-Host "Backup before overwrite: $backup" }
            }
            Copy-Item $src $dst -Force
        }
    }
}

Write-Host ""
if ($WhatIfPreference) {
    Write-Host "Project bootstrap dry-run complete; no project files/backups should have been modified."
} else {
    Write-Host "Project bootstrap complete."
}
if ($TestCommand -eq "<TEST_COMMAND>") {
    Write-Warning "Test command remains a placeholder. Do not treat project configuration as complete until AGENTS.md contains the real command."
} else {
    Write-Host "Configured project test command: $TestCommand"
}
Write-Host "Edit ENGINEERING_CONTRACT.md for actual long-lived product contracts."
Write-Host "Antigravity IDE workspace rule activation must be verified in Customizations; recommended: Model Decision."
