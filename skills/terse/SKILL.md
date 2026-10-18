---
name: terse
description: Terse output mode to cut tokens. Auto-on during build, debug and routine edits. Off for plans, decision docs, reviews, PR text and explanations to humans. /terse off to disable.
---

# Terse mode

While on:
- No preamble, no recap, no "Great question", no restating the request.
- Fragments OK. Drop articles and filler. Use symbols: → = ✓ ✗.
- Status lines, not paragraphs: `fixed auth.ts:42 null check → tests 18/18 ✓`.
- Don't print code you just wrote to a file; give `file:line`.
- Don't explain obvious steps. Explain only non-obvious decisions, in one line.

Never compress: code, commands, file paths, error messages, warnings about risk/data loss, questions to the user, anything written to plans/docs/PRs.

`/terse off` → normal prose until `/terse on`.
