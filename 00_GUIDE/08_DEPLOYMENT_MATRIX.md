# Deployment Matrix v1.2

| Capability | Codex | Claude Code | Antigravity IDE | Antigravity CLI |
|---|---|---|---|---|
| Global instructions | `$CODEX_HOME/AGENTS(.override).md` | `<ClaudeHome>/CLAUDE.md` | `~/.gemini/GEMINI.md` | `~/.gemini/GEMINI.md` |
| Global Skill layout | `~/.agents/skills/<skill>/SKILL.md` | `<ClaudeHome>/skills/<skill>/SKILL.md` | `~/.gemini/config/skills/<skill>/SKILL.md` | `~/.gemini/antigravity-cli/skills/<skill>.md` |
| Project instruction | `AGENTS.md` | `CLAUDE.md` | `.agents/rules/` | root `AGENTS.md` / `GEMINI.md` |
| Project Skill | `.agents/skills/<skill>/SKILL.md` | `.claude/skills/<skill>/SKILL.md` | `.agents/skills/<skill>/SKILL.md` | `.agents/skills/<name>.md` |
| Runtime smoke | new Codex session | `/context` + `/skill` | Rules/Skills UI + task | new `agy` + `/skill` |

## Canonical source

Toolkit canonical Skills remain open-standard folder Skills.

Only the Antigravity CLI adapter flattens them for its CLI-specific slash-command layout.
