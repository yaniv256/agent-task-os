# agent-kanban

A standalone, backend-agnostic skill: **Agent Kanban** — how a memory-less
agent manages its own work across a long or multi-session project.

- **`SKILL.md`** — the operating checklist. Part A: the mechanics (offload store, one goal in
  progress, checklist, executor and priority labels, linked unblockers, full-remediation closure,
  CE Compound closure, context-injection items, telescoping, work stack, operate-to-improve).
  Part B: the two virtues that decide *when* to push-and-switch — **curiosity**
  (trigger: world-model↔reality mismatch → investigate) and **depth** (trigger: a productive
  insight → brainstorm/capture) — as one calibrated behavioral parameter.
- **`references/methodology.md`** — the fuller compounded write-up (the "why").

**Backend-agnostic.** The task store can be a Trello board (via an MCP or `actions.json`), an
Obsidian vault, plain `.md` files, Linear, or Jira. Recommended default is
**Trello-via-actions.json** — uniquely agent-driveable *and* human-beautiful — but the
principles are identical across substrates.

## Status

Active standalone skill, imported as a submodule by actions.json.dev. Companion skills it composes with:
- `incident-investigation` — what curiosity switches *into* when the world-model breaks.
- `write-actions-json` — how the Trello store is authored when the substrate is actions.json.

## Queue contract

- Exactly one card is In Progress.
- New work enters Next with one executor label and one three-level priority label. Next is a priority-bucketed stack: new work enters at the top of its High, Normal, or Low bucket, and the top Agent runnable card is selected next.
- Blocked cards form an acyclic dependency graph over Next, In Progress, and Blocked, then return to Next when their final direct blocker reaches Done.
- Investigations close only after full remediation and verification.
- Verified work runs CE Compound before entering Done.

## Migration from `agent-task-os`

- The canonical skill identity is now `agent-kanban`; update explicit invocations and skill registries to that name.
- Rename installed skill directories from `agent-task-os` to `agent-kanban` when the host uses folder-based discovery.
- Existing consumers may temporarily keep the legacy checkout or submodule path while updating references; the `name` in `SKILL.md` is authoritative during that transition.
- After the repository is renamed, update submodule URLs to the canonical `agent-kanban` repository. GitHub's old-repository redirect is a migration aid, not the permanent configured URL.
- In each importer, sweep and update explicit invocations and filesystem paths. Reconcile deployed skill mirrors and chained-prompt `skill_path` values in the same migration.
- For submodule importers, verify `.gitmodules` path and URL plus `git submodule status`, then load `skills/agent-kanban/SKILL.md` from the importer to prove discovery works from the installed location.
- Finish with a repository-wide search to grep-clean unintended `agent-task-os` references. Retain the old name only in intentional migration notes or compatibility fixtures.
