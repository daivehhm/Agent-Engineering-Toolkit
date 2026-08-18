# Project Agent Rules

## Project Root

```text
CURRENT_ROOT = <CURRENT_ROOT>
LEGACY_REFERENCE_ROOT = <OPTIONAL>
EXTERNAL_DATA_ROOT = <OPTIONAL>
```

## Project Engineering Contract

For tasks that change:

- scoring / selection / routing / completeness
- schema / persistence semantics
- state transitions
- validator / gate behavior
- externally observable product semantics

MUST read:

```text
ENGINEERING_CONTRACT.md
```

and use `contract-impact-check` before editing.

Do not load the full contract for trivial typo/cosmetic tasks.

## Reusable Skills

- contract-impact-check
- stage-execution
- independent-review

## Safety / Git

- Respect read-only/legacy roots.
- Do not mutate canonical evidence to satisfy a Gate.
- No git add / commit / push unless explicitly authorized by the current task.

## Test Entry

```text
<TEST_COMMAND>
```
