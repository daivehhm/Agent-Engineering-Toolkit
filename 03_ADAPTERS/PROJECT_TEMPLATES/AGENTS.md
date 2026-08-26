# Project Agent Router

Canonical project semantics: `ENGINEERING_CONTRACT.md`.

For semantic changes, read it and use `contract-impact-check`.

Do NOT duplicate business thresholds/state semantics/acceptance criteria/scoring policy here.

Before terminal/filesystem/process/network/GPU/long-runtime work, read `%USERPROFILE%\.agent-engineering\MACHINE_EXECUTION_PROFILE.md` if installed and verify current Agent accessibility.

Cross-Agent defaults:
- one active Builder writer per worktree;
- Reviewer read-only by default;
- parallel Builders require isolated working trees;
- preserve unexplained dirty overlap.

Skills:
- contract-impact-check
- stage-execution
- independent-review

Project paths:

```text
CURRENT_ROOT = <CURRENT_ROOT>
LEGACY_REFERENCE_ROOT = <OPTIONAL>
EXTERNAL_DATA_ROOT = <OPTIONAL>
```

Test:

```text
<TEST_COMMAND>
```

No git add/commit/push without explicit authorization.
