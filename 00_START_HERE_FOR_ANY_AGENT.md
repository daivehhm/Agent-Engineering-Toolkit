# Start Here for Any Agent — v1.6.1

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
→ Static Verify
→ Actual Agent Loading + Behavioral Smoke
```

## Commands
From the extracted package root:
```powershell
powershell -ExecutionPolicy Bypass -File .\04_SCRIPTS\self-test-toolkit.ps1
powershell -ExecutionPolicy Bypass -File .\04_SCRIPTS\preflight-windows.ps1 -TestWriteAccess
powershell -ExecutionPolicy Bypass -File .\04_SCRIPTS\install-agent-engineering.ps1 -WhatIf
powershell -ExecutionPolicy Bypass -File .\04_SCRIPTS\install-agent-engineering.ps1
powershell -ExecutionPolicy Bypass -File $HOME\.agent-engineering\scripts\refresh-machine-profile.ps1
powershell -ExecutionPolicy Bypass -File $HOME\.agent-engineering\scripts\verify-agent-engineering.ps1
```
If upgrading an older installation, add `-UpgradeCanonical` to both installer commands after reviewing the dry-run. If a non-empty Codex `AGENTS.override.md` suppresses the global `AGENTS.md`, inspect it and add `-IntegrateCodexOverride` only when integration is intended.

## Safety of the Setup Process
`-WhatIf` must not create backups, directories, files, or partial Skill installations. Installer conflict discovery happens before writes. Existing global Agent files are backed up before marker changes. Existing Machine Profile user policy is preserved and only missing current safety defaults are merged.

## Success State
File existence is insufficient. Static verification must pass first. `SETUP_VERIFIED` additionally requires actual loading and behavioral verification for every locally installed/used target using `00_GUIDE/09_AGENT_LOADING_SMOKE_TEST.md`.
