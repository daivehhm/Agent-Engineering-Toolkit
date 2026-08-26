# Stage Execution Template

## Stage Binding

```yaml
stage_id: <STAGE_ID>
stage_contract_version: <VERSION>
prompt_version: <VERSION>
project_contract_version: <VERSION>
toolkit_version: <VERSION>
machine_profile_schema_version: <VERSION_OR_NA>
source_baseline: <GIT_OR_NON_GIT_BASELINE>
runtime_run_ids: []
```

## Stage Goal
One verifiable engineering/product result.

## Required Capabilities

| Capability | Required | Machine Available | Current Agent Accessible | Evidence | Blocking |
|---|---:|---:|---:|---|---:|
| Project read | | | | | |
| Project write | | | | | |
| Terminal | | | | | |
| Required runtime | | | | | |
| Required binaries | | | | | |
| Network | | | | | |
| GPU | | | | | |
| Long-running execution | | | | | |
| Human review access | | | | | |

Missing required capability => `EXECUTION_BLOCKED`.

## Writer / Workspace Preflight

- capture Git status;
- identify dirty files;
- confirm no unknown overlapping writer;
- preserve unexplained dirty overlap;
- one active Builder per worktree;
- parallel Builders require isolated working trees.

## Current Known Defects
Separate Observed Fact / Hypothesis / External Reference.

## Product Invariants
Read canonical Project Engineering Contract. Run Contract Impact Check for semantic changes.

## Contract Impact
Record semantic change, upstream/downstream, validator/gate/schema impact, immutable evidence, real path, runtime proof.

## Parameter Changes
Classify as SAFETY_LIMIT / PROVISIONAL_DEFAULT / PILOT_OVERRIDE / CALIBRATED_THRESHOLD / ACCEPTANCE_THRESHOLD.

## Allowed Scope
Writable/read-only files, network, external data, Git, generated artifacts.

## Implementation Principle
Minimal change; reuse existing capability; no speculative architecture; do not mutate evidence to satisfy old Gate.

## Required Evidence

1. Unit / Invariant
2. Real Path Integration
3. Real Runtime / Pilot

## Canonical Evidence
Declare task/run/artifact/DB/ffprobe/test-runner sources.

## Claim-Evidence Matrix

| Claim | Canonical Evidence | Real Path | Contract/Invariant | Run/Task Binding | Result |
|---|---|---|---|---|---|

## Review ZIP
Include binding, capability preflight, contract impact, diff/reviewcopy, tests, runtime evidence, claim-evidence matrix, commands, Git state, blank Human sheet if needed, manifest.

## Exit
Only `IMPLEMENTATION_COMPLETE_FOR_INDEPENDENT_REVIEW` or `EXECUTION_BLOCKED`.
