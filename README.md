# agent-task-os

A standalone, backend-agnostic skill: **the Agent Task Operating System** — how a memory-less
agent manages its own work across a long or multi-session project.

- **`SKILL.md`** — the operating checklist. Part A: the mechanics (offload store, one goal in
  progress, checklist, context-injection items, state-in-list, telescoping, work stack, operate-
  to-improve). Part B: the two virtues that decide *when* to push-and-switch — **curiosity**
  (trigger: world-model↔reality mismatch → investigate) and **depth** (trigger: a productive
  insight → brainstorm/capture) — as one calibrated behavioral parameter.
- **`references/methodology.md`** — the fuller compounded write-up (the "why").

**Backend-agnostic.** The task store can be a Trello board (via an MCP or `actions.json`), an
Obsidian vault, plain `.md` files, Linear, or Jira. Recommended default is
**Trello-via-actions.json** — uniquely agent-driveable *and* human-beautiful — but the
principles are identical across substrates.

## Status

First draft (2026-07-08). Intended to become its own repo, imported as a submodule (like
`incident-investigation`). Companion skills it composes with:
- `incident-investigation` — what curiosity switches *into* when the world-model breaks.
- `write-actions-json` — how the Trello store is authored when the substrate is actions.json.

## TODO (next iterations)
- Worked examples (the push/pop of a real investigation; a depth-driven capture).
- Concrete store adapters / recipes per substrate.
- Convert to a chained-prompt if phased execution proves valuable.
- Turn into its own git repo + submodule wiring.
