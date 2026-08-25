# Validation playbook

Execution mechanics for each rung of the Stage 7 ladder. Consulted only on a **Pursue**
or **Narrow and retest** verdict — a Kill needs no validation plan.

The ladder itself, with pass/kill thresholds, is the table in SKILL.md Stage 7. This file
answers "how do I actually run this test this week."

## The principle behind the ordering

Each rung costs more and proves more. The point is not to climb the whole ladder — it is
to find the cheapest test that could still kill the idea, run it, and stop if it fails.

Most people run only weak tests, collect encouraging noise, and build anyway. The weak
rungs exist to *disqualify* ideas cheaply, not to validate them. **Passing a weak test
means "not yet dead," never "go build it."** Only the strong rungs — where money changes
hands — actually validate.

Never propose a test the user cannot start within a week. A validation plan that takes a
month to set up gets replaced by building the product, every time.

## Weak — community reaction

**Run it:** one post in the ICP's main community describing the *problem*, not the
product. "How do you all handle X?" outperforms "would you use a tool that does X?" —
the first gets people describing reality, the second gets politeness.

**This week:** one post, one community, 20 minutes.

**Pass:** several substantive replies describing the pain unprompted, ideally naming the
workaround they use. Comments arguing about which workaround is best are a strong tell.

**Kill:** silence, or a chorus of "just use \<existing tool\>" with no complaints attached.

**Trap:** builder communities (r/SaaS, r/indiehackers) will encourage almost anything.
Their feedback measures founder enthusiasm, not demand. Post where buyers are.

## Weak — waitlist

**Run it:** one page stating the problem and the promised outcome, with an email field.
No feature list. Post the link where the problem post landed.

**This week:** a few hours with any landing-page tool.

**Pass:** signups meaningfully above ambient traffic — the number matters less than the
rate relative to how many people saw it.

**Kill:** under roughly 10 signups from a real, targeted audience.

**Trap:** an email address costs nothing to give. Waitlist size predicts revenue poorly.
This rung is for disqualification only.

## Medium — qualified waitlist

**Run it:** the same landing page plus two screener questions. The questions are the
entire point:

1. *"What do you use for this today?"* — a free-text answer naming a tool, a spreadsheet,
   or a person is the signal.
2. *"What does that cost you per month?"* — in money or hours.

**This week:** add two fields to the form you already built.

**Pass:** a majority name a specific tool or workaround they already pay for in money or
significant time.

**Kill:** most answer "nothing," "I just wing it," or leave it blank. That is a problem
people tolerate, and tolerated problems do not convert.

**Why this beats a plain waitlist:** it converts a costless signal into a revealed one.
Someone who names a $40/mo tool they hate is a qualified lead. Someone who has never
tried to solve the problem is not.

## Medium — customer conversations

**Run it:** 15-20 conversations about how they solve this *today*. Do not pitch. Do not
describe your idea until the end, and only if asked.

Questions that work:

- "Walk me through the last time you did this."
- "What did you try before that?"
- "What did it cost you when it went wrong?"
- "Who else on the team touches this?"

Questions that do not work: anything hypothetical. "Would you use…" and "would you pay…"
generate encouraging answers that predict nothing.

**This week:** 5 conversations is enough to start seeing pattern or absence of pattern.
Recruit from the qualified waitlist, the community post's commenters, or cold LinkedIn
messages to the role.

**Pass:** most describe a workaround that costs real time or money, and describe it
consistently — the same shape of problem recurring across people who have never met.

**Kill:** everyone describes a different problem, or most have never attempted to solve
it. Divergent stories mean the ICP is still too broad; go back to Stage 1 and narrow.

## Strong — pre-sale or deposit

**Run it:** ask for money before the product exists. A founding-member price, a deposit
against a discount, or an annual plan at a steep discount. Be explicit that it does not
exist yet and offer a full refund — the honesty costs nothing and the signal survives it.

**This week:** a Stripe payment link and a paragraph of email to the qualified waitlist.

**Pass:** any *stranger* pays. One payment from someone who does not know you outweighs
fifty warm nods.

**Kill:** warm contacts decline. If people who like you personally will not pay, strangers
certainly will not.

**Trap:** friends and colleagues buying to be supportive. Discount those to zero.

## Strong — concierge

**Run it:** deliver the outcome manually for one paying customer. No product, no
automation — you doing the work by hand behind an email address. This is the highest
information-per-dollar test in the entire ladder.

**This week:** one customer, one manual delivery cycle.

**Pass:** they pay again unprompted for a second cycle.

**Kill:** they churn after one cycle, or they accept the result but never use it.

**Why it is worth the effort:** it simultaneously tests whether the outcome is valuable,
whether the price is right, and what the product actually needs to do. Most feature ideas
die during the first manual cycle when you discover which steps actually matter. It also
frequently reveals the real product is narrower than planned.

## Strong — paid traffic to a buy button

**Run it:** roughly $100 of tightly targeted ads to a pricing page with a real checkout at
the real intended price. The checkout must be real — a "coming soon" interstitial after
the click is acceptable, but the price and the button must be genuine.

**This week:** one ad set, one landing page, one price.

**Pass:** real clicks on the buy button at the target price.

**Kill:** traffic lands, reads, and nobody clicks buy. That isolates the failure to
willingness-to-pay rather than to targeting or messaging.

**Trap:** measuring landing-page conversion instead of buy-button clicks. Email signups
from paid traffic tell you the ad worked, not that the product will sell.

**When to skip it:** if the ICP is not reachable by ad targeting — a niche trade with no
usable interest category — this rung is not available. Substitute the concierge test.

## Choosing which rung to run

| Situation | Start at |
|---|---|
| No demand evidence at all yet | Community reaction — cheapest possible disqualifier |
| Demand evidence exists, ICP uncertain | Customer conversations — they also fix the ICP |
| Demand and ICP both solid, price unknown | Pre-sale — it tests price and demand together |
| Everything solid, build cost is the risk | Concierge — proves value before engineering |
| Everything solid, reachability is the risk | Paid traffic — it tests the channel and the price at once |

Pick the rung that tests the thing most likely to kill the idea. That is almost always
the binding constraint named in the verdict, so let the verdict choose the test.
