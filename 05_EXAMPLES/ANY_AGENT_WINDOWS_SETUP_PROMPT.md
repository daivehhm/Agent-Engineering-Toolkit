# Prompt to give any local Agent

Configure the Windows local Agent Engineering Toolkit from the attached/extracted package.

First read:

`00_START_HERE_FOR_ANY_AGENT.md`

Then follow it exactly.

Requirements:

- Native Windows only; do not install through WSL.
- Run package self-test first.
- Run Windows preflight with write-access test.
- Run installer with `-WhatIf` before actual install.
- Preserve all existing unrelated configuration.
- Do not overwrite unmanaged same-name Skills.
- If Codex has an active non-empty `AGENTS.override.md`, inspect it before deciding whether to integrate.
- Configure Codex, Claude Code, Antigravity IDE, and Antigravity CLI using their distinct native layouts.
- Antigravity CLI global skills are flat `<skill>.md` files; do not install IDE-style `<skill>/SKILL.md` folders there.
- Run disk verification after installation.
- Perform actual loading smoke tests for each locally installed Agent.
- Do not modify auth, API keys, model/provider, sandbox, or permission settings.
- Produce `agent-engineering-installation-report.md`.
- Final state must be `SETUP_VERIFIED`, `SETUP_PARTIALLY_VERIFIED`, or `SETUP_BLOCKED`.
