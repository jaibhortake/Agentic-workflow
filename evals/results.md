# Results

| Date | Task | Size | Run | Tokens | Cost | Hidden tests | Defects | Drift | Interventions | Notes |
|---|---|---|---|---|---|---|---|---|---|---|
| 2026-10-18 | Cart discount codes (Node) | S | A plain | 38.6k | – | 14/14 | 0 | 0 | 0 | Left `npm test` broken (Node 24) and didn't notice |
| 2026-10-18 | Cart discount codes (Node) | S (agent sized M) | B workflow v1 | 48.9k | – | 14/14 | 0 | 1 logged | 0 | Fixed broken `npm test` via verify gate; over-sized → sizing rule tightened |
| 2026-10-18 | Todo REST API (Node, no deps) | M | A plain | 49.0k | – | 22/22 | 0 | 0 | 0 | 5 tests, 174 src lines, no plan or assumptions recorded |
| 2026-10-18 | Todo REST API (Node, no deps) | M | B workflow | 59.8k | – | 22/22 | 0 | 0 | 0 | 7 tests, 246 src lines, plan + assumptions; wrote code and tests together (TDD not followed) → build-phase tightened |
| 2026-10-18 | Invoice/refund bug report (vague, 6 bugs) | S | A plain | 38.5k | – | 13/13 | 0 | 0 | 0 | Found all bugs; added 0 regression tests |
| 2026-10-18 | Invoice/refund bug report (vague, 6 bugs) | S | B workflow | 46.4k | – | 13/13 | 0 | 0 | 0 | Found all bugs; +6 regression tests; again wrote tests with code, not first → verify now requires a test that fails on old code |
| | | | A plain | | | /  | | | | |
| | | | B workflow | | | /  | | | | |
