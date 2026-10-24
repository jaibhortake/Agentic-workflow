<!-- Ported from nikhilw/structured-agentic-workflow skills/triage/SKILL.md (MIT), adapted to this repo's names and paths. This is the full explanation; ../SKILL.md is binding where the two differ (S/M/L sizing, rigor, docs/plans/active/, docs/decisions/, terse). -->

## Step 3: Apply the Selection Strategy

### When context is thin (fresh conversation, few files loaded):
→ **Pick bugs.** They are small, self-contained, and don't require the full Brainstorm → Plan → Build cycle. They warm up the context efficiently.

### When context is rich (mid-session, modules loaded, domain established):
→ **Pick work that leverages what's already loaded.** If you've been working in the entity extraction module, recommend tasks in that same area; even if a task in a different module is technically higher priority.

### When context is rich AND resources are plentiful:
→ **Pick features or plans.** These require the full workflow and sustained attention. Now is the time.

### Priority ordering (within context-aligned work):
1. **Critical bugs**: broken functionality, data loss risks
2. **Active plan phases**: work already in progress
3. **High-priority features**: user-requested, high impact
4. **Accumulated plans in `new/`**: pre-invested design work ready for execution
5. **Low-priority bugs**: cosmetic, edge cases
6. **New feature brainstorming**: only when everything else is clear
