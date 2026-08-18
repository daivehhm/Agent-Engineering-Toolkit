# Official Path Sources — verified 2026-08-18

This file records vendor documentation used for v1.2 adapters.

## OpenAI Codex

Global instruction discovery:

```text
CODEX_HOME (default ~/.codex)
AGENTS.override.md > AGENTS.md
```

User Skills:

```text
$HOME/.agents/skills/<skill>/SKILL.md
```

Official:
- https://developers.openai.com/codex/guides/agents-md
- https://developers.openai.com/codex/skills
- https://developers.openai.com/codex/learn/best-practices

## Anthropic Claude Code

Windows user config:

```text
%USERPROFILE%\.claude
```

or `CLAUDE_CONFIG_DIR`.

Global instructions:

```text
~/.claude/CLAUDE.md
```

Personal Skills:

```text
~/.claude/skills/<skill>/SKILL.md
```

Claude `CLAUDE.md` supports `@path` imports.

Official:
- https://code.claude.com/docs/en/memory
- https://code.claude.com/docs/en/claude-directory
- https://code.claude.com/docs/en/skills
- https://code.claude.com/docs/en/env-vars

## Google Antigravity IDE

Global Rule:

```text
~/.gemini/GEMINI.md
```

Workspace Rules:

```text
.agents/rules/
```

Global IDE Skills:

```text
~/.gemini/config/skills/<skill>/SKILL.md
```

Official:
- https://antigravity.google/docs/rules-workflows
- https://antigravity.google/docs/skills

## Google Antigravity CLI

Global developer context:

```text
~/.gemini/GEMINI.md
```

Global CLI Skills:

```text
~/.gemini/antigravity-cli/skills/<skill>.md
```

Workspace CLI Skills:

```text
.agents/skills/*.md
```

Official:
- https://antigravity.google/docs/cli/plugins
- https://antigravity.google/docs/cli/gcli-migration
- https://antigravity.google/docs/cli/best-practices

## Update policy

Vendor product paths can change.

If a future product release disagrees with this file:

1. verify official docs;
2. update adapter + scripts;
3. do not change the canonical engineering invariants unless the engineering principle itself changed.
