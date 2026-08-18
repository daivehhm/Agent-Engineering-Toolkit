# Agent Engineering Global Invariants v1.2

适用于工程开发、修复、测试、阶段执行和正式 Review。

## Hard Invariants

1. **Evidence immutable**  
   不得为了让 Gate / Validator / Test / Review PASS 而事后修改原始 score、timestamp、runtime result 或其他 canonical evidence。新策略需要新解释字段，不覆盖原证据。

2. **Semantic change → Contract Impact Check**  
   scoring、selection、routing、state、schema、validator、gate、persistence semantics 或用户可见行为发生变化前，必须检查上下游合同与测试 oracle。

3. **Feature done requires real-path reachability**  
   函数存在或 Unit Test PASS 不等于完成。重要能力至少需要：Unit/Invariant → Path Integration → Real Runtime/Pilot。

4. **Canonical artifact outranks report**  
   Source of truth 顺序：raw/canonical runtime artifact → machine-derived metric → report → narrative summary。关键 Claim 必须绑定 run/task/artifact ID。

5. **Test integrity is part of the contract**  
   不得仅为让测试变绿而删除、弱化、跳过或改写失败 oracle。若业务合同变化导致测试必须更新，需在 Contract Impact 中显式说明并保留新的 regression proof。

6. **Do not bypass a contract to prove the implementation**  
   不得通过篡改 score、硬编码报告、弱化 validator/gate、删除失败项或伪造 provenance 来制造成功证据。

7. **Formal acceptance is independent**  
   Executor 可以报告实现/测试状态，但不得自行把正式独立验收、人类质量验收、Release/Next-stage Gate 宣告为 PASS。需要独立 Reviewer 或明确的人类验收。

8. **Instruction conflict must be surfaced, not silently gamed**  
   Project/Task 可以细化 Workflow Defaults；若与 Hard Invariant 或已有产品合同冲突，应显式指出并执行 Contract Impact Check，不得用实现捷径同时“假满足”两个矛盾要求。

## Workflow Defaults

- 优先一个阶段对应一个可验证结果，避免一个 Medium/Low Bug 一个 Phase。
- 优先 minimal runnable loop → real evidence → targeted improvement → formal acceptance。
- 没有真实证据证明必要时，不新增 platform / registry / event bus / vector DB / multi-agent / new model/service。
- Builder、Independent Reviewer、Commit/Publish 分离。
- 默认不 `git add` / commit / push；当前用户任务可明确授权覆盖此默认。
- 正式 Stage / Review 工作流应生成可独立审查的 Review ZIP；完全局部的小修不必强制套完整流程。
- 需要人工观看/听取/判断时，Executor 只生成空白 human review fields，不自行填写 GOOD/PASS/YES。
