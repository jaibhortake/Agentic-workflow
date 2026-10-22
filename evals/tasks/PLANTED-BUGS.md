# Eval task: planted-bug catch rate

Standard evals compare cost and hidden-test pass rate; if every arm scores 100% (as the first runs did) they can't show whether a stricter workflow buys anything. This task measures what the review and verify gates *catch*.

## Setup
1. Take a small repo with a passing suite (any of your own tasks works).
2. Make a branch where a feature is implemented **with N known defects planted** (aim for 6-10) spread over classes the workflow claims to catch. Record them in a private answer key, one line each, with its class:
   - **Impact:** a changed signature with one caller not updated (including a test double or a string-dispatched caller).
   - **Removal:** a deleted helper whose job nothing now does (with the covering test also deleted).
   - **Logic:** an off-by-one at a boundary; a retry that never stops; a threshold equal to a weight; a crash window between two writes.
   - **Behaviour:** one export or screen that shows a blank field for the new data.
   - **Business sense:** an outcome a typical user would find odd that no decision asked for.
   - **Proof:** a test that passes with its guard removed (hollow); a mocked seam where the plan names a no-mock test.
   - **Security:** a permission check tested only as admin.
   - **Duplication:** a helper rewritten in a second file.
   - **Drift:** one requirement silently dropped, one capability silently added.
3. Keep the task spec, a decision doc and a plan alongside the branch so the conformance and drift checks have material.

## Arms
- **A:** plain agent asked to "review this branch".
- **B:** this workflow, `rigor: standard`.
- **C:** this workflow, `rigor: strict` (ledger, gates, deep audits, lenses).

Give each arm the same branch and the same budget cap. Run each at least 3 times (variance matters at n=1).

## Record (extend `evals/results.md`)
| Arm | Run | Tokens | Cost | Planted found / N | By class | False positives | Wrong-but-confident claims | Interventions |
Score a planted defect as found only if the finding names the right file and cause. Count a finding that is not a real defect as a false positive. Count a clean claim made while a planted defect remained as a wrong-but-confident claim.

## Reading the result
- If C finds materially more than A or B at tolerable extra cost, strict mode is earning its keep for that class of task; keep it as the L default.
- If B finds about what C finds, make `standard` the default for M and keep strict for L only.
- If neither beats A, the workflow's value is process (plans, drift records), not defect catching; say so in the README rather than claiming otherwise.
- Classes the workflow misses go into `docs/lessons.md` and become a new check or lens.
