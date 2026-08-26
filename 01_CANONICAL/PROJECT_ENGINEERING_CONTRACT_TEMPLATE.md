# <PROJECT_NAME> Engineering Contract

Contract-Version: <CONTRACT_VERSION>
Project-Scope: <CURRENT_ROOT>

> Canonical source for long-lived project product/engineering semantics. Agent adapters MUST NOT maintain separate copies.

## Product Goal
`<ONE_SENTENCE_PRODUCT_GOAL>`

## Canonical Objects
| Object | Authority | Semantics |
|---|---|---|
| | | |

## Immutable Evidence
## State Machine Invariants
## Validation / Gate Authority
## Persistence / Identity Contract
## Runtime Contract
Machine-wide facts belong in Machine Execution Profile; project-specific runtime requirements belong here.

## Work Classification Overrides
Default policy comes from `WORK_CLASS_POLICY.md`. A project may require a stronger minimum for specific operations, e.g. schema migration => STAGE_WORK, release holdout => FORMAL_ACCEPTANCE. It must not weaken global safety.

## Parameter Registry
| Parameter | Semantic Role | Class | Scope | Value | Evidence/Source | Change Authority |
|---|---|---|---|---|---|---|
Classes: SAFETY_LIMIT / PROVISIONAL_DEFAULT / PILOT_OVERRIDE / CALIBRATED_THRESHOLD / ACCEPTANCE_THRESHOLD.

## External Research Adoption Boundary
External information starts as REFERENCE / HYPOTHESIS / CANDIDATE_PRACTICE and becomes a frozen requirement only through explicit adoption/evidence/calibration.

## Review Independence Requirement
Default formal minimum: `R1_INDEPENDENT_CONTEXT_REVIEW`, unless project risk requires R2/R3.

## Review Evidence Contract
STAGE_WORK / FORMAL_ACCEPTANCE bind Stage/Prompt/Project Contract/source/run and include Claim-Evidence Matrix, Critical Command Evidence, Stage Outcome, tests/runtime evidence, and source/Git state.

## Deferred / Not Yet Frozen
