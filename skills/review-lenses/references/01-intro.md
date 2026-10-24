<!-- Full detail for this skill. ../SKILL.md is binding where the two differ (S/M/L sizing, rigor, docs/plans/active/, docs/decisions/, terse). -->

# Review Lenses

This file holds the perspectives the workflow reviews through: what each lens asks, what it catches,
and the checklist it walks. `/brainstorm` looks through them at an approach, `/write-plan` at a
plan, and `/review` at built code. The gate table at the end says which gate runs which lens and
how deep. A gate names its column there and keeps a short binding copy of each checklist inline; it
does not restate the checklist, because two copies drift and the weaker one wins.

**Why lenses, and why one at a time.** Asked by hand, each of these questions has turned up a real,
usually critical defect in work that had already been reviewed: a plan, a decision, a finished build.
A review that carries several questions at once answers whichever is easiest and reports clean on
the rest, and nothing on the page shows which ones it skipped. So each lens is run on its own, with
its own question in front of you. What it finds is settled before the next lens looks: fixed, or put to the owner where it is theirs to decide.
