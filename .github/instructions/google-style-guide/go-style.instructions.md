---
description: "Use when writing, reviewing, or modifying Go code. Enforces Google Go Style Guide conventions for formatting, naming, error handling, documentation, imports, interfaces, testing, and Go-specific practices."
applyTo: "**/*.go"
---

# Google Go Style Guide

Reference: https://google.github.io/styleguide/go/

## Formatting

- **gofmt is mandatory**. All Go source files must conform to `gofmt` output. No configuration needed — tabs for indentation, spaces for alignment.
- **goimports** should be used to manage import grouping and removal of unused imports.
- **No fixed line length**. If a line feels too long, prefer refactoring over splitting. Do not split before an indentation change (function declarations, conditionals).
- **Function signatures** should remain on a single line to avoid indentation confusion. Factor out local variables to shorten call sites instead of wrapping arguments.
- **Matching braces**: closing brace on a line with the same indentation as the opening brace. Multi-line struct literals must have a trailing comma and closing brace on a new line.

## Naming Conventions

| Type | Convention | Example |
|------|-----------|---------|
| Exported names | `MixedCaps` (PascalCase) | `MaxLength`, `UserCount` |
| Unexported names | `mixedCaps` (camelCase) | `maxLength`, `userCount` |
| Packages | lowercase, single-word, no underscores | `strconv`, `httputil` |
| Constants | `MixedCaps` (NOT `ALL_CAPS`) | `MaxPacketSize` |
| Interfaces | noun or `-er` suffix | `Reader`, `Stringer` |
| Receiver | 1–2 letter abbreviation, consistent | `func (s *Server)` |
| Acronyms/Initialisms | all-caps or all-lower | `URL`, `xmlAPI`, `ID` |

- **Variable name length proportional to scope**: short names (`i`, `r`, `w`) in small scopes; descriptive names (`userCount`) in large scopes.
- **No `Get` prefix** on getters: use `Name()` not `GetName()`. Use `Compute` or `Fetch` for expensive operations.
- **Avoid repetition** with package name: `widget.New()` not `widget.NewWidget()`.
- **No underscores** in names except `_test.go` files and generated code.
- **Package names**: avoid `util`, `helper`, `common`, `model`. Name should relate to what the package provides.
- Omit types from variable names: `users` not `userSlice`, `count` not `numUsers`.
- Name constants by role, not value: `MaxRetries` not `Three`.

## Error Handling

- **Always check errors**. Do not discard errors with `_` unless explicitly documented as safe (e.g., `bytes.Buffer.Write`).
- **Return `error` as the last return value**. Return `nil` error for success.
- **Handle errors immediately**: handle, return to caller, or in exceptional cases call `log.Fatal`.
- **Error strings**: lowercase, no punctuation. They appear in larger context.
  ```go
  // Good
  fmt.Errorf("something bad happened")
  // Bad
  fmt.Errorf("Something bad happened.")
  ```
- **Return early with guard clauses** (indent error flow). Keep the happy path at the left edge.
  ```go
  // Good
  val, err := doSomething()
  if err != nil {
      return err
  }
  // use val
  ```
- **Wrap errors** with `%w` for programmatic inspection, `%v` for simple annotation. Place `%w` at the end of format strings.
- **Don't add redundant context**: if the underlying error already includes the information, don't repeat it.
- **Don't use `panic`** for normal error handling. Use `error` and multiple return values. Reserve `panic` for truly unrecoverable invariant violations and API misuse (like the standard library does).
- **Avoid naked returns** in anything but the smallest functions. Be explicit with returned values.
- **Exported functions returning errors** must use the `error` interface type, not concrete error types.

## Documentation (Godoc)

- **All exported names must have doc comments**. Unexported types with non-obvious behavior should too.
- **Start comments with the name** of the thing being described. Use a full sentence.
  ```go
  // Request represents a request to run a command.
  type Request struct { ... }

  // Encode writes the JSON encoding of req to w.
  func Encode(w io.Writer, req *Request) { ... }
  ```
- **Package comments**: immediately above `package` clause, no blank line between. Start with `// Package <name> ...`.
  ```go
  // Package math provides basic constants and mathematical functions.
  package math
  ```
- **Comment sentences**: doc comments should be complete sentences, capitalized and punctuated. End-of-line struct field comments can be fragments.
- **Don't restate obvious parameters**. Document error-prone, non-obvious, or interesting fields.
- **Runnable examples** (`func ExampleFoo()` in `_test.go` files) are preferred over code in comments.
- Use **blank lines** to separate paragraphs in comments. Indent code blocks by two extra spaces.

## Imports

- **Group imports** in this order, separated by blank lines:
  1. Standard library
  2. Third-party packages
  3. Local/project packages
- **Don't rename imports** unless necessary to avoid collision. If renaming, follow package naming rules.
- **Avoid dot imports** (`import . "pkg"`) except in test files that need it for readability.
- **Avoid blank imports** (`import _ "pkg"`) except for side effects (e.g., database drivers), with a comment explaining why.

## Go-Specific Practices

- **`context.Context` as first parameter**. Do not store contexts in structs. Pass explicitly to every function that needs one.
  ```go
  func (s *Server) Handle(ctx context.Context, req *Request) error { ... }
  ```
- **Avoid `init()` functions** when possible. They make code harder to test and reason about. Prefer explicit initialization.
- **Interfaces**: keep them small. Accept interfaces, return concrete types. Define interfaces at the consumer, not the producer. Don't create interfaces before a real need exists.
- **Don't use `panic`/`recover`** for control flow. If you must panic internally, always recover at the package boundary.
- **Prefer `:=`** over `var` when initializing with a non-zero value. Use `var` for zero-value declarations.
- **Nil slices**: prefer `var s []T` (nil) over `s := []T{}` (empty). Use `len(s) == 0` to check emptiness, not `s == nil`.
- **Goroutine lifetimes**: never start a goroutine without knowing how it will stop. Use context cancellation or done channels.
- **`Must` functions** (`MustParse`, `MustCompile`): only for package-level initialization or test helpers. Never in request handlers.
- **Use `%q`** for quoting strings in format output, especially when values could be empty.
- **Table-driven tests**: preferred for testing multiple cases. Use subtests with `t.Run`. Print `got` before `want`. Use `cmp.Diff` for struct comparison.
- **Global state**: approach with extreme scrutiny. Prefer dependency injection.
- **String building**: use `+` for simple cases, `fmt.Sprintf` for formatting, `strings.Builder` for piecemeal construction.

## Enforcement

### gofmt / goimports

`gofmt` is the standard Go formatter — no configuration needed. `goimports` extends it to manage imports.

```bash
# Format all Go files
gofmt -w .

# Format and fix imports
goimports -w .
```

Install goimports:
```bash
go install golang.org/x/tools/cmd/goimports@latest
```

### golangci-lint Configuration

Create `.golangci.yml` in the project root:

```yaml
run:
  timeout: 5m

linters:
  enable:
    - errcheck        # Check that errors are handled
    - govet           # Reports suspicious constructs
    - ineffassign     # Detects unused variable assignments
    - staticcheck     # Advanced static analysis
    - unused          # Finds unused code
    - goimports       # Enforces goimports formatting
    - revive          # Extensible linter (replaces golint)
    - gosimple        # Simplification suggestions
    - gocritic        # Opinionated style checks
    - unconvert       # Remove unnecessary type conversions
    - unparam         # Reports unused function parameters
    - misspell        # Catches common misspellings
    - nakedret        # Flags naked returns in large functions
    - exportloopref   # Catches loop variable capture bugs
    - noctx           # Finds HTTP requests without context
    - errorlint       # Checks error wrapping and comparison

linters-settings:
  nakedret:
    max-func-lines: 10
  revive:
    rules:
      - name: exported
        arguments:
          - checkPrivateReceivers
      - name: var-naming
      - name: package-comments
      - name: error-return
      - name: error-naming
      - name: context-as-argument
      - name: context-keys-type
      - name: dot-imports
      - name: blank-imports
  gocritic:
    enabled-tags:
      - diagnostic
      - style
      - opinionated
  errorlint:
    errorf: true
    asserts: true
    comparison: true

issues:
  exclude-use-default: false
  max-issues-per-linter: 0
  max-same-issues: 0
```

### Pre-commit Configuration

Add to `.pre-commit-config.yaml`:

```yaml
repos:
  - repo: https://github.com/dnephin/pre-commit-golang
    rev: v0.5.1
    hooks:
      - id: go-fmt
      - id: go-imports
        args: ['-w']
      - id: go-vet
      - id: go-build
      - id: go-mod-tidy

  - repo: https://github.com/golangci/golangci-lint
    rev: v1.62.2
    hooks:
      - id: golangci-lint
        args: ['--config=.golangci.yml']
```

### Makefile Targets

```makefile
.PHONY: fmt lint vet test check

## Format all Go files with gofmt and goimports
fmt:
	gofmt -w .
	goimports -w .

## Run golangci-lint
lint:
	golangci-lint run --config .golangci.yml ./...

## Run go vet
vet:
	go vet ./...

## Run all tests
test:
	go test -race -count=1 ./...

## Run all checks (format, vet, lint, test)
check: fmt vet lint test
```

### Setup Instructions

```bash
# Install Go tools
go install golang.org/x/tools/cmd/goimports@latest
go install github.com/golangci/golangci-lint/cmd/golangci-lint@latest

# Install pre-commit (if not already installed)
pip install pre-commit
pre-commit install

# Verify setup
gofmt -l .
golangci-lint run ./...
go vet ./...
go test -race ./...
```
