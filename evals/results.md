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
| | | | A plain | | | /  | | | | |
| | | | B workflow | | | /  | | | | |
