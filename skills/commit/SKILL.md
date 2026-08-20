---
name: commit
description: |
  Create git commits with surgical, line-level staging via the hunk CLI. Use when the
  user says "commit", "commit this", "save my changes", "create a commit", or types
  /commit. By default, commits the current session's uncommitted changes if it made
  any, otherwise every uncommitted change on the branch — split into coherent commits
  by staging specific line ranges rather than whole files. Accepts an optional scope to
  commit only part of the work, or "everything" to force branch-wide instead of the
  session default. Counts edits made by sub-agents as session work. Takes an optional
  `in:<path>` to commit inside a specific worktree rather than the current directory.
  Falls back to file-level staging when hunk is unavailable.
user-invocable: true
argument-hint: "[optional scope — e.g. 'only the auth changes', 'just src/api.ts', 'one commit', 'everything'; optional 'in:<abs worktree path>']"
---

# Commit

Create well-scoped git commits from the working tree, staging **specific lines** rather
than whole files.

A single file's changes often contain several unrelated concerns — sometimes written by
different agent sessions. File-level staging collapses them into one commit. `hunk`
(`~/go/bin/hunk`) is a line-level staging CLI that splits them properly.

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

**Every `git` and `hunk` invocation in this skill runs against `$WORK_DIR`.** A `cd`
does not persist between `Bash` tool calls, so **each Bash block below must begin by
re-entering it**. Without that, an `in:` caller gets a skill that silently operates on
the wrong tree: it finds that tree clean, reports "nothing to commit," and the work it
was asked to commit stays uncommitted (Gotcha #12).

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
2. **Dry-run before every real stage.** `hunk stage` can stage a **superset** of your
   selection (Gotcha #3). The dry-run is the only way to know what you are about to
   commit. This is the single most important rule in this skill.

There is deliberately **no protected-branch check** — committing directly to `main` is a
normal workflow here. Do not warn, do not prompt.

---

## Step 0 — Preflight

Run both guards:

```bash
cd "$WORK_DIR" || exit 1
~/go/bin/hunk version || echo "HUNK_UNAVAILABLE"
git diff --cached --quiet || echo "INDEX_DIRTY"
```

The `||` marker idiom is used instead of `$?` because it behaves identically in bash,
zsh, and fish — `$?` is invalid in fish and would fail silently.

- **`HUNK_UNAVAILABLE`** printed → the binary is missing or broken. Jump to
  [Fallback](#fallback-no-hunk) and use file-level staging.
- **`INDEX_DIRTY`** printed → content is **already staged**. `hunk stage` reads *unstaged*
  changes only and is blind to the index (Gotcha #4), so anything pre-staged would land
  in the first commit regardless of how you group. Run `git reset` to unstage it, then
  plan from the full working-tree diff. This is lossless under commit-everything — the
  content still gets committed, just in the right commit. **Report that you did this.**

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
# sub-agent made (Gotcha #11). Same schema, and jq accepts multiple files, so the
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
printf '\n=== STAGED STAT ===\n'; git diff --cached --stat
printf '\n=== BRANCH ===\n'; git branch --show-current
printf '\n=== LOG ===\n'; git log --oneline -10
```

Then the line-level view:

```bash
cd "$WORK_DIR" || exit 1
~/go/bin/hunk diff                # compact, line-numbered
~/go/bin/hunk diff --stage-hints  # ready-to-run candidate stage commands
```

`hunk` reads the tree it is run in and takes no `-C`-style flag, which is exactly why
`$WORK_DIR` is entered with `cd` rather than threaded through per-command options.

`--stage-hints` prints commands like `hunk stage src/App.tsx:86,151-163` — the best
starting point for building selections. Use `~/go/bin/hunk diff --json` only when you
need precise line math; its shape is:

```
{ files: [ { path, status(modified|new|deleted|renamed), old_path?, binary?,
             hunks: [ { header, section,
                        lines: [ { op(add|delete|context), content, old_line?, new_line? } ] } ] } ],
  untracked: [ paths ] }
```

**Do not run `git diff HEAD`.** Hunk's output supersedes it and is line-addressable.

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

## Step 4 — Group at line level

Build an inventory from the hunk diff: file → hunk → line ranges. **Every changed line
must be assigned to exactly one group.** That assignment is the completeness invariant.

- **Group by concern, not by file.** One file may contribute lines to several commits;
  one commit may span several files.
- **Session-vs-foreign origin is a hint for drawing boundaries, not a filter.** Changes
  you did not make are still committed — they just tend to belong in their own commit.
- **Untracked files** (the `untracked[]` array): hunk cannot stage these at all
  (Gotcha #2). Use `git add <explicit path>` — all-or-nothing, never `git add -A` or
  `git add .`. Included by default.
  - **Safety carve-out:** paths matching `.env*`, `*.pem`, `*.key`, `*credential*`,
    `*secret*` are **surfaced and confirmed, not silently added.** This is the one place
    the skill will not blindly commit everything.
- **Binary, deleted, and renamed files** cannot be line-staged. Use `git add` / `git rm`
  by explicit path.
  - ⚠️ **The dry-run lies about deletions** (Gotcha #10). For a deleted file,
    `--stage-hints` will suggest `hunk stage legacy.py:1-3` and `--dry-run` will print a
    clean, plausible patch — but the real `hunk stage` fails with
    `error: /dev/null: does not exist in index`. Never route a deletion through hunk;
    reach straight for `git rm <path>`.
- **If scope is narrower than the whole branch** — an explicit `<scope>`, or Step 1's
  session-default narrowing — restrict to matching changes and state plainly what is
  being left uncommitted. This is the one intentional relaxation of the invariant,
  however scope was set.
- **Cap at 2–4 commits.** Split when separation is obvious; one commit is fine when it is
  ambiguous. Do not over-slice into many tiny commits.

**Confirm only when unsure.** Proceed automatically when the grouping is unambiguous.
Stop and ask only when the dry-run patch does not match your selection and you cannot
re-scope it cleanly, or when concerns are so entangled that any split would be arbitrary.

## Step 5 — Per-group stage → verify → commit loop

Run this loop for each group, in order. **Do not skip step 1.**

```bash
cd "$WORK_DIR" || exit 1
# 1. Dry-run FIRST — read the emitted patch
~/go/bin/hunk stage --dry-run FILE:LINES [FILE:LINES...]
```

**2. Compare the patch against your intent.** If it contains lines you did not select
(Gotcha #3):
- Accept only if those lines are genuinely inseparable and belong in *this* commit.
- Otherwise re-scope the selection and repeat from step 1.
- Either way, **reassign any swept-in lines** in your inventory so they are not
  double-counted in a later group.

```bash
cd "$WORK_DIR" || exit 1
# 3. Stage for real — check the exit code
~/go/bin/hunk stage FILE:LINES [FILE:LINES...]

# 4. Confirm the index holds exactly what you expect
~/go/bin/hunk preview

# 5. Commit
git commit -m "$(cat <<'EOF'
type(scope): subject line here

Optional body explaining why this change was made, not just what changed.
EOF
)"

# 6. Re-check remaining work before the next group
~/go/bin/hunk diff
```

If step 3 exits non-zero, **nothing was staged** — a clean dry-run does not guarantee the
real stage will succeed (Gotcha #10). Fix the selection, or route that change through
plain `git add` / `git rm` instead.

On any mismatch at step 4: `~/go/bin/hunk reset`, then re-plan from Step 4
(Group at line level).

Use `git commit` with a heredoc rather than `hunk commit -m` — hunk's commit is a
self-described thin wrapper taking a single `-m` string, while the heredoc gives reliable
multi-line bodies. `hunk commit -m "..."` is fine for short one-line messages.

**Message style:**
- **Subject** — concise, imperative mood, focused on *why* not *what*. Follow the Step 3
  convention.
- **Body** — blank line, then motivation, trade-offs, or anything a future reader needs.
  Omit entirely for obvious single-purpose changes.

## Step 6 — Completeness check and report

```bash
cd "$WORK_DIR" || exit 1
~/go/bin/hunk diff --summary
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

## Fallback (no hunk)

If `~/go/bin/hunk` is missing or errors out, degrade to file-level staging:

- Group by **file**, not by line. Do not attempt `git add -p`.
- `git add <explicit filename>` — never `-A` or `.`.
- Keep the commit-everything default and the same message conventions.
- `$WORK_DIR` still applies: `cd "$WORK_DIR"` at the top of each block, or use
  `git -C "$WORK_DIR"` throughout. Losing hunk does not make the tree ambiguous.
- **Tell the user surgical staging was unavailable**, so they know commits may be coarser
  than usual.

---

## Gotchas

Empirically verified against hunk v1.0.0. Each maps to a rule above.

| # | Gotcha | Rule |
|---|---|---|
| 1 | `hunk` is **not on `$PATH`** | Always invoke as `~/go/bin/hunk` |
| 2 | Cannot stage **untracked** files — they land in a top-level `untracked[]` array marked *"use git add"* | `git add <explicit path>`; all-or-nothing, no partial staging |
| 3 | **The staged patch can be a SUPERSET of your selection.** Real repro: selecting one added line also pulled in nearby deletions and 8 unrelated added lines | ⚠️ `--dry-run` before every real stage, always; then reassign swept-in lines |
| 4 | `hunk stage` reads **unstaged changes only** — blind to the index | Reset a dirty index at preflight (Step 0) |
| 5 | Deleted lines carry only `old_line`, no `new_line` | Deletions can't be addressed by line number; they attach to neighbouring additions |
| 6 | A **context-only** selection errors: `no matching lines found for selection` | Every selection must contain actual additions |
| 7 | Exit codes are reliable: `0` success, `1` on error (context-only, out-of-range, bad syntax, missing file), `127` binary absent | Check exit status after each hunk call |
| 8 | `hunk diff --stage-hints` prints **ready-to-run** stage commands — but see #10, it also suggests deletion commands that cannot work | Good starting point for selections; ignore its hints for deleted files |
| 9 | Line numbers refer to the **NEW (post-edit) file** | Matches what the editor and the agent already see |
| 10 | **For deleted files the dry-run lies.** `--dry-run` prints a clean patch and exits 0; the real `hunk stage` then fails with `error: /dev/null: does not exist in index` (malformed `+++ b//dev/null`). Fails safely — nothing is staged | Never stage a deletion through hunk; use `git rm <path>`. A successful dry-run is *not* proof a stage will succeed |
| 11 | **Sub-agent edits are written to a different file than the session transcript** — one `agent-<id>.jsonl` per worker under `<session-id>/subagents/`, a *subdirectory* beside `<session-id>.jsonl`. A top-level-only read sees none of them. Because session scope is an **intersection**, an unseen writer doesn't widen scope, it shrinks it: an orchestrator that dispatches workers and then makes one edit of its own narrows to *that one file* and silently abandons every worker's output, reporting it as intentional | Read `$TRANSCRIPT` **and** `"$SUBAGENT_DIR"/*.jsonl` together. Same schema, and `jq` takes multiple files, so the filter is unchanged. Pass `everything` whenever an untracked writer may have touched the tree |
| 12 | **A harness that "enters" a worktree does not move the running process's cwd** — it redirects its own file tree, diff view, and terminal defaults only. Unqualified `git` therefore runs against the **main checkout**, finds it clean, and reports success-by-vacuity while the work stays uncommitted. `pwd` cannot detect this, and passing absolute paths as *scope* does not fix it — scope is not a tree | Callers pass `in:<abs path>`; every Bash block starts with `cd "$WORK_DIR"`, since `cd` does not persist between tool calls |

Gotchas #3 and #10 are v1.0.0 quirks that may change between versions. The guards here
are behavioral — always dry-run and compare, always check the exit code of the real
stage — so they stay correct either way.

Gotchas #11 and #12 are harness behaviors rather than hunk behaviors, and both fail
**silently in the direction of looking successful** — #11 reports a deliberate-looking
narrowing, #12 reports a clean tree. Neither surfaces as an error, which is why both are
guarded structurally above rather than left to be noticed.
