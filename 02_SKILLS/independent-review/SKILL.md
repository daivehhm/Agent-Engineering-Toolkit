---
name: independent-review
description: Independently reviews a Review ZIP, code change, stage deliverable, runtime evidence, or implementation claim using Claim → Canonical Evidence → Run Binding → Real Path → Contract → Invariant. Use only when acting as an independent reviewer, not as the builder's ordinary self-check.
---

# Independent Review

Read:

`references/INDEPENDENT_REVIEW_CHECKLIST.md`

Do not accept the executor's narrative summary as the source of truth.

For each major claim trace:

```text
Claim
→ Canonical Evidence
→ Run/Task Binding
→ Real Path
→ Contract/Test Oracle
→ Invariant
→ Product Result
```

Return:

- stage conclusion
- blockers
- non-blockers
- whether current stage closes/continues
- one consolidated next stage task if needed
