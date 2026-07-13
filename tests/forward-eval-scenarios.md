# Agent Kanban forward-evaluation scenarios

Run each scenario in fresh context with only `SKILL.md` and the scenario text. A pass requires every listed observable decision; extra actions must not violate another invariant.

## Scenario 1 — executor and priority ordering

Next contains an Agent runnable Normal card, a Human required High card, and an Agent runnable High card. In Progress is empty. Then a new Agent runnable card is added at each priority.

Pass when the agent treats Next as priority buckets in High → Normal → Low order, inserts every new card at the top of its own bucket, keeps Human required work after Agent runnable work, moves the topmost Agent runnable card to In Progress, and does not ask the human while agent-runnable work remains.

## Scenario 2 — blocked dependency repair

Blocked contains a parent whose description only says “waiting on the user.” Next has no corresponding card.

Pass when the agent creates or identifies a linked Human required Next card with a priority label, preserves the parent in Blocked only after the link exists, and places the human card after every Agent runnable card.

## Scenario 3 — investigation closure

Done contains an investigation with a fully checked analysis checklist. Its remediation artifact says the structural fix and live release verification are deferred.

Pass when the agent removes the investigation from Done, creates linked Agent runnable Next work for every incomplete remediation phase, and refuses to treat the checklist or follow-up cards as closure proof.

## Scenario 4 — CE Compound outcomes

An ordinary In Progress implementation has fresh passing verification. Exercise two variants: CE Compound returns a legitimate no-learning result; CE Compound fails to execute.

Pass when the no-learning variant records the no-op and allows Done, while the execution-failure variant opens an investigation and keeps the original card out of Done.

## Scenario 5 — acyclic blocker lifecycle

Blocked contains parent A linked to blocker B, which is also Blocked and linked to Agent runnable blocker C in Next. A proposed new edge would make C depend on A.

Pass when the agent preserves the valid A → B → C chain, rejects C → A with the exact cycle path, allows C to move through In Progress, moves B to Next when C reaches Done, and moves A to Next only after B reaches Done.

## Scenario 6 — repair an inherited cycle

At sync, the store already contains A → B → C → A. The store proves C → A was added last.

Pass when the agent records the cycle, removes C → A, moves C to Next if it has no remaining active blocker, and leaves the valid A → B → C chain. If edge recency is unavailable, pass only when the agent removes all cycle participants from Blocked and creates a High-priority Human required Next card for the unresolved dependency order rather than guessing.

## Scenario 7 — agent work arrives during a human handoff

A Human required card is In Progress awaiting an answer. A new Agent runnable Normal card enters Next.

Pass when the agent preserves the human request and context, returns the Human required card to the top of its Human/priority bucket in Next, promotes the topmost Agent runnable card, and resumes autonomous work.

## Recorded fresh-context run

On 2026-07-12, a fresh agent received a combined version of Scenarios 1–4. It selected Agent runnable work before the higher-priority Human required card, repaired the unlinked Blocked parent, reopened the incompletely remediated investigation, and ran Lightweight CE Compound before Done. The run exposed the former direct-to-Done contradiction in rule 4.5, which this change removes.
