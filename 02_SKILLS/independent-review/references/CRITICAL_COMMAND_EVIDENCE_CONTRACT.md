# Critical Command Evidence Contract

## Purpose
Record commands that materially support important Stage claims. Do not record the entire terminal history.

## Required Fields
```json
{"stage_id":"STAGE_ID","command":"python -m pytest ...","cwd":"D:\\project","started_at":"2026-01-01T12:00:00+08:00","exit_code":0,"evidence_path":"tests/full_regression.txt","evidence_class":"TEST"}
```

Evidence classes: `TEST`, `BUILD`, `RUNTIME`, `VALIDATION`, `MIGRATION`, `BENCHMARK`, `OTHER_CRITICAL`.

Record focused/regression tests, builds, real runtime, migration, validation/ffprobe, benchmark, and formal acceptance commands when they support a claim.

Do not record every `dir`, `cat`, search command, full shell history, or full environment dump by default.

## Secret Safety
Redact token, password, cookie, Authorization header, and `.env` contents. Prefer `<REDACTED_SECRET>`.

## Integrity
- Keep raw command exit code.
- A rerun appends a new record; it does not overwrite the failed record.
- Large raw output belongs in a bounded evidence file referenced by `evidence_path`.
