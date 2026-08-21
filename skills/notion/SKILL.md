---
name: notion
description: |
  Read and write Notion via the local `ntn` CLI — search pages, read a page as Markdown,
  create/edit pages, query databases, upload files, and call any Notion API endpoint. Use
  when the user says "notion", "my notes", "my notion page", "notion database", "my tasks
  in notion", asks to look something up in or save something to Notion, or pastes a
  notion.so / app.notion.com URL. This is the authenticated `ntn` binary on this machine
  (NOT the `notion` command, which does not exist, and not the Notion MCP server) — prefer
  it over any Notion MCP tool when both are available.
user-invocable: true
argument-hint: "[optional task — e.g. 'find my Projects database', 'add a note about X', 'what's in my Shopping page']"
---

# Notion

Drive Notion from the shell through **`ntn`** — a single authenticated binary that covers
pages, databases, files, and the entire public API.

## Input

<task> #$ARGUMENTS </task>

Empty `<task>` → ask what to do in Notion, then proceed. Otherwise resolve `<task>`
against the [task map](#task-map) below.

---

## The two things that break this

Read these before running anything. They are the difference between this skill working
and a hung or unusable tool call.

### 1. The binary is `ntn`, not `notion`

`notion` is `command not found`. Every command in this skill starts with `ntn`.

### 2. Three commands block or flood

| Trap | Why it breaks | Rule |
|---|---|---|
| `ntn pages create` / `ntn pages edit` with **no content source** | Opens `$VISUAL` / `$EDITOR` / `vi` and waits forever | **Always** pass `--content '…'` or pipe stdin (`< file.md`) |
| `ntn pages trash <id>` | Prompts for confirmation | **Always** pass `--yes` (after confirming with the user) |
| `ntn api … --spec` / `--docs` | 26–116 KB and 40–172 KB of OpenAPI/markdown per endpoint — `v1/pages POST` alone is 109 KB / 172 KB | Never dump unfiltered. Use `ntn api <path> --help` (~23 lines) or pipe through `jq` / `grep` |

---

## Preflight

One call confirms binary, config, workspace, token, and both API surfaces:

```bash
ntn doctor
```

Expect **7 passed**: CLI version, Config, Default workspace, Resolved workspace, Token
source, Workers access, Public API access.

- Any check fails → `ntn login`, then re-run `ntn doctor`.
- **Do not run `ntn update`.** Upgrading the CLI is the user's call, not a side effect of
  answering a question.

Skip preflight for a quick read when the CLI has already worked this session.

---

## Task map

| Intent | Command |
|---|---|
| Find a page by title | `ntn api v1/search query=<text> page_size:=10` |
| List databases / data sources | `ntn api v1/search 'filter[property]=object' 'filter[value]=data_source' page_size:=20` |
| Read a page | `ntn pages get <id>` — Markdown with frontmatter |
| Create a page | `ntn pages create --parent page:<id> --content '# Title\n\nBody'` |
| Replace a page body | `ntn pages edit <id> --content '…'` or `ntn pages edit <id> < file.md` |
| Query a database | `ntn datasources query <id-or-url> --limit N [--filter JSON] [-s 'Prop desc']` |
| Database with several sources | `ntn datasources resolve <database-id>` first, then query one |
| Trash a page | `ntn pages trash <id> --yes` |
| Upload a file | `ntn files create < f.png` or `ntn files create --external-url <https-url>` |
| Who am I / which workspace | `ntn whoami` |
| **Anything else** | `ntn api` → read `reference/api.md` |

`ntn api` is the escape hatch and it is complete — page properties, block trees,
comments, users, and every other endpoint live there. When the table above doesn't cover
the task, **read `reference/api.md`** rather than guessing at flags.

### IDs and URLs

`datasources query` accepts a data source ID, a database ID, **or a Notion URL** — hand it
a pasted URL directly. `pages get` / `edit` / `trash` want a page ID; the 32-hex tail of a
Notion URL is that ID, with or without dashes.

---

## Reading

```bash
# Search — returns one compact JSON line, so always pipe to jq
ntn api v1/search query=Shopping page_size:=5 \
  | jq -r '.results[] | "\(.id)\t\(.properties.title.title[0].plain_text // .title[0].plain_text // "?")"'

# Read a page as Markdown
ntn pages get 9c438cac-7393-4f3d-9f55-54166da38352

# Query a database, JSON so property names survive
ntn datasources query <data-source-id> --limit 10 --json \
  | jq -r '.results[] | .properties.Name.title[0].plain_text'
```

**Use `--json` whenever property names matter.** The default (and `--plain`) output is
headerless TSV: column 1 is the page ID, then **properties in alphabetical order** with no
labels. On a real Projects database that puts `Name` in column 6, behind `Created`,
`Description`, `Health`, and `Last Updated` — positional parsing of that is a bug waiting
to happen.

`/v1/search` matches **titles only**, never page body text. If a title search comes up
empty, the content may still exist — query the containing database, or ask the user where
it lives, rather than concluding it isn't there.

---

## Writing

### Round-trip edit — the safe way to change part of a page

`ntn pages edit` **replaces the entire page body**. To change one line, read → modify →
write back. `pages get` output is valid `pages edit` input (edit strips the leading
frontmatter block), so the round trip is lossless:

```bash
ntn pages get <id> > /tmp/page.md
# edit /tmp/page.md — keep everything you aren't changing
ntn pages edit <id> < /tmp/page.md
```

Never hand-write a `--content` replacement for a page you haven't read. That silently
deletes every block you didn't happen to retype.

### Creating

```bash
ntn pages create --parent page:<id> --content '# Weekly Notes

- first item
- second item'
```

`--parent` takes `page:<id>`, `database:<id>`, or `data-source:<id>`, and is optional —
omitting it creates a private top-level page, which is rarely what the user meant. **Ask
where the page should live** unless the task already says.

On create, a frontmatter `title` sets the page title and **every other frontmatter
property is silently ignored** — no error, no warning. Real database properties need a
follow-up:

```bash
ntn api -X PATCH v1/pages/<id> 'properties[Status][select][name]=In Progress'
```

The type key (`select` above) must match the schema — a property named "Status" is often
type `select`, not `status`. Check before writing:
`ntn datasources query <ds-id> --limit 1 --json | jq '.results[0].properties | map_values(.type)'`

### Confirm before writing

This is a **real personal workspace**, not a scratch environment. Confirm with the user
before:

- `pages edit` — replaces the whole body
- `pages trash`
- any `-X PATCH` / `-X DELETE` / `-X POST` through `ntn api` that mutates
- `--allow-deleting-content` on an edit — this lets the edit destroy **child pages and
  databases**. Never pass it casually; name what could be lost first.

No confirmation needed for reads: `search`, `pages get`, `datasources query`,
`datasources resolve`, `files get`/`list`, `whoami`, `doctor`.

Report the page URL after any successful write so the user can check it.

---

## Gotchas

Verified against `ntn` v0.22.8 on this machine.

| # | Gotcha | Rule |
|---|---|---|
| 1 | Binary is **`ntn`** — `notion` is `command not found` | Every command starts with `ntn` |
| 2 | `--spec` is 26–116 KB and `--docs` is 40–172 KB **per endpoint** (`v1/pages POST`: 109 KB / 172 KB) | Use `ntn api <path> --help` (~23 lines) or filter through `jq`/`grep`. Never dump raw |
| 3 | `ntn api` emits **one compact JSON line** | Always pipe to `jq` |
| 4 | Default and `--plain` output is **headerless TSV** — id, then properties **alphabetically**, unlabeled | Use `--json` whenever property names matter; never parse TSV positionally |
| 5 | `pages edit` **replaces the entire page body** | Round-trip through `pages get` for partial edits |
| 6 | `--allow-deleting-content` lets an edit destroy child pages and databases | Never pass casually; confirm what's at risk first |
| 7 | On `pages create`, frontmatter `title` sets the title; **all other frontmatter is silently ignored** | Set real properties with `-X PATCH v1/pages/<id>` |
| 8 | `/v1/search` matches **titles only**, not body text | Empty result ≠ doesn't exist; query the database instead |
| 9 | `v1/users` → `403 restricted_resource: Personal access tokens cannot list users` | Use `ntn whoami` |
| 10 | `ntn files list` returns **only the first page** — pagination not implemented | Don't treat its output as complete |
| 11 | `datasources query` needs a **data source**; a database can hold several. `resolve` given a *data source* ID 404s (with a helpful hint) | `ntn datasources resolve <database-id>` to list sources; query takes IDs or URLs directly |
| 12 | `pages trash` prompts; `pages create`/`edit` open `$EDITOR` with no content source — **both hang a non-interactive call** | `--yes` on trash; `--content` or stdin on create/edit |
| 13 | `ntn pages --help` claims `NOTION_API_TOKEN` is "required today" — **stale**. Saved keychain credentials work | Ignore it; trust `ntn doctor` |
| 14 | `--spec`/`--docs` on a **multi-method path** exit 5: *"Multiple methods are available"* | Pass `-X GET` / `-X PATCH`. (`--help` needs no method — it lists them all) |
| 15 | `datasources query` truncates silently-ish — prints a `--start-cursor` hint to continue | Raise `--limit` or follow the cursor when completeness matters |

Gotchas 5, 6, 7, and 12 are the destructive ones: 5 and 6 lose content, 7 loses data
without erroring, 12 hangs the call. The rest cost accuracy or context, not data.
