# <PROJECT_NAME> Engineering Contract

> 只存长期产品/工程合同，不存本轮 Bug/Prompt。

## 1. Product Goal

`<ONE_SENTENCE_GOAL>`

## 2. Canonical Objects

| Object | Authority | Semantics |
|---|---|---|
| `<object>` | `<module/schema>` | `<meaning>` |

## 3. Immutable Evidence

一旦产生不得为通过 Gate 而修改：

- `<score>`
- `<timestamp>`
- `<raw evaluator result>`

## 4. State Machine Invariants

- `<terminal states>`
- `<who may write terminal state>`
- `<failure/no-result semantics>`

## 5. Validator / Gate Contract

| Gate | Validates | Must Not Assume / Do |
|---|---|---|
| `<gate>` | `<semantic>` | `<forbidden shortcut>` |

如果业务策略变化导致 Gate 假设变化：

先 Contract Impact Check，再同步更新 contract/test/gate。

## 6. Test Oracle Contract

- 哪些测试代表核心业务合同？
- 哪些必须 fail-closed？
- 哪些是 unit/path/runtime 层？

## 7. Persistence / Cache Contract

- source identity
- model/config binding
- stale-data rejection
- migration rules

## 8. Runtime Contract

- supported runtime
- external binaries/services
- canonical real path
- fallback/provenance rules

## 9. External Side Effects

- Network:
- Filesystem:
- Git:
- External services:

## 10. Review Evidence Contract

正式 Stage 最少：

- claim-evidence matrix
- changed source/test
- test runner evidence
- path/runtime evidence
- run/task IDs
- Git state

## 11. Deferred / Provisional

列出尚未冻结的：

- thresholds
- limits
- architectures
- future modes

避免 provisional default 被误当 acceptance truth。
