---
name: personal-email
description: Interact with jeremyasuncion808@gmail.com via the gog CLI (gogcli). Reads, searches, sends, and manages personal Gmail.
---

## Auth Verification (run first, every invocation)

```bash
gog auth list --plain | cut -f1 | grep -Fx "jeremyasuncion808@gmail.com"
```

- **Match** → proceed; use `--account=jeremyasuncion808@gmail.com` on every subsequent `gog` command.
- **No match** → stop immediately with:
  > Error: `jeremyasuncion808@gmail.com` is not authenticated in gog. Run `gog auth add jeremyasuncion808@gmail.com` to add it, then retry.

## Supported Operations

| Intent | Command |
|--------|---------|
| List/search inbox | `gog gmail search "<query>" --account=jeremyasuncion808@gmail.com --max=20` |
| Read a message | `gog gmail get <message-id> --account=jeremyasuncion808@gmail.com` |
| Read a thread | `gog gmail thread get <thread-id> --account=jeremyasuncion808@gmail.com` |
| List labels | `gog gmail labels list --account=jeremyasuncion808@gmail.com` |
| Send email | `gog gmail send --to=... --subject=... --body=... --account=jeremyasuncion808@gmail.com` *(confirm first)* |
| Reply to thread | `gog gmail send --reply-to-message-id=<id> --thread-id=<id> --quote --account=jeremyasuncion808@gmail.com` |
| Archive | `gog gmail archive "<query>" --account=jeremyasuncion808@gmail.com` |
| Mark as read | `gog gmail mark-read "<query>" --account=jeremyasuncion808@gmail.com` |
| Mark as unread | `gog gmail unread "<query>" --account=jeremyasuncion808@gmail.com` |
| Trash a message | `gog gmail trash <message-id> --account=jeremyasuncion808@gmail.com` |
| List drafts | `gog gmail drafts list --account=jeremyasuncion808@gmail.com` |
| Download attachment | `gog gmail attachment <message-id> <attachment-id> --account=jeremyasuncion808@gmail.com` |

## Gmail Search Operators

Translate natural language into Gmail query syntax using these operators:

- `from:<address>` — sender filter
- `to:<address>` — recipient filter
- `subject:<text>` — subject contains text
- `has:attachment` — has at least one attachment
- `is:unread` — unread messages
- `is:starred` — starred messages
- `after:YYYY/MM/DD` — received after date
- `before:YYYY/MM/DD` — received before date
- `label:<name>` — in a specific label/folder
- `in:inbox` — inbox only
- `in:sent` — sent mail only

## Safety Rules

1. **Send requires explicit user confirmation.** Before calling `gog gmail send`, show a preview:
   - To: ...
   - Subject: ...
   - Body: ...
   Then ask "Send this email? (yes/no)". Only call send after the user confirms.
2. **Destructive actions** (trash, bulk-archive, bulk-mark-read) — confirm the scope before executing.
3. **Never use `--force` or `-y`** on send or trash.
4. **`--dry-run` / `-n`** may be used to preview bulk operations before committing.

## Output Formatting

- **Search results**: numbered list with From, Subject, Date, and a preview snippet per message.
- **Full message reads**: show headers (From, To, Date, Subject) first, then body, then list attachment names if present.
- **JSON output** (`--json` flag): parse and present as readable text — never dump raw JSON at the user.
