# Notice

The strict-mode practices in this repository (frozen intent and the three-comparison drift audit, build halts and amendment logging, the review lenses and gates, the test-scope rungs and citable-run rule, the existing-mechanisms trace and inventory, the build handoff schema, build-model and rework flow, compact briefs, decision summaries, deep audits, knowledge-graph limits, GitHub backlog handling, and the AW/BS/WP/RL rule numbering) are adapted from
[nikhilw/structured-agentic-workflow](https://github.com/nikhilw/structured-agentic-workflow) (MIT). The skills here are rewritten in our own words and fitted to our S/M/L routing, hooks, plugin packaging and CI; they are not verbatim copies.

Test-first and systematic-debugging ideas, and the Iron Law and rationalization tables in `verify`, come from [obra/superpowers](https://github.com/obra/superpowers) (MIT, Jesse Vincent). Terse output follows Caveman. Planning and verification guidance follows Anthropic's Claude Code best practices.

Additions that are ours: S/M/L task routing and the `rigor` dial, hooks that enforce rules (guard, frozen decision doc, format-on-edit, verify-on-stop), the plugin and installers, stack presets with per-rung test commands, the CI review template, the `outside-reviewer` agent, `/learn`, the planted-bug eval, and the evals folder.

`skills/test-driven-development/` and `skills/systematic-debugging/` are vendored verbatim from [obra/superpowers](https://github.com/obra/superpowers) (MIT, Copyright (c) 2025 Jesse Vincent) by `pull-superpowers.sh` / `pull-superpowers.ps1`. Each folder carries the upstream `LICENSE` and a `SOURCE.md` with the commit it came from. The only change is rewriting `superpowers:` cross-references to plain skill names (and `verification-before-completion` to our `/verify`). Do not edit them by hand.
