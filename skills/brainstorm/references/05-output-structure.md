<!-- Full detail for this skill. ../SKILL.md is binding where the two differ (S/M/L sizing, rigor, docs/plans/active/, docs/decisions/, terse). -->

## Output Structure

### 1. Problem Understanding
Restate the problem in your own words. Identify the core need vs. nice-to-haves.

### 2. Current State Analysis

What exists today? What code, patterns, or infrastructure is already in place that this work touches?

**This section is gated by `/existing-mechanisms`.** Load it, answer all eight of its questions, and
record the answers in its ledger shape. Do not move on to approaches until the ledger is filled in.

That gate is here because this is the section the rest of the brainstorm rests on, and it is the
one that gets skimmed. The questions look like bookkeeping and they find something almost every
time: a mechanism that already does this under a name nobody searched for, a caller nobody
enumerated, a subsystem a proposal would leave unreachable, a second pathway added where the codebase
already had one. Every one of those is cheap to find now and expensive to find during build.

Three of the eight carry more weight than the rest at this stage, so do not let them collapse into
a yes:

- **Question 1, which here means the whole impact trace.** Read that section of
  `/existing-mechanisms` and run all three of its axes, not just the call graph. Binding summary,
  so nothing is lost if you never open it: **structural**, every caller and their callers out to a
  named boundary plus every callee, including the inbound edges that never spell the name
  (fixtures, DI registrations, route tables, subscriptions, config keys, anything dispatched by
  string), and the dependency directions both ways; **functional**, every end-to-end flow this
  could alter and every flow it depends on, plus the invariants and ordering that couple this to
  code with no edge to it; **consolidation**, what this leaves unused, whether it builds a parallel
  system beside one that exists, whether it abandons something without anyone deciding to, and
  whether it increases reuse or adds another flow. Query the graph to find where to look on the
  structural axis, and in typed code count with the type checker or language server, since the
  graph matches names, not types; the other two axes are found by reading and by asking what else
  believes this.

  **An approach costed against a third of its blast radius is costed wrong**, and at this stage
  that is not a file list that comes out short, it is the wrong approach winning. That is the
  expensive version of this mistake: a plan with a missing caller costs a halt, a brainstorm with a
  missing blast radius costs the whole design.
- **Question 4, relationship to the incumbent.** "Compete" is not a design. If two mechanisms would
  end up doing one job, the work is not designed yet, whichever one is better.
- **Question 6, build on what exists.** State the extend-the-incumbent version of this change even
  when you will not recommend it. It becomes one of the approaches in §4, and it is frequently the
  one that wins once its cost is written next to the alternatives.

### 3. Contracts & Constraints

Bad recommendations rarely come from bad trade-off analysis. They come from a contract nobody wrote down; an ownership rule, a uniqueness assumption, a consumer you didn't know existed. Surface them *before* proposing approaches, because a contract discovered later invalidates the comparison, not just one option.

Answer each line for the data or behavior in play. Where you don't know, write **unknown**: then either probe for it (BS-8) or promote it to an Open Question. An unanswered line is a risk the recommendation is carrying silently.

- **Authority:** What is the source of truth here? If two places hold this, which one wins when they disagree; and who decided that?
- **Identity & cardinality:** What identifies one of these? One-to-one, one-to-many, many-to-many? Can duplicates exist, and is the identifier stable over time?
- **Currentness:** How does a reader know what it got is current; version, generation, timestamp, ETag, or nothing at all? What is the staleness window, and can the feature tolerate it?
- **Lifecycle:** What states does this move through (created → active → superseded → deleted)? Who moves it, and can it move backwards?
- **Consumers & surface authority:** Who reads this today, and which surface is authoritative *for them*? Changing a producer without enumerating its consumers is the standard way contracts break.
- **Environment constraints:** What does the runtime forbid regardless of how good the design is; offline operation, read-only filesystem, single writer, air-gapped deployment, platform or resource limits?

Skip a line only when it genuinely does not apply, and say that you're skipping it. Silent omission reads identically to "answered" in the decision document.

### 4. Proposed Approaches

You MUST cover the whole spectrum; don't just propose variations of the same idea:

- **At least one minimal approach:** What is the smallest, simplest change that solves the core problem? Could this be a 10-line fix instead of a new module?
- **At least one structural/ambitious approach:** a broader restructuring of what exists today. Even if it requires wide changes, name it; the user decides whether the scope is worth it.
- **Always the ideal-then-adjusted derivation**, written last and described below. It is where "what would we build from scratch?" is answered properly, so do not spend the structural approach on that question.

For each approach:
- **Name:** A short descriptive name
- **How it works:** 2-3 sentence summary
- **Pros:** What makes this attractive
- **Cons:** What are the risks or costs
- **Complexity:** Low / Medium / High
- **Scope of change:** How many files/modules touched? Is this localized or cross-cutting?
- **Impact estimate:** The blast radius, from `/existing-mechanisms`' **impact trace** run at survey depth against *this* approach. Not a paragraph of adjectives: **structural**, how many call sites and in which modules, counted rather than characterised, and what the approach makes depend on what; **functional**, which end-to-end flows it changes and which it depends on; **consolidation**, what it leaves unused, whether it adds a pathway beside an existing one or collapses two into one, and what it lets you delete. Survey depth means enough to compare approaches honestly, not every `file:line`: the winner gets the exhaustive trace in the Decision Audit. Two approaches that look equally costly on file count routinely differ by an order of magnitude here, and this line is the only place that shows up before the decision is made.
- **Through the lenses, at survey depth** (`/review-lenses`), written only where they tell the approaches apart; a lens that would say the same of every approach gets no line: **what the user sees**, the one or two sentences a user would say about this approach's result; **business sense**, anything a typical user of this domain would find odd, and who; **logic**, the main case and its nearest edge walked with real values, plus any values or rules this approach sets against each other; **removal**, what it deletes or stops doing, and what does that job afterwards. An approach that wins on blast radius and loses here is a different trade than the one you thought you were comparing.
- **Milestone impact:** Does this invalidate or rework something already shipped, and does it constrain something already planned? Name the earlier milestone it disturbs and the later one it boxes in. An approach that quietly forces a redo of last month's work; or paints the next feature into a corner; is more expensive than its file count suggests.

#### The last approach: ideal, then adjusted

After the others are written, derive one more. It is **mandatory**, it is always the last one, and
it is not a variation of anything above it. Letter it after the others and always title it
"(ideal, then adjusted)"; with the usual four approaches that makes it E, which is what people call
it.

Derive it in two movements, and keep them separate on the page:

1. **The ideal.** What is the right design for this problem *in this project's perspective*: its
   domain, its language, its conventions, its constraints of purpose? Not a textbook design and not
   a different product; the design this team would land on if this part of the codebase were being
   written today, with everything now known and nothing yet committed. Write it as a design, not as
   a wish.
2. **The adjustments.** Now walk it into the codebase that exists. Each place the ideal collides
   with a decision already made becomes one **adjustment**, recorded as its own line: what the
   ideal wanted, what already exists that prevents it, the concession made, and what that
   concession costs. An adjustment is a deliberate concession to history, and it is not a place
   where the ideal was quietly abandoned.

```markdown
**E. [name] (ideal, then adjusted)**
- **Ideal design:** [the design this problem deserves in this project, stated plainly]
- **Adjustments:**
  | # | Ideal wanted | Existing decision in the way | Concession | Cost of the concession |
  |---|---|---|---|---|
  | 1 | ... | ... | ... | ... |
- **Resulting design:** [the ideal plus every adjustment, as one coherent design]
- **Distance from ideal:** [what the concessions cost in total, in one sentence]
- **What would close the gap later:** [the change that would let an adjustment be reversed, or "none"]
```

Then give it the same Pros / Cons / Complexity / Scope / Impact / Milestone impact treatment as the
others, so it can be compared rather than admired.

**Why this is worth the extra work.** Approaches derived from the current code inherit its
constraints silently, so what comes out is a patch that fits. Starting from the ideal and adjusting
*names* every constraint on the way in, which does three things nothing else in this skill does: it
produces a design rather than a fix, it makes visible which existing decisions are actually costing
you, and it leaves behind the "what would close the gap later" line that turns today's concession
into tomorrow's tractable work.

Two failure modes to avoid. The ideal is not a rewrite proposal; if every adjustment turns out to
be "rewrite the surrounding module", you have described a different project, not an ideal for this
one. And an adjustment is not a rejection; writing "the ideal wanted an event bus, the codebase has
direct calls, so use direct calls" is a legitimate adjustment, while quietly reverting to the
obvious approach and calling it adjusted is not.

**If the resulting design turns out to be one of the approaches above, say so and stop there.** On a
small or well-shaped problem the ideal survives contact with the codebase almost intact, and lands
on something already on the list. That is a real result and it is worth writing down in one line:
"the ideal, adjusted, is Approach B". Do not manufacture a fifth option to fill the slot; the
derivation earned its place by being run, not by producing a different answer.

**Compare them fairly.** The comparison decides the architecture, so a rigged one is worse than no analysis at all. Three ways it gets rigged without anyone intending to:

- **Don't charge an approach for work it doesn't require.** Costs belong to the approach that actually incurs them. If the migration, the backfill, or the rewrite is only needed under Approach B, it does not appear under Approach A "for symmetry"; and B's cost never gets quietly spread across the others to make the gap look smaller.
- **A shared interface is not a shared implementation.** "These should look like one API to the caller" does not imply one table, one file, one service, or one process. Separate the logical goal from the physical consolidation and price them separately; the consolidation is usually where the risk actually lives, and it is usually optional.
- **Don't move something for a consumer that doesn't exist.** Restructuring now for a hypothetical second caller is a cost paid today against a benefit that may never arrive. If the second consumer is speculative, label it speculative and let the user decide whether to buy the option.

#### When an approach changes a rule: the scenario table

An approach that changes *when* something happens cannot be described in prose without leaving
something out. "It will still suggest for a fresh project, and it won't suggest while targets are
pending" is a claim about two cases out of a number the sentence never states. Build the table
instead (BS-13).

**One table, not one per approach.** The cases are a property of the rule, not of any proposal
about it, so they are enumerated once and every approach that moves the rule gets a column beside
today's. That is also what makes the approaches comparable here rather than merely described: two
proposals that sound equally targeted turn out to move three rows and nine.

**1 · Get the cases from the state, not from your imagination.** Name the variables the rule
actually reads; counts, flags, statuses, presence and absence; and enumerate their combinations,
including the empty one, the all-of-them one, and the mixed ones. A case list you brainstormed is a
list of the cases you could think of, which is the failure prose already had. Where the full
cross-product is too large, collapse it deliberately and say on what grounds: "status has five
values, three behave identically here, so they are one row". A collapse you can justify is method;
one you cannot is the imagination failure wearing a table.

**2 · Today's column first, and read it out of the code.** It is derived case by case from the
current implementation, never recalled; and it is the column that finds things, because filling it
in is usually the first time anyone has stated today's behaviour case by case. Then one column per
approach that moves this rule. Name what the outcome means above the table ("True = will suggest");
a boolean with no legend is unreadable within a week.

**3 · The rows where a column differs from today are that approach's change.** That is the entire
proposal, as a finite set rather than an argument, and each differing row gets a label:

- **the fix**: the row the user actually asked about;
- **collateral**: a row that moves because the new rule is wider or narrower than the ask, and
  which nobody has agreed to. These are why the table is worth building: they are invisible to
  prose, because prose only visits the rows that occurred to someone.

**The rows that do not differ are evidence, not filler.** A rule that moves three rows of twelve is
a small change with a provable radius; one that moves nine is a different feature, and that count is
the first honest thing anyone has said about its size.

**4 · Then ask what each new rule exposes.** A rule is not only its outcomes. Some rows it leaves
unchanged are now reached by a different route, and some that were unreachable before are reachable
now. Walk those, per approach, and say whether they bite.

```
True = will suggest          (excerpt of a twelve-case table)

case                                        active  wdrawn   TODAY       A       B
1   empty, nothing ever added                    0       0    True    True    True
2   2 pending user targets                       2       0    True   False   False   <- the fix
3   2 pending suggested targets                  2       0   False   False   False
11  1 active user + 1 withdrawn researched       1       1    True   False    True   <- A: collateral
12  all researched, all removed                  0       2    True    True   False   <- B: collateral
```

Two approaches, both of which fix case 2, and the table is the first place their difference is
visible: A also moves case 11, B also moves case 12, and neither was asked for.

**Keep it readable at a glance.** Fixed-width columns, one row per case, booleans or short verdicts
rather than sentences, changed rows marked in the margin. The shape is the point: a reader should
see the diff without reading the table.

**Writing it is not building it (BS-1).** The table is a thinking instrument; it settles what the
change *is* before anyone argues about whether to make it. It does carry forward, and usefully: the
differing rows are exactly the cases the plan owes test criteria for, and `/write-plan` lifts them
straight out. That is a downstream convenience, not the reason to write it.

### 5. Challenge the Obvious Solution

Before making your recommendation, ask yourself:
- **How far is your pick from the ideal in approach E?** You have already written the ideal and the adjustments; now say plainly whether the recommendation is the resulting design, or something further away, and what the extra distance buys.
- **Are we solving the right problem?** Or are we patching a symptom of a deeper structural issue?
- **Is there an approach that makes the problem disappear entirely** instead of managing its complexity? (Different data model, removing a feature, changing an interface)

### 6. Recommendation
Which approach do you recommend and why? What would change your recommendation?

### 7. Open Questions
What do you need the human to clarify before planning begins?
