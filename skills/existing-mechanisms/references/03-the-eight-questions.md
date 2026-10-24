<!-- Full detail for this skill. ../SKILL.md is binding where the two differ (S/M/L sizing, rigor, docs/plans/active/, docs/decisions/, terse). -->

## The eight questions

Answer every one. A question that genuinely does not apply is answered **"does not apply,
because ..."**; silence reads identically to "checked and clean" to every later reader, and that
is how the gap ships.

1. **Callers and calls, in both directions.** Trace the target backward *and* forward. They answer
   different questions and missing either one is its own class of defect, so answer them as two
   separate lists rather than one paragraph about "usages".

   - **Backward, what reaches this.** Every direct caller, then *their* callers, outward until you
     reach a boundary that this change cannot disturb (a stable public API, a process edge, a
     surface with its own contract). Say where you stopped and why. Direct callers are the easy
     half; the defect usually lives one hop further out, where a caller adapts to the change and
     quietly passes something different to *its* caller. Include the inbound edges that carry no
     literal reference to the name: test doubles and fixtures, dependency-injection registrations,
     route and command tables, event or signal subscriptions, decorators, serialized or persisted
     references, config keys, scheduled jobs, and anything dispatched by string. A grep finds the
     name; none of these spell it.
   - **Forward, what this reaches.** Everything the target calls out to, and what those things
     depend on in turn: modules, shared helpers, database tables and columns, queues, caches,
     files, environment variables, external services, and the assumptions each of those carries.

   Backward tells you who breaks when this changes. Forward tells you what can break *this*, and
   what the change inherits whether or not you looked. Where an index exists, walk it both ways:
   `graphify query` to find the thing, its incoming edges for backward, its outgoing edges for
   forward, and `graphify path "A" "B"` to confirm two things actually connect. The graph matches by
   name, so in typed code take the count from the language server's *find references* or the type
   checker instead, and grep for names held in strings.

   **This question is the structural third of a larger method.** Where a gate's row below says
   *impact trace*, answer it with "The impact trace" section further down: the same backward and
   forward walk, plus the functional flows that break while every call site still compiles, plus
   the consolidation verdict. Answering only this question and stopping is the most common way a
   blast radius comes out at a third of its real size.

   *Prevents, backward: the signature change that breaks seven call sites nobody listed, and the
   caller two hops out that silently changes meaning. Forward: building on a dependency that
   already has the constraint you are about to design around.*

2. **Scope beyond the entry point.** Which related methods, sibling flows, and alternative paths
   reach the same data or the same decision? A change scoped to one function is only correct if
   the other three ways in do not exist. *Prevents: fixing one of four entry points and calling
   the behaviour fixed.*

3. **Does this already exist?** Name the mechanism in this codebase that already does this job, or
   state what you searched for and did not find. Search by *behaviour*, not by the name you would
   have given it; the duplicate you are about to write is nearly always sitting under a word you
   did not think of. *Prevents: the second implementation of something the codebase already had.*

   **Asked of a plan or a diff, this question has a second half: does the change already contain
   it?** A plan that specifies three readers can give each its own copy of the same skeleton, and a
   later phase can rewrite what an earlier phase built an hour before. Each copy reads fine in its
   own file, so that half is answered by listing, not by reading: the **self-duplication
   inventory** below.

4. **Relationship to the incumbent.** If something related exists, say which of these you are
   doing, in one word, and then justify it: **extend** it, **replace** it, **abandon** it, or
   **compete** with it. *Compete is never an answer you get to keep.* Two mechanisms for one job is
   the defect, whichever one is better. If the honest answer is "compete", the work is not designed
   yet.

5. **Retirement and dead code.** If you are replacing or abandoning something: what happens to the
   old mechanism, its callers, its tests, its config keys, its stored data, its documentation?
   Name every part that becomes dead, unreachable, or vestigial, and where it gets removed. A
   subsystem that no longer runs but is still installed is worse than one that was never built;
   the next reader cannot tell it is dead. *Prevents: the abandoned-in-place subsystem that three
   people later assume is live.*

   **The moment anything is removed, this answer stops being a line and becomes a table.** One row
   per removal, with a replacement named for each. Summarising instead, as in "cleaned up the old prune
   path", is how the load-bearing half of a removal disappears without anyone deciding to drop it.

   | Removed | What it did | Replaced by | Anything lost? |
   |---|---|---|---|

   - **Nothing is deleted because it "looks unused".** Prove the callers both ways, per question 1,
     including the inbound edges that never spell the name: tests, fixtures, DI registrations,
     route and command tables, config keys, scheduled jobs, anything dispatched by string. A
     removed file is also read as a file: by tests, build and packaging files, and checks that
     open it by path. Name those readers too, not only the callers of its code.
   - **Ask what the code was load-bearing *for*, not only who calls it.** The dangerous removals
     are the ones that read as housekeeping. A checkpoint prune that looks like tidy-up can be the
     only thing bounding a database that is already at 100 MB, and no caller says so.
   - **A test left covering a path nobody takes any more is a coverage hole, not a pass.** It stays
     green and proves nothing. Name it in the row, and say which assertion replaces it.
   - **Deleting a test because it went red is not updating it.** A changed rule needs a test that
     states the new rule.
   - **Scalpel, not butcher knife.** Remove exactly the lines the table names, not the
     neighbourhood. Anything you want to remove that the table does not name gets a row first.
   - **You cannot finish with less than you started with.** A row whose *Replaced by* cell is empty
     is a capability the work took away. That is a loud failure, not a simplification. Say so in
     those words rather than letting the blank cell read as an answer. Reduced functionality is a
     decision the owner is allowed to make; it is not one any gate here makes quietly on their
     behalf.

6. **Build on what exists.** State the version of this change that extends the existing mechanism
   rather than adding a parallel one, even if you will not recommend it. If you cannot state it,
   you have not understood the existing mechanism well enough to replace it. *Prevents: greenfield
   design applied to a field that is not green.*

7. **House patterns before book patterns.** What shape does this codebase already use for this
   class of problem? Name it before you name a pattern from a book. The project's existing
   vocabulary wins over a tidier abstraction; consistency beats correctness in isolation.
   *Prevents: a third way of doing the thing the codebase already does two ways.*

8. **Unify, do not bifurcate.** What common behaviour can be extracted here? And, the sharper half:
   does this change add a second pathway where one existed? A branch at the top that routes old
   versus new, a flag that selects between implementations, a parallel class for the new case;
   each is a bifurcation, and each one doubles every future change to this area. If you are adding
   one, say so out loud and say what collapses it back.
