# Agent Engineering Toolkit v1.6.1

Agent Engineering Toolkit（AET）是一套面向 Codex / Claude Code / Antigravity 等本地 AI Coding Agent 的轻量工程执行、证据约束、安全约束与独立 Review Toolkit。

## 六层架构

```text
L0  Machine Execution Profile
L1  Global Engineering Invariants
L2  Agent Adapter / Capability
L3  Project Engineering Contract
L4  Stage Execution Contract
L5  Independent Review / Human Gate
```

AET 仍然只有三个程序性 Skill：`contract-impact-check`、`stage-execution`、`independent-review`。v1.6.1 没有引入 Policy Engine、Agent Manager、MCP Server、Registry 或新的治理层。

## FS_SEARCH_SAFETY_V1

该规则来自一次真实 Windows HDD 事件：Agent 为确认 `data_aishell3.tgz` 是否存在，从 `D:\` 和 `E:\` 执行无边界 `Get-ChildItem -Recurse`，机械盘活动时间升至约 87–100%，停止扫描后回落到接近空闲。

v1.6.1 将规则扩大到高成本的 **search / discovery / inventory / enumeration traversal**，而不只“找单个文件”：

```text
expected destination
→ current project/workspace
→ known download/cache/dataset/model locations
→ existing healthy filesystem index
→ narrowly scoped candidate directories
→ whole-drive/root recursion only with explicit authorization
```

不得为了避免 scoped search 而主动触发 full index rebuild；默认不得并发多个 full-disk / large-tree scanner。规则覆盖 main Agent、subagent、delegated tool/shell/script 和替代执行路径。

## v1.6.1 修复内容

v1.6.0 的二次自检发现安装/验证链存在发布阻断项，因此 v1.6.1 重点做闭环修复：

- 修复 `00_START_HERE_FOR_ANY_AGENT.md` 中破坏命令的隐藏控制字符。
- Self-test 增加 C0 控制字符扫描、PowerShell native parser、JSON/JSONL 解析、Adapter version/reference 检查。
- v1.5/v1.6 旧 Machine Profile 升级时保留用户 policy，仅幂等补齐缺失的 filesystem safety defaults。
- Installer 在任何写入前完成全部 Skill / Antigravity CLI unmanaged conflict pre-scan。
- 现有全局 Agent 配置和被替换的 Skill 在修改前备份；`-WhatIf` 不写入。
- 非空 Codex `AGENTS.override.md` 若会压制 Global `AGENTS.md`，默认 fail closed；仅在显式 `-IntegrateCodexOverride` 时集成。
- 安装 `adapters/` canonical templates，使 verifier 可以做 marker 内容的确定性 drift comparison。
- Verifier 恢复 Skill tree / CLI flattened Skill 的精确内容比较，而非只检查 marker 是否存在。
- `bootstrap-project.ps1 -IntegrateExisting` 改为 idempotent marker integration；已有 `ENGINEERING_CONTRACT.md` 永不追加空白 skeleton。

## 安装 / 升级

先执行 dry-run，不要直接覆盖：

```powershell
powershell -ExecutionPolicy Bypass -File .\04_SCRIPTS\self-test-toolkit.ps1
powershell -ExecutionPolicy Bypass -File .\04_SCRIPTS\preflight-windows.ps1 -TestWriteAccess
powershell -ExecutionPolicy Bypass -File .\04_SCRIPTS\install-agent-engineering.ps1 -WhatIf
```

已有旧版本时：

```powershell
powershell -ExecutionPolicy Bypass -File .\04_SCRIPTS\install-agent-engineering.ps1 -UpgradeCanonical -WhatIf
```

Review `WhatIf` 后再去掉 `-WhatIf`。若非空 Codex `AGENTS.override.md` 阻断加载，先人工 Review，再按需增加 `-IntegrateCodexOverride`。

安装后：

```powershell
powershell -ExecutionPolicy Bypass -File $HOME\.agent-engineering\scripts\refresh-machine-profile.ps1
powershell -ExecutionPolicy Bypass -File $HOME\.agent-engineering\scripts\verify-agent-engineering.ps1
```

静态验证通过仍只表示 `PASS_STATIC`。真正的 Agent loading、behavioral compliance 和 subagent inheritance 使用 `00_GUIDE/09_AGENT_LOADING_SMOKE_TEST.md` 在 fresh session 中验证。

## 边界

AET 是 instruction/configuration-level 工程规则，不是 OS 级 shell interceptor。当前证据不足以证明需要建设中央 Policy Engine 或强制 command gateway。如果已正确加载规则后仍反复出现同类绕过，再根据真实事件决定是否升级 hard enforcement。

## License

MIT License.
