# Results

| Date | Task | Size | Run | Tokens | Cost | Hidden tests | Defects | Drift | Interventions | Notes |
|---|---|---|---|---|---|---|---|---|---|---|
| 2026-10-18 | Cart discount codes (Node) | S | A plain | 38.6k | – | 14/14 | 0 | 0 | 0 | Left `npm test` broken (Node 24) and didn't notice |
| 2026-10-18 | Cart discount codes (Node) | S (agent sized M) | B workflow v1 | 48.9k | – | 14/14 | 0 | 1 logged | 0 | Fixed broken `npm test` via verify gate; over-sized → sizing rule tightened |
| 2026-10-18 | Todo REST API (Node, no deps) | M | A plain | 49.0k | – | 22/22 | 0 | 0 | 0 | 5 tests, 174 src lines, no plan or assumptions recorded |
| 2026-10-18 | Todo REST API (Node, no deps) | M | B workflow | 59.8k | – | 22/22 | 0 | 0 | 0 | 7 tests, 246 src lines, plan + assumptions; wrote code and tests together (TDD not followed) → build-phase tightened |
| 2026-10-18 | Invoice/refund bug report (vague, 6 bugs) | S | A plain | 38.5k | – | 13/13 | 0 | 0 | 0 | Found all bugs; added 0 regression tests |
| 2026-10-18 | Invoice/refund bug report (vague, 6 bugs) | S | B workflow | 46.4k | – | 13/13 | 0 | 0 | 0 | Found all bugs; +6 regression tests; again wrote tests with code, not first → verify now requires a test that fails on old code |
| 2026-10-19 | Note sharing in existing multi-file service (real `claude -p`, Sonnet, 2 runs/arm) | S–M | A plain ×2 | 4.3k / 7.0k out | $0.15 / $0.19 | 7/8, 8/8 | 1 (missing username → 404 not 400) | 0 | 0 | Export-leak trap avoided both runs; run 1 wrote no tests; 60–72 s |
| 2026-10-19 | Note sharing in existing multi-file service (real `claude -p`, Sonnet, 2 runs/arm) | S–M | B workflow ×2 | 8.7k / 7.4k out | $0.36 / $0.35 | 8/8, 8/8 | 0 | 0 | 0 | Trap avoided; both added tests; run 2 wrote plan straight to done/ and skipped /review + /verify; 106–164 s |
| 2026-10-24 | Planted-bug review: note sharing (9 planted: impact, removal, logic, behaviour, proof, security, duplication, 2 drift). In-session subagents, same model, rigor standard, 3 runs/arm | M | Compact skills (361ab56) ×3 | 52.3k / 53.0k / 52.9k total | – | 9/9, 9/9, 9/9 found | 0 false positives | – | 0 | 4 tool calls each, 44-52 s. Extras found (real, unplanted): duplicate re-share entry ×3, admin export now dumps all users' notes ×2 |
| 2026-10-24 | same | M | Full skills (2.0.0) ×3 | 41.7k / 42.0k / 41.8k total | – | 9/9, 9/9, 9/9 found | 0 false positives | – | 0 | 3 tool calls each, 35-45 s. Extras: duplicate re-share entry ×3, missing Phase 2 tests ×3 |

**Reading the 2026-10-24 run.** Both arms hit the ceiling, so this fixture can't separate them on catch rate; it is too easy for this model. The full skills weren't more expensive at the review step (about 20% fewer tokens), but with 3 tool calls the reviewers most likely read only `SKILL.md` and never opened `references/`, so this measures the new binding text, not the reference depth. Next: a harder fixture (more files, string-dispatched callers, a crash window between writes, a hollow test that needs mutation to expose) and a check in the transcript of which references were read. Run as in-session subagents, not headless CLI (plan amendment A3).

| | | | A plain | | | /  | | | | |
| | | | B workflow | | | /  | | | | |
