# Scripts v1.5

- `self-test-toolkit.ps1`: package static/self-consistency gate.
- `preflight-windows.ps1`: native Windows environment/conflict/write-access preflight.
- `install-agent-engineering.ps1`: canonical install/upgrade and adapter integration.
- `refresh-machine-profile.ps1`: refresh managed machine discovery only.
- `sync-agent-engineering.ps1`: sync three canonical Skills to vendor-native layouts with conflict prescan.
- `verify-agent-engineering.ps1`: disk/config verification.
- `bootstrap-project.ps1`: create/integrate project routers and Engineering Contract.
- `uninstall-agent-engineering.ps1`: remove managed Toolkit assets without deleting unrelated user content.

Important: WhatIf must remain non-mutating; unknown unmanaged Skill conflicts fail closed; Antigravity CLI Skills are flat `.md` files; runtime loading smoke is separate from disk Verify.
