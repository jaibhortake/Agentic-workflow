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

Then open your project in Claude Code and run **`/setup-project`**. It scans the repo and fills `CLAUDE.md` with your stack, commands and conventions.

The installer adds:

```
your-project/
  AGENTS.md            # workflow rules, read by all agent tools (in a marked block, safe to re-run)
  CLAUDE.md            # project facts, imports AGENTS.md (filled by /setup-project)
  .claude/skills/      # workflow skills = slash commands
  .claude/agents/      # builder (Sonnet), reviewer (Opus), explorer (Haiku)
  docs/plans/{new,active,done}/
  docs/decisions/
```

To update, `git pull` this repo and re-run the installer. Your `CLAUDE.md` and any project notes you added outside the marked block in `AGENTS.md` are kept.

## How to use

Start any task with `/workflow <what you want>`. It sizes the task and picks a path:

| Size | Example | Path |
|---|---|---|
| **S** | typo, config, 1-file fix | build → `/verify` |
| **M** | one feature or bug | `/write-plan` → `/build-phase` → `/review` → `/verify` |
| **L** | new module, schema/API/auth change | `/brainstorm` → `/write-plan` → `/build-phase` ×N → `/review` → `/verify` |

Then run `/security-check` and open a PR.

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
| `/handoff` | Compact resume brief for a new session or teammate |
| `/terse on/off` | Toggle terse output (on by default during build) |
| `/setup-project` | Generate this project's `CLAUDE.md` |

## Saving tokens

- The plan file is the handoff, so Opus plans and reviews while Sonnet builds.
- The `explorer` subagent (Haiku) runs wide searches and returns only conclusions.
- Terse mode during build and debug. Plans, reviews and PR text stay readable.
- `CLAUDE.md` is kept to about 60 lines; skills load only when used.
- Tests are scoped during a phase, with the full suite only at `/verify`.
- Use `/handoff` and then a fresh session instead of dragging a long context along.

## Team tips

- Commit `AGENTS.md`, `CLAUDE.md`, `.claude/` and `docs/` so everyone shares them.
- Personal preferences go in `CLAUDE.local.md`, which the installer gitignores.
- Review plans in `docs/plans/new/` like code; moving one to `active/` means it's approved.

MIT License.
