# Any-Agent Windows Installation Playbook v1.2

## Question this playbook answers

> Can a local engineering Agent receive this ZIP with no prior context and safely configure Codex, Claude Code, Antigravity IDE, and Antigravity CLI on Windows?

Answer:

**Yes, provided the Agent has native Windows PowerShell access and permission to write the relevant user-profile configuration paths.**

The package cannot bypass product sandboxes or OS permissions.

---

# 1. Native Windows only

Do not run installation from WSL merely because the Windows drive is mounted.

Why:

```text
WSL $HOME != Windows %USERPROFILE%
```

and installing there can create a perfectly valid configuration in the wrong operating system profile.

`preflight-windows.ps1` fails closed outside native Windows.

---

# 2. Discovery before mutation

The setup Agent must discover:

```text
%USERPROFILE%
$HOME
CODEX_HOME
CLAUDE_CONFIG_DIR
codex executable
claude executable
agy executable
existing global instruction files
Codex AGENTS.override.md
same-name Skill conflicts
write access
```

No hardcoded username.

---


## Preflight status semantics

```text
BLOCKED
```

means the environment cannot safely continue yet, such as non-native Windows or failed write-access requirements.

```text
REVIEW_REQUIRED
```

means an existing user configuration must be inspected before deciding whether to integrate or replace it.

```text
READY_WITH_WARNINGS
```

means configuration can proceed, but one or more target products cannot yet be runtime-verified.

```text
READY
```

means no preflight blockers/review conflicts were found.


---

# 3. Vendor-specific layouts

## Codex

Global instruction:

```text
$CODEX_HOME/AGENTS.override.md
```

if non-empty, otherwise:

```text
$CODEX_HOME/AGENTS.md
```

Default `CODEX_HOME`:

```text
~/.codex
```

User Skills:

```text
~/.agents/skills/<skill>/SKILL.md
```

## Claude Code

User config root:

```text
CLAUDE_CONFIG_DIR
```

if set, otherwise:

```text
~/.claude
```

Global instructions:

```text
<ClaudeHome>/CLAUDE.md
```

Personal Skills:

```text
<ClaudeHome>/skills/<skill>/SKILL.md
```

## Antigravity IDE

Global Rule:

```text
~/.gemini/GEMINI.md
```

Global Skills use Agent Skills folder format:

```text
~/.gemini/config/skills/<skill>/SKILL.md
```

## Antigravity CLI

Global developer context:

```text
~/.gemini/GEMINI.md
```

Global CLI Skills use a **different flat-file layout**:

```text
~/.gemini/antigravity-cli/skills/<skill>.md
```

Do not copy the IDE `<skill>/SKILL.md` directory layout into this CLI directory.

Workspace CLI skills are also flat Markdown skills under:

```text
<workspace>/.agents/skills/
```

This distinction is a v1.2 critical correction.

---

# 4. Why self-test, verify, and smoke test are separate

```text
Package Self-Test
```

proves the ZIP is internally coherent.

```text
Verify
```

proves files were installed into the expected disk locations and match canonical content.

```text
Agent Loading Smoke Test
```

proves the actual target product loaded those files.

None of the three can replace another.

---

# 5. Existing configuration conflict policy

## Existing normal config

Preserve it. Toolkit uses marker blocks.

## Codex active override

If:

```text
AGENTS.override.md
```

is non-empty, it wins over global `AGENTS.md`.

The Agent must inspect it.

If compatible:
- backup
- integrate Toolkit marker block

If materially conflicting with a Hard Invariant:
- stop
- report conflict
- do not silently weaken either side

## Same-name Skill

If Toolkit-managed or recognized old Toolkit version:
- backup/migrate when needed

If unmanaged:
- stop by default

Never silently delete.

---

# 6. Dry-run semantics

`-WhatIf` is a contract:

> no config modification and no backup creation.

v1.2 fixes v1.1 code paths where backup helpers could still write during `-WhatIf`.

If a future version violates this, treat installer self-test/runtime verification as failed.

---

# 7. Existing project integration

For existing projects, use:

```text
-IntegrateExisting
```

The integration path must:

- preserve existing file body
- add/update only Toolkit marker block
- never first replace the file with the template

`-Force -IntegrateExisting` must still preserve existing adapter files and only force non-adapter template replacement where explicitly applicable.

---

# 8. No false universal success

An Agent cannot claim:

```text
Codex configured and verified
```

if Codex is not installed or has not been launched for a loading smoke test.

Use per-target states:

```text
CONFIGURED_AND_RUNTIME_VERIFIED
CONFIGURED_NOT_RUNTIME_VERIFIED
NOT_CONFIGURED
BLOCKED
```

The final machine state is the aggregation of these target states.
