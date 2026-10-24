<!-- Full detail for this skill. ../SKILL.md is binding where the two differ (S/M/L sizing, rigor, docs/plans/active/, docs/decisions/, terse). -->

## The shape

Two fenced blocks, run in order, with one line before them saying so (AW-28).

**The command is one short line, never the brief.** In Claude Code, a long or multi-line paste
collapses into a placeholder, the input no longer starts with `/compact`, and it goes to the model
as an ordinary prompt: nothing is compacted, and nothing says so. So the command stays a single
line of a sentence or two, and the brief travels as the first message after the compaction, where
it lands verbatim instead of being summarised a second time. The same two steps work in a harness
whose compact command takes no text: run it bare, then paste the brief.

```text
/compact Keep the workflow stage, the files in play, and every correction the owner gave on how to work. A resume brief follows as the next message.
```

The brief is a sketch, not a template; use the labels that fit and drop the ones that are empty:

```text
RESUME BRIEF (pasted after a compaction)
Stack: [goal] > [level] > [here]. Still owed: [per level].
Next: [skill and argument], then [what follows].
Files: decision doc [path]; plan [path]; amendments [IDs].
Rulings (verbatim): "[ruling]" ([what it governs]).
Open asks: [question].
From the chat, [who said it], claims not verified: [handoff and sign-off items].
How to work with the owner: "[their words]"; [corrections they repeated].
[Anything else the next step needs.]
Before acting: re-read the plan and decision doc from disk, and load each skill and reference again when a step needs it; what was loaded before the compaction is gone or cut short. Where sources disagree, the files on disk win, then this brief, then the compaction summary. Runs listed here are claims; /verify runs the full suite fresh.
State the next step in one line and wait for the owner's go.
```
