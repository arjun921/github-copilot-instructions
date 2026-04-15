# GitHub Copilot Instructions

A template repo for shared GitHub Copilot agent instructions. Clone this into any project to enforce consistent AI-assisted coding behaviour.

## What's included

### Core instructions

| File | Triggers on |
|------|-------------|
| `critical-thinking.instructions.md` | Adding/removing features, refactoring, architectural changes, dependency changes, schema changes, or any change touching 2+ files or ~50+ lines. Enforces Socratic challenge and tradeoff analysis before any plan is agreed. |
| `multi-file-change-planning.instructions.md` | Same triggers as above. Enforces feature branch setup, file scoping, and merge/commit discipline after critical thinking is complete. |
| `git.instructions.md` | Git push, branch operations, and remote interactions. Enforces atomic semantic commits, safe push discipline, and feature branch workflow. |

### Google Style Guides

The `google-style-guide/` subfolder contains instruction files for all 18 languages covered by the [Google Style Guides](https://google.github.io/styleguide/). Each file enforces the corresponding style guide conventions and includes enforcement tooling configuration (linters, formatters, pre-commit hooks).

| Language | File | Key tooling |
|----------|------|-------------|
| Python | `python-style.instructions.md` | Ruff, mypy, pre-commit |
| C++ | `cpp-style.instructions.md` | clang-format, clang-tidy, cpplint |
| Java | `java-style.instructions.md` | google-java-format, Checkstyle |
| JavaScript | `javascript-style.instructions.md` | ESLint, Prettier |
| TypeScript | `typescript-style.instructions.md` | ESLint, Prettier |
| Go | `go-style.instructions.md` | gofmt, go vet, golangci-lint |
| Shell | `shell-style.instructions.md` | ShellCheck, shfmt |
| C# | `csharp-style.instructions.md` | dotnet format, StyleCop |
| Swift | `swift-style.instructions.md` | swift-format, SwiftLint |
| Objective-C | `objectivec-style.instructions.md` | clang-format |
| R | `r-style.instructions.md` | lintr, styler |
| Common Lisp | `commonlisp-style.instructions.md` | sblint |
| HTML/CSS | `htmlcss-style.instructions.md` | Prettier, Stylelint, HTMLHint |
| JSON | `json-style.instructions.md` | Prettier |
| Markdown | `markdown-style.instructions.md` | markdownlint |
| Vim script | `vimscript-style.instructions.md` | Vint |
| XML | `xml-style.instructions.md` | xmllint, Prettier |
| AngularJS | `angularjs-style.instructions.md` | ESLint (angular plugin) |

See [`google-style-guide/README.md`](.github/instructions/google-style-guide/README.md) for full details.

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
