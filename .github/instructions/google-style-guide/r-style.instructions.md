---
description: "Use when writing, reviewing, or modifying R code. Enforces Google R Style Guide conventions (forked from Tidyverse Style Guide) for naming, formatting, pipes, namespaces, documentation, and R-specific best practices."
applyTo: "**/*.R"
---

# Google R Style Guide

Reference: https://google.github.io/styleguide/Rguide.html
Base: [Tidyverse Style Guide](https://style.tidyverse.org/) with Google-specific overrides below.

## Key Google Overrides from Tidyverse

### Naming Conventions
| Type | Convention |
|------|-----------|
| Functions | `BigCamelCase` |
| Private functions | `.BigCamelCase` (prefix with dot) |
| Variables | `snake_case` or `BigCamelCase` |
| Constants | `kConstantName` |
| S4 classes | `BigCamelCase` |

- Do NOT use `dot.case` for names (deprecated).

### Formatting
- **Line length**: 80 characters max.
- **Indentation**: 2 spaces. Never tabs.
- **Assignment**: Use `<-` for assignment, not `=`.
- **No right-hand assignment**: Never use `->`.
- **Spacing**: Space after commas, around `<-`, around infix operators.

### Explicit Returns
- Always use explicit `return()` — do not rely on implicit return of last expression.
```r
# Good
AddValues <- function(x, y) {
  return(x + y)
}

# Bad
AddValues <- function(x, y) {
  x + y
}
```

### Namespace Qualification
- Explicitly qualify namespaces for all external functions: `purrr::map()`, `dplyr::filter()`.
- Do not use `@import` Roxygen tag to import entire namespaces.
- Exceptions: infix functions (`%name%`), `rlang` pronouns (`.data`), functions from default R packages.

### Pipes
- No right-hand assignment with pipes.
- Prefer native pipe `|>` (R 4.1+) or magrittr `%>%`.

### Don't Use `attach()`
- Never use `attach()`.

## Documentation
- Use Roxygen2 (`#'`) for all exported functions.
- All packages must have a `packagename-package.R` file.
- Place `@importFrom` tags in the Roxygen header above functions where the dependency is used.

---

## Enforcement

### lintr Configuration (`.lintr`)

```yaml
linters:
  linters_with_defaults(
    line_length_linter(80),
    assignment_linter(),
    object_name_linter(styles = c("CamelCase", "snake_case")),
    trailing_whitespace_linter(),
    spaces_inside_linter(),
    commas_linter(),
    T_and_F_symbol_linter()
  )
```

### styler Configuration

Use the `tidyverse_style` from the `styler` package with Google overrides applied manually:

```r
# Format files
styler::style_file("script.R", style = styler::tidyverse_style)
styler::style_dir("R/", style = styler::tidyverse_style)
```

### Pre-commit Configuration (`.pre-commit-config.yaml`)

```yaml
repos:
  - repo: https://github.com/lorenzwalthert/precommit
    rev: v0.4.3
    hooks:
      - id: style-files
        args: [--style_pkg=styler, --style_fun=tidyverse_style]
      - id: lintr
      - id: parsable-R
      - id: no-browser-statement
      - id: deps-in-desc
      - id: readme-rmd-rendered

  - repo: https://github.com/pre-commit/pre-commit-hooks
    rev: v5.0.0
    hooks:
      - id: trailing-whitespace
      - id: end-of-file-fixer
      - id: check-yaml
```

### Setup Instructions

```bash
# Install R packages
Rscript -e 'install.packages(c("lintr", "styler"))'

# Install pre-commit hooks (requires precommit R package)
Rscript -e 'install.packages("precommit")'
Rscript -e 'precommit::use_precommit()'

# Run lintr manually
Rscript -e 'lintr::lint("script.R")'
Rscript -e 'lintr::lint_dir("R/")'

# Run styler manually
Rscript -e 'styler::style_file("script.R")'
Rscript -e 'styler::style_dir("R/")'
```
