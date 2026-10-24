# Decision: full-depth parity with structured-agentic-workflow, plus three extras

## Problem
This repo adapts nikhilw/structured-agentic-workflow ("SAW"). It already has every rule (AW-1..29, plus our AW-30) and the same section structure, but the skills were compressed to about half of SAW's depth (~31k words vs ~62k). Dropped: worked examples, rationale, the detail of each review pass, rationalization tables, and most of the docs. SAW is the base; this repo should match it fully and then improve on it.

## Decision (owner's words, 2026-10-24)
- "implement the nikhil one fully in my personal workflow with some genuine improvements"
- Depth: "full depth", stored as **full text, split**. SKILL.md holds the binding gate steps; SAW's long rationale and examples go into `skills/<name>/references/*.md`, loaded at the step that names them. No SAW content is dropped.
- Names: "keep my short ones but map them to the upstream ones they should have the same functionality", with the map in the README.
- Superpowers: "keep vendor obra one". Vendor `test-driven-development` and `systematic-debugging` the way SAW does.
- Per-tool guides: "keep codex, cursor, gemini and claude as primary".
- Extras chosen: works in every tool, stronger safety locks, prove it works better.
- Delivery: "commit directly to main".

## What the user sees
- Every `/command` they use today still works, with the same name.
- Each command does at least what its SAW counterpart does, and the README says which SAW command it maps to.
- `/debug` and test-first building run on obra/superpowers' skills.
- One installer for Claude, Cursor, Codex and Gemini, on Windows and on bash.
- Hooks block code edits on M/L work with no approved plan, and block rewrites of a plan's Amendment Log.
- `evals/results.md` records the compact version against the full version on planted bugs.

## Consequences
- Each skill costs more tokens when it loads. The split keeps the always-read part close to today's size.
- What we keep that SAW does not have: S/M/L sizing, the `rigor` setting, hooks, the plugin, presets, CI review, `/learn`, `/terse`, `/pr`, `/security-check`, `outside-reviewer`, and AW-30. None of it is removed.

## Ruled out
- Renaming to SAW's names (owner chose short names).
- Writing our own TDD/debug skills instead of vendoring (owner chose obra).
- A shipped skill linter in CI (not selected). Consistency is checked with a scratch checker during review.

## Amendments
