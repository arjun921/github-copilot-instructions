# Google Style Guide Instructions

Copilot instruction files derived from the
[Google Style Guides](https://google.github.io/styleguide/). Each file
encodes the key rules from its corresponding guide so that GitHub Copilot
produces code conforming to Google conventions out of the box.

## How it works

Each `.instructions.md` file has:

- **YAML frontmatter** with a `description` (for on-demand discovery) and
  `applyTo` glob (so the instruction auto-attaches when you edit matching
  files).
- **Style rules** — the most impactful conventions from the Google guide,
  covering naming, formatting, imports, documentation, and language-specific
  idioms.
- **Enforcement section** — copy-paste-ready configuration for the
  recommended linter, formatter, and pre-commit hooks for that language.

When you run `make export`, all files are flattened into your VS Code
user-level `instructions/` directory where Copilot picks them up
automatically.

## Languages covered

### Systems languages

| File | Source guide | Enforcement tooling |
|------|-------------|---------------------|
| `cpp-style.instructions.md` | [C++ Style Guide](https://google.github.io/styleguide/cppguide.html) | clang-format (Google preset), clang-tidy, cpplint |
| `csharp-style.instructions.md` | [C# Style Guide](https://google.github.io/styleguide/csharp-style.html) | `dotnet format`, StyleCop Analyzers |
| `objectivec-style.instructions.md` | [Objective-C Style Guide](https://google.github.io/styleguide/objcguide.html) | clang-format (Google preset) |
| `swift-style.instructions.md` | [Swift Style Guide](https://google.github.io/swift/) | swift-format, SwiftLint |
| `go-style.instructions.md` | [Go Style Guide](https://google.github.io/styleguide/go/) | gofmt, goimports, go vet, golangci-lint |

### Application languages

| File | Source guide | Enforcement tooling |
|------|-------------|---------------------|
| `python-style.instructions.md` | [Python Style Guide](https://google.github.io/styleguide/pyguide.html) | Ruff (lint + format), mypy, pre-commit |
| `java-style.instructions.md` | [Java Style Guide](https://google.github.io/styleguide/javaguide.html) | google-java-format, Checkstyle (google_checks.xml) |
| `javascript-style.instructions.md` | [JavaScript Style Guide](https://google.github.io/styleguide/jsguide.html) | ESLint (eslint-config-google), Prettier |
| `typescript-style.instructions.md` | [TypeScript Style Guide](https://google.github.io/styleguide/tsguide.html) | ESLint (@typescript-eslint), Prettier |
| `r-style.instructions.md` | [R Style Guide](https://google.github.io/styleguide/Rguide.html) | lintr, styler (tidyverse base + Google overrides) |
| `commonlisp-style.instructions.md` | [Common Lisp Style Guide](https://google.github.io/styleguide/lispguide.xml) | sblint, Emacs + SLIME/SLY |

### Scripting and config

| File | Source guide | Enforcement tooling |
|------|-------------|---------------------|
| `shell-style.instructions.md` | [Shell Style Guide](https://google.github.io/styleguide/shellguide.html) | ShellCheck, shfmt (Google preset) |
| `vimscript-style.instructions.md` | [Vim script Style Guide](https://google.github.io/styleguide/vimscriptguide.xml) | Vint (vim-vint) |

### Web and data formats

| File | Source guide | Enforcement tooling |
|------|-------------|---------------------|
| `htmlcss-style.instructions.md` | [HTML/CSS Style Guide](https://google.github.io/styleguide/htmlcssguide.html) | Prettier, Stylelint, HTMLHint |
| `json-style.instructions.md` | [JSON Style Guide](https://google.github.io/styleguide/jsoncstyleguide.xml) | Prettier, check-json (pre-commit) |
| `markdown-style.instructions.md` | [Markdown Style Guide](https://google.github.io/styleguide/docguide/style.html) | markdownlint-cli |
| `xml-style.instructions.md` | [XML Document Format Style Guide](https://google.github.io/styleguide/xmlstyle.html) | xmllint, Prettier (plugin-xml) |

### Framework-specific

| File | Source guide | Enforcement tooling |
|------|-------------|---------------------|
| `angularjs-style.instructions.md` | [AngularJS Style Guide](https://google.github.io/styleguide/angularjs-google-style.html) | ESLint (eslint-plugin-angular) |

> **Note:** AngularJS (1.x) is end-of-life. This guide is for maintaining
> legacy codebases only. For new projects, use Angular 2+.

## Enforcement approach

Each instruction file includes a **copy-paste-ready** enforcement section
with configuration for the best available tooling:

| Category | Tools used |
|----------|-----------|
| **Linting** | Language-specific linters (Ruff, ESLint, clang-tidy, golangci-lint, ShellCheck, lintr, etc.) |
| **Formatting** | Autoformatters configured to match Google style (Ruff, Prettier, clang-format, gofmt, google-java-format, swift-format, shfmt, styler) |
| **Pre-commit hooks** | Pre-commit configurations referencing official hook repos — run linters and formatters automatically before each commit |
| **Type checking** | Where applicable (mypy for Python, TypeScript strict mode) |

The config snippets are **templates** — they live inside the instruction
files for reference. Copy them into your project's root when adopting a
language.

## Adding a new language

1. Create `<language>-style.instructions.md` in this folder.
2. Add YAML frontmatter with `description` and `applyTo`.
3. Document the key rules from the official Google style guide.
4. Add an Enforcement section with linter/formatter/pre-commit config.
5. Run `make export` to deploy.

## License

The Google Style Guides are licensed under
[CC-BY 3.0](https://creativecommons.org/licenses/by/3.0/). These
instruction files are derivative summaries for use with AI coding
assistants.
