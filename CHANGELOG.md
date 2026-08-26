# Changelog

## 1.5.0 — Evidence & Consistency Closure

### Active documentation consistency
- README is current-only; embedded legacy active documentation removed.
- Overview uses the six-layer model only.
- Active configuration/operations/loading guides rewritten as current canonical documentation.
- History remains in CHANGELOG/Migration docs instead of append-only active bodies.

### Work Class
Added `SMALL_CHANGE`, `STAGE_WORK`, `FORMAL_ACCEPTANCE`. No lenient/standard/strict modes.

### Critical Command Evidence
Added canonical contract and JSONL template for key command evidence, preserving exit codes and requiring secret redaction. No shell interceptor, daemon, or Receipt DB.

### Minimal Stage Outcome
Added canonical `stage_outcome.json` contract/template to accumulate review rounds, blockers, false sign-off, Unit/Path/Runtime, and Human Gate outcomes. No Evaluation Platform/dashboard.

### Review Package
Formal Stage packages now standardize binding, Claim-Evidence Matrix, Critical Command Evidence, Stage Outcome, bounded tests/runtime/diff evidence, Git state, and Human sheet when required.

### Deferred candidates
Added evidence-triggered future candidates for automated command capture, evaluation aggregation, MCP/CI adapters, and enterprise policy integration.

### Architecture boundary
Still exactly three procedural Skills: contract-impact-check, stage-execution, independent-review. No MCP Server, DB, Dashboard, Receipt Server, Agent Manager, Policy Engine, or centralized lock.

## 1.4.0

- Added Machine Execution Profile and refresh script.
- Added six-layer scope model.
- Added capability preflight.
- Added Single Writer per Worktree.
- Added R0/R1/R2/R3 review independence.
- Added Project semantic single-source rule.
- Added Stage/Prompt/Contract/Toolkit/source/run binding.
- Added external-research promotion boundary.
- Added parameter identity classes.
- Bootstrap supports ContractVersion.
- Verify checks Machine Profile/adapters.
- No new procedural Skill or governance platform.

## 1.3.0

### Product-level documentation completion

Added:

- `00_OVERVIEW.md`
- `13_USAGE_SCENARIOS_AND_DECISION_TREE.md`
- `14_ROLES_LIFECYCLE_AND_SUCCESS_CRITERIA.md`

The package now explicitly and centrally explains:

- what the Toolkit is;
- why it exists;
- its goals;
- problems it solves;
- what it is not;
- when to use it;
- when not to use it;
- Builder / Reviewer / Human roles;
- complete lifecycle;
- Stage definition;
- configuration success criteria;
- engineering success criteria;
- Toolkit long-term value criteria.

No new governance platform or new procedural Skill was introduced.

## 1.2.0

### Critical correctness fixes

- Added an agent-neutral setup entrypoint.
- Corrected Antigravity CLI global Skill layout to flat Markdown files.
- Added native Windows preflight and WSL fail-closed behavior.
- Added target write-access probes.
- Skill sync now pre-scans all unmanaged conflicts before writes.
- Fixed `-WhatIf` backup/directory side effects.
- Fixed destructive interaction between `-Force` and `-IntegrateExisting`.
- Verify now validates Antigravity IDE and CLI using their distinct real layouts.
- Added explicit setup outcome states and per-agent runtime loading requirements.

### Documentation

- Added Any-Agent Windows Installation Playbook.
- Added capability/permission prerequisites.
- Updated deployment matrix and official-source notes.
- Added setup prompt usable with any local Agent.

## 1.1.0

- Split Hard Invariants from Workflow Defaults.
- Added Test Integrity Contract and Claim-Evidence Matrix.
- Added CODEX_HOME / CLAUDE_CONFIG_DIR awareness.
- Added Codex AGENTS.override detection.
- Added safer same-name Skill migration/conflict behavior.
- Added package/static vs runtime loading distinction.

## 1.0.0

Initial cross-Agent Toolkit.
