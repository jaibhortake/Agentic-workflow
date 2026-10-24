<!-- Ported from nikhilw/structured-agentic-workflow skills/knowledge-graph/SKILL.md (MIT), adapted to this repo's names and paths. This is the full explanation; ../SKILL.md is binding where the two differ (S/M/L sizing, rigor, docs/plans/active/, docs/decisions/, terse). -->

## Counting in typed code

The graph answers *where to look*. It cannot answer *what really reaches this*, because it links
names, and a name is not a type. Wherever the code has a type checker or a language server, that is
the tool for the count:

- **Every reference to a symbol:** the language server's *find references* (pyright or pylance for
  Python, the TypeScript server, gopls, rust-analyzer), which resolves `obj.method()` to the method
  it actually calls.
- **Everything a removal or signature change breaks:** apply it in an isolated copy and run the
  project's type checker or compiler (`tsc`, pyright or mypy, `go build`, `cargo check`). Each error is an inbound site. `/review-lenses`' impact lens has the
  method, including proving the check can see a deliberate break before you trust a clean result.
- **What neither can see:** names held in strings, patch targets in tests, dispatch tables, config
  keys. That part is still grep.

Use all three, and record in the trace's evidence which one answered what. A caller count taken from
graph edges alone in typed code is an undercount that looks exact. Where the language has no type
checker, or the repo does not use one, the graph and grep are what you have: say so once, and do not
install one on the user's behalf.
