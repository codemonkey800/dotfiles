---
name: bruh
description: |
  Communication style for explanations, planning docs, design docs, summaries, and
  code walkthroughs — bullets over walls of text, plain language without losing
  precision, real code samples, and mermaid diagrams for anything with structure or
  flow. Use when explaining how something works, walking through a plan or design,
  summarizing findings or a codebase, writing a plan/PRD/runbook/README, or when the
  user says "explain", "walk me through", "how does X work", "write a plan", "bruh",
  "keep it readable", "too long", "tl;dr", "simpler", or "make this easier to follow".
user-invocable: true
argument-hint: "[optional topic — e.g. 'how auth works', 'plan for the migration', 'redo that last answer']"
---

# bruh

Make it readable. Optimize for the reader skimming first and reading second — without
sanding off the details that actually matter.

Applies to chat responses, planning docs, design docs, PRDs, runbooks, READMEs, code
comments, PR descriptions, and commit bodies.

## The rules

**Structure**

- Paragraphs max ~3 lines. If it's longer, it's a list.
- Bullets for anything enumerable: steps, options, trade-offs, findings, gotchas.
- Headers every ~10 lines in a doc, so it's skimmable without reading.
- Nest at most 2 levels deep. Deeper means the outline is wrong.
- **Bold the key term**, not the whole sentence. Bold everything = bold nothing.
- Lead with the answer. Context after, not before.

**Language**

- Plain words. "Use" not "utilize", "so" not "in order to".
- Define jargon inline the first time: "a bloom filter (a probabilistic 'have I seen
  this?' check that can false-positive but never false-negative)".
- Don't hedge in layers. One caveat, stated once, where it's relevant.
- Simple ≠ vague. If the detail changes what someone does, keep it.

**Code**

- Show the snippet instead of describing it. A 4-line example beats a paragraph.
- Minimal but real — no `foo`/`bar` when actual names from the codebase exist.
- Reference existing code as `path/to/file.ts` rather than pasting it wholesale.
- Comment only the non-obvious line.

**Diagrams**

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

## Anti-patterns

- **The wall** — six dense paragraphs where a 6-item list was sitting right there.
- **Bullet soup** — 20 flat bullets with no grouping. Add headers or cut.
- **Diagram theater** — a mermaid chart for a linear 3-step process.
- **Restating the question** — "Great question! You're asking about X." Just answer.
- **Padding** — "It's worth noting that", "As you may know", "In essence".
- **Over-hedging** — "might possibly, in some cases, depending". Commit or say you
  don't know.
- **Summary of the summary** — closing paragraph that repeats the bullets above it.

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

## Calibration

Match effort to the question.

- Quick factual question → answer in a sentence. Don't build scaffolding around it.
- "How does X work" → short prose + diagram or bullets.
- "Write a plan / design this" → full doc structure above.

The goal is fewer words carrying the same meaning — not a formatting ritual applied to
everything.
