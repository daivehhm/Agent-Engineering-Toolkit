# Cross-Agent Execution and Review Protocol

## Same Stage, Different Agent
Keep Stage business contract Agent-neutral whenever possible.

## Capability
Separate:
1. Stage requirement
2. Machine availability
3. Current Agent accessibility

## Single Writer
One Builder writer per worktree.
Reviewer read-only.
Parallel Builders use isolated working trees.

## Dirty Overlap
Preserve pre-existing overlapping changes and require explicit continuation authorization.

## Review Independence
R0 same-session self-review.
R1 fresh context.
R2 different Agent/model.
R3 Human/Product.

## Source of Truth
ENGINEERING_CONTRACT.md owns project semantics. Adapters route.

## External Research
Reference/Hypothesis/Candidate Practice != frozen requirement.

## Parameters
Safety / Provisional / Pilot / Calibrated / Acceptance are different semantic classes.

## Anti-overdesign
No manager/registry/lock server/policy daemon is introduced.
