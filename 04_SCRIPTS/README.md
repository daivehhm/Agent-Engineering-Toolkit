# Scripts v1.2

## self-test-toolkit.ps1

Validates package structure and known regression guards.

Run before any installation.

## preflight-windows.ps1

Discovers the real Windows environment before mutation:

- native Windows
- effective CODEX_HOME
- effective CLAUDE_CONFIG_DIR
- target executables
- active Codex override
- same-name Skill conflicts
- optional reversible write-access probes

Example:

```powershell
.\04_SCRIPTS\preflight-windows.ps1 -TestWriteAccess
```

## install-agent-engineering.ps1

Installs/updates canonical Toolkit, Skills, and global adapters.

Always dry-run first.

## sync-agent-engineering.ps1

Synchronizes canonical Skills.

Important v1.2 behavior:

- Codex / Claude / Antigravity IDE → folder `SKILL.md`
- Antigravity CLI → flat `<skill>.md`
- scans all unmanaged conflicts before any Skill write

## verify-agent-engineering.ps1

Verifies disk/config state.

Does not replace actual product loading smoke tests.

## bootstrap-project.ps1

Creates or non-destructively integrates project adapters.

For existing projects prefer:

```text
-IntegrateExisting
```

## uninstall-agent-engineering.ps1

Removes Toolkit marker blocks and Toolkit-managed Skills only.

It does not delete unmanaged content.

## Recovery

If installation stops partway:

1. do not declare success;
2. run `verify-agent-engineering.ps1`;
3. resolve the reported conflict/permission issue;
4. rerun the idempotent installer;
5. if the user wants removal instead, run uninstall.

Timestamped backups remain for manual recovery of prior content.
