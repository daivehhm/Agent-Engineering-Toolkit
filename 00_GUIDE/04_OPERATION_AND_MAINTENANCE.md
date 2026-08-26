# Operation and Maintenance v1.5

Canonical install root: `%USERPROFILE%\.agent-engineering\`.

## Machine Profile
机器工具/运行时变化后：
```powershell
$HOME\.agent-engineering\scripts\refresh-machine-profile.ps1
```
只更新 managed discovery block，不覆盖 User Policy。

Machine Available != Agent Accessible。正式 STAGE_WORK / FORMAL_ACCEPTANCE 仍需 Capability Preflight。

## Skill Sync
```powershell
$HOME\.agent-engineering\scripts\sync-agent-engineering.ps1
```
同步 Codex folder Skills、Claude folder Skills、Antigravity IDE folder Skills、Antigravity CLI flat Skills。

## Verify
```powershell
$HOME\.agent-engineering\scripts\verify-agent-engineering.ps1
```
Disk Verify 不替代 Runtime Loading Smoke。

## Upgrade
```powershell
.\04_SCRIPTS\install-agent-engineering.ps1 -UpgradeCanonical -WhatIf
```
审查后实际升级。

## Documentation Discipline
Active 文档只描述当前版本。历史进入 CHANGELOG。禁止继续“旧正文 + 新 addendum”。

## Evidence Maintenance
只保存足够 Independent Review 的证据；不默认保存完整终端历史、全量环境变量、secrets、私有大文件、node_modules、模型权重。

## AET Self-Evaluation
通过 stage_outcome.json 积累真实 Stage 数据；真实跨项目数据不足前不建设 Evaluation Harness/Dashboard。
