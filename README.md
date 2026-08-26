# Agent Engineering Toolkit v1.5

AET 是面向 **Codex / Claude Code / Antigravity 等本地 AI Coding Agent** 的轻量工程执行、证据约束与独立 Review Toolkit。

核心问题不是“Agent 会不会写代码”，而是：

```text
执行是否真实
改动是否受控
证据是否可信
完成声明是否可验证
不同 Agent 是否遵守同一项目合同
```

## 六层架构

```text
L0  Machine Execution Profile
L1  Global Engineering Invariants
L2  Agent Adapter / Capability
L3  Project Engineering Contract
L4  Stage Execution Contract
L5  Independent Review / Human Gate
```

## 三个程序性 Skill

```text
contract-impact-check
stage-execution
independent-review
```

仍然只有三个 Skill。

## v1.5 — Evidence & Consistency Closure

### Work Class

```text
SMALL_CHANGE
STAGE_WORK
FORMAL_ACCEPTANCE
```

不是 `lenient / standard / strict`。Work Class 由工作性质决定最低 Evidence/Review 要求。

### Critical Command Evidence
正式 Stage 记录关键测试、构建、真实运行、验证、迁移、benchmark 命令的结构化证据，不捕获全部终端历史。要求保存 exit code，并默认进行 secret redaction。

### Minimal Stage Outcome
STAGE_WORK / FORMAL_ACCEPTANCE 生成 `stage_outcome.json`，最小记录 Unit/Path/Runtime、Review 轮数、Blocker、false sign-off 与 Human Gate 状态。先积累真实数据，不建设 Evaluation Platform。

### Documentation Consistency
Active 文档只描述当前版本。历史变化只进入 `CHANGELOG.md`，不再采用“旧版正文 + 新版 addendum”。

## AET 不是什么

当前不建设：MCP Server、Receipt Server、Evaluation Platform、Dashboard、Agent Manager、Policy Engine、centralized lock、RBAC/Compliance 平台。

AET 支持 auditability-oriented engineering，但不声称满足企业合规认证。

## 安装

```powershell
powershell -ExecutionPolicy Bypass -File .\04_SCRIPTS\self-test-toolkit.ps1
powershell -ExecutionPolicy Bypass -File .\04_SCRIPTS\preflight-windows.ps1 -TestWriteAccess
powershell -ExecutionPolicy Bypass -File .\04_SCRIPTS\install-agent-engineering.ps1 -WhatIf
powershell -ExecutionPolicy Bypass -File .\04_SCRIPTS\install-agent-engineering.ps1
powershell -ExecutionPolicy Bypass -File $HOME\.agent-engineering\scripts\verify-agent-engineering.ps1
```

最后执行 `00_GUIDE/09_AGENT_LOADING_SMOKE_TEST.md`。文件存在不等于 Runtime Loading 成功。

## 成功标准

配置成功：`SETUP_VERIFIED`。

工程效果长期观察：false PASS、Review 推翻率、返工轮数、Path failure、一次 Stage 完成率、Human Gate 前机器错误。
