# Independent Review Checklist

## Declare Review Independence

- `R0_SELF_REVIEW`
- `R1_INDEPENDENT_CONTEXT_REVIEW`
- `R2_CROSS_AGENT_OR_MODEL_REVIEW`
- `R3_HUMAN_PRODUCT_ACCEPTANCE`

R0 is not formal Independent Review. Default formal minimum is R1 unless Project Contract requires stronger review.

## Reviewer Write Mode
Default `READ_ONLY`. Fixing requires closing Review and beginning a separate Builder/Fix activity.

## Validate Binding
Check Stage/Prompt/Project Contract/Toolkit/source baseline/run IDs/generated time.

## Core Trace

```text
Claim
→ Canonical Evidence
→ Real Data Path
→ Contract / Gate
→ Invariant
→ User-visible Result
```

## Evidence Integrity
Check score/timestamp mutation, test weakening, hidden exclusions, report/canonical mismatch, stale run IDs, configured runtime reported as actual runtime.

## Capability / Workspace Integrity
Check actual Agent access, dirty-overlap preservation, single-writer discipline, Reviewer read-only discipline.

## Contract Impact
Check changed semantics, validator/gate assumptions, contract updates, evidence mutation, Gate weakening.

## Real Path
Synthetic helper tests alone are insufficient for real-path claims.

## Parameter Identity
Verify Safety / Provisional / Pilot / Calibrated / Acceptance class and semantic role.

## External Research Promotion
Do not accept “industry does X” as proof this project froze X.

## Test Layers
Distinguish Unit / Path Integration / Real Runtime.

## Overdesign Check
Reject speculative new models/platforms/grouping/registries not required by current evidence.

## Human/Product Gate
Confirm Executor did not pre-fill Human acceptance.

## Result
PASS / PASS_WITH_NONBLOCKING_ITEMS / FAIL-CONTINUE_CURRENT_STAGE / READY_FOR_HUMAN_REVIEW / READY_FOR_NEXT_STAGE.
