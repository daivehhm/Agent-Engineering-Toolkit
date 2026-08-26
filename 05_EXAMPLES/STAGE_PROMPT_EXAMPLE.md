# Stage Prompt Example v1.5
```yaml
stage_id: EXAMPLE-STAGE
stage_contract_version: 1.0
prompt_version: 1.0
project_contract_version: 0.3
toolkit_version: 1.5.0
source_baseline: <baseline>
runtime_run_ids: []
work_class: STAGE_WORK
required_review_level: R1
```
Goal: one verifiable Stage result. Perform capability/writer preflight. Read ENGINEERING_CONTRACT.md. Use contract-impact-check if semantics change. Prove Unit → Path → Runtime. Record critical commands only. Generate `stage_outcome.json`. Exit `IMPLEMENTATION_COMPLETE_FOR_INDEPENDENT_REVIEW`.
