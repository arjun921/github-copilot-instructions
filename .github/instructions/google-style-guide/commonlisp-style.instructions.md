---
description: "Use when writing, reviewing, or modifying Common Lisp code. Enforces Google Common Lisp Style Guide conventions for formatting, naming, documentation, error handling, and Lisp-specific best practices."
applyTo:
  - "**/*.lisp"
  - "**/*.cl"
  - "**/*.asd"
---

# Google Common Lisp Style Guide

Reference: https://google.github.io/styleguide/lispguide.xml

## Formatting

- **Indentation**: Use 2 spaces for body forms (e.g., `defun`, `let`, `when`, `loop`). Align argument forms vertically with the first argument when on separate lines.
- **Line length**: 100 characters max.
- **Closing parentheses**: Always on the same line as the last element. Never place closing parens on their own line.
- **No tabs**: Use spaces only.
- **Horizontal whitespace**: No spaces inside parentheses. No space before opening paren. One space between elements.
- **Vertical whitespace**: One blank line between top-level forms. No excessive blank lines within forms.
- **Indent as Emacs does**: Maintain consistent indentation style as produced by a properly configured GNU Emacs with `common-lisp-indent-function`.

```lisp
;; Good
(defun factorial (n)
  (if (<= n 1)
      1
      (* n (factorial (1- n)))))

;; Bad — closing parens on separate lines
(defun factorial (n)
  (if (<= n 1)
      1
      (* n (factorial (1- n)))
  )
)
```

## Naming

- **General**: Use lowercase with hyphens (`kebab-case`) for all symbols: `compute-total`, `parse-input`.
- **Global/special variables**: Surround with asterisks (earmuffs): `*default-timeout*`, `*database-connection*`.
- **Constants**: Surround with plus signs: `+max-retries+`, `+pi+`.
- **Predicates**: End with `p` for single-word names (`evenp`) or `-p` for multi-word names (`list-empty-p`).
- **Packages**: Use lowercase hyphenated names: `my-project`, `web-server`.
- **No library prefixes**: Do not embed package names into symbol names. Use the package system for namespacing.
- **Intent over content**: Name variables by their purpose, not their type: use `user-count` not `integer-value`.
- **Spelling**: Use correct spelling. Use common abbreviations consistently.

| Type | Convention | Example |
|------|-----------|---------|
| Functions/variables | `kebab-case` | `compute-result` |
| Special/global variables | `*earmuffs*` | `*output-stream*` |
| Constants | `+plus-signs+` | `+max-size+` |
| Predicates | ends in `p` / `-p` | `validp`, `list-empty-p` |
| Packages | `lowercase-hyphenated` | `my-package` |
| Classes | `kebab-case` | `http-request` |
| Slots/accessors | `kebab-case` | `request-method` |

## Documentation

- **Docstrings**: Provide docstrings for all exported functions, variables, macros, classes, and generic functions.
- **Grammar**: Use proper grammar and punctuation in docstrings. Start with a complete sentence describing the purpose.
- **File header**: Include a description at the top of each source file. Do not include authorship or copyright in individual files.
- **DSLs**: Document domain-specific languages and any terse programs written in them.

```lisp
(defun parse-uri (string &key (scheme :http))
  "Parse STRING as a URI and return a URI object.
Optionally specify SCHEME as the default scheme when none is present
in the input string."
  ...)
```

## Comments

- **`;;;;`** (four semicolons): File-level comments, top-of-file headers.
- **`;;;`** (three semicolons): Section headers and major commentary blocks within a file.
- **`;;`** (two semicolons): In-code comments, aligned with the code they describe.
- **`;`** (one semicolon): End-of-line comments, separated by at least one space from the code.
- **TODO comments**: Use `TODO` for code requiring special attention. Include context about what needs to be done.

```lisp
;;;; file: parser.lisp — URI parsing utilities

;;; Section: Main parser entry points

(defun parse-token (stream)
  ;; Read until we hit a delimiter
  (let ((token (make-array 0 :element-type 'character :adjustable t)))
    (loop for char = (read-char stream nil nil) ; peek at next char
          while (and char (not (delimiter-p char)))
          do (vector-push-extend char token))
    token))
```

## Error Handling

- **Use the condition system**: Prefer `handler-case` and `handler-bind` over ad-hoc error returns.
- **Define custom conditions**: Create specific condition types for your domain using `define-condition`.
- **Restarts**: Provide restarts where callers may want recovery options using `restart-case`.
- **Assertions**: Use `assert`, `check-type`, and `etypecase` for runtime type and value checking.
- **Don't ignore errors silently**: Always handle or propagate conditions explicitly.

```lisp
(define-condition invalid-input-error (error)
  ((input :initarg :input :reader invalid-input))
  (:report (lambda (condition stream)
             (format stream "Invalid input: ~A" (invalid-input condition)))))

(defun process-data (input)
  "Process INPUT, signaling INVALID-INPUT-ERROR if INPUT is malformed."
  (restart-case
      (unless (valid-input-p input)
        (error 'invalid-input-error :input input))
    (use-default ()
      :report "Use default input instead."
      (process-data *default-input*))))
```

## Macros

- **Use only when functions won't do**: Macros are for syntactic abstraction. If a function suffices, use a function.
- **Avoid variable capture**: Use `gensym` or the `with-gensyms` utility to generate unique symbols for macro-internal bindings.
- **Keep it simple**: Macros should expand to minimal, obvious code. Complex logic belongs in helper functions called by the expansion.
- **Document macro syntax**: Docstrings for macros should describe the syntax and expansion behavior.
- **Use `EVAL-WHEN` correctly**: When needed, use all three situations: `(:compile-toplevel :load-toplevel :execute)`.

```lisp
(defmacro with-retry ((&key (max-attempts 3) (delay 1)) &body body)
  "Execute BODY, retrying up to MAX-ATTEMPTS times with DELAY seconds between attempts."
  (let ((attempts (gensym "ATTEMPTS"))
        (result (gensym "RESULT")))
    `(loop for ,attempts from 1 to ,max-attempts
           do (handler-case
                  (return (progn ,@body))
                (error (c)
                  (when (= ,attempts ,max-attempts)
                    (error c))
                  (sleep ,delay))))))
```

## Style Rules

- **Prefer functional style**: Avoid side-effects when not necessary. Favor pure functions and immutable data.
- **Favor iteration over recursion**: Use `loop`, `dolist`, `dotimes` for iteration rather than recursive patterns, unless recursion is natural for the algorithm.
- **`let` vs. `let*`**: Use `let` by default. Use `let*` only when bindings depend on earlier bindings in the same form.
- **Single-branch conditionals**: Use `when` for single positive-branch, `unless` for single negative-branch. Do not use `if` with a `nil` else-branch.
- **Multi-branch conditionals**: Use `cond` for multi-way branching. Use `case`/`ecase`/`etypecase` when testing against constants.
- **Avoid `progn`/`prog1`/`prog2`**: Restructure code to avoid sequencing forms when possible. Use implicit `progn` in `let`, `when`, `unless`, `defun`, etc.
- **Use special variables sparingly**: Prefer explicit parameter passing. Use dynamic binding only when it provides clear benefit.
- **Assignment**: Be consistent. Use `setf` as the universal assignment operator; avoid `setq` in new code.
- **Do not use `EVAL` at runtime**: Find a proper solution instead.
- **Do not use `INTERN`/`UNINTERN` at runtime**.
- **Prefer `#'function` over `'function`**: Use `#'fun` to reference functions, not `'fun`.
- **Use proper data structures**: Do not abuse lists. Use structures, classes, hash tables, or arrays as appropriate.
- **Avoid `NCONC`**: Prefer `append` or better data structures over destructive list operations.
- **Use `REDUCE` over `APPLY`**: Prefer `(reduce #'+ list)` over `(apply #'+ list)` for variable-length argument lists.
- **Type declarations**: When you know the type, declare it to enable compile-time and runtime checking.

## Enforcement

Common Lisp has limited automated formatting and linting tooling compared to other languages. Enforcement relies heavily on editor configuration and code review.

### Emacs Configuration

```elisp
;; Use common-lisp-style indentation
(setq lisp-indent-function 'common-lisp-indent-function)

;; Use SLIME or SLY for interactive development
;; SLIME: https://common-lisp.net/project/slime/
;; SLY: https://github.com/joaotavora/sly
```

### Pre-commit Configuration (`.pre-commit-config.yaml`)

```yaml
repos:
  - repo: https://github.com/pre-commit/pre-commit-hooks
    rev: v5.0.0
    hooks:
      - id: trailing-whitespace
      - id: end-of-file-fixer
      - id: check-added-large-files
```

### Setup Instructions

```bash
# Common Lisp lacks comprehensive automated formatters comparable to other languages.
# Use editor-based formatting (Emacs + SLIME/SLY recommended).

# Install Roswell (Common Lisp installer/launcher)
# https://github.com/roswell/roswell

# Install sblint (a linter for Common Lisp using SBCL)
ros install cxxxr/sblint

# Run sblint
sblint src/
```

Note: Common Lisp relies more heavily on editor-integrated tools (Emacs + SLIME/SLY) for formatting enforcement. Automated pre-commit linting is limited.
