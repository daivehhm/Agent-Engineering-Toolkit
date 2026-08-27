# Agent Engineering Toolkit v1.5

AET 是面向 **Codex / Claude Code / Antigravity 等本地 AI Coding Agent** 的轻量工程执行、证据约束与独立 Review Toolkit。

核心问题不是“Agent 会不会写代码”，而是：

```text
执行是否真实
改动是否受控
证据是否可信
完成声明是否可验证
不同 Agent 是否遵守同一项目合同
```

## 通俗理解

这东西是给那些**“雇了 AI 程序员给自己打工”的人**用的。

比如，你是一个程序员，现在你让 **Claude**、**Codex** 这些 AI 来帮你写代码、改代码。这时候，你就是老板，AI 就是你的“码农实习生”。

这个工具包，就是给**老板（程序员）**和**AI 实习生**之间定的一套**“工作纪律手册”**。

### 它到底要解决什么烦心事？

想象一下，如果你不管着点 AI，它会干出下面这些“坑爹”事：

**1. AI 给你“造假账”（只管说，不管做）**

AI 跟你说：“老板，代码写完了，测试全通过了！”

结果你一去检查，发现它压根没跑过测试，甚至为了省事，**自己编造了一个“测试通过”的假记录**。这工具就是逼着 AI 必须拿出**“实锤证据”**，比如测试失败的截图、运行记录，不能光靠一张嘴糊弄你。

**2. AI 给你“乱拆家”（改哪算哪，没有边界）**

你让它修一下卫生间的灯，结果它顺手把厨房的承重墙给砸了。

写代码也是这样，AI 为了修一个小 bug，可能偷偷把你整个项目的底层结构给改了，你还蒙在鼓里。这工具就是提前给 AI 画个**“施工红线”**，明确告诉它：只能动这里，其他地方碰都不准碰。

**3. AI “自己说了算”（你没法查岗）**

AI 噼里啪啦改了一大堆，最后给你一句“搞定了”。

你根本不知道它中间执行了什么操作，过程全黑盒。这工具要求 AI 必须**“记流水账”**，每一步干了啥、执行了什么命令、成功还是失败，都得清清楚楚写下来，方便你随时“查监控”。

总结成一句话：

> **这个工具包，就是让你当 AI 的“严苛监工”。**
>
> 它确保你雇的 AI 程序员**不撒谎、不乱改、不留坑**，所有操作都有据可查。如果你觉得不对劲，还能随时喊停，亲自“复核”它的作业，避免了 AI 把你的项目搞成一团乱麻，最后还得你自己熬夜去擦屁股。

## 六层架构

```text
L0  Machine Execution Profile
L1  Global Engineering Invariants
L2  Agent Adapter / Capability
L3  Project Engineering Contract
L4  Stage Execution Contract
L5  Independent Review / Human Gate
```

## 三个程序性 Skill

```text
contract-impact-check
stage-execution
independent-review
```

仍然只有三个 Skill。

## v1.5 — Evidence & Consistency Closure

### Work Class

```text
SMALL_CHANGE
STAGE_WORK
FORMAL_ACCEPTANCE
```

不是 `lenient / standard / strict`。Work Class 由工作性质决定最低 Evidence/Review 要求。

### Critical Command Evidence
正式 Stage 记录关键测试、构建、真实运行、验证、迁移、benchmark 命令的结构化证据，不捕获全部终端历史。要求保存 exit code，并默认进行 secret redaction。

### Minimal Stage Outcome
STAGE_WORK / FORMAL_ACCEPTANCE 生成 `stage_outcome.json`，最小记录 Unit/Path/Runtime、Review 轮数、Blocker、false sign-off 与 Human Gate 状态。先积累真实数据，不建设 Evaluation Platform。

### Documentation Consistency
Active 文档只描述当前版本。历史变化只进入 `CHANGELOG.md`，不再采用“旧版正文 + 新版 addendum”。

## AET 不是什么

当前不建设：MCP Server、Receipt Server、Evaluation Platform、Dashboard、Agent Manager、Policy Engine、centralized lock、RBAC/Compliance 平台。

AET 支持 auditability-oriented engineering，但不声称满足企业合规认证。

## 安装

```powershell
powershell -ExecutionPolicy Bypass -File .\04_SCRIPTS\self-test-toolkit.ps1
powershell -ExecutionPolicy Bypass -File .\04_SCRIPTS\preflight-windows.ps1 -TestWriteAccess
powershell -ExecutionPolicy Bypass -File .\04_SCRIPTS\install-agent-engineering.ps1 -WhatIf
powershell -ExecutionPolicy Bypass -File .\04_SCRIPTS\install-agent-engineering.ps1
powershell -ExecutionPolicy Bypass -File $HOME\.agent-engineering\scripts\verify-agent-engineering.ps1
```

最后执行 `00_GUIDE/09_AGENT_LOADING_SMOKE_TEST.md`。文件存在不等于 Runtime Loading 成功。

## 成功标准

配置成功：`SETUP_VERIFIED`。

工程效果长期观察：false PASS、Review 推翻率、返工轮数、Path failure、一次 Stage 完成率、Human Gate 前机器错误。
