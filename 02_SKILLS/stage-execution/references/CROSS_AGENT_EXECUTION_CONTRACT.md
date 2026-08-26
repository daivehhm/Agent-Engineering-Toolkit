# Cross-Agent Execution Contract

## Capability Preflight

Before real execution:

| Capability | Required | Machine Available | Current Agent Accessible | Evidence | Blocking |
|---|---:|---:|---:|---|---:|
| Project read | | | | | |
| Project write | | | | | |
| Terminal | | | | | |
| Required runtime | | | | | |
| Required binaries | | | | | |
| Network | | | | | |
| GPU | | | | | |
| Long-running execution | | | | | |
| Human review access | | | | | |

Rules:

- Machine Profile is machine fact, not Agent permission.
- Verify critical capabilities in the current session.
- Missing required capability => `EXECUTION_BLOCKED`.
- Do not weaken security/sandbox controls merely to gain access.

## Single Writer per Worktree

```text
one worktree/workspace
→ one active Builder with write authority
```

Independent Reviewer is read-only by default.

Parallel Builders require isolated working trees.

Before writing:

- capture Git status if available;
- identify pre-existing dirty files;
- preserve unexplained overlapping changes;
- never overwrite another Agent's uncommitted work just to proceed.

## Review Independence Levels

### R0_SELF_REVIEW
Same Agent + same context/session. Useful, but NOT independent.

### R1_INDEPENDENT_CONTEXT_REVIEW
Fresh session/context. Builder narrative is not treated as truth.
Minimum practical formal Stage review unless Project Contract requires stronger review.

### R2_CROSS_AGENT_OR_MODEL_REVIEW
Different Agent/product/model + fresh context.
Use for high risk, prior false sign-off, acceptance/holdout contamination risk, security/architecture/release stakes.

### R3_HUMAN_PRODUCT_ACCEPTANCE
For product quality that machine evidence cannot reliably establish.

Human acceptance does not replace engineering correctness review.

## Reviewer Write Boundary

Independent Reviewer defaults to `READ_ONLY`.

If fixing is required:

1. close/report Review;
2. explicitly switch to Builder/Fix;
3. create a new implementation evidence chain.

Do not edit during an independent Review and approve the modified result in the same act.

## Project Semantics Source of Truth

Each project declares one canonical Engineering Contract source.

Default:

```text
ENGINEERING_CONTRACT.md
```

AGENTS.md / CLAUDE.md / GEMINI.md are routers.

They MUST NOT maintain independent copies of business thresholds, state semantics, acceptance criteria, or scoring policy.

## Agent Vendor Is an Execution Carrier

Prefer Agent-neutral Stage Contracts.

Vendor-specific content is limited to loading paths, tool invocation, sandbox behavior, Skill invocation, and runtime adapters.


## Work Classification
Use SMALL_CHANGE / STAGE_WORK / FORMAL_ACCEPTANCE according to `WORK_CLASS_POLICY.md`. Work Class determines minimum process/evidence, not whether safety rules apply.
