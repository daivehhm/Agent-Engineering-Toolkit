# 调用示例

## 1. 语义/合同变化

### Codex

```text
$contract-impact-check
检查这次 Selection 从 global score ranking 改为 coverage-aware 后，对 FinishGate、ClipPlanContract 和 immutable evidence 的影响。
```

然后：

```text
$stage-execution
按 Contract Impact 结果执行当前阶段，不创建微阶段；完成后输出 Review ZIP。
```

### Claude Code

```text
/contract-impact-check
```

然后：

```text
/stage-execution
```

### Antigravity

```text
Use the contract-impact-check skill first.
Then use the stage-execution skill.
直接执行，无需 planning confirmation 阻断。
```

---

## 2. 独立 Review

Codex：

```text
$independent-review
独立审查本轮 Review ZIP。不要接受执行方摘要为证据源。
```

Claude：

```text
/independent-review
```

Antigravity：

```text
Use the independent-review skill.
```

---

## 3. 小修改

如果只是：

- typo
- 明确局部 bug
- 文档错字
- 不影响 contract 的简单测试修正

可以不强制 contract-impact-check。

全局规则的目标不是制造流程，而是阻止高成本错误。
