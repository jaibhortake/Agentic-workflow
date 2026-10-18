---
name: backlog
description: Manage features and bugs as GitHub Issues with the gh CLI - file a bug or feature, link a plan to its issue, close issues when work is verified. Usage /backlog bug|feature|link|close|list ...
disable-model-invocation: true
---

# Backlog (GitHub Issues)

Needs `gh` authenticated (`gh auth status`). Not available → say so and stop.

| Command | Does |
|---|---|
| `/backlog bug <summary>` | Create issue, label `bug`. Body: steps to reproduce, expected, actual, evidence (error/log lines). Ask for missing reproduction steps first. |
| `/backlog feature <summary>` | Create issue, label `enhancement`. Body: intent, success criteria, out of scope, size guess S/M/L. |
| `/backlog link <issue#> <plan>` | Add `Issue: #<n>` to the plan header; comment on the issue with the plan path. |
| `/backlog close <issue#>` | Only after `/verify` passed this session: comment with the verify report + PR link, then close. |
| `/backlog list` | `gh issue list --limit 30` grouped by label; feed into `/triage`. |

Rules:
- Show the issue title and body to the user before creating or closing anything.
- One issue per bug/feature; search first (`gh issue list --search "<words>"`) to avoid duplicates.
- Keep bodies short; link plans and decision docs instead of pasting them.
- Use the labels that exist (`gh label list`); don't invent new ones without asking.
