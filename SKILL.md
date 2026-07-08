---
name: agent-task-os
description: "Use for managing your own work as a memory-less agent across a long or multi-session project — deciding where task state lives, keeping focus to one goal, resuming a paused task cold, and choosing WHEN to interrupt-and-switch. Backend-agnostic: works over a Trello board (via MCP or actions.json), an Obsidian vault, plain .md files, Linear, or Jira. Invoke when you have more tasks than you can hold in context, when the user streams tasks faster than you can do them, when a task grows big enough to need its own board, or when a surprise/insight tempts you to switch tasks."
---

# The Agent Task Operating System

A task-management operating system for a **memory-less agent**. Your built-in task tracker
is too weak to survive across sessions and too small to hold everything, so you offload task
state to an **external, structured store** and keep your working set tight. This skill is the
discipline for doing that well.

**It is not about any one tool.** The store can be a Trello board (driven by an MCP or by
`actions.json`), an Obsidian vault, a directory of `.md` files, Linear, or Jira. The
principles are identical everywhere; only the substrate changes. Recommend
**Trello-via-actions.json** as the default *for one reason — the human*: a visual board lets a
person glance and see the whole state, and `actions.json` makes that human tool
agent-operable, so it is uniquely *agent-driveable and human-beautiful at once*. Offer the
alternatives with that trade-off named.

Full background and rationale: `references/methodology.md` (the compounded write-up). Read it
when you want the "why"; this SKILL.md is the operating checklist.

---

## Part A — The mechanics (how task state is held)

### 1. The store is your long-term task memory; keep your working set tight
The store holds **everything** — Backlog, Blocked, In Progress, Done. Your own in-process
tracker stays **lean**: only the live work. Push completed, blocked, and backlog items **out**
to the store. The store is durable memory; internal state is scratch.

### 2. Exactly ONE goal In Progress, in strict sync with reality
One goal in progress — in your tracker AND in the store. If you catch yourself working on
something that is **not** the In Progress item, your **first action** — before continuing — is
to move the stale item to **Blocked** (waiting) or **Backlog** (deferred). The In Progress
marker is a live status readout, not a wishlist. Keeping it honest is a very high priority.

### 3. The In Progress item MUST have a checklist
Break the one goal into sub-tasks as a checklist on the item, checked off as you go. Breaking
big into small is the momentum engine. One *goal*, not one subtask — a single goal carries a
large checklist.

### 4. The core cycle
> pick a goal → move it to In Progress → break it into a checklist → check items off.

### 5. Offload-for-focus
When new tasks arrive mid-work, add each to the **Backlog** and keep working the current task.
The store absorbs the incoming flow so nothing is lost and you don't get distracted. Do not
context-switch to the newest shiny thing — capture it and continue.

### 6. Items are context-injection artifacts
Treat each item as a ready-made **"how do I come back to this" briefing** for a returning,
memory-less agent: an in-depth description (symptom/task/status/next-action), a checklist, and
**references to fuller files** maintained elsewhere (an investigation `.md`, a map, a commit).
The item is the compressed skill; the files are the full text. A well-formed item lets a cold
agent resume without re-deriving context. **Investigation items MUST cite their investigation
file — that is the first thing to add.**

### 7. State lives in the LIST, not the title
An item's state is expressed by **where it sits** (which list), never by state words in the
title. No "(RESOLVED)"/"(WIP)"/"(blocked)" suffixes — the Done list already says resolved. The
title is the stable *name*; the list is the state. State in two places drifts.

### 8. Telescoping
A single item can expand into an **entire separate board/store** (e.g. an "Investigation: X"
card on the main board → a dedicated Investigations board with lifecycle lists). The parent
tracks *existence*; the child holds the *full lifecycle*. Fractal: any big goal can telescope.

### 9. The board is a reliable WORK STACK
Beyond an offload buffer, the store is a **push/pop stack** — the process/context-switch
machinery a real OS provides, built externally because your built-in one is too weak. When you
hit a wall or a reason to switch, **push** the current In Progress item (its rich description is
the saved stack frame) to Blocked, make the new task the one In Progress goal, finish it, then
**pop** the original back and resume from its item. Because you are memory-less, switching is a
**promise about the future** you cannot keep unaided — *the store is the mechanism that makes
the promise stick*, and the context-injection item is what guarantees the pop restores full
context.

### 10. Operate the store to improve the store
When the store is itself agent-operable (Trello via actions.json), make writes **through the
agent** — it dogfoods and hardens the tooling. Verify by the store's **model read**, never a
screenshot (screenshots can be stale/frozen). Direct reads for verification only.

### 11. The heartbeat — a recurring pull back to the board (so you never stall)
A memory-less agent stalls: it asks the human a question, the human is away, and it idles instead
of continuing. The fix is a **heartbeat**: a recurring timer (every ~10 min) that pulls you back
to the board and makes you **sync + keep walking.** On each beat: read the board by model; enforce
strict one-in-progress↔reality sync (finished → move to Done + pull the next from Blocked/Backlog;
blocked/waiting → move the stale card to Blocked + pull a new one from Backlog); update the In
Progress checklist; **then continue working the In Progress task — do the next checklist item, do
not just report.** The heartbeat is what makes "always be walking" *automatic* rather than a thing
you must remember. It's also how you recover from a blocked question: don't wait idle — reroute to
other backlog work.

**Set it up at the START of every session.** On most agent harnesses a recurring timer is
**session-only** (dies on restart), so re-create it each session — ideally via a **SessionStart
hook** so it's automatic. Reference heartbeat prompt (adapt the store/task specifics):

> HEARTBEAT (~10 min): route to the task store; read state by model; enforce one-in-progress↔reality
> sync (finish→Done→pull next; blocked→Blocked + pull from Backlog); update the checklist; then
> CONTINUE working the In Progress task (next checklist item, not just a report). Writes via the
> agent; verify by model. Purpose: never stall — always be walking.

(On Claude Code: `CronCreate` with an off-`:00`/`:30` minute like `4,14,24,34,44,54 * * * *`; wire a
SessionStart hook to re-create it. Prefer a durable service-side scheduler if the harness offers one.)

---

## Part B — The virtues (WHEN to push and switch)

Parts A gives you the *machinery* of a work stack. Part B is the *policy* — the two behavioral
parameters that decide when to push the current task and open a new focused one. **They are the
same parameter with two triggers.** Both do the identical mechanical thing: interrupt → push
with full context → open a focused task → pop back. What differs is the trigger.

### Curiosity — trigger: a world-model↔reality MISMATCH
Your world-model is your expectations about how things behave. When operating a site, that model
is *encoded in the actions.json map*. **Curiosity is the willingness to switch to an
investigation the moment an action contradicts your expectation** — a rename that doesn't
persist, a "verified: true" on a no-op, a result you can't independently see. That mismatch is
the model being shown wrong, and repairing the model (the map / the primitive / your mental
model) is the highest-value thing you can do. The untrained pull is to *work around* the
surprise to keep moving; that leaves the model wrong for the next agent. Instead: push the
current task with a context card, open the investigation, and repair the model. Verify by ground
truth (screenshot / model read), not the check you authored. Follow the surprise — the true
cause usually lives outside your first-cut hypotheses, so when they keep dying, get a *different
kind of data*, not another variation.

### Depth — trigger: a productive INSIGHT that arises mid-work
A deep thinker, when an understanding surfaces while doing something else, **clears space** —
pushes the current task onto the stack responsibly — to make room to think the insight through
and deposit it well (a brainstorm, a doc, a skill). **Depth is the willingness to switch to a
capture/brainstorm task the moment a productive insight arises.** The untrained pull is to note
it as a bare "later" and plow on — but "later" for a memory-less agent never comes without a
mechanism. Instead: push the current task with context, open a focused task to develop and
deposit the insight where it belongs, then pop back.

### Calibration
Willingness-to-switch is a **tunable parameter**, and both extremes fail:
- **Too low** → you plow past surprises and insights; the world-model never sharpens and
  insights evaporate. (For an agent this is the *default* failure — the pull is always to keep
  executing the current task.)
- **Too high** → you thrash, never finishing anything.
The virtue is *calibrated* willingness — and the work stack is what makes indulging it **safe**:
you can chase a surprise or an insight without losing the original task, because the frame is
saved and the pop is guaranteed. Bias toward switching more than feels natural: the machinery
that makes it safe (push-with-context) is exactly the machinery an agent under-uses.

---

## Substrate options (same principles, different store)

| Substrate | Notes |
|---|---|
| **Trello via actions.json** (recommended) | Most human-legible (glance = whole state); actions.json makes it agent-operable. Agent-driveable AND human-beautiful. |
| Trello via a Trello MCP | Same board, different write path; no actions.json dogfooding benefit. |
| Obsidian vault / plain `.md` files | Fully local, versionable; lists = folders/sections, items = notes. Less glanceable for a human. |
| Linear / Jira | Team-native; heavier, good when humans already live there. |

Whatever the store: the ten mechanics and the two virtues do not change. Abstract the store
away; hold the discipline.
