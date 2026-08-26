# Troubleshooting v1.5

## Setup says file exists but Agent does not follow rules
Run the Agent Loading Smoke Test. Disk Verify is not runtime proof.

## Codex ignores AGENTS.md
Check effective CODEX_HOME and whether a non-empty AGENTS.override.md is active. Inspect conflicts before integrating Toolkit into an override.

## Claude ignores instructions
Check effective CLAUDE_CONFIG_DIR and actual CLAUDE.md loading. Verify imports point to installed canonical files.

## Antigravity IDE sees Skills but CLI does not
IDE uses folder `SKILL.md`; CLI global Skills are flat `.md` files. Verify both independently.

## WhatIf changed files
This is a failure. WhatIf must not create backups, directories, project files, or adapter writes.

## Same-name unmanaged Skill exists
Fail closed. Inspect it. Only replace after explicit authorization; do not use Force blindly.

## Machine Profile says tool exists but Agent cannot run it
Expected possibility. Machine Available != Agent Accessible. Record the Stage capability as BLOCKED rather than weakening sandbox/security.

## Multiple Agents edit same worktree
Stop one writer or move Builders to isolated worktrees/working trees. Preserve dirty overlap.

## Stage evidence is too large
Use Critical Command Evidence plus bounded raw outputs. Do not capture every terminal command or full environment.

## Stage Outcome disagrees with tests/runtime
Canonical evidence wins. Correct `stage_outcome.json`; never rewrite canonical evidence to match the summary.
