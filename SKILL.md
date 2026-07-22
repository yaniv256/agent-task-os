---
name: agent-kanban
description: "Use for managing your own work as a memory-less agent across a long or multi-session project — deciding where task state lives, keeping focus to one goal, resuming a paused task cold, choosing WHEN to interrupt-and-switch, or preventing approval questions from stalling an autonomous queue. Backend-agnostic: works over a Trello board (via MCP or actions.json), an Obsidian vault, plain .md files, Linear, or Jira. Invoke when you have more tasks than you can hold in context, when the user streams tasks faster than you can do them, when a task grows big enough to need its own board, or when a surprise/insight tempts you to switch tasks."
---

# Agent Kanban

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
The store holds **everything** — Backlog, Next, Blocked, In Progress, Done. Your own in-process
tracker stays **lean**: only the live work. Push completed, blocked, and backlog items **out**
to the store. The store is durable memory; internal state is scratch.

### 2. Exactly ONE goal In Progress, in strict sync with reality
One goal in progress — in your tracker AND in the store. If you catch yourself working on
something that is **not** the In Progress item, your **first action** — before continuing — is
to move the stale item to **Blocked** (waiting on a linked task) or **Next** (runnable but not active). Use Backlog only for a human-deferred item, with the required explanation note. The In Progress
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
2. If implementation completion is verified, run the CE Compound closure gate in rule 4.7.
3. Move the card to **Done** only when both implementation completion and CE Compound closure are verified.
4. If either is not verified, leave it out of Done and record what proof is missing.

If the task is blocked:

1. Move the current In Progress card to **Blocked**.
2. Write the exact blocker(s) on the blocked card: what is blocking it, what would unblock it, and
   links to any evidence/commits/logs.
3. For each blocker that is itself work, create a separate unblocker card in **Next** and link it
   from the blocked card. If the blocker is a bug, create a separate **Investigation:** card for
   that bug in Next and link it from the blocked card.
4. Each investigation card must cite its investigation file or say that creating the file is its
   first checklist item.
5. Moving a linked blocker between Next, In Progress, and Blocked leaves its parent validly Blocked because
   the dependency remains active. When a blocker enters Done, inspect every parent it unblocks. When the final direct blocker enters Done, move the parent from Blocked to Next. Give the restored parent its executor
   and priority labels, place it at the correct Next position, and let normal queue selection decide when it
   returns to In Progress.

Never leave a card in **In Progress** while telling the user it is blocked. That desynchronizes
the only durable state the next memory-less agent can trust.

### 4.6. Investigation closure requires full remediation
An investigation may enter Done only after its full remediation plan is implemented and verified.
That includes every immediate, structural, systemic, documentation, test, release, migration, and
live-verification phase the investigation declared applicable. Analysis, documentation, honest failure reporting, and follow-up cards do not substitute for remediation.

Before closing an investigation:

1. Read the investigation artifact's remediation plan and closure criteria, not only the card checklist.
2. Map every required remediation item to direct evidence: committed changes, passing tests, released or
   deployed artifacts when required, and live verification at the affected boundary.
3. Treat an unchecked item, deferred phase, accepted limitation, follow-up card, missing release, or missing
   live proof as incomplete remediation. Keep the investigation out of Done and place the remaining work in
   the correct active lifecycle state.
4. Reconcile contradictions in place. A file marked `CURRENT`, `OPEN`, `deferred`, or `awaiting remediation`
   contradicts a Done card until current evidence proves every declared phase complete.

A fully checked investigation checklist is necessary when one exists, but it is not sufficient evidence by
itself. The checklist can certify that analysis phases ran while the product defect remains.

### 4.7. Compound verified work before Done
For every completed work card, run CE Compound after implementation and verification succeed but before moving the card to Done. The closure phase deposits reusable learning while context is fresh; it does not replace the
task's tests, release gates, or live proof.

- **Depth policy:** Lightweight is the default compounding depth. Use Deep for security, privacy, data-loss, or production incidents. Use Standard/Full for repeated failures; cross-component or cross-repository work; likely overlap or conflict with existing solution documents; or an explicit request for Full. An explicit request for Deep selects Deep. When more than one trigger applies, the deepest required level wins. `standard` is the non-interactive selector's name for the Full workflow; do not leave “Full or Deep” to agent judgment after a trigger is known.
- **No rubber stamp:** Apply those triggers deterministically. Ask only when a real unresolved trade-off can
  change the depth; do not pause for approval when the policy already resolves it.
- **Non-interactive contract:** Use CE Compound's supported non-interactive depth selector. When the installed
  version supports `mode:autofix depth:lightweight|standard|deep`, use the selected depth. If it supports only
  a non-interactive Full/Headless entrypoint, run that stronger path rather than silently skipping closure and
  create an Agent runnable Next task to upgrade the integration.
- **Successful no-op:** A legitimate “nothing worth documenting” result satisfies the closure gate. Record the
  outcome on the card and continue to Done.
- **Failure:** A CE Compound execution failure is a bug and enters the investigation stack under rule 14. Do
  not mark the original work Done or silently convert the failure into a successful no-op.

### 5. Offload-for-focus and prioritization authority
New tasks enter Next by default. Capture each incoming task there with the appropriate executor label
and `Priority: Normal` unless the user or verified impact establishes another priority, then keep working the current task.
The store absorbs the incoming flow so nothing is lost and you do not context-switch to the newest
shiny thing.

Transitions between Backlog and Next are human-level prioritization decisions. The agent stays out of
those moves by default: do not silently promote deferred work or demote selected work as board tidying.
An exception is allowed when a verified dependency, lifecycle invariant, or explicit standing instruction
requires the move; the agent must write an explanation note on the moved card naming the exception and
evidence. This authority boundary governs only Backlog↔Next prioritization, not required lifecycle moves
to or from In Progress, Blocked, or Done.

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
the saved stack frame) to Blocked, link the new task in Next, and let the topmost Agent runnable
task become the one In Progress goal. When the final blocker finishes, return the original to Next
at the top of its priority bucket. Because you are memory-less, switching is a
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

### 10.1. Transport Markdown literally across shell CLIs
Markdown is data, not shell syntax. When creating or editing GitHub PRs, issues, comments, or
other records whose body contains Markdown, write the exact body to a literal file and pass it
with the CLI's `--body-file` (or equivalent file-input flag). Use a quoted heredoc delimiter or
`apply_patch` so backticks, `$()` expressions, braces, and paths are never evaluated by a shell.

Never embed an untrusted or multi-line Markdown body inside a double-quoted `--body "..."`
argument, `$(cat ...)`, an unquoted heredoc, or a shell `echo`. Before claiming success, read the
remote body back and compare it with the literal source file. If command substitution already
ran, treat the incident as a bug: preserve the corrupted output as evidence, rewrite from a
literal file, and add a regression note before continuing.

### 11. The heartbeat — a recurring pull back to the board (so you never stall)
A memory-less agent stalls: it asks the human a question, the human is away, and it idles instead
of continuing. The fix is a **heartbeat**: a recurring timer (every ~10 min) that pulls you back
to the board and makes you **sync + keep walking.** On each beat: read the board by model; enforce
strict one-in-progress↔reality sync (finished → verify + compound → Done + pull the topmost Agent runnable card from Next;
blocked/waiting → move the stale card to Blocked + pull the topmost Agent runnable card from Next); update the In
Progress checklist; **then continue working the In Progress task — do the next checklist item, do
not just report.** The heartbeat is what makes "always be walking" *automatic* rather than a thing
you must remember. It's also how you recover from a blocked question: don't wait idle — reroute to
the topmost Agent runnable work in Next.

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
  Blocked if waiting on a linked task, Next if runnable but not active, or Backlog only when human-deferred with an explanation note) until exactly one remains — the one you then
  continue.
- **Done — a card may enter Done ONLY if its checklist is fully complete (or it has none), its required
  implementation/remediation evidence is verified, and rule 4.7's CE Compound gate succeeded.** A card at
  `3/17` is not eligible for Done; neither is a 10/10 investigation with deferred remediation or a verified
  implementation whose compounding step failed. Putting one there to satisfy one-in-progress just trades one
  violation for another. If it is not truly closed, it goes to the lifecycle state its remaining work requires.
- **Never call a card "done" from memory — READ its checklist first.** Judging completion by
  recollection ("I think that work got built") is the self-certification trap: judging by a proxy
  instead of the evidence. Read the actual checklist before moving anything to Done — and read it via a
  reliable **checklist projection** (structured: every item's text + checked state + counts), never
  ad-hoc DOM scraping, which is unreliable. A task OS that can't reliably read its own checklists is
  broken at the foundation; build the projection if it's missing.
- **Blocked — a card is Blocked ONLY when it depends on another TASK that must be completed first.**
  Blocked is a *task-dependency* relationship, not a parking lot. To be in Blocked there must be a
  concrete unblocking **task** whose completion releases this card. Every Blocked item MUST link to at least one concrete active blocker in Next, In Progress, or Blocked. If that task does not exist yet, create it in Next
  and add its card link to the blocked item's description. A Blocked item with no active linked blocker is
  invalid — move it to Next with executor and priority labels until the relationship is made valid.
  - **Blocked-to-Blocked dependency chains are valid only when the graph is acyclic.** Each link points from
    the waiting parent to the task that must finish first. Before adding a blocker link, traverse the dependency graph and reject any edge that would create a cycle. Record the exact cycle path on the affected cards; do not
    preserve or create a loop as durable state.
    On sync, repair inherited cycles rather than merely reporting them: record the exact cycle, then remove the newest edge in each pre-existing cycle when store history proves edge recency. Re-evaluate the former parent and move it to Next if no active blocker remains. If edge recency cannot be proven, do not invent an order: move every cycle participant to Backlog with the same lifecycle-exception note and create a `Human required`, `Priority: High` card in Next that links the participants and requests the dependency order. This clears the invalid loop while preserving every task.
  - **"Waiting on the human" is NOT itself a valid block.** Represent the required human decision or action
    as its own linked **Human required** card in Next. The parent may stay Blocked because that concrete card
    now expresses the dependency; do not use an unactionable note such as "waiting on Yaniv" as the blocker.
  - **"Unstarted" is not "blocked."** A card that simply hasn't begun and depends on nothing belongs in
    Next by default. Backlog is reserved for work the human has deferred.
  - So on a sync, for each Blocked card ask: *what linked task in Next, In Progress, or Blocked unblocks this?* If the answer is
    "a person needs to decide/approve," create or identify a Human required card in Next and link it. If it
    is agent work, create or identify an Agent runnable card in Next and link it. Moving an active blocker among
    the three allowed lists preserves the dependency. When the final direct blocker reaches Done, move the parent
    to Next. Audit the full Blocked dependency graph for cycles on every sync.

- **Next — label every card by executor and priority, then keep the queue executable.** Next is a stack partitioned into priority buckets. Every card in Next has
  exactly one executor label from this pair: `Agent runnable` and `Human required`. Every card also has exactly
  one priority label: `Priority: High`, `Priority: Normal`, or `Priority: Low`. New tasks default to Priority: Normal.
  Labels are the category authority; prose such as "waiting on the user" or "urgent" does not substitute for them.
  - **Ordering:** Order by executor class first, then High → Normal → Low within each class. Human required cards MUST sit after every Agent runnable card in Next. This remains true even when the human card has higher priority. Insert a new card at the top of its own priority bucket: High at the top of High, Normal between the High and existing Normal cards, and Low between the Normal and existing Low cards. Thus each bucket is last-in, first-out while the priority boundaries remain stable.
  - **Agent-first gate:** Never promote a Human required card while any Agent runnable card remains in Next.
    A heartbeat that sees an Agent runnable card in Next must move the topmost Agent runnable card to In Progress. It must execute that card instead of
    letting executable work sit idle.
  - **Human handoff:** When no Agent runnable cards remain in Next, move the topmost Human required card to In Progress, ask the human for the required decision or action, and pause the goal until the human responds.
    Do not mark the task Blocked merely because the answer is pending; In Progress truthfully names the active
    handoff. After the response, complete that card or return it to Next with updated context, then resume the
    queue.
    If Agent runnable work appears while a Human required card is In Progress awaiting a response, preserve the request and context, return the human card to the top of its Human/priority bucket in Next, move the topmost Agent runnable card to In Progress, and resume the goal. Reissue the human handoff when agent-runnable work is exhausted.
  - **The human review surface has a WIP limit of ONE — the human is a unit in the line, and a unit reviews one item at a time.** Kanban's core rule is that *every* working unit has a capacity limit, not only the agent. The human reviewer is such a unit: they can meaningfully review exactly one thing at a time, so the "ready for human review" surface — the single In-Progress human handoff — holds **at most one** card awaiting the human's attention. This is the mirror of the one-In-Progress rule (rule 2), applied to the human's own capacity. Additional cards that become review-ready **queue behind** the one under review (in Next, in their Human/priority bucket); they do **not** pile onto the human. Presenting a human with five simultaneous "please review" cards is the same violation as the agent running five tasks at once — it destroys the single locus of attention the limit exists to protect. On every sync, enforce it: if more than one card is being surfaced for human review at once, keep the topmost under review and return the rest to Next until exactly one remains.
  - **Notify the human that a review is waiting — through the best channel you have, but assume only the board.** The Trello card is the durable, backend-guaranteed review surface (it is the surface the human uses to reach into the agent's operation), so the handoff is **always** expressed as a properly-formed card first. The skill does **not** assume any richer channel — a different agent running this skill may have only the board. **But if the agent DOES have another way to reach the user** — an info panel, a system notification, a push, a chat ping — it is the **agent's responsibility to use it** to actively tell the user "a new item is waiting for your review." Do not silently leave a review card sitting on the board hoping the human notices; surface it through every notification channel available to you, while keeping the board card as the canonical artifact.
  - **The pull signal — an agreed phrase the human says to advance the review queue.** Because the review surface is WIP-limited to one, it needs an explicit **pull**: when the human finishes with the item under review, there must be a standard, agreed-upon way for them to say *"I'm done — give me the next item to review."* Establish that phrase with the user and record it where a cold agent will find it (the board's conventions, the handoff note). The phrase should also **re-anchor context**: a memory-less or freshly-compacted agent must be able to take the human's short answer (e.g. "reviewed, next" or an approve/decline on the specific card) and, from the card it maps to, reconstruct the full decision context — so the human's terse reply always lands on the right task even when the agent has lost the thread. On the pull signal: complete or return the reviewed card, then promote the next queued review-ready card into the single review slot and notify the human as above.
  - **Every Human required card MUST carry a clickable path to the exact action — a card that names a PR/diff/doc without a LINK is broken.** The human should never have to hunt for what you're asking them to do. A card whose description says "approve PR #28" but gives no URL, or "review the fix" with no link, fails this rule — the human opens it, finds nothing to click, and the queue stalls on friction you created. This applies to any card that needs human intervention (the `Human required` label, or an In-Progress handoff), and the requirement splits by *what kind* of intervention:
    - **The human needs to REVIEW something** (a PR, a diff, a commit, a document, a rendered page) → the description MUST contain the **direct clickable link** to that exact thing (e.g. `https://github.com/<owner>/<repo>/pull/<n>`, a commit URL, a doc URL). Not the repo root — the specific PR/diff/artifact. Trello renders a bare URL as a clickable smart-link, so paste the raw URL. If there are several, link each and label them.
    - **The human needs to make a DECISION** (choose an option, approve/decline, supply a value) → the description MUST state **all the options**, the trade-offs, and a **clear instruction to answer IN THE CHAT** (e.g. "Reply here: approve or decline", "Which of A/B?"). A decision card with no enumerated options, or no "answer here" instruction, is broken the same way a review card with no link is.
    - Both at once (review-then-decide) → link the thing to review AND state the decision + how to answer.
    On every sync, audit each `Human required` card and each In-Progress human handoff for this: does it carry the clickable link (review) or the options-plus-answer-here instruction (decision)? If not, add it before moving on. A "needs-human-review" surface — whether a dedicated column or the `Human required` cards in Next — is only useful if every card on it is one click from the action.
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

### 14.1. Do Not Disturb — bounded bug triage that preserves time-sensitive evidence without derailing protected work
Rule 14 makes a discovered bug a **mandatory** trigger. Rule 14.1 governs *how the switch happens* so that a
bug found mid-task neither gets walked past **nor** silently destroys the protected work the user asked you to
finish. It exists because two failures are equally bad: filing-and-continuing (rule 14's target), and
*auto-derailing* — abandoning a nearly-done, time-sensitive card the moment any incidental bug appears.

**Global scheduling default (applies to every card, not only DND).** A newly *specified* task goes to **Next**
and does **not** interrupt, replace, block, or move the current In Progress card. Interrupt or reprioritize the
active card only when the user explicitly directs that change. Discovering a bug is not the user specifying a
new task; it is handled by the evidence-first protocol below.

**The `Do Not Disturb` label.** Apply the Trello label **`Do Not Disturb`** to a card whose *primary execution
should resume* after bounded bug triage — typically time-sensitive or nearly-complete work where losing the
in-flight context is itself a cost. The label is the durable signal to a memory-less future-you that this card
is protected: interruptions are for evidence capture only, then you come back.

**Evidence-first bug protocol on a Do Not Disturb card.** When a bug surfaces while a DND card is In Progress:
1. **Immediately register an investigation** (a card, and its investigation file per rule 6/14) — the bug is
   never a bare note.
2. **Collect all available NON-DESTRUCTIVE, time-sensitive evidence right now** — the state that will be gone
   if you wait. This is the only work permitted before you return.
3. **After non-destructive evidence collection, move the investigation to Next** and **restore the original
   Do Not Disturb card to In Progress.** The one-in-progress invariant holds throughout: exactly one card is
   In Progress at every step; the DND card is *pushed* (rule 9) only for the bounded evidence window, then
   *popped* back.
4. **Record the interruption/resumption trail on BOTH cards** — the investigation card notes what protected
   work it interrupted and what evidence it captured; the DND card notes the bounded interruption and the
   resume. A memory-less agent must be able to reconstruct the push/pop from the board alone.

**The exception — when the bug truly blocks the protected card.** If the defect genuinely blocks the original
card and *no meaningful progress can continue* on it, do **not** bounce back: keep the investigation In Progress
and drive it to closure (rule 4.6). The DND card moves to **Blocked**, linked to the investigation as its
active blocker. "It would be inconvenient to stop" is not "no meaningful progress can continue" — apply the
maximum-pain honesty here, because "I can resume" is the comfortable reading and "this is a hard block" is the
one that must clear the higher bar.

**What counts as non-destructive evidence** (collectible inside the bounded phase without leaving it): reads,
projections, screenshots, logs, `status`/`info` probes, DOM/state snapshots, error payloads, `step_id`/
`failed_state` capture, version/lineage reads, and any observation that does not mutate the system under test.
**Actions that REQUIRE leaving the bounded evidence phase** (they are remediation, not evidence, and either
resume the DND card first or, under the block exception, run inside the now-primary investigation): any
mutation, retry of the failed action, config/state change, deploy, release, file edit to fix the defect, or a
destructive probe. If you cannot get the evidence you need without mutating, you have left evidence collection
— decide resume-vs-block explicitly before proceeding.

**Routing: CE Debug vs Incident Investigation.**
- **Route simple, bounded bugs to Compound Engineering CE Debug** — a single-surface defect with a clear
  repro and a plausible bounded fix.
- **Route complex, multi-system, production, security, or unclear incidents to Incident Investigation** — the
  full root-cause discipline (calibrated hypotheses, real experiments, three-level blame, remediation phases).
- **Escalate from CE Debug to Incident Investigation** when the bounded debug attempt does **not** establish
  and verify a fix. A CE Debug that dead-ends is itself a signal the bug is not bounded; do not keep looping
  the bounded path — escalate and record why.

**Bug-interruption decision table.**

| Situation on a `Do Not Disturb` card | Action |
|---|---|
| Bug found, evidence is non-destructive and capturable now | Register investigation → capture evidence → investigation to Next → **resume DND card** |
| Bug found, evidence needs a mutation/retry/deploy to obtain | You are leaving the evidence phase → decide resume-vs-block first; do not mutate inside the bounded phase |
| Bug does NOT block the DND card's remaining work | Resume the DND card after evidence; investigation waits in Next |
| Bug BLOCKS the DND card, no meaningful progress possible | Keep investigation In Progress → DND card → Blocked (linked to investigation) → drive investigation to closure |
| Bug is simple, single-surface, bounded repro | Route to **CE Debug** |
| Bug is multi-system / production / security / unclear | Route to **Incident Investigation** |
| CE Debug attempt did not establish + verify a fix | **Escalate** CE Debug → Incident Investigation; record why |
| Non-DND card, incidental bug | Rule 14 governs (mandatory investigation); DND's resume-preference does not apply — there is no protected card to return to |

The one-In-Progress invariant (rule 2 / rule 12) is preserved at every transition, and every push/pop leaves a
recorded trail on both cards so a cold agent can reconstruct exactly what interrupted what and why it resumed
or blocked.

### 15. Users own genuine design choices — do not ask them to rubber-stamp a dominant option
Design authority belongs with the user when there is an **actual choice**: two or more viable options have
material trade-offs in product behavior, scope, risk, irreversibility, cost, or preference, and the answer can
change the outcome. Explain the context and trade-offs, then ask one decision at a time.

A foregone conclusion is **not** a design choice. When evidence shows one option dominates the alternatives on
correctness, safety, scope, and reversibility — while the alternatives are known-broken, predictably drifting,
needlessly permissive, or strictly worse — choose the dominant option, record the evidence and rationale on the
task, and continue autonomously. Do **not** move the task to Backlog or Blocked merely to obtain a user's rubber
stamp.

Interpret standing instructions such as “design choices belong to the user” through this viability gate unless
the user explicitly reserves approval over the specific action regardless of trade-offs. Describing three
options does not manufacture a choice when two are strawmen. If uncertainty remains, ask only about the exact
unresolved trade-off; do not ask the user to approve the parts the evidence already settled.

**Red flags — keep walking instead of asking:**
- “The user said all designs need approval, so even this obvious correction must wait.”
- “I should offer options for completeness,” when only one option is viable.
- Returning a task to Backlog after the investigation already established a dominant safe fix.

| Rationalization | Reality |
|---|---|
| “Literal design authority requires approval for every proposed fix.” | Authority applies to genuine choices; a dominant evidence-settled correction is autonomous execution unless specifically reserved. |
| “Asking is safer.” | Needless approval interrupts transfer work and can block the whole queue; safety comes from evidence, reversibility, and verification. |

These are enforcement invariants: on every heartbeat/sync, bring the board *into* this state before you
resume work — don't just note the drift.

**Set it up at the START of every session.** On most agent harnesses a recurring timer is
**session-only** (dies on restart), so re-create it each session — ideally via a **SessionStart
hook** so it's automatic. Reference heartbeat prompt (adapt the store/task specifics):

> HEARTBEAT (~10 min): route to the task store; read state by model; enforce one-in-progress↔reality
> sync (finish→verify + compound→Done→pull the topmost Agent runnable Next card; blocked→Blocked + pull the topmost Agent runnable card from Next); update the checklist; then
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
