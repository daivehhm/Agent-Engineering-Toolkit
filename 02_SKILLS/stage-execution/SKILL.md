---
name: stage-execution
description: Executes a complete engineering implementation or fix stage with invariant tests, real-path integration, runtime evidence, canonical run binding, and a review package. Use for multi-file or stage-level work; avoid for tiny typo-only/local edits.
---

# Stage Execution

Read:

`references/STAGE_EXECUTION_TEMPLATE.md`

## Required behavior

- Work toward one verifiable stage result.
- If semantics/contracts change, use `contract-impact-check` first.
- Preserve intrinsic evidence.
- Preserve test integrity.
- Prove Unit → Path → Runtime.
- Bind reports to canonical run/task IDs.
- Produce `claim_evidence_matrix.md`.
- Avoid speculative platforms/frameworks.
- Do not self-approve formal Independent/Human/Release PASS.

## Exit

Use an executor status such as:

```text
IMPLEMENTATION_COMPLETE_FOR_INDEPENDENT_REVIEW
```

or:

```text
EXECUTION_BLOCKED
```
