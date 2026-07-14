---
title: Literal Markdown transport prevents shell interpolation in CLI bodies
date: 2026-07-14
category: docs/solutions/documentation-gaps
module: GitHub CLI workflow
problem_type: documentation_gap
component: documentation
severity: high
applies_when:
  - "Creating or editing GitHub records whose bodies contain Markdown through a shell CLI"
  - "Automating agent-kanban updates with multi-line or untrusted text"
tags:
  - markdown-transport
  - shell-safety
  - body-file
  - github-cli
---

# Literal Markdown transport prevents shell interpolation in CLI bodies

## Context

An incident exposed a transport boundary in the agent-kanban workflow: Markdown sent through a
shell command can be interpreted before the GitHub CLI receives it. Backticks, command-substitution
expressions, braces, and paths are valid Markdown data but also have shell meaning. The original
workflow did not make that distinction explicit, so a PR or comment body could be silently
corrupted while the command still appeared to succeed.

The remediation was merged in [agent-kanban PR #6](https://github.com/yaniv256/agent-kanban/pull/6).
The current skill contract describes Markdown as data and requires a literal file transport
(`SKILL.md:172-182`), with a regression test in
`tests/markdown-cli-safety.test.mjs:9-13`.

## Guidance

Treat every multi-line Markdown body as an artifact, not as a shell string:

1. Write the exact body to a file using `apply_patch` or a quoted heredoc delimiter.
2. Pass that file to the CLI's literal input option, such as `--body-file`.
3. Read the remote body back and compare it with the source file before claiming success.
4. If interpolation already occurred, preserve the corrupted result as evidence, rewrite from the
   literal source, and record the incident as a bug.

The durable contract is explicit: `SKILL.md:173-176` requires `--body-file` (or an equivalent
file-input option), and `SKILL.md:178-182` forbids embedding untrusted or multi-line Markdown in
double-quoted `--body`, `$(cat ...)`, unquoted heredocs, or `echo`.

## Why This Matters

Shell substitution is an execution-time transformation, not a formatting concern. A successful
CLI exit therefore cannot certify that the stored Markdown is intact. Literal file transport keeps
the bytes under the agent's control, while the remote read-back establishes the postcondition that
the GitHub record contains the intended body. The regression test checks the contract's key safety
phrases (`tests/markdown-cli-safety.test.mjs:9-13`), preventing the documentation guardrail from
silently disappearing in a later edit.

## When to Apply

- PR, issue, review, or comment bodies contain Markdown syntax, code fences, backticks, `$()`
  expressions, braces, or filesystem paths.
- Text comes from a user, an external record, or another tool and may contain shell metacharacters.
- A command reports success but the remote record has not yet been read back for comparison.

## Examples

Safe pattern:

```bash
cat > /tmp/body.md <<'EOF'
## Reproduction

The literal text includes `$(not-a-command)` and `{% raw %}`.
EOF
gh pr create --title "Document transport safety" --body-file /tmp/body.md
gh pr view <number> --json body --jq .body
```

Unsafe patterns include `gh pr create --body "$(cat body.md)"`, an unquoted heredoc, or an
`echo` pipeline. Those forms allow the shell to evaluate or rewrite the Markdown before the CLI
receives it.

## Related

- [agent-kanban PR #6](https://github.com/yaniv256/agent-kanban/pull/6) — merged transport contract
  and regression test.
- `SKILL.md:154-164` — the adjacent postcondition rule for verifying store mutations by model read.
