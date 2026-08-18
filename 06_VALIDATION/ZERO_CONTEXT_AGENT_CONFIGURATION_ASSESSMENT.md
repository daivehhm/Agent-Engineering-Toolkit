# Zero-Context Agent Configuration Assessment

## Question

Can an arbitrary local engineering Agent receive only this package and correctly configure the user's Windows-local Codex, Claude Code, Antigravity IDE, and Antigravity CLI?

## Answer

**Conditionally yes by design, but not unconditionally guaranteed.**

### The package is self-contained for decision-making

A zero-context Agent can determine:

- where to start;
- which files to read;
- which Windows paths actually apply;
- how to discover CODEX_HOME / CLAUDE_CONFIG_DIR;
- how to treat Codex AGENTS.override;
- the distinct Skill formats of each product;
- how to preserve existing configuration;
- when to stop for a conflict;
- how to dry-run;
- how to verify disk state;
- how to verify actual Agent loading;
- how to report partial/blocked setup.

### What no package can guarantee

The executor may lack:

- native Windows shell access;
- permission to write user-profile paths;
- the target product itself;
- permission to launch/restart the product;
- approval to replace a conflicting user Skill.

The package treats those conditions as evidence, not as instructions to bypass controls.

## Acceptance standard

The correct claim is:

> Any sufficiently capable local Agent with native Windows PowerShell access and authorized write/runtime access can use this ZIP without prior conversation context to perform a deterministic, non-destructive, evidence-checked setup.

If the capabilities are absent, the same package can still produce the correct:

```text
SETUP_BLOCKED
```

or:

```text
SETUP_PARTIALLY_VERIFIED
```

instead of a false success.

That fail-closed behavior is part of “accurate configuration.”
