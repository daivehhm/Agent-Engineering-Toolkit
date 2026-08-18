# Independent Review Checklist v1.2

核心问题不是：

> Executor 是否说“完成了”？

而是：

> 关键 Claim 是否被同一轮 canonical evidence 真实证明？

## Core Trace

```text
Claim
→ Canonical Evidence
→ Run/Task Binding
→ Real Data Path
→ Contract / Test Oracle
→ Hard Invariant
→ User-visible Result
```

## 1. Claim vs Evidence

逐项检查：

- Claim 是否出现在 `claim_evidence_matrix.md`？
- Source 是否真的是 raw/canonical artifact？
- 是否绑定正确 task/run？
- Report 是否存在手工/旧数据？

报告与 canonical artifact 冲突时：

```text
canonical artifact wins
```

## 2. Real Path

重要能力必须追真实链：

```text
producer
→ normalization
→ persistence
→ planner/consumer
→ final artifact
```

检查中间是否：

- 字段丢失；
- fallback 未记录；
- helper 从未被真实调用；
- final output 实际仍走旧路径。

## 3. Contract Compatibility

检查：

- 新策略是否改变旧 Validator 假设？
- 是否应该更新 Contract/Gate？
- 是否通过修改 intrinsic evidence 来“适配”旧 Gate？
- 是否削弱 Gate 只为让新实现通过？

## 4. Test Integrity

检查：

- test runner 原始 failure/error；
- 是否删/skip/弱化旧失败测试；
- 测试 expectation 变化是否有 Contract Impact 依据；
- 是否存在 hardcoded fake evidence test；
- Unit PASS 是否被错误当成 E2E PASS。

## 5. Before / After

Fix 类任务检查：

- Before 与 After 是否针对同一问题；
- 是否使用同一输入/等价配置；
- After 是否来自修改后的新 run；
- 是否只是复用了 stale artifact。

## 6. Anti-signoff Checks

重点搜索：

- score mutation after selection
- hardcoded report counts
- fake provenance
- hidden threshold drift
- test deletion/skip
- validator bypass
- summary PASS vs runner FAIL
- holdout/acceptance contamination

## 7. Overdesign Check

问：

1. 是否为了一个案例建立通用平台？
2. 是否在引入 model/embedding/registry 前证明现有能力不足？
3. 是否一个 Medium/Low 变成一个 Phase？
4. 是否存在更简单 existing-data/deterministic 方案？

## 8. Result

Independent Reviewer 可输出：

- PASS
- PASS_WITH_NONBLOCKING_ITEMS
- FAIL / CONTINUE_CURRENT_STAGE
- READY_FOR_HUMAN_REVIEW
- READY_FOR_NEXT_STAGE

必须分：

```text
Blocker
Non-blocker
```

下一步优先给一个完整阶段任务，不要微 Bug 循环。
