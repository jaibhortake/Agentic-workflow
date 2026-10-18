# Agentic Workflow (tool-agnostic rules)

Read by Claude Code, Cursor, Copilot, Codex, Gemini CLI. Keep short — every line costs tokens every session.

## Core rules
1. **Size the task first**, then follow its path:
   - **S** (typo, config, ≤1 file, obvious): build → verify.
   - **M** (one feature/bug, few files): plan → build → review → verify.
   - **L** (new module, schema/API change, cross-cutting, risky): brainstorm → plan → build (per phase) → review → verify.
   - Unsure? Pick the bigger size.
2. **Plans are files, not chat.** `docs/plans/new/` (draft) → `docs/plans/active/` (approved) → `docs/plans/done/`.
3. **Never improvise past the plan.** If the plan has a gap, stop and report it; update the plan's Amendment Log after approval.
4. **Evidence before "done".** No completion claim without a test/build/lint run *in this session* and its result shown.
5. **Reuse first.** Before writing new code, look for an existing function/module/pattern that does it.
6. **Tests:** TDD (failing test first) for business logic, data, APIs, bug fixes. Tests-after allowed for UI layout and glue. No mocks on the main value path — at least one test crosses the real seam (DB, HTTP, file).
7. **Removals are audited:** when deleting code, name what replaces it and confirm nothing still uses it.
8. **Security** before any PR: run the `security-check` skill.

## Token discipline
- Read only what you need: search first (grep/glob), then read file ranges, not whole trees.
- Delegate wide searches to a subagent; keep only its conclusion.
- Terse mode during build (see `terse` skill). Plans, reviews and PR text stay in clear prose.
- Long session or switching task → write a handoff (`handoff` skill), then start fresh.

## Workflow commands (skills)
Skill files: `.claude/skills/<name>/SKILL.md`. Tools without slash-command support: read the matching file when the step is reached.
`/workflow` (start here) · `/brainstorm` · `/write-plan` · `/build-phase` · `/review` · `/verify` · `/debug` · `/security-check` · `/handoff` · `/terse` · `/setup-project`

Project-specific facts (stack, commands, conventions) live in `CLAUDE.md` / the "Project" section below.
