---
name: pr
description: Write the pull request title and description from the plan and /verify output, then open it if the user agrees. Use after /verify and /security-check pass.
disable-model-invocation: true
---

# PR

1. Confirm `/verify` and `/security-check` passed this session. If not, run them first.
2. Gather: plan (`docs/plans/done/<slug>.md` or active), `git log <base>..HEAD --oneline`, `git diff <base> --stat`. Base branch from `.claude/workflow.json` (default `main`).
3. Write:

```
<type>(<scope>): <summary, ≤70 chars>

## Why
<intent, 1–3 lines; link issue/decision doc>

## What changed
- <bullet per meaningful change, not per file>

## How it was verified
- Tests: <command> → <x/y passing>
- ACs: AC1 ✓ (test) …
- Manual: <what was run/checked, if any>

## Risk & rollback
<risk level, migrations/flags, how to roll back>

## Reviewer notes
<where to look first; anything deliberately left out>
```

4. Show it to the user. Push and open the PR (`gh pr create` or the host's CLI) only after they agree.
