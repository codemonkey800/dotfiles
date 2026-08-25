---
name: personal-email-triage
description: |
  Triage unread/read/all/custom-scoped email in jeremyasuncion808@gmail.com: get an
  exact count, fetch in waves, categorize using Gmail's CATEGORY_* labels plus
  sender/subject heuristics, propose a label per cluster (matching the existing
  "Filtered Stuff/..." hierarchy when one fits), get explicit confirmation, then
  trash safe-to-delete noise and archive+label everything else. Builds on and
  invokes the personal-email skill for auth and base CLI reference. Use when the
  user asks to clean up / triage / declutter their inbox, process unread email in
  bulk, categorize and label an email backlog, figure out what's safe to delete, or
  process email in batches/waves (e.g. "clean up my inbox", "triage my unread
  email", "go through my email and label/archive/delete stuff", "process the first
  500 emails").
user-invocable: true
argument-hint: "[scope: default=unread-in-inbox | read | all | first N | free-form Gmail query] [permanent-delete for this run]"
---

# Email Triage

Works down the inbox in checkpointed waves instead of one message at a time: count
exactly how much there is, fetch a wave, categorize it, propose labels, get explicit
confirmation, then trash the safe-to-delete noise and archive+label the rest. Builds
on `personal-email` rather than re-deriving auth or the base CLI table.

## Step 0 — Load base conventions, then the safety override

Invoke the `personal-email` skill first, via the Skill tool, before anything else.
That runs its auth check and loads its CLI reference table into this reasoning
stream — this skill builds directly on it instead of keeping a hand-copied duplicate
that can drift out of sync when the base skill changes.

### Deliberate override of personal-email's safety rule #3

personal-email's rule #3 says: "Never use --force or -y on send or trash."

This skill DELIBERATELY OVERRIDES that rule for its own execution calls —
DO NOT REMOVE THIS OVERRIDE, and do not "fix" it by dropping --force back out.

Scope of the override: trash, batch modify, batch delete, and mark-read/unread
if explicitly requested mid-run — i.e. every bulk/destructive gmail command
this skill issues programmatically, and ONLY when executing a wave the user
has ALREADY confirmed in chat. It does NOT apply to `send` — this skill never
sends email, and if it ever did, rule #3 would fully apply unchanged.

Why: the Bash tool has no attached interactive terminal. A command's blind
y/n confirmation prompt cannot be answered by the user through it — there is
no channel. Omitting --force here doesn't preserve a safety check, it just
produces a hang or a bare CLI failure on a command the user already approved
in chat. This skill's own confirmation (grouped by category/cluster, with
concrete examples, editable via free-form reply) is strictly richer than the
CLI's blind per-call prompt — --force retires the weaker gate, it does not
remove the only gate.

(`-y/--force` is documented as "skip confirmations for destructive commands";
`--no-input` is documented as "never prompt; fail instead" — a dedicated
fail-clean escape hatch, not what we want here since the user already said
yes. A fake `y` piped into stdin was considered and rejected as fragile
versus `--force` being a first-class documented contract for exactly this
situation.)

## Step 1 — Parse scope

Default: unread in inbox → `in:inbox is:unread`. Also supported:

- "read" → `in:inbox -is:unread`
- "all" → `in:inbox`
- "first N [+ read/unread/all]" → same query, capped at N results
- Any additional text that looks like Gmail query syntax gets AND-ed onto the
  base query (e.g. "unread newsletters from before 2024" →
  `in:inbox is:unread before:2024/01/01`)

**"First N" ordering**: Gmail's API only returns results newest-first — there is no
API-level oldest-first sort. So "first N" means **the N most recently received
messages matching the rest of scope**. If oldest-cruft-first is actually wanted,
layer `before:YYYY/MM/DD` onto the scope instead of paging to exhaustion to fake a
sort Gmail doesn't offer.

## Step 2 — Get an exact count, cheaply

For the three basic scopes, one free call, zero pagination:

```bash
gog gmail labels get INBOX --json --account=jeremyasuncion808@gmail.com
```

→ `messagesUnread` (unread scope), `messagesTotal - messagesUnread` (read scope),
`messagesTotal` (all scope).

For a scope with extra filters layered on (no free total exists for an arbitrary
query): skip the upfront count, paginate and report "found so far: N" as fetching
proceeds, and stop once the wave's target or the scope's cap is reached — don't
paginate further than needed just to produce an exact denominator nobody asked for.

Re-run this same cheap count at the **start of every wave**, not just once — it's
one free call, and it keeps "N remaining" framing accurate if new mail arrives
mid-run or overrides changed the actual processed count.

## Step 3 — Fetch (paginated, metadata-only)

```bash
gog gmail messages search "<query>" --json --max=100 --page=<token> --account=jeremyasuncion808@gmail.com
```

- **Must pass `--max=100` explicitly** — the command's own default is 10, not 100.
- Loop on `nextPageToken` until absent or the wave's target (500) is hit.
- **Never** use `--all` (silently fetches the entire result set, defeating
  wave-based processing) or combine `--results-only` with this call (it drops
  `nextPageToken`, which the loop depends on).
- Skip `--select`/`--fields` — `--select` is best-effort with unclear array
  semantics, and no `--fields` flag actually exists despite being name-dropped in
  the help text. The default shape already returned (id, threadId, date, from,
  subject, labels) is sufficient.
- No `--include-body` — full decoded bodies are never fetched by default; see Step 4
  for why ambiguous cases don't get a fallback fetch either.
- Use `--fail-empty` on a scope's first fetch for a clean exit code on "no matches"
  instead of parsing an empty array.

## Step 4 — Categorize

This step is explicitly **judgment**, not a deterministic algorithm — using Gmail's
own `CATEGORY_*` labels plus sender/subject heuristics as strong priors to assign
each message a coarse category and a finer cluster. (Step 5's delete gate is the
opposite: strict, deterministic, no judgment calls. Keep these two modes
conceptually separate — don't accidentally loosen one while "improving" the other.)

Classify **per fetched page (100), not once over the full wave (500)** —
accumulating cluster tallies across pages within a wave. Classifying ~500 short rows
in one pass is where quality degrades from attention drop-off over a long,
repetitive, low-information-density list; per-page classification is both cheaper
and more accurate.

**Coarse categories** (7, internal only — never shown as Gmail labels):

| # | Coarse category | Delete-eligible? | `CATEGORY_*` prior |
|---|---|---|---|
| 1 | Promotional/Marketing | Yes | `CATEGORY_PROMOTIONS` — strong, direct |
| 2 | Social/App Notification | Yes | `CATEGORY_SOCIAL` for social platforms, but also catches productivity/app-tool notifications (Slack, Notion, Calendly, GitHub, etc.) that Gmail often files under `CATEGORY_UPDATES` instead — classify these in via sender/subject pattern, not label alone |
| 3 | Newsletter/Forum Digest | Yes | `CATEGORY_FORUMS`, plus pure-newsletter `CATEGORY_UPDATES` mail (subject patterns like "X Daily/Weekly Digest") |
| 4 | Receipt/Order/Shipping | **Never** | Mostly `CATEGORY_UPDATES` — needs real sender/subject sub-classification, see caveat below |
| 5 | Financial/Legal/Security | **Never** | Mostly `CATEGORY_UPDATES` — same caveat |
| 6 | Personal Correspondence | **Never** | `CATEGORY_PERSONAL`, or individual-looking sender with no category label, or `Re:`/`Fwd:` subject prefix (strong human-thread signal even if Gmail mislabeled it) |
| 7 | Other/Uncertain | **Never** | Doesn't confidently fit above |

`CATEGORY_UPDATES` is a grab-bag (receipts, bank alerts, security notices, and app
notifications all land there) — treat it as "needs real classification," never map
it directly to one coarse category. `CATEGORY_PROMOTIONS` already encodes signals
like `List-Unsubscribe` internally; don't add a separate header-fetch step to
re-derive that.

**Ambiguous after metadata alone → Other/Uncertain, no fallback body fetch.**
Rejected outright for v1: the metadata already in hand is sufficient for the
overwhelming majority of bulk/automated mail this skill targets, and a genuinely
ambiguous case is more likely to be exactly the "look at this yourself" case that
should stay conservative anyway. If Other/Uncertain turns out surprisingly large in
practice, that's a signal to revisit, not a reason to pre-build the complexity.

**Other/Uncertain's default label proposal**: a top-level `Filtered Stuff/_later`-style
label ("needs a second look," already reversible) is a near-perfect semantic match —
*if the live Step 6 fetch still contains a label like that*, propose it by default
rather than inventing a new "needs review" label. If it's gone (renamed, deleted,
never existed on this account), fall through to proposing a new one — never assume
it's there because it's named here.

**Institution/merchant-specific matching**: accounts that already file shopping or
financial mail by merchant (e.g. a `Filtered Stuff/Shopping/<Retailer>` per retailer,
or `Filtered Stuff/Financial/<Institution>` alongside a generic
`Filtered Stuff/Important Stuff/Financial` catch-all) establish a pattern worth
matching. When a sender clearly identifies a specific institution/merchant, check
the live Step 6 fetch for a label specific to that institution first; propose it if
found. Fall back to a generic existing label only when no specific one exists, and
to a brand-new label only when neither does.

**Cluster derivation** (the finer per-run grouping that becomes the actual label):
key on the identifiable business/entity — display name or full address — not raw
domain. A receipt from "Vadoo Internet Services Private Limited" can route through
`@stripe.com`; domain-only clustering would wrongly lump every Stripe-invoiced
merchant into one "Stripe" cluster. Fall back to domain only where domain *is* the
identity (e.g. `facebookmail.com`, `linkedin.com`). In the confirmation display,
lump low-volume (1-2 message) senders within a coarse category into one
"Misc / low-volume senders" line so the screen stays scannable.

**Low-volume clusters share one label per category, not a bespoke label each.**
Confirmed against a real run: a fresh/active inbox can produce dozens of one-off
senders in a single wave, and a bespoke new-label proposal for each is unworkable
at that scale. Default: when a cluster has **no existing-label match** and **1-2
messages this wave**, don't propose a new label just for it — fold it into one
shared catch-all label per coarse category (e.g. one new label covering every
unmatched one-off Promotional/Marketing sender this wave, a separate one for
Social/App Notification, etc.). Reserve individual label proposals for (a) a
cluster with a clear existing-label match, or (b) a cluster with real volume this
wave (3+ messages). The catch-all is just another Step 4 cluster as far as Step 6
is concerned — cache and reuse it across waves in the run like any other
resolution, don't recreate it per wave.

## Step 5 — Safe-to-delete rule set (deterministic, all conditions must hold)

1. Coarse category ∈ {Promotional/Marketing, Social/App Notification,
   Newsletter/Forum Digest}. Absolute allowlist — Receipt/Financial/Personal/
   Uncertain are **permanently excluded from deletion** regardless of any other
   signal (sender pattern, anything). If old receipts should go, that's an
   explicit free-form override per run (Step 7), never a default.
2. Not `STARRED`, not `IMPORTANT`.
3. Sender looks automated (no-reply/donotreply/notifications/mailer/news/info
   local-part patterns).
4. Subject matches none of these (case-insensitive): invoice, receipt, order,
   confirmation, statement, tax, legal, security, verify, password, login, refund,
   warranty, ticket, itinerary, insurance, contract, medical, prescription,
   appointment, renewal, subscription, suspended, unauthorized, fraud, chargeback,
   lawsuit, court, IRS, boarding pass, two-factor, 2FA, one-time code, action
   required, expiring, expires.
5. No attachments present.
6. Subject does not start with `Re:` or `Fwd:` (near-free extra guard — catches a
   promotional-*labeled* thread a human actually replied to).

Any single condition failing → not a delete-candidate → falls through to
archive+label. Never delete on uncertainty. Trash's ~30-day recovery window is a
backstop, not a reason to be less careful up front.

**Starred/Important messages: excluded from both deletion *and* archiving by
default** — left completely untouched in the inbox. Archiving wouldn't unstar them
(Gmail's Starred/Important views are independent of inbox membership) — but "I
starred/flagged this, don't move it without asking" is the safer, less-surprising
default. Easy to override per-run if starred promo/social mail should still get
archived+labeled like everything else.

## Step 6 — Resolve labels (the "ask per run" mechanism)

**Every label name anywhere in this file — `_later`, the Shopping/Financial
examples in Step 4, the mock-up in Step 7 — is illustrative only, never
authoritative.** They describe a pattern (a reversible catch-all, per-merchant
filing) or an account snapshot from whenever this doc was last touched, not a
cache to trust. The live fetch below is the only source of truth for what labels
exist right now. A name mentioned in this file that isn't in that live result does
not exist on this account — propose creating it like any other new label, never
assume it's there.

At run start, right after the auth check: `gog gmail labels list --json` **once**,
cached for the whole run; append newly-created labels to that in-memory list as they
are created rather than re-fetching.

**Ask once per distinct cluster, the first time it's seen in the run; cache the
resolution; reuse it transparently (shown, not hidden) on repeat; allow override
again via free-form reply in any later wave.** Do not ask every wave regardless of
repeats (pure friction, no new information), and do not ask once for all clusters
up front (requires an expensive full-scope pre-scan before any wave can start,
undermining the whole wave-based design). Cluster identity for caching = the
sender/business-identity key from Step 4.

This caching needs **zero persistence** — an entire multi-wave run happens in one
continuous conversation, so "remember what was decided earlier this run" is just
conversational memory. Cross-*run* persistence (never re-ask about a sender again,
even next week) is out of scope.

There is no hard-coded taxonomy→label mapping in this skill. Every proposal is
generated at run time and confirmed before anything is applied.

## Step 7 — Confirm (per wave)

Show grouped counts, not per-message detail:

```
Wave N: processing 500 of ~1,842 unread inbox messages (newest first)

DELETE CANDIDATES (142) — moved to Trash, recoverable ~30 days:
  • Promotional/Marketing — "Weekly deals" cluster (89, e.g. "50% off ends
    tonight" from deals@retailer.com, 2026-04-02..2026-06-30)
  • Social/App Notification — "Facebook updates" cluster (53, e.g. "X was
    at Y" from friendupdates@facebookmail.com)

ARCHIVE + LABEL (358):
  • Amazon order confirmations (61) → Filtered Stuff/Shopping/Amazon [existing]
  • LinkedIn notifications (47) → Filtered Stuff/Websites/LinkedIn [existing]
    (using label confirmed earlier this run)
  • "Acme SaaS" product updates (33) → Filtered Stuff/Companies/Acme SaaS [NEW]
  • Financial/Legal/Security (19) → Filtered Stuff/Important Stuff/Financial [existing]
  • Personal Correspondence (14) → Filtered Stuff/... [existing/ask]
  • Other/Uncertain (12) → Filtered Stuff/_later [existing]

LEFT UNTOUCHED (starred/important): 6

Reply "yes" to proceed as shown, edit any line ("don't delete the Facebook
cluster, just archive it" / "also delete anything from spam@x.com" / "leave
Personal Correspondence in the inbox"), or "stop" to end here.
```

Give Financial/Legal/Security and Personal Correspondence groups slightly more
visual prominence than routine notification clusters — higher-stakes categories
where "wait, why did that get archived" is a plausible reaction. Presentation-only —
doesn't change the rule that non-deleted mail is archived+labeled.

**Free-form overrides are required, not optional:**

- Edit that doesn't expand deletion scope (re-bucket delete→archive, rename a label,
  skip a cluster) → apply and proceed, echoing what changed.
- Edit that *expands* deletion beyond what was shown (a new criterion like "also
  delete anything from spam@site.com") → a light, scoped re-confirm on just the
  delta, not a full wave re-display.
- Anything ambiguous → ask for clarification rather than guess on a destructive
  action.

**Permanent-delete escape hatch**: if the user says something like "permanently
delete X" mid-run, route that subset to `batch delete` instead of `trash`, gated
behind a stronger confirmation phrase ("yes, permanently delete") so a casual "yes"
meant for the rest of the wave can't trigger it accidentally.

## Step 8 — Execute (per confirmed wave)

Order: create any newly-approved labels first (verify each `labels create` call
succeeded **before** any `batch modify` chunk references it — if creation fails or
is unverified, abort that chunk and report clearly rather than silently skipping) →
trash delete-candidates in ~100-ID chunks → `batch modify` for everything else,
~100 IDs per chunk **per resolved-label group** (if one label covers 500 messages in
a wave, that's 5 separate calls with different ID sub-lists, not one 500-ID call).

**Exactly two execution primitives**:

- `gog gmail trash <id1> <id2> ... --force --account=jeremyasuncion808@gmail.com`
  (or `batch delete` for an explicit permanent-delete override) for
  delete-candidates.
- `gog gmail batch modify <id1> <id2> ... --add=<Label> --remove=INBOX --force --account=jeremyasuncion808@gmail.com`
  for everything else — combines archive+label in one call per group, since
  `--remove=INBOX` *is* Gmail's definition of archiving.

**Use `batch modify` (message-level) exclusively — never `labels modify` or
`thread modify` (both thread-level).** If a thread contains a message outside this
wave's categorization (e.g. a reply that arrived later), a thread-level call would
silently relabel/archive that sibling message too. The standalone `archive` command
is likewise unused in the default flow.

~100 IDs per chunk keeps calls safely inside shell arg-length limits and gives
partial-chunk failures an easy, legible recovery story. Both `trash` and label
add/remove are idempotent, so a simple "retry a failed chunk once, then surface to
the user" policy is safe.

## Explicit boundaries (do not "helpfully" add these later)

- No read/unread side effects, ever, in the default flow — `batch modify --add=X
  --remove=INBOX` never touches `UNREAD` unless a call explicitly includes it,
  which the default flow never does.
- No permanent delete by default — `trash` only, unless explicitly invoked per-run
  with the stronger confirmation phrase.
- No sending email, ever — rule #3's `send` clause is untouched.
- No cross-run persisted state.

## Resumability

Archiving removes `INBOX`; trashing removes messages from `in:inbox` entirely — so
any `in:inbox`-scoped query naturally shrinks as waves complete. A later re-run,
interrupted or not, only sees what's left; zero extra state-tracking needed. This
also covers partial execution failure mid-wave: if `trash` succeeds but a `batch
modify` chunk fails partway, the already-done portion is safe (idempotent), and the
unfinished label-group's messages just sit in the inbox, unrelabeled, until the next
run's fresh categorization picks them up.

## Report + loop

End every wave with counts trashed / archived+labeled per group and any errors, then
an explicit go/no-go before the next wave's fetch — never auto-chain waves silently.
The per-wave confirmation already provides a natural stop point at any time.
