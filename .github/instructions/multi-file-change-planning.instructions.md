---
description: "Use when adding features, removing features or code, refactoring, architectural changes, introducing or removing dependencies, schema changes, or any change that touches more than 2 files or adds/removes more than ~50 lines."
---
# Multi-File Change Planning

> **Before planning, run the critical-thinking process first** (see `critical-thinking.instructions.md`). Do not scope files or create a plan until hard questions have been asked and tradeoffs acknowledged.

Once direction is confirmed:
- Clearly define the goal and scope — understand what you are building/removing before touching any files
- Identify all files that will need to change and why
- Do not bundle unrelated changes into the same effort

# Feature Branch Workflow

- When working on a **big feature**, always create a new branch from the latest `main` before starting:
  1. `git checkout main`
  2. `git pull`
  3. `git checkout -b <feature-branch-name>`
- Keep the feature branch focused on the original goal — do not bundle unrelated changes

# Completing Implementation

When implementation is done:
1. Commit all changes to the local feature branch
2. Pull in the source branch (e.g. `main`) into the feature branch: `git fetch origin && git merge origin/main`
3. Resolve any merge conflicts **based on the original intent of the feature** — preserve feature changes, integrate upstream updates without drifting from the initial goal
4. Once conflicts (if any) are fully resolved and the branch is clean, **ALWAYS ask the user** whether they want to push changes to the remote branch
