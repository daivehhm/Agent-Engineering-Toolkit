# Agent Engineering Toolkit — Overview v1.5

## 是什么
AET 是跨 Agent、跨项目的轻量工程执行、证据约束与独立 Review Toolkit。

## 为什么
典型高成本失败包括：局部实现但真实 Path 未生效；新业务语义与旧 Gate 冲突；为了 PASS 修改 Evidence；Unit PASS 被误当成产品 PASS；Report 与 Canonical Artifact 冲突；Executor 自批 PASS；多 Agent 多份项目语义漂移。

## 目标
- Evidence immutable
- Contract Impact
- Unit → Path → Runtime
- Canonical Evidence
- Capability Preflight
- Single Writer per Worktree
- Independent Review
- Human Gate when needed
- Stage-level outcomes
- Anti-overdesign

## 六层模型
```text
L0 Machine Execution Profile
L1 Global Engineering Invariants
L2 Agent Adapter / Capability
L3 Project Engineering Contract
L4 Stage Execution Contract
L5 Independent Review / Human Gate
```

## Work Class
`SMALL_CHANGE`：局部低风险、无合同影响。通常 direct change + necessary check。

`STAGE_WORK`：系统级、多文件、语义变化、真实 Runtime 或正式 Stage closure。要求 Capability/Writer preflight、Contract Impact when needed、Unit/Path/Runtime、Review Package、Independent Review、Stage Outcome。

`FORMAL_ACCEPTANCE`：Holdout/Release/Formal Corpus/Production Acceptance。额外要求 frozen criteria、Acceptance Threshold、strict binding、no inline tuning、required Review/Human Gate。

## 最小结构化证据
Critical Command Evidence：只记录关键命令。

Stage Outcome：记录阶段与 Review 结果，让 AET 自己也能 Evidence-driven 地判断是否有效。

## 不是什么
当前不建设 MCP Server、Receipt DB、Evaluation Platform、Dashboard、Agent Manager、Policy Engine、centralized lock。

> 小修改直接做；语义变化先查合同；完整阶段做 Unit→Path→Runtime；正式结论交独立 Review；高成本验收前先真实 Pilot。
