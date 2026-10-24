# Installation reference

The [README](../README.md) has the short version. This page covers per-tool targets, both installers, the Claude Code plugin, the full skill inventory and what's vendored.
## Install into a project

```bash
git clone https://github.com/jaibhortake/Agentic-workflow.git
./Agentic-workflow/install.sh path/to/project --tool claude          # macOS / Linux / Git Bash
.\Agentic-workflow\install.ps1 -Project path\to\project -Tool claude  # Windows PowerShell
```

`--tool` / `-Tool` takes `claude` (the default), `cursor`, `codex`, `gemini`, `all`, or a comma-separated list (`cursor,gemini`). Re-run after `git pull` to update. Re-runs are idempotent, and your `CLAUDE.md`, `GEMINI.md`, `.claude/workflow.json`, `.claude/settings.json` and anything outside the marked block in `AGENTS.md` are kept.

| Tool | Skills | Rules | Also installed |
|---|---|---|---|
| Claude Code | `.claude/skills/` | `CLAUDE.md`, which imports `AGENTS.md` | agents (`builder`, `reviewer`, `explorer`, `outside-reviewer`), hooks, `.claude/settings.json` |
| Cursor | `.agents/skills/` | `AGENTS.md` (read natively) | |
| Codex | `.agents/skills/` | `AGENTS.md` (read natively) | |
| Gemini CLI | `.agents/skills/` (Gemini's alias for `.gemini/skills/`) | `GEMINI.md`, which imports `AGENTS.md` | |
| every tool | | `AGENTS.md` (a marked block) | `.claude/workflow.json` (config, read by the skills whatever the tool), `.claude/presets/`, `docs/plans/{new,active,done}/`, `docs/decisions/`, `.gitignore` entries |

Cursor, Codex and Gemini share one `.agents/skills/` copy, so `--tool cursor,codex,gemini` writes it once. Hooks run only in Claude Code; the other tools rely on the written rules, so `plan-gate` and `amendment-guard` don't apply there.

Claude Code models per role (Claude only): `--build sonnet --review opus --explore haiku` (`-Build`, `-Review`, `-Explore`), or later `/models`.

### Claude Code plugin
```
/plugin marketplace add jaibhortake/Agentic-workflow
/plugin install agentic-workflow@agentic-workflow
```
The plugin ships skills (vendored superpowers included), agents and hooks, and updates with `/plugin update`. It doesn't create `docs/plans/` or `.claude/workflow.json`; run `/setup-project` once, or the installer with `--tool claude`. Hooks that read config (`plan-gate`, `verify-on-stop`, `format-on-edit`) do nothing until `.claude/workflow.json` exists.

### Existing projects
A re-install keeps your `.claude/workflow.json`, so new keys don't appear in it. To turn on the plan gate, add `"planGate": true`. If `.claude/settings.json` already existed, the installer leaves it alone and says so; merge the `PreToolUse` entries for `plan-gate.sh` and `amendment-guard.sh` from `templates/settings.json`.

## The skills

Every skill, with what it does, is listed in the [README](../README.md#what-each-skill-does). Each skill folder travels whole, so its `references/` and supporting files always come along.

### Vendored, and retired
- `test-driven-development` and `systematic-debugging` come from obra/superpowers through `pull-superpowers.sh` / `pull-superpowers.ps1`. They're committed under `skills/` (each with its `LICENSE` and a `SOURCE.md` naming the commit), so the plugin ships them. Don't edit them by hand; re-run the script.
- `verification-before-completion` (superpowers) is never installed: `/verify` replaces it with the same Iron Law plus the requirements tick-off and the drift audit. Two skills claiming one gate would leave the agent picking whichever it read first. If you have it installed from elsewhere, remove it yourself.

## Manual install (no installer)
Copy `skills/*` into your tool's skills directory from the table above, copy `AGENTS.md` into your project, and create `docs/plans/{new,active,done}/`, `docs/decisions/` and `.claude/workflow.json` (from `templates/`). For Claude Code, also copy `agents/` to `.claude/agents/`, `hooks/*.sh` to `.claude/hooks/`, and `templates/settings.json` to `.claude/settings.json`.

## Machine setup for headless runs
To drive Cursor, Codex, Gemini CLI or Claude CLI headless as a build model or reviewer, see [extras/agent-cli-setup.md](extras/agent-cli-setup.md).
