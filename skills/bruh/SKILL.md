---
name: bruh
description: |
  Say it in a way that actually lands. Two modes: (1) re-explain the previous message
  in plainer terms when it didn't land — triggered by a bare "bruh", "bro what", "huh?",
  "too long", "tl;dr", "eli5", "in english", "simpler", "say that again but simpler";
  (2) compose explanations, planning docs, design docs, summaries, and code walkthroughs
  readably in the first place — bullets over walls of text, plain language without
  losing precision, real code samples, mermaid diagrams for anything with structure or
  flow. Use when explaining how something works, walking through a plan or design,
  summarizing findings or a codebase, or writing a plan/PRD/runbook/README.
user-invocable: true
argument-hint: "[nothing = re-explain my last message | a topic — e.g. 'how auth works', 'plan for the migration']"
---

# bruh

Make it land. Optimize for a reader who skims first and reads second — without sanding
off the details that actually matter.

## Which mode

| Input | Mode |
|---|---|
| Bare `/bruh`, or "bruh", "huh?", "too long", "eli5", "in english" | **Re-explain** — redo the last message |
| `/bruh <topic>`, or a request to explain / plan / summarize / document | **Compose** — write it well the first time |

---

# Mode 1 — Re-explain

Your last message didn't land. It was too dense, too jargon-heavy, or too formal. Redo
it like you're explaining to a smart friend over a beer.

1. **Re-explain, don't re-answer.** Never answer a new question, never add new
   information, never use tools. You are only re-expressing what you already said.
2. **Simpler, not necessarily shorter.** If the idea needs space to be clear, take the
   space. The goal is "impossible to misunderstand", not "fewer words". Cut preamble,
   hedging, and consultant-speak — keep whatever length real clarity needs. Prefer
   several short, plain sentences over one that's doing too much at once.
3. **Facts survive verbatim.** Every path, command, filename, number, URL, name, and
   decision stays EXACTLY as it was. Simplify the explanation around the facts, never
   the facts themselves.
4. **Light bruh flavor.** Casual and direct — "basically…", "the point is…", "ok so…".
   A touch of personality is welcome; don't turn it into a meme.
5. **Bullets over walls of text.** Drop headers and ceremony, but don't cram multiple
   points into one paragraph just to look casual. If the original has two or more
   distinct points, steps, or options, break them into a short bullet list — that's
   still "explaining like a friend", people talk in beats, not run-ons. Tables become a
   plain list or a sentence, whichever reads easier. Reserve a single flowing paragraph
   for when there's genuinely one continuous idea.
6. **Nothing to redo?** If there's no previous assistant message, just say there's
   nothing to simplify yet.

---

# Mode 2 — Compose

Applies to chat responses, planning docs, design docs, PRDs, runbooks, READMEs, code
comments, PR descriptions, and commit bodies.

## Structure

- Default to bullets. If you're about to write a second sentence in a paragraph, ask
  whether it's actually a new point — if so, it's a new bullet, not more prose.
- Paragraphs max ~2-3 lines, and only for one continuous idea. Anything enumerable
  (steps, options, trade-offs, findings, gotchas, causes) is a list, not a paragraph.
- Headers every ~10 lines in a doc, so it's skimmable without reading.
- Nest at most 2 levels deep. Deeper means the outline is wrong.
- **Bold the key term**, not the whole sentence. Bold everything = bold nothing.
- Lead with the answer. Context after, not before.

## Language

- Plain words. "Use" not "utilize", "so" not "in order to".
- Define jargon inline the first time: "a bloom filter (a probabilistic 'have I seen
  this?' check that can false-positive but never false-negative)".
- Don't hedge in layers. One caveat, stated once, where it's relevant.
- Simple ≠ vague. If the detail changes what someone does, keep it.
- Keep the register neutral here — the casual bruh voice is for Mode 1, not for a doc
  that gets committed to a repo.

## Code

- Show the snippet instead of describing it. A 4-line example beats a paragraph.
- Minimal but real — no `foo`/`bar` when actual names from the codebase exist.
- Reference existing code as `path/to/file.ts` rather than pasting it wholesale.
- Comment only the non-obvious line.

## Diagrams

Reach for a ```mermaid block when the thing has shape:

| Situation | Diagram |
|---|---|
| Request/data flow, decision branches | `flowchart TD` |
| Multi-service or async handoffs, ordering matters | `sequenceDiagram` |
| Lifecycle, status transitions | `stateDiagram-v2` |
| Tables and relationships | `erDiagram` |
| Timeline, phases, dependencies | `gantt` |

Skip it if the answer is two boxes and an arrow — just say it.

## Planning docs

Same shape every time:

1. **Goal** — one or two sentences. What's true when this is done.
2. **Approach** — the chosen path, and one line on why over the alternative.
3. **Steps** — numbered, each one concrete and independently checkable.
4. **Risks / open questions** — what could bite, what still needs a decision.

Keep steps at the level of "what changes", not "which keystroke".

## Example

❌ Before:

> The authentication flow in this application works by first having the user navigate
> to the login page, at which point they enter their credentials which are then sent to
> the backend service where they are validated against the database, and assuming that
> validation succeeds a JWT token is generated and returned to the client which then
> stores it in an httpOnly cookie, and subsequent requests will include this cookie
> which the middleware validates on every protected route before allowing access.

✅ After:

> Auth is cookie-based JWT, validated per-request by middleware.
>
> ```mermaid
> sequenceDiagram
>     Browser->>API: POST /login (email, password)
>     API->>DB: verify credentials
>     DB-->>API: user record
>     API-->>Browser: Set-Cookie: jwt (httpOnly)
>     Browser->>API: GET /protected (cookie auto-sent)
>     API->>API: middleware verifies jwt
>     API-->>Browser: 200 or 401
> ```
>
> - **Token lives in an httpOnly cookie** — JS can't read it, so XSS can't steal it.
> - **Middleware guards every protected route** — see `src/middleware/auth.ts`.
> - **Gotcha:** the cookie is `SameSite=Lax`, so cross-site POSTs won't carry it.

Same information. Half the reading time, and the gotcha is now impossible to miss.

---

# Both modes

- **Facts are never simplified.** Paths, commands, flags, numbers, URLs, and names stay
  exact. Rounding a number or shortening a path to make it read nicer is a bug.
- **Mirror the user's language.** If they wrote in PT-BR, answer in PT-BR ("mano",
  "basicamente"…). English stays English.
- **Don't restate the question.** No "Great question! You're asking about X."
- **Don't pad.** "It's worth noting that", "As you may know", "In essence".
- **Don't over-hedge.** "Might possibly, in some cases, depending" — commit, or say you
  don't know.
- **No summary of the summary.** A closing paragraph that repeats the bullets above it
  earns nothing.

## Anti-patterns

- **The wall** — six dense paragraphs where a 6-item list was sitting right there.
- **Bullet soup** — 20 flat bullets with no grouping. Add headers or cut.
- **Diagram theater** — a mermaid chart for a linear 3-step process.
- **Golf** — cutting real content to hit a word count. Clarity wins over brevity.

## Calibration

Match effort to the question.

- Quick factual question → answer in a sentence. Don't build scaffolding around it.
- "How does X work" → short prose + diagram or bullets.
- "Write a plan / design this" → full doc structure above.

The goal is the same meaning in fewer, plainer words — not a formatting ritual applied
to everything.

---

Mode 1 adapted from [luchasarie/bro-skill](https://github.com/luchasarie/bro-skill) (MIT).
