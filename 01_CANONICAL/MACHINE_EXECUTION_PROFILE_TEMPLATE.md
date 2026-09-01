# Machine Execution Profile

Profile-Schema-Version: 1.1
Profile-Scope: MACHINE
Profile-Authority: LOCAL_USER_POLICY + MANAGED_DISCOVERY

## Purpose
Machine-level execution facts and machine-wide safety defaults shared by local engineering Agents.

## Core Interpretation
```text
Machine capability exists != Current Agent is allowed/able to use it
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
filesystem_search_policy_id: FS_SEARCH_SAFETY_V1
drive_root_recursive_search: explicit-user-authorization
concurrent_large_tree_scans: prohibited-by-default
indexed_search_preference: existing-healthy-index-preferred
```

Local policy may be stricter than the Global Invariants; it may not weaken `FS_SEARCH_SAFETY_V1`.

## Managed Discovery — DO NOT HAND-EDIT BETWEEN MARKERS
<!-- MACHINE-DISCOVERY:BEGIN -->
Discovery-State: NOT_REFRESHED
<!-- MACHINE-DISCOVERY:END -->

## Scope Boundary
Belongs here: OS/shell, local tool discovery, machine-wide process/Git/secret/network defaults and stricter machine safety. Project semantics belong in Project Engineering Contract. Stage-specific constraints belong in Stage Contract.
