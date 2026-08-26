# Stage Binding and Parameter Policy v1.5

Formal Stage execution/review packages record:
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
work_class:
required_review_level:
```
No SHA/SHA256 is required by this Toolkit.

Use `SMALL_CHANGE`, `STAGE_WORK`, or `FORMAL_ACCEPTANCE` according to `WORK_CLASS_POLICY.md`.

Do not silently evaluate old evidence against a materially newer contract.

External information is classified as `REFERENCE`, `HYPOTHESIS`, `CANDIDATE_PRACTICE`, `PROJECT_ADOPTED_REQUIREMENT`, or `CALIBRATED_RULE`.

Important parameters are classified as `SAFETY_LIMIT`, `PROVISIONAL_DEFAULT`, `PILOT_OVERRIDE`, `CALIBRATED_THRESHOLD`, or `ACCEPTANCE_THRESHOLD`.

For FORMAL_ACCEPTANCE: freeze criteria before the run, do not tune inline against holdout evidence, preserve failure evidence, and rerun only according to the Project acceptance contract.
