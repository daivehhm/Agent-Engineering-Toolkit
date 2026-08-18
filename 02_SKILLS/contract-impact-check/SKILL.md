---
name: contract-impact-check
description: Checks contract impact before changing scoring, selection, routing, state transitions, schemas, validators, gates, persistence semantics, test oracles, or user-visible behavior. Use for semantic changes; do not use for typo-only or purely cosmetic edits.
---

# Contract Impact Check

Read:

`references/CONTRACT_IMPACT_CHECK.md`

Produce a compact matrix covering:

1. changed semantic
2. upstream/downstream
3. affected contract/gate
4. affected test oracle
5. immutable evidence
6. real data path
7. runtime proof
8. forbidden shortcuts

This is not a standalone phase. Continue the current task after the check unless a genuine blocker is found.
