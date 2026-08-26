# Independent Review Checklist v1.5

## Review Independence
Declare `R0_SELF_REVIEW`, `R1_INDEPENDENT_CONTEXT_REVIEW`, `R2_CROSS_AGENT_OR_MODEL_REVIEW`, or `R3_HUMAN_PRODUCT_ACCEPTANCE`. R0 is not formal Independent Review.

Reviewer defaults to `READ_ONLY`; fixing requires closing Review and beginning a separate Builder/Fix evidence chain.

## Work Class / Binding
Verify Work Class was not used to bypass evidence. Check Stage ID/version, Work Class, required Review level, Prompt version, Project Contract version, Toolkit version, source baseline, and run IDs.

## Core Trace
`Claim → Canonical Evidence → Real Data Path → Contract/Gate → Invariant → User-visible Result`.

## Critical Command Evidence
Check key commands exist, exit codes are preserved, reruns append rather than rewrite, evidence paths resolve, secrets are redacted, and full environment dumps are not default evidence.

## Evidence Integrity
Check for score/timestamp mutation, hidden failures, test weakening, manual report count drift, stale run IDs, configured runtime presented as actual runtime, and failed command evidence removed after rerun.

## Capability / Workspace Integrity
Verify current Agent capability, Single Writer, dirty-overlap preservation, and Reviewer read-only behavior.

## Test Layers
Distinguish Unit, Path Integration, and Real Runtime.

## External Evidence Sources
CI/build/lint/security scan may support claims but do not automatically grant Stage PASS.

## Formal Acceptance
Verify criteria were frozen, inline holdout tuning did not occur, failure evidence was preserved, and rerun policy was followed.

## Stage Outcome
Verify `stage_outcome.json` agrees with canonical evidence; canonical evidence wins on conflict.

## Result
May output PASS, PASS_WITH_NONBLOCKING_ITEMS, FAIL/CONTINUE_CURRENT_STAGE, READY_FOR_HUMAN_REVIEW, or READY_FOR_NEXT_STAGE. Separate Blocker / Non-blocker.
