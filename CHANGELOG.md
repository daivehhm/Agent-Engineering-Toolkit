# Changelog

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
