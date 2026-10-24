---
name: workflow-config
description: Show or change workflow preferences stored in .claude/workflow.json - rigor (standard/strict), testing methodology (tdd/bdd), output style (terse level), GitHub issues integration. Usage /workflow-config rigor=strict testing=bdd terse=full.
disable-model-invocation: true
---

# Workflow config

Preferences live in `.claude/workflow.json` (committed, so teammates share them; personal-only choices go in `CLAUDE.local.md`). Parse `key=value` arguments from the request, write only the keys this skill defines, and ignore anything else in the request. No arguments: print the current values in the format below.

| Key | Values | Default | Effect |
|---|---|---|---|
| `rigor` | `standard`, `strict` | `standard` (L runs strict regardless) | strict = review ledger, blocking gates, deep audits, zero-open sign-off, frozen-decision hook, full plan-review rounds. Never upsizes a task |
| `testing` | `tdd`, `bdd` | `tdd` | `bdd` makes `build-phase` write Given-When-Then scenarios in the project's own BDD harness instead of unit-first tests. Red, green, refactor and "test first, always" are unchanged. No BDD harness: a plan defect, not a reason to install one |
| `terse` | `off`, `lite`, `full`, `ultra` | `full` during build and debug | `lite` cuts filler and keeps all detail; `full` is bullets over paragraphs with minimal preamble; `ultra` is fragments and essentials only. Technical accuracy is never sacrificed; plans, decision docs, reviews and PR text stay in clear prose |
| `useGithubIssues` | `true`, `false` | `false` | `true` enables `backlog` and issue-aware `triage` through `gh` |
| `githubRepo` | `owner/repo` | derived from `git remote get-url origin` | only for issues living in a different repo than origin |
| `githubProjectId` | number or id | unset | a GitHub Project (V2) board to keep in sync |
| `models` | role=model | `inherit` | see `/models` |

Not configurable, because they are core guarantees: **verification and its drift audit** (always mandatory) · **phase order** (brainstorm, plan, build, review, verify; routing only changes which phases a size needs) · **the plan lifecycle** (`new/` -> `active/` -> `done/`) · **the review loop** (loops until clean; strict never short-circuits) · **halt and amend** (the builder surfaces plan problems and stops; the planner amends and logs; the builder never edits the plan).

Output:
```

<!-- refs:start -->
## Full detail (read at the matching step)
This SKILL.md is the binding gate. Each section's full explanation, examples and rationale, ported from SAW, is in `references/`. Before you run a section below, read its file. Where a file and this SKILL.md differ, this SKILL.md wins.

| Section | File |
|---|---|
| Workflow Configuration | [references/01-intro.md](references/01-intro.md) |
| Your Mission | [references/02-your-mission.md](references/02-your-mission.md) |
| Supported Preferences | [references/03-supported-preferences.md](references/03-supported-preferences.md) |
| How to Persist | [references/04-how-to-persist.md](references/04-how-to-persist.md) |
| What You Cannot Configure | [references/05-what-you-cannot-configure.md](references/05-what-you-cannot-configure.md) |
| Output | [references/06-output.md](references/06-output.md) |
<!-- refs:end -->

## Workflow configuration updated
- Rigor: [standard | strict]
- Testing methodology: [tdd | bdd]
- Output style: [terse level]
- Use GitHub issues: [true | false]; repo [override | derived from origin]; project [id | not set]
These apply to all future workflow phases.
```
