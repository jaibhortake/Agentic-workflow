# Driving another agent CLI (principles for every tool)

Not a skill; no skill loads or runs these commands. It applies to any headless-capable coding CLI (Cursor agent, Codex, Gemini or Antigravity CLI, a Claude CLI process). Check your tool's own docs for exact flags; they change faster than this page.

## Principles that hold for every tool
1. **Launch with the plan path only.** The prompt is: `/build-model <plan path>` (or the equivalent instruction: build every phase of the plan, review it, emit the build handoff, stop). The plan is the contract; don't add instructions that contradict it.
2. **Install the workflow skills in the build tool's environment** (they're plain `SKILL.md` files) and commit the plan first so a reviewer can read committed code.
3. **Give it a clean worktree.** A shared tree lets `git add -A` sweep another session's work into the build's commit. One git worktree per build.
4. **Run it in the background with its own result file;** a long build writes its result only when it ends. Don't detach with `nohup` or `&` in a way that loses the result. Use bounded wait loops (`timeout 590 bash -c 'while pgrep -f "<tool> exec" >/dev/null; do sleep 20; done'`) and read the exit code from the file, never from a pipeline.
5. **Permissions:** the tool acts with your account's permissions while you're away. Commit everything first, cap spend if the tool supports a budget flag, and disallow destructive git (`push`, `reset`, `checkout`, `stash`, `rebase`, `clean`) outright. An allowlist too narrow to let it `cd`, `sleep` or redirect makes it stop and ask, which is the right behaviour; widen deliberately, don't switch to "allow everything" casually.
6. **Batch a long plan** across runs by phase ranges; every batch begins with "re-read the plan from disk" (a resumed thread remembers the version it discussed).
7. **To change instructions mid-run,** stop it by exact process id, write a short resume prompt, relaunch with the tool's resume flag and the same options.

## What to check when it returns (the driver's checklist; levels 5 and 6 in `docs/review-levels.md`)
- Read the diff and every new test; look for hollow tests (fixture too small, assertion true in every mode, "exits 0", copy-of-the-code tested).
- Re-run the mutations the plan names yourself. A builder's "witnessed" is a claim.
- Check it touched only the files the plan names and committed by path.
- Read its handoff: halts, deviations, unproven criteria, concerns. A halt is the fence working; resolve it in the plan (amend, log), not in chat.
- Expect rework to be common on long builds; each rework is a defect caught, but better briefs prevent them.

## Failure modes worth guarding against
- **Silent workaround:** the builder routes around a plan gap inside named files and everything passes. Counter: plan review first, the standing instruction, and a reviewer who reads the diff against the decision doc.
- **Mocked seam:** a unit test substituted for the named no-mock seam test.
- **Wide-word narrow run:** a scoped run reported as "all tests pass". Counter: rungs recorded in the handoff.
- **Result lost to a refused command:** a headless run can stop on a refused command and still report success with an empty answer; check a result exists before trusting it.

Where the tool differs (command names, sandbox flags, budget caps), trust its own docs over this page, and record what worked in `docs/lessons.md`.
