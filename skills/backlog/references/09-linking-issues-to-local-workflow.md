<!-- Full detail for this skill. ../SKILL.md is binding where the two differ (S/M/L sizing, rigor, docs/plans/active/, docs/decisions/, terse). -->

## Linking Issues to Local Workflow Plans

To ensure traceability:
1. **When Writing a Plan:** When creating a plan file (e.g., `docs/plans/new/offline-sync.md`), include the GitHub Issue number at the top of the file:
   ```markdown
   # Plan: Offline Sync (#123)
   ```
2. **Comment on the Issue:** When the plan is approved, add a comment on the GitHub issue linking it to the plan file:
   ```markdown
   Plan approved. Active plan file: docs/plans/active/offline-sync.md
   ```
3. **Closing Issues:** When the verification phase is successful and the plan is moved to `docs/plans/done/`, close the GitHub issue with a comment referencing the final commits or verification output.
