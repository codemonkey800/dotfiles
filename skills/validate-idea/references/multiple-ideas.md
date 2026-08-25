# Multiple ideas

Read this when the input contains more than one idea. Single-idea runs never need it.

## Procedure

Branch at the **end of Stage 1**. Framing is cheap, and it is where the kill gate lives —
running it for everything before spending any research budget is what keeps a five-idea
request affordable.

1. **Run Stage 1 for every idea.** Any idea failing the cheap kill gate — no nameable
   role, or no reachable venue — dies there with its reason and consumes zero research
   budget. Report these kills up front rather than burying them.
2. **Hard-cap survivors at 3.** With more, present the framings and ask which three to
   take forward. The cap is a technical constraint rather than a preference: reddit-fetch
   is a serial mutex, so five ideas at five invocations each is roughly 13 minutes of
   blocking with nothing on screen.
3. **Run Stages 2-8 per survivor, sequentially** — research through verdict, stopping
   short of Stage 9 — with the Reddit budget reduced from 8 to 4-5 invocations each.
   Three ideas is about 14 invocations, roughly 8 minutes.
4. **Render each full report in sequence, then the comparison table.**
5. **Harvest adjacent leads once, at the end**, if any idea killed or narrowed — see
   `## Adjacent leads` below.

Never spawn per-idea sub-agents. Two independent reasons: the reddit-fetch mutex, and
verdict consistency — verdicts produced in separate contexts are not comparable, which
destroys the entire point of running ideas through one framework.

## Comparison table

Every column is an observable fact, a cited quote, a labeled model output, or a
categorical verdict. **No synthetic scores, and no total column.** A 1-10 rubric hides
the reasoning that makes ideas comparable and invents precision that the evidence does
not support.

```
| Idea | ICP | Strongest evidence | Competitors | Wedge | 12-mo MRR | #1 channel | MVP | Verdict | Binding constraint |
```

| Column | Content |
|---|---|
| Idea | Short label, not the full restatement |
| ICP | The nameable role from Stage 1 |
| Strongest evidence | One cited signal with its date — the best single thing found |
| Competitors | Count, plus whether the market reads crowded / thin / empty |
| Wedge | The angle in a few words, or "none found" |
| 12-mo MRR | The Stage 6 figure with its `[measured]` / `[proxy]` / `[assumed]` label |
| #1 channel | The named channel, never a category |
| MVP | Time-to-sellable estimate |
| Verdict | Pursue / Narrow / Kill |
| Binding constraint | The single thing that must be true or the idea dies |

`Binding constraint` is the load-bearing column. Two ideas rarely share one, and naming
each idea's distinct point of failure is what makes them genuinely comparable without a
rubric — it converts "which scores higher" into "which bet do you believe."

## Ranking

Ranking is carried by row order plus one line of prose per adjacent pair, rendered
directly beneath the table:

```
Ranked B > A because A's only realistic channel is the same saturated
recommendation-thread channel B already has a foothold in.

Ranked A > C because C has no wedge — every gap found is already claimed by
two or more incumbents.
```

One line per adjacent pair, not a paragraph about the whole set. Each ordering claim
should be individually arguable, which is precisely what a numeric score is not.

When two ideas are genuinely tied on the evidence, say so and name the discriminator
rather than manufacturing separation:

```
A and B are tied on current evidence. The discriminator is whether solo
bookkeepers pay for tooling out of pocket or expense it to the firm — go find
that out before choosing.
```

An honest tie with a named next question is more useful than a fabricated ordering. It
tells the user what to go learn, which is the actual deliverable.

## Adjacent leads

Stage 9 fires once for the whole run, not once per dead idea. **Omit section 11 from the
individual reports**, pool the artifacts across every idea researched, harvest up to 3
leads total, and render them once after the comparison table and its ranking lines.
Mechanics are in `references/adjacent-pivots.md`.

Two rules specific to multi-idea runs:

- **Check the sibling set before rendering.** Proposing idea B as an adjacent lead for
  idea A, when B was killed earlier in the same report, is the failure this section
  invites. Anything the user already submitted is disqualified.
- **A lead surfacing under three dead ideas is still one lead.** Repeating it per idea
  reads as a recommendation, and Stage 9 explicitly does not make recommendations.

When every idea in the set dies, say that plainly first — a pooled lead list does not
soften a clean sweep, and presenting it as a silver lining misreads the evidence.
