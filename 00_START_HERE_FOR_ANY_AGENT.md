# START HERE — Any Agent Windows Setup Contract

## Purpose

If you are Codex, Claude Code, Antigravity, or another local engineering agent with Windows filesystem + PowerShell access, use this file as the authoritative entrypoint for configuring this Toolkit on the user's Windows machine.

Do **not** rely on prior conversation context.

## Scope

This package configures only:

- Agent Engineering global instructions/rules
- three reusable engineering skills
- optional project adapter files

It does **not**:

- install Codex / Claude Code / Antigravity
- change authentication/API keys
- change model/provider
- weaken sandbox/approval settings
- enable non-workspace access
- modify Git repositories unless the user separately asks for project bootstrap
- commit/push anything

## Preconditions

You may perform setup only when all are true:

1. You are operating through **native Windows PowerShell**, not WSL/Linux.
2. You can read this extracted package.
3. The user has asked you to configure the local machine.
4. You can write to the relevant user-profile config locations, or can request the required approval.
5. You will preserve existing configuration and stop on unresolved conflicts.

If any precondition fails, report `SETUP_BLOCKED` and explain the exact missing capability. Do not invent a workaround that bypasses sandbox or permissions.

---

# Mandatory Setup Sequence

## Step 1 — Read

Read, in order:

1. this file
2. `README.md`
3. `00_GUIDE/02_AGENT_CONFIGURATION_GUIDE.md`
4. `00_GUIDE/11_ANY_AGENT_WINDOWS_INSTALLATION_PLAYBOOK.md`

Do not read the whole package unless needed.

## Step 2 — Package self-test

From the extracted package root:

```powershell
powershell -ExecutionPolicy Bypass -File .\04_SCRIPTS\self-test-toolkit.ps1
```

Required:

```text
Toolkit Self-Test: PASS
```

If FAIL: stop. Do not install.

## Step 3 — Native Windows preflight

Run:

```powershell
powershell -ExecutionPolicy Bypass -File .\04_SCRIPTS\preflight-windows.ps1 -TestWriteAccess
```

Read the generated:

```text
agent-engineering-preflight.md
```

Do not proceed through a `BLOCKED` result.

If the result is `REVIEW_REQUIRED`, inspect and resolve every listed conflict before the actual install. This is not a failure; it is a deliberate human/Agent decision gate.

Important decisions:

- Non-empty active Codex `AGENTS.override.md` without Toolkit block:
  inspect it for conflicts before using `-IntegrateCodexOverride`.
- Existing same-name unmanaged Skill:
  do not use `-ForceManagedSkillOverwrite` automatically.
- Write-access failure:
  request the needed approval or stop.
- Missing application binary:
  configuration files may still be installed, but that target must remain `NOT_RUNTIME_VERIFIED`.

## Step 4 — Dry-run

Run:

```powershell
powershell -ExecutionPolicy Bypass -File .\04_SCRIPTS\install-agent-engineering.ps1 -WhatIf
```

If upgrading a previously installed different Toolkit version:

```powershell
powershell -ExecutionPolicy Bypass -File .\04_SCRIPTS\install-agent-engineering.ps1 -UpgradeCanonical -WhatIf
```

If an active Codex override has been independently reviewed and is compatible:

```powershell
... -IntegrateCodexOverride -WhatIf
```

**Dry-run must not create backups or modify configuration.**

## Step 5 — Install

Run the same command without `-WhatIf`.

Never add:

```text
-ForceManagedSkillOverwrite
```

unless the conflicting Skill was inspected and the user explicitly authorizes replacement.

## Step 6 — Disk/config verification

Run:

```powershell
powershell -ExecutionPolicy Bypass -File $HOME\.agent-engineering\scripts\verify-agent-engineering.ps1
```

Required before runtime smoke test:

```text
Verification: PASS
```

`PASS_WITH_WARNINGS` is not equivalent to fully verified; inspect every warning.

## Step 7 — Real loading smoke test

Follow:

```text
00_GUIDE/09_AGENT_LOADING_SMOKE_TEST.md
```

Test every installed target that is actually available:

- Codex
- Claude Code
- Antigravity IDE
- Antigravity CLI

Do not claim a missing/unlaunched product passed.

## Step 8 — Final installation report

Create:

```text
agent-engineering-installation-report.md
```

Use:

```text
03_ADAPTERS/INSTALLATION_REPORT_TEMPLATE.md
```

Record:

```text
Toolkit version
native Windows confirmed
package self-test
preflight status
effective CODEX_HOME
effective CLAUDE_CONFIG_DIR
global adapter paths
Codex override status
Skill destinations
Antigravity IDE skill result
Antigravity CLI flat-skill result
verify result
runtime loading smoke result per agent
backups created
conflicts encountered
manual actions remaining
```

Final state must be exactly one:

```text
SETUP_VERIFIED
SETUP_PARTIALLY_VERIFIED
SETUP_BLOCKED
```

Use:

- `SETUP_VERIFIED` only when disk verification passes and every locally installed target has passed its real loading smoke test.
- `SETUP_PARTIALLY_VERIFIED` when configuration is correct but one or more products are not installed/launchable for runtime verification.
- `SETUP_BLOCKED` for unresolved conflict, permission, script, or loading failure.

---

# Project Bootstrap Is Separate

Do not modify a project merely because global setup succeeded.

If the user explicitly asks to configure a project, use:

```powershell
$HOME\.agent-engineering\scripts\bootstrap-project.ps1 -ProjectRoot "<PATH>" -TestCommand "<COMMAND>" -WhatIf
```

For an existing project with existing `AGENTS.md / CLAUDE.md / GEMINI.md`, prefer:

```text
-IntegrateExisting
```

This must merge Toolkit marker blocks without replacing unrelated existing content.

---

# Hard Safety Rules

- No secret/token/cookie/.env reads are required.
- Do not change authentication.
- Do not loosen agent permissions to make setup easier.
- Do not overwrite unmanaged same-name Skills without explicit authorization.
- Do not treat `file exists` as `Agent loaded it`.
- Do not treat `verify PASS` as runtime loading PASS.
- Do not report success from narrative output when a script exit/result says FAIL.


---

# v1.4 Machine Execution Profile

安装后创建/保留：

```text
%USERPROFILE%\.agent-engineering\MACHINE_EXECUTION_PROFILE.md
```

刷新：

```powershell
$HOME\.agent-engineering\scripts\refresh-machine-profile.ps1
```

Machine discovery 不是当前 Agent 权限证明；真实 Stage 仍需 Capability Preflight。
