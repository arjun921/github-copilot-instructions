---
description: "Use when writing, reviewing, or modifying Vim script code. Enforces Google Vim script Style Guide conventions for formatting, naming, commands, functions, and plugin structure."
applyTo: "**/*.vim"
---

# Google Vim Script Style Guide

Reference: https://google.github.io/styleguide/vimscriptguide.xml

## Portability

- Target Vim 7.0+ unless a newer feature is explicitly required.
- Use `has('feature')` and `exists()` checks before using optional features.
- Test on multiple platforms (Linux, macOS, Windows).
- Always prefix regular expressions with `\m`, `\v`, `\M`, or `\V` (prefer the most concise).
- Prepend `\c` or `\C` to regexes used as function arguments to force explicit case handling.
- Always use case-explicit string comparison operators (`==#`, `==?`, `=~#`, `=~?`); never use `=~`, `==`, `!=`, `>`, `>=`, `<`, `<=` on strings without explicit case.
- Always use `normal!` instead of `normal` to avoid user key mappings.
- Always use the `noremap` family (`nnoremap`, `vnoremap`, `inoremap`) over `nmap`, `vmap`, `imap`.
- When using `catch`, match error codes rather than error text (error text may be locale-dependent). See `:help error-messages`.
- Avoid `:s[ubstitute]` in scripts — it moves the cursor, errors on no match, and depends on `gdefault`.
- If you don't support vi-compatibility mode, fail gracefully.

## Formatting

- Use **2 spaces** for indentation. No tabs.
- Use backslash (`\`) for line continuations, placed at the start of the continued line.
- Whitespace conventions follow Python style (Google convention).
- Separate major sections in files with **two blank lines**.
- Prefer single-quoted strings (`'like this'`) over double-quoted strings unless escape sequences are needed.
- Prefer long setting names (`number` over `nu`, `tabstop` over `ts`).
- Use `setlocal` instead of `set` when the setting should apply only to the current buffer/window.

## Naming

| Entity | Convention | Example |
|---|---|---|
| Plugin names | `kebab-case` | `my-plugin`, `vim-foo` |
| Functions (autoloaded) | `plugin#FunctionName` | `myplugin#DoThing()` |
| Functions (script-local) | `s:FunctionName` | `s:ParseBuffer()` |
| Commands | `UpperCamelCase` | `MyPluginRefresh` |
| Augroups | `snake_case` | `my_plugin_events` |
| Variables (local) | `l:variable_name` | `l:count` |
| Variables (global) | `g:variable_name` | `g:myplugin_enabled` |
| Variables (script) | `s:variable_name` | `s:cache` |
| Arguments | `a:argument_name` | `a:path` |

- **Always** prefix variables with their scope (`l:`, `s:`, `g:`, `a:`, `b:`, `w:`, `t:`, `v:`).
- Prefer semantic command names over a unified prefix.

## Language Features

- Prefer string comparison operators that specify case: `==#`, `==?`, `=~#`, `=~?`. Never rely on `ignorecase` setting.
- Use `is#` for identity comparison (especially with strings and lists).
- Avoid `eval()` — it is a security risk and makes code harder to reason about.
- Use `has('feature')` and `exists()` to guard feature-dependent code.
- Use `:unlet` for variables that may change types, particularly inside loops.
- Use strict and explicit type checks — `0 == 'foo'` evaluates to true in Vim script.
- Check `type()` explicitly before using variables of uncertain type.
- Use exceptions with caution. Always include an error code in thrown exception messages.
- Prefer `return` over `return 0` when the return value has no semantic purpose.
- Prefer `catch` over `catch /.*/`.
- Use Python sparingly (only for background work). Do not use Ruby or Lua.
- Use dict functions (functions attached to dictionaries) where you would use a class. Do not over-use.
- Avoid FuncRefs in most cases (inconsistent naming restrictions and reassignment behavior). Pass function name strings instead.

## Commands and Autocommands

### Commands

- Define commands in `plugin/commands.vim` or `ftplugin/` files.
- Use `CommandNamesLikeThis` (UpperCamelCase).
- Do **not** use `[!]` when defining commands (do not overwrite user commands).
- Prefer `command -nargs=0` explicitly to make argument expectations clear.
- Extract command logic into functions; keep command definitions thin.

### Autocommands

- Define autocommands in `plugin/autocmds.vim`.
- Always wrap in `augroup` with `autocmd!` to clear before redefining:
  ```vim
  augroup my_plugin_events
    autocmd!
    autocmd BufWritePost *.vim call s:OnSave()
  augroup END
  ```
- Use `augroup_names_like_this` (snake_case).
- Extract logic into functions rather than inlining.

### Mappings

- Define mappings in `plugin/mappings.vim` (opt-in).
- Define `<Plug>` mappings in `plugin/plugs.vim` (opt-out).
- Always use `nnoremap`, `vnoremap`, `inoremap` — never `nmap`, `vmap`, `imap`.
- Mappings should be disabled by default; users opt in.

## Functions

- Place all functions in `autoload/` for late-loading (speed up startup).
- Define functions with `[!]` and `[abort]`:
  ```vim
  function! myplugin#DoThing(arg) abort
    " ...
  endfunction
  ```
- Prefix script-local functions with `s:`.
- `[abort]` ensures the function stops on error rather than continuing silently.

## Plugin Layout

```
myplugin/
├── autoload/       " Functions (late-loaded)
│   └── myplugin.vim
├── plugin/         " Commands, autocommands, mappings, settings
│   ├── commands.vim
│   ├── autocmds.vim
│   ├── mappings.vim
│   ├── plugs.vim
│   └── settings.vim
├── ftplugin/       " Filetype-specific functionality
├── syntax/         " Syntax definitions
├── doc/            " Vim help documentation
│   └── myplugin.txt
├── instant/        " Flags and settings loaded immediately
│   └── flags.vim
└── addon-info.json " Plugin metadata
```

- Avoid use of the `after/` directory — it should be reserved for the user.
- Each plugin should be one directory (or repository) sharing a name with the plugin.
- Separate library plugins from command-providing plugins.
- Declare dependencies in `addon-info.json`.

## Documentation

- Use Vim help format for plugin documentation (`:help write-plugin`).
- Place help files in `doc/` directory.
- Use [vimdoc](https://github.com/google/vimdoc) to generate documentation.

## Forbidden Commands and Style Prohibitions

- **No `eval()`** — security risk and code clarity concern.
- **No abbreviations in commands** — use full command names for readability.
- **No `set` when `setlocal` is appropriate** — avoid clobbering global settings.
- **No `:match`, `:2match`, or `:3match`** — reserved for the user; use `matchadd()` instead.
- **No `echoerr`** — it prints debug context, not a clean error. Use `echohl ErrorMsg` with `echomsg` for red error messages.
- **Use `echomsg` instead of `echo`** — `echomsg` messages persist in `:messages`; `echo` disappears on redraw.
- **No `[!]` on command definitions** — do not overwrite user commands.
- **Do not clobber user settings** — provide configurability, don't force values.
- **Minimal messaging** — only message on errors or long-running operations.

## Layout Conventions

### `plugin/` files

Separate sections with two blank lines:
1. Declaration of script constants
2. Declaration of configuration variables
3. Other declarations (commands, autocommands, etc.)

### `autoload/` files

Separate sections with two blank lines:
1. Library require calls
2. Script-local variables
3. Script-local functions
4. Private autoloaded functions
5. Public autoloaded functions

---

## Enforcement

### Vint (Vim Lint)

```bash
# Install vint
pip install vim-vint

# Run vint
vint script.vim
vint plugin/
```

### Pre-commit Configuration (`.pre-commit-config.yaml`)

```yaml
repos:
  - repo: https://github.com/pre-commit/pre-commit-hooks
    rev: v5.0.0
    hooks:
      - id: trailing-whitespace
      - id: end-of-file-fixer

  # vint can be run as a local hook
  - repo: local
    hooks:
      - id: vint
        name: vint
        entry: vint
        language: python
        additional_dependencies: [vim-vint]
        types: [vim]
```

### Setup Instructions

```bash
# Install vint
pip install vim-vint

# Run vint on a file
vint script.vim

# Run vint on directory
vint --recursive plugin/
```

Note: Vim script has limited automated formatting tools. Vint provides linting but not formatting. Editor-based indentation is the primary formatting mechanism.
