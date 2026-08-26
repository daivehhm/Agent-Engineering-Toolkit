# Machine Execution Profile

Profile-Schema-Version: 1.0
Profile-Scope: MACHINE
Profile-Authority: LOCAL_USER_POLICY + MANAGED_DISCOVERY

## Purpose

Machine-level execution facts and machine-wide safety defaults shared by local engineering Agents.

This is NOT a project contract, Stage prompt, vendor configuration, or secret store.

## Core Interpretation

```text
Machine capability exists
!=
Current Agent is allowed/able to use it
```

Every Stage still verifies current-session capability.

## User Policy — PRESERVE ON REFRESH

```yaml
preferred_os: windows
preferred_shell: native-windows-powershell
wsl_for_windows_agent_configuration: prohibited
command_wrapper_policy: user-or-project-defined
network_default: project-or-stage-decides
git_add_commit_push: explicit-user-authorization
broad_process_kill: prohibited
secret_access: only-when-required-and-explicitly-authorized
parallel_writer_policy: one-writer-per-worktree
reviewer_write_policy: read-only-by-default
```

Optional local customization:

```yaml
command_wrapper_policy: rtk-required
network_default: offline-unless-stage-authorizes
preferred_python: D:\project\.venv\Scripts\python.exe
```

Do not put project thresholds, Stage URLs, acceptance data, or current defects here.

## Managed Discovery — DO NOT HAND-EDIT BETWEEN MARKERS

<!-- MACHINE-DISCOVERY:BEGIN -->
Discovery-State: NOT_REFRESHED
<!-- MACHINE-DISCOVERY:END -->

## Scope Boundary

Belongs here: OS/shell, local tool discovery, machine-wide process/Git/secret/network defaults.

Project semantics belong in Project Engineering Contract.
Stage-specific constraints belong in Stage Contract.
