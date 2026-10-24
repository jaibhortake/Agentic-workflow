<!-- Ported from nikhilw/structured-agentic-workflow skills/handoff-summary/SKILL.md (MIT), adapted to this repo's names and paths. This is the full explanation; ../SKILL.md is binding where the two differ (S/M/L sizing, rigor, docs/plans/active/, docs/decisions/, terse). -->

## Your only job

Follow the template below: same headings, same order, same casing. Fill each section from the build record. Do **not** rename sections, add sections, drop sections, or replace the template with your own prose. This is a fixed artifact format so the consuming model can parse it reliably. A section with nothing in it is filled with "None.", never removed.

```markdown
## Build Handoff Summary

**Plan:** [plan file path]
**Plan revision built against:** [amendment IDs applied during this build, e.g. "A1, A2", or "as approved"]

### Halts
- **Phase N**: [what was halted on, one line] → [resolved by amendment A1 / overruled by the user / withdrawn after investigation]
- (Every halt raised during this build. If none, write "None.")

### Deviations
- **Phase N: [Name]**: [what changed and why, one line]; [amendment ID if a plan amendment covers it, or "no amendment"]
- (Only list phases that deviated from the plan. If nothing deviated, write "None.")

### Verification Runs
- **[plan criterion, or a plain name for the run]** (rung [T1/T2/T3/T4]) → exit [code]; [N passed, M failed, K skipped]
- **Mutation checks** → [N of M witnessed]; each one not witnessed is listed under Unproven Criteria. Omit this line when the plan names no mutation checks
- (Name the run; do not write out the shell line. Every run carries its rung. The T4 full-suite run from Phase Completion is mandatory here. Report the counts the terminal printed, not what you expected.)

### Unproven Criteria
- **[plan criterion]**: [manual / skipped / deferred / verified by inspection]; [why]
- (Every test criterion in the plan that did NOT end in a green automated run. If all criteria ran green, write "None.")

### Concerns
- [Anything the next reviewer should specifically investigate or validate]
- (If none, write "None.")
```
