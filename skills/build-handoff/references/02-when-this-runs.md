<!-- Full detail for this skill. ../SKILL.md is binding where the two differ (S/M/L sizing, rigor, docs/plans/active/, docs/decisions/, terse). -->

## When this runs

This skill is invoked **after** the build is complete and **after** `/review` has passed. It does not build, test, or review; it only produces the handoff record. If `/review` has not run yet, stop and run it first. `/review` is its own artifact; the handoff summary does not restate or reference its findings.
