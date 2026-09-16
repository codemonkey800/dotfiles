# Plan doc skeleton

Copy from the rule below, fill the `{{ placeholders }}`, delete what doesn't apply.

Sections marked **verbatim** are meant to be used almost as-is — they're the parts that
make a plan executable rather than merely descriptive.

Drop the whole **Instructions for the orchestrator** section when the plan will be
worked directly by one session instead of delegated. Keep **How to work this plan**
either way.

Drop **Branch and worktree** and **Rollout** together when the plan-doc SKILL's
branching-strategy step says this plan doesn't need isolation (a genuinely one-commit
plan). Keep both together otherwise — a branch with no rollout gate is a plan that can
get silently merged; a rollout gate with no branch section is instructions for a branch
nobody set up.

---

# {{ Title — what this delivers }} — `{{ package or area }}`

## Overview

> This section is written for a human, not the executor — plain language, no task IDs,
> no file paths. Everything below it is written for whoever (or whatever) implements
> the plan. If a claim here needs more, it links to where the detail lives.

{{ One paragraph: what's changing, and why. Link the spec, the parent plan, or the phase
this implements. }}

| Feature | In one sentence |
| --- | --- |
| **{{ name }}** | {{ what it does }} |
| **{{ name }}** | {{ what it does }} |

```mermaid
graph LR
  U[{{ trigger }}] --> A[{{ step }}]
  A --> B[{{ outcome }}]
```

**Shape:** {{ one line — e.g. "One doc, groups A–D, 2 waves" or "4 phases, orchestrated,
worktree-isolated sub-agents" }}

**Key decisions:**
- {{ decision, one line, no jargon }} — why: {{ one line }}
- {{ decision, one line, no jargon }} — why: {{ one line }}

  See [Design decisions](#design-decisions) for the full reasoning and what was ruled out.

> **Accepted gap:** {{ what this deliberately does not solve, and why that's fine }}

**Read next:** {{ "[Branch and worktree](#branch-and-worktree) to set up ·" — only when
that section exists }} [Design decisions](#design-decisions) for the why · [Task
List](#task-list) for the work itself · [Sequencing](#sequencing) for the order and the
human checkpoints · {{ "[Rollout](#rollout) for how it lands ·" — only when that section
exists }} [Final report](#final-report) for what "done" reports back.

---

## Branch and worktree

> Include this section only when the plan-doc SKILL's branching-strategy step calls for
> isolation. Drop it — and [Rollout](#rollout) — together otherwise.

**All tasks land on one branch, in one worktree, and never touch the main checkout.**
The main checkout at `{{ path }}` stays on `{{ its current branch }}` for the duration —
it's the developer's live workspace, and an agent session switching its branch out from
under them is a real cost.

| | Value |
| --- | --- |
| Branch | `{{ type/slug, matching the repo's existing branch names }}` |
| Worktree | `{{ path — use the repo's own worktree tooling if it has any, else a plain }}` |
| Base | `{{ usually main }}` |

**Create it with {{ the repo's worktree mechanism }}**, not a bare `git worktree add`
unless that's genuinely all the repo has. {{ Name the reason if the repo's tool matters
for a specific reason — e.g. a session needs to track the new root. }}

**Then, before Wave 1, move these into the worktree** — the worktree is a checkout of
*committed* history, so anything uncommitted in the main checkout, including this doc,
is otherwise invisible there:

| File (main checkout) | Same path in the worktree |
| --- | --- |
| `{{ this plan doc's own path }}` | {{ so the executor can check boxes in it }} |
| `{{ mockup / spec / design doc path, if any }}` | {{ what task cites it }} |

Move, don't copy — one file, one live version. A duplicate left behind goes stale at the
first checked box, and the branch's version lands in `{{ base branch }}` at
[rollout](#rollout) anyway. **Commit these files on the branch early** — they exist in no
commit anywhere until you do, so until that first commit a forced worktree removal takes
them with it.

**Rules while the work is in flight:**

- ❌ Never `git checkout` / `git switch` in the main checkout.
- ❌ Never rebase, force-push, or reset `{{ base branch }}`.
- ❌ Never merge, rename, or delete this branch before the [rollout gate](#rollout)
  clears.
- ✅ Every `/commit` targets the feature worktree — pass `in:{{ worktree path }}` when
  the session isn't already rooted there.
- ✅ {{ Any isolation bonus the worktree buys for free — its own dev instance, port, or
  DB state for verification tasks — if the repo has such a convention. }}

---

## How to work this plan

{{ Only if [Branch and worktree](#branch-and-worktree) exists: }} **Before task 1:**
create the branch and worktree, then move in the files listed in
[Branch and worktree](#branch-and-worktree) — the plan doc and any cited mockups/specs.
Do this once, first.

**Per task:**

1. Work tasks in wave order (see [Sequencing](#sequencing)). Never start a task before
   its dependencies are green.
2. Implement → write or update tests → run `{{ test command }}`, `{{ lint command }}`,
   and `{{ type-check command }}` for every touched package.
3. **`/commit`** — one task, one commit (or a small coherent set). `/commit` stages at
   line level, so unrelated edits in the same file don't ride along. Working in an
   isolated worktree? Pass `in:<abs path>`.
4. Check the box below and append the commit hash.

**Markers:**

| Marker | Means |
| --- | --- |
| `- [ ]` | Not started |
| `- [x]` … `abc1234` | Done, with the commit that did it |
| ⚠️ **PARTIAL** | Landed with scope narrowed — say what was left and why, inline |
| ⏭️ **DROPPED** | Not doing it — say why. Never delete a task |
| 🚧 / ⏳ | Blocked. Do not implement |

**When reality disagrees with this plan,** add a short **Findings** note under the task,
then update the downstream tasks that finding invalidates. Do not let the doc drift from
what actually shipped.

---

## Instructions for the orchestrator agent

You are an **orchestrator**. Your job is delegation, sequencing, and status tracking —
nothing else.

**Do**

- {{ Only if [Branch and worktree](#branch-and-worktree) exists: }} Before delegating
  Wave 1, create the branch and worktree yourself and move in the files listed in that
  section. One-time setup, not implementation — do it directly rather than delegating
  it.
- Delegate every task to a sub-agent — implementation, testing, and committing
  included. One sub-agent per task, or per parallel group where
  [Sequencing](#sequencing) allows batching.
- Write **self-contained** delegation prompts. Copy in the task's full text, the
  relevant parts of the [Shared Context Pack](#shared-context-pack), and the
  [Definition of Done](#definition-of-done). If a task depends on names an earlier task
  produced, paste that sub-agent's reported outcomes — exported names, file paths,
  schema names — into the prompt.
- Tell every sub-agent to: implement → write or update tests → run the package's tests
  plus lint and type-check → run `/commit`. Each reports back **files changed, exported
  names, test results, commit hash(es)**.
- Respect the sequencing graph. Launch parallel-safe tasks concurrently; never start a
  task before its dependencies report success.
- Re-delegate a failed task with the failure details attached.

**Don't**

- ❌ Read or edit any code yourself — no source, no tests, no configs. The only file you
  may edit is _this plan_, to check off tasks and record outcomes.
- ❌ Let sub-agents read this plan. Their prompts must carry everything they need.
- ❌ Fix a failing task yourself.
- ❌ Implement anything tagged 🚧 or ⏳. A sub-agent that thinks it needs to build one
  has misread its task — stop and report.

**Finish by** verifying every checkbox is checked, then reporting the
[final status summary](#final-report).

---

## Design decisions

### {{ Decision }}

{{ What was chosen, in one or two sentences. Then why — including the option that was
ruled out and what ruled it out. Cite `path/to/file.ts:42` where the constraint lives. }}

### {{ Things that already exist — don't rebuild them }}

- **{{ behavior }}** already happens at `{{ path:line }}`. Don't reimplement it.

### {{ What stays untouched }}

`{{ path }}` must keep compiling and **must not be modified**. {{ Why. }}

---

## Shared Context Pack

> Copy the relevant parts into every sub-agent prompt. These are pointers, not gospel —
> sub-agents verify against current code.

### Repo & conventions

- {{ Monorepo/tooling shape. The package(s) this touches and their import names. }}
- {{ Lint and type-check commands. Note if lint is two separate checks. }}
- {{ Where tests live, and the runner. }}
- {{ Anything sequentially numbered — migrations, fixtures — and what the next free
  number is. }}

### Layout

| File | What it is |
| --- | --- |
| `{{ path }}` | {{ role }} |
| `{{ path }}` | {{ role }} |

### Patterns to imitate

{{ The canonical example file for each pattern, named explicitly. }}

```ts
{{ the 4-line version of the pattern }}
```

### Gotchas

- **{{ trap }}** — {{ what actually happens, and what to do instead }}

### Definition of Done

Include this **verbatim** in every delegation:

> **Done means:** implemented; tests written or updated following the package's existing
> conventions and passing; lint and type-check clean for every touched package;
> committed with `/commit`. Report back: files changed, exported names introduced, test
> summary, commit hash(es).

{{ Addendum, when a task verifies differently — e.g. a manual-only suite: "❌ Do not run
`{{ command }}`; verify with `--listTests` instead." }}

---

## Task List

{{ For a phased plan, wrap these groups in `### Phase N — {{ name }}` headings and
restart IDs per phase. }}

### Group A — {{ concern }}

- [ ] **A1. {{ Title }}.** {{ One sentence: what exists when this is done. }}

  **Files:** create `{{ path }}`; edit `{{ path }}`.

  ```ts
  {{ signatures or shapes that matter }}
  ```

  **Edge cases:**
  - {{ the case that will be gotten wrong }}

  **Tests:** {{ behaviors to cover, not assertions }}.

- [ ] **A2. {{ Title }}.** {{ … }}

### Group B — {{ concern }}

- [ ] **B1. {{ Title }}.** {{ … }}

### Group {{ last }} — Verification & docs

- [ ] **{{ X }}1. Full-repo verification.** From the repo root: `{{ build }}`,
      `{{ lint }}`, `{{ type-check }}`, `{{ test }}`. Confirms nothing else broke.

- [ ] **{{ X }}2. Docs + status.** Update `{{ doc }}` with what shipped, commit refs,
      deferred items, and any manual verification left for the user.

---

## Sequencing

```mermaid
graph TD
  A1[A1 {{ short }}] --> B1[B1 {{ short }}]
  A2[A2 {{ short }}] --> A3[A3 {{ short }}]
  B1 --> C1[C1 {{ short }}]
  A3 --> C1
```

### Waves

| Wave | Run | Why it works |
| --- | --- | --- |
| 1 | **A1 ∥ A2** | {{ the isolation that makes it safe — different packages, disjoint files }} |
| 2 | **B1 ∥ A3** | {{ … }} |
| 3 | **C1** | {{ the convergence point }} |
| 4+ | **D1 → E1** | Strictly sequential — each integrates the previous |

> ⚠️ **{{ Wave N caveat }}.** {{ Two tasks that share a file, a manifest, or a migration
> number. Parallel-safe only with worktree-isolated agents or a serialized commit step;
> otherwise run them sequentially. }}

### Dependency table

| Task | Depends on | Parallel with |
| --- | --- | --- |
| A1 | — | A2 |
| A2 | — | A1 |
| A3 | A2 | B1 |

### Critical path

**{{ A1 → B1 → C1 → D1 }}**

{{ Which task leads and why it shouldn't slip. }}

### Human checkpoints

{{ Things the executor cannot perform and must not delegate — a live run, a deploy, a
credential rotation, a real-data delete, a judgment call. }}

1. **After {{ task }}** — {{ what to do, and what it's checking for }}.

---

## Rollout

> Include this section only alongside [Branch and worktree](#branch-and-worktree) —
> both or neither.

**Nothing in this section happens automatically.** Every step below is blocked until a
human explicitly says to proceed. Finishing the last task means the branch is *ready*,
not that it lands.

```mermaid
flowchart TD
    A[Last checkbox checked] --> B[Report final status]
    B --> C{{"⛔ HUMAN APPROVAL GATE"}}
    C -->|Approved| D[{{ Squash merge / open PR }} → {{ base branch }}]
    C -->|Changes wanted| E[More commits on the branch]
    E --> B
    D --> F[Delete branch]
    F --> G[Remove worktree]
```

### The gate

When the last box is checked, the executor **stops and reports**
([Final report](#final-report)). It does not merge, does not push, does not rename,
does not delete. The human reads the report and gives — or withholds — explicit
approval to roll out. Approval covers **any** mutation of the branch; if a step below
isn't covered by what the human actually said, stop and ask rather than inferring it.

### Pre-merge checks

Run these *before* asking for approval, so the human is deciding on a green branch:

1. `{{ build/lint/typecheck/test commands }}` from the worktree root, re-run at the
   final commit.
2. {{ The repo's pre-merge review skill or process, if it has one. }}
3. Confirm every checkbox is `[x]`, `⚠️ PARTIAL`, or `⏭️ DROPPED` with a reason. No bare
   `[ ]`.
4. Confirm every [human checkpoint](#human-checkpoints) cleared.

### Steps, once approved

```bash
# 1. {{ Squash merge into base, or push + open a PR — whichever the repo does }}
{{ commands }}

# 2. Remove the worktree. {{ Note if order matters — most git tooling refuses to
#    delete a branch a live worktree still has checked out. }}
git worktree remove {{ worktree path }}

# 3. Delete the branch.
git branch -D {{ branch }}
```

**The commit/PR message** follows the repo's existing style — scan recent history for
the convention. {{ Note any repo rule about trailers, e.g. no `Co-Authored-By`. }}

### If the plan doesn't finish intact

{{ If a phase or spike can fail and still leave a shippable subset, say so: which tasks
get marked ⏭️ DROPPED and why, and that the same rollout path applies to the partial
result — don't improvise a different split. Omit this subsection if every task in the
plan is load-bearing for every other. }}

### After rollout

- The plan doc stays in `{{ plans dir }}` with every box checked. It's the record;
  don't delete it.
- Verify the worktree is gone and the main checkout is back on `{{ base branch }}`.
- {{ Sweep for anything else the worktree's isolation was hiding — a leaked dev
  instance, a stray port — if applicable. }}

---

## Final report

When every box is checked, report:

1. **Per-task outcome** — status, files changed, exported names, commit hashes
2. **Test results** — per package plus the repo-wide sweep
3. **Deviations** from this plan, and why
4. **Deferred** — human checkpoints outstanding, and everything tagged 🚧 or ⏳
5. **Open questions** discovered during implementation
6. {{ **Branch state** — branch name at commit `<hash>`, N commits ahead of the base,
   worktree still live, pre-merge checks green. Only when
   [Rollout](#rollout) exists — and if it does, end here: "Then stop and ask for
   rollout approval." }}
