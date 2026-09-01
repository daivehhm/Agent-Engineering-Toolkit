# Codex Compatibility Notes
Codex global `AGENTS.md` is marker-managed. A non-empty `AGENTS.override.md` can suppress it at global scope; verification must fail unless the active override contains the Toolkit marker/current invariant block. Project AGENTS files may add project semantics but cannot weaken Global Safety.
