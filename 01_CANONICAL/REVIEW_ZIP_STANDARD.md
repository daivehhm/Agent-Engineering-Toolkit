# Review ZIP Standard v1.2

## Formal Stage 推荐内容

```text
review_report.md
claim_evidence_matrix.md
before_after_evidence.md      # Fix 类
files_modified.md
focused_tests.md
full_regression_summary.md
runtime_evidence.md
commands_run.md
git_state.md
review_manifest.md
review_diffs/ or reviewcopy/
```

根据项目增加产品证据。

## claim_evidence_matrix.md

每个重要成功 Claim 绑定：

```text
canonical artifact
run/task ID
field/extraction method
status
```

## review_manifest.md

记录：

- file list
- purpose
- generated_at
- canonical run IDs
- forbidden-content check
- Git state

默认不要求 SHA/SHA256。

## 默认排除

- secret/token/cookie/.env
- raw customer/private data
- node_modules
- model weights
- nested archives
- giant DB/raw transcript unless explicitly necessary

## 目标

Independent Reviewer 不访问 Executor 的脑内过程，也能判断：

```text
Claim 是否由同一轮真实 evidence 支持
```
