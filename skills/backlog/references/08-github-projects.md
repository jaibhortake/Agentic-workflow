<!-- Full detail for this skill. ../SKILL.md is binding where the two differ (S/M/L sizing, rigor, docs/plans/active/, docs/decisions/, terse). -->

## GitHub Projects (V2) Integration

If `githubProjectId` is configured:
1. **Add to Project:** When creating a new issue, use the GitHub MCP tools to add the issue to the specified Project board.
2. **Synchronize Status:**
   - **Triage (Todo):** Set the Project status column to **Todo** (or equivalent) when the issue is logged.
   - **Plan/Build (In Progress):** Move the card to **In Progress** when starting a `/write-plan` or `/build-phase`.
   - **Review (In Review):** Move the card to **In Review** during `/review`.
   - **Verify (Done):** Move the card to **Done** after `/verify` passes.

---
