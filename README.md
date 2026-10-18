# Agentic-workflow

A lean, stack-agnostic workflow for building production-grade software with AI coding agents (Claude Code first; Cursor, Copilot, Codex and Gemini CLI via `AGENTS.md`).

It combines:
- **[structured-agentic-workflow](https://github.com/nikhilw/structured-agentic-workflow)**: brainstorm → plan → build → review → verify, plans saved as files, evidence-based "done", drift audit.
- **[superpowers](https://github.com/obra/superpowers)**-style TDD and systematic debugging.
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
  .claude/workflow.json # testCommand, formatCommand, baseBranch, models
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

**Hooks** enforce three things automatically (rules in markdown are advice; hooks always run):
- `guard.sh` blocks edits to `.env` and key files and blocks `git push --force`, `reset --hard`, `rm -rf /` and similar.
- `format-on-edit.sh` runs `formatCommand` on each edited file.
- `verify-on-stop.sh` runs `testCommand` when the agent tries to finish after code changes; failing tests send it back to fix them.

| Command | What it does |
|---|---|
| `/workflow` | Entry point: sizes the task and routes it |
| `/brainstorm` | Options, risks, decision doc. No code |
| `/write-plan` | Phased plan a cheaper model can build without guessing |
| `/build-phase <plan> <n>` | Test-first build of one phase (Sonnet `builder`) |
| `/review` | Fresh-context review until zero findings (Opus `reviewer`) |
| `/verify` | Fresh test/lint/build run, AC checklist, drift audit |
| `/debug` | Reproduce → root cause → fix with a regression test |
| `/security-check` | Secrets, injection, authz, data and dependency checks |
| `/pr` | PR title and description from the plan and verify evidence |
| `/triage` | Suggests the next task from handoff, plans and issues |
| `/models` | Show or change the model per role |
| `/handoff` | Compact resume brief for a new session or teammate |
| `/terse on/off` | Toggle terse output (on by default during build) |
| `/setup-project` | Generate this project's `CLAUDE.md` |

## Saving tokens

- The plan file is the handoff, so a cheaper build model can follow it (if you choose one).
- The `explorer` subagent runs wide searches and returns only conclusions.
- Build each approved plan in a fresh session (`/clear`); the plan carries the context.
- Corrected twice on the same thing? Start fresh with a sharper prompt.
- Terse mode during build and debug. Plans, reviews and PR text stay readable.
- `CLAUDE.md` is kept to about 60 lines; skills load only when used.
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
