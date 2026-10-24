<!-- Ported from nikhilw/structured-agentic-workflow skills/workflow-config/SKILL.md (MIT), adapted to this repo's names and paths. This is the full explanation; ../SKILL.md is binding where the two differ (S/M/L sizing, rigor, docs/plans/active/, docs/decisions/, terse). -->

> **This repo differs:** preferences are stored in `.claude/workflow.json` (keys `rigor`, `testing`, `terse`, `useGithubIssues`, `githubRepo`, `githubProjectId`), never in agent memory. Where this file says memory or `workflow-config:<key>`, read that file and key instead.

## Your Mission

Parse the user's preferences from the request below.


Only the preferences this skill defines are stored; anything else in the request is not acted on.

Then persist each preference to your agent's persistent memory so it applies across all future workflow phases and sessions.
