<!-- Ported from nikhilw/structured-agentic-workflow skills/existing-mechanisms/SKILL.md (MIT), adapted to this repo's names and paths. This is the full explanation; ../SKILL.md is binding where the two differ (S/M/L sizing, rigor, docs/plans/active/, docs/decisions/, terse). -->

## The ledger

The gates below record the answers in this shape. Eight lines, one per question, each with its
evidence. Collapse the ones that genuinely do not apply onto a single "does not apply" line.

```markdown
### Existing Mechanisms
1. **Callers and calls:**
   - *backward:* [N] sites in [M] files: [each one, file:line; direct callers → their callers, to
     the boundary named here; plus the inbound edges that do not spell the name]
     *(evidence: graph incoming edges / grep / read)*
   - *forward:* [N] dependencies: [each one; what it calls, and what those depend on: modules,
     tables, queues, services, env] *(evidence: graph outgoing edges / read)*
   - *boundary:* [where you stopped tracing outward, and why that edge cannot be disturbed]
2. **Scope beyond the entry point:** [related methods and flows that reach the same thing]
3. **Already exists:** [the mechanism that already does this, or what was searched for and not found]
4. **Relationship to the incumbent:** [extend / replace / abandon] + [why]
5. **Retirement:** [what becomes dead and where it is removed, or "nothing is retired". If anything
   is removed, this line is the removal table above, one row per removal]
6. **Build on what exists:** [the extend-the-incumbent version of this change]
7. **House pattern:** [the shape this codebase already uses for this problem]
8. **Unify vs bifurcate:** [what is extracted; any second pathway introduced and what collapses it]
```
