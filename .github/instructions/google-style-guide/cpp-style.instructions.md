---
description: "Use when writing, reviewing, or modifying C++ code. Enforces Google C++ Style Guide conventions for naming, formatting, headers, namespaces, classes, functions, comments, exceptions, RTTI, and smart pointers."
applyTo: ["**/*.cpp", "**/*.cc", "**/*.h", "**/*.hpp", "**/*.cxx"]
---

# Google C++ Style Guide

Reference: https://google.github.io/styleguide/cppguide.html

## Formatting

- **Indentation**: 2 spaces. Never tabs.
- **Line length**: 80 characters max. Exceptions: comments with URLs, `#include` statements, header guards, and using-declarations.
- **Braces**: Opening brace on the same line as the statement. Closing brace on its own line.
- **Function declarations**: Return type on the same line as function name. Wrap parameters at 4-space indent if they don't fit.
- **Namespace contents are not indented**. Terminate with `// namespace name` comment.
- **Pointer/reference declarators** bind to the type: `char* c`, `const std::string& str`. No space after `*` or `&`.
- **Preprocessor directives** (`#if`, `#define`, `#endif`) always start at column 0, regardless of indentation.
- **Use prefix increment/decrement** (`++i`) unless postfix semantics are required.
- **Floating-point literals** must have digits on both sides of the radix point: `1.0f`, not `1.f`.

## Naming Conventions

| Type | Convention | Example |
|------|-----------|---------|
| Files | `lower_with_under.cc`, `.h` | `my_class.cc` |
| Types (classes, structs, enums, aliases, type template params) | `PascalCase` | `MyExcitingClass` |
| Variables (local, function params) | `snake_case` | `table_name` |
| Class data members | `snake_case_` (trailing underscore) | `table_name_` |
| Struct data members | `snake_case` (no trailing underscore) | `num_entries` |
| Constants (`constexpr`, `const` with static storage) | `kPascalCase` | `kDaysInAWeek` |
| Functions | `PascalCase` | `AddTableEntry()` |
| Accessors/mutators | `snake_case` (may match member) | `count()`, `set_count()` |
| Namespaces | `snake_case` | `my_project` |
| Enumerators | `kPascalCase` | `kOutOfMemory` |
| Macros (avoid if possible) | `ALL_CAPS_WITH_PREFIX` | `MYPROJECT_ROUND(x)` |

## Header Files

- **Header guards**: Use `#ifndef`/`#define`/`#endif`. Format: `PROJECT_PATH_FILE_H_`.
  ```cpp
  #ifndef FOO_BAR_BAZ_H_
  #define FOO_BAR_BAZ_H_
  // ...
  #endif  // FOO_BAR_BAZ_H_
  ```
- **Do not use** `#pragma once`.
- **Headers must be self-contained** (compile on their own).
- **Include what you use**: Do not rely on transitive inclusions.

### Include Order

Separate each group with a blank line, alphabetize within each group:

1. Related header (e.g., `foo.h` for `foo.cc`)
2. C system headers (`<unistd.h>`, `<stdlib.h>`)
3. C++ standard library headers (`<algorithm>`, `<string>`)
4. Other libraries' headers
5. Your project's headers

```cpp
#include "foo/server/fooserver.h"

#include <sys/types.h>
#include <unistd.h>

#include <string>
#include <vector>

#include "base/basictypes.h"
#include "foo/server/bar.h"
```

## Namespaces

- Place code in a namespace. Do not use `using namespace` directives.
- Do not use inline namespaces.
- Namespace contents are **not indented**.
- Terminate with a comment: `}  // namespace my_project`.
- Prefer single-line nested namespace declarations: `namespace my_project::my_component {`.

## Classes

- **Prefer composition over inheritance**. All inheritance should be `public`.
- Mark overrides with `override` (or `final`). Do not repeat `virtual` on overrides.
- Use `explicit` on single-argument constructors and conversion operators (except copy/move constructors).
- **Data members must be `private`** (except in structs or test fixtures).
- **Declaration order** within a class: `public`, then `protected`, then `private`. Within each section: types/aliases → static constants → factory functions → constructors → destructor → methods → data members.
- Use `struct` only for passive data objects with all-public fields and no invariants. Otherwise use `class`.
- Make copy/move semantics explicit: declare, default, or delete them.

## Functions

- **Prefer return values** over output parameters.
- **Write short functions**: aim for ≤40 lines. Break up long functions.
- Input parameters: pass by value or `const` reference. Output parameters: pass by pointer (use `std::optional` for optional inputs).
- Place input-only parameters before output parameters.
- Do not use default arguments on virtual functions.

## Other C++ Features

- **No exceptions**: Do not use C++ exceptions (Google-specific policy). Use error codes, `absl::Status`, or assertions.
- **Avoid RTTI**: Do not use `dynamic_cast` or `typeid` except in unit tests. Prefer virtual methods or the Visitor pattern.
- **Use `nullptr`**, not `NULL` or `0`, for null pointers. Use `'\0'` for null characters.
- **Use C++ casts** (`static_cast`, `const_cast`, `reinterpret_cast`). Do not use C-style casts like `(int)x`.
- **Use `const`** liberally on function parameters, methods, and non-local variables.
- **Use `constexpr`** to define true compile-time constants.
- **Avoid macros**. Prefer inline functions, `const` variables, and enums.
- **Smart pointers**: Prefer `std::unique_ptr` for ownership. Use `std::shared_ptr` only when shared ownership is truly needed. Never use `std::auto_ptr`.
- **Forward declarations**: Avoid them; prefer including the necessary headers.
- **Use `noexcept`** on move constructors and where it accurately reflects semantics.
- **Prefer `sizeof(varname)`** over `sizeof(type)`.

## Comments

- Use `//` style consistently (`/* */` is also acceptable if consistent).
- **File comments**: Start each file with license boilerplate.
- **Class/struct comments**: Describe purpose, usage, and thread-safety on every non-obvious class.
- **Function declaration comments**: Describe what the function does and how to use it. Focus on *what*, not *how*.
- **Function definition comments**: Describe implementation tricks and *why*, not *what*.
- **TODO format**: `// TODO: bug 12345 - Description` or `// TODO(username): Description`.
- Do not state the obvious. Write higher-level comments that explain *why*.

## Enforcement

### `.clang-format`

Place at project root:

```yaml
BasedOnStyle: Google
ColumnLimit: 80
IndentWidth: 2
TabWidth: 2
UseTab: Never
PointerAlignment: Left
DerivePointerAlignment: false
SortIncludes: CaseSensitive
IncludeBlocks: Regroup
IncludeCategories:
  - Regex: '^".*\.h"'
    Priority: 3
  - Regex: '^<sys/.*>'
    Priority: 1
  - Regex: '^<.*\.h>'
    Priority: 1
  - Regex: '^<.*>'
    Priority: 2
```

### `.clang-tidy`

Place at project root:

```yaml
Checks: >
  -*,
  google-*,
  bugprone-*,
  cppcoreguidelines-avoid-non-const-global-variables,
  misc-non-private-member-variables-in-classes,
  modernize-use-nullptr,
  modernize-use-override,
  modernize-use-using,
  modernize-redundant-void-arg,
  readability-avoid-const-params-in-decls,
  readability-braces-around-statements,
  readability-identifier-naming,
  readability-inconsistent-declaration-parameter-name,
  performance-*

CheckOptions:
  - key: readability-identifier-naming.ClassCase
    value: CamelCase
  - key: readability-identifier-naming.StructCase
    value: CamelCase
  - key: readability-identifier-naming.EnumCase
    value: CamelCase
  - key: readability-identifier-naming.FunctionCase
    value: CamelCase
  - key: readability-identifier-naming.VariableCase
    value: lower_case
  - key: readability-identifier-naming.MemberCase
    value: lower_case
  - key: readability-identifier-naming.MemberSuffix
    value: '_'
  - key: readability-identifier-naming.ConstexprVariableCase
    value: CamelCase
  - key: readability-identifier-naming.ConstexprVariablePrefix
    value: 'k'
  - key: readability-identifier-naming.NamespaceCase
    value: lower_case
  - key: readability-identifier-naming.MacroDefinitionCase
    value: UPPER_CASE

WarningsAsErrors: '*'
HeaderFilterRegex: '.*'
```

### `.pre-commit-config.yaml`

```yaml
repos:
  - repo: https://github.com/pre-commit/mirrors-clang-format
    rev: v18.1.8  # Pin to a specific version
    hooks:
      - id: clang-format
        types_or: [c, c++]
        args: [--style=file]  # Uses .clang-format from project root

  - repo: https://github.com/cpplint/cpplint
    rev: 2.0.0  # Pin to a specific version
    hooks:
      - id: cpplint
        args:
          - --linelength=80
          - --filter=-legal/copyright,-build/c++11
```

### CMake / `compile_commands.json`

- For `clang-tidy` to work correctly, generate `compile_commands.json`:
  ```cmake
  set(CMAKE_EXPORT_COMPILE_COMMANDS ON)
  ```
  Or pass `-DCMAKE_EXPORT_COMPILE_COMMANDS=ON` when invoking CMake. Symlink or copy the generated `compile_commands.json` to the project root.

### Setup Instructions

```bash
# Install tools (Ubuntu/Debian)
sudo apt-get install clang-format clang-tidy

# Install cpplint
pip install cpplint

# Install pre-commit and set up hooks
pip install pre-commit
pre-commit install

# Run clang-format on all source files
find . -regex '.*\.\(cpp\|cc\|cxx\|h\|hpp\)$' -exec clang-format -i {} +

# Run clang-tidy (requires compile_commands.json)
clang-tidy -p build src/*.cpp

# Run cpplint
cpplint --recursive src/
```
