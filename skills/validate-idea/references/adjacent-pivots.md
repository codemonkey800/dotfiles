# Adjacent pivots

Read this whenever SKILL.md Stage 9 fires — that is, on a **Kill** or a **Narrow and
retest**. Never consulted on a Pursue.

The four governing rules are in SKILL.md and are not repeated here: clear the binding
constraint, ground every lead in an artifact, clear the Stage 1 gate on its face, never
rank a lead against the validated idea. This file is the lookup material — where leads
come from, which moves are available, and what disqualifies one.

## Harvest map

Work this table top to bottom against the material already in context. Nothing here
requires a new search; every row points at an artifact Stages 2-5 already produced.

| Artifact | What to look for | Feeds axis |
|---|---|---|
| `competitor-scan` — 2-3★ review clusters | A grievance repeated across reviewers that the original idea never addressed | Unbundle a complaint |
| `competitor-scan` — supported-industry and integration lists | Segments named as unsupported, or conspicuously missing from a long list | Narrow the vertical |
| `competitor-scan` — dead products and post-mortems | Why it died, and whether the underlying need outlived the product | Any — post-mortems name real constraints better than live products do |
| `demand-signal-scan` — Upwork / Fiverr gigs | Adjacent tasks people already pay a human to do, with rates | Productize the workaround |
| `demand-signal-scan` — templates with visible sales | What the template actually does. It is usually narrower than the idea, and the narrow thing is the one selling | Productize the workaround |
| `demand-signal-scan` — Show HN comment threads | The "I'd want this for X instead" critique. Commenters routinely hand you a better-shaped adjacent product | Same pain, different audience |
| `distribution-scan` — communities with counts and promo policy | A venue that is unusually reachable *and* tolerates promotion. A channel in hand is worth pivoting toward | Same audience, different pain |
| `distribution-scan` — role headcount | A neighbouring role with more headcount, more budget, or a tighter venue | Same pain, different audience |
| Stage 4 Reddit threads | Recurring pains in the sub that had nothing to do with your query. The strongest source here, and the one most easily discarded with the file | Same audience, different pain · Shift along the workflow |
| Stage 5 "Do nothing" / spreadsheet row | The specific narrow job the spreadsheet does well, and the one step around it that it cannot do | Shift along the workflow |

The Reddit row deserves particular attention. Wave A brand probes return threads where
the brand is discussed among a sub's other preoccupations, and those other preoccupations
are demand signal that cost nothing extra to collect. Read the triage output once more
with the original query set aside before discarding the files.

## Axis catalogue

Seven moves from a dead idea to a neighbouring one. The trap column is the part that
matters — each axis has a characteristic way of producing a lead that dies exactly like
its parent.

| Axis | The move | Constraints it can clear | The trap |
|---|---|---|---|
| Narrow the vertical | Same problem, one trade or segment the incumbents explicitly do not serve | No wedge · race-to-bottom pricing | A segment every incumbent skipped was usually skipped for a reason, and the reason is normally that it is both small and broke |
| Shift along the workflow | Target the step immediately before or after the one you aimed at, where the pain actually concentrates | No wedge · AI commoditization | The adjacent step is frequently owned by a larger incumbent than the one you were already losing to |
| Same audience, different pain | Keep the reachable community, swap the problem | No wedge · no demand evidence · incumbent absorption | Willingness to pay travels with the audience. If they were broke for idea one, they are broke for idea two |
| Same pain, different audience | Keep the problem, move to a segment with budget or a tighter venue | Unreachable audience · WTP mismatch | The pain is often pain precisely *because* the audience is broke. Confirm the wealthier segment genuinely has it before believing the lead |
| Productize the workaround | Sell the thing they already hire a freelancer for or buy as a template | No demand evidence · WTP mismatch | If every gig in the listing has bespoke requirements, software does not replace the freelancer — it competes with them badly |
| Unbundle a complaint | Take one recurring incumbent failure and make it the entire product | No wedge · crowded market | A complaint the incumbent can close in one sprint is a feature request wearing a product costume |
| Service before software | Same problem, delivered done-for-you at service pricing | Market too thin for SaaS volume · chicken-and-egg · accuracy bar too high to automate | This is not SaaS. Say so in the lead — it trades scale for cashflow, and the user should take that trade knowingly rather than discover it in month four |

## Disqualifiers

Drop a lead, without mentioning it, when any of these hold:

| Disqualifier | Why |
|---|---|
| It does not clear the Stage 8 binding constraint | The same death, delayed. This is the single most common failure |
| No artifact stands behind it | Then it is an idea you generated, and `/validate-idea` is not an ideation skill |
| It fails the Stage 1 gate on its face | No nameable role, or nowhere that role gathers. It would die in the first minute of its own run |
| The user already submitted it in this run and it died | Check the sibling set before rendering |
| It is a feature of the original, not a product with its own buyer | If the buyer is the same person buying the same thing, nothing moved |
| It is the original with a renamed ICP | Renaming "small businesses" to "SMB owners" is not a pivot |

Three qualifying leads is a good outcome. One is a normal outcome. Zero is a legitimate
outcome, and padding to three with speculation destroys the only thing that makes this
section worth reading.

## When the idea died at Stage 1

No research ran, so there are no artifacts and there can be no leads. Offer at most two
reframings from the axis catalogue, phrased as questions and marked as unresearched:

```
No research ran on this, so these are reframings rather than leads:
- Narrow the vertical: is there one trade inside "small businesses" where this
  is acute enough to name?
- Same pain, different audience: who currently pays someone to do this by hand?
```

Never format these as leads. They have no artifact, no constraint analysis, and no
cheapest-check — the three things that separate a lead from a guess.

## Multiple ideas

Harvest **once across the pooled artifacts**, not per dead idea. The same lead surfacing
under three kills is one lead, not three, and rendering it three times reads as a
recommendation the evidence does not support.

Render the pooled leads after the comparison table, not inside any single idea's report.
And run the sibling check hard here: proposing idea B as an adjacent lead for idea A when
B was killed four paragraphs earlier is the failure mode this section invites.

## Worked example

**Illustrative only — figures below are stand-ins for the shape of a lead, not findings.**

From the recipe-extraction run. Verdict was Kill; binding constraint was *no wedge in a
category with 25-35+ live competitors*. So every lead has to get out of that category or
out of that saturation — a better recipe importer clears neither.

```
### 11. Adjacent leads

**Batch-cook grocery reconciliation** — for meal-preppers cooking 5+ batch meals a
week who overbuy and throw food out.
- Clears: no wedge in a crowded category. This is a different category — the
  competitor set found was recipe capture, and nothing in it costed a shopping
  list against what is already in the kitchen.
- Artifact: r/MealPrepSunday thread <date>, surfaced incidentally during the
  `recime` brand probe — <N> comments describing the same overbuying problem
  with no tool named.
- Cheapest check: one post in that sub describing the problem, no product
  mentioned. Pass if replies describe the pain unprompted; kill on "just use a
  list app".

**Done-for-you weekly meal plans for a named diet** — the plan, not the software.
- Clears: no wedge. Competes on curation and taste rather than on features, which
  is where 25+ feature-competitors cannot follow.
- Artifact: Gumroad meal-plan templates at $<P> with <N> visible sales, from the
  demand-signal scan — revealed spend on exactly this output.
- Cheapest check: sell one week's plan to strangers at $<P> before writing
  anything. Pass if any stranger pays.

Unvalidated — each is a candidate for its own `/validate-idea` run, not a
recommendation.
```

And the lead that should have been dropped:

> **A recipe app with better video OCR** — fails on the binding constraint. Same
> category, same 25-35 competitors, and "better extraction" was the original idea's
> wedge claim, which the research already found was claimed by several incumbents.
> No artifact supports it either; it is the parent idea with an adjective.
