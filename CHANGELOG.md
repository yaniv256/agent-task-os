# Changelog

## Unreleased — Human-review capacity limit

### Added

- Rule 12 (Next / list discipline): the human review surface now has a **WIP
  limit of one**. The human is a unit in the production line and reviews one item
  at a time, so at most one card is surfaced for human review; additional
  review-ready cards queue behind it in Next. This mirrors the one-In-Progress
  rule, applied to the human's own capacity.
- Notification responsibility: the Trello card is always the canonical, durable
  review surface (the skill assumes only the board), but an agent that has a
  richer channel (info panel, system notification, push, chat ping) is
  responsible for using it to actively tell the user a review is waiting.
- The pull signal: an agreed phrase the human says to advance the WIP-limited
  review queue ("I'm done — next item"), which must also re-anchor context so a
  memory-less or freshly-compacted agent can map the terse reply back to the
  right card's full decision context.

## Unreleased — Do Not Disturb bug triage

### Added

- Rule 14.1: Do Not Disturb bug-triage and debug-escalation policy. A `Do Not
  Disturb` label marks protected, time-sensitive work; a bug found mid-execution
  triggers bounded non-destructive evidence collection, then the protected card
  resumes In Progress — unless the defect truly blocks it, in which case the
  investigation stays In Progress and the card moves to Blocked.
- Global scheduling default: a newly specified task enters Next and never
  interrupts, replaces, blocks, or moves the current In Progress card unless the
  user explicitly directs the change.
- CE Debug vs Incident Investigation routing, with escalation from CE Debug to
  Incident Investigation when a bounded debug does not establish and verify a fix.
- A bug-interruption decision table and forward-eval Scenarios 8 and 9.

### Notes

- Preserves the one-In-Progress invariant across every push/pop and records the
  interruption/resumption trail on both cards.
