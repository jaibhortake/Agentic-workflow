<!-- Ported from nikhilw/structured-agentic-workflow skills/3p-review/SKILL.md (MIT), adapted to this repo's names and paths. This is the full explanation; ../SKILL.md is binding where the two differ (S/M/L sizing, rigor, docs/plans/active/, docs/decisions/, terse). -->

## Blocking Gates

Three things block sign-off no matter how good the code looks. Check them explicitly and by name; do not let them dissolve into the checklist.

**Gate 1; Every material value path has a no-mock proof.**
Green tests do not prove a feature works; tests that mock the load-bearing seam prove only that the mock was called. A feature usually has *several* independent paths (`request → route → repo → response`, `worker → derived store → completion record`, `mutation → background job → updated read`, `migration → upgraded deployed DB`). Name every one. For each, require a test crossing the real seam or evidenced manual verification (screenshot, captured log line, curl transcript). A path with neither is **CRITICAL**: it is unverified, whatever the unit tests say. Assertions must target the **leaf**: proving an intermediate holder received a dependency is insufficient; assert the actual consumer that uses it.

**Gate 2; Nothing rests on an unproven criterion.**
Any handoff concern of the form "not integration-tested" / "manual E2E not executed" / "live X not verified" is blocking. It cannot be dismissed by reading code or running mocked tests; clear it by exercising the real seam, or by explicit written risk acceptance from the human.

**Gate 3; Zero open findings at exit** (see Gate Check).

**Work with the test infrastructure that exists.** These gates demand proof, not a particular harness. Verify each harness, fixture, and command actually exists here before citing it as evidence or demanding it in a finding. Do **not** stand up an unrelated browser/E2E framework to satisfy this skill; introducing a test stack the project never chose is a bigger change than the feature, and not a reviewer's call. Where no suitable harness exists, take the strongest real automated seam plus the plan's bounded manual evidence, and record in the summary which harness was absent and how you confirmed that. "No harness exists" explains why proof is manual; it never excuses proof being absent.

---
