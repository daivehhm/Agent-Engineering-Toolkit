# v1.6.1 Socratic Pre-Release Review

## Stage Goal
Produce one installable AET package whose filesystem safety rule can be upgraded and statically verified across the currently supported Codex / Claude Code / Antigravity adapters without false PASS or unmanaged configuration overwrite.

## Blocking questions and resolutions

1. **Could package text itself be malformed?** Yes in v1.6.0. C0 scan added and Start Here repaired.
2. **Could PowerShell syntax errors ship?** Native parser gate added to self-test; native Windows execution is still required before final setup sign-off.
3. **Could upgrade omit the new Machine Profile policy?** Fixed by preserve-and-merge migration.
4. **Could a later conflict appear after earlier writes?** Skill/CLI conflicts are pre-scanned before write activity.
5. **Could unmanaged user Skills be overwritten?** Fail closed by default; explicit force path backs up.
6. **Could an Agent global override suppress AET?** Codex active override is handled fail closed and verified as the active configuration.
7. **Could verifier confuse marker presence with content correctness?** Exact marker/Skill comparisons restored.
8. **Could regex replacement corrupt `$skill` tokens?** MatchEvaluator insertion used.
9. **Could repeated project bootstrap create duplicate governance text?** Marker-idempotent routers; canonical contract never auto-appended.
10. **Could a narrow root still be expensive?** Policy covers high-cost traversal intents and existing healthy indexes, but cannot predict every filesystem topology; runtime judgment remains required.
11. **Could subagents or delegated scripts bypass instruction-level rules?** Rule scope explicitly includes them, but inheritance remains a runtime smoke requirement rather than an unsupported claim.
12. **Should this become a central Policy Engine?** No. Current acceptance goals are met inside existing L0/L1/L2 + installer/verifier surfaces.

## Remaining non-blocking boundaries

- AET cannot discover or configure arbitrary future Agent products without an adapter.
- Instruction-level policy is not an OS-level command interceptor.
- Installation is backup/idempotency oriented, not transactionally rolled back across every possible I/O failure.
- Project-specific rule precedence must be checked when a project introduces vendor-specific override files.

## Exit decision
Static package is suitable for **Native Windows validation**, not yet for `SETUP_VERIFIED`. Final setup sign-off requires package self-test, preflight, WhatIf review, real install/upgrade, static verify, and fresh-session loading/behavior/subagent smoke for each installed/used supported target.
