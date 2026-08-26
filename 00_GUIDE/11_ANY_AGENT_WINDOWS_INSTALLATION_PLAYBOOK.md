# Any-Agent Windows Installation Playbook v1.5

## Goal
Let any sufficiently capable local Agent configure AET on native Windows without prior conversation context, while failing closed on conflicts/permissions.

## Preconditions
- Native Windows PowerShell.
- User-profile write access when required.
- Toolkit ZIP extracted locally.
- Do not disable sandbox/non-workspace protection.

## Sequence
1. Read `00_START_HERE_FOR_ANY_AGENT.md`.
2. Run package self-test.
3. Run preflight with write-access probe.
4. Inspect CODEX_HOME, CLAUDE_CONFIG_DIR, Codex override, same-name Skills.
5. Run installer with `-WhatIf`.
6. Resolve REVIEW_REQUIRED/BLOCKED issues.
7. Install/upgrade.
8. Refresh Machine Profile.
9. Run Verify.
10. Run actual loading smoke for each installed Agent.
11. Produce Installation Report.

## Conflict Rules
Unknown unmanaged same-name Skill => fail closed.
Non-empty Codex override without Toolkit => inspect before integration.
Partial/unversioned canonical install => do not trust automatically; use explicit upgrade path after review.

## WhatIf Contract
No config writes, backup creation, project directory creation, or managed Skill mutation.

## Final States
Per Agent: CONFIGURED_AND_RUNTIME_VERIFIED / CONFIGURED_NOT_RUNTIME_VERIFIED / NOT_CONFIGURED / BLOCKED.
Machine: SETUP_VERIFIED / SETUP_PARTIALLY_VERIFIED / SETUP_BLOCKED.
