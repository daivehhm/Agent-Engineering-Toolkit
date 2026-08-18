# Static Validation Report — v1.3 FINAL

## Result

`PASS`

## Final package gate

```text
errors = 0
warnings = 0
version = 1.3.0
```

## Checked

### Zero-context setup

- root `00_START_HERE_FOR_ANY_AGENT.md`
- deterministic setup sequence
- explicit setup result states
- standardized installation report template

### Agent discovery/adapters

- Codex effective `CODEX_HOME`
- Codex active `AGENTS.override.md` handling
- Codex user folder Skills
- Claude effective `CLAUDE_CONFIG_DIR`
- Claude user folder Skills
- Antigravity IDE global rule and folder Skills
- Antigravity CLI global flat Markdown Skills

### Safety / non-destructive behavior

- native Windows fail-closed
- `-WhatIf` backup/write guards
- unmanaged Skill conflict pre-scan
- recognized legacy Toolkit migration
- unknown/unversioned canonical install fail-closed
- existing project adapters preserved with `-IntegrateExisting`
- project overwrite backups
- no automatic auth/model/provider/sandbox changes
- no Git commit/push behavior

### Evidence integrity

- package self-test
- native Windows preflight
- disk/config Verify
- real Agent Loading Smoke Test kept as separate gates
- `SETUP_VERIFIED / SETUP_PARTIALLY_VERIFIED / SETUP_BLOCKED`
- per-target runtime status reporting

### PowerShell regression checks

- no `$skill-name` interpolation regression
- no double-quoted Markdown-backtick regex in CLI flatten logic
- no escaped `$f/$final` preflight reporting regression
- project marker here-strings use literal form
- raw brace counts balanced
- here-string delimiter counts balanced

### Package hygiene

- no nested ZIP/RAR/7z
- no `.env`/cookie/private-key payloads
- canonical Skill names unique
- Skill frontmatter present
- managed markers are v1.2.0
- Global Invariants remain concise

## Not claimed

This static PASS is **not** Windows runtime installation PASS.

The remaining required local proof is:

```text
Package Self-Test
→ Native Windows Preflight
→ WhatIf
→ Install
→ Disk Verify
→ Actual Agent Loading Smoke Test
```

Only then may the local machine be reported as:

`SETUP_VERIFIED`
