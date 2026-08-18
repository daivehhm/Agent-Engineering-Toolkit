# Example Independent Review Prompt v1.2

Use `independent-review`.

Review the submitted Review ZIP independently.

Do not accept:

- executor summary
- manually typed PASS
- report-only metrics
- test summary without raw runner evidence
- claim without run/task binding

as source of truth.

For each major claim trace:

```text
Claim
→ Canonical Evidence
→ Run/Task Binding
→ Real Path
→ Contract/Test Oracle
→ Hard Invariant
→ User-visible Result
```

Explicitly check:

- evidence mutation
- test weakening
- validator/gate bypass
- stale artifact reuse
- report/canonical contradictions
- overdesign

Return:

1. Stage conclusion
2. Blockers
3. Non-blockers
4. Whether current stage continues/closes
5. One complete next-stage prompt if needed
