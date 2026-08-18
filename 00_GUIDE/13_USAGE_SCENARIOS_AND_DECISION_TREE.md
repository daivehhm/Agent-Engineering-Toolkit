# Usage Scenarios and Decision Tree

## 1. 核心问题

每次准备调用 Toolkit 前，先问：

> 当前只是一个普通局部修改，还是会改变系统语义、跨模块行为、正式阶段状态或验收证据？

---

# 2. 决策树

```text
我要修改或审查一个工程项目
        │
        ├─ 只是 typo / 注释 / 文案 / 完全局部低风险修改？
        │       │
        │       └─ YES → 直接修改 + 必要自测
        │
        └─ NO
             │
             ├─ 是否改变 scoring / selection / routing /
             │  schema / state / validator / gate /
             │  persistence / externally observable behavior？
             │       │
             │       └─ YES → contract-impact-check
             │
             ├─ 是否属于一个完整工程阶段或系统级修复？
             │       │
             │       └─ YES → stage-execution
             │
             └─ 是否要独立判断 Executor 的 Claim 是否真实成立？
                     │
                     └─ YES → independent-review
```

---

# 3. 场景 A — 新增较大功能

示例：

```text
Video-Clipping:
global score ranking
→ coverage-aware selection
```

推荐：

```text
contract-impact-check
→ stage-execution
→ independent-review
```

原因：

业务选择语义变化，原 FinishGate / Validator 假设可能失效。

---

# 4. 场景 B — 系统级 Bug

示例：

```text
ASR 有 word timestamps
但 normalize 后 words 丢失
导致 physical alignment 实际未生效
```

推荐：

```text
stage-execution
```

重点验证：

```text
Unit
→ Path Integration
→ Real Runtime
```

不是只给 helper 写 Unit Test。

---

# 5. 场景 C — Schema / Gate / Validator 修改

示例：

```text
Selection Policy 已变化
旧 FinishGate 仍要求 global Top-score
```

必须先：

```text
contract-impact-check
```

重点检查：

```text
新策略
vs
旧合同
```

不能通过修改 Evidence 迎合旧 Gate。

---

# 6. 场景 D — 阶段成果 Review

输入可能是：

- Review ZIP
- source diff
- test result
- runtime evidence
- benchmark
- task DB snapshot

使用：

```text
independent-review
```

Reviewer 不接受：

```text
Executor narrative summary
```

作为唯一证据。

---

# 7. 场景 E — 新项目

执行：

```powershell
bootstrap-project.ps1
```

得到：

```text
AGENTS.md
CLAUDE.md
GEMINI.md
ENGINEERING_CONTRACT.md
.agents/rules/
```

然后人工/Agent 完成项目级长期合同。

---

# 8. 场景 F — 多 Agent 协作

例如：

```text
Codex Builder
Claude Reviewer
Antigravity Runtime Executor
```

三者共享：

- Global Invariants
- 三个通用 Skills
- Project Engineering Contract

但角色职责仍分离。

不要因为多个 Agent 都能 Review，就允许 Executor 自己批准正式 PASS。

---

# 9. 场景 G — 高成本正式验收之前

例如：

- 40-video Gold
- Holdout
- 大规模 benchmark
- 真 GPU 长时实验
- 人工标注
- 生产发布

先问：

> 最小真实 Pilot 是否已经证明基本产品路径正确？

如果没有：

```text
先 Pilot
→ 再 Formal Acceptance
```

避免用高成本数据校准一个已知存在系统缺陷的版本。

---

# 10. 什么时候不要调用 contract-impact-check？

通常不需要：

- typo
- 注释
- README 排版
- 不改变输出语义的简单重命名
- 明确完全局部且没有上下游影响的修复

---

# 11. 什么时候不要调用 stage-execution？

通常不需要：

- 单文件简单 Bug
- 无真实 Runtime 风险的小修改
- 几分钟即可完成并验证的低风险工作

不要把每次开发都包装成 Stage。

---

# 12. 什么时候不要调用 independent-review？

普通 Builder 自测不需要独立 Review。

Independent Review 用于：

- 正式阶段关闭
- 用户要求独立审查
- Review ZIP
- Release / Human Review / Next Stage Gate

---

# 13. 过度设计检查

当 Agent 想新增：

- LLM Judge
- Embedding
- Vector DB
- Registry
- Event Bus
- Agent Platform
- Rules Engine
- Governance Service

先问：

1. 当前真实问题是否必须依赖它？
2. 现有数据和 deterministic logic 是否已经足够？
3. 是否只是为了让设计“更完整”？
4. 是否会阻塞最小真实闭环？

如果没有直接证据：

> 不新增。

---

# 14. 一句话使用原则

```text
小修改直接做
语义变化先查合同
完整阶段用 Stage Execution
正式结论交 Independent Review
高成本验收前先真实 Pilot
```
