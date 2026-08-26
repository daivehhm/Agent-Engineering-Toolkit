# Agent Engineering Global Invariants

## Hard Invariants

1. **Evidence Is Immutable** — do not rewrite observed/scored/runtime evidence merely to satisfy a Gate, Validator, test, report, or desired conclusion.
2. **Business Semantic Change Requires Contract Impact** — if scoring/selection/routing/schema/state/validator/gate/persistence/external behavior changes, check contract impact.
3. **Feature Done Requires Real Path Reachability** — important capability completion requires Unit/Invariants + Real Path Integration + Real Runtime Evidence.
4. **Canonical Runtime Evidence Is Source of Truth** — Canonical Runtime Artifact → Metrics → Report.
5. **Test Integrity** — PASS comes from actual runner/exit/failure evidence; do not weaken tests merely to create green output.
6. **Executor Does Not Self-Approve Formal PASS** — Builder exits with `IMPLEMENTATION_COMPLETE_FOR_INDEPENDENT_REVIEW` or `EXECUTION_BLOCKED`.
7. **Project Semantics Have One Canonical Source** — Agent adapters route; they do not maintain separate business-spec copies.
8. **Formal Evidence Must Be Bound** — identify Stage/Prompt/Project Contract/Toolkit/source baseline/runtime run.

## Workflow Defaults

A. **Capability Preflight Before Real Execution** — Machine capability does not imply current Agent access.

B. **Single Writer per Worktree** — one active Builder writer per worktree; Reviewer read-only by default; parallel Builders use isolated working trees.

C. **Prefer Stage-Level Outcomes** — one Stage = one verifiable result; avoid one Phase per Medium/Low issue.

D. **Minimal Runnable Loop Before Expensive Acceptance** — minimal loop → real Pilot → targeted correction → formal calibration/holdout.

E. **Avoid Speculative Architecture** — no platform/registry/event bus/vector DB/new model/multi-agent framework/rules engine/governance service without current evidence.

F. **External Research Is Evidence, Not Automatic Requirement** — vendor/industry recommendations begin as reference/hypothesis/candidate practice.

G. **Separate Builder / Reviewer / Commit** — no git add/commit/push without explicit authorization.

H. **Human Product Judgment Is Not Auto-Filled** — Executor prepares blank Human review material when required.

I. **Review Package Must Be Reviewable** — include sufficient diff/tests/runtime evidence/binding/Git state; exclude secrets/private bulk data/node_modules/model weights/nested archives by default; no SHA/SHA256 manifest required.
