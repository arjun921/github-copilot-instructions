---
description: "Use when running git push, pushing branches, publishing commits, or any git remote operations. Enforces safe push discipline."
---
# Git Push Rules

- **NEVER** run `git push origin <branchname>` — do not specify the remote or branch explicitly
- Always ensure you are on the correct local branch first (verify with `git branch` or `git status`)
- Then run a plain `git push` with no arguments
- **NEVER push unless the user explicitly asks for it** — do not push as part of completing a task unless instructed

# Feature Branch Workflow

- When working on a **big feature**, always create a new branch from the latest `main` before starting:
  1. `git checkout main`
  2. `git pull`
  3. `git checkout -b <feature-branch-name>`
- Keep the feature branch focused on the original goal

# Commit Style

- Use **atomic commits** — each commit should represent one logical change only
- Use **semantic commit messages** in the format: `type: short description`
  - Common types: `feat`, `fix`, `refactor`, `chore`, `docs`, `test`, `style`
  - Examples: `feat: add user auth middleware`, `fix: handle null response from API`
- Keep messages **one line** — no body, no bullet points, no extended description
- Do not group unrelated changes into a single commit

# Completing Implementation

When implementation is done:
1. Commit all changes to the local feature branch
2. Pull in the source branch (e.g. `main`) into the feature branch: `git fetch origin && git merge origin/main`
3. Resolve any merge conflicts **based on the original intent of the feature** — preserve feature changes, integrate upstream updates without drifting from the initial goal
4. Once conflicts (if any) are fully resolved and the branch is clean, **ALWAYS ask the user** whether they want to push changes to the remote branch
5. Before pushing, verify the local branch name matches the remote tracking branch exactly:
   - Run `git status` and confirm the "Your branch is..." line shows the correct remote tracking branch
   - If no upstream is set, set it explicitly: `git push --set-upstream origin <branch-name>` — but only after the user confirms they want to push
6. Then run a plain `git push` with no arguments
