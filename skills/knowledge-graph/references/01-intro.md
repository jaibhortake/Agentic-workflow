<!-- Ported from nikhilw/structured-agentic-workflow skills/knowledge-graph/SKILL.md (MIT), adapted to this repo's names and paths. This is the full explanation; ../SKILL.md is binding where the two differ (S/M/L sizing, rigor, docs/plans/active/, docs/decisions/, terse). -->

# Knowledge Graph

This file holds one definition the rest of the workflow depends on and must never restate: **what a
[graphify](https://github.com/Graphify-Labs/graphify) answer is worth, and what it is not worth.**

It is not a step. Reading this satisfies no gate. The gate you are standing in decides *what* to ask
the graph; this decides how much weight the answer can carry.

**Load this before your first query, not after.** The limits below are what stop a graph answer
being mistaken for proof, and one of them is a security rule.
