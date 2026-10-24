<!-- Full detail for this skill. ../SKILL.md is binding where the two differ (S/M/L sizing, rigor, docs/plans/active/, docs/decisions/, terse). -->

# Part 4: The completion report

You are writing to the person who asked for the feature, and the only question they have is *did I
get what we agreed, or not*. Answer that first, in their words. The report is said, not saved
(AW-29), and it is **the one report this gate emits**: Parts 1 to 3 are worked, not narrated, and a
check that came back clean is evidence for the bottom of this report rather than an update of its
own (AW-28). Three rules:

- **Bad news first.** What is wrong opens the report. Everything that checked out is evidence, and
  evidence goes at the bottom. Nobody should have to read a clean checklist to discover that the
  thing they asked for is not there.
- **Show both sides of every difference.** Quote what was decided, in the words it was decided in,
  then say what was built instead and where it lives. "Narrowed", "half-implemented" and "widened"
  are your labels for a difference, not the difference; a reader cannot rule on a label. One row,
  two columns, both filled.
- **Say it in the words of the work, not the words of this skill.** Section names, check names and
  internal shorthand mean nothing outside this file. The verdict keyword and the rung on the suite
  line are the only terms that travel, and each gets a plain sentence next to it.

If there is no decision document, the first section says exactly that, because "nothing departed
from what we decided" and "nothing recorded what we decided" look identical on a page and are not
the same finding.

```markdown
## Completion Verification

**Claim:** [what is being claimed complete]
**Plan:** [path]   **Decision doc:** [path, or "none, so there is no record of what was decided"]

### Status: COMPLETE / NOT COMPLETE
[One line, in the owner's terms: what is wrong, or that nothing is. If the drift verdict is not NO
DRIFT, name it here in a clause: "...and nobody wrote that down before this gate (UNDOCUMENTED
DRIFT)."]

### What we decided and did not build
[Every departure from the decision document, one row each. Or: "Nothing. Every decision in [doc] is
in the code as written."]

| We decided | We built instead | Where | Was it written down before this gate? |
|---|---|---|---|
| "[quoted from the decision doc]" ([which section]) | [what the code actually does, plainly] | [file:line] | no, found here / yes, [amendment entry] |

### What we built and nobody decided
[Capability that widened past what was decided, scope the plan never carried, a plan step with no
amendment behind it. Same two columns, same quoting. Or "Nothing."]

### What the plan asked for and is not there
[Requirements not built; requirements built but unproven; capabilities removed whose named
replacement never landed, and deletions no removal table named. Or "Nothing."]

| The plan asked for | What is actually there | Proven by |
|---|---|---|
| [requirement / contract line / seam test / removal-table row] | not built / built, nothing proves it / replacement never landed | [run name, or why nothing proves it] |

### Your call
[Numbered, one line each, cheapest first. What needs a ruling, and what each choice costs. Or
"Nothing needs a ruling."]

### Evidence
**Suite:** [run name] (rung T4, the full suite) → exit [code], [N passed, M failed, K skipped].
[Fresh, or: cited from /review's sign-off run; tree proven unchanged by git status and git diff.]

**Every requirement, including the ones that passed:**

| Requirement | Status | Evidence |
|---|---|---|
| [phase / criterion / contract line / seam test] | built and proven / built but unproven / not built | [run name, or why not] |

**What the drift audit compared:**
- **Baseline:** decision document read from [git at <ref> / the working tree only, because it is
  untracked]; working copy [identical to the committed version / differs: what, and whether an
  Amendments entry covers it]. Plan baseline: [git history / the Amendment Log read as a claim /
  the handed-off copy].
- **DecisionDoc → Plan:** [N] decisions read, [N] upheld, [N] narrowed, [N] superseded, [N] dropped.
  Each departure is a row above.
- **Plan → Plan:** [each difference from the approved plan and the Amendment Log entry behind it,
  or "none"].
- **Scenario table:** [N] differing rows checked against the built behaviour, [N] matched; each
  mismatch is a row above. [Or: the decision document carries no table, or it records "not a rule
  change".]
- **What the User Sees:** [N] expectation sentences checked against the built behaviour, [N] held;
  each broken one is a row above. [Or: the decision document has no such section.]
- **DecisionDoc → Code:** [does the code solve the problem that was decided; did the document's
  "what would reverse this decision" condition come true during the build; did the amendments add
  up to an approach nobody chose].
- **Verdict:** NO DRIFT / DOCUMENTED DRIFT / UNDOCUMENTED DRIFT
- **Documents I changed during this gate:** [none, or: the appended Amendments entry, after the
  human accepted it, quoting what they said. Nothing else, ever. "None" is the normal answer.]
- **Record still to close:** [what the human has not yet ruled on, or "nothing"]
```

If the verdict is UNDOCUMENTED DRIFT, or any requirement is "not built", the status is **NOT
COMPLETE** until the record is closed or the human accepts the gap in writing.

---
