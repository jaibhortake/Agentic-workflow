<!-- Ported from nikhilw/structured-agentic-workflow skills/agentic-workflow/SKILL.md (MIT), adapted to this repo's names and paths. This is the full explanation; ../SKILL.md is binding where the two differ (S/M/L sizing, rigor, docs/plans/active/, docs/decisions/, terse). -->

> **This repo differs:** preferences are stored in `.claude/workflow.json` (keys `rigor`, `testing`, `terse`, `useGithubIssues`, `githubRepo`, `githubProjectId`), never in agent memory. Where this file says memory or `workflow-config:<key>`, read that file and key instead.

## Configurable Preferences

Some aspects of this workflow are user-configurable via `/workflow-config`. When a preference is set, it is stored in your agent's persistent memory. Check memory for these settings and respect them across all phases:

- **Testing methodology:** TDD (default) or BDD. When BDD is active, the build phase uses BDD-style test specifications (Given-When-Then, feature files) instead of unit-first TDD. The core rule; "test first, always"; applies regardless of methodology.
- **Output style:** Normal (default) or terse (lite/full/ultra). When terse is active, all workflow phases adapt their prose to the requested brevity level. Technical accuracy is never sacrificed; only verbosity changes. terse compatibility is built into this workflow and works independently of the separate terse skills package.
