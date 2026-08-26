# Review Package Standard v1.5

Required for STAGE_WORK and FORMAL_ACCEPTANCE; normally not required for SMALL_CHANGE.

Recommended structure:
```text
review_package/
├─ stage_binding.yaml
├─ claim_evidence_matrix.md
├─ critical_command_evidence.jsonl
├─ stage_outcome.json
├─ tests/
├─ runtime/
├─ diff/
├─ git_status.txt
├─ human_review_sheet.md       # only when needed
└─ manifest.md
```
Not every directory is required if genuinely not applicable.

Critical commands follow `CRITICAL_COMMAND_EVIDENCE_CONTRACT.md`. Stage outcome follows `STAGE_OUTCOME_CONTRACT.md`.

Include bounded raw/machine evidence sufficient to verify claims. Human review sheet remains blank when handed off by Executor.

Manifest uses relative paths; no SHA/SHA256 required by default.

Exclude secrets, `.env`, token/cookie, private bulk media, model files, node_modules, full DB, and nested archives by default.

Principle: enough to independently verify, not enough to reconstruct every keystroke.
