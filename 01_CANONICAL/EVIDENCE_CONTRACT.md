# Evidence Contract

## Source-of-Truth Hierarchy
Canonical raw runtime artifact > machine-derived metric > derived report > narrative summary.

## Immutable Evidence
Raw scores, timestamps, provider response IDs, state transitions, ffprobe results, raw test results, benchmark measurements, qualification reasons.

## Derived Decision Evidence
Add selection_reason / coverage_rank / policy_version / final_rank. Do not overwrite intrinsic evidence.

## Runtime Provenance
configured / requested / attempted / actual-successful / fallback.

## Stage / Run Binding
Formal report identifies Stage/Prompt/Project Contract/Toolkit/source baseline/task-run-artifact IDs.

## Report Derivation
Machine-derive test totals/counts/durations/pass-fail where canonical source exists.

## Review Independence
Executor narrative is a claim, not proof.
