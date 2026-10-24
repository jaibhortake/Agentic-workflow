<!-- Ported from nikhilw/structured-agentic-workflow skills/workflow-config/SKILL.md (MIT), adapted to this repo's names and paths. This is the full explanation; ../SKILL.md is binding where the two differ (S/M/L sizing, rigor, docs/plans/active/, docs/decisions/, terse). -->

> **This repo differs:** preferences are stored in `.claude/workflow.json` (keys `rigor`, `testing`, `terse`, `useGithubIssues`, `githubRepo`, `githubProjectId`), never in agent memory. Where this file says memory or `workflow-config:<key>`, read that file and key instead.

## How to Persist

Save each preference as a memory entry in your agent's persistent memory system. Use whatever memory mechanism your platform provides; the key requirement is that the preference survives across conversation sessions.

**Memory entries should be structured as:**
- **Key:** `workflow-config:<preference-name>` (e.g., `testing` in `.claude/workflow.json`, `terse` in `.claude/workflow.json`, `useGithubIssues`, `githubRepo`, `githubProjectId`)
- **Value:** The chosen setting (e.g., `bdd`, `full`, `true`/`false`, `owner/repo`)
