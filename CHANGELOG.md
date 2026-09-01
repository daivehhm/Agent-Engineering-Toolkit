# Changelog

## 1.6.1 — 2026-09-01
- Fixed hidden C0 control characters in Start Here commands.
- Added package text-control scanning, native PowerShell parser checks, and JSON/JSONL parsing to self-test.
- Added idempotent Machine Profile safety-default migration for upgrades while preserving user policy.
- Restored fail-before-write conflict pre-scan across Codex / Claude / Antigravity IDE / Antigravity CLI Skills.
- Added backups before global adapter and Skill replacement; preserved non-mutating WhatIf behavior.
- Added fail-closed handling for active non-empty Codex `AGENTS.override.md` unless explicit integration is authorized.
- Installed canonical adapter templates and restored exact adapter/Skill drift verification.
- Made project router integration idempotent and prevented appending a blank Engineering Contract to an existing canonical contract.
- Expanded `FS_SEARCH_SAFETY_V1` from single-file location to expensive search/discovery/inventory/enumeration traversal; prefer an existing healthy index and do not trigger full rebuild just to avoid scoped search.
- No new governance layer, Skill, Registry, Policy Engine, MCP Server, or Agent Manager.

## 1.6.0 — 2026-08-31
- Added Global Invariant `FS_SEARCH_SAFETY_V1` from a real HDD saturation incident.
- Added lowest-I/O search order, concurrent scanner restriction, and main/subagent/delegated execution inheritance.
- Added fresh-session loading + behavioral smoke and explicit runtime coverage states.

## 1.5.0
- Cross-agent execution contracts, work classes, capability preflight, static adapter verification and three procedural Skills.
