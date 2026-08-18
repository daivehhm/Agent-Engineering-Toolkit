[CmdletBinding(SupportsShouldProcess=$true)]
param(
    [string]$InstallRoot = (Join-Path $HOME ".agent-engineering"),
    [switch]$RemoveCanonical
)

$ErrorActionPreference = "Stop"
function Get-CodexHome { if ($env:CODEX_HOME) { return $env:CODEX_HOME }; return (Join-Path $HOME ".codex") }
function Get-ClaudeHome { if ($env:CLAUDE_CONFIG_DIR) { return $env:CLAUDE_CONFIG_DIR }; return (Join-Path $HOME ".claude") }
function Remove-MarkerBlock([string]$Path) {
    if (-not (Test-Path $Path)) { return }
    $begin = "<!-- AGENT-ENGINEERING-TOOLKIT:BEGIN -->"
    $end = "<!-- AGENT-ENGINEERING-TOOLKIT:END -->"
    $txt = Get-Content $Path -Raw -Encoding UTF8
    $pattern = [regex]::Escape($begin) + "(?s).*?" + [regex]::Escape($end)
    $new = [regex]::Replace($txt, $pattern, "").Trim()
    if ($PSCmdlet.ShouldProcess($Path, "Remove Toolkit marker block")) {
        Set-Content $Path $new -Encoding UTF8
    }
}

$codexHome = Get-CodexHome
$claudeHome = Get-ClaudeHome
$geminiHome = Join-Path $HOME ".gemini"

Remove-MarkerBlock (Join-Path $codexHome "AGENTS.md")
Remove-MarkerBlock (Join-Path $codexHome "AGENTS.override.md")
Remove-MarkerBlock (Join-Path $claudeHome "CLAUDE.md")
Remove-MarkerBlock (Join-Path $geminiHome "GEMINI.md")

$skills = @("contract-impact-check","stage-execution","independent-review")
$directoryTargets = @(
    (Join-Path $HOME ".agents\skills"),
    (Join-Path $claudeHome "skills"),
    (Join-Path $geminiHome "config\skills")
)
foreach ($target in $directoryTargets) {
    foreach ($skill in $skills) {
        $p = Join-Path $target $skill
        if (-not (Test-Path $p)) { continue }
        if (-not (Test-Path (Join-Path $p ".agent-engineering-managed"))) {
            Write-Warning "Skip unmanaged skill: $p"
            continue
        }
        if ($PSCmdlet.ShouldProcess($p, "Remove Toolkit-managed skill")) { Remove-Item $p -Recurse -Force }
    }
}

$cliRoot = Join-Path $geminiHome "antigravity-cli\skills"
foreach ($skill in $skills) {
    $flat = Join-Path $cliRoot "$skill.md"
    $sidecar = Join-Path $cliRoot "$skill.agent-engineering-managed"
    $legacyDir = Join-Path $cliRoot $skill

    if ((Test-Path $flat) -and (Test-Path $sidecar)) {
        if ($PSCmdlet.ShouldProcess($flat, "Remove Toolkit-managed Antigravity CLI flat skill")) {
            Remove-Item $flat -Force
            Remove-Item $sidecar -Force -ErrorAction SilentlyContinue
        }
    } elseif (Test-Path $flat) {
        Write-Warning "Skip unmanaged Antigravity CLI flat skill: $flat"
    }

    # Remove only recognized v1.1 managed directory leftovers.
    if ((Test-Path $legacyDir) -and (Test-Path (Join-Path $legacyDir ".agent-engineering-managed"))) {
        if ($PSCmdlet.ShouldProcess($legacyDir, "Remove legacy Toolkit CLI directory-format skill")) {
            Remove-Item $legacyDir -Recurse -Force
        }
    }
}

if ($RemoveCanonical -and (Test-Path $InstallRoot)) {
    if ($PSCmdlet.ShouldProcess($InstallRoot, "Remove canonical Toolkit")) { Remove-Item $InstallRoot -Recurse -Force }
}
Write-Host "Uninstall complete. Non-Toolkit rules/skills were preserved."
