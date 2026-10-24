<!-- Ported from nikhilw/structured-agentic-workflow skills/review-lenses/SKILL.md (MIT), adapted to this repo's names and paths. This is the full explanation; ../SKILL.md is binding where the two differ (S/M/L sizing, rigor, docs/plans/active/, docs/decisions/, terse). -->

## Which gate runs which lens

Each gate is a column. Depth is the gate's, and so is what happens to a finding.

| Lens | `/brainstorm`: on the approaches and the recommendation | `/write-plan`: on the finished plan | `/review`: on the built code |
|---|---|---|---|
| impact | every approach at survey depth; the recommendation in full, in the decision audit | the **impact pass** (structural and functional), then the **consolidation pass** (the trace's third axis and the self-duplication inventory, as a pass of its own under RL-1) | *Consumer authority*, *Coupling through storage, both ends*, and the plan's Impact Analysis block checked against the code |
| removal | what each approach removes and what does that job after; a job with no replacement is a cost in the comparison, and it goes to the owner | the **removal pass** | *Retirement actually happened*, plus the new-path test for each removal |
| logic | every approach through the main case and its edges, enough to rank them; the recommendation in full, especially *values against each other* and *can the mechanism express the rule*, which are cheapest to fix here | the **logic pass** | *Correctness*, walking the built code with concrete values rather than reading it |
| behaviour | what the user sees under each approach; the recommendation's user-facing sentences go into the decision document's **What the User Sees** | the **behaviour pass**, checked against those sentences | the *Behaviour* section: drive the built thing on each surface and compare with the sentences |
| business sense | every approach, and the owner's own steer, read cold | the **business-sense pass** | the *Business Sense* section: the plan does not matter on its own; the built thing has to work the way the business needs. A defect is graded and fixed like any finding; a question goes to the owner and does not hold the gate |
| proof | for each load-bearing claim, what would prove it (BS-9, BS-10) | the **proof pass** | *Tests*, with the mutation checks run |
| coherence | the decision document once written, before `/write-plan`: Decision against Consequences, the scenario table and What the User Sees | the **coherence pass** | not run on code; *Codebase Consistency* covers the equivalent |
