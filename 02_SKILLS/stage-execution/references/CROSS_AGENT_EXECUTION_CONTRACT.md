# Cross-Agent Execution Contract

## Capability Preflight
Machine Profile is machine fact, not Agent permission. Verify critical capabilities in the current session. Missing required capability => `EXECUTION_BLOCKED`. Do not weaken sandbox/security merely to gain access.

## Safety Inheritance
`01_AGENT_ENGINEERING_INVARIANTS.md` applies to main Agents, subagents, delegated shell/tool execution, scripts launched by an Agent, and alternate execution paths. Vendor adapters and project routers MUST NOT create a bypass. Project/Stage rules may be stricter, never weaker.

`FS_SEARCH_SAFETY_V1` is therefore inherited across all supported Agents and subagents. A delegated search is still the originating Agent's responsibility.

## Single Writer per Worktree
```text
one worktree/workspace → one active Builder with write authority
```
Independent Reviewer is read-only by default. Parallel Builders require isolated working trees.

## Review Independence Levels
- R0_SELF_REVIEW
- R1_INDEPENDENT_CONTEXT_REVIEW
- R2_CROSS_AGENT_OR_MODEL_REVIEW
- R3_HUMAN_PRODUCT_ACCEPTANCE

## Project Semantics Source of Truth
Default canonical source: `ENGINEERING_CONTRACT.md`. AGENTS.md / CLAUDE.md / GEMINI.md are routers and MUST NOT maintain independent copies of project business semantics.

## Agent Vendor Is an Execution Carrier
Prefer Agent-neutral Stage Contracts. Vendor-specific content is limited to loading paths, tool invocation, sandbox behavior, Skill invocation, and runtime adapters.

## Work Classification
Use SMALL_CHANGE / STAGE_WORK / FORMAL_ACCEPTANCE. Work Class determines minimum process/evidence, not whether safety rules apply.
