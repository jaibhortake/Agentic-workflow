# Deep audits (conditional)

Run the matching audit only when the change touches that area. Each item is a question answered with evidence from disk, not a box to tick. Depth is set by these triggers, never by how big the change feels: a four-line permission-check change trips the authority trigger; a four-hundred-line fixture shuffle trips nothing. Record in the sign-off which audits ran and the trigger matched (or "none applied").

## Derived state (caches, indexes, materialized views, search indexes, generated artifacts)
- Rebuildable **only** from authoritative data? Name the command. If rebuilding needs something only the derived store holds, it is a second source of truth.
- Generations and pointers: is a new generation built then swapped atomically, or mutated in place while readers read?
- Stale reads: what does a reader get between write and reconcile? Is the window bounded and acceptable?
- Retention: are old generations cleaned up; does a cleanup failure block or leak?
- **Security:** can stale derived state grant visibility that current authoritative state denies (deleted record still indexed, revoked permission still cached)?
- Loss: if the derived store is deleted, does recovery rebuild from authority, or invent authority from what survived?

## Migrations and schema change
- **Fresh database vs an already-dirty deployed one:** both paths tested? The second is the one that breaks.
- Preflight: does it check preconditions and report what it found, or just start writing?
- Fail-closed: on unexpected data does it stop, or skip rows and report success?
- Transactionality: what is on disk if it dies mid-run; is a partial migration detectable and resumable?
- Reversible? If not, is that stated with an operator remediation path?
- Schema snapshot and generated artifacts regenerated and committed?
- Startup: what does the app do booting against an un-migrated or half-migrated DB: refuse, or serve wrong answers?

## Failure timelines
For any operation with an external or non-transactional side effect, write the real step order:
1 resolve authoritative input, 2 claim the work, 3 acquire lock or lease, 4 revalidate before the side effect, 5 external write, 6 confirm the write, 7 record completion, 8 retry or reconcile.

Walk every gap between consecutive steps: **crash here leaves what, and what cleans it up?** Check specifically: lease lost or expired mid-work (steps 3 to 7: does work continue anyway?); cancellation and lock timeout (is the side effect already committed?); duplicate completion (is step 7 idempotent under retry?); crash between two stores (external write done, completion unrecorded); input changed during work (is step 4 present at all, or was validity assumed from step 1?); partial batches (does one bad item abort, skip or corrupt the rest?); process restart (in-flight work reclaimed or orphaned?); shared object aliases (two call sites mutating one instance).

A missing step 4 (revalidate immediately before the side effect) is the most common defect this audit finds.

## Third-party and deployment
- Is the **installed, locked** version the one whose behaviour you rely on? Check the lockfile and the actual installed version, not the docs.
- Does the call shape match that version's real API, not the latest docs or the version the model remembers?
- Expected deprecation warnings present, or newly appearing?
- Packaging constraints: wheels, ABI, CPU and arch, container base, image size, offline or air-gapped install.
- Runtime downloads: does it fetch anything at run time; what happens when the fetch fails or is blocked?
- Cleanup on failure: partial images, temp dirs, half-written files.
- Operational thresholds: measured, with the command that measured them, never asserted from documentation.

## Authority and security boundaries (authn, authz, trust transitions, tenant or visibility rules)
- Enforced at a layer every writer and reader passes through, not only the path this feature uses?
- Tested in a non-default state (a permission check tested only as admin proves nothing)? Mutation-check it: break the guard, watch the test fail on its assertion, restore.
- Can any cached, indexed or session-held copy of a permission outlive the change that revoked it?
- Where does untrusted text (issues, fetched pages, prior handoffs, user content) cross into a command, a query, a prompt or a plan?

## A seam between components (one side can change without the other)
- Is there a contract test or parity test across the seam, running the path production runs?
- Which side is authoritative on disagreement, and is that written down where both sides read it?
- What does each side do when the other is absent, old, or newer than expected?
