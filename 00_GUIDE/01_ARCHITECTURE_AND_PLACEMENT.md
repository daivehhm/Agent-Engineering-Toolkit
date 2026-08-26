# Architecture and Placement v1.4

Canonical home:

```text
%USERPROFILE%\.agent-engineering\
```

Six layers:

```text
L0 Machine Execution Profile
L1 Global Engineering Invariants
L2 Agent Adapter / Capability
L3 Project Engineering Contract
L4 Stage Execution Contract
L5 Independent Review / Human Gate
```

Installed global layout:

```text
~/.agent-engineering/
├─ VERSION
├─ 01_AGENT_ENGINEERING_INVARIANTS.md
├─ MACHINE_EXECUTION_PROFILE.md
├─ canonical/
├─ skills/
├─ project-templates/
└─ scripts/
```

Project layout:

```text
<project>/
├─ AGENTS.md
├─ CLAUDE.md
├─ GEMINI.md
├─ ENGINEERING_CONTRACT.md
└─ .agents/rules/engineering-contract-router.md
```

Always-on content stays concise.
Detailed workflows live in Skills.
Project semantics load on demand.
