# Troubleshooting v1.2

## Start with preflight

```powershell
preflight-windows.ps1 -TestWriteAccess
```

Do not diagnose Agent behavior before confirming the effective paths.

---

# Codex global rules missing

Check:

```powershell
$env:CODEX_HOME
```

Then inspect:

```text
AGENTS.override.md
AGENTS.md
```

A non-empty override wins at global scope.

Verify must show the Toolkit in the active file.

---

# Codex Skill missing

Check:

```text
%USERPROFILE%\.agents\skills\<skill>\SKILL.md
```

Then use `/skills` or explicit `$skill-name`.

---

# Claude global rules missing

Check:

```powershell
$env:CLAUDE_CONFIG_DIR
```

Then run:

```text
/context
```

Confirm the effective `CLAUDE.md`.

---

# Claude Skill missing

Check:

```text
<ClaudeHome>\skills\<skill>\SKILL.md
```

Invoke:

```text
/contract-impact-check
```

---

# Antigravity IDE Skill works but CLI Skill does not

Do not compare only the same directory layout.

IDE:

```text
~/.gemini/config/skills/<skill>/SKILL.md
```

CLI:

```text
~/.gemini/antigravity-cli/skills/<skill>.md
```

v1.1 used the wrong directory-style layout for CLI. v1.2 migrates recognized Toolkit v1.1 directories to flat CLI files.

---

# Antigravity CLI still has `<skill>/SKILL.md`

Verify will fail.

Run v1.2 sync. It should back up and remove recognized Toolkit legacy folders.

If the directory is unmanaged, sync fails closed; inspect it before replacement.

---

# Workspace Contract not active in Antigravity IDE

File existence:

```text
.agents/rules/engineering-contract-router.md
```

does not prove activation.

Check:

```text
Customizations → Rules
```

Recommended activation:

```text
Model Decision
```

---

# Sync reports unmanaged Skill conflict

Do not immediately use Force.

Inspect the same-name Skill.

Only if replacement is explicitly intended:

```powershell
sync-agent-engineering.ps1 -ForceManagedSkillOverwrite
```

The script backs up replaced content.

---

# `-WhatIf` created files/backups

That is a Toolkit defect.

v1.2 contract says dry-run does not create:
- config files
- backups
- project directories

Stop and report the exact path created.

---

# Verify PASS but Agent ignores rule

Disk verification is not runtime proof.

Run:

```text
09_AGENT_LOADING_SMOKE_TEST.md
```

If loading fails, diagnose:
- session restart
- effective config path
- override
- Agent discovery behavior
- sandbox/permission

Do not rewrite engineering rules to compensate for a loading problem.
