# Work Class Policy

## Purpose
Use the nature of work to determine minimum evidence/review requirements. Do not create `lenient / standard / strict` governance modes.

## SMALL_CHANGE
Use for typo, comments, cosmetic UI, or a completely local low-risk fix with no contract semantic change and no meaningful runtime acceptance risk.

Minimum: direct implementation + necessary local test/check.

Normally no formal Review Package, Independent Review, Stage Outcome, or Critical Command Evidence. Escalate if scope/risk expands.

## STAGE_WORK
Use for multi-file work, system-level bugs, semantic/schema/state/gate/validator changes, real runtime behavior, or formal stage closure.

Minimum: Capability Preflight; Writer/Workspace Preflight; Contract Impact when needed; Unit/Invariant; Real Path Integration; Real Runtime when required; Review Package; Independent Review; `stage_outcome.json`.

## FORMAL_ACCEPTANCE
Use for holdout, release acceptance, formal corpus, production readiness, formal benchmark, or expensive Human acceptance.

Minimum: all STAGE_WORK requirements + criteria frozen before acceptance + acceptance-threshold identity + exact binding + no inline tuning against acceptance evidence + required independent review + Human/Product Gate when applicable.

## Rule
Work Class is descriptive, not a bypass mechanism. Risky work cannot be labeled SMALL_CHANGE just to avoid evidence/review.
