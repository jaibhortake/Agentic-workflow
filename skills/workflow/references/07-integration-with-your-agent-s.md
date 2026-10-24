<!-- Full detail for this skill. ../SKILL.md is binding where the two differ (S/M/L sizing, rigor, docs/plans/active/, docs/decisions/, terse). -->

## Integration with Your Agent's Config

For best results, list the workflow skills in your project's config file (`CLAUDE.md`, `.cursorrules`, `GEMINI.md`, or `.github/copilot-instructions.md`) so they are loaded automatically:

```markdown
## Workflow Skills
- `workflow`; orchestrates the structured development lifecycle
- `/workflow-config`; configure workflow preferences (TDD/BDD, terse output style)
- `/brainstorm`; explore problem space, challenge the design, produce decision documents
- `/decision-summary` : plain-words summary of what has been decided so far; any time, changes nothing
- `/write-plan`; write phased plans to docs/plans/new/
- `/build-phase`; execute plan phases with test + self-review; produces a build completion report (no review/handoff)
- `/build-model`; dedicated build-model workflow: build-phase → review → build-handoff → stop (alternative entry point to this workflow, for a smaller/faster build session)
- `/review`; independent third-person code review (after all build phases)
- `/build-handoff`; emit the fixed Build Handoff Summary artifact after review passes
- `/verify`; the final gate: fresh suite, requirements tick-off, drift audit
- `/compact-brief` : a one-line compact command and a resume brief to paste after it; suggested at the compact slots, usable any time
- `/test-driven-development`; RED-GREEN-REFACTOR, test first always (from superpowers)
- `/debug`; 4-phase root cause investigation (from superpowers)
- `/triage`; recommend next task minimizing context thrash
```

Four more are references rather than steps, and are loaded by the skills that need them rather
than invoked: `test-scope` (how wide a test run must be at each gate), `existing-mechanisms` (the
eight questions about what the codebase already does), `review-lenses` (the perspectives brainstorm,
plan review and code review look through, one question each, and the outside-review brief), and
`knowledge-graph` (what a graphify answer is worth, loaded only when graphify is actually installed). They do not belong in the list above.
