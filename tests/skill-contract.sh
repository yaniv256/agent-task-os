#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd -P)"
skill="$repo_root/SKILL.md"
readme="$repo_root/README.md"
methodology="$repo_root/references/methodology.md"

assert_contains() {
  local file="$1"
  local expected="$2"
  if ! grep -Fq -- "$expected" "$file"; then
    printf 'Expected %s to contain: %s\n' "$file" "$expected" >&2
    return 1
  fi
}

assert_contains "$skill" 'name: agent-kanban'
assert_contains "$skill" '# Agent Kanban'
assert_contains "$readme" '# agent-kanban'
assert_contains "$skill" 'Every Blocked item MUST link to at least one concrete active blocker in Next, In Progress, or Blocked.'
assert_contains "$skill" 'Blocked-to-Blocked dependency chains are valid only when the graph is acyclic.'
assert_contains "$skill" 'Before adding a blocker link, traverse the dependency graph and reject any edge that would create a cycle.'
assert_contains "$skill" 'remove the newest edge in each pre-existing cycle'
assert_contains "$skill" 'If edge recency cannot be proven'
assert_contains "$skill" '`Agent runnable` and `Human required`'
assert_contains "$skill" 'Human required cards MUST sit after every Agent runnable card in Next.'
assert_contains "$skill" 'Never promote a Human required card while any Agent runnable card remains in Next.'
assert_contains "$skill" 'move the topmost Human required card to In Progress, ask the human for the required decision or action, and pause the goal'
assert_contains "$skill" 'New tasks enter Next by default.'
assert_contains "$skill" 'Transitions between Backlog and Next are human-level prioritization decisions.'
assert_contains "$skill" 'must write an explanation note on the moved card'
assert_contains "$skill" '`Priority: High`, `Priority: Normal`, or `Priority: Low`'
assert_contains "$skill" 'New tasks default to Priority: Normal.'
assert_contains "$skill" 'Next is a stack partitioned into priority buckets.'
assert_contains "$skill" 'Insert a new card at the top of its own priority bucket'
assert_contains "$skill" 'move the topmost Agent runnable card to In Progress.'
assert_contains "$skill" 'If Agent runnable work appears while a Human required card is In Progress awaiting a response'
assert_contains "$skill" 'executor class first, then High → Normal → Low within each class'
assert_contains "$skill" 'An investigation may enter Done only after its full remediation plan is implemented and verified.'
assert_contains "$skill" 'Analysis, documentation, honest failure reporting, and follow-up cards do not substitute for remediation.'
assert_contains "$skill" 'run CE Compound after implementation and verification succeed but before moving the card to Done'
assert_contains "$skill" 'Lightweight is the default compounding depth.'
assert_contains "$skill" 'A legitimate “nothing worth documenting” result satisfies the closure gate.'
assert_contains "$skill" 'A CE Compound execution failure is a bug and enters the investigation stack'
assert_contains "$methodology" 'Next is a priority-bucketed stack'
assert_contains "$methodology" 'Blocked-to-Blocked chains are allowed, but the dependency graph must remain acyclic.'
assert_contains "$methodology" 'remove its provably newest edge'
assert_contains "$methodology" 'Run the required CE Compound closure after completion is verified.'
assert_contains "$methodology" 'If agent-runnable work appears while a Human required card is awaiting a response'
assert_contains "$skill" 'Move the card to **Done** only when both implementation completion and CE Compound closure are verified.'
assert_contains "$skill" 'When the final direct blocker enters Done, move the parent from Blocked to Next.'
assert_contains "$readme" '## Migration from `agent-task-os`'
assert_contains "$readme" 'Rename installed skill directories from `agent-task-os` to `agent-kanban`'
assert_contains "$readme" 'Reconcile deployed skill mirrors and chained-prompt `skill_path` values'
assert_contains "$readme" 'verify `.gitmodules` path and URL plus `git submodule status`'
assert_contains "$readme" 'load `skills/agent-kanban/SKILL.md` from the importer'
assert_contains "$readme" 'grep-clean unintended `agent-task-os` references'
assert_contains "$repo_root/tests/forward-eval-scenarios.md" 'Scenario 1 — executor and priority ordering'
assert_contains "$repo_root/tests/forward-eval-scenarios.md" 'Scenario 2 — blocked dependency repair'
assert_contains "$repo_root/tests/forward-eval-scenarios.md" 'Scenario 3 — investigation closure'
assert_contains "$repo_root/tests/forward-eval-scenarios.md" 'Scenario 4 — CE Compound outcomes'
assert_contains "$repo_root/tests/forward-eval-scenarios.md" 'Scenario 5 — acyclic blocker lifecycle'
assert_contains "$repo_root/tests/forward-eval-scenarios.md" 'Scenario 6 — repair an inherited cycle'
assert_contains "$repo_root/tests/forward-eval-scenarios.md" 'Scenario 7 — agent work arrives during a human handoff'

printf 'agent-kanban skill contract: ok\n'
