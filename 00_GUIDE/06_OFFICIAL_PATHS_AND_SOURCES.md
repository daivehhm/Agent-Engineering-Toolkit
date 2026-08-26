# Official Paths and Sources — v1.5

Vendor-specific paths can change. Before changing adapter layout, verify current official vendor documentation. The six-layer model is AET architecture, not a vendor-native claim.

## OpenAI Codex
Global instruction discovery: `CODEX_HOME` (default `~/.codex`), `AGENTS.override.md > AGENTS.md`.
User Skills: `$HOME/.agents/skills/<skill>/SKILL.md`.
Official: https://developers.openai.com/codex/guides/agents-md ; https://developers.openai.com/codex/skills

## Anthropic Claude Code
Global instructions: `~/.claude/CLAUDE.md` or effective `CLAUDE_CONFIG_DIR`.
Personal Skills: `~/.claude/skills/<skill>/SKILL.md`.
Official: https://code.claude.com/docs/en/memory ; https://code.claude.com/docs/en/skills ; https://code.claude.com/docs/en/env-vars

## Google Antigravity IDE
Global Rule: `~/.gemini/GEMINI.md`; Workspace Rules: `.agents/rules/`; Global IDE Skills: `~/.gemini/config/skills/<skill>/SKILL.md`.
Official: https://antigravity.google/docs/rules-workflows ; https://antigravity.google/docs/skills

## Google Antigravity CLI
Global context: `~/.gemini/GEMINI.md`; Global CLI Skills: `~/.gemini/antigravity-cli/skills/<skill>.md`; Workspace CLI Skills: `.agents/skills/*.md`.
Official: https://antigravity.google/docs/cli/plugins ; https://antigravity.google/docs/cli/gcli-migration

## Update Policy
Vendor path changes update L2 adapters/scripts, not automatically L1 engineering invariants or L3 project semantics.
