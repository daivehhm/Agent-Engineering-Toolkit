# Install Checklist — v1.6.1

- [ ] Read `00_START_HERE_FOR_ANY_AGENT.md`
- [ ] Run package self-test; require no control-character / parser / JSON failures
- [ ] Run native Windows preflight
- [ ] Run installer `-WhatIf` (`-UpgradeCanonical` if upgrading)
- [ ] Confirm WhatIf created no files/backups/directories
- [ ] Review active Codex `AGENTS.override.md` if present
- [ ] Review unmanaged Skill conflicts; do not use force without explicit intent
- [ ] Execute install/upgrade
- [ ] Refresh Machine Profile
- [ ] Run static verify; expect `PASS_STATIC`, not runtime PASS
- [ ] Run fresh-session loading/behavior smoke for each installed/used supported Agent
- [ ] Verify subagent/delegation when supported
- [ ] Verify representative project precedence where local Agent rules exist
- [ ] Record unsupported engineering Agents as `NOT_COVERED`
- [ ] Only then record `SETUP_VERIFIED`
