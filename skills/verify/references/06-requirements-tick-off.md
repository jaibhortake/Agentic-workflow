<!-- Full detail for this skill. ../SKILL.md is binding where the two differ (S/M/L sizing, rigor, docs/plans/active/, docs/decisions/, terse). -->

# Part 2: Requirements tick-off (plan → code)

Re-read the plan from disk. Not from memory of it, not from the handoff summary, not from the
review. Build a checklist and walk it.

- **Every phase, every implementation step, every test criterion, one line each.** Mark each
  **built and proven**, **built but unproven**, or **not built**.
- **Proven means an automated run you can name.** A criterion checked by reading is *unproven*, and
  it goes on the report as unproven. So does a criterion proven only at a scoped rung, which is a
  real result but a narrower claim than the plan asked for.
- **Walk the plan's own sections, not just its phases.** State & Data Contracts, Failure Modes &
  Interactions, and Value Paths & Seam Tests each specify behaviour. A named seam test that was
  never written is a missing requirement, not a missing nicety.
- **Anything in Out of Scope that got built anyway is a finding.** Scope grows silently and this is
  the only line that catches it.
- **Anything removed comes with its replacement named.** Walk the plan's removal table
  (`/existing-mechanisms` question 5) against the diff. A row whose replacement never landed, and a
  deletion the table never named, are each a capability the feature took away. Report them in
  those words. The suite cannot see this, because the tests that covered the removed path were
  usually deleted with it, so the same commit destroys the evidence of the loss (AW-26).

A gap here does not fail the gate by itself. An *unreported* gap does. The output is a truthful
ledger; the human decides whether an unproven row is acceptable.

---
