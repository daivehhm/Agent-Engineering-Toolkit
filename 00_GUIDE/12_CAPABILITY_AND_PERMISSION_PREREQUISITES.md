# Capability and Permission Prerequisites

## Any Agent can understand the package; not every Agent can physically apply it.

Required local capabilities:

- native Windows PowerShell command execution
- read access to extracted package
- write access, with user approval when needed, to:
  - Codex home
  - Claude config home
  - `~/.gemini`
  - `~/.agents`
- ability to launch target Agent for runtime smoke test if claiming runtime verification

## Antigravity IDE caveat

Antigravity IDE can restrict non-workspace file access.

Do not disable or weaken that protection just to install this Toolkit.

Use one of:

1. user-approved terminal command with required access
2. an Agent surface that already has authorized user-profile access
3. user manually runs the supplied PowerShell command

If access remains denied:

```text
SETUP_BLOCKED
```

is correct.

## Codex / Claude sandbox caveat

If current sandbox only allows repository writes, writing user-profile configuration may require explicit approval.

Request approval; do not bypass sandbox.

## What the Toolkit never needs

- administrator privileges for normal user-level configuration
- API keys
- cookies
- browser profile data
- application authentication tokens
- disabling security features
