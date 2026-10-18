---
name: debug
description: Systematic debugging - reproduce, isolate root cause, fix with a regression test. Use for any bug, failing test or unexpected behaviour.
---

# Debug

Don't guess-and-patch.

1. **Reproduce:** get an exact failing command/test/input. If you can't reproduce it, gather logs and ask.
2. **Write a failing test** that captures the bug (when feasible).
3. **Isolate:** form 1–3 hypotheses; check the cheapest first (logs, prints, bisect, narrow the input). Read code along the actual failing path only.
4. **Root cause:** state it in one sentence. If the fix doesn't explain the symptom, keep looking.
5. **Fix** the cause, not the symptom. Smallest change.
6. Run the new test + nearby tests. Remove debug code.
7. Check for the same bug pattern elsewhere (one grep).

After 3 failed attempts: stop, summarise what you've ruled out, and ask the user.
