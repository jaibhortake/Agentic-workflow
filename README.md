# Agentic-workflow

A set of skills, hooks and installers that make an AI coding agent work in a fixed order: **brainstorm → plan → build → review → verify**. Plans are files, nothing is "done" without fresh test evidence, and small tasks skip the ceremony. Works with Claude Code, Cursor, Codex and Gemini CLI.

## 1. Install

```bash
git clone https://github.com/jaibhortake/Agentic-workflow.git

# macOS / Linux / Git Bash
./Agentic-workflow/install.sh path/to/your-project

# Windows PowerShell
.\Agentic-workflow\install.ps1 -Project path\to\your-project
```

The default tool is Claude Code. For others add `--tool cursor`, `--tool codex`, `--tool gemini`, `--tool all`, or a list such as `--tool claude,gemini` (PowerShell: `-Tool`). Re-run after `git pull` to update; your own settings are kept.

**Claude Code plugin instead** (skills, agents and hooks, updated with `/plugin update`):

```
/plugin marketplace add jaibhortake/Agentic-workflow
/plugin install agentic-workflow@agentic-workflow
```

## 2. First run: create your project's `CLAUDE.md`

Open the project in your agent and run **`/setup-project`** (Cursor, Codex, Gemini: ask the agent to run the `setup-project` skill). It reads your repo, finds the real install/test/lint commands, and fills in the project facts file. That file is `CLAUDE.md` for Claude Code, or a `## Project` section at the bottom of `AGENTS.md` for the other tools. It also fills `.claude/workflow.json` with your test and format commands.

What the installer put in your project:

| Path | What it is |
|---|---|
| `AGENTS.md` | The workflow rules, in a marked block that re-installs replace safely. Read by every tool |
| `CLAUDE.md` | Imports `AGENTS.md`, then holds your project facts (Claude Code) |
| `GEMINI.md` | Imports `AGENTS.md` (Gemini CLI) |
| `.claude/skills/` | The skills, as slash commands (Claude Code). Cursor, Codex and Gemini use `.agents/skills/` |
| `.claude/agents/`, `.claude/hooks/`, `.claude/settings.json` | Sub-agents and safety hooks (Claude Code only) |
| `.claude/workflow.json` | Your settings (see below) |
| `docs/plans/{new,active,done}/` | Plans: drafts, approved and being built, finished |
| `docs/decisions/` | Decision docs written by `/brainstorm` |

## 3. Use it

Start any task with **`/workflow <what you want>`**. It sizes the task and picks the path:

| Size | When | Path |
|---|---|---|
| **S** | clear spec, at most 2 source files, no schema/API/auth change | build → `/verify` |
| **M** | spec gaps, 3+ files, or shared code | `/write-plan` → `/build-phase` → `/review` → `/verify` |
| **L** | new module, schema/API/auth change, unclear design | `/brainstorm` → `/write-plan` → `/build-phase` per phase → `/review` → `/verify` |

When `/verify` passes, run `/security-check`, then `/pr`. A plan you approve moves from `docs/plans/new/` to `active/`, and to `done/` after verify. Bugs start with `/debug`.

## What each skill does

**The lifecycle**

| Skill | What it does |
|---|---|
| `/workflow` | Entry point. Sizes the task (S/M/L), routes it, and holds the rules every other skill follows |
| `/brainstorm` | Explores the problem before any plan: approaches with trade-offs, challenges the obvious one, writes a decision doc. Never writes code |
| `/write-plan` | Writes a phased plan a cheaper model can build without guessing, then runs ten review passes on it |
| `/build-phase` | Builds one phase of an approved plan: reviews the plan, writes tests first, runs scoped tests, self-reviews. Stops and reports if the plan is wrong instead of improvising |
| `/build-model` | For a separate, cheaper build session: builds every phase, reviews, writes the handoff, then stops |
| `/review` | Independent review of the built change against the decision doc and plan. Loops until no findings are left; sends too-large rework back as a brief |
| `/build-handoff` | Writes the fixed-format record of a build: halts, deviations, test runs, unproven criteria, concerns |
| `/verify` | The final gate. Fresh test run, line-by-line check against the plan, and a drift audit from decision doc to plan to code. Nothing is "done" without it |
| `/debug` | Finds the root cause before fixing, then requires a regression test |
| `/security-check` | Pre-PR check for secrets, injection, auth, data exposure and dependencies |
| `/pr` | Writes the PR title and description from the plan and verify evidence |

**Around the lifecycle**

| Skill | What it does |
|---|---|
| `/triage` | Recommends what to work on next from plans, handoffs and issues, without wasting loaded context |
| `/backlog` | GitHub Issues: file bugs and features, link a plan to its issue, close after verify |
| `/decision-summary` | Plain-words recap of what has been decided so far. Changes nothing |
| `/compact-brief` | One-line compact command plus a resume brief, so work survives a context compaction |
| `/handoff` | Resume notes for a fresh session or a teammate |
| `/learn` | Saves lessons from a finished task to `docs/lessons.md` |
| `/terse` | Short output while building and debugging. Plans, reviews and PR text stay in full prose |
| `/models` | Choose the model for each role (plan, build, review, explore) |
| `/workflow-config` | Change settings in `.claude/workflow.json` |
| `/setup-project` | Fills in your project facts file (step 2) |

**Used by the skills above (not run directly)**

| Skill | What it does |
|---|---|
| `existing-mechanisms` | Eight questions about what the codebase already does, so nothing is duplicated or orphaned |
| `review-lenses` | The seven review lenses plus security, and the brief for handing a review to another model |
| `test-scope` | How wide each test run must be, and when an earlier run may be cited |
| `knowledge-graph` | How to use a [graphify](https://github.com/Graphify-Labs/graphify) index, if you have one |
| `test-driven-development`, `systematic-debugging` | Test-first and root-cause discipline, from [obra/superpowers](https://github.com/obra/superpowers) (MIT) |

Each skill's `SKILL.md` is the short, binding version. Its `references/` folder holds the full explanation and examples, loaded only at the step that needs them.

## Hooks (Claude Code)

Rules in markdown are advice; hooks always run.

- `guard.sh`: blocks edits to `.env` and key files, destructive commands, and edits to a frozen decision doc.
- `plan-gate.sh`: blocks source edits until a plan is approved in `docs/plans/active/`. For an S task, write one line to `docs/plans/.s-task` first. Docs, tests and config always pass.
- `amendment-guard.sh`: an active plan's Amendment Log is append-only.
- `format-on-edit.sh`: runs your `formatCommand` on each edited file.
- `verify-on-stop.sh`: runs your `testCommand` before the agent may finish; failing tests send it back.

## Settings

In `.claude/workflow.json`; change them with `/workflow-config`.

| Key | Meaning |
|---|---|
| `testCommand`, `formatCommand`, `baseBranch` | Filled by `/setup-project` |
| `rigor` | `standard` or `strict` (L tasks always run strict) |
| `planGate` | `true` turns on the plan-gate hook. Existing projects add this line themselves |
| `testing` | `tdd` or `bdd` |
| `terse` | `off`, `lite`, `full`, `ultra` |
| `useGithubIssues` | `true` enables `/backlog` |
| `models` | Per-role models, or use `/models` |

## More

[docs/](docs/): [workflow diagram](docs/workflow.md) · [installation](docs/installation.md) · [configuration](docs/configuration.md) · [multi-model use](docs/multi-model.md) · [driving Cursor, Codex, Gemini and Claude CLI headless](docs/extras/README.md) · [security](docs/security.md) · [philosophy](docs/philosophy.md). Also [examples/](examples/), [evals/](evals/), [CONTRIBUTING.md](CONTRIBUTING.md) for changing this repo.

MIT License. Third-party licenses: [THIRD-PARTY-LICENSES.md](THIRD-PARTY-LICENSES.md).
