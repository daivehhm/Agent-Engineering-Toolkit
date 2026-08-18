# Roles, Lifecycle and Success Criteria

# 1. Builder / Executor

Builder 可以是：

- Codex
- Claude Code
- Antigravity
- Human Developer
- 其他工程 Agent

负责：

- 读取项目合同
- 实现代码
- 运行测试
- 真实 Runtime
- 生成 Canonical Evidence
- 生成 Review ZIP

Builder 的成功出口：

```text
IMPLEMENTATION_COMPLETE_FOR_INDEPENDENT_REVIEW
```

或：

```text
EXECUTION_BLOCKED
```

Builder 不负责正式批准：

```text
PASS
READY_FOR_RELEASE
READY_FOR_HUMAN_REVIEW
```

---

# 2. Independent Reviewer

Reviewer 的职责不是：

> 检查 Executor 是否认真执行 Prompt。

而是：

> Executor 声称的结果是否真实成立。

使用：

```text
Claim
→ Canonical Evidence
→ Real Path
→ Contract
→ Invariant
→ Product Result
```

输出：

- PASS
- PASS_WITH_NONBLOCKING_ITEMS
- FAIL / CONTINUE_CURRENT_STAGE
- READY_FOR_HUMAN_REVIEW
- READY_FOR_NEXT_STAGE

并区分：

```text
Blocker
Non-blocker
```

---

# 3. Human Reviewer

Human 负责机器无法可靠替代的产品判断。

典型：

- 视频高光是否真的有价值
- 声音是否自然
- 图片是否商业可用
- 文章是否可发布
- 用户体验是否符合预期

Agent 只能准备：

```text
blank human review sheet
```

不能预填 Human 结论。

---

# 4. Commit / Release Role

Commit 不应和开发自动绑定。

推荐：

```text
Builder
→ Independent Review
→ Fix
→ PASS
→ Commit Prep
→ Commit
```

避免错误实现被过早固化。

---

# 5. 完整生命周期

## Phase 0 — Toolkit Setup

```text
Self-Test
→ Preflight
→ Dry-run
→ Install
→ Verify
→ Loading Smoke
```

## Phase 1 — Project Setup

```text
bootstrap-project
→ Engineering Contract
→ Agent adapters
```

## Phase 2 — Normal Engineering

### Small work

```text
direct change
→ necessary tests
```

### Semantic/stage work

```text
Contract Impact
→ Stage Execution
```

## Phase 3 — Evidence

```text
Unit
→ Path Integration
→ Real Runtime
→ Canonical Evidence
```

## Phase 4 — Independent Review

```text
Claim
→ Evidence
→ Path
→ Contract
→ Invariant
```

## Phase 5 — Human Review

Only when product judgment requires it.

## Phase 6 — Commit / Next Stage

Only after gate closure.

---

# 6. Stage Definition

一个 Stage 应该代表：

> 一个可验证、用户可理解的工程或产品结果。

错误示例：

```text
Fix pause
Fix suffix
Fix one validator
Fix one report
```

正确示例：

```text
Real-world Pilot Quality Closure
Windows Runtime Qualification
Calibration & Corpus Qualification
Release Readiness
```

---

# 7. Blocker 定义

通常只有以下问题值得打断当前 Stage：

- false sign-off
- data loss
- irreversible harm
- critical security issue
- current stage cannot run
- contamination of acceptance/holdout evidence

Medium/Low 问题默认在 Stage 结束统一关闭。

---

# 8. 配置成功标准

不能以：

```text
file exists
```

判断。

需要：

```text
Package Self-Test
Disk Verify
Real Agent Loading
```

最终：

```text
SETUP_VERIFIED
```

---

# 9. 工程成功标准

一个重要能力 DONE 至少要同时满足：

```text
Unit / Invariant behavior correct
+
Real data path reaches it
+
Real runtime proves product behavior
```

如果：

```text
helper exists
Unit Test PASS
but real path never supplies required data
```

则：

```text
NOT DONE
```

---

# 10. Review 成功标准

Reviewer 应该能在不访问 Executor 私有推理过程的情况下，通过 Review ZIP 验证：

- 代码修改
- 测试
- Runtime
- Canonical Task/Run
- Claim-Evidence Binding
- Git state

---

# 11. Toolkit 自身成功标准

短期：

- 不破坏已有 Agent 配置
- Agent 能准确加载规则/Skills
- 无 false setup success
- 新 Agent 无历史上下文也能配置

长期：

- false PASS 减少
- Review 推翻率下降
- 返工轮数下降
- 一次阶段完成率提升
- 真正 Path Bug 更早发现
- Prompt 更短、更稳定
- 微阶段数量下降
- 高成本验收前错误减少

---

# 12. 不应该为了评估 Toolkit 再建设一个 Metrics Platform

初期只需要在真实项目 Review 中观察：

```text
本阶段 Review 轮数
Blocker 数量
是否出现 false PASS
是否出现 report/runtime conflict
是否出现 unit-pass/path-fail
```

真实证据积累后，再决定是否需要自动化指标。

---

# 13. 角色分离的核心价值

不是制造治理，而是降低：

```text
Executor completion bias
```

即：

> 执行者倾向于证明自己的任务已经完成。

通过：

```text
Executor
≠
Final Judge
```

降低假成功概率。
