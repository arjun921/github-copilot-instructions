---
description: "Use when writing, reviewing, or modifying Objective-C or Objective-C++ code. Enforces Google Objective-C Style Guide conventions for formatting, naming, patterns, memory management, imports, nullability, properties, initializers, and Cocoa best practices."
applyTo: ["**/*.m", "**/*.mm", "**/*.h"]
---

# Google Objective-C Style Guide

Reference: https://google.github.io/styleguide/objcguide.html

## Formatting

- **Indentation**: 2 spaces. Never tabs. Trim trailing spaces.
- **Line length**: 100 characters max. Objective-C++ projects may opt for 80 columns for C++ consistency.
- **Braces**: K&R style — `} else {` on same line, `@catch`/`@finally` on same line as preceding `}`.
- **Spaces after control flow keywords**: `if`, `while`, `for`, `switch`. Space around comparison operators.
- **Binary operators**: space around `=`, `+`, `-`, `*`, etc. No space for unary operators. No spaces inside parentheses.
- **Method declarations**: one space between `-`/`+` and return type. No space between parameters except between them. Wrap long parameter lists one-per-line with colon alignment and at least 4-space indent.
- **Method invocations**: all arguments on one line, or one argument per line with colon alignment. Never mix.
- **Function declarations**: return type on same line as function name. Wrapped parameters indented 4 spaces. Open brace on last line of declaration.
- **Braces may be omitted** only when the loop/conditional body fits on a single line. If `if` has `else`, both clauses must use braces.
- **Switch fall-through**: document with `// Falls through.` comment. Cases with no code between them need no comment.
- **Vertical whitespace**: use sparingly. No blank lines just inside braces. One or two between functions/logical groups.
- **Function length**: prefer ≤40 lines. Break up longer functions when possible.

## Naming Conventions

| Type | Convention | Example |
|------|-----------|---------|
| Classes/Protocols/Categories | `UpperCamelCase` with prefix | `GTMExample`, `GTMExampleDelegate` |
| Methods/Parameters | `lowerCamelCase` | `doWorkWithBlah:` |
| Functions (C) | `UpperCamelCase` (static), prefixed (non-static) | `AddTableEntry()`, `GTMGetDefaultTimeZone()` |
| Variables | `lowerCamelCase` | `numberOfErrors` |
| Instance variables | `_lowerCamelCase` (leading underscore) | `_usernameTextField` |
| Global variables | `g` prefix | `gGlobalCounter` |
| Constants (file-scope) | `k` prefix for static storage | `kFileCount`, `kUserKey` |
| Constants (external) | `ClassNameConstantName` | `GTLServiceErrorDomain` |
| Macros | `SHOUTY_SNAKE_CASE` | `GTM_EXPERIMENTAL_BUILD` |
| Enums (NS_ENUM values) | Extend the typedef name | `DisplayTingeGreen` |

- Be descriptive. Avoid non-standard abbreviations.
- Use ALL CAPS for acronyms/initialisms within names: `URL`, `ID`, `TIFF`.
- **Prefixes**: 3+ letter uppercase prefix for classes, protocols, global functions, and global constants. Apple reserves 2-letter prefixes.
- **Category naming**: prefix category name (`GTMCrashReporting`), prefix methods with lowercase prefix + underscore (`gtm_methodName:`).
- **File names**: match the class name including case. Categories: `ClassName+CategoryName.h/m`.
- **Method names**: read like a sentence. Use prepositions (`with`, `from`, `to`) only when needed for clarity. Name accessors after the property — no `get` prefix. Boolean getters use `is` prefix but property name omits it.
- **Dot notation**: only with property names, not method calls.

## Imports and Includes

- **`#import`** for Objective-C/Objective-C++ headers. **`#include`** for C/C++ headers.
- **`@import`** or `#import` umbrella headers for system frameworks (e.g., `@import UIKit;`, `#import <Foundation/Foundation.h>`). Do not import individual framework headers.
- **Include order** (separated by blank lines):
  1. Related header (e.g., `Foo.h` for `Foo.m`)
  2. System/OS headers
  3. Language library headers
  4. Other dependency groups
- Within each group, sort alphabetically.

## Properties and Instance Variables

- **Properties over direct ivar access**. Use `@property` declarations.
- Declare ivars in implementation files or let them be auto-synthesized. If in a header, mark `@protected` or `@private`.
- Use `copy` for properties with mutable variants (`NSString`, `NSArray`, `NSDictionary`, `NSSet`).
- Use **lightweight generics** on all `NSArray`, `NSDictionary`, `NSSet` references: `NSArray<NSString *> *`.
- **Avoid redundant property access**: assign to a local variable when used multiple times.
- Omit empty braces `{}` on interfaces/implementations without ivars.

## Memory Management (ARC)

- **Use ARC** (Automatic Reference Counting). No manual `retain`/`release`/`autorelease`.
- Use `__weak` to break retain cycles. Delegates and targets should be weak.
- Block pointers for callbacks should be released after use to avoid retain cycles.
- Use `__weak __typeof__(self) weakSelf = self;` for self-references in blocks. Prefer `__typeof__` over `typeof`.
- **Copy potentially mutable objects** when receiving and retaining them. Copy before dispatching to async queues.
- In `-dealloc`, avoid messaging self. Directly release ivars and remove observers.
- Do not use `+new`. Use `+alloc` and `-init`.

## Initializers

- **Identify designated initializers** with `NS_DESIGNATED_INITIALIZER`.
- Override superclass designated initializers in subclasses.
- Place overridden `NSObject` methods (`init...`, `dealloc`, `description`, `isEqual:`, `hash`) at the top of `@implementation`.
- Do not initialize ivars to `0` or `nil` in `init` — the runtime already does this.
- **Avoid messaging self** in `init` and `dealloc`. Assign ivars directly.

## Modern Objective-C Features

- **`NS_ENUM` / `NS_OPTIONS`** for all enumerations. Use `int32_t` for underlying type.
- **Objective-C literals**: `@[]`, `@{}`, `@YES`, `@NO`, `@42`, `@"string"`.
- **Nullability annotations**: use `NS_ASSUME_NONNULL_BEGIN`/`END` regions. Annotate with `nonnull`, `nullable`, `null_resettable` (context-sensitive keywords) for methods/properties. Use `_Nonnull`/`_Nullable` for C functions. Prefer `_Nullable` over `__nullable`.
- **Avoid exceptions**: don't `@throw`. Use `NSError` for error delivery. `@try`/`@catch` only for third-party code.
- **Avoid macros**: prefer `const`, enums, C functions. If needed, use unique names and `#undef` after use.
- **BOOL pitfalls**: never compare directly with `YES`. Use conditional operators for integer-to-BOOL conversions. Use `@YES`/`@NO` literals, not boxed expressions `@(YES)`.
- **Avoid unsigned integers** except when matching system interfaces. Use signed integers for math.
- **`nil` checks**: don't guard against sending messages to `nil` — the runtime handles it safely. Do guard C/C++ pointers against `NULL`.

## Cocoa Patterns

- **Delegate pattern**: don't retain delegates (use `weak`). Release when no longer needed.
- **Keep public API simple**: don't expose methods that should be private.
- **`__auto_type`**: allowed only for block and function pointer types, not for general variables.

## Objective-C++

- Follow Objective-C naming in `@implementation` blocks, C++ naming in C++ class methods.
- Be consistent within a file for code outside class implementations.

## Comments

- **Declaration comments**: all non-trivial interfaces, properties, classes, categories, protocols, and enums must have Doxygen-style (`/** */`) comments.
- **Recommended declaration order** in `@interface`: properties, class methods, initializers, instance methods.
- **Implementation comments**: explain tricky/subtle code. 2+ spaces before end-of-line comments.
- Use `@c` for symbol references in Doxygen comments, backticks in regular comments.
- Use descriptive form ("Opens the file") not imperative ("Open the file").

## Style Exceptions

- Use `// NOLINT` at end of line or `// NOLINTNEXTLINE` on the previous line to suppress style warnings.

---

## Enforcement

### clang-format

`.clang-format`:
```yaml
BasedOnStyle: Google
Language: ObjC
IndentWidth: 2
ColumnLimit: 100
ObjCBlockIndentWidth: 2
ObjCSpaceAfterProperty: true
ObjCSpaceBeforeProtocolList: true
AlignConsecutiveDeclarations: false
AllowShortIfStatementsOnASingleLine: true
AllowShortLoopsOnASingleLine: true
```

### OCLint

`.oclint` configuration file:
```yaml
rules:
  - LongMethod
  - LongLine
  - UnusedMethodParameter
  - EmptyIfStatement
  - EmptyCatchStatement

rule-configurations:
  - key: LONG_LINE
    value: 100
  - key: LONG_METHOD
    value: 40

disable-rules:
  - ShortVariableName
```

### Pre-commit

`.pre-commit-config.yaml` snippet:
```yaml
repos:
  - repo: https://github.com/pre-commit/mirrors-clang-format
    rev: v19.1.0
    hooks:
      - id: clang-format
        types_or: [objective-c, objective-c++, c]
        args: [--style=file]

  - repo: https://github.com/pre-commit/pre-commit-hooks
    rev: v5.0.0
    hooks:
      - id: trailing-whitespace
        files: \.(m|mm|h)$
      - id: end-of-file-fixer
        files: \.(m|mm|h)$
```

### Setup Instructions

1. **Install clang-format**: `brew install clang-format` (macOS) or via Xcode toolchain.
2. **Place `.clang-format`** in the project root.
3. **Install OCLint**: `brew install oclint` or download from [oclint.org](https://oclint.org).
4. **Place `.oclint`** in the project root.
5. **Install pre-commit**: `pip install pre-commit && pre-commit install`.
6. **Format on save**: configure your editor to run `clang-format` on save for `.m`, `.mm`, and `.h` files.
7. **CI integration**: add `clang-format --dry-run --Werror` and `oclint` steps to your CI pipeline.
