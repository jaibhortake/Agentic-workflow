<!-- Ported from nikhilw/structured-agentic-workflow skills/existing-mechanisms/SKILL.md (MIT), adapted to this repo's names and paths. This is the full explanation; ../SKILL.md is binding where the two differ (S/M/L sizing, rigor, docs/plans/active/, docs/decisions/, terse). -->

## How to answer

- **Count the set, then list it.** Every answer about a set of things carries the size of the set
  and the members: "7 call sites in 5 files" with the files named, not "all callers updated" and
  not "the callers are handled". A count is checkable by the next reader and an adjective is not,
  and the gap between a set you enumerated and a set you characterised is exactly where the
  half-sized blast radius lives. If you did not count, say you did not count.
- **Every answer names its evidence.** "Checked, looks fine" is not an answer. Say what you ran or
  read: the graph query, the grep, the file you opened, the probe you executed. `/brainstorm`'s
  evidence tiers apply here exactly as they do everywhere else; a claim from docs or comments is
  tier 1 and is a liability if it is load bearing.
- **An unknown is probed or promoted, never left.** If the answer is cheap to get, get it now. If
  it is genuinely expensive, write it down as an Open Question and say what it would change. An
  unanswered question is a risk the recommendation carries silently.
- **Write the answers down where the next reader will find them.** In `/brainstorm` they belong in
  the decision document; in `/write-plan`, in the plan's Codebase Analysis. Answers that live only
  in the session are answers the build model never sees.
