# Codex / Claude Code / Antigravity Configuration Guide v1.5

## Shared Canonical Source
Global invariants, Machine Profile, and canonical Skills live under `%USERPROFILE%\.agent-engineering\`.

## Codex
Global instructions use effective `CODEX_HOME` and active AGENTS file. User Skills use `$HOME/.agents/skills/<skill>/SKILL.md`.

## Claude Code
User instructions use effective Claude config home and `CLAUDE.md`. User Skills use `<ClaudeHome>/skills/<skill>/SKILL.md`. Claude adapter imports Global Invariants and Machine Profile.

## Antigravity IDE
Global rule uses `~/.gemini/GEMINI.md`. Global IDE Skills use `~/.gemini/config/skills/<skill>/SKILL.md`.

## Antigravity CLI
Global context uses `~/.gemini/GEMINI.md`. Global CLI Skills are flat Markdown files under `~/.gemini/antigravity-cli/skills/<skill>.md`.

## Common Rule
Vendor adapters contain loading/tool/sandbox details only. Project semantics stay in `ENGINEERING_CONTRACT.md`.

## Capability
Machine tool discovery is not Agent-session permission. STAGE_WORK / FORMAL_ACCEPTANCE performs Capability Preflight.
