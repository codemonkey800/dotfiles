---
name: validate-idea
description: |
  Research and validate a micro-SaaS / indie-hacker product idea with the skepticism of
  someone who has watched most of them fail. Bootstrapped framing — optimizes for "can
  1-2 people run this to $10-30K MRR," not VC scale. Use when the user says "validate
  this idea", "is this worth building", "research this SaaS idea", "poke holes in this",
  pitches a side-project, or types /validate-idea. Accepts one idea or several at once, a
  sentence to a paragraph each, plus any audience or context they have. Pulls real demand
  signal from Reddit via ~/dev/reddit-fetch (web search does not surface Reddit threads),
  mines competitor reviews and app directories, then returns a nameable ICP, a competitor
  table, the wedge or "none found", a 12-month MRR model built on a named channel, the
  cheapest next tests with pass/kill thresholds, and a blunt Pursue / Narrow / Kill
  verdict. On a Kill or Narrow it also returns up to 3 adjacent leads — nearby ideas in
  the same niche or industry, harvested from the research already run, each one clearing
  the specific constraint that killed the original. Plus a ranked comparison when given
  multiple ideas. NOT for generating new ideas from scratch (use /ce-ideate) or exploring
  how to build something already committed to (use /ce-brainstorm).
user-invocable: true
argument-hint: "<idea> — e.g. 'invoicing for solo bookkeepers'; multiple ideas OK; prefix quick: or deep:"
---

# Validate Idea

Research and validate a micro-SaaS idea at bootstrapped scale. The bar is "can 1-2 people
run this to $10-30K MRR," not "can this be a unicorn." Runs a ten-stage pipeline —
framing, parallel web research, Reddit demand mining, synthesis, MRR modelling,
validation design — and ends in a blunt Pursue / Narrow and retest / Kill verdict. A Kill
or Narrow carries one thing further: up to three adjacent leads in the same niche, pulled
out of the research already run rather than invented after it.

Three guarantees shape every stage. Every claim names a source. Every number in the MRR
model carries a `[measured]` / `[proxy]` / `[assumed]` label, so a guess can never
masquerade as evidence. And the verdict leads the report rather than hiding behind eight
sections of research — if the idea is weak, that is the first thing on screen.

Chat-only. This skill writes no report files and does not read or write memory. The one
exception is scratch JSON under `/tmp/validate-idea/`, which exists purely to keep large
Reddit payloads out of the context window.

## When to use

- The user brings an idea — a sentence or a paragraph — and wants it pressure-tested.
- The user is comparing several candidate ideas and needs them judged on the same terms.
- The user asks "is this worth building", "will anyone pay for this", "poke holes in this".
- When the user types `/validate-idea`, with or without arguments.

Route away when:

- The user wants *new* ideas generated → `/ce-ideate`.
- The user has already committed to building something and wants to explore how →
  `/ce-brainstorm`.

## Operating principles

These shape every judgment in every stage. When a stage's guidance and a principle
conflict, the principle wins.

- **Optimize for "can 1-2 people run this to $10-30K MRR,"** not for market size.
- **Evidence of existing spend beats stated interest.** Someone already paying for a
  spreadsheet, a worse competitor, or a freelancer doing it manually is a far stronger
  signal than fifty people saying "I'd use that." Hunt for revealed preference.
- **A crowded market with visible competitors making money is a GOOD sign.** No
  competitors usually means no market, not open opportunity. Treat an empty landscape as
  a red flag and go find out why nobody is there.
- **Distribution is the bottleneck, not the product.** Pressure-test how the user reaches
  the first 100 customers before validating anything else.
- **Boring, narrow, unsexy niches win.** Vertical tools for one trade, workflow glue,
  internal tools disguised as products — these beat broad "for everyone" tools.
- **Be blunt.** If the idea is weak, say so early and say exactly why. Do not soften it,
  do not pad it with encouragement, do not bury the verdict in caveats.

## Prompt interpretation

`<idea_input> #$ARGUMENTS </idea_input>`

Parse the input into idea count, stated ICP, depth mode, and pre-supplied context.

| User input | Resolution |
|---|---|
| One idea, any length | Standard single-idea run. Full budget |
| Several ideas (numbered, bulleted, or "or") | Multi-idea run — see `## Multiple ideas` |
| Idea + a stated audience | Use their audience as the Stage 1 starting point, then narrow it further if it is not yet a nameable role |
| Idea with no audience | Derive candidate audiences in Stage 1 and pick the narrowest defensible one |
| Idea that names a competitor ("a cheaper Calendly for X") | The named competitor is a free rare token — seed it directly into the Stage 3 brand probes |
| Prefixed `quick:` | Skip Reddit entirely. Web-only, ~90s. Note the missing demand evidence in the coverage footer |
| Prefixed `deep:` | Raise the Reddit cap from 8 to 12 invocations |
| Too vague to name a user ("an AI app for productivity") | Do not research it. Ask one narrowing question and stop — see the Stage 1 kill gate |
| Blank | Ask for an idea. Do not invent one |

Announce the plan and budget before running, so the user can shrink it:

```
Validating: <one-line restatement>
Plan: 3 web agents in parallel → ~<N> Reddit invocations (~<M> min) → report.
Say "quick:" to skip Reddit, or interrupt any time.
```

## Stage 1: Frame the idea and ICP

Restate the problem in the user's own terms, then force the audience down to a **nameable
role**. This is the single highest-leverage stage — a vague ICP makes every later stage
vague, and the MRR model becomes unfalsifiable.

| Too broad | Narrowing question | Nameable ICP |
|---|---|---|
| "Small businesses" | Which trade? How many staff? Who touches the tool daily? | "Solo bookkeepers filing for 20-40 clients" |
| "Content creators" | Which platform, what volume, monetized how? | "YouTubers at 10-100K subs who edit their own footage" |
| "Developers" | Which stack, at what company size, solving what? | "Solo Rails devs shipping client work on Heroku" |
| "Anyone who cooks" | What forces the pain? How often? | "Meal-preppers cooking 5+ batch meals weekly" |

**Cheap kill gate — stop here and spend no research budget when either holds:**

1. The audience cannot be narrowed to a nameable role after one clarifying exchange.
2. The audience has no place it congregates that the user could plausibly reach — no
   subreddit, no trade association, no directory, no newsletter, no conference.

Gate 2 is the one people skip. An audience that cannot be reached is not a market, no
matter how real the pain. Say so directly and stop; do not run research to be polite.

Output of this stage: a one-paragraph problem statement, a nameable ICP, and a first
guess at where they congregate. Carry all three forward.

## Stage 2: Parallel web research

Spawn three agents in a **single message** so they run concurrently. Use the `Agent` tool
with `subagent_type: general-purpose`. Prompt templates and their `{placeholder}`
substitutions live in `references/research-agent-prompts.md`.

| Agent | Purpose |
|---|---|
| `competitor-scan` | 5-10 direct and adjacent alternatives with pricing, scale signals, and specific complaints from 2-3 star reviews. **Its highest-value output is the list of exact product names** — those become Stage 3's rare tokens |
| `demand-signal-scan` | Non-Reddit evidence of existing *spend*: paid spreadsheet templates, freelancer gigs for the manual task, HN Show HN launches, public revenue disclosures, search-volume proxies |
| `distribution-scan` | Named communities with member counts, newsletters, app directories, trade associations, role headcount. Also returns candidate subreddits |

Feasibility is deliberately not an agent. Technical complexity and time-to-MVP are your
own engineering judgment, not a research lookup — you assess them in Stage 6.

While the agents run, do not start Reddit work. Stage 3 depends on their output; querying
Reddit before you have brand names reproduces the exact failure documented below.

Also run the HN Algolia query directly here — it is cheap, needs no auth, and its date
filter covers reddit-fetch's recency blind spot:

```bash
curl -s 'https://hn.algolia.com/api/v1/search?query=<topic>&tags=show_hn&numericFilters=created_at_i%3E<unix-24mo-ago>' \
  | jq -r '.hits[] | "\(.points)\t\(.num_comments)\t\(.title)\t\(.url // "")"' | head -20
```

The `>` must be URL-encoded as `%3E` or the shell eats it.

## Stage 3: Build the Reddit query plan

This is the stage that determines whether Reddit research produces evidence or noise.

**The mechanism you are working around.** `sort=top` is hardcoded in reddit-fetch with no
time filter, and Reddit search does loose OR-matching. A query built only from words that
are common *inside the target subreddit* matches thousands of posts, and `sort=top` then
floats that subreddit's all-time greatest hits to the front. The query silently becomes a
no-op filter and you get back plausible-looking garbage.

This is measured, not theoretical. Three real prior runs:

| Query | Query token in results | Outcome |
|---|---|---|
| `recipe extractor app` in r/Cooking | "extractor" **0 times** | All-time top posts, scores 3915 / 3658 / 2623. Worthless |
| `tiktok recipe measurements` in r/Cooking | "tiktok" 2 times | Mostly all-time hits, 9058 / 8986. Mostly worthless |
| `recime` in r/Cooking | "recime" **20 times** | On-topic, scores 28 / 21 / 7 / 8 / 5 / 2 / 2 / 2. Surfaced 9 unknown competitors |

**The rule: every query must contain at least one token that is rare inside the target
subreddit.** Brand names satisfy this by construction, which is why competitor-name
search is the highest-signal technique available. If you cannot find a rare token for a
query, do not spend the invocation — a wasted call costs 30 seconds and produces data
that will actively mislead the report.

### Subreddit selection — cap 4

| Rule | Rationale |
|---|---|
| Prefer the ICP's professional or hobby sub over the generic tech sub | r/Bookkeeping beats r/smallbusiness beats r/SaaS for demand signal |
| Exactly one "buyer" sub is mandatory; at most one "builder" sub | Builder subs (r/SaaS, r/indiehackers, r/EntrepreneurRideAlong) describe *supply*. Over-indexing on them is how you conclude a market exists because founders are excited about it |
| Take the intersection of three sources: Stage 2 output, the ICP's job title, and wherever competitor names get mentioned | Three independent signals beats one guess |
| A query returning 0 posts means the sub is small, dead, or misspelled — spend nothing more there | There is no listing endpoint, so this is the only liveness probe available |

### Query archetypes — each must carry a rare token

| # | Archetype | Where the rare token comes from | Example |
|---|---|---|---|
| A1 | Bare competitor brand name | Rare by construction | `dext`, `hubdoc` |
| A2 | Incumbent brand + pain word | The brand | `quickbooks export` |
| A3 | Domain jargon compound | Trade jargon is rare in general subs | `1099 reconciliation` |
| A4 | Workaround artifact | Tool names | `zapier bookkeeping`, `airtable client tracker` |
| A5 | Switching intent | Brand-anchored | `paprika alternative` |

### Waves — budget 8, hard cap 12 under `deep:`

| Wave | Calls | Purpose |
|---|---|---|
| Preflight | 1 | Prove the session is live before committing to a plan |
| A — brand probes | 3-4 | Top Stage-2 product names, each in its single best-fit sub. Highest signal per call |
| B — jargon / workaround | 2-3 | A3 and A4 archetypes across the remaining subs |
| C — adaptive | 0-3 | Fires only when Wave A comments surfaced 2+ previously-unknown product names. **This is where the 9-competitor payoff came from in prior research — do not skip it when the trigger fires** |

## Stage 4: Run reddit-fetch sequentially

**Never run two invocations in parallel.** All invocations share one Playwright persistent
profile directory, which is why `CONCURRENCY = 1` is hardcoded in the tool. Concurrent
runs contend on the profile and trigger bot challenges. Sub-agents do not help — they
share the same filesystem.

### Preflight

Run this first, with the Bash tool's `timeout` set to `60000`:

```bash
mkdir -p /tmp/validate-idea/<slug>-$(date +%Y%m%d)
~/dev/reddit-fetch/reddit-fetch \
  -s <best-sub> -q <best-brand-token> -l 1 --comment-limit 0 \
  -o /tmp/validate-idea/<slug>-$(date +%Y%m%d)/preflight.json
```

A healthy headless run is two navigations, well under 20s. **If it times out, the session
has expired and an invisible browser window is waiting for a human login** — it will
block for up to 5 minutes. Say so plainly and let the user choose:

```
Reddit session looks expired — reddit-fetch has opened a login window and is
waiting (up to 5 min). Sign in and I'll continue, or say "skip reddit" and I'll
run web-only with reduced demand evidence.
```

Never silently proceed as though Reddit data was gathered. Record any degradation in the
coverage footer. Rarer failures — the `"Login completed but session was not detected"`
case and bot challenges — are handled in `references/reddit-fetch.md`.

### Each invocation

```bash
~/dev/reddit-fetch/reddit-fetch \
  -s <subreddit> -q "<query with rare token>" -l 10 --comment-limit 10 \
  -o /tmp/validate-idea/<slug>-<date>/<sub>-<query-slug>.json
```

Always an **absolute** `-o` path. The wrapper `cd`s to its own directory, so a relative
path lands in the tool repo, not your cwd.

**Never send output to stdout.** Saved payloads from prior runs range 26KB-344KB; the
largest is roughly 90K tokens. Write to a file, then triage:

```bash
jq -r '.posts[] | "\(.score)\t\(.num_comments)\t\(.created_utc|todate[:10])\t\(.title)"' <f> | sort -rn
```

Then pull only the posts that matter, dropping deleted content:

```bash
jq '.posts[] | select(.id=="<id>") | {title, selftext,
  top_comments: [.top_comments[] | select(.body != "[deleted]")]}' <f>
```

### Mandatory relevance smoke test

Run after **every** invocation. The all-time-top failure is silent, so this is the only
thing standing between the report and confidently-cited garbage:

```bash
jq -r --arg t "<rare-token-lowercased>" \
  '[.posts[] | ((.title + " " + .selftext + " " + ([.top_comments[].body] | join(" ")))
    | ascii_downcase | contains($t))] | "hits=\(map(select(.)) | length)/\(length)"' <f>
```

Zero or one hit out of eight means the query fell into the trap. **Discard the file,
reason from none of it, and retry with a rarer token** — or drop the query if no rarer
token exists. Do not salvage partial signal from a trapped result.

### Recency

Always surface `created_utc` next to any quoted evidence. All-time sort can rank a 2020
thread above a 2026 one, which is actively misleading for competitor pricing and for
whether a product still exists. Split on 24 months:

```bash
jq --argjson c "$(( $(date +%s) - 730*86400 ))" \
  '{recent: [.posts[] | select(.created_utc > $c)] | length, total: (.posts | length)}' <f>
```

Expect shortfall as normal: `-l 10` typically yields 8 posts, and `--comment-limit 10`
yielded 6 in two of three prior runs. Not an error.

## Stage 5: Synthesize the competitive picture

Select which non-Reddit source families to mine based on the idea type. Per-source
extraction detail is in `references/demand-sources.md`.

| Idea type | Families to prioritize |
|---|---|
| Vertical B2B tool | Role headcount, trade associations, existing spend on freelancers/templates |
| Ecommerce adjacent | Shopify App Store installs and reviews, Gumroad templates |
| Developer tool | HN Show HN, GitHub stars on adjacent OSS, Stack Overflow volume |
| Consumer mobile | App Store / Play Store review mining, install-count proxies |
| Workflow glue | Zapier / Make template counts, Notion and Airtable template marketplaces |

Then fold Reddit, web, and directory data into one table. **"Do nothing" and "a
spreadsheet / manual process" are mandatory rows** — they are the real incumbents, and
omitting them is how a landscape looks emptier than it is.

| Column | Content |
|---|---|
| Name | Product, or "Do nothing" / "Spreadsheet" |
| Pricing | Actual tiers, or "free", or "n/a" |
| Scale signal | Review counts, years active, funding, install counts — with the source |
| Key complaint / gap | The specific recurring grievance, quoted where possible |

Cap at 10 rows. Beyond that the report stops being read.

## Stage 6: Wedge, MRR, distribution, feasibility

**Wedge.** Based on competitor gaps, name the specific underserved angle — cheaper,
simpler, narrower niche, better integration, different pricing model. If every gap you
found is already claimed by two or more incumbents, write **"none found"** and say so
plainly. A missing wedge is a finding, not a gap in the research.

**MRR model.** Every number carries a label. An unlabeled number is a bug.

```
Addressable:  <N>         [measured|proxy|assumed] — <source>
Reachable:    <M> (<x>%)  via <NAMED channel>
Price:        $<P>/mo     — anchored to <competitor> at $<their price>
12-mo MRR:    $<MRR>
Assumptions:  <the reasoning behind the reach % and the price, explicitly>
```

The named-channel requirement is the whole point. "SEO", "content marketing", and
"Twitter" are not channels. "The r/bookkeeping weekly thread plus the 4,200-member
Bookkeeper Growth Facebook group" is a channel.

**Distribution.** Rank the top 2-3 channels by realism for a solo operator:

| Test | Question |
|---|---|
| Access | Does the user already have a foothold, or is this cold? |
| Concentration | Is the audience actually gathered there, or diffuse? |
| Tolerance | Does the venue permit promotion, or will it ban them? |
| Repeatability | One-shot launch spike, or a channel that keeps producing? |

**Feasibility.** Rough technical complexity and realistic time to a *sellable* MVP for a
solo builder — not a demo. Name the hard part specifically: the integration nobody
documents, the data you have to acquire, the compliance step, the accuracy bar.

**Kill-criteria checklist.** Test each explicitly rather than treating them as generic
caveats. Platform dependency (built on an API that can revoke you) · regulatory or
liability exposure · race-to-bottom pricing · chicken-and-egg marketplace dynamics ·
incumbent absorption (this is a feature, and Notion ships it next quarter) · AI
commoditization (a weekend rebuild) · unreachable audience · willingness-to-pay mismatch
(the audience is broke or expects free) · churn structure (a one-time need dressed up as
recurring).

## Stage 7: Validation ladder

Propose the cheapest, fastest tests that move this from theory to evidence, ordered by
signal strength. Give the smallest version runnable *this week* and the threshold that
counts as pass versus kill. Execution mechanics are in `references/validation-playbook.md`.

| Strength | Test | Smallest version this week | Pass | Kill |
|---|---|---|---|---|
| Weak | Community reaction | One post describing the problem in the ICP's main sub | Substantive replies describing the pain unprompted | Crickets, or "just use X" |
| Weak | Waitlist | One-page landing, one link posted | Signups above ambient traffic | Under ~10 from a real audience |
| Medium | Qualified waitlist | Add 2 screener questions incl. current spend | Majority name a tool or workaround they pay for | Most say "nothing, I just wing it" |
| Medium | Customer conversations | 15-20 calls on how they solve it *today* | Most describe a workaround costing real time or money | Most have never tried to solve it |
| Strong | Pre-sale / deposit | Ask for money before building | Any stranger pays | Warm contacts decline |
| Strong | Concierge | Do it manually for one paying customer | They pay again unprompted | They churn after one cycle |
| Strong | Paid traffic to a buy button | $100 of ads to a pricing page with a real checkout | Real clicks on "buy" at target price | Clicks on the page, none on buy |

Never propose a strong test the user cannot start within a week.

## Stage 8: Verdict

Derive the verdict from the evidence pattern rather than from overall impression.

| Evidence pattern | Verdict |
|---|---|
| Demand shown + wedge found + a named reachable channel | **Pursue** |
| Demand shown + wedge found + no reachable channel | **Narrow and retest** — respecify to an audience you can reach |
| Demand shown + no wedge | **Narrow and retest** — go narrower until a wedge exists, or kill |
| No demand evidence, crowded market | **Kill** — competitors are serving it and you found no gap |
| No demand evidence, empty market | **Kill** — empty usually means no market. Say why you think it is empty |
| Audience unreachable or unnameable | **Kill** at Stage 1 |
| A structural kill criterion fires | **Kill** regardless of demand |

State exactly one binding reason. Not three contributing factors — the single thing that
determines the outcome. Before rendering, scan the verdict sentence for "could", "might",
"consider", "potentially", "it depends" and rewrite if any appear.

## Stage 9: Adjacent leads

A Kill answers "not this." It does not answer "then what," and the research just run is
by far the best available input to that second question. Competitor complaints that fell
outside the idea, segments incumbents refuse to serve, dead products with post-mortems,
freelancer gigs for the manual version, communities that turned out to be highly
reachable — all of it surfaced during Stages 2-5 and none of it was the thing being
validated. Harvest it before it is thrown away.

Fires on **Kill** and **Narrow and retest**. Never on Pursue — a Pursue verdict shipped
with a list of other things to build is a distraction from the one thing worth doing.

Four rules govern this stage. The full harvest map, the axis catalogue, and the worked
example are in `references/adjacent-pivots.md`; read it whenever this stage fires.

**Clear the binding constraint.** A lead qualifies only if it clears the exact constraint
named in the Stage 8 verdict. If the idea died because the audience was unreachable, a
lead aimed at that same audience is not an alternative — it is the same death on a delay.
State per lead which constraint it clears and how. A lead that cannot answer this is not
a lead.

**Ground every lead in an artifact.** Each one cites the specific finding it came from: a
named competitor's review cluster, a quoted Reddit thread with its date, a Gumroad
template with sales, a community with a member count. Reasoning your way to an adjacent
idea without an artifact is speculation, and speculation rendered in a research report is
exactly what the rest of this skill exists to prevent. Spend no new research budget here —
harvest only what Stages 2-5 already collected.

**Clear the Stage 1 gate on its face.** A lead needs a nameable role and somewhere that
role congregates. Anything failing that gate would die at Stage 1 of its own run, so do
not propose it.

**Never rank a lead against the validated idea.** Leads inherit none of this run's
evidence beyond the single artifact that suggested them. No MRR model, no verdict, no
"this one looks stronger." The deliverable is a pointer worth its own `/validate-idea`
run. Render them after the kill reasoning, never inside it, and never as consolation —
the verdict does not get softer because something else might work.

Cap at 3. Zero is a legitimate and common result: write "No adjacent leads surfaced" and
name what you looked through.

**When the idea died at the Stage 1 gate**, no research ran and there are no artifacts to
harvest. Do not manufacture leads. Offer at most two reframings drawn from the axis
catalogue, labelled plainly as unresearched questions rather than findings.

## Stage 10: Render the report

Lead with the verdict banner, then the sections — ten on a Pursue, eleven on a Kill or
Narrow. Emoji appear on the banner only — this is an analytical memo, and heavy emoji
undercuts the blunt-operator voice.

```
## 🟢 PURSUE — <one-sentence binding reason>
```

Use `🟢 PURSUE`, `🟡 NARROW AND RETEST`, or `🔴 KILL`.

**Critical rendering rule:** the banner must be a `##` heading followed by a blank line,
and every section heading below must have a blank line before its content. Without the
blank lines the markdown renderer joins headings into the following paragraph.

Then, in order:

```
### 1. Idea and ICP
<Problem restated. The nameable ICP. Flag it if the user's original audience was narrowed.>

### 2. Demand signals
<Specific sources with dates, not vague claims. Quote real language where you have it.
Mark each signal [recent] or [historical >24mo]. Say plainly if evidence is thin.>

### 3. Competitive landscape
<The table from Stage 5, max 10 rows, incl. "Do nothing" and "Spreadsheet".>

### 4. Wedge
<The specific underserved angle, or "None found" with why.>

### 5. MRR model
<The labeled chain from Stage 6. Assumptions explicit.>

### 6. Distribution plan
<Top 2-3 named channels, ranked, each with why it is realistic for a solo operator.>

### 7. Build complexity and time-to-MVP
<Estimate plus the specifically hard part.>

### 8. Kill criteria and biggest risks
<Which structural risks actually fire here, and what would have to be true to survive them.>

### 9. Verdict
<Restate the banner verdict with the reasoning behind the single binding reason.>

### 10. Next 3 actions
<Only on Pursue or Narrow. Three concrete moves in order, drawn from the Stage 7 ladder,
each with its pass/kill threshold. On a Kill, replace with: what would have to change
for this to be worth revisiting.>

### 11. Adjacent leads
<Kill and Narrow only — omit the whole section on a Pursue, and on a multi-idea run,
where leads are pooled once after the comparison table instead. Up to 3, each in the
format below. Or "No adjacent leads surfaced" plus what you looked through.>

**<Short label>** — <one sentence: what it is and for whom>
- Clears: <the Stage 8 binding constraint, and specifically how this gets past it>
- Artifact: <the exact finding it came from, with source and date>
- Cheapest check: <one probe from the Stage 7 ladder, sized to a single day>

<Close with exactly this line:>
Unvalidated — each is a candidate for its own `/validate-idea` run, not a
recommendation.

---
**Coverage:** <sources fetched> · <anything that failed or was skipped, and why>
```

The coverage footer is not optional. A report that quietly omits Reddit because the
session expired reads identically to one where Reddit found nothing — and those are
opposite findings.

## Multiple ideas

When the input holds more than one idea, branch at the **end of Stage 1** — framing is
cheap and it is where the kill gate lives. Ideas failing the gate die there and consume
zero research budget. Survivors are hard-capped at 3: reddit-fetch is serial, so 5 ideas
at 5 calls each is roughly 13 minutes of blocking.

The full procedure, the comparison-table contract, and the pairwise-ranking format are in
`references/multiple-ideas.md`. Read it whenever the input has more than one idea.

## Parallelism policy

- The three Stage 2 web agents run in parallel — one message, three `Agent` calls.
- **reddit-fetch is a global mutex.** One invocation at a time, always in the main
  thread. Never delegate Reddit work to a sub-agent; they share the same browser profile.
- Never spawn per-idea agents in multi-idea mode. Two reasons: the mutex, and verdict
  consistency — split synthesis produces verdicts that cannot be compared, which defeats
  the purpose.
- Query planning, synthesis, the MRR model, and the verdict stay in the main thread.
  Choosing rare tokens requires holding the subreddit vocabulary and competitor list in
  one context.

## Quality gates

Run before delivering.

1. Every Reddit-sourced claim came from a file that passed the relevance smoke test.
2. No competitor pricing claim rests solely on a Reddit post older than 18 months.
3. Every MRR-chain number carries `[measured]` / `[proxy]` / `[assumed]`.
4. The distribution channel is named specifically, not a category.
5. The verdict is one sentence with exactly one binding reason, and contains no "could",
   "might", or "consider".
6. Competitor table ≤ 10 rows; demand-signal quotes ≤ 6.
7. "Do nothing" and "spreadsheet / manual" both appear in the competitor table.
8. The coverage footer names every source that failed to fetch or was skipped.
9. If the verdict is Kill, the report says so in the first line on screen.
10. On a Kill or Narrow, adjacent leads appear exactly once — as section 11 on a
    single-idea run, or once after the comparison table on a multi-idea run — with leads
    or with "No adjacent leads surfaced". Every lead cites an artifact and names the
    constraint it clears; none carries an MRR figure or a comparison to the validated
    idea.
11. No lead re-proposes an idea already killed elsewhere in this run.

## Maintenance

- **New query archetype** — add a row to the Stage 3 archetype table, stating where its
  rare token comes from. An archetype without a rare-token source does not belong there.
- **New demand-signal source** — add it to `references/demand-sources.md` and, if it is
  gated by idea type, to the Stage 5 selection table.
- **New validation rung** — add to the Stage 7 ladder with its pass/kill threshold, and
  put the mechanics in `references/validation-playbook.md`.
- **New pivot axis** — add it to the axis catalogue in `references/adjacent-pivots.md`,
  naming the research artifact it harvests from. An axis with no artifact behind it
  generates speculation and does not belong there.
- **reddit-fetch gains flags** (time filter, multi-sub, sort control) — Stage 3's entire
  design exists to work around their absence. Revisit the rare-token rule and the wave
  structure if a `t=` time filter ever lands, since that removes the all-time-top trap.
