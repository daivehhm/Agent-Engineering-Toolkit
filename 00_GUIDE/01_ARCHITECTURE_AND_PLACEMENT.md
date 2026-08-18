# Architecture and Placement v1.2

## 1. Agent-neutral Canonical Source

Single long-term editing source:

```text
%USERPROFILE%\.agent-engineering\
```

Do not use `.codex`, `.claude`, or `.gemini` as the canonical source. They are vendor adapters / installed copies.

## 2. Four layers

### Layer 1 — Global Hard Invariants + Workflow Defaults

Always-On, intentionally concise:

```text
01_AGENT_ENGINEERING_INVARIANTS.md
```

### Layer 2 — Cross-Agent Skills

On-demand:

```text
contract-impact-check
stage-execution
independent-review
```

### Layer 3 — Project Engineering Contract

Long-lived project semantics:

```text
ENGINEERING_CONTRACT.md
```

Read when the task changes product/contracts; do not force-load it for every typo.

### Layer 4 — Task / Stage Prompt

Contains only current outcome, evidence-backed defects, boundaries, and acceptance evidence.

---

# 3. Vendor adapters are not physically identical

## Codex

```text
<CODEX_HOME or ~/.codex>/AGENTS(.override).md
~/.agents/skills/<skill>/SKILL.md
```

## Claude Code

```text
<CLAUDE_CONFIG_DIR or ~/.claude>/CLAUDE.md
<ClaudeHome>/skills/<skill>/SKILL.md
```

## Antigravity IDE

```text
~/.gemini/GEMINI.md
~/.gemini/config/skills/<skill>/SKILL.md
workspace/.agents/rules/
workspace/.agents/skills/<skill>/SKILL.md
```

## Antigravity CLI

```text
~/.gemini/GEMINI.md
~/.gemini/antigravity-cli/skills/<skill>.md
workspace/AGENTS.md or GEMINI.md
workspace/.agents/skills/<name>.md
```

The CLI Skill layout is intentionally different from the IDE layout.

---

# 4. Setup correctness is also evidence-driven

```text
Package Self-Test
→ Native Windows Preflight
→ Non-mutating Dry-Run
→ Install
→ Disk Verify
→ Real Agent Loading Smoke
```

A file existing on disk is not proof that the Agent loaded it.

---

# 5. No governance platform

Toolkit remains:

```text
Markdown contracts
+ three Skills
+ small deterministic PowerShell setup/verify scripts
```

No daemon, database, policy server, registry service, or event bus.
