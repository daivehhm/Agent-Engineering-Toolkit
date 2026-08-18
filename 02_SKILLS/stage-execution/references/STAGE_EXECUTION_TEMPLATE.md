# Stage Execution Template v1.2

## Role

`<Builder / Fix Agent / Coordinator>`

## Task Type

`Stage-level Implementation / Fix / Validation`

## Stage Goal

一句话定义最终可验证产品/工程结果。

## Known Defects

只列已有证据支持的问题。

## Contracts / Invariants

- Read global Hard Invariants.
- Read project `ENGINEERING_CONTRACT.md` when task changes business semantics/contracts.
- If semantic/contract change exists, run `contract-impact-check` before editing.

## Baseline Evidence

Fix 类任务先记录能够复现当前问题的最小 Before Evidence：

```text
before_run_id
failing test / runtime artifact
expected vs actual
```

避免修完后无法证明改变的是同一个问题。

## Allowed Scope

明确：

- writable roots
- read-only roots
- network policy
- external data
- Git policy

## Implementation

- 最小修改；
- 复用现有能力；
- intrinsic evidence 不可被后续 policy 回写；
- 不通过弱化 test/gate/validator 让结果 PASS；
- 不为未知未来需求新增框架。

## Test Layers

### L1 — Unit / Invariant

证明局部规则。

### L2 — Path Integration

证明真实关键数据在模块链中没有丢失/旁路。

### L3 — Real Runtime / Pilot

证明真实输入导致预期用户可见行为变化。

## Test Integrity

如果修改测试：

必须说明：

```text
which old contract changed
why old assertion is obsolete
what new regression oracle replaces it
```

不能仅为让当前实现变绿而改 expectation。

## Canonical Evidence

定义本阶段 Source of Truth：

```text
task/run ID
runtime artifact
raw test runner
ffprobe
DB row
...
```

所有关键报告数字必须由 canonical artifact 派生。

## Claim-Evidence Matrix

正式 Stage 至少生成：

```text
claim_evidence_matrix.md
```

每个关键 Claim：

| Claim | Canonical Source | Run/Task ID | Derived Field | Status |
|---|---|---|---|---|

## Review ZIP

正式 Stage 推荐：

```text
review_report.md
claim_evidence_matrix.md
before_after_evidence.md        # Fix task
files_modified.md
focused_tests.md
full_regression_summary.md
runtime_evidence.md
commands_run.md
git_state.md
review_manifest.md
review_diffs/ or reviewcopy/
```

## Executor Exit

执行方使用执行状态，例如：

```text
IMPLEMENTATION_COMPLETE_FOR_INDEPENDENT_REVIEW
EXECUTION_BLOCKED
```

除非任务明确约定其他“executor-only”状态。

正式 Independent PASS / Human PASS / Release Gate 由独立验收决定。
