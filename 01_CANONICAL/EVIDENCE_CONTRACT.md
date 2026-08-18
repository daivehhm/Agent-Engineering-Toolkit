# Evidence Contract v1.2

## Source-of-Truth Hierarchy

```text
Canonical raw runtime artifact
> machine-derived metric
> derived report
> narrative summary
```

冲突时，上一级为准。

## Immutable Evidence

典型：

- raw score
- timestamp
- task state transition
- ASR output
- ffprobe result
- raw test runner result
- benchmark measurement
- evaluator raw result

不得为了 PASS：

- 加分/乘系数；
- 改时间戳；
- 删除失败项；
- 重写 provenance；
- 把 configured value 冒充 actual value。

## Policy / Selection Evidence

新策略需要：

```text
selection_reason
policy_version
coverage_rank
final_rank
```

这些是 derived policy evidence。

不得覆盖 intrinsic evidence。

## Runtime Provenance

至少区分：

```text
configured
requested
actual successful
fallback
```

## Run Binding

关键 artifact/report 必须能追到：

```text
run_id / task_id / artifact_id
actual runtime/config
```

Report 不允许拿旧 run 数字拼装成新结果。

## Claim-Evidence Matrix

正式阶段：

```text
claim_evidence_matrix.md
```

最小列：

```text
Claim
Canonical Source
Run/Task ID
Derived Field / Extraction
Status
```

## Before/After Evidence

Fix 类任务优先保留：

```text
before
after
same/controlled input
same relevant config
```

若输入/配置不同，必须说明为什么仍可比较。
