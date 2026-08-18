# Video-Clipping Engineering Contract — Example

> 示例，不作为当前项目正式合同。

## Product Goal

One Source Video → Content Intelligence → L1 Smart Clipping.

## Canonical Objects

```text
HighlightAnchor
→ ContentUnit
→ ClipCandidate
→ ClipPlan
```

## Immutable Evidence

- Anchor raw score
- ASR timestamps
- candidate qualification evidence
- original selection score
- ffprobe result
- test runner result

Selection 策略变化时应增加：

```text
selection_reason
coverage_rank
final_rank
```

不得回写原始分数。

## Completeness

- COMPLETE = 可独立理解的合法语义单元
- hard_max 到达但未闭合 ≠ COMPLETE
- short COMPLETE 不强行 padding
- no-result 是合法产品结果，不等于技术失败

## Finish Gate

FinishGate 验证实际 Selection Policy。

如果 Selection Policy 从 global-score 改为 coverage-aware：

必须 Contract Impact Check。

不得通过修改 score 迎合旧 Gate。

## Real Path Requirement

Word-safe boundary 声称完成前，必须证明：

```text
ASR words
→ sanitizer
→ normalize
→ planner
→ aligner
→ ClipPlan
→ renderer
```

真实链路中 words 没有丢失。

## Acceptance

先用少量真实视频 Pilot 证明产品路径可用，再进入正式 Gold / Calibration。


## Test Oracle

核心 regression 不得仅因实现变化而删除：

- score mutation must fail
- hard_max incomplete must not become COMPLETE
- word timestamps must survive real planner path when present
- selected MP4 must map to valid ClipPlan item

如果业务合同变化，先更新 Engineering Contract，再更新测试 oracle。

## Review Evidence

正式阶段的关键 Claim 应进入：

```text
claim_evidence_matrix.md
```

例如：

| Claim | Canonical Source | Run/Task ID | Status |
|---|---|---|---|
| Word-safe boundary active | selected ClipPlan + ASR words | `<task_id>` | PASS/FAIL |
| Coverage selection changed | canonical candidate/selection evidence | `<task_id>` | PASS/FAIL |
