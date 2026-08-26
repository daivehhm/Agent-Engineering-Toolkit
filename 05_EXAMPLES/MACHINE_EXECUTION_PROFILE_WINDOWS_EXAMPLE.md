# Machine Execution Profile — Windows Example

Example only.

```yaml
preferred_shell: native-windows-powershell
command_wrapper_policy: rtk-required
network_default: offline-unless-stage-authorizes
git_add_commit_push: explicit-user-authorization
broad_process_kill: prohibited
parallel_writer_policy: one-writer-per-worktree
reviewer_write_policy: read-only-by-default
```

Even if ffmpeg/nvidia-smi are discovered, current Agent still proves access in its sandbox/session.
