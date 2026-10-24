<!-- Full detail for this skill. ../SKILL.md is binding where the two differ (S/M/L sizing, rigor, docs/plans/active/, docs/decisions/, terse). -->

## Prerequisites

This skill talks to GitHub through whatever **GitHub MCP server** the user has configured. The server name is install-specific, so its tools may be named `mcp__<server>__create_issue`, `mcp__<server>__list_issues`, etc. (the official GitHub MCP server is a common choice). Calls to these tools are governed by your normal permission settings; this skill does not pin a server name. Before running any backlog task:

1. `useGithubIssues` must be `true`. If it is `false` or unset, GitHub integration is disabled; stop and tell the user to enable it with `/workflow-config` (the local `bugs.md` / `features.md` flow applies instead).
2. A GitHub MCP server must be configured and authenticated in the environment. If no GitHub MCP tools are available in the session, tell the user to configure one and stop.
3. Resolve the target repository (see next section).

---
