# Evidence Contract v1.5

## Source-of-Truth Hierarchy
`Canonical raw runtime artifact > machine-derived metric > derived report > narrative summary`.

## Immutable Evidence
Raw scores, timestamps, provider response IDs, state transitions, ffprobe results, raw test/build results, benchmark measurements, qualification reasons, and command exit codes must not be rewritten merely to obtain PASS.

## Derived Decision Evidence
Add fields such as `selection_reason`, `coverage_rank`, `policy_version`, `final_rank`; do not overwrite intrinsic evidence.

## Runtime Provenance
Distinguish `configured`, `requested`, `attempted`, `actual-successful`, and `fallback`.

## Critical Command Evidence
Formal Stage critical commands follow `CRITICAL_COMMAND_EVIDENCE_CONTRACT.md`: key commands only, append reruns, redact secrets, no full environment dump, bounded outputs referenced by path.

## External Deterministic Systems
CI, build, lint, type check, security scan, test runner, ffprobe, and migration verifier may be Canonical Evidence Sources. They are not the final Review Authority.

## Stage / Run Binding
Formal reports identify Stage ID/version, Work Class, Prompt version, Project Contract version, Toolkit version, source baseline, run/artifact IDs, and required Review level.

## Stage Outcome
`stage_outcome.json` is a derived summary; canonical evidence outranks it.

## Review Independence
Executor narrative is evidence of what the Executor claims, not proof that the claim is correct.
