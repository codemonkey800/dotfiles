# Non-Reddit demand-signal sources

Nine source families, ordered by signal strength. SKILL.md Stage 5 carries the compact
selection table — which families to hit for which idea type. This file carries what to
extract from each and what separates a strong signal from a weak one there.

Reddit is handled separately by `reddit-fetch.md` and is not repeated here.

## The ordering principle

Every family below is ranked by one question: **does this show someone already spending
money or meaningful time, or does it only show that someone finds the problem annoying?**

Stated interest is nearly worthless. "I'd definitely use that" costs nothing to say and
predicts nothing. A $29 spreadsheet purchase, a $400 Upwork gig, or a paid subscription
to a product everyone complains about is revealed preference — it is the closest thing to
proof available before you build.

Families 1, 2, and 9 are the highest value per minute for micro-SaaS specifically, and
they are exactly the ones a generic research pass skips. Prioritize them.

## 1. Existing spend on a worse solution

**The strongest signal available.** Someone paying for a bad version of your product has
already cleared the two hardest hurdles: they know they have the problem, and they are
willing to pay to solve it.

| Where | What to extract |
|---|---|
| Gumroad, Etsy | Spreadsheet and template products for this task. Price, sales count where visible, review count, last-updated date |
| Notion / Airtable template marketplaces | Paid templates solving this workflow. Price, install counts |
| Upwork, Fiverr | Gigs where someone pays a freelancer to do this manually. Hourly rate or fixed price, number of orders completed, how many providers compete |
| Etsy / Creative Market | Printable or digital tools for the trade |

Strong: multiple sellers, repeat sales, prices above $20, recent activity.
Weak: one abandoned listing from 2021 with no reviews.

The gold finding here is a template with hundreds of sales — that is a customer list and
a price anchor in one.

## 2. App-directory installs and reviews

Doubles as competitive evidence and distribution research: the directory is itself a
channel you could ship into.

| Directory | Relevant when |
|---|---|
| Shopify App Store | Ecommerce-adjacent |
| Chrome Web Store | Browser workflow, scraping, overlay tools |
| Zapier / Make | Workflow glue. Also count how many templates exist for the task |
| Slack, Atlassian, HubSpot | Team and B2B workflow |
| QuickBooks / Xero | Accounting and bookkeeping verticals |
| WordPress plugins | Content and small-business web |
| Notion integrations | Knowledge work |

Extract install counts, review counts, rating distribution, and last-updated date. A
directory app with 50K installs and a 3.1 rating is a wedge advertisement.

Strong: several apps with real install counts and mediocre ratings.
Weak: one app with 12 installs, or a directory with nothing at all — check whether the
platform simply does not permit this category before reading it as opportunity.

## 3. Review mining

**Mine 2-3 star reviews specifically.** This is the single most useful filter in
competitor research. One-star reviews are usually billing disputes or outages; five-star
reviews are usually solicited during onboarding. The two- and three-star band is where
users who genuinely want the product explain precisely what it fails to do — which is the
wedge, stated in the customer's own words.

Sources: G2, Capterra, TrustRadius, App Store, Google Play, Trustpilot.

Extract the recurring complaint themes, not individual gripes. A complaint that appears
once is noise; one that appears in nine reviews across two years is a product gap the
incumbent has chosen not to fix. Note pricing friction separately — "great tool, but the
jump from $29 to $199 is brutal" is a pricing wedge, not a feature wedge.

Always date the reviews. A 2019 complaint may describe a since-shipped feature.

## 4. Hacker News via Algolia

Verified working, no auth required:

```bash
curl -s 'https://hn.algolia.com/api/v1/search?query=<topic>&tags=show_hn&numericFilters=created_at_i%3E<unix>' \
  | jq -r '.hits[] | "\(.points)\t\(.num_comments)\t\(.created_at[:10])\t\(.title)\t\(.url // "")"'
```

The `>` must be URL-encoded as `%3E` or the shell eats it.

Two things make this valuable. `tags=show_hn` surfaces indie launches — direct
bootstrapped competitors, often invisible to G2 and Capterra. And the
`numericFilters=created_at_i%3E<unix>` date filter **covers reddit-fetch's recency blind
spot**, since reddit-fetch is locked to all-time sort with no time filter.

Drop `tags=show_hn` for general discussion. Read the comments, not just the points — HN's
critique of a launch is often a free competitive analysis.

## 5. Public revenue disclosures

Indie Hackers product pages and milestone posts, MicroConf talks, build-in-public
threads on X, Starter Story interviews, open startup dashboards.

The question: has someone already tried this, and what happened? A public post-mortem
explaining why a product in this exact space failed is worth ten hours of speculation.
A public MRR chart from someone succeeding in an adjacent niche is a price and growth
anchor.

Strong: someone disclosing real MRR in this category.
Weak: a launch announcement with no follow-up — check whether the product still exists.

## 6. Product Hunt

Launch traction, with a caveat: **upvotes are gamed and weakly correlated with revenue.**
Weight the comments over the vote count. Look for whether the product still has a live
site two years after launch — the launch-then-die pattern is common and informative.

## 7. Search-volume proxies

No keyword tool is assumed to be available. Label everything from this family `[proxy]`
in the MRR model — these establish relative interest, never absolute volume.

- Google and YouTube autocomplete for the problem phrase
- "People also ask" and "Related searches"
- The count of distinct SEO-farm articles targeting the term. Ten thin affiliate posts
  competing for "best X software" means someone has measured real commercial volume
- YouTube tutorial count and view counts for the manual workaround. A tutorial with
  400K views on doing this by hand is a large audience with an unmet need

## 8. Community sizing

Subscriber and member counts for subreddits, Discord servers, Slack communities,
Facebook groups, and newsletters. Feeds the `Addressable` line of the MRR model.

Record activity, not just size. A 200K-member subreddit with four posts a day is smaller
in practice than a 6K-member Discord with constant traffic. Also record whether promotion
is permitted — a community you cannot reach into is not a channel, and this distinction
belongs in the distribution ranking rather than the addressable number.

## 9. Role headcount

**For vertical B2B, the count of people holding the role IS the addressable market.**
This is what turns a TAM line from a guess into a citation, and it is routinely skipped.

| Source | Use |
|---|---|
| US Bureau of Labor Statistics OES data | Employment counts by occupation code. Authoritative and free |
| Trade association membership numbers | Often published in annual reports |
| LinkedIn people-search filter counts | Title + geography. Rough but directional; label `[proxy]` |
| Job-board posting volume | Indicates whether the role is growing or contracting |
| State licensing registries | For licensed trades — often exact counts, publicly downloadable |

Strong: an official count you can cite with a year.
Weak: a market-research press release quoting a "$4.2B market growing at 14% CAGR" —
those numbers are almost always unfalsifiable and are not addressable-user counts.

## What to do with thin evidence

If several families come back empty, that is itself the finding. Say so explicitly in the
report rather than stretching weak signals to fill the section. An idea where nobody sells
a template, no directory app exists, no one posts about it, and no freelancer offers the
service is an idea where the pain may be real but is not felt strongly enough to spend on
— which is a Kill, and worth reaching quickly.
