# Stage Execution Template v1.5

## Stage Binding
```yaml
stage_id: <STAGE_ID>
stage_contract_version: <VERSION>
prompt_version: <VERSION>
project_contract_version: <VERSION>
toolkit_version: 1.5.0
machine_profile_schema_version: <VERSION_OR_NA>
source_baseline: <GIT_OR_NON_GIT_BASELINE>
runtime_run_ids: []
work_class: SMALL_CHANGE | STAGE_WORK | FORMAL_ACCEPTANCE
required_review_level: R0 | R1 | R2 | R3
```

## Goal
One verifiable engineering/product result. Do not define a Stage as a list of micro-fixes.

## Work Class
Read `WORK_CLASS_POLICY.md`. SMALL_CHANGE should not incur formal-stage overhead unless risk expands. STAGE_WORK and FORMAL_ACCEPTANCE use the formal requirements below.

## Required Capabilities
Record Required / Machine Available / Current Agent Accessible / Evidence / Blocking for project read/write, terminal, runtime, binaries, network, GPU, long-running execution, and Human review access. Missing required capability => `EXECUTION_BLOCKED`.

## Writer / Workspace Preflight
Capture Git status, identify dirty files, confirm no unknown overlapping writer, preserve unexplained dirty overlap, allow one active Builder per worktree, and isolate parallel Builders.

## Current Known Defects
Separate `Observed Fact`, `Hypothesis`, and `External Reference`.

## Product Contract
Read canonical `ENGINEERING_CONTRACT.md`. Use `contract-impact-check` when business semantics change.

## Parameter Changes
Classify important values as Safety / Provisional / Pilot / Calibrated / Acceptance.

## Critical Command Evidence
For key commands only record: `stage_id`, `command`, `cwd`, `started_at`, `exit_code`, `evidence_path`, `evidence_class`. Redact secrets; do not capture full terminal history or environment by default.

## Required Evidence
1. Unit / Invariant
2. Real Path Integration
3. Real Runtime / Pilot when required

CI/build/lint/security scan may be evidence sources, but not final Review Authority.

## Claim-Evidence Matrix
| Claim | Canonical Evidence | Real Path | Contract/Invariant | Binding | Result |
|---|---|---|---|---|---|

## Stage Outcome
STAGE_WORK and FORMAL_ACCEPTANCE produce `stage_outcome.json` using the canonical contract.

## Review Package
Recommended artifacts: `stage_binding.yaml`, `claim_evidence_matrix.md`, `critical_command_evidence.jsonl`, `stage_outcome.json`, bounded tests/runtime/diff evidence, `git_status.txt`, blank `human_review_sheet.md` when required, and `manifest.md`.

## Formal Acceptance
Freeze criteria before acceptance, prohibit inline tuning against holdout evidence, preserve failures, and follow rerun policy.

## Exit
Only `IMPLEMENTATION_COMPLETE_FOR_INDEPENDENT_REVIEW` or `EXECUTION_BLOCKED`. Formal PASS/READY belongs to Review/Human authority.
