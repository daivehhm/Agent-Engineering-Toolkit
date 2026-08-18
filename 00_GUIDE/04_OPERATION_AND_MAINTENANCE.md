# Operation and Maintenance v1.2

## Canonical edits

Long-term edits belong under:

```text
%USERPROFILE%\.agent-engineering\
```

## Skill sync

After changing canonical Skills:

```powershell
$HOME\.agent-engineering\scripts\sync-agent-engineering.ps1
```

The script updates:

- Codex folder Skills
- Claude folder Skills
- Antigravity IDE folder Skills
- Antigravity CLI flattened `.md` Skills

## Global invariant edit

Claude and Antigravity import the canonical file directly.

Codex stores the canonical invariant body in the active AGENTS marker block, so after changing the canonical invariant file, rerun the same-version installer from the installed Toolkit:

```powershell
$HOME\.agent-engineering\scripts\install-agent-engineering.ps1
```

then Verify.

## Verify

```powershell
$HOME\.agent-engineering\scripts\verify-agent-engineering.ps1
```

Verify detects drift but does not replace runtime Agent loading smoke.

## Upgrade

When package VERSION differs:

```powershell
.\04_SCRIPTS\install-agent-engineering.ps1 -UpgradeCanonical -WhatIf
```

then actual upgrade after review.

## Failure recovery

If an install is interrupted:

1. do not declare success;
2. run Verify;
3. resolve the exact conflict/permission issue;
4. rerun installer idempotently;
5. if removal is desired, run uninstall;
6. use timestamped backups for manual restoration when needed.

The Toolkit does not automatically restore arbitrary preexisting content because doing so without knowing the user's intent can itself destroy later edits.

## Update discipline

Add something to Global Invariants only when it:

- repeats across projects;
- remains true long-term;
- materially reduces failure;
- does not belong to a procedural Skill.

Otherwise keep it in Project Contract, Skill reference, or Task Prompt.
