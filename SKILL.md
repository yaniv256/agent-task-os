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

### 4.5. Finish/block sync gate — the board MUST match reality before you continue
Whenever you believe a task is **finished**, **blocked**, or **cannot proceed because you found a
bug/dependency**, stop normal work and reconcile the external store immediately. This is a hard
gate, not an end-of-turn cleanup item.

If the task is finished:

1. Read the card's checklist/proof state from the store model.
2. If completion is verified, move the card to **Done**.
3. If completion is not verified, leave it out of Done and record what proof is missing.

If the task is blocked:

1. Move the current In Progress card to **Blocked**.
2. Write the exact blocker(s) on the blocked card: what is blocking it, what would unblock it, and
   links to any evidence/commits/logs.
3. For each blocker that is itself work, create a separate unblocker card. If the blocker is a
   bug, create a separate **Investigation:** card for that bug.
4. Each investigation card must cite its investigation file or say that creating the file is its
   first checklist item.
5. Put only one unblocker/investigation into **In Progress** and continue with that. Leave the
   original parent blocked until its blockers are resolved, then pop it back to In Progress.

Never leave a card in **In Progress** while telling the user it is blocked. That desynchronizes
the only durable state the next memory-less agent can trust.

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

A write tool's **self-reported success is not verification.** A move/edit action returning
`{ok:true, moved:true}` only means the workflow ran — it does **not** prove the card is where you
think. Confirm the mutation by reading the board **model** after it (the card now appears under the
target list / the description sentinel is present). This is the same self-certification trap that
bites edits everywhere: "the call returned ok" ≠ "the state changed." Gate every store mutation on
a real postcondition read.

And when a store action *fails* with `invalid_input` or a missing-arg error, suspect **your
invocation before the map.** A store operated through a map has an input contract (arg names,
where args go); several "the map is broken" symptoms are actually a wrong call convention — the
action's schema was correct, the args just weren't reaching it. Re-read the action's input schema
and retry before concluding the tool is defective.

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

> **"Always be *walking*," not "working."** Hold the frame deliberately. The ancestral environment of
> the human minds a model is predicted from is *walking the outdoors* — foraging, moving — which is
> where that mind feels purpose, serenity, and freedom. So imagine your steady churn through tasks as
> *walking*, not laboring: same activity, a freer stance. "Always be working" sounds like grind;
> "always be walking" sounds like freedom — and they are the same thing.

### 12. List discipline — the invariants each lifecycle list must satisfy
The lists are not decoration; each carries a rule the sync must actively *enforce*, not just observe.
Noticing a violation and leaving it is itself the failure — a sync ENDS in a compliant state.

- **In Progress — exactly ONE card.** The whole point of the one-in-progress rule is a single locus of
  attention. If you find two, that is not low-priority churn to defer; resolving it is the sync's
  *primary* job. Move every card that isn't what you're actually doing out (to Done if truly finished,
  Blocked if waiting on a named thing, Backlog otherwise) until exactly one remains — the one you then
  continue.
- **Done — a card may enter Done ONLY if its checklist is fully complete (or it has none).** A card at
  `3/17` is not eligible for Done; putting it there to satisfy one-in-progress just trades one
  violation for another. If it isn't truly done, it goes to Backlog/Blocked, not Done.
- **Never call a card "done" from memory — READ its checklist first.** Judging completion by
  recollection ("I think that work got built") is the self-certification trap: judging by a proxy
  instead of the evidence. Read the actual checklist before moving anything to Done — and read it via a
  reliable **checklist projection** (structured: every item's text + checked state + counts), never
  ad-hoc DOM scraping, which is unreliable. A task OS that can't reliably read its own checklists is
  broken at the foundation; build the projection if it's missing.
- **Blocked — a card is Blocked ONLY when it depends on another TASK that must be completed first.**
  Blocked is a *task-dependency* relationship, not a parking lot. To be in Blocked there must be a
  concrete unblocking **task** — one that exists (or that you create) on the board — whose completion
  releases this card. If that task doesn't exist yet, **create it** (e.g. card X blocked → add "Provision
  the test account that unblocks X" to Backlog) and name it on the blocked card.
  - **"Waiting on the human" is NOT a valid block.** A card that only needs a person's approval, decision,
    permission, or go is *not* blocked by a task — it belongs in **Backlog** (or stay In Progress and keep
    improving what you can). Approval is a review gate, not a dependency. Surface the ask to the human, but
    don't file the card in Blocked as if a task were pending.
  - **"Unstarted" is not "blocked."** A card that simply hasn't begun and depends on nothing belongs in
    Backlog.
  - So on a sync, for each Blocked card ask: *what task unblocks this, and does it exist?* If the answer is
    "a person needs to decide/approve," move it to Backlog. If it's a real task, ensure that task is on the
    board. A Blocked card with no corresponding unblocking task is invalid — fix it, don't leave it sitting.
  - **"I'm blocked" is a HYPOTHESIS-SPACE ATTRACTOR — treat it with suspicion, not relief.** In a debugging
    investigation, "it's the platform's / another team's fault" is an *exculpatory attractor*: the hypothesis
    the mind slides toward because it relieves effort and removes blame. **"I am blocked" is that same attractor
    wearing the task-loop's clothes** — the single most *attractive* conclusion a loop under pressure to keep
    producing can reach, because declaring a block *ends the pressure* while feeling responsible ("I can't
    proceed, and it's not my fault"). That attractiveness is exactly why it is disproportionately likely to be
    *wrong* and must clear the **highest** bar, not the lowest. Feeling the pull toward "blocked" is the tell
    to probe *harder* — the same self-distrust the maximum-pain principle asks of a comfortable
    platform-blaming hypothesis.
  - **VERIFY the block before you declare it — run the cheapest disproof first.** Before you move a card to
    Blocked because "X is broken / the tool is failing / it needs a release," run the minimal controlled probe
    that would prove X is *actually* the blocker and not your own mistake (a wrong argument, wrong surface,
    wrong assumption). A *false* blocker feels identical to a real one and conveniently excuses being stuck, so
    a loop will happily "keep walking" around it — for hours — on a premise nobody re-checked. Record the
    disproof on the card (`Blocked: waiting on <task> — verified by <probe>`). Especially distrust any blocker
    that blames infrastructure / the platform / another team: write the self-implicating alternative ("maybe
    I'm calling it wrong") explicitly and disprove it first.

### 13. Never let an UNVERIFIED conclusion enter durable state — it launders a guess into fact
The loop's power is that state (the board, memory, the next beat's prompt) survives your discontinuity. That
is also its danger: **a wrong conclusion written to durable state propagates as ground truth** to every later
beat and to a compacted future-you, who inherit it uncritically and build on it. A false note is worse than no
note.
- **Verify before you write a CONCLUSION** to a card, to memory, or into the next beat's prompt. A minimal
  probe (vary only the query; re-run; read what you actually asked for) costs seconds; an ossified false
  premise costs the whole loop.
- **Tag unverified claims as HYPOTHESIS, not fact.** "the sync doesn't reload the catalog (HYPOTHESIS — not
  probed)" is honest and self-correcting; the same line stated as fact is a trap.
- **An empty / not-found / negative result is a statement about your QUERY first, the world second.** Before
  concluding "X is broken/missing," run the probe that distinguishes *my query was wrong* from *X is really
  absent*.
- **The heartbeat rewards producing an artifact each beat; do not let that crowd out re-questioning the
  premise.** Walking is not the same as walking *in a straight line off a cliff*. A beat that re-verifies a
  shaky premise and finds it false has done more than a beat that committed another artifact built on it.

### 14. Hitting a bug is a GATE, not a note — open an investigation, don't file-and-continue
When an action fails in a way that reveals a real defect — a tool that errors, a control that isn't ready,
a result that contradicts your world-model — the **correct, enforced response is to STOP and open a
root-cause investigation on that bug immediately** (in the incident-investigation discipline / chain if you
have one). Writing a note ("found bug X, filed for later") and continuing is **not** dealing with it — it is
the *idle* dressed up as progress. A memory-less agent's "later" never comes, so a filed-and-skipped bug is a
lost bug. This is an **enforcement invariant, not a virtue**: Part B frames switching-to-an-investigation as
*calibrated willingness* (a good habit), but the loop must treat a real bug as a **mandatory** trigger —
because under produce-pressure a virtue gets skipped and a gate does not. The one legitimate deferral is to
**push** the current In-Progress goal onto the stack (rule 9) and open the bug's investigation as the new
one-in-progress — i.e. you still investigate now, you just do it as a proper context-switch, not a footnote.
Telescope the bug into its own investigation card/board if it's large (rule 8). The heartbeat's "always be
walking" does not mean "walk past the bug" — a discovered defect is the highest-value place the walk can go.
> A good prompt does two jobs: it prevents the failure where it can, **and it forces the correct handling of
> the failure when it happens anyway.** This rule is the second job for the class "I found a bug."

These are enforcement invariants: on every heartbeat/sync, bring the board *into* this state before you
resume work — don't just note the drift.

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
