# Example Stage Prompt v1.2

## Role

Builder Agent

## Stage Goal

Make the existing real-user workflow complete and independently reviewable.

## Known Defects

- `<evidence-backed defect A>`
- `<evidence-backed defect B>`

## Contracts

If the task changes business semantics:

1. read `ENGINEERING_CONTRACT.md`;
2. use `contract-impact-check`;
3. record affected validator/gate/test oracle and immutable evidence.

## Baseline Evidence

Capture the minimum failing Before evidence:

```text
run/task ID
input
expected
actual
```

## Required Evidence

1. Unit / invariant test
2. Real-path integration
3. Real runtime replay
4. Canonical task/run IDs
5. `claim_evidence_matrix.md`
6. Review ZIP

## Test Integrity

Do not delete/weaken tests to make the implementation green.

If a contract changes, explain why the old test oracle is obsolete and what replaces it.

## Exit

Do not self-approve formal acceptance.

Return an executor status such as:

```text
IMPLEMENTATION_COMPLETE_FOR_INDEPENDENT_REVIEW
```
