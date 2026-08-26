# Project Agent Router
Canonical project semantics: `ENGINEERING_CONTRACT.md`. Do not duplicate business thresholds/state/acceptance/scoring here.

Use Work Class: SMALL_CHANGE / STAGE_WORK / FORMAL_ACCEPTANCE. Do not label risky work SMALL_CHANGE to avoid evidence.

Before terminal/filesystem/network/GPU/long-runtime work, read installed Machine Execution Profile if available and verify current Agent accessibility.

Workspace: one active Builder writer per worktree; Reviewer read-only by default; parallel Builders isolated; preserve dirty overlap.

Skills: contract-impact-check / stage-execution / independent-review.

Project paths:
```text
CURRENT_ROOT = <CURRENT_ROOT>
LEGACY_REFERENCE_ROOT = <OPTIONAL>
EXTERNAL_DATA_ROOT = <OPTIONAL>
```
Test: `<TEST_COMMAND>`.
No git add/commit/push without explicit authorization.
