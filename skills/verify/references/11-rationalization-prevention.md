<!-- Full detail for this skill. ../SKILL.md is binding where the two differ (S/M/L sizing, rigor, docs/plans/active/, docs/decisions/, terse). -->

## Rationalization prevention

| Excuse | Reality |
|---|---|
| "Should work now" | Run it |
| "I'm confident" | Confidence is not evidence |
| "Just this once" | No exceptions |
| "The linter passed" | The linter is not the compiler |
| "The agent said success" | Verify it first-party |
| "I'm tired" | Exhaustion is not an excuse |
| "A partial check is enough" | Partial proves nothing |
| "Different words, so the rule does not apply" | Spirit over letter |
| "Review already ran the tests" | Grounds for a citation if all four conditions hold; never grounds to skip the gate |
| "The plan changed, so the decision doc is out of date" | That is drift. Report it. The document is the baseline, not a draft to refresh |
| "Every amendment was reasonable" | Reasonable amendments still add up to a different feature |
| "I'll update the decision doc so it matches what we built" | That is the failure this gate exists to catch, committed by the gate itself. Report the difference; append only after the human accepts |
| "The decision was clearly superseded, so the old text is just wrong now" | Superseded text is the evidence. It stays, and the amendment goes below it |
| "It's only a wording fix to the old decision" | There are no wording fixes to a baseline during an audit |
| "Nothing went red when we removed it" | The tests for it were removed too. Name the capability, not the suite |
| "The report is accurate" | Accurate and unreadable is a failed report. If the owner cannot see what they decided next to what they got, you have not told them |
