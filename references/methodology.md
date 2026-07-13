---
title: "The agent task-management operating system (Trello-backed, agent-operated)"
module: task-management
date: 2026-07-08
problem_type: best_practice
component: development_workflow
severity: high
applies_when:
  - "Managing agent tasks/backlog across a long-running project on a Trello board"
  - "The user piles on new tasks mid-work and focus must be preserved"
  - "Deciding where durable task memory lives vs. the agent lean in-process list"
  - "A single task grows large enough to need its own board (telescoping)"
  - "Returning to a paused task and needing a self-contained context briefing"
  - "Hitting a wall that spawns a blocking sub-task and needing to push/pop reliably"
tags:
  - trello
  - task-management
  - workflow
  - hosted-agent
  - context-injection
  - telescoping
  - work-stack
  - best-practices
related_components:
  - assistant
  - documentation
---

# Agent Kanban (Trello-backed, agent-operated)

## Context

> **The substrate is interchangeable — the principles are the same everywhere.** What matters is the
> **discipline** (offload, one-in-progress focus, checklist, telescoping, push/pop work stack,
> context-injection items) — abstract the store away. You can keep this in an Obsidian vault, a bunch of `.md`
> files, Linear, Jira, or a Trello board (via an MCP or via actions.json). The principles do not change.
>
> **But the substrate choice matters for one reason — the human.** Trello is the **most beautiful, most
> human-legible** way to keep this information: its visual board lets a person *glance* and see the whole state,
> so it is the natural way to **share what's going on with a human**. And `actions.json` is what makes Trello —
> a visual tool built for humans, not agents — reliably **agent-operable**. So the Trello-via-actions.json combo
> is uniquely strong: **agent-driveable and human-beautiful at once.** Recommend it as the default; offer the
> alternatives with their trade-offs. This methodology is slated to become a standalone, backend-agnostic skill
> ("Agent Kanban") imported as a submodule, with Trello-via-actions.json as the flagship
> reference implementation.


An agent working long autonomous sessions was drowning in its own work. It kept
**6+ tasks marked "in progress" at once**, carried a **flat 160-item internal task
list**, and got knocked off course every time the user piled on new work mid-task —
context-switching to the newest thing and losing the thread it was on.

The root problem is structural, not a discipline failure: **a memory-less agent has
no durable place to hold task state across sessions.** Without an external, structured
task memory it drops work, over-commits, and loses focus. Its internal tracker is both
too big (holding everything) and too fragile (evaporates at session end).

The user — dogfooding the actions.json Trello map — established a task-management
**operating system** built on a Trello board that is **operated through a hosted
browser agent**. The board becomes the agent's long-term task memory; the hosted agent
is the write path; the agent's own internal tracker shrinks to just the live work.
This is "skills are context management" applied to task resumption.

## Guidance

The system is a small set of rules. Follow them together — each one props up the others.

### 1. Trello is the offload / long-term task memory
The board holds **everything** across lists: **Backlog, Next, Blocked, In Progress, Done**.
Your own internal tracker stays **lean — only the in-process work.** Push completed,
blocked, and backlog items **out** to Trello; keep the internal list small. The board is
the durable memory; internal state is scratch.

### 2. Exactly ONE goal "In Progress" at a time
One goal in progress — **internally AND on the board.** Strict In-Progress↔reality sync
is a **very high priority.** If you catch yourself working on something that is **not**
the In Progress card, your **first action** is to move the stale card to **Blocked**
(waiting on a linked task) or **Next** (runnable but not active) — *before* you continue working. The
In Progress marker is a **live status readout, not a wishlist.** It must always describe
what you are actually doing right now.

### 3. The In Progress card MUST have a checklist
The one in-progress goal is broken into **smaller sub-tasks as a checklist on the card**,
checked off as you go. Breaking a big task into small tasks is what creates **productive
engagement — it is the momentum engine.** Note the rule is **one goal, not one subtask**:
a single in-progress goal can and should carry a large checklist.

### 4. The core dev cycle
> **pick a goal → move its card to In Progress → break it into a checklist ON the card → check items off as you go.**

This is the loop. Everything else supports keeping this loop clean.

### 4.5. Finish/block sync gate
Whenever a task is finished or blocked, **sync the board before doing anything else.** The
board is the durable truth; if the conversation says one thing and the board says another,
the next memory-less agent will trust the board and resume wrong.

If a task is finished:

1. Read the checklist/proof state from the board model.
2. Run the required CE Compound closure after completion is verified. Lightweight is the ordinary default;
   Standard/Full handles repeated, cross-component/repository, overlap-prone, or explicitly Full work; Deep
   handles security, privacy, data-loss, production incidents, or explicit Deep requests. The deepest applicable
   trigger wins.
3. Move the card to **Done** only when completion and closure are verified.
4. If proof is missing, keep it out of Done and record exactly what proof is missing.

If a task is blocked:

1. Move the parent card from **In Progress** to **Blocked**.
2. Write the blocker(s) on the parent card: what is blocked, what unblocks it, and links to
   evidence/commits/logs.
3. Create a separate unblocker card in **Next** for each blocker. If the blocker is a bug, create an
   **Investigation:** card for that bug and make its first checklist item either the
   investigation file path or creating that file.
4. Link every blocker from the parent. Blockers may themselves be in Next, In Progress, or Blocked,
   so Blocked-to-Blocked chains are allowed, but the dependency graph must remain acyclic.
5. Move the topmost Agent runnable card from Next into **In Progress** and work it.
6. When the final direct blocker reaches Done, return the parent from Blocked to **Next** at the top
   of its executor/priority bucket. Normal queue selection decides when it resumes.

Never leave a card in **In Progress** while telling the user it is blocked. That is not a
minor bookkeeping issue; it corrupts the operating system's process table.

#### Closure evidence is stronger than checklist completion

Done is an evidence transition, not a checkbox transition. For an investigation, read its
remediation artifact and map every applicable immediate, structural, systemic, documentation,
test, release, migration, and live-verification phase to direct proof. Depending on the phase,
that proof is a committed change, a passing test, a released or deployed artifact, or a live
verification at the affected boundary. Checked analysis, a documented failure, an accepted limitation, or a follow-up card does not substitute for remediation. An artifact still marked
`CURRENT`, `OPEN`, `deferred`, or `awaiting remediation` contradicts Done until newer evidence
proves every declared phase complete.

CE Compound runs only after that implementation/remediation proof is complete. A legitimate no-learning result is a successful closure outcome: record it and allow Done. A CE Compound execution failure is a bug, not a no-learning result. Keep the original card out of Done, move it
to Blocked with a linked investigation, remediate and verify the failure, then rerun CE Compound
successfully before the original can close.

Example: ordinary verified work uses Lightweight and may close after a recorded no-learning result.
A cross-repository production-incident remediation uses Deep because the deepest trigger wins. If
Deep fails to execute, the original remains Blocked while the failure investigation becomes the
active goal; the original returns to Next only after that blocker is fully remediated.

### 5. Offload-for-focus and queue authority
When the user **dumps new tasks mid-work**, have the browser agent **add each one to the
Next** with one executor label and one High, Normal, or Low priority label, then **keep working
the current task.** New work defaults to Normal. Next is a priority-bucketed stack: insert new
work at the top of its own priority bucket and promote the topmost Agent runnable card. Human
required work sits after all Agent runnable work. Backlog↔Next transitions are human-level
prioritization decisions; an agent exception requires a verified lifecycle reason and an
explanation note. Do not context-switch merely because a new task arrived.

### 6. Operate through the agent (dogfooding)
**All Trello writes** — add/move/label/checklist cards, create lists/boards — go
**through the hosted browser agent via natural-language prompts. NEVER direct primitive
calls for writes.** This dogfoods and continuously improves the site's actions.json map:
every operation exercises and hardens the tooling. Direct calls are for **reads /
verification only.** And **verify by the board MODEL read** (`actions.site` board read),
**never a canvas screenshot** — screenshots can be stale or frozen and will lie to you.

### 7. Telescoping boards (fractal hierarchy)
A card on one board can **expand into an entire separate board.** The main board tracks
the **existence** of a thing — one card, e.g. "Investigation: X". A **dedicated board**
(e.g. an Investigations board with lists **Bug → Investigating → Root Cause →
Remediation → Done**) holds that thing's **full lifecycle.** The hierarchy is
**fractal/recursive**: any big goal can telescope into its own project board while
remaining a single card on its parent.

### 8. A card is a context-injection artifact
Treat each card as a ready-made **"how do I come back to this task" briefing** for a
returning, memory-less agent. A card can be extensive:
- an in-depth **description** (symptom / task / status / next-action),
- a **checklist**, and
- **references to fuller files** maintained elsewhere (an investigation `.md`, the map,
  the commit) so the card stays contained but **points to depth.**

The card is the **compressed skill**; the files are the **full text.** A well-formed card
lets a cold agent resume without re-deriving context.

### 9. Next is an executable priority stack
Every Next card has exactly one executor label (`Agent runnable` or `Human required`) and one
priority label (`Priority: High`, `Priority: Normal`, or `Priority: Low`). Keep all Agent runnable
cards before Human required cards. Within each executor class, maintain High, Normal, and Low
buckets; each new card enters at the top of its bucket. The next task is the topmost Agent runnable
card. Only when no Agent runnable work remains may the top Human required card move to In Progress
for a decision or action.

If agent-runnable work appears while a Human required card is awaiting a response in In Progress,
preserve the request, return the human card to the top of its Human/priority bucket, and resume the
topmost Agent runnable task. During every sync, traverse Blocked dependencies. Reject new cycle-forming
edges. For an inherited cycle, remove its provably newest edge; if history cannot establish recency,
move the participants to Backlog with lifecycle-exception notes and create a High-priority Human required
Next card to establish their order without guessing.

## Why This Matters

A memory-less agent across sessions needs an **external, durable, structured task
memory** or it drops work, over-commits, and loses focus. This system delivers four
properties at once:

- **Focus** — exactly one In Progress goal, kept honestly in sync with reality.
- **Resumability** — cards are context injections a cold agent can resume from.
- **Scalability** — Next/Backlog offload plus telescoping boards absorb unbounded work.
- **A virtuous loop** — operating via the hosted agent improves the very tooling
  (actions.json map) that the operation depends on.

It is the direct application of **"skills are context management"** to the problem of
**task resumption**: the board and its cards are the reliable attention highway across
sessions, the same way a skill is the reliable attention highway within one.

## When to Apply

Apply this system to any **long-running or multi-session autonomous agent** that:

- **(a)** accumulates more tasks than it can hold in working context,
- **(b)** loses continuity between sessions (no durable memory), or
- **(c)** operates a website it is also improving (dogfooding the map).

It is **especially** valuable when the **user streams tasks faster than they can be
done** — the offload-for-focus rule is what lets the user pile on without derailing the
agent.

## Examples

### Before / After — over-commitment and distraction
- **BEFORE:** 6 tasks marked `in_progress`; a flat 160-item internal list; a new task
  arrives → the agent context-switches and **loses the current thread.**
- **AFTER:** **1 In Progress card with a 9-item checklist**; a new task arrives →
  *"agent, add to Next"* → the agent **keeps focus.** If it ever notices it drifted,
  the stale In Progress card is **moved to Blocked before switching.**

### Telescoping
The main board card **"Investigation: Trello board-tools"** telescopes into a **dedicated
Investigations board** with lists **Bug → Investigating → Root Cause → Remediation →
Done.** The parent board still shows a single card; the child board holds the whole
lifecycle.

### Card-as-context-injection
An In Progress card whose **description carries everything a cold agent needs to resume**:
- the **goal**,
- the **status**: *"board.create LIVE-PROVEN, 5 lists built, remaining: seed 22 cards"*,
- the **root-cause lesson** learned so far, and
- **file references**: `investigations/<slug>.md`, the seed manifest, the map path.

That single card is enough to **resume cold** — the compressed skill on the board, the
full text in the files it points to.

## The board is a reliable WORK STACK (the deepest reason it is an "operating system")

The offload buffer is only half of it. The board is a **push/pop stack** for work — the process/context-switch machinery a real OS provides, built externally because a memory-less agent built-in task tool is too weak.

The pattern that demands a stack: you are working task **A**, you **hit a wall**, and the wall **is** a new task **B** that must be done first to *unblock* A. So you **PUSH A** (pause it, store full context in its card), **switch to B**, focus on B until done, then **POP back to A** with full context restored.

Switching to B is a **promise about the future** — "I will come back to A." A memory-less agent **cannot keep promises about the future on its own** ("later" never comes without a mechanism). **The board is the mechanism that makes the promise stick**, and the context-injection card is what guarantees the pop **restores full context** so A resumes cold. Mechanically: when a wall spawns a blocking sub-task, push the current In Progress card (its rich description is the saved *stack frame*) to **Blocked** ("blocked on B"), link B as its blocker, and put B in **Next**. The queue promotes the topmost Agent runnable task. Blocked chains may telescope through other Blocked cards so long as no cycle exists. When A's final direct blocker reaches Done, return A to Next; normal stack selection later restores it from its card. This is also a **control plane** for the user: the board makes the agent task-switching visible and steerable.


## Related
- `investigations/trello-board-manipulation-tools-authoring.md` — the tooling/authoring investigation that BUILDS the primitives this methodology depends on (trello.board.create, board lists, telescoping links). Different altitude: that file is how to AUTHOR the Trello map actions; this doc is the task-management METHODOLOGY that consumes them.
- `investigations/browser-screenshot-stale-frame-on-docs-canvas.md` — why "verify by the board MODEL, not a screenshot": canvas screenshots can be frozen/stale.
- `skills/write-actions-json/SKILL.md` — the actions.json authoring playbook the Trello map (dogfooded by this system) is written against.
