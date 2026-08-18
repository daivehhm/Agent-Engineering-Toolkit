# Known Limitations — v1.2

## 1. Native Windows runtime not executed in this artifact build

PowerShell scripts were assembled and statically reviewed here.

They still require execution in the user's native Windows environment before `SETUP_VERIFIED`.

## 2. Agent permissions are external to the Toolkit

A local Agent may be sandboxed to the project workspace.

Toolkit does not disable that boundary.

## 3. Antigravity IDE workspace-rule activation is a UI/runtime property

The Toolkit can create `.agents/rules/engineering-contract-router.md`.

It does not invent undocumented activation metadata.

If project workspace rules are used, activation must be verified in Antigravity IDE.

## 4. Missing target product

The Toolkit may configure files for an Agent that is not installed.

That target is:

```text
CONFIGURED_NOT_RUNTIME_VERIFIED
```

not PASS.

## 5. Vendor paths can change

Adapters are based on official documentation verified 2026-08-18.

If vendor behavior changes, update the adapter/scripts; do not rewrite canonical engineering principles unless those principles changed.

## 6. Automatic rollback is not transaction-managed

The installer creates timestamped backups where it replaces existing content and is designed to be idempotent.

If a rare partial failure occurs:

- Verify
- resolve cause
- rerun
- or uninstall

Manual restoration from timestamped backups remains available.

A transactional rollback engine was deliberately not added because it would materially increase Toolkit complexity without current evidence that it is necessary.

## 7. Project contract content is not safe to auto-infer universally

The project template is only a skeleton.

Product-specific canonical objects, state semantics, gates, and runtime contracts still require project-specific judgment.
