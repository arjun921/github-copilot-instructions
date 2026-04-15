# GitHub Copilot Instructions

A template repo for shared GitHub Copilot agent instructions. Clone this into any project to enforce consistent AI-assisted coding behaviour.

## What's included

| File | Triggers on |
|------|-------------|
| `critical-thinking.instructions.md` | Adding/removing features, refactoring, architectural changes, dependency changes, schema changes, or any change touching 2+ files or ~50+ lines. Enforces Socratic challenge and tradeoff analysis before any plan is agreed. |
| `multi-file-change-planning.instructions.md` | Same triggers as above. Enforces feature branch setup, file scoping, and merge/commit discipline after critical thinking is complete. |
| `git.instructions.md` | Git push, branch operations, and remote interactions. Enforces atomic semantic commits, safe push discipline, and feature branch workflow. |

## Usage

### Copy instructions to your user-level VS Code config

```bash
make export
```

This copies all `.instructions.md` files to your local VS Code instructions directory, making them available across all projects.

### Import user-level instructions into this repo

```bash
make import
```

Lists your current user-level instructions and prompts before copying any into this repo.

## Paths detected automatically

The Makefile detects your VS Code installation type:

- **VS Code Server** — `~/.vscode-server/data/User/prompts/instructions`
- **VS Code (Linux)** — `~/.config/Code/User/prompts/instructions`
- **VS Code (macOS)** — `~/Library/Application Support/Code/User/prompts/instructions`
