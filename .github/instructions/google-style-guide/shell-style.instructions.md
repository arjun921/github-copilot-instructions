---
description: "Use when writing, reviewing, or modifying shell scripts. Enforces Google Shell Style Guide conventions for formatting, naming, quoting, error handling, control flow, functions, variables, and shell-specific best practices."
applyTo:
  - "**/*.sh"
  - "**/*.bash"
---

# Google Shell Style Guide

Reference: https://google.github.io/styleguide/shellguide.html

## Shell Choice

- **Bash only**. Use `#!/bin/bash` shebang for all executable scripts.
- Use `set` to configure shell options rather than shebang flags, so `bash script_name` invocation still works.
- Shell is for small utilities and simple wrappers. Rewrite in a structured language if a script exceeds ~100 lines or has complex control flow.

## Formatting

- **Indentation**: 2 spaces. Never tabs (exception: `<<-` here-document bodies).
- **Line length**: 80 characters max. Use here-documents or embedded newlines for long literal strings. Long paths/URLs may exceed the limit on their own line.
- **Pipelines**: If a pipeline fits on one line, keep it on one line. Otherwise, split one segment per line with `\` continuation and the pipe `|` on the new line, indented 2 spaces.
- **Control flow**: `; then` and `; do` go on the same line as `if`/`for`/`while`. `else`, `fi`, and `done` each on their own line, vertically aligned with the opener.
- **Case statements**: Indent alternatives 2 spaces from `case`/`esac`. One-line alternatives: space after `)` and before `;;`. Multi-line: pattern, actions, and `;;` on separate lines. No `;&` or `;;&`.
- **Variable expansion**: Prefer `"${var}"` over `"$var"`. Brace-delimit all variables except single-character shell specials (`$?`, `$#`, `$$`, `$!`, positional `$1`–`$9`).

## Quoting

- **Always quote** strings containing variables, command substitutions, spaces, or shell metacharacters.
- Use `"${array[@]}"` for array expansion and `"$@"` for positional parameters.
- Single-quote strings where no substitution is desired.
- Never quote literal integers used in assignments.
- Quote command substitutions even when expecting integers: `count="$(wc -l < file)"`.

## Naming Conventions

| Type | Convention |
|------|-----------|
| Functions | `lower_snake_case` (library namespacing: `mypackage::my_func`) |
| Variables | `lower_snake_case` |
| Constants / Env vars | `UPPER_SNAKE_CASE`, declared at top of file |
| Source filenames | `lower_snake_case` (no hyphens) |
| Loop variables | Descriptive name matching the collection (e.g., `zone` for `zones`) |

## Variables

- **`local`**: Declare function-specific variables with `local`. Separate declaration from command-substitution assignment so `$?` reflects the command, not `local`.
- **`readonly`**: Use `readonly` (or `declare -r`) for constants. Set `readonly` immediately after computing a value, even if computed at runtime.
- **`export`**: Use `export` explicitly for environment variables; prefer `readonly` + `export` over `declare -xr` for clarity.

## Functions

- Parentheses `()` required after the function name. The `function` keyword is optional but must be used consistently within a project.
- Braces `{` on the same line as the function name; no space between name and `()`.
- Place all functions together near the top of the file, after includes, `set` statements, and constants.
- **`main` pattern**: Scripts with at least one other function must define a `main` function. The last non-comment line must be `main "$@"`.

## Error Handling

- **`set -euo pipefail`**: Use at the top of scripts (or handle errors explicitly at every step).
- **Errors to STDERR**: All error/diagnostic messages go to `>&2`. Recommended pattern:
  ```bash
  err() {
    echo "[$(date +'%Y-%m-%dT%H:%M:%S%z')]: $*" >&2
  }
  ```
- **Check return values**: Use `if ! command; then` or inspect `$?`. For pipelines, use `PIPESTATUS[@]`.

## Features and Builtins

- **Command substitution**: Use `$(command)`, never backticks.
- **Tests**: Use `[[ ]]` over `[ ]` or `test`. Use `==` for string equality (not `=`). Use `-z`/`-n` for empty/non-empty checks.
- **Arithmetic**: Use `(( ))` or `$(( ))`. Never use `let`, `$[ ]`, or `expr`. Inside `$(( ))`, omit `${}` on variable names.
- **Arrays**: Use arrays for lists and command-argument building. Expand with `"${array[@]}"`. Do not use strings for sequences.
- **`eval`**: Avoid.
- **Aliases**: Do not use in scripts; use functions.
- **Wildcards**: Use `./*` instead of `*` to avoid filenames starting with `-`.
- **Pipes to while**: Prefer process substitution (`< <(cmd)`) or `readarray` over piping to `while`.
- **Builtins over externals**: Prefer parameter expansion, `[[ =~ ]]`, and `$(( ))` over `sed`, `grep`, and `expr` when possible.

## Comments

- **File header**: Every file starts with `#!/bin/bash` followed by a blank `#` line and a brief description.
- **Function comments**: Non-trivial functions must have a header documenting: description, `Globals:`, `Arguments:`, `Outputs:`, `Returns:`.
- **TODO format**: `# TODO(username): description (bug ####)`.

## Enforcement

### ShellCheck

Use [ShellCheck](https://github.com/koalaman/shellcheck) for static analysis.

`.shellcheckrc`:
```ini
# Follow sourced files
enable=all
# Use bash dialect
shell=bash
# Recommended: treat warnings as errors in CI
# Add any project-specific exclusions below
# disable=SC2034
```

### shfmt

Use [shfmt](https://github.com/mvdan/sh) for automatic formatting.

Run with Google Shell Style settings:

```bash
# Format in place (2-space indent, binary ops at start of line, case indent)
shfmt -i 2 -bn -ci -w .
```

Flags reference:
- `-i 2` — 2-space indentation
- `-bn` — binary ops (&&, ||, |) at the start of a line
- `-ci` — indent case statement bodies one additional level
- `-w` — write result to file in place

### Pre-commit hooks

`.pre-commit-config.yaml` snippet:
```yaml
repos:
  - repo: https://github.com/shellcheck-py/shellcheck-py
    rev: v0.10.0.1    # pin to latest stable
    hooks:
      - id: shellcheck
        args: ["--severity=warning"]

  - repo: https://github.com/scop/pre-commit-shfmt
    rev: v3.8.0-1     # pin to latest stable
    hooks:
      - id: shfmt
        args: ["-i", "2", "-bn", "-ci"]
```

### Setup instructions

```bash
# Install ShellCheck
# macOS
brew install shellcheck
# Debian/Ubuntu
sudo apt-get install shellcheck

# Install shfmt
# macOS
brew install shfmt
# Go install
go install mvdan.cc/sh/v3/cmd/shfmt@latest

# Install pre-commit and hooks
pip install pre-commit
pre-commit install
```
