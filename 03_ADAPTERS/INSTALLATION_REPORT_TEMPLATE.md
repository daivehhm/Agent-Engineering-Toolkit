# Agent Engineering Installation Report

## Machine Setup Result

Choose exactly one:

```text
SETUP_VERIFIED
SETUP_PARTIALLY_VERIFIED
SETUP_BLOCKED
```

## Environment

| Field | Value |
|---|---|
| Toolkit version | |
| Native Windows PowerShell | |
| Windows user profile | |
| Effective CODEX_HOME | |
| Effective CLAUDE_CONFIG_DIR | |
| Gemini home | |
| Package self-test | |
| Preflight result | |
| Disk Verify result | |

## Target Status

Allowed target states:

```text
CONFIGURED_AND_RUNTIME_VERIFIED
CONFIGURED_NOT_RUNTIME_VERIFIED
NOT_CONFIGURED
BLOCKED
```

| Target | Config path(s) | Config status | Runtime loading evidence | Final target state |
|---|---|---|---|---|
| Codex | | | | |
| Claude Code | | | | |
| Antigravity IDE | | | | |
| Antigravity CLI | | | | |

## Codex Override

```text
AGENTS.override.md present:
non-empty:
reviewed:
Toolkit integrated:
conflict:
```

## Skill Installation

| Target | contract-impact-check | stage-execution | independent-review |
|---|---|---|---|
| Codex | | | |
| Claude | | | |
| Antigravity IDE | | | |
| Antigravity CLI flat md | | | |

## Existing Configuration Preservation

```text
Backups created:
Existing unmanaged rules preserved:
Existing unmanaged same-name Skill conflicts:
Force replacement explicitly authorized:
```

## Runtime Smoke

### Codex

```text
global instructions loaded:
contract-impact-check loaded:
evidence:
```

### Claude Code

```text
CLAUDE.md loaded:
contract-impact-check loaded:
evidence:
```

### Antigravity IDE

```text
global rule loaded:
global Skill discovered:
workspace rule activation verified if applicable:
evidence:
```

### Antigravity CLI

```text
GEMINI.md loaded:
flat /contract-impact-check loaded:
evidence:
```

## Remaining Manual Actions

- [ ]

## Final Notes

Do not write `SETUP_VERIFIED` unless all locally installed targets are `CONFIGURED_AND_RUNTIME_VERIFIED`.
