# Project Configuration Guide v1.2

## Minimal project structure

```text
<project-root>/
├─ AGENTS.md
├─ CLAUDE.md
├─ GEMINI.md
├─ ENGINEERING_CONTRACT.md
└─ .agents/
   └─ rules/
      └─ engineering-contract-router.md
```

## Existing project

Do not replace existing agent instructions.

Dry-run:

```powershell
$HOME\.agent-engineering\scripts\bootstrap-project.ps1 `
  -ProjectRoot "D:\path\project" `
  -TestCommand "<real command>" `
  -IntegrateExisting `
  -WhatIf
```

Then run without `-WhatIf`.

`-IntegrateExisting` preserves existing `AGENTS.md / CLAUDE.md / GEMINI.md` bodies and only adds/updates a Toolkit marker block.

Even if `-Force` is also supplied, existing adapter files are not first overwritten by templates.

## New project

```powershell
bootstrap-project.ps1 `
  -ProjectRoot "D:\path\project" `
  -TestCommand "<real command>"
```

Do not leave `<TEST_COMMAND>` as if setup were complete.

## ENGINEERING_CONTRACT.md

Keep only long-lived product/engineering contracts:

- canonical objects
- immutable evidence
- state semantics
- gate/validator authority
- persistence identity
- runtime acceptance
- external side effects

Do not put current bug lists or speculative future architecture here.

## Antigravity IDE

`.agents/rules/engineering-contract-router.md` must be discovered/activated by the IDE.

Recommended activation:

```text
Model Decision
```

This activation is a runtime/UI property; file creation alone is not proof it is active.

## Project Skills

This Toolkit installs only global cross-Agent Skills.

Create project-specific Skills only for truly project-specific workflows.

Remember:

- Codex project Skill: `.agents/skills/<skill>/SKILL.md`
- Claude project Skill: `.claude/skills/<skill>/SKILL.md`
- Antigravity IDE project Skill: `.agents/skills/<skill>/SKILL.md`
- Antigravity CLI workspace Skill: `.agents/skills/<name>.md`

Do not try to force one physical Skill layout on all products.
