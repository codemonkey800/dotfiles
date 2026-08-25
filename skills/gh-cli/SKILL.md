---
name: gh-cli
description: |
  Use the gh CLI to interact with GitHub from the terminal — repos, issues,
  pull requests, GitHub Actions, raw API calls, search, and releases.
  Use when the user wants to list/create/manage GitHub resources, check CI,
  review PRs, query the GitHub API, or automate GitHub workflows.
user-invocable: true
---

# GitHub CLI (gh)

Interact with GitHub repositories, issues, pull requests, Actions, and the
GitHub API using the official `gh` CLI.

## When to Use

- List, create, or manage GitHub issues and pull requests
- Check CI/CD status or re-run failed Actions workflows
- Clone, fork, or create repositories
- Query the GitHub REST or GraphQL API with authentication
- Search GitHub for issues, PRs, repos, or code
- Create or manage releases and release assets
- Automate any GitHub workflow from the terminal or a script

## Prerequisites

```bash
# Check gh is installed
gh --version

# Authenticate (run once; opens browser for OAuth)
gh auth login

# Verify authentication
gh auth status
```

## Core Commands

### Repositories

```bash
# Clone a repo
gh repo clone owner/repo

# Fork a repo and clone it
gh repo fork owner/repo --clone

# Create a new repo
gh repo create my-repo --public --clone
gh repo create my-org/my-repo --private --clone

# View repo details
gh repo view owner/repo

# List your repos
gh repo list --limit 50
gh repo list my-org --limit 100 --fork

# Sync a fork with upstream
gh repo sync

# Archive / delete a repo (prompts for confirmation)
gh repo archive owner/repo
gh repo delete owner/repo
```

### Issues

```bash
# List open issues
gh issue list
gh issue list --state closed --limit 25
gh issue list --label bug --assignee @me
gh issue list --search "memory leak"

# View an issue
gh issue view 42
gh issue view 42 --comments

# Create an issue
gh issue create --title "Bug: crash on startup" --body "Steps to reproduce..."
gh issue create --title "Feature request" --label enhancement --assignee octocat

# Edit an issue
gh issue edit 42 --title "Updated title"
gh issue edit 42 --add-label wontfix --remove-label bug
gh issue edit 42 --assignee octocat

# Close / reopen
gh issue close 42
gh issue close 42 --comment "Fixed in #99"
gh issue reopen 42

# Comment on an issue
gh issue comment 42 --body "Looking into this now."

# Pin an issue
gh issue pin 42
```

### Pull Requests

```bash
# List PRs
gh pr list
gh pr list --state closed
gh pr list --author @me
gh pr list --label "needs review" --base main

# View a PR
gh pr view 99
gh pr view 99 --comments

# Create a PR (from current branch)
gh pr create --title "Add feature X" --body "Closes #42"
gh pr create --draft --base main
gh pr create --fill                      # use commit message as title/body

# Checkout a PR branch locally
gh pr checkout 99

# Review a PR
gh pr review 99 --approve
gh pr review 99 --request-changes --body "Please fix the test."
gh pr review 99 --comment --body "Nice work!"

# See the diff
gh pr diff 99

# Merge a PR
gh pr merge 99
gh pr merge 99 --squash
gh pr merge 99 --rebase --delete-branch

# Mark a draft PR as ready
gh pr ready 99

# Close a PR without merging
gh pr close 99

# Comment on a PR
gh pr comment 99 --body "LGTM!"
```

### GitHub Actions (Runs & Workflows)

```bash
# List recent workflow runs
gh run list
gh run list --limit 20 --workflow ci.yml
gh run list --status failure

# View a run
gh run view 1234567890
gh run view 1234567890 --log          # full logs
gh run view 1234567890 --log-failed   # only failed step logs

# Watch a run in real time
gh run watch 1234567890

# Re-run a failed run (or all jobs)
gh run rerun 1234567890
gh run rerun 1234567890 --failed     # only failed jobs

# Cancel a run
gh run cancel 1234567890

# List workflows
gh workflow list

# Trigger a workflow (workflow_dispatch event)
gh workflow run ci.yml
gh workflow run ci.yml --ref my-branch
gh workflow run deploy.yml -f environment=staging

# Enable / disable a workflow
gh workflow enable ci.yml
gh workflow disable old-workflow.yml
```

### GitHub API

Use `gh api` for any REST or GraphQL endpoint — auth headers are added automatically.

```bash
# GET a resource
gh api repos/owner/repo
gh api repos/owner/repo/issues?state=open

# POST / PATCH / DELETE
gh api repos/owner/repo/issues --method POST \
  --field title="New issue" --field body="Details here"

gh api repos/owner/repo/issues/42 --method PATCH \
  --field state=closed

# GraphQL
gh api graphql -f query='
  query {
    viewer { login }
  }
'

# Paginate all results (GitHub paginates at 30/100 by default)
gh api repos/owner/repo/issues --paginate

# Output specific fields with jq
gh api repos/owner/repo/pulls --jq '.[].number'
```

### Search

```bash
# Search issues
gh search issues "memory leak" --repo owner/repo
gh search issues --assignee @me --state open
gh search issues "label:bug created:>2024-01-01"

# Search PRs
gh search prs "refactor" --author octocat --merged
gh search prs --review-requested @me

# Search repositories
gh search repos "machine learning" --language python --stars ">1000"

# Search code
gh search code "TODO" --repo owner/repo --extension go
```

### Releases

```bash
# List releases
gh release list
gh release list --limit 10

# View a release
gh release view v1.2.3

# Create a release
gh release create v1.2.3
gh release create v1.2.3 --title "Version 1.2.3" --notes "Bug fixes"
gh release create v1.2.3 --draft --prerelease
gh release create v1.2.3 ./dist/app-linux ./dist/app-darwin  # attach assets

# Upload asset to an existing release
gh release upload v1.2.3 ./dist/app-linux

# Download release assets
gh release download v1.2.3
gh release download v1.2.3 --pattern "*.tar.gz" --dir ./downloads

# Delete a release
gh release delete v1.2.3
```

### Gists

```bash
# Create a gist
gh gist create file.py
gh gist create file.py --public --desc "Useful script"

# List your gists
gh gist list

# View a gist
gh gist view <gist-id>

# Clone a gist
gh gist clone <gist-id>
```

## JSON Output & Filtering

Most commands support `--json` with a comma-separated field list. Combine with
`--jq` for inline filtering or `--template` for Go template formatting.

```bash
# Common fields for issues/PRs
gh issue list --json number,title,state,author,labels,assignees,createdAt

# Inline jq filter
gh issue list --json number,title --jq '.[].title'

# Pipe to jq for complex processing
gh pr list --json number,title,headRefName,mergeable --jq \
  '.[] | select(.mergeable == "MERGEABLE") | .number'

# Count open PRs
gh pr list --json number | jq length

# Extract PR numbers as shell array
prs=$(gh pr list --json number --jq '.[].number')
```

**Available fields** (varies by command — run `gh <cmd> --json` with no fields to list them):

| Resource | Common fields |
|----------|--------------|
| Issues | `number`, `title`, `state`, `author`, `body`, `labels`, `assignees`, `createdAt`, `closedAt`, `comments`, `url` |
| PRs | `number`, `title`, `state`, `author`, `headRefName`, `baseRefName`, `mergeable`, `reviewDecision`, `labels`, `mergedAt`, `url` |
| Runs | `databaseId`, `name`, `status`, `conclusion`, `workflowName`, `headBranch`, `createdAt`, `url` |
| Repos | `name`, `owner`, `description`, `url`, `isPrivate`, `stargazerCount`, `forkCount`, `defaultBranchRef` |

## Cross-Repo Operations

Target any repo without changing directories using `-R` / `--repo`:

```bash
gh issue list -R owner/other-repo
gh pr view 42 -R owner/other-repo
gh api -R owner/other-repo repos/owner/other-repo/releases
```

## Common Patterns

```bash
# List all open PRs assigned to me across a repo
gh pr list --assignee @me --state open --json number,title,url

# Find PRs awaiting my review
gh pr list --search "review-requested:@me" --state open

# Get the current branch's PR number
gh pr view --json number --jq .number

# Check CI status of current branch's PR
gh pr checks

# List failed CI checks for a specific PR
gh pr checks 99 --fail-fast

# Open a PR/issue/run in the browser
gh pr view 99 --web
gh issue view 42 --web
gh run view 1234567890 --web

# Interactive PR creation (opens editor for description)
gh pr create --fill --web

# Watch a workflow run until it finishes
gh run watch $(gh run list --limit 1 --json databaseId --jq '.[0].databaseId')
```

## Authentication Scopes

If a command requires a scope not granted during initial login:

```bash
# Re-authenticate with additional scopes
gh auth login --scopes read:org,repo,workflow

# Check current scopes
gh auth status
```
