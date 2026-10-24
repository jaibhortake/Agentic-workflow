<!-- Ported from nikhilw/structured-agentic-workflow skills/workflow-config/SKILL.md (MIT), adapted to this repo's names and paths. This is the full explanation; ../SKILL.md is binding where the two differ (S/M/L sizing, rigor, docs/plans/active/, docs/decisions/, terse). -->

## Output

After saving preferences, confirm what was set:

```
## Workflow Configuration Updated

- Testing methodology: [TDD / BDD]
- Output style: [normal / terse lite / terse full / terse ultra]
- Use GitHub Issues: [true / false]
- GitHub repo: [owner/repo override / auto-derived from origin]
- GitHub Project ID: [project ID or not set]

These preferences are saved to memory and will apply to all future workflow phases.
```

If the user asks to see current configuration, read the preferences from memory and display them in the same format.
