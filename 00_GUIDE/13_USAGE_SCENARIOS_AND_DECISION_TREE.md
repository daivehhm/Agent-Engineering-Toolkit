# Usage Scenarios and Decision Tree v1.5

```text
完全局部低风险无合同影响？
  YES → SMALL_CHANGE
  NO  → 是否改变 scoring/selection/routing/schema/state/validator/gate/persistence/observable behavior？
          YES → contract-impact-check
        是否系统级、多文件、真实 Runtime 的完整工程结果？
          YES → STAGE_WORK → stage-execution
        是否 Holdout/Release/Formal Corpus/Production Acceptance？
          YES → FORMAL_ACCEPTANCE
        是否要正式判断 Builder Claim？
          YES → independent-review
```

SMALL_CHANGE 不默认要求 Review ZIP；若范围扩大则升级。

STAGE_WORK 要求 Capability/Writer Preflight、Contract Impact when needed、Unit/Path/Runtime、Critical Command Evidence、Stage Outcome、Review Package、Independent Review。

FORMAL_ACCEPTANCE 在 STAGE_WORK 基础上增加 frozen criteria、Acceptance Threshold、no inline tuning、strict binding、required review/Human Gate。

AET 不使用 lenient / standard / strict。MCP/Evaluation/Receipt Platform 当前不建设。
