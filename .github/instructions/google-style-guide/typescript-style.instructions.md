---
description: "Use when writing, reviewing, or modifying TypeScript or TSX code. Enforces Google TypeScript Style Guide conventions for formatting, naming, types, modules, imports, exports, classes, functions, interfaces, enums, and TypeScript-specific practices."
applyTo:
  - "**/*.ts"
  - "**/*.tsx"
---

# Google TypeScript Style Guide

Reference: https://google.github.io/styleguide/tsguide.html

## Formatting

- **Indentation**: 2 spaces. Never tabs.
- **Line length**: 80 characters max.
- **Semicolons**: Always use explicit semicolons. Do not rely on ASI.
- **Strings**: Use single quotes (`'`) for ordinary strings. Use template literals (`` ` ``) for interpolation or multi-line.
- **Trailing commas**: Use in multi-line arrays, objects, parameters, and imports.
- **Braces**: Always use braces for control flow (`if`, `for`, `while`, etc.) even for single statements.
- **Blank lines**: Separate class methods with a single blank line. Separate constructor from surrounding code.
- **Multi-line comments**: Use multiple `//` single-line comments, not `/* */` blocks.
- **Arrow functions**: Parentheses around single parameter recommended. No space after `...` in rest/spread.
- **Generators**: Attach `*` to `function` and `yield` keywords: `function* foo()`, `yield* iter`.

## Naming Conventions

| Type | Convention |
|------|-----------|
| Variables / Parameters / Functions / Methods / Properties | `lowerCamelCase` |
| Classes / Interfaces / Types / Enums / Decorators / Type Parameters / TSX Components | `UpperCamelCase` |
| Global constants / Enum values / `static readonly` | `CONSTANT_CASE` |
| Module namespace imports | `lowerCamelCase` |

- Treat acronyms as whole words: `loadHttpUrl`, not `loadHTTPURL`.
- **No Hungarian notation**, no trailing/leading underscores, no `I` prefix on interfaces.
- Names must be descriptive. No single-letter names except for ≤10-line scopes.
- Do not decorate names with type information (the type system expresses it).

## Imports and Modules

- **Use ES6 modules** (`import`/`export`). No `namespace`, no `require()`, no `/// <reference>` triple-slash directives.
- **Named exports only**. No default exports — they lack canonical names and hurt refactoring.
- Use `import type {...}` when the import is only used as a type. Use `export type` for type-only re-exports.
- Prefer **relative imports** (`./foo`, `../foo`) within the same project.
- Prefer **named imports** for frequently used symbols; namespace imports (`import * as`) for large APIs.
- Minimize the exported API surface. Only export symbols used outside the module.
- **No `export let`** (mutable exports). Use getter functions if mutation is needed.
- Do not create container classes with static members for namespacing — export constants and functions directly.

## Type System

- **Prefer `interface` over `type` alias** for object shapes. Use `type` for unions, tuples, and mapped types.
- **Avoid `any`**. Use `unknown` if the type is truly unknown, then narrow with type guards. If `any` is necessary, add a comment explaining why.
- **Do not use `{}` type**. Prefer `unknown`, `Record<string, T>`, or `object`.
- **Never use wrapper types** (`String`, `Boolean`, `Number`, `Object`). Use lowercase primitives.
- **Use `readonly`** for properties never reassigned after construction.
- **Use `as` syntax** for type assertions, never angle-bracket `<Foo>x` syntax.
- **Avoid non-null assertions (`!`)** except in tests with a comment. Prefer runtime checks.
- **Do not use `@ts-ignore`**. Avoid `@ts-expect-error` outside unit tests.
- Use `const` by default, `let` when reassignment is needed. Never use `var`.
- Prefer `T[]` for simple array types; `Array<T>` for complex element types (unions, objects).
- Prefer `?` optional fields/params over `| undefined`.
- Do not include `| null` or `| undefined` in type aliases.
- Use structural typing. Annotate object literals with the target type at declaration.
- Use mapped/conditional types sparingly. Prefer explicit interfaces when possible.
- Leave out type annotations for trivially inferred types (`string`, `number`, `boolean`, `RegExp`, `new` expressions).

## Enums

- **Avoid enums** where possible. Prefer union types or `as const` objects for better tree-shaking and type safety.
- If using enums, use plain `enum` — never `const enum`.
- Do not implicitly coerce enum values to booleans; compare explicitly.

## Functions

- **Explicit return types on exported functions** for documentation and earlier error detection.
- Prefer **function declarations** (`function foo()`) over arrow function expressions for named functions.
- Use **arrow functions** for callbacks and inline functions. Do not use `function` expressions.
- Do not use concise arrow body if the return value is unused (e.g., `promise.then(v => { console.log(v); })`).
- Prefer passing **arrow functions as callbacks** instead of named function references to avoid argument mismatch.
- Use **rest parameters** (`...args`) instead of `arguments`.
- Use **parameter properties** in constructors (`constructor(private readonly foo: Foo) {}`).
- Keep default parameter initializers simple with no side effects.
- No blank lines at start/end of function bodies.

## Classes

- **Visibility**: Limit to minimum. Never use `public` modifier explicitly (it's the default) unless for non-readonly constructor parameter properties.
- Use TypeScript `private`/`protected`, not `#private` fields.
- Use `readonly` on properties not reassigned outside the constructor.
- Initialize fields at declaration when possible.
- Getters must be pure functions (no side effects, no state mutation).
- Do not manipulate `prototype`s directly.
- Do not use `this` in static methods.

## Control Structures

- Always use `===` and `!==`. Never `==`/`!=` (exception: `== null` to check for `null | undefined`).
- `switch` must have a `default` case (last). No fall-through in non-empty cases.
- Iterate arrays with `for...of`, not `for...in`. Use `Object.keys()`/`Object.entries()` for objects.
- Only throw `Error` objects (or subclasses). Never throw strings or plain objects.
- Instantiate errors with `new Error(...)`.
- Keep try blocks focused on the throwable code.

## Comments and Documentation

- Use `/** JSDoc */` for public API documentation. Use `// line comments` for implementation notes.
- Document all top-level exports. Omit JSDoc type annotations (TypeScript types are sufficient).
- Do not use `@implements`, `@enum`, `@private`, `@override` in JSDoc — use the TypeScript keywords.
- Place JSDoc **before** decorators.
- Use `/* paramName= */` comments for ambiguous arguments at call sites.

## Disallowed Features

- `eval()`, `Function(...string)` constructor
- `with` statement
- `debugger` in production code
- Modifying builtin prototypes
- `new String()`, `new Boolean()`, `new Number()` wrapper constructors
- `var` declarations
- Relying on Automatic Semicolon Insertion (ASI)

---

## Enforcement

### ESLint (Flat Config — `eslint.config.ts`)

```ts
// eslint.config.ts
import eslint from '@eslint/js';
import tseslint from 'typescript-eslint';
import stylistic from '@stylistic/eslint-plugin';

export default tseslint.config(
  eslint.configs.recommended,
  ...tseslint.configs.strictTypeChecked,
  ...tseslint.configs.stylisticTypeChecked,
  {
    plugins: {
      '@stylistic': stylistic,
    },
    languageOptions: {
      parserOptions: {
        projectService: true,
        tsconfigRootDir: import.meta.dirname,
      },
    },
    rules: {
      // --- Formatting (via @stylistic) ---
      '@stylistic/indent': ['error', 2],
      '@stylistic/max-len': ['error', { code: 80, ignoreUrls: true, ignoreStrings: true }],
      '@stylistic/semi': ['error', 'always'],
      '@stylistic/quotes': ['error', 'single', { avoidEscape: true, allowTemplateLiterals: true }],
      '@stylistic/comma-dangle': ['error', 'always-multiline'],
      '@stylistic/brace-style': ['error', '1tbs'],
      '@stylistic/arrow-parens': ['error', 'always'],

      // --- TypeScript rules ---
      '@typescript-eslint/no-explicit-any': 'error',
      '@typescript-eslint/no-non-null-assertion': 'error',
      '@typescript-eslint/explicit-function-return-type': ['error', {
        allowExpressions: true,
        allowTypedFunctionExpressions: true,
      }],
      '@typescript-eslint/consistent-type-imports': ['error', { prefer: 'type-imports' }],
      '@typescript-eslint/consistent-type-exports': ['error', { fixMixedExportsWithInlineTypeSpecifier: true }],
      '@typescript-eslint/no-import-type-side-effects': 'error',
      '@typescript-eslint/prefer-readonly': 'error',
      '@typescript-eslint/no-unnecessary-condition': 'error',
      '@typescript-eslint/strict-boolean-expressions': 'error',
      '@typescript-eslint/switch-exhaustiveness-check': 'error',
      '@typescript-eslint/no-unsafe-assignment': 'error',
      '@typescript-eslint/no-unsafe-call': 'error',
      '@typescript-eslint/no-unsafe-member-access': 'error',
      '@typescript-eslint/no-unsafe-return': 'error',
      '@typescript-eslint/prefer-nullish-coalescing': 'error',
      '@typescript-eslint/consistent-type-definitions': ['error', 'interface'],

      // --- Module / export rules ---
      'no-restricted-syntax': ['error', {
        selector: 'ExportDefaultDeclaration',
        message: 'Prefer named exports. Default exports are not allowed.',
      }],

      // --- General best practices ---
      'no-var': 'error',
      'prefer-const': 'error',
      'eqeqeq': ['error', 'always', { null: 'ignore' }],
      'curly': ['error', 'all'],
      'no-eval': 'error',
      'no-implied-eval': 'error',
      'no-debugger': 'error',
      'no-with': 'error',
    },
  },
);
```

### TypeScript Compiler — `tsconfig.json`

```jsonc
{
  "compilerOptions": {
    "target": "ES2022",
    "module": "Node16",
    "moduleResolution": "Node16",

    // Strict type-checking
    "strict": true,
    "noUncheckedIndexedAccess": true,
    "noFallthroughCasesInSwitch": true,
    "noImplicitOverride": true,
    "noImplicitReturns": true,
    "noPropertyAccessFromIndexSignature": true,
    "exactOptionalPropertyTypes": true,
    "forceConsistentCasingInFileNames": true,
    "isolatedModules": true,
    "verbatimModuleSyntax": true,

    // Output
    "declaration": true,
    "declarationMap": true,
    "sourceMap": true,
    "esModuleInterop": true,
    "skipLibCheck": true
  }
}
```

### Prettier — `.prettierrc`

```json
{
  "semi": true,
  "singleQuote": true,
  "trailingComma": "all",
  "tabWidth": 2,
  "printWidth": 80,
  "bracketSpacing": false,
  "arrowParens": "always",
  "endOfLine": "lf"
}
```

### Pre-commit — `.pre-commit-config.yaml`

```yaml
repos:
  - repo: local
    hooks:
      - id: eslint
        name: ESLint
        entry: npx eslint --fix
        language: system
        types_or: [ts, tsx]
        pass_filenames: true

      - id: prettier
        name: Prettier
        entry: npx prettier --write
        language: system
        types_or: [ts, tsx, json, yaml, markdown]
        pass_filenames: true

      - id: tsc
        name: TypeScript type-check
        entry: npx tsc --noEmit
        language: system
        types_or: [ts, tsx]
        pass_filenames: false
```

### `package.json` Scripts

```jsonc
{
  "scripts": {
    "lint": "eslint . --ext .ts,.tsx",
    "lint:fix": "eslint . --ext .ts,.tsx --fix",
    "format": "prettier --write '**/*.{ts,tsx,json,yaml,md}'",
    "format:check": "prettier --check '**/*.{ts,tsx,json,yaml,md}'",
    "typecheck": "tsc --noEmit",
    "check": "npm run typecheck && npm run lint && npm run format:check"
  }
}
```

### Setup Instructions

```bash
# Install all tooling dependencies
npm install -D \
  typescript \
  eslint \
  @eslint/js \
  typescript-eslint \
  @stylistic/eslint-plugin \
  prettier \
  pre-commit

# Initialize pre-commit hooks
pre-commit install

# Verify setup
npm run check
```
