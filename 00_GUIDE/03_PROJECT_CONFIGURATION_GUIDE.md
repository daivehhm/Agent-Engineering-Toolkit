# Project Configuration Guide v1.5

## Project Source of Truth
每个项目默认以 `ENGINEERING_CONTRACT.md` 作为长期业务/工程语义唯一真源。AGENTS.md / CLAUDE.md / GEMINI.md 只是 Router，不复制阈值、状态机、Selection policy、Gate 或 Acceptance 规则。

## Minimal Structure
```text
<project-root>/
├─ AGENTS.md
├─ CLAUDE.md
├─ GEMINI.md
├─ ENGINEERING_CONTRACT.md
└─ .agents/rules/engineering-contract-router.md
```

## New Project
```powershell
$HOME\.agent-engineering\scripts\bootstrap-project.ps1 `
  -ProjectRoot "D:\path\project" `
  -TestCommand "<real command>" `
  -ContractVersion "0.1.0" `
  -WhatIf
```

## Existing Project
加 `-IntegrateExisting`。必须保留既有 AGENTS/CLAUDE/GEMINI 正文，只维护 Toolkit marker block；发现 dirty overlap 不静默覆盖。

## Engineering Contract
只放长期稳定的 Product Goal、Canonical Objects、Immutable Evidence、State/Gate/Persistence/Runtime、Parameter Registry、Review Independence 和 Deferred assumptions。当前 Bug、Stage Prompt、Pilot URL 不放这里。

## Work Class
Work Class 属于 Stage：SMALL_CHANGE / STAGE_WORK / FORMAL_ACCEPTANCE。项目合同可以规定某些操作最低 Work Class，但 Adapter 不复制这些业务语义。

## Git
默认不执行 git add / commit / push / PR，除非用户明确授权。
