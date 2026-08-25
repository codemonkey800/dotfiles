# reddit-fetch playbook

Full operational reference for `~/dev/reddit-fetch`. SKILL.md carries the happy path —
command shape, the rare-token rule, the smoke test. Read this file on your first
invocation of a session, or when a run misbehaves.

## Why this tool exists

WebSearch, WebFetch, and general-purpose web-research subagents consistently fail to
surface indexed Reddit threads. This is not a minor gap: in prior recipe-app research,
the web pass flagged Reddit evidence as "the real weak spot" it could not verify, and
running reddit-fetch afterward surfaced concrete threads, real user quotes, and **nine
competitor products no web search had found** — mostly founders self-promoting in comment
replies, which never gets indexed the way blog posts do.

Use this tool for the Reddit portion. Do not substitute a web search.

## Invocation

Not globally installed. The only entry point is the bash wrapper:

```bash
~/dev/reddit-fetch/reddit-fetch <flags>
```

The wrapper `cd`s to its own directory and `exec`s `pnpm start`, so it works by absolute
path from any cwd. **The consequence: a relative `-o` path resolves against the tool
repo, not your shell's cwd.** Always pass an absolute `-o`.

## Flags — the complete surface

One flat command. No subcommands. Bare positional arguments throw.

| Flag | Short | Default | Limits |
|---|---|---|---|
| `--subreddit` | `-s` | *required* | Name without the `r/` prefix |
| `--query` | `-q` | *required* | Free text |
| `--limit` | `-l` | 10 | Max 100 |
| `--comment-limit` | | 10 | Max 100. `0` is legal but saves no time — it still loads every post page |
| `--out` | `-o` | stdout | Always pass an absolute path |
| `--help` | `-h` | | Prints usage to stderr |

Exit codes: `0` success · `2` missing a required flag · `1` runtime error.

stdout is pure JSON; stderr is progress noise (`Authenticated as u/…`, `Searching r/X…`).
Pipe-safe. Never parse stderr.

## Output shape

```json
{
  "subreddit": "Cooking",
  "query": "recime",
  "fetched_at": "2026-08-02T23:12:47.549Z",
  "posts": [{
    "id": "1e1k4g0",
    "title": "Good (cheap) recipe app?",
    "score": 28,
    "author": "Bandit595",
    "permalink": "/r/Cooking/comments/1e1k4g0/good_cheap_recipe_app/",
    "url": "https://www.reddit.com/r/Cooking/comments/1e1k4g0/good_cheap_recipe_app/",
    "created_utc": 1720797232,
    "num_comments": 64,
    "selftext": "Hi, I saw an app called ReciMe that seems able to…",
    "top_comments": [{ "author": "[deleted]", "body": "[deleted]", "score": 7 }]
  }]
}
```

Notes that matter when analyzing:

- `created_utc` is a Unix epoch **number** in seconds. All time filtering is client-side.
- `num_comments` is Reddit's *total*, far larger than `top_comments.length` (64 vs 7 above).
- `selftext` is `""` for link posts.
- Deleted content arrives literally as `"[deleted]"` in both `author` and `body`. Filter it.
- Comments are flat — exactly three keys, no nesting, no ids, no replies.

## Hard limits and their workarounds

| Limit | Why | Workaround |
|---|---|---|
| One subreddit per call | `restrict_sr=on` hardcoded | Loop invocations, merge the JSON |
| `sort=top`, all time, no time filter | Hardcoded; no `t=` param sent | Filter `created_utc` post-hoc. **This is also the source of the all-time-top trap** |
| No listing endpoint | Only `/search.json` is used | You cannot get "hot in r/X" without a query |
| Top-level comments only | `depth=1` hardcoded; `more` nodes dropped | Accept it; follow the permalink manually if a thread looks pivotal |
| Comment sort fixed to top | Hardcoded | Accept it |
| Cannot fetch a post by id or URL | No such flag | Craft a query that surfaces it |
| Cannot fetch a user's posts | Not supported | n/a |

## The all-time-top trap

Documented in SKILL.md Stage 3 with the measured evidence. Restating the mechanism
because it is the single biggest source of bad output:

`sort=top` with no time filter, plus loose OR-matching, means a query composed only of
words common inside the target subreddit matches thousands of posts and returns that
subreddit's greatest hits. The failure is silent — the JSON looks fine.

Always run the smoke test:

```bash
jq -r --arg t "<rare-token-lowercased>" \
  '[.posts[] | ((.title + " " + .selftext + " " + ([.top_comments[].body] | join(" ")))
    | ascii_downcase | contains($t))] | "hits=\(map(select(.)) | length)/\(length)"' <file>
```

Ground truth for verifying the expression still works, using the saved files in
`~/dev/reddit-fetch/data/`:

| File | Token | Expected |
|---|---|---|
| `q1_cooking_extractor.json` | `extractor` | `hits=0/8` — trap |
| `q2_cooking_tiktok.json` | `tiktok` | `hits=2/8` — trap |
| `q3_recime.json` | `recime` | `hits=8/8` — clean |

## jq recipe library

**Triage — titles, scores, dates only.** Run this before reading anything else:

```bash
jq -r '.posts[] | "\(.score)\t\(.num_comments)\t\(.created_utc|todate[:10])\t\(.title)"' <f> | sort -rn
```

**Pull one post in full, dropping deleted comments:**

```bash
jq '.posts[] | select(.id=="<id>") | {title, selftext, created: (.created_utc|todate[:10]),
  top_comments: [.top_comments[] | select(.body != "[deleted]") | {author, score, body}]}' <f>
```

**Recency split at 24 months:**

```bash
jq --argjson c "$(( $(date +%s) - 730*86400 ))" \
  '{recent: [.posts[] | select(.created_utc > $c)] | length, total: (.posts | length)}' <f>
```

**Harvest product-name candidates from comment bodies** — the technique that found nine
competitors. Capitalized tokens in comments are disproportionately product names:

```bash
jq -r '.posts[].top_comments[].body' <f> \
  | grep -oE '\b[A-Z][a-zA-Z]{2,}[a-zA-Z0-9]*\b' \
  | sort | uniq -c | sort -rn | head -40
```

Eyeball the output — it will contain ordinary sentence-initial words alongside real
product names. The real ones repeat across multiple posts.

**Merge per-subreddit files after a loop:**

```bash
jq -s '{query: .[0].query, results: [.[] | {subreddit, posts}]}' /tmp/validate-idea/<slug>-*/*.json
```

**Context discipline.** Saved payloads range 26KB-344KB; the 344KB file is roughly 90K
tokens. Never let raw output reach the context window — always `-o` to a file, triage,
then pull only what you need.

## Auth and session handling

No API keys and no environment variables. Auth is a persisted Playwright Chromium profile
at `<repo>/chrome/profile/`, detected via the `token_v2` / `reddit_session` cookies plus
an in-page `/api/v1/me` check. Launches with `--disable-blink-features=AutomationControlled`
and a macOS Chrome user agent.

**Healthy path:** fully headless, no interaction.

**Expired session:** opens a *visible* Chromium at reddit.com/login and polls for up to
**5 minutes** waiting for a human. An unattended run hangs, then throws.

Mitigation is the preflight probe in SKILL.md Stage 4 — `-l 1 --comment-limit 0` called
with the Bash tool's `timeout: 60000`. Healthy is under 20s, so a timeout means a login
window is open. Tell the user; offer to wait or to degrade to web-only.

**`"Login completed but session was not detected on relaunch"`** — the profile is
corrupt. The fix is destructive, so ask before running it:

```bash
rm -rf ~/dev/reddit-fetch/chrome/
```

Then retry; the next run will prompt for a fresh login.

**`GET <url> → non-JSON response (likely a bot challenge)`** — Reddit is challenging the
session. Stop Reddit work immediately. Do not retry-loop: retries deepen the challenge.
Proceed with whatever was already gathered and record the gap in the coverage footer.
Partial evidence, honestly labeled, beats a stalled run.

## Performance

Measured from file mtimes on three consecutive prior runs (16:11:53 / 16:12:23 /
16:12:47): **24-30s per invocation** at `-l 10`, roughly 3s per navigation across 9
navigations (1 search + 8 posts), plus ~15s auth probe on the first run of a session.

An 8-invocation budget is 4-5 minutes. Announce it before running.

Built-in retry on 429 and 503: 5 attempts with exponential backoff from 4s
(4→8→16→32→64), so a single unlucky URL can absorb ~124s. Any other status ≥400 throws
immediately with no retry.

**Never raise concurrency.** `CONCURRENCY = 1` is hardcoded and the repo's own CLAUDE.md
notes that raising it "has historically triggered bot challenges." All invocations share
one persistent browser profile directory; concurrent runs contend on it.

## Expect shortfall

Requesting `-l 10` typically returns 8 posts. Requesting `--comment-limit 10` returned
exactly 6 in two of three prior runs, because Reddit's comment `limit` counts all nodes
including nested ones and the parser then discards everything that is not a top-level
`t1`. Neither is an error — do not retry on a short result.

`data/` in the tool repo is not auto-created. Irrelevant if you write to
`/tmp/validate-idea/`, which is the recommendation anyway — it keeps the tool repo clean.
