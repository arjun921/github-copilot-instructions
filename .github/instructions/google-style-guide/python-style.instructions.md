---
description: "Use when writing, reviewing, or modifying Python code. Enforces Google Python Style Guide conventions for naming, imports, formatting, docstrings, type hints, exceptions, and line length."
applyTo: "**/*.py"
---

# Google Python Style Guide

Reference: https://google.github.io/styleguide/pyguide.html

## Formatting

- **Indentation**: 4 spaces. Never tabs.
- **Line length**: 80 characters max. Exceptions: long imports, URLs in comments, and string constants without whitespace.
- **No backslash line continuations**. Use implicit continuation inside parentheses, brackets, and braces.
- **No semicolons** to terminate lines or combine statements.
- **Blank lines**: 2 between top-level definitions, 1 between methods, no blank line after `def`.
- **Trailing commas**: Use in multi-line sequences when closing bracket is on its own line.

## Naming Conventions

| Type | Convention |
|------|-----------|
| Packages/Modules | `lower_with_under` |
| Classes/Exceptions | `CapWords` |
| Functions/Methods/Variables | `lower_with_under` |
| Constants | `CAPS_WITH_UNDER` |
| Internal/Protected | Prefix with `_` |

- Avoid single-character names except for counters (`i`, `j`, `k`), exception vars (`e`), file handles (`f`).
- Never use dashes (`-`) in module names.
- Exception names should end in `Error`.

## Imports

- Import **packages and modules only**, not individual classes or functions (except from `typing` and `collections.abc`).
- Use **absolute imports**. No relative imports.
- One import per line (except `typing` and `collections.abc` symbols).
- **Import order** (each group separated by a blank line):
  1. `__future__` imports
  2. Standard library
  3. Third-party
  4. Local/project
- Within each group, sort lexicographically by full module path (case-insensitive).

## Docstrings (Google Style)

- Use triple double-quotes `"""` always.
- Summary line: one physical line, ≤80 chars, ends with period/question/exclamation.
- Blank line after summary, then description.
- Sections: `Args:`, `Returns:` (or `Yields:`), `Raises:`, `Attributes:` (for classes).
- Each arg: `name: Description.` with 2 or 4 space hanging indent.

```python
def fetch_rows(
    table: Table,
    keys: Sequence[str],
    require_all: bool = False,
) -> Mapping[str, tuple[str, ...]]:
    """Fetches rows from a table.

    Args:
        table: An open Table instance.
        keys: Row keys to fetch.
        require_all: If True, only return rows with all keys set.

    Returns:
        A dict mapping keys to row data tuples.

    Raises:
        IOError: An error occurred accessing the table.
    """
```

## Type Hints

- **Strongly encouraged** for all public APIs.
- Use built-in generics (`list[int]`, `dict[str, int]`, `tuple[int, ...]`) over `typing` equivalents.
- Use `X | None` instead of `Optional[X]` (Python 3.10+).
- Prefer `collections.abc.Sequence`, `collections.abc.Mapping` over concrete types in signatures.
- Don't annotate `self`, `cls`, or `__init__` return type.
- Use `from __future__ import annotations` for forward references.

## Exceptions

- Use built-in exception types (`ValueError`, `TypeError`, etc.) when appropriate.
- Custom exceptions must inherit from `Exception` and end in `Error`.
- Never use bare `except:` or catch `Exception` unless re-raising or at an isolation boundary.
- Minimize code inside `try` blocks.
- Use `finally` for cleanup; prefer `with` statements for resources.

## Key Rules

- **No mutable default arguments**. Use `None` and assign inside the function:
  ```python
  # Yes
  def foo(items: list[int] | None = None) -> None:
      if items is None:
          items = []
  # No
  def foo(items: list[int] = []) -> None: ...
  ```
- **Use `is` / `is not` for `None` comparisons**, never `==` / `!=`.
- **Use implicit false**: `if not users:` instead of `if len(users) == 0:`.
- **Close resources with `with` statements**.
- **Functions should be ≤40 lines** where practical.
- **Comprehensions**: single `for` clause only; no nested `for` in one expression.
- **Avoid `staticmethod`**. Use module-level functions instead.
- **Main guard**: Always use `if __name__ == '__main__':`.
- **Logging**: Use %-placeholders, not f-strings: `logger.info('Value: %s', val)`.

---

## Enforcement

### Ruff Configuration (`pyproject.toml`)

```toml
[tool.ruff]
target-version = "py311"
line-length = 80
indent-width = 4

[tool.ruff.lint]
select = [
    "E",    # pycodestyle errors
    "F",    # pyflakes
    "W",    # pycodestyle warnings
    "I",    # isort
    "D",    # pydocstyle
    "UP",   # pyupgrade
    "N",    # pep8-naming
    "ANN",  # flake8-annotations
    "B",    # flake8-bugbear (catches mutable defaults, etc.)
    "A",    # flake8-builtins
    "RUF",  # ruff-specific rules
]
ignore = [
    "ANN101",  # missing type annotation for self
    "ANN102",  # missing type annotation for cls
    "D203",    # conflicts with D211 (no-blank-line-before-class)
    "D213",    # conflicts with D212 (multi-line-summary-first-line)
]

[tool.ruff.lint.pydocstyle]
convention = "google"

[tool.ruff.lint.isort]
known-first-party = ["myproject"]  # Replace with your project name
section-order = ["future", "standard-library", "third-party", "first-party", "local-folder"]
force-single-line = false
force-sort-within-sections = true

[tool.ruff.format]
quote-style = "single"
indent-style = "space"
line-ending = "auto"
```

### Pre-commit Configuration (`.pre-commit-config.yaml`)

```yaml
repos:
  - repo: https://github.com/astral-sh/ruff-pre-commit
    rev: v0.8.6  # pin to a specific version
    hooks:
      - id: ruff
        args: [--fix, --exit-non-zero-on-fix]
      - id: ruff-format

  - repo: https://github.com/pre-commit/mirrors-mypy
    rev: v1.14.1  # pin to a specific version
    hooks:
      - id: mypy
        additional_dependencies: []  # add stubs as needed, e.g. types-requests

  - repo: https://github.com/pre-commit/pre-commit-hooks
    rev: v5.0.0
    hooks:
      - id: trailing-whitespace
      - id: end-of-file-fixer
      - id: check-yaml
      - id: check-added-large-files
      - id: debug-statements
```

### Setup Instructions

```bash
# Install tools
pip install ruff mypy pre-commit

# Install pre-commit hooks
pre-commit install

# Run ruff manually
ruff check .            # lint
ruff check --fix .      # lint + autofix
ruff format .           # format

# Run mypy
mypy .
```
