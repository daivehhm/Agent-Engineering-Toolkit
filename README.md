# Agent Engineering Toolkit v1.6.3

Agent Engineering Toolkit（AET）是一套面向 Codex / Claude Code / Antigravity 等本地 AI Coding Agent 的轻量工程执行、证据约束与独立 Review Toolkit。

*Agent Engineering Toolkit (AET) is a lightweight engineering execution, evidence-control, and independent-review toolkit for local AI coding Agents such as Codex, Claude Code, and Antigravity.*


核心问题不是“Agent 会不会写代码”，而是：

*The core question is not whether an Agent can write code, but whether:*


```text
执行是否真实 / execution is real
改动是否受控 / changes are controlled
证据是否可信 / evidence is trustworthy
完成声明是否可验证 / completion claims are verifiable
不同 Agent 是否遵守同一项目合同 / different Agents follow the same project contract
```


## 通俗理解
## Plain Explanation

这东西是给那些“雇了 AI 程序员给自己打工”的人用的。比如，你是一个程序员，现在你让 Claude、Codex 这些 AI 来帮你写代码、改代码。这时候，你就是老板，AI 就是你的“码农实习生”。这个工具包，就是给老板（程序员）和 AI 实习生之间定的一套“工作纪律手册”。

*This is for people who have effectively hired AI programmers to work for them. For example, if you are a developer asking Claude, Codex, or another coding Agent to write and modify code, you are the boss and the AI is your coding intern. This toolkit is the work-discipline manual between the developer and that AI intern.*


AET 主要解决三个烦心事：AI 给你“造假账”，说测试通过但实际没跑；AI 给你“乱拆家”，修一个小 bug 却偷偷改了底层结构；AI “自己说了算”，改完只说搞定了，过程不可查。

*AET mainly addresses three pain points: the AI fakes the books by claiming tests passed without running them; the AI changes the house by touching architecture or unrelated code while fixing a small bug; and the AI acts as its own judge by saying “done” without leaving a traceable process.*


所以，AET 要求 AI 拿出“实锤证据”，例如 exit code、运行记录和测试结果；要求 AI 遵守“施工红线”，只改允许改的地方；还要求 AI 留下“流水账”，让关键操作、失败、重跑和结论都能被复核。

*That is why AET requires hard evidence such as exit codes, run logs, and test results; clear work boundaries so the Agent touches only what is allowed; and an audit trail so key commands, failures, reruns, and conclusions can be reviewed.*


总结成一句话：这个工具包，就是让你当 AI 的“严苛监工”。它确保你雇的 AI 程序员不撒谎、不乱改、不留坑，所有操作都有据可查。

*In one sentence: this toolkit helps you act as a strict supervisor for AI coding Agents. It keeps them from lying, making uncontrolled changes, or leaving hidden problems behind, while making important work auditable.*


## 六层架构
## Six-Layer Architecture

AET 采用六层架构，把机器能力、全局纪律、Agent 适配、项目合同、阶段执行和独立 Review 分开，避免把所有规则混成一团。

*AET uses a six-layer architecture that separates machine capability, global discipline, Agent adaptation, project contracts, stage execution, and independent review instead of mixing all rules into one place.*


```text
L0  Machine Execution Profile
L1  Global Engineering Invariants
L2  Agent Adapter / Capability
L3  Project Engineering Contract
L4  Stage Execution Contract
L5  Independent Review / Human Gate
```


## 三个程序性 Skill
## Three Procedural Skills

AET 仍然只有三个程序性 Skill：`contract-impact-check`、`stage-execution` 和 `independent-review`。它们负责在语义变化、阶段执行和独立复核时提供最小但硬的流程约束。

*AET still has only three procedural Skills: `contract-impact-check`, `stage-execution`, and `independent-review`. They provide minimal but strict process constraints for semantic changes, stage execution, and independent review.*


```text
contract-impact-check
stage-execution
independent-review
```


## v1.5 — 证据与一致性闭环
## v1.5 — Evidence & Consistency Closure

v1.5 引入 Work Class，由工作性质决定最低 Evidence/Review 要求。Work Class 不是 `lenient / standard / strict`，而是 `SMALL_CHANGE`、`STAGE_WORK` 和 `FORMAL_ACCEPTANCE`。

*v1.5 introduces Work Class, where the nature of the work determines the minimum evidence and review requirements. Work Class is not `lenient / standard / strict`; it is `SMALL_CHANGE`, `STAGE_WORK`, and `FORMAL_ACCEPTANCE`.*


```text
SMALL_CHANGE
STAGE_WORK
FORMAL_ACCEPTANCE
```


Critical Command Evidence 要求正式 Stage 只记录关键测试、构建、真实运行、验证、迁移和 benchmark 命令的结构化证据；必须保存 exit code，要求 secret redaction，并且默认不捕获全部终端历史或完整环境变量。

*Critical Command Evidence requires formal stages to record structured evidence only for key test, build, real-runtime, validation, migration, and benchmark commands. It must preserve exit code, requires secret redaction, and does not capture the full terminal history or full environment by default.*


Minimal Stage Outcome 要求 `STAGE_WORK` / `FORMAL_ACCEPTANCE` 生成 `stage_outcome.json`，最小记录 Unit/Path/Runtime、Review 轮数、Blocker、false sign-off 与 Human Gate 状态。它是派生摘要，不能覆盖真实测试和运行证据。

*Minimal Stage Outcome requires `STAGE_WORK` / `FORMAL_ACCEPTANCE` to produce `stage_outcome.json`, minimally recording Unit/Path/Runtime, review rounds, blockers, false sign-off, and Human Gate status. It is a derived summary and must not override real test or runtime evidence.*


Documentation Consistency 要求 active 文档只描述当前版本，历史变化进入 `CHANGELOG.md`，不再采用“旧版正文 + 新版 addendum”的写法。

*Documentation Consistency means active documents describe only the current version, while historical changes go into `CHANGELOG.md`. The project no longer uses an “old body plus new addendum” style.*


## v1.6.x — 安全与运行期验证增量
## v1.6.x — Safety & Runtime Verification Increment

在保持六层架构和三个程序性 Skill 不变的前提下，v1.6.x 增加文件系统搜索安全边界 `FS_SEARCH_SAFETY_V1`、Toolkit-managed Skill 保护、Runtime Loading 与静态配置分离，以及 Stage Review ZIP 完整性要求。详细历史变更见 `CHANGELOG.md`。

*Without changing the six-layer architecture or the three procedural Skills, v1.6.x adds `FS_SEARCH_SAFETY_V1`, Toolkit-managed Skill protection, separation of runtime loading from static configuration, and Stage Review ZIP completeness requirements. See `CHANGELOG.md` for detailed history.*


## AET 不是什么
## What AET Is Not

当前 AET 不建设 MCP Server、Receipt Server、Evaluation Platform、Dashboard、Agent Manager、Policy Engine、centralized lock 或 RBAC/Compliance 平台。AET 支持 auditability-oriented engineering，但不声称满足企业合规认证。

*AET currently does not build an MCP Server, Receipt Server, Evaluation Platform, Dashboard, Agent Manager, Policy Engine, centralized lock, or RBAC/Compliance platform. AET supports auditability-oriented engineering, but it does not claim enterprise compliance certification.*


## 目录结构
## Directory Layout

仓库目录包括 `00_GUIDE`、`01_CANONICAL`、`02_SKILLS`、`03_ADAPTERS`、`04_SCRIPTS`、`05_EXAMPLES` 和 `06_VALIDATION`。其中 `01_CANONICAL` 是规范源，`02_SKILLS` 是三个程序性 Skill，`04_SCRIPTS` 是 Windows 安装、同步、预检和验证脚本。

*The repository contains `00_GUIDE`, `01_CANONICAL`, `02_SKILLS`, `03_ADAPTERS`, `04_SCRIPTS`, `05_EXAMPLES`, and `06_VALIDATION`. `01_CANONICAL` contains canonical contracts, `02_SKILLS` contains the three procedural Skills, and `04_SCRIPTS` contains Windows install, sync, preflight, and verification scripts.*


## 安装
## Installation

安装建议先自检，再做 Windows 预检，然后执行 `-WhatIf` 预览，确认无误后正式安装，最后运行验证脚本。

*The recommended installation flow is: run the self-test, run the Windows preflight, run the `-WhatIf` preview, perform the real install after checking the preview, and then run verification.*


```powershell
powershell -ExecutionPolicy Bypass -File .\04_SCRIPTS\self-test-toolkit.ps1
powershell -ExecutionPolicy Bypass -File .\04_SCRIPTS\preflight-windows.ps1 -TestWriteAccess
powershell -ExecutionPolicy Bypass -File .\04_SCRIPTS\install-agent-engineering.ps1 -WhatIf
powershell -ExecutionPolicy Bypass -File .\04_SCRIPTS\install-agent-engineering.ps1
powershell -ExecutionPolicy Bypass -File $HOME\.agent-engineering\scripts\verify-agent-engineering.ps1
```


已有 AET 安装需要升级时，先运行 `INSTALL_UPGRADE_PREVIEW.cmd`，确认预览结果后再运行 `INSTALL_UPGRADE.cmd`；不要用全新安装入口静默覆盖已有版本。

*For an existing AET installation, run `INSTALL_UPGRADE_PREVIEW.cmd` first and only then `INSTALL_UPGRADE.cmd` after reviewing the preview. Do not silently overwrite an existing installation through the fresh-install path.*


最后执行 `00_GUIDE/09_AGENT_LOADING_SMOKE_TEST.md`。文件存在不等于 Runtime Loading 成功。

*Finally, run `00_GUIDE/09_AGENT_LOADING_SMOKE_TEST.md`. File existence does not prove Runtime Loading success.*


## 成功标准
## Success Criteria

配置文件和 Skill 通过静态验证后，仍需 fresh-session Runtime Loading 验证。完整通过状态以 verifier 输出 `CONFIGURED_AND_RUNTIME_VERIFIED` 为准；只有静态配置完成时应保持 `CONFIGURED_NOT_RUNTIME_VERIFIED`。

*After static verification of configuration files and Skills, fresh-session runtime-loading verification is still required. Full success is represented by `CONFIGURED_AND_RUNTIME_VERIFIED`; static configuration alone remains `CONFIGURED_NOT_RUNTIME_VERIFIED`.*


工程效果仍需长期观察，包括 false PASS、Review 推翻率、返工轮数、Path failure、一次 Stage 完成率和 Human Gate 前机器错误。

*Engineering effectiveness should still be observed over time through false PASS, review overturn rate, rework rounds, path failure, one-pass Stage completion rate, and machine errors before Human Gate.*


## 许可证
## License

本项目使用 MIT License。详见 `LICENSE`。

*This project is released under the MIT License. See `LICENSE`.*
