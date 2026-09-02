---
name: commit
description: |
  Create git commits with surgical, hunk-level staging via the git-hunk CLI. Use when the
  user says "commit", "commit this", "save my changes", "create a commit", or types
  /commit. By default, commits the current session's uncommitted changes if it made
  any, otherwise every uncommitted change on the branch — split into coherent commits
  by staging specific hunks (or specific lines within a hunk) rather than whole files.
  Accepts an optional scope to commit only part of the work, or "everything" to force
  branch-wide instead of the session default. Counts edits made by sub-agents as session
  work. Takes an optional `in:<path>` to commit inside a specific worktree rather than
  the current directory. Falls back to file-level staging when git-hunk is unavailable.
user-invocable: true
argument-hint: "[optional scope — e.g. 'only the auth changes', 'just src/api.ts', 'one commit', 'everything'; optional 'in:<abs worktree path>']"
---

# Commit

Create well-scoped git commits from the working tree, staging **specific hunks** — or
specific lines within a hunk — rather than whole files.

A single file's changes often contain several unrelated concerns — sometimes written by
different agent sessions. File-level staging collapses them into one commit. `git-hunk`
is a non-interactive, hunk-level staging CLI (installed via `uv tool install git-hunk`,
on `$PATH`) that splits them properly.

## Input

<scope> #$ARGUMENTS </scope>

**Empty `<scope>`** → defer to Step 1: commit the current session's uncommitted changes
if it made any, otherwise every uncommitted change on the branch (today's behavior).

**Non-empty `<scope>`** always overrides Step 1's default:
- A subset ("only the auth changes", "just src/api.ts", "one commit") → honor it and
  report plainly what was left uncommitted.
- `everything` / `the whole branch` / equivalent → the explicit escape hatch back to
  branch-wide, skipping session-narrowing even when session changes exist.

### Working directory

`<scope>` may additionally carry a single `in:<path>` token anywhere in it, naming the
working tree to commit in — e.g. `/commit in:/Users/me/wt/feat-auth everything`. Strip
that token out before interpreting the rest of `<scope>`; what remains is the scope.

```bash
WORK_DIR="$(pwd)"            # default: wherever this session is running
# WORK_DIR="<the in: path>"  # if an in: token was supplied
cd "$WORK_DIR" || exit 1
git rev-parse --show-toplevel   # sanity: confirm this is a work tree at all
```

**Every `git` and `git-hunk` invocation in this skill runs against `$WORK_DIR`.** A `cd`
does not persist between `Bash` tool calls, so **each Bash block below must begin by
re-entering it**. Without that, an `in:` caller gets a skill that silently operates on
the wrong tree: it finds that tree clean, reports "nothing to commit," and the work it
was asked to commit stays uncommitted (Gotcha #11).

Callers that hand off work done in a worktree — the `plan` skill, anything driving
sub-agents — must pass `in:` explicitly. A harness that "enters" a worktree generally
redirects its own bookkeeping only and **does not move the running process's cwd**, so
ambient `pwd` still points at the main checkout even when everything on screen suggests
otherwise. `pwd` cannot be used to detect this. Pass the path.

One deliberate asymmetry: `$PROJECT_KEY` in Step 1 is derived from **ambient `pwd`, not
`$WORK_DIR`** — see the comment there.

## Two invariants

1. **Commit everything in scope.** Surgical staging exists to *split work into good
   commits* — never to silently leave changes behind. Scope defaults to the current
   session's changes when Step 1 finds any, otherwise the whole branch — narrowing that
   way is expected and fine, as long as it's reported. What's never fine, no matter how
   scope was set: silently skipping something in scope, or sweeping leftovers into an
   unexplained catch-all commit.
2. **Preview before every risky operation.** Whole-hunk and whole-path selections are
   safe to commit directly — the `show` output from Step 2 already **is** the preview.
   But a *partial* selection within a hunk (`-l`, `--include-matching`,
   `--exclude-matching`) has no preview built into `git-hunk commit` (Gotcha #7) — run
   the equivalent `git-hunk stage ... --dry-run` first and compare its output against
   your intent before committing for real.

There is deliberately **no protected-branch check** — committing directly to `main` is a
normal workflow here. Do not warn, do not prompt.

---

## Step 0 — Preflight

Run both guards:

```bash
cd "$WORK_DIR" || exit 1
git-hunk --version || echo "HUNK_UNAVAILABLE"
git diff --cached --quiet || echo "INDEX_DIRTY"
```

The `||` marker idiom is used instead of `$?` because it behaves identically in bash,
zsh, and fish — `$?` is invalid in fish and would fail silently.

- **`HUNK_UNAVAILABLE`** printed → the binary is missing or broken. Jump to
  [Fallback](#fallback-no-git-hunk) and use file-level staging.
- **`INDEX_DIRTY`** printed → content is **already staged**. `git-hunk stage` tolerates a
  dirty index fine (it staged content sits alongside whatever it adds), but
  `git-hunk commit` **refuses to run at all** while anything is pre-staged (Gotcha #4) —
  every commit call in Step 5 would abort. Run `git reset` to unstage it, then plan from
  the full working-tree diff. This is lossless under commit-everything — the content
  still gets committed, just in the right commit. **Report that you did this.**

## Step 1 — Resolve scope

Skip this step if `<scope>` was non-empty (see Input) — an explicit scope always wins.

Otherwise, try to narrow to **this session's uncommitted changes**:

```bash
# PROJECT_KEY is deliberately derived from the SESSION's directory, not $WORK_DIR, so
# capture it BEFORE entering the work tree. Claude Code keys the transcript path off
# the directory the session started in, and that never changes — not even when a
# harness "enters" a worktree. Deriving it from a $WORK_DIR that differs from the
# session directory looks up a project key that was never written and finds nothing.
SESSION_DIR="$(pwd)"

cd "$WORK_DIR" || exit 1
REPO_ROOT="$(git rev-parse --show-toplevel 2>/dev/null)"
PROJECT_KEY="$(printf '%s' "$SESSION_DIR" | tr '/.' '-')"

TRANSCRIPT="$HOME/.claude/projects/$PROJECT_KEY/${CLAUDE_CODE_SESSION_ID}.jsonl"
if [ -z "$CLAUDE_CODE_SESSION_ID" ] || [ ! -f "$TRANSCRIPT" ]; then
  TRANSCRIPT="$(ls -t "$HOME/.claude/projects/$PROJECT_KEY"/*.jsonl 2>/dev/null | head -1)"
fi

# Sub-agent turns are NOT in $TRANSCRIPT. They live one per worker in a sibling
# directory named after the session id, so a top-level-only read misses every edit a
# sub-agent made (Gotcha #10). Same schema, and jq accepts multiple files, so the
# filter below is unchanged. Deriving the directory by stripping `.jsonl` keeps this
# working under the newest-mtime fallback above. `*.jsonl` also correctly skips the
# `agent-<id>.meta.json` sidecars.
SUBAGENT_DIR="${TRANSCRIPT%.jsonl}/subagents"
TRANSCRIPTS=()
[ -n "$TRANSCRIPT" ] && [ -f "$TRANSCRIPT" ] && TRANSCRIPTS+=("$TRANSCRIPT")
if [ -d "$SUBAGENT_DIR" ]; then
  for f in "$SUBAGENT_DIR"/*.jsonl; do [ -f "$f" ] && TRANSCRIPTS+=("$f"); done
fi

SESSION_FILES=""
if [ "${#TRANSCRIPTS[@]}" -gt 0 ] && command -v jq >/dev/null 2>&1; then
  SESSION_FILES="$(jq -r '
      select(.type=="assistant") | .message.content[]?
      | select(.type=="tool_use" and (.name=="Edit" or .name=="Write" or .name=="NotebookEdit"))
      | (.input.file_path // .input.notebook_path // empty)
    ' "${TRANSCRIPTS[@]}" 2>/dev/null | sort -u)"
fi

UNCOMMITTED_FILES=""
if [ -n "$REPO_ROOT" ]; then
  UNCOMMITTED_FILES="$(
    { git -c core.quotePath=false -C "$REPO_ROOT" diff --name-only HEAD 2>/dev/null
      git -c core.quotePath=false -C "$REPO_ROOT" ls-files --others --exclude-standard 2>/dev/null
    } | while IFS= read -r f; do printf '%s/%s\n' "$REPO_ROOT" "$f"; done | sort -u
  )"
fi

SCOPE_FILES=""
if [ -n "$SESSION_FILES" ] && [ -n "$UNCOMMITTED_FILES" ]; then
  SCOPE_FILES="$(comm -12 <(printf '%s\n' "$SESSION_FILES") <(printf '%s\n' "$UNCOMMITTED_FILES"))"
fi
printf '%s\n' "${SCOPE_FILES:-NO_SESSION_SCOPE}"
```

- **`NO_SESSION_SCOPE` printed** — no session changes to narrow to, for any reason (none
  still uncommitted, no session ID, no matching or parseable transcript, no `jq`, not a
  git repo). Fall through to branch-wide, silently — the skill's original default.
  Nothing extra to report when this is why nothing narrowed.
- **A list of absolute paths printed instead** — that is the effective scope for the
  rest of this run. Treat it exactly like an explicit `<scope>` naming those paths.

**Known limitations** — most of these degrade to branch-wide, so they don't lose work,
they just miss the chance to narrow. **The first one is different: read it.**
- ⚠️ **Narrowing is only safe when it can see every writer.** Session scope is an
  intersection, so a writer it cannot see doesn't widen the scope — it *shrinks* it.
  Sub-agent transcripts are now included (see `$SUBAGENT_DIR` above), which closes the
  case that mattered most: an orchestrator that dispatches workers and then makes a
  single edit of its own — fixing a worker's bug, reconciling a collision — would
  otherwise narrow scope to *only that one file* and leave every worker's output
  uncommitted, while reporting the narrowing as deliberate. That failure is silent and
  it looks like success. If a writer that isn't `Edit`/`Write`/`NotebookEdit` may have
  touched the tree, pass `everything` rather than trusting the default.
- Only `Edit`/`Write`/`NotebookEdit` tool calls are tracked. A file changed via a
  `Bash`-invoked script or `sed` inside the session is invisible here and lands in the
  branch-wide bucket instead — still gets committed, just not treated as "session work."
  Do not attempt to parse arbitrary Bash commands for file paths to close this gap.
  Note this interacts with the warning above: a session whose *only* untracked writer
  was `Bash` narrows correctly, but a session that mixes `Bash` writes with `Edit`
  writes narrows to the `Edit` set and silently excludes the `Bash` ones.
- Sub-agent transcripts are found by stripping `.jsonl` off the resolved transcript path.
  If the newest-mtime fallback picks the wrong session, it picks that session's workers
  too — wrong together rather than inconsistently, which at least keeps the Step 6
  report coherent.
- When `$CLAUDE_CODE_SESSION_ID` is unset, the newest-mtime fallback can pick the wrong
  transcript if several sessions are active in this project at once. Worst case is a
  plausible-but-wrong narrowing, visible in the Step 6 report.
- On a repo with no commits yet, `git diff --name-only HEAD` errors and contributes
  nothing — content already staged (but never committed) before the first commit won't
  be seen here. Harmless: it still shows up normally in Step 2 and gets committed as
  part of whatever scope results.

## Step 2 — Gather context

One batched command:

```bash
cd "$WORK_DIR" || exit 1
printf '=== STATUS ===\n'; git status --short
printf '\n=== BRANCH ===\n'; git branch --show-current
printf '\n=== LOG ===\n'; git log --oneline -10
```

Then the hunk-level view — **do this once**, per git-hunk's own bundled workflow:

```bash
cd "$WORK_DIR" || exit 1
git-hunk list   # inventory: every unstaged/staged hunk's ID + header, plus untracked files
git-hunk show   # full diff body for every hunk, with IDs and 1-based line positions
```

`show`'s output **is** the preview for whole-hunk work: read it once, plan every commit
from it, and record the IDs you intend to use. Do not also run `git diff`, `cat`, or a
single-ID `show` unless information is genuinely missing — and never run `git diff
HEAD`; git-hunk's output supersedes it and is what carries stable, addressable IDs.

Use `git-hunk list --json` / `git-hunk show --json` only when you need precise
programmatic access. Shape (`schema_version: 2`):

```
list --json: { schema_version, hunks: [ { id, id_stability, file: {text},
               status(unstaged|staged|untracked), change_kind(M|D|A|...),
               a_mode, b_mode, binary, header, context_before, additions, deletions } ] }
show --json: same per-hunk shape, plus lines: [ { n, op(" "|"-"|"+"), content: {text} } ]
             — `n` is the 1-based body position `-l` addresses (counts context lines)
```

Untracked files appear in `list`/`show` with `status: "untracked"` and `id: ""` — they
have no Hunk ID (Gotcha #2).

- **Clean tree** (no staged, modified, or untracked files) → report nothing to commit and
  stop.
- **Detached HEAD** (`git branch --show-current` is empty) → commit anyway. Add a
  **non-blocking warning** to the final report: commits are unreachable without a branch,
  suggest `git branch <name>`. Do not prompt.

## Step 3 — Determine commit message convention

Priority order:

1. **Repo conventions already in context** — AGENTS.md / CLAUDE.md loaded at session
   start. Follow them. Do not re-read those files.
2. **Recent history** — a clear pattern in the last 10 commits (conventional commits,
   ticket prefixes, emoji prefixes). Match it.
3. **Default** — conventional commits: `type(scope): description`, where type is one of
   `feat`, `fix`, `docs`, `refactor`, `test`, `chore`, `perf`, `ci`, `style`, `build`.

## Step 4 — Group at hunk level

Build an inventory from the `list`/`show` output: file → hunk ID → (optionally) line
positions within it. **Every changed hunk, line, and untracked file must be assigned to
exactly one group.** That assignment is the completeness invariant.

- **Group by concern, not by file.** One file may contribute several hunks to several
  commits; one commit may span several files (`git-hunk commit` accepts multiple
  IDs/paths at once).
- **Session-vs-foreign origin is a hint for drawing boundaries, not a filter.** Changes
  you did not make are still committed — they just tend to belong in their own commit.
- **A whole file is a valid unit.** A Repository path selects every hunk in that file at
  once, and beats an ID when the entire file belongs in one commit.
- **Untracked files**: git-hunk cannot stage or commit these at all — `stage`/`commit`
  on an untracked path fails with `no changed file matches` (Gotcha #2). Use
  `git add <explicit path>` — all-or-nothing, never `git add -A` or `git add .`. Included
  by default.
  - **Safety carve-out:** paths matching `.env*`, `*.pem`, `*.key`, `*credential*`,
    `*secret*` are **surfaced and confirmed, not silently added.** This is the one place
    the skill will not blindly commit everything.
  - **Combining an untracked file with tracked hunks in the same commit** needs a
    different finishing move than the normal loop — see Step 5, case C.
- **Deleted and binary files stage normally** — a deletion is an ordinary whole hunk
  (`change_kind: "D"`) and stages/commits cleanly by ID or by path, same as any other
  hunk. No special-casing needed here (unlike some other hunk-staging tools).
- **Renames, copies, and unmerged states are rejected outright** by git-hunk (a clear
  `unsupported file changes: rename: ...` error) — resolve these with plain `git mv` /
  `git add` / `git rm` by explicit path instead of routing them through `git-hunk`.
- **If scope is narrower than the whole branch** — an explicit `<scope>`, or Step 1's
  session-default narrowing — restrict to matching changes and state plainly what is
  being left uncommitted. This is the one intentional relaxation of the invariant,
  however scope was set.
- **Cap at 2–4 commits.** Split when separation is obvious; one commit is fine when it is
  ambiguous. Do not over-slice into many tiny commits.

**Confirm only when unsure.** Proceed automatically when the grouping is unambiguous.
Stop and ask only when a dry-run patch does not match your selection and you cannot
re-scope it cleanly, or when concerns are so entangled that any split would be arbitrary.

## Step 5 — Per-group commit loop

Run this loop for each group, in order, using whichever case fits it.

**Case A — whole hunk(s) and/or whole path(s), nothing partial, no untracked files.**
This is the common case. No dry-run needed — the `show` output from Step 2 already told
you exactly what's in these hunks:

```bash
cd "$WORK_DIR" || exit 1
git-hunk commit <id-or-path> [<id-or-path>...] -m "$(cat <<'EOF'
type(scope): subject line here

Optional body explaining why this change was made, not just what changed.
EOF
)"
```

`-m` is an ordinary shell string argument, so the heredoc trick works exactly like plain
`git commit` — no need to fall back to `git commit` for a multi-line body.

**Case B — a partial selection within exactly one hunk** (`-l`, `--include-matching`, or
`--exclude-matching`). `git-hunk commit` has no `--dry-run` (Gotcha #7), so preview with
the equivalent `stage` call first:

```bash
cd "$WORK_DIR" || exit 1
# 1. Dry-run FIRST — git-hunk commit itself can't preview
git-hunk stage <id> -l 3,5-7 --dry-run
# (or --include-matching / --exclude-matching, matching literal substrings by default;
#  add --regex to treat the pattern as a regular expression)
```

**2. Compare the preview against your intent.** Selecting only one side of a
one-for-one replacement is a hard error (`cannot select one side of lines N-M`) unless
you pass `--allow-one-sided` — prefer matching text both sides share, or select both
line positions, over reaching for that flag. Line numbers for `-l` are **1-based body
positions from `show`, counting context lines** — not source file line numbers.

```bash
cd "$WORK_DIR" || exit 1
# 3. Same flags, for real — stage and commit in one atomic call
git-hunk commit <id> -l 3,5-7 -m "$(cat <<'EOF'
type(scope): subject line here
EOF
)"
```

A partial-line or matching operation can invalidate other recorded IDs and body
positions **for that file** (git-hunk's `list`/`show` re-numbers "Conditional" Hunk IDs —
duplicate-hunk group members — after such an operation). Re-run `git-hunk list`/`show`
before planning further work in that file rather than trusting earlier notes.

**Case C — the group mixes tracked hunks with untracked files.** `git-hunk commit`
refuses to run once anything is staged that it didn't select itself (Gotcha #4), so this
case must finish with plain `git commit`, not `git-hunk commit`:

```bash
cd "$WORK_DIR" || exit 1
git-hunk stage <tracked-id-or-path> [<tracked-id-or-path>...]   # skip if untracked-only
git --literal-pathspecs add -- '<untracked-path>' ['<untracked-path>'...]
git diff --cached --stat   # confirm the index holds exactly this group
git commit -m "$(cat <<'EOF'
type(scope): subject line here
EOF
)"
```

**After every group**, re-check what remains:

```bash
cd "$WORK_DIR" || exit 1
git-hunk list
```

If any `git-hunk` call above exits non-zero, nothing was changed by that call — `stage`
and `commit` are transactional (confirmed: a refused `commit` leaves the index and
working tree untouched). Fix the selection and retry, or route that particular change
through plain `git add`/`git rm`/`git mv` if it's a structural case (rename, copy,
unmerged) that git-hunk rejects outright.

**Message style:**
- **Subject** — concise, imperative mood, focused on *why* not *what*. Follow the Step 3
  convention.
- **Body** — blank line, then motivation, trade-offs, or anything a future reader needs.
  Omit entirely for obvious single-purpose changes.

## Step 6 — Completeness check and report

```bash
cd "$WORK_DIR" || exit 1
git-hunk list
git status --short
```

**If anything is still uncommitted, loop back to Step 4** and plan the remainder into a
group. Do not stop while uncommitted work remains. The only permitted leftovers are an
explicit `<scope>` exclusion (including Step 1's session-default) and an unconfirmed
secret-looking path.

Then report:
- Each commit hash + subject line.
- **If Step 1 narrowed to session scope**, say so: name the files treated as session
  work, count how many other uncommitted files remain on the branch, and note that
  `/commit everything` sweeps those in too.
- Anything deliberately excluded (scope argument, secret-like paths) and why.
- The detached-HEAD warning, if applicable.
- That the index was reset at preflight, if it was.
- **The working tree committed in, whenever `in:` was passed** — name the path. A caller
  that asked for a worktree needs to see that it got one, since the failure mode is a
  clean-tree "nothing to commit" against the wrong directory.

---

## Fallback (no git-hunk)

If `git-hunk` is missing or errors out, degrade to file-level staging:

- Group by **file**, not by hunk. Do not attempt `git add -p`.
- `git add <explicit filename>` — never `-A` or `.`.
- Keep the commit-everything default and the same message conventions.
- `$WORK_DIR` still applies: `cd "$WORK_DIR"` at the top of each block, or use
  `git -C "$WORK_DIR"` throughout. Losing git-hunk does not make the tree ambiguous.
- **Tell the user surgical staging was unavailable**, so they know commits may be coarser
  than usual.

---

## Gotchas

Empirically verified against git-hunk 0.3.0 (a couple items are documented by the tool's
own bundled `core` skill rather than independently reproduced here — flagged below).
Each maps to a rule above.

| # | Gotcha | Rule |
|---|---|---|
| 1 | `git-hunk` is installed via `uv tool install git-hunk` and lands on `$PATH` directly — no `~/go/bin`-style workaround needed | Invoke it as plain `git-hunk`; Step 0's `git-hunk --version` check both confirms availability and gives a clean `HUNK_UNAVAILABLE` fallback trigger |
| 2 | Cannot stage or commit **untracked** files at all — `git-hunk stage <untracked-path>` fails with `error: no changed file matches '<path>'`. They appear in `list`/`show` only as inventory entries (`status: "untracked"`, `id: ""`) | `git add <explicit path>`; all-or-nothing, no partial staging |
| 3 | Selecting only **one side of a one-for-one replacement** (`-l`, `--include-matching`, `--exclude-matching`) is a **hard error**: `cannot select one side of lines N-M; ... or pass --allow-one-sided` — the opposite failure mode of tools that silently over-select | Prefer text both sides share, or select both positions; reach for `--allow-one-sided` only when a one-sided result is genuinely the goal |
| 4 | `git-hunk commit` **aborts** (exit 1, clear error) if the index already holds staged content it didn't select — even content `git-hunk stage` itself just placed there. `git-hunk stage`/`unstage`/`discard` do **not** have this restriction; they work fine alongside a dirty index | Reset a dirty index at preflight (Step 0) so mid-loop `commit` calls don't fail; when a commit must include a pre-staged mix (Case C), finish with plain `git commit`, not `git-hunk commit` |
| 5 | **Deletions stage/commit cleanly** as an ordinary whole hunk (`change_kind: "D"`) by ID or by path — confirmed end-to-end, no special-casing or workaround needed | Treat a deleted file exactly like any other hunk/path group in Step 4/5 |
| 6 | **Renames, copies, and unmerged states are rejected outright**: `error: unsupported file changes: rename: 'a' -> 'b'` with a tip to use Git directly | Resolve these with plain `git mv` / `git add` / `git rm` by explicit path, never through `git-hunk` |
| 7 | `-l` line numbers are **1-based body positions from `show`, counting context lines** — not source file line numbers. `git-hunk commit` has **no `--dry-run`** (only `stage`/`unstage`/`discard` do) | Preview a partial selection with the equivalent `git-hunk stage ... --dry-run` before running the same flags through `git-hunk commit` for real |
| 8 | Hunk IDs accept unambiguous, case-insensitive prefixes; an unknown one errors clearly and lists the currently valid IDs (`error: hunk 'x' not found ... tip: available hunk ids: ...`) | Re-derive IDs from a fresh `git-hunk list`/`show` rather than reusing stale ones across a long session |
| 9 | *(Documented by git-hunk's bundled `core` skill, not independently reproduced here.)* Hunks that would otherwise collide on their short ID are marked `conditional` — members of a "Duplicate Hunk group" — and acting on one member **renumbers the group** | After any partial-line operation, re-run `git-hunk list`/`show` for that file before trusting a previously recorded ID or body position in it |
| 10 | **Sub-agent edits are written to a different file than the session transcript** — one `agent-<id>.jsonl` per worker under `<session-id>/subagents/`, a *subdirectory* beside `<session-id>.jsonl`. A top-level-only read sees none of them. Because session scope is an **intersection**, an unseen writer doesn't widen scope, it shrinks it: an orchestrator that dispatches workers and then makes one edit of its own narrows to *that one file* and silently abandons every worker's output, reporting it as intentional | Read `$TRANSCRIPT` **and** `"$SUBAGENT_DIR"/*.jsonl` together. Same schema, and `jq` takes multiple files, so the filter is unchanged. Pass `everything` whenever an untracked writer may have touched the tree |
| 11 | **A harness that "enters" a worktree does not move the running process's cwd** — it redirects its own file tree, diff view, and terminal defaults only. Unqualified `git`/`git-hunk` therefore run against the **main checkout**, find it clean, and report success-by-vacuity while the work stays uncommitted. `pwd` cannot detect this, and passing absolute paths as *scope* does not fix it — scope is not a tree | Callers pass `in:<abs path>`; every Bash block starts with `cd "$WORK_DIR"`, since `cd` does not persist between tool calls |

Gotchas #1–#8 were verified directly against a scratch repo running git-hunk 0.3.0 and
may shift between versions — the guards here are behavioral (check exit codes, dry-run
partial selections, re-list after anything partial), so they stay correct either way. If
behavior seems to have drifted, `git-hunk skills get core logical-commits` loads the
tool's own current, version-matched workflow guidance.

Gotchas #10 and #11 are harness behaviors rather than git-hunk behaviors, and both fail
**silently in the direction of looking successful** — #10 reports a deliberate-looking
narrowing, #11 reports a clean tree. Neither surfaces as an error, which is why both are
guarded structurally above rather than left to be noticed.
