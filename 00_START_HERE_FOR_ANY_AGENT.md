# Start Here for Any Agent — v1.5

Do not rely on prior conversation context. Treat this package as self-contained.

## Scope
This Toolkit configures engineering rules, Skills, Machine Profile, and optional project adapters for Codex / Claude Code / Antigravity. It does not install those products, change authentication/API keys/models/providers, weaken sandbox/security, or perform Git writes unless explicitly authorized.

## Native Windows only for setup scripts
Do not use WSL/Linux as a substitute for native Windows configuration proof.

## Required Setup Sequence
```text
Package Self-Test
→ Native Windows Preflight
→ WhatIf
→ Install/Upgrade
→ Machine Profile Refresh
→ Disk Verify
→ Actual Agent Loading Smoke
```

## Commands
From extracted package root:
```powershell
powershell -ExecutionPolicy Bypass -File .\04_SCRIPTS\self-test-toolkit.ps1
powershell -ExecutionPolicy Bypass -File .\04_SCRIPTS\preflight-windows.ps1 -TestWriteAccess
powershell -ExecutionPolicy Bypass -File .\04_SCRIPTS\install-agent-engineering.ps1 -WhatIf
powershell -ExecutionPolicy Bypass -File .\04_SCRIPTS\install-agent-engineering.ps1
powershell -ExecutionPolicy Bypass -File $HOME\.agent-engineering\scripts\verify-agent-engineering.ps1
```
If upgrading an older version, use `-UpgradeCanonical` after reviewing WhatIf output.

## Machine Profile
Installed path:
`%USERPROFILE%\.agent-engineering\MACHINE_EXECUTION_PROFILE.md`.
Refresh after tool/runtime changes:
```powershell
$HOME\.agent-engineering\scripts\refresh-machine-profile.ps1
```
Machine discovery is machine fact only. It does not prove the current Agent session can execute a tool.

## Project Work
Before formal work, classify it as SMALL_CHANGE / STAGE_WORK / FORMAL_ACCEPTANCE. Use `WORK_CLASS_POLICY.md`.

For semantic changes use `contract-impact-check`.
For STAGE_WORK / FORMAL_ACCEPTANCE use `stage-execution`.
For formal review use `independent-review`.

## Success State
File existence is insufficient. `SETUP_VERIFIED` requires actual loading verification for every locally installed target. Otherwise report `SETUP_PARTIALLY_VERIFIED` or `SETUP_BLOCKED`.
