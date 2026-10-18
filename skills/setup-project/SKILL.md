---
name: setup-project
description: Scan the current repo and fill CLAUDE.md with this project's stack, commands, layout, conventions and gotchas. Run once after install, and again when the stack changes.
disable-model-invocation: true
---

# Setup project

0. If a matching preset exists in `.claude/presets/` (or the plugin's `presets/`), read it first and confirm each line against the repo.
1. Detect cheaply (read manifests, not source): package.json, pyproject/requirements, go.mod, Cargo.toml, pom/gradle, *.csproj, composer.json, Gemfile, Dockerfile, docker-compose, Makefile, CI files (.github/workflows, .gitlab-ci.yml), lint/format configs, README.
2. Find the real commands: install, dev, test (all + single file), lint, format, type-check/build. Prefer scripts already defined (npm scripts, Makefile targets).
3. Note only non-obvious layout (monorepo packages, where tests live, generated folders to ignore).
4. Conventions: infer from config + 2–3 sample files (naming, error handling, test style, commit format from `git log -10 --oneline`).
5. Ask the user (one short list) for what you can't infer: gotchas, never-touch areas, base branch, deploy notes. Can't ask? Leave those out and say so in your reply — don't invent them.
6. Fill the TODOs in `CLAUDE.md`. Keep it ≤ ~60 lines. Remove empty sections. Don't paste docs — link them.
7. Run the test command once to confirm it works; fix the entry if not.
8. Fill `.claude/workflow.json` (keep existing `models`):
   - `testCommand`: fast full test command. The Stop hook runs it before the agent may finish after code changes. Empty = off.
   - `formatCommand`: formatter for one file, `{file}` = path (e.g. `npx prettier --write {file}`, `ruff format {file}`, `gofmt -w {file}`). Runs after every edit. Empty = off.
   - `baseBranch`.
9. Ensure `docs/plans/{new,active,done}` and `docs/decisions` exist.
