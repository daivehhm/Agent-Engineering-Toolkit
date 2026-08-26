# Contract Impact Check v1.5
用于业务语义/系统合同变化前的最小检查。

不是独立 Phase；完成后继续当前 Stage。

## 必答 9 项

| Item | Question |
|---|---|
| Changed Semantic | 真正改变的业务语义是什么？ |
| Upstream | 谁产生输入？ |
| Downstream | 谁消费结果？ |
| Contract/Gate | 哪些 schema / validator / gate 假设会失效或变化？ |
| Test Oracle | 哪些既有测试表达了旧合同？哪些必须保留/更新？ |
| Immutable Evidence | 哪些字段不能为了适配新策略而修改？ |
| Real Data Path | 真实数据经过哪些函数/模块？ |
| Runtime Proof | 什么真实现象证明新能力真正生效？ |
| Forbidden Shortcut | 最容易出现的“让 Gate 绿但产品没修”的捷径是什么？ |

## 强制追问

1. 新策略与旧 Validator 是否语义兼容？
2. 若不兼容，应该更新合同还是实现？
3. 是否存在“修改 score/evidence 来迎合旧 Gate”的诱因？
4. Helper 是否可能实现了但真实 Path 没把数据传进去？
5. 是否可能只改 Unit Test，而 Runtime artifact 不变化？
6. Test 更新是在表达新合同，还是在删除失败 oracle？
7. Report 是否可能来自旧 run / 手工数字？

## 输出

简短：

```text
contract_impact_check.md
```

至少含：

```text
Changed semantic
Affected contracts
Test-oracle impact
Immutable evidence
Real path
Runtime proof
Forbidden shortcuts
```
