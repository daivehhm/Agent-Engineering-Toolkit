# Codex / Claude Code / Antigravity Configuration Guide v1.2

## Codex

### Global instruction discovery

Effective Codex home:

```text
CODEX_HOME
```

if set, otherwise:

```text
~/.codex
```

At global scope:

```text
AGENTS.override.md
```

wins if non-empty; otherwise:

```text
AGENTS.md
```

Toolkit must be in the actually active file.

### User Skills

```text
~/.agents/skills/<skill>/SKILL.md
```

Codex project skills are discovered under `.agents/skills` from CWD upward to repo root.

---

# Claude Code

### Effective user config root

```text
CLAUDE_CONFIG_DIR
```

if set, otherwise:

```text
~/.claude
```

Windows default:

```text
%USERPROFILE%\.claude
```

### Global instructions

```text
<ClaudeHome>/CLAUDE.md
```

Claude supports `@path` imports, including absolute paths.

### Personal Skills

```text
<ClaudeHome>/skills/<skill>/SKILL.md
```

Project:

```text
.claude/skills/<skill>/SKILL.md
```

Claude reads `CLAUDE.md`, not `AGENTS.md` natively, so the project adapter imports:

```text
@AGENTS.md
```

---

# Antigravity IDE

### Global Rule

```text
~/.gemini/GEMINI.md
```

Rule files are limited to 12,000 characters.

### Global Skills

IDE uses Agent Skills folder format:

```text
~/.gemini/config/skills/<skill>/SKILL.md
```

### Workspace Rules

```text
<workspace>/.agents/rules/
```

Workspace rule activation is controlled by the IDE:

- Manual
- Always On
- Model Decision
- Glob

The Toolkit router recommends `Model Decision`.

Do not claim project Rule runtime activation until it is confirmed in the IDE.

---

# Antigravity CLI

The CLI shares global developer context:

```text
~/.gemini/GEMINI.md
```

Workspace context reads root:

```text
GEMINI.md
AGENTS.md
```

### CLI global Skills — important difference

The CLI global location is:

```text
~/.gemini/antigravity-cli/skills/
```

and the CLI documentation defines these as **flat Markdown skills**, e.g.:

```text
~/.gemini/antigravity-cli/skills/contract-impact-check.md
```

This is not the same physical layout as Antigravity IDE.

v1.2 generates flattened CLI Skill files from the canonical folder Skill plus its reference document.

### CLI workspace Skills

CLI workspace Skills are flat Markdown files under:

```text
<workspace>/.agents/skills/
```

Do not blindly copy IDE `SKILL.md` folders to the CLI global path.

---

# CODEX.md

`CODEX.md` remains optional compatibility only.

Codex official discovery uses `AGENTS.md`.

---

# Runtime verification

Configuration paths are necessary but not sufficient.

After disk Verify, perform the real session tests in:

```text
00_GUIDE/09_AGENT_LOADING_SMOKE_TEST.md
```
