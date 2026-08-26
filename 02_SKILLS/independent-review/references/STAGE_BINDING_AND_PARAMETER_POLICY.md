# Stage Binding and Parameter Policy

## Formal Stage Binding

```yaml
stage_id:
stage_contract_version:
prompt_version:
project_contract_version:
toolkit_version:
machine_profile_schema_version:
source_baseline:
git_state_or_non_git_baseline:
runtime_run_ids:
generated_at:
```

No SHA/SHA256 required by this Toolkit.

## Binding Rule

Do not silently evaluate old execution evidence against a materially newer Stage Contract.

## External Research Is Not Automatically a Requirement

Classify as:

```text
REFERENCE
HYPOTHESIS
CANDIDATE_PRACTICE
PROJECT_ADOPTED_REQUIREMENT
CALIBRATED_RULE
```

Industry/vendor practice requires explicit adoption before becoming project requirement.

## Parameter Identity

Classes:

```text
SAFETY_LIMIT
PROVISIONAL_DEFAULT
PILOT_OVERRIDE
CALIBRATED_THRESHOLD
ACCEPTANCE_THRESHOLD
```

### SAFETY_LIMIT
Protects resources/safety/corruption. Not automatically quality optimum.

### PROVISIONAL_DEFAULT
Temporary pre-calibration default.

### PILOT_OVERRIDE
Temporary named Pilot setting. Not production truth.

### CALIBRATED_THRESHOLD
Chosen from documented calibration evidence.

### ACCEPTANCE_THRESHOLD
Formal pass/fail criterion frozen before acceptance/holdout.

## Parameter Record

| Parameter | Semantic Role | Class | Scope | Value | Evidence/Source | Change Authority |
|---|---|---|---|---|---|---|
| | | | | | | |

Do not reuse one numeric value across different semantics without contract evidence.

## Holdout Integrity

Once criteria are frozen:

- do not tune against holdout inline;
- preserve failure evidence;
- perform separately authorized correction;
- rerun only according to Project acceptance contract.
