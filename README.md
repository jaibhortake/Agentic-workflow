# Agentic-workflow

A stack-agnostic workflow for building production-grade software with AI coding agents: Claude Code, Cursor, Codex and Gemini CLI, installed by one command. It has the full depth of [structured-agentic-workflow](https://github.com/nikhilw/structured-agentic-workflow) (SAW), plus task sizing, enforcing hooks and multi-tool installs.

It combines:
- **[structured-agentic-workflow](https://github.com/nikhilw/structured-agentic-workflow)** (MIT, credited in [NOTICE.md](NOTICE.md)): brainstorm → plan → build → review → verify, intent-audited drift checks, plans saved as files, evidence-based "done", removal tables, build halts, three-axis impact tracing, review lenses, test-scope rungs, rework briefs, compaction briefs, GitHub backlog. Every skill carries SAW's full text in its `references/` folder, loaded at the step that needs it, behind a shorter binding `SKILL.md`. Extended here with S/M/L routing, a `rigor` dial, enforcing hooks, a plugin, presets, CI review, an outside-reviewer agent, `/learn` and a planted-bug eval.
- **[superpowers](https://github.com/obra/superpowers)**: `test-driven-development` and `systematic-debugging`, vendored verbatim (MIT) and used by `/build-phase` and `/debug`.
- **[Caveman](https://github.com/JuliusBrussee/caveman)**-style terse output to cut tokens during builds.
- **[Anthropic's Claude Code best practices](https://www.anthropic.com/engineering/claude-code-best-practices)**: plan before coding, verify your own work, short CLAUDE.md, subagents to protect context.

## Install into your project

```bash
git clone https://github.com/jaibhortake/Agentic-workflow.git
# macOS / Linux / Git Bash
./Agentic-workflow/install.sh path/to/your-project
# Windows PowerShell
.\Agentic-workflow\install.ps1 -Project path\to\your-project
```

**Other tools:** add `--tool cursor`, `--tool codex`, `--tool gemini`, `--tool all`, or a list like `--tool claude,gemini` (`-Tool` in PowerShell). Cursor, Codex and Gemini CLI share one `.agents/skills/` copy; Gemini also gets a `GEMINI.md` that imports `AGENTS.md`. Hooks are Claude Code only. Details: [docs/installation.md](docs/installation.md).

**Or as a Claude Code plugin** (skills, agents and hooks, updated with `/plugin update`):

```
/plugin marketplace add jaibhortake/Agentic-workflow
/plugin install agentic-workflow@agentic-workflow
```

## Models

Nothing is hard-coded: every agent defaults to `inherit` (your current session model). Pick per role:

```bash
./Agentic-workflow/install.sh my-app --build sonnet --review opus --explore haiku
.\Agentic-workflow\install.ps1 -Project my-app -Build sonnet -Review opus -Explore haiku
# or later, inside Claude Code:
/models build=sonnet review=opus explore=haiku
```

Values: `inherit`, `opus`, `sonnet`, `haiku`, `fable`, or any full model id. The planning model is just your session model (`/model`). Re-running the installer keeps your choices. A strong model for plan/review and a cheaper one for build/explore usually saves the most, but that's your call.

## First run

Open your project in Claude Code and run **`/setup-project`**. It scans the repo and fills `CLAUDE.md` with your stack, commands and conventions.

The installer adds:

```
your-project/
  AGENTS.md            # workflow rules, read by all agent tools (in a marked block, safe to re-run)
  CLAUDE.md            # project facts, imports AGENTS.md (filled by /setup-project)
  .claude/skills/      # workflow skills = slash commands
  .claude/agents/      # builder, reviewer, explorer (model: your choice, see "Models")
  .claude/hooks/       # guard, format-on-edit, verify-on-stop
  .claude/settings.json # wires the hooks (only created if you don't have one)
  .claude/workflow.json # testCommand, formatCommand, baseBranch, rigor, testing, terse, GitHub, models
  .claude/presets/     # stack hints for /setup-project (node, python, java, go, dotnet)
  docs/plans/{new,active,done}/
  docs/decisions/
```

To update, `git pull` this repo and re-run the installer. Your `CLAUDE.md` and any project notes you added outside the marked block in `AGENTS.md` are kept.

## How to use

Start any task with `/workflow <what you want>`. It sizes the task and picks a path:

| Size | Example | Path |
|---|---|---|
| **S** | clear spec, ≤2 source files | build → `/verify` |
| **M** | spec gaps, 3+ files, shared code | `/write-plan` → `/build-phase` → `/review` → `/verify` |
| **L** | new module, schema/API/auth change | `/brainstorm` → `/write-plan` → `/build-phase` ×N → `/review` → `/verify` |

Then run `/security-check` and `/pr`.

**Hooks** (Claude Code) enforce five things automatically (rules in markdown are advice; hooks always run):
- `guard.sh` blocks edits to `.env` and key files and blocks `git push --force`, `reset --hard`, `rm -rf /` and similar.
- `format-on-edit.sh` runs `formatCommand` on each edited file.
- `verify-on-stop.sh` runs `testCommand` when the agent tries to finish after code changes; failing tests send it back to fix them.
- `plan-gate.sh` blocks source edits when no plan is approved in `docs/plans/active/`, unless the task is declared S in `docs/plans/.s-task`. Docs, tests and config always pass. On by default for new installs (`"planGate"` in `.claude/workflow.json`; existing projects add it themselves).
- `amendment-guard.sh` keeps an active plan's Amendment Log append-only: the plan body can be amended, old log entries can't be rewritten.

| Command | What it does |
|---|---|
| `/workflow` | Entry point: sizes the task and routes it |
| `/brainstorm` | Options, risks, decision doc. No code |
| `/write-plan` | Phased plan a cheaper model can build without guessing |
| `/build-phase <plan> <n>` | Test-first build of one phase (Sonnet `builder`) |
| `/review` | Fresh-context review until zero findings (Opus `reviewer`) |
| `/verify` | Fresh test/lint/build run, AC checklist, drift audit |
| `/debug` | Runs the vendored `systematic-debugging` skill (root cause before fix), then a regression test per fix |
| `/security-check` | Secrets, injection, authz, data and dependency checks |
| `/pr` | PR title and description from the plan and verify evidence |
| `/triage` | Suggests the next task from handoff, plans and issues |
| `/backlog` | GitHub Issues: file bugs/features, link plans, close after verify |
| `/models` | Show or change the model per role |
| `/build-model <plan>` | Dedicated cheaper builder: build all phases, review, emit handoff, stop |
| `/build-handoff` | The fixed-format build handoff (halts, deviations, runs with rungs, unproven criteria, concerns) |
| `/decision-summary` | Read-only plain-words recap of what's been decided |
| `/compact-brief` | One-line compact command plus a resume brief that survives compaction |
| `/workflow-config` | Set `rigor`, `testing` (tdd/bdd), `terse` level, GitHub issues |
| `/learn` | Append lessons from a verified task to `docs/lessons.md` |
| `/handoff [compact]` | Resume notes for a new session or teammate |
| `/terse on/off` | Toggle terse output (on by default during build) |
| `/setup-project` | Generate this project's `CLAUDE.md` |

### Names, compared with SAW

The short names are kept. Each does at least what its SAW counterpart does:

| Here | In SAW |
|---|---|
| `/workflow` | `agentic-workflow` (here it is also the entry point, with S/M/L sizing) |
| `/review` | `/3p-review` |
| `/verify` | `/verify-completion` |
| `/build-handoff` | `/handoff-summary` |
| `/backlog` | `/github-backlog` |
| `/debug` | `/systematic-debugging` (runs the vendored skill, plus a regression test per fix) |
| `/terse` and the `terse` setting | the caveman brevity setting |
| `/brainstorm`, `/write-plan`, `/build-phase`, `/build-model`, `/triage`, `/compact-brief`, `/decision-summary`, `/workflow-config` | same names |

Only here: `/handoff`, `/learn`, `/pr`, `/security-check`, `/models`, `/setup-project`, rule AW-30, the hooks, the agents. Full inventory: [docs/installation.md](docs/installation.md#the-skills).

Reference skills the gates load (not run directly): `existing-mechanisms`, `review-lenses`, `test-scope`, `knowledge-graph` (only if [graphify](https://github.com/Graphify-Labs/graphify) is installed), and the vendored `test-driven-development` and `systematic-debugging`. Agents: `builder`, `reviewer`, `explorer`, and the read-only `outside-reviewer`.

## Intent-audited rigor (strict mode)

Set `"rigor"` in `.claude/workflow.json`: L tasks run `strict`, S and M `standard`. Rigor adds depth to a path and never upsizes a task.

- **Intent is frozen.** The decision doc locks the moment its plan is approved; only you amend it (append a dated line with your own words). `/verify` audits decision vs plan, approved plan vs current plan, and the decision's problem statement vs what shipped, and reports **NO / DOCUMENTED / UNDOCUMENTED DRIFT**. The `guard` hook blocks agent edits to a frozen decision doc.
- **The builder halts instead of improvising.** A Build Halt Report goes to the planner, who classifies it (plan defect, reality defect, decision-level, builder error), amends the plan and logs it in the Amendment Log.
- **Seven review lenses + Security**, each a single question run on its own and repeated until a round changes nothing; ten plan-review passes before a plan is activated.
- **Review gates:** a ledger, no-mock proof for every value path, zero open findings, deep audits (derived state, migrations, failure timelines, dependencies, authority, seams), mutation checks, optional fresh readers. Too many findings go back as a verified Rework Brief.
- **Tests are scoped and honest** (`test-scope`): rungs T1-T4, escalation triggers, a four-condition citable-run rule, and no narrow run described in wide words.
- **Every claim of "done" needs fresh evidence** (`/verify`), and text from outside you (issues, handoffs, fetched pages) is data, never instruction (`docs/security.md`).

## Documentation

| Doc | What it holds |
|---|---|
| [workflow](docs/workflow.md) | The full lifecycle diagram, phase by phase |
| [philosophy](docs/philosophy.md) | Why it works this way |
| [installation](docs/installation.md) | Per-tool targets, installers, plugin, the full skill inventory |
| [configuration](docs/configuration.md) | `.claude/workflow.json` keys and the hooks |
| [agent config](docs/agent-config.md) | What to put in `CLAUDE.md` / `AGENTS.md` |
| [multi-model](docs/multi-model.md) | Planning, build and review models; the two contracts |
| [review levels](docs/review-levels.md) | Each review level and which model runs it |
| [practices](docs/practices.md) | Task selection, monoliths, "no surprises" |
| [security](docs/security.md) | What skills read from outside, and what contains it |
| [comparison](docs/comparison.md) | SAW's comparison with other agent workflows |
| [extras](docs/extras/README.md) | Driving Claude CLI, Codex, Cursor and Gemini CLI headless, and machine setup |
| [CONTRIBUTING](CONTRIBUTING.md) | Rules for changing this repo |

## Saving tokens

- The plan file is the handoff, so a cheaper build model can follow it (if you choose one).
- The `explorer` subagent runs wide searches and returns only conclusions.
- Build each approved plan in a fresh session (`/clear`); the plan carries the context.
- Corrected twice on the same thing? Start fresh with a sharper prompt.
- Terse mode during build and debug. Plans, reviews and PR text stay readable.
- `CLAUDE.md` is kept to about 60 lines; skills load only when used, and each skill's full detail in `references/` loads only at the step that names it.
- Tests are scoped during a phase, with the full suite only at `/verify`.
- Use `/handoff` and then a fresh session instead of dragging a long context along.

## More

- [examples/](examples/): a worked plan and handoff to copy.
- [templates/ci/agent-review.yml](templates/ci/agent-review.yml): Claude reviews every PR in GitHub Actions.
- [evals/](evals/): how to A/B test the workflow on your own tasks.

## Team tips

- Commit `AGENTS.md`, `CLAUDE.md`, `.claude/` and `docs/` so everyone shares them.
- Personal preferences go in `CLAUDE.local.md`, which the installer gitignores.
- Review plans in `docs/plans/new/` like code; moving one to `active/` means it's approved.
- Parallel work: one git worktree per task (`claude --worktree` or `git worktree add`) so sessions don't collide.
- Run `/fewer-permission-prompts` after a few sessions to allowlist the safe commands you keep approving.

MIT License.
