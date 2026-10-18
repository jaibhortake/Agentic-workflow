# Results

| Date | Task | Size | Run | Tokens | Cost | Hidden tests | Defects | Drift | Interventions | Notes |
|---|---|---|---|---|---|---|---|---|---|---|
| 2026-10-18 | Cart discount codes (Node) | S | A plain | 38.6k | – | 14/14 | 0 | 0 | 0 | Left `npm test` broken (Node 24) and didn't notice |
| 2026-10-18 | Cart discount codes (Node) | S (agent sized M) | B workflow v1 | 48.9k | – | 14/14 | 0 | 1 logged | 0 | Fixed broken `npm test` via verify gate; over-sized → sizing rule tightened |
| | | | A plain | | | /  | | | | |
| | | | B workflow | | | /  | | | | |
