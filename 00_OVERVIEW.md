# Agent Engineering Toolkit — Overview

## 1. 这是什么？

Agent Engineering Toolkit 是一套面向本地 AI 编程 Agent 的**轻量工程执行标准与配置工具包**。

它主要服务于：

- Codex
- Claude Code
- Google Antigravity IDE
- Google Antigravity CLI
- 以及其他具备本地工程执行能力的 Agent

它通过以下四层能力，提高复杂软件开发的一次完成率、真实正确率和可复核性：

```text
Global Engineering Invariants
        ↓
Cross-Agent Skills
        ↓
Project Engineering Contract
        ↓
Stage Execution + Independent Review
```

它不是一个新的 Agent 平台，也不是 CI/CD、账号管理、模型路由或治理平台。

---

# 2. 为什么需要它？

普通 Agent 工程开发很容易形成：

```text
用户给 Prompt
→ Agent 修改代码
→ Unit Test PASS
→ Agent 宣布完成
→ 独立 Review
→ 发现真实链路未生效
→ 再修
→ 再 Review
```

典型问题包括：

- 函数实现了，但真实数据路径根本没有走到；
- 新业务策略与旧 Validator / Gate 冲突；
- Agent 为了通过 Gate 修改原始 score / evidence；
- 报告说 PASS，但真实 task/test 实际失败；
- Unit Test PASS 被误认为产品行为已经正确；
- Executor 自己给自己最终验收 PASS；
- 项目规则在不同 Agent 中重复维护并逐渐漂移；
- 配置文件存在，但 Agent 实际没有加载；
- 每个小问题都拆成独立 Phase，形成治理循环；
- 为了解决当前问题提前建设模型、平台、Registry、Event Bus 等复杂能力。

Toolkit 的目的不是给 Agent 增加更多规则，而是：

> 用少量稳定的不变量、真实证据和清晰的职责边界，减少高成本返工和假完成。

---

# 3. 最终目标是什么？

## 一级目标

提高 AI Agent 软件工程任务的：

- 一次完成率
- 真实正确率
- 可验证性
- 可复核性
- 跨 Agent 一致性

## 二级工程目标

让 Agent 默认做到：

```text
不破坏工程不变量
不制造假证据
不绕过 Validator/Gate
真实数据路径生效
测试与 Runtime 一致
报告与 Canonical Evidence 一致
Executor 与 Independent Reviewer 分离
```

## 三级效率目标

将：

```text
开发
→ 报 PASS
→ Review 推翻
→ Fix
→ Review
→ 再发现假修复
```

收敛为：

```text
Stage Goal
→ Contract Impact
→ Minimal Implementation
→ Unit
→ Path Integration
→ Real Runtime
→ Canonical Evidence
→ Independent Review
```

---

# 4. 它解决什么问题？

主要解决 8 类问题：

1. **局部实现与真实链路脱节**
2. **新业务策略与旧合同冲突**
3. **原始 Evidence 被修改以迎合 Gate**
4. **报告/测试形成自证循环**
5. **Executor 自己批准正式 PASS**
6. **不同 Agent 配置和 Skill 机制漂移**
7. **微阶段过多、Review 循环过重**
8. **过度设计和过度治理**

---

# 5. 它不是什么？

Toolkit 明确不是：

- Agent 管理平台
- 多 Agent 编排平台
- CI/CD 系统
- Prompt 管理平台
- 代码托管平台
- 测试框架
- 自动发布系统
- 模型管理系统
- API Key / 账号权限管理系统
- 安全策略替代品
- 通用项目管理平台
- 自动决策所有产品质量的 Judge

如果一个能力不直接降低真实工程失败成本，就不应该因为 Toolkit 存在而被新增。

---

# 6. 什么时候使用？

典型场景：

## 场景 A — 修改业务语义

例如：

- scoring
- selection
- routing
- schema
- state transition
- validator
- gate
- persistence semantics

先使用：

```text
contract-impact-check
```

## 场景 B — 完整阶段开发或系统级修复

例如：

- 多文件实现
- 真实 runtime 验证
- 需要 Review ZIP
- 一次关闭一组相关系统问题

使用：

```text
stage-execution
```

## 场景 C — 独立 Review

例如：

- Review ZIP
- 阶段成果
- runtime evidence
- Executor 声称已经完成

使用：

```text
independent-review
```

## 场景 D — 新项目初始化

使用：

```text
bootstrap-project.ps1
```

生成轻量项目适配器和 Engineering Contract 模板。

---

# 7. 什么场景不应该使用完整流程？

以下场景通常不需要完整 Toolkit Workflow：

- typo
- 注释修改
- 纯 UI 文案
- 完全局部、低风险、无合同影响的小修复
- 普通开发中的自测
- 一次性 Demo
- 非工程问答

原则：

> 规则应降低工程成本，而不是制造流程成本。

---

# 8. 核心方法

## Evidence Is Immutable

原始评分、时间戳、测试结果、运行结果不能为了 PASS 被事后修改。

## Contract Impact Check

业务语义变化前先检查：

```text
Upstream
Downstream
Validator
Gate
Schema
Immutable Evidence
Real Path
Runtime Proof
```

## 三层证据

重要能力至少需要：

```text
Unit / Invariant Test
        ↓
Path Integration
        ↓
Real Runtime / Pilot
```

## Canonical Evidence

正确关系：

```text
Canonical Runtime Artifact
→ Metrics
→ Report
```

不是：

```text
Agent 写报告
→ 报告证明 Agent 正确
```

## Builder / Reviewer Separation

```text
Builder
→ Review ZIP
→ Independent Review
→ Human Review if needed
→ Commit
```

---

# 9. 使用前与使用后的区别

## Before

```text
Prompt
→ 开发
→ Unit Test
→ Agent PASS
→ Review
→ 返工
```

## After

```text
Stage Goal
→ Invariants
→ Contract Impact
→ Minimal Fix
→ Unit
→ Path
→ Runtime
→ Canonical Evidence
→ Independent Review
```

---

# 10. 三类角色

## Builder / Executor

负责：

- 实现
- 测试
- Runtime Evidence
- Review ZIP

不能：

- 批准自己的正式 PASS
- 伪造人工评价
- 修改原始 Evidence 迎合 Gate

## Independent Reviewer

负责：

```text
Claim
→ Canonical Evidence
→ Real Path
→ Contract
→ Invariant
→ Product Result
```

并决定：

- PASS
- FAIL
- Continue Current Stage
- Ready for Human Review
- Ready for Next Stage

## Human

用于无法完全自动判定的真实产品质量：

- 视频是否完整自然
- 图片是否商业可用
- 内容是否可发布
- 用户体验是否可接受

Agent 不得代替 Human 预填结论。

---

# 11. 完整生命周期

```text
Install Toolkit
        ↓
Configure Agent
        ↓
Bootstrap Project
        ↓
Define Project Engineering Contract
        ↓
Normal Development
        │
        ├─ Small local change → direct work
        │
        └─ Semantic / stage-level work
                    ↓
             Contract Impact
                    ↓
             Stage Execution
                    ↓
                Review ZIP
                    ↓
          Independent Review
                    ↓
        Human Review if necessary
                    ↓
               Commit Prep
                    ↓
                  Commit
                    ↓
               Next Stage
```

---

# 12. Toolkit 是否成功，如何判断？

不能用：

> “安装文件存在”

作为最终成功。

## 配置成功

需要：

```text
SETUP_VERIFIED
```

即：

- 配置文件正确
- Skills 正确
- Agent 实际加载成功

## 工程效果成功

长期应该观察：

- Review 推翻率是否下降
- false PASS 是否减少
- 返工轮数是否下降
- 真实 Path 问题是否更早暴露
- 一次阶段完成率是否提高
- Prompt 是否变短
- 微阶段数量是否减少
- Human Review 前的机器错误是否减少

暂时不需要建设 Metrics Platform。

---

# 13. 核心术语

## Invariant

不能为了局部任务被静默破坏的长期规则。

## Contract

模块/数据/状态之间长期成立的工程语义约定。

## Canonical Evidence

最接近真实运行事实的权威证据源。

## Real Path

真实输入到真实输出所经过的完整执行链。

## Gate / Validator

验证业务状态或输出是否合法的组件。

## Stage

一个可验证的完整产品/工程结果，不等于一个小 Bug。

## Executor

负责实现的 Agent。

## Independent Reviewer

独立验证 Executor Claim 的 Reviewer。

## Review ZIP

让 Reviewer 不依赖 Executor 脑内过程，也能验证关键 Claim 的交付包。

## Run Binding

确保 Report / Metrics 明确绑定到某个真实 task/run/artifact，避免引用旧数据。

---

# 14. 从哪里开始？

如果你是第一次拿到本包：

```text
00_START_HERE_FOR_ANY_AGENT.md
```

如果你想快速判断 Toolkit 是否适合当前任务：

```text
00_GUIDE/13_USAGE_SCENARIOS_AND_DECISION_TREE.md
```

如果你要理解角色、生命周期和成功标准：

```text
00_GUIDE/14_ROLES_LIFECYCLE_AND_SUCCESS_CRITERIA.md
```
