# Migration to v1.2

Supports upgrade from v1.0 or v1.1.

## Important v1.1 → v1.2 change

Antigravity CLI global Skill storage changes from the incorrect Toolkit v1.1 directory copy:

```text
~/.gemini/antigravity-cli/skills/<skill>/SKILL.md
```

to the actual CLI flat format:

```text
~/.gemini/antigravity-cli/skills/<skill>.md
```

Recognized Toolkit-managed/legacy directories are backed up and migrated.

Unmanaged same-name content remains fail-closed.

---

# Upgrade sequence

From the **new v1.2 extracted package**:

```powershell
.\04_SCRIPTS\self-test-toolkit.ps1
```

Then:

```powershell
.\04_SCRIPTS\preflight-windows.ps1 -TestWriteAccess
```

Dry-run:

```powershell
.\04_SCRIPTS\install-agent-engineering.ps1 -UpgradeCanonical -WhatIf
```

Actual:

```powershell
.\04_SCRIPTS\install-agent-engineering.ps1 -UpgradeCanonical
```

Verify:

```powershell
$HOME\.agent-engineering\scripts\verify-agent-engineering.ps1
```

Then perform all applicable Agent Loading Smoke Tests.

---

# Existing projects are not bulk rewritten

Global Toolkit upgrade does not automatically modify repositories.

For a project:

```powershell
bootstrap-project.ps1 `
  -ProjectRoot "D:\project" `
  -TestCommand "<real command>" `
  -IntegrateExisting `
  -WhatIf
```

Review before applying.

---

# Force options

`-ForceManagedSkillOverwrite` is not an ordinary migration switch.

Use only after inspecting an unmanaged same-name Skill and confirming replacement is intended.

`-Force` in project bootstrap does not authorize destructive replacement of existing adapters when `-IntegrateExisting` is used.
