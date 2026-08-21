# `ntn api` — the escape hatch

`ntn api` calls any public Notion API endpoint with an inline input grammar, so you never
have to hand-assemble JSON. Read this when the task map in `SKILL.md` doesn't cover the
job.

```
ntn api [OPTIONS] [PATH] [INPUT]...
```

Authentication, workspace, and the `Notion-Version` header are handled for you.

---

## Input grammar

Everything after `<PATH>` is parsed as inline input:

| Syntax | Meaning | Example |
|---|---|---|
| `Header:Value` | Request header | `Accept:application/json` |
| `name==value` | Query parameter | `page_size==100` |
| `path=value` | Body field, **always a JSON string** | `parent[page_id]=abc123` |
| `path:=json` | Body field, **typed JSON** | `archived:=true` |

**Parser precedence** (first match wins): `path:=json` → `name==value` → `Header:Value` →
`path=value`.

Use `:=` for numbers, booleans, arrays, objects, and `null`. Use `=` when you want a
string — `page_size:=10` sends `10`, while `page_size=10` sends `"10"` and the API
rejects it.

### Nested paths

Bracket syntax builds nested objects and arrays. `[]` appends to an array; a numeric index
addresses a slot:

```bash
properties[Status][status][name]=Done
properties[Estimate][number]:=3
children[][paragraph][rich_text][0][text][content]=Hello
```

### Method selection

- **GET** by default.
- **POST** automatically when a body is present (stdin JSON, `--data`, or inline body
  fields).
- `-X` / `--method` always wins — needed for `PATCH` and `DELETE`.

### Body sources — pick exactly one

Mixing these is an error:

- stdin JSON — `echo '{...}' | ntn api v1/pages`
- `-d` / `--data <JSON|@PATH|@->` — `--data @body.json`, or `@-` for stdin
- inline body fields — `path=value` / `path:=json`

`--file <PATH>` reads a file into a multipart `file` form field (uploads).

---

## Discovering endpoints

```bash
ntn api ls                      # 58 endpoints, one TSV line each (~2.8 KB) — safe to dump
ntn api ls | grep -i comment    # narrow it
ntn api 'v1/pages/{page_id}' --help   # ~23-line endpoint card: methods + doc links
```

The endpoint card lists each method with `Ref`/`Guide` URLs and the exact `--docs` /
`--spec` commands. **That card is almost always enough** — reach for `--spec`/`--docs`
only when you need a field you can't infer, and filter the output:

> ⚠️ `--spec` runs 26–116 KB and `--docs` 40–172 KB **per endpoint**. `v1/pages POST` is
> 109 KB of spec and 172 KB of docs. Dumping either unfiltered will shred the context
> window.

```bash
# Filtered — safe
ntn api v1/pages --spec -X POST | jq '.paths | keys'
ntn api v1/comments --docs -X POST | grep -A5 -i 'rich_text'
```

On a multi-method path, `--spec`/`--docs` exit 5 with *"Multiple methods are available"* —
pass `-X GET` / `-X PATCH` / etc. `--help` needs no method.

Quote paths containing `{...}` so the shell doesn't try to expand the braces.

---

## Recipes

### Search

```bash
# By title (titles only — never body text)
ntn api v1/search query='Weekly Notes' page_size:=10 | jq -r '.results[].url'

# Only databases / data sources
ntn api v1/search 'filter[property]=object' 'filter[value]=data_source' page_size:=20 \
  | jq -r '.results[] | "\(.id)\t\(.title[0].plain_text)"'

# Most recently edited first
ntn api v1/search 'sort[direction]=descending' 'sort[timestamp]=last_edited_time' page_size:=5 \
  | jq -r '.results[] | "\(.last_edited_time)\t\(.url)"'
```

### Set page properties

The one thing `ntn pages` cannot do — `create`/`edit` handle body Markdown and the title
only.

```bash
ntn api -X PATCH v1/pages/<page-id> \
  'properties[Status][status][name]=In Progress' \
  'properties[Priority][select][name]=High' \
  'properties[Estimate][number]:=5' \
  'properties[Done][checkbox]:=true' \
  'properties[Due][date][start]=2026-09-01'
```

**Both the property name and the type key must match the schema exactly.** Names are
case-sensitive, and the type key is easy to guess wrong — a property called "Status" is
often type `select`, not `status`, in which case the line above must be
`'properties[Status][select][name]=In Progress'`. Guessing produces a
`400 validation_error`. Check the schema first:

```bash
ntn datasources query <data-source-id> --limit 1 --json \
  | jq '.results[0].properties | map_values(.type)'
```

Archive (trash) or restore a page the same way:

```bash
ntn api -X PATCH v1/pages/<page-id> archived:=true    # trash
ntn api -X PATCH v1/pages/<page-id> archived:=false   # restore
```

### Append blocks to a page

Adds to the end without touching existing content — unlike `pages edit`, which replaces
the whole body. **This is the safe way to add to a page you haven't read.**

```bash
ntn api -X PATCH v1/blocks/<page-id>/children \
  'children[][paragraph][rich_text][0][text][content]=Appended from the CLI'

# A to-do item
ntn api -X PATCH v1/blocks/<page-id>/children \
  'children[][to_do][rich_text][0][text][content]=Buy milk' \
  'children[][to_do][checked]:=false'
```

Read a page's block tree (children are one level deep — recurse on any block with
`has_children: true`):

```bash
ntn api v1/blocks/<page-id>/children page_size==100 \
  | jq -r '.results[] | "\(.type)\t\(.id)\t\(.has_children)"'
```

### Comments

```bash
# Read comments on a page
ntn api v1/comments block_id==<page-id> | jq -r '.results[].rich_text[].plain_text'

# Add one
ntn api v1/comments \
  'parent[page_id]=<page-id>' \
  'rich_text[0][text][content]=Looks good to me'
```

Note the asymmetry: reading uses a **query param** (`block_id==`), posting uses a **body
field** (`parent[page_id]=`).

### Query a data source with filter and sort

`ntn datasources query` covers most cases — including `--filter`, `--filter-file`,
`-s 'Prop desc'`, `--limit`, and `--start-cursor`. Drop to the API for compound filters:

```bash
ntn api -X POST v1/data_sources/<data-source-id>/query --data '{
  "filter": {
    "and": [
      {"property": "Status", "status": {"equals": "In Progress"}},
      {"property": "Priority", "select": {"equals": "High"}}
    ]
  },
  "sorts": [{"property": "Last Updated", "direction": "descending"}],
  "page_size": 25
}' | jq -r '.results[] | .properties.Name.title[0].plain_text'
```

Paginate with `next_cursor` while `has_more` is true:

```bash
ntn api -X POST v1/data_sources/<id>/query start_cursor=<cursor> page_size:=100
```

### Create a page with properties in one shot

`ntn pages create` sets body and title only. To land properties at creation time:

```bash
ntn api v1/pages \
  'parent[data_source_id]=<data-source-id>' \
  'properties[Name][title][0][text][content]=New project' \
  'properties[Status][status][name]=Planning' \
  'children[][paragraph][rich_text][0][text][content]=Kickoff notes'
```

For a page under another page, use `'parent[page_id]=<id>'` and title the page with
`'properties[title][title][0][text][content]=…'`.

### Upload a file and attach it

```bash
UPLOAD_ID=$(ntn files create --filename shot.png --content-type image/png < shot.png \
  --json | jq -r '.id')

ntn api -X PATCH v1/blocks/<page-id>/children \
  'children[][image][type]=file_upload' \
  "children[][image][file_upload][id]=$UPLOAD_ID"
```

`ntn files create --external-url <https-url>` imports a publicly reachable file instead of
reading stdin. `ntn files list` returns **only the first page** — pagination isn't
implemented.

---

## Error handling

Errors print as `error: Public API request failed (<status> <code>): <message>` on stderr,
usually with a `hint:` line that names the fix. Read the hint before retrying — it's
specific and usually correct.

| Status | Code | Meaning |
|---|---|---|
| 400 | `validation_error` | Bad body shape — check `:=` vs `=`, and property type names |
| 403 | `restricted_resource` | Token isn't allowed (e.g. `v1/users` — use `ntn whoami`) |
| 404 | `object_not_found` | Wrong ID, wrong object type, or not shared with the integration |
| 409 | `conflict_error` | Concurrent edit — retry |
| 429 | `rate_limited` | Back off and retry |

A 404 on a valid-looking ID usually means one of: the ID is a *data source* where a
*database* was expected (or vice versa), or the page isn't shared with the "Notion CLI"
integration. The hint distinguishes these.
