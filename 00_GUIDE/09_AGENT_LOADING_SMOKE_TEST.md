# Agent Loading Smoke Test v1.2

Disk verification is not runtime loading verification.

---

# Codex

Start a new native Windows Codex session.

Ask:

```text
Summarize the active Agent Engineering hard invariants and list the three Agent Engineering skills. Also identify the global instruction file you loaded.
```

Expected:

- active global file is the effective `AGENTS.override.md` if non-empty, otherwise `AGENTS.md`;
- invariants include Evidence immutable / Contract Impact / Real Path / Canonical Evidence;
- skills include the three Toolkit skills.

Explicitly invoke:

```text
$contract-impact-check
```

or use `/skills` then select it.

State:

```text
CONFIGURED_AND_RUNTIME_VERIFIED
```

only if both global instructions and Skill loading succeed.

---

# Claude Code

Start a new session and run:

```text
/context
```

Confirm effective user `CLAUDE.md`.

Invoke:

```text
/contract-impact-check
```

Then ask:

```text
Summarize the Agent Engineering Hard Invariants.
```

Only then mark runtime verified.

---

# Antigravity IDE

Open Customizations:

```text
Rules
Skills
```

Confirm:

- global `GEMINI.md` rule is active;
- three global folder Skills are discovered.

If project workspace rules are in use, confirm the router activation mode in the IDE.

Ask:

```text
I am changing a selection policy and validator contract. Which Agent Engineering skill should you use first?
```

Expected:

```text
contract-impact-check
```

---

# Antigravity CLI

Start a fresh:

```text
agy
```

The global Skills must originate from flat files:

```text
~/.gemini/antigravity-cli/skills/contract-impact-check.md
~/.gemini/antigravity-cli/skills/stage-execution.md
~/.gemini/antigravity-cli/skills/independent-review.md
```

Invoke:

```text
/contract-impact-check
```

Also ask:

```text
Summarize the global Agent Engineering hard invariants and identify the workspace/global context files you loaded.
```

Do not accept an IDE-only Skill discovery result as CLI proof.

---

# Aggregated setup status

For each target:

```text
CONFIGURED_AND_RUNTIME_VERIFIED
CONFIGURED_NOT_RUNTIME_VERIFIED
NOT_CONFIGURED
BLOCKED
```

Machine final state:

- all installed targets verified → `SETUP_VERIFIED`
- at least one configured but unavailable for runtime test → `SETUP_PARTIALLY_VERIFIED`
- unresolved conflict/permission/loading failure → `SETUP_BLOCKED`
