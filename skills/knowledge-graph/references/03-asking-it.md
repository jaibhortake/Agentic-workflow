<!-- Full detail for this skill. ../SKILL.md is binding where the two differ (S/M/L sizing, rigor, docs/plans/active/, docs/decisions/, terse). -->

## Asking it

| Question | Call |
|---|---|
| What already handles X? | `graphify query "<question>"` |
| How do these two things connect? | `graphify path "A" "B"` |
| What is this component? | `graphify explain "<node>"` |
| Who reaches this? (backward) | the node's **incoming** edges |
| What does this reach? (forward) | the node's **outgoing** edges |

Search by **behaviour**, not by the name you would have given it. The duplicate you are about to
write is nearly always under a word you did not think of.
