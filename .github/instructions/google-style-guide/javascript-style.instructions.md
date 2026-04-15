---
description: "Use when writing, reviewing, or modifying JavaScript code. Enforces Google JavaScript Style Guide conventions for formatting, naming, modules, JSDoc, language features, and best practices."
applyTo: ["**/*.js", "**/*.mjs", "**/*.cjs"]
---

# Google JavaScript Style Guide

Reference: https://google.github.io/styleguide/jsguide.html

## Formatting

- **Indentation**: 2 spaces. Never tabs.
- **Column limit**: 80 characters. Exceptions: long URLs, import/export statements, shell commands.
- **Semicolons**: Required on every statement. Never rely on ASI.
- **Braces**: Required for all control structures (`if`, `else`, `for`, `do`, `while`), even single-statement bodies. K&R style (opening brace on same line).
- **One statement per line**.
- **Trailing whitespace**: Forbidden.
- **Line-wrapping**: Break at higher syntactic levels. Continuation lines indented +4 spaces minimum.
- **Single quotes** for ordinary string literals. Use template literals for complex concatenation or multi-line strings.

## Naming Conventions

| Type | Convention | Example |
|------|-----------|---------|
| Variables/Functions/Methods | `lowerCamelCase` | `processItem`, `userId` |
| Classes/Interfaces/Typedefs/Enums | `UpperCamelCase` | `EventTarget`, `TemperatureScale` |
| Constants (deeply immutable) | `UPPER_SNAKE_CASE` | `MAX_RETRY_COUNT` |
| Enum values | `UPPER_SNAKE_CASE` | `Status.ACTIVE` |
| File names | lowercase, may use `_` or `-` | `string_utils.js` |
| Template parameters | `ALL_CAPS` | `TYPE`, `KEY` |

- Names must be descriptive. No ambiguous abbreviations.
- One-character names only for short-scoped (≤10 lines) variables, never in public APIs.
- `@private` fields may optionally end with a trailing underscore.

## Modules

- **Use ES modules** (`import`/`export`) for new code. Do not use CommonJS `require()` in new files.
- **Named exports only**. Do not use `default` exports.
- Include `.js` extension in import paths.
- Do not import the same file multiple times.
- Namespace imports (`import * as name`) use `lowerCamelCase` derived from the file name.
- Avoid aliasing named imports unless necessary to resolve collisions.
- Do not create circular dependencies.
- Exported variables must not be mutated outside module initialization.

## Variable Declarations

- **Use `const` by default**. Use `let` when reassignment is needed.
- **Never use `var`**.
- One variable per declaration (`const a = 1;` not `const a = 1, b = 2;`).
- Declare variables close to their first use, not at the top of the function.

## Language Features

- **Template literals** over string concatenation when involving multiple literals or expressions.
- **Arrow functions** preferred for anonymous/nested functions. Use method shorthand in object literals.
- **Destructuring**: Use for arrays and objects where it improves readability.
- **Spread operator**: Prefer `[...arr]` over `Array.prototype.slice.call(arr)`.
- **Trailing commas**: Required in multi-line array literals, object literals, parameter lists, and argument lists.
- **Equality**: Use `===`/`!==`. Use `==` only for null checks (`== null` catches both `null` and `undefined`).
- **Shorthand properties and methods** in object literals.
- Always use `new` with parentheses when invoking constructors (`new Foo()`, not `new Foo`).

## Classes

- Use ES6 `class` syntax. Do not manipulate `prototype` directly.
- Subclass constructors must call `super()` before accessing `this`.
- Define all fields in the constructor.
- Do not use getters/setters unless required by a framework.
- Prefer module-local functions over private static methods.
- Do not create static-only container classes; export functions and constants directly.

## Control Structures

- `for-of` preferred. `for-in` only on dict-style objects with `hasOwnProperty` guard.
- Always throw `Error` or subclasses, never string literals.
- Every `switch` must have a `default` case (last). Comment fall-throughs with `// fall through`.

## Disallowed Features

- `with` keyword.
- `eval()` and `Function(...string)`.
- `var`.
- Non-standard or proposal-stage features.
- `new` on primitive wrappers (`Boolean`, `Number`, `String`, `Symbol`).
- Modifying builtins or their prototypes.
- Line continuations in strings (backslash at end of line).

## JSDoc

- **Required** on all classes, fields, methods, and exported functions.
- Use `/** ... */` for JSDoc. Do not use JSDoc syntax for implementation comments.
- Document `@param`, `@return`, and `@this` types. Omit descriptions only if obvious from signature.
- Method descriptions begin with a third-person verb phrase.
- `@override` methods must still include explicit `@param` and `@return`.
- Use `@fileoverview` for file-level documentation when the file is complex.
- Use `@enum`, `@typedef`, `@const`, `@private`, `@protected`, `@package` as appropriate.
- Tags that require data (`@param`, `@return`, `@implements`, `@template`) get their own line.
- Simple tags (`@private`, `@const`, `@export`, `@final`) may share a line.

## Source File Structure (order)

1. License/copyright header (if present)
2. `@fileoverview` JSDoc (if present)
3. `import` statements
4. The file's implementation

Separate each section with exactly one blank line.

---

## Enforcement

### ESLint (Flat Config)

Create `eslint.config.js` in project root:

```js
import google from 'eslint-config-google';

export default [
  {
    ...google,
    files: ['**/*.js', '**/*.mjs', '**/*.cjs'],
    rules: {
      ...google.rules,
      // Enforce const/let, forbid var
      'no-var': 'error',
      'prefer-const': 'error',
      // Strict equality
      eqeqeq: ['error', 'smart'],
      // Trailing commas in multiline
      'comma-dangle': ['error', 'always-multiline'],
      // Arrow functions for callbacks
      'prefer-arrow-callback': 'error',
      // Template literals
      'prefer-template': 'error',
      // 2-space indent
      indent: ['error', 2, {SwitchCase: 1}],
      // 80-char line limit
      'max-len': ['error', {
        code: 80,
        ignoreUrls: true,
        ignorePattern: '^(import|export)\\s',
      }],
    },
  },
];
```

> **Note**: `eslint-config-google` may require a compatibility wrapper for ESLint 9+ flat config. If it does not export a flat config, use `@eslint/eslintrc`'s `FlatCompat`:
>
> ```js
> import {FlatCompat} from '@eslint/eslintrc';
> const compat = new FlatCompat();
>
> export default [
>   ...compat.extends('google'),
>   {
>     files: ['**/*.js', '**/*.mjs', '**/*.cjs'],
>     rules: {
>       'no-var': 'error',
>       'prefer-const': 'error',
>       eqeqeq: ['error', 'smart'],
>       'comma-dangle': ['error', 'always-multiline'],
>       'prefer-arrow-callback': 'error',
>       'prefer-template': 'error',
>     },
>   },
> ];
> ```

### Prettier Config

Create `.prettierrc` in project root (compatible subset):

```json
{
  "singleQuote": true,
  "trailingComma": "all",
  "tabWidth": 2,
  "printWidth": 80,
  "semi": true,
  "bracketSpacing": false,
  "arrowParens": "always"
}
```

> **Note**: Prettier's `bracketSpacing: false` matches Google style (`{a: 1}` not `{ a: 1 }`). For rules Prettier cannot enforce (naming, JSDoc, `===`), rely on ESLint.

### Pre-commit Hook

Add to `.pre-commit-config.yaml`:

```yaml
repos:
  - repo: https://github.com/pre-commit/mirrors-eslint
    rev: v9.18.0  # Use latest stable version
    hooks:
      - id: eslint
        files: \.(js|mjs|cjs)$
        additional_dependencies:
          - eslint@9
          - eslint-config-google
          - '@eslint/eslintrc'
  - repo: https://github.com/pre-commit/mirrors-prettier
    rev: v4.0.0-alpha.8  # Use latest stable version
    hooks:
      - id: prettier
        files: \.(js|mjs|cjs)$
```

### package.json Scripts

```json
{
  "scripts": {
    "lint": "eslint .",
    "lint:fix": "eslint . --fix",
    "format": "prettier --write '**/*.{js,mjs,cjs}'",
    "format:check": "prettier --check '**/*.{js,mjs,cjs}'"
  }
}
```

### Setup Instructions

```bash
# Install ESLint + Google config
npm install --save-dev eslint eslint-config-google

# Install flat config compatibility layer (if needed for ESLint 9+)
npm install --save-dev @eslint/eslintrc

# Install Prettier
npm install --save-dev prettier

# Install pre-commit hooks (requires pre-commit installed)
pre-commit install
```
