# Agent Engineering Toolkit — Overview v1.6.1

## 是什么
AET 是跨 Agent、跨项目的轻量工程执行、证据约束、安全边界与独立 Review Toolkit。

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
- Cross-Agent Machine Safety

## 六层模型
```text
L0 Machine Execution Profile
L1 Global Engineering Invariants
L2 Agent Adapter / Capability
L3 Project Engineering Contract
L4 Stage Execution Contract
L5 Independent Review / Human Gate
```

`FS_SEARCH_SAFETY_V1` 属于 L1 的跨 Agent invariant；L0 可以声明本机更严格的 filesystem policy，但不能弱化 L1。

## 不是什么
当前不建设 MCP Server、Receipt DB、Evaluation Platform、Dashboard、Agent Manager、Policy Engine、centralized lock。
