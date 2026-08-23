# Plan doc skeleton

Copy from the rule below, fill the `{{ placeholders }}`, delete what doesn't apply.

Sections marked **verbatim** are meant to be used almost as-is — they're the parts that
make a plan executable rather than merely descriptive.

Drop the whole **Instructions for the orchestrator** section when the plan will be
worked directly by one session instead of delegated. Keep **How to work this plan**
either way.

---

# {{ Title — what this delivers }} — `{{ package or area }}`

{{ One paragraph: what changes, and what's true when it's done. Link the spec, the
parent plan, or the phase this implements. }}

| Feature | In one sentence |
| --- | --- |
| **{{ name }}** | {{ what it does }} |
| **{{ name }}** | {{ what it does }} |

```mermaid
graph LR
  U[{{ trigger }}] --> A[{{ step }}]
  A --> B[{{ outcome }}]
```

> **Accepted gap:** {{ what this deliberately does not solve, and why that's fine }}

---

## How to work this plan

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

## Final report

When every box is checked, report:

1. **Per-task outcome** — status, files changed, exported names, commit hashes
2. **Test results** — per package plus the repo-wide sweep
3. **Deviations** from this plan, and why
4. **Deferred** — human checkpoints outstanding, and everything tagged 🚧 or ⏳
5. **Open questions** discovered during implementation
