# Agent Engineering Toolkit v1.3

面向 Windows 本地 **Codex / Claude Code / Google Antigravity IDE / Antigravity CLI** 的跨 Agent 工程规则与 Skill 配置包。

## 先理解 Toolkit

如果第一次接触本 Toolkit，先读：

```text
00_OVERVIEW.md
```

它回答：是什么、为什么、目标、解决什么问题、什么时候使用、什么时候不使用。

---

## 任意 Agent 从哪里开始？

**唯一入口：**

```text
00_START_HERE_FOR_ANY_AGENT.md
```

如果执行者不是人，而是 Codex / Claude Code / Antigravity / 其他本地 Agent，请先读该文件，不要凭经验直接运行安装脚本。

---

# 核心目标

减少复杂工程中的高成本错误：

- 局部 helper 实现了，但真实数据链未生效；
- 新 Selection/Scoring 与旧 Validator/Gate 冲突；
- 为了 PASS 篡改 score、报告、测试或 provenance；
- Unit Test PASS 被误当成真实产品 PASS；
- Executor 自己宣布正式验收通过；
- Agent 配置文件“存在”但产品实际没加载；
- 不同 Agent 的 Skill 布局被错误当成完全一致；
- 自动配置覆盖用户已有规则或同名 Skill。

---

# v1.3 内容补全

1. 新增 `00_START_HERE_FOR_ANY_AGENT.md`，让无历史上下文的 Agent 也能确定执行顺序。
2. 新增 native Windows `preflight-windows.ps1`。
3. 明确 native Windows vs WSL，非 Windows 环境 fail-closed。
4. 修复 Antigravity CLI Skill 布局：
   - IDE：`<skill>/SKILL.md`
   - CLI：`<skill>.md` flat file
5. `sync` 先扫描全部 Skill 冲突，再做任何 Skill 写入。
6. 修复 `-WhatIf` 仍可能创建 backup/目录的副作用。
7. 修复 `bootstrap-project -Force -IntegrateExisting` 可能先覆盖既有 Agent 配置的问题。
8. Verify 同时检查：
   - Codex active override
   - Claude effective config dir
   - Antigravity IDE folder skills
   - Antigravity CLI flat skills
9. 成功状态分为：
   - `SETUP_VERIFIED`
   - `SETUP_PARTIALLY_VERIFIED`
   - `SETUP_BLOCKED`
10. 明确 Agent 权限不足时不得通过关闭 sandbox / 放宽安全设置来“完成安装”。

---

# 推荐安装

从解压后的 Toolkit 根目录：

```powershell
powershell -ExecutionPolicy Bypass -File .\04_SCRIPTS\self-test-toolkit.ps1
```

然后：

```powershell
powershell -ExecutionPolicy Bypass -File .\04_SCRIPTS\preflight-windows.ps1 -TestWriteAccess
```

再 dry-run：

```powershell
powershell -ExecutionPolicy Bypass -File .\04_SCRIPTS\install-agent-engineering.ps1 -WhatIf
```

确认后安装：

```powershell
powershell -ExecutionPolicy Bypass -File .\04_SCRIPTS\install-agent-engineering.ps1
```

安装后：

```powershell
powershell -ExecutionPolicy Bypass -File $HOME\.agent-engineering\scripts\verify-agent-engineering.ps1
```

最后必须执行：

```text
00_GUIDE/09_AGENT_LOADING_SMOKE_TEST.md
```

---

# 配置架构

```text
Canonical Source
~/.agent-engineering/
        │
        ├── Global Hard Invariants
        ├── Contract Impact
        ├── Stage Execution
        ├── Independent Review
        └── Project Templates
        │
        ├── Codex
        │   ├── $CODEX_HOME/AGENTS(.override).md
        │   └── ~/.agents/skills/<skill>/SKILL.md
        │
        ├── Claude Code
        │   ├── <CLAUDE_CONFIG_DIR>/CLAUDE.md
        │   └── <CLAUDE_CONFIG_DIR>/skills/<skill>/SKILL.md
        │
        ├── Antigravity IDE
        │   ├── ~/.gemini/GEMINI.md
        │   └── ~/.gemini/config/skills/<skill>/SKILL.md
        │
        └── Antigravity CLI
            ├── ~/.gemini/GEMINI.md
            └── ~/.gemini/antigravity-cli/skills/<skill>.md
```

---

# 三个通用 Skill

- `contract-impact-check`
- `stage-execution`
- `independent-review`

Always-On 只放 Hard Invariants / 少量 Workflow Defaults。

过程性内容按需加载 Skill，避免全局 Context 膨胀。

---

# 项目配置

只有用户明确要求配置某个项目时才运行：

```powershell
$HOME\.agent-engineering\scripts\bootstrap-project.ps1 `
  -ProjectRoot "D:\path\to\project" `
  -TestCommand "<real test command>" `
  -WhatIf
```

既有项目优先：

```text
-IntegrateExisting
```

它必须保留原 `AGENTS.md / CLAUDE.md / GEMINI.md` 正文，只维护 Toolkit marker block。

---

# 安全边界

Toolkit 不负责：

- 安装三种 Agent 产品
- 登录认证
- API Key
- Provider/model
- sandbox/approval policy
- 网络代理
- Git commit/push

这些不能为了安装 Toolkit 被自动修改。

---

# 推荐阅读顺序

1. `00_START_HERE_FOR_ANY_AGENT.md`
2. `00_GUIDE/00_SOCRATIC_SELF_REVIEW_AND_V1_2_CHANGES.md`
3. `00_GUIDE/02_AGENT_CONFIGURATION_GUIDE.md`
4. `00_GUIDE/11_ANY_AGENT_WINDOWS_INSTALLATION_PLAYBOOK.md`
5. `01_CANONICAL/01_AGENT_ENGINEERING_INVARIANTS.md`


---

# v1.3 新增的产品级说明

新增：

```text
00_OVERVIEW.md
00_GUIDE/13_USAGE_SCENARIOS_AND_DECISION_TREE.md
00_GUIDE/14_ROLES_LIFECYCLE_AND_SUCCESS_CRITERIA.md
```

这三个文件集中回答：

- 是什么
- 为什么
- 目标
- 解决什么问题
- 什么场景使用
- 什么场景不要使用
- Builder / Reviewer / Human 分工
- 完整生命周期
- Stage 如何定义
- 如何判断配置成功
- 如何判断工程质量成功
- Toolkit 自身是否真正产生价值
