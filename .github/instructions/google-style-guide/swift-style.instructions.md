---
description: "Use when writing, reviewing, or modifying Swift code. Enforces Google Swift Style Guide conventions for formatting, naming, indentation, braces, semicolons, closures, access control, optionals, guard statements, documentation comments, and Swift-specific best practices."
applyTo: "**/*.swift"
---

# Google Swift Style Guide

Reference: https://google.github.io/swift/

## Formatting

- **Indentation**: 2 spaces. Never tabs.
- **Column limit**: 100 characters. Exceptions: long URLs in comments, `import` statements, generated code.
- **No semicolons**. Not to terminate or separate statements.
- **One statement per line**. Single-statement blocks may remain on one line (e.g., `guard ... else { return }`).
- **Braces**: K&R style — no line break before `{`, line break after `{` and before `}`. `} else {` on the same line.
- **No parentheses** around top-level conditions in `if`, `guard`, `while`, `switch`.
- **Horizontal alignment** is forbidden (no aligning colons or equals signs across lines).
- **Trailing commas**: Required in multi-line array/dictionary literals.

## Line-Wrapping

- If the entire declaration fits on one line, keep it on one line.
- Comma-delimited lists are either all horizontal or all vertical (one per line). No mixing.
- Continuation lines in vertical lists are indented +2 from the original line.
- Wrapped function arguments: each on its own line, indented +2. Closing `)` on its own line or on the last argument's line.
- When `{` follows a wrapped declaration, place it on the same line as the last continuation line, unless that line is indented +2, in which case `{` goes on its own line.
- Do NOT align arguments to the opening parenthesis (no zig-zag indentation).

## Whitespace

- Space after control flow keywords (`if`, `guard`, `while`, `switch`, `for`) before `(`.
- Space before and after `{` and `}` when on the same line as code.
- Space around binary/ternary operators (`=`, `->`, `&` in protocol composition).
- No space around `.` (member access) or `..<`/`...` (range operators).
- Space after `,` and `:` (in type annotations, dictionary literals, superclass lists), but not before.
- At least 2 spaces before `//` end-of-line comments, exactly 1 space after `//`.
- Blank line between consecutive type members; optional between single-line stored properties or enum cases.

## Naming Conventions

| Type | Convention | Example |
|------|-----------|---------|
| Types, Protocols, Enums | `UpperCamelCase` | `MovieRatingController`, `Equatable` |
| Functions, Methods, Properties, Variables | `lowerCamelCase` | `makeIterator()`, `backgroundColor` |
| Global/Local Constants | `lowerCamelCase` | `secondsPerMinute` |
| Enum Cases | `lowerCamelCase` | `.ascending`, `.notFound` |
| Type Parameters | Single uppercase or `UpperCamelCase` | `Element`, `Key` |

- **No Hungarian notation** — no `k`, `g`, or type prefixes.
- Use access control (`private`, `fileprivate`, `internal`) instead of naming conventions (e.g., leading `_`) to hide information.
- Static/class properties returning instances of the declaring type are NOT suffixed with the type name (use `UIColor.red`, not `UIColor.redColor`).
- Follow Apple's [API Design Guidelines](https://swift.org/documentation/api-design-guidelines/).

## Imports

- Import **whole modules**, not individual declarations (except to avoid global namespace pollution from C interfaces).
- No line-wrapping on `import` statements.
- Order: (1) non-test module imports sorted lexicographically, (2) individual declaration imports, (3) `@testable` imports. Separate groups with one blank line.

## Properties

- Declare local variables close to first use.
- One variable per `let`/`var` statement (except tuple destructuring).
- Omit `get` block for read-only computed properties — nest body directly.

## Switch Statements

- `case` labels at the same indentation level as the `switch`. Body indented +2.
- Combine cases using ranges or commas instead of `fallthrough`. Never write a `case` whose body is only `fallthrough`.

## Enum Cases

- One `case` per line unless all cases are simple (no associated/raw values), fit on one line, and meaning is obvious.
- When all cases are `indirect`, declare `indirect enum` instead of marking each case.
- No empty parentheses on cases without associated values.

## Trailing Closures

- Use trailing closure syntax when a function has a **single** closure as the **final** argument.
- When no other arguments exist, omit `()` entirely: `[1, 2, 3].map { $0 * $0 }`.
- If a function has **multiple** closure arguments, do NOT use trailing closure syntax; label all closures inside the parentheses.
- Do not overload functions such that two overloads differ only by trailing closure label.

## Programming Practices

- **Prefer `let` over `var`**. Use `var` only when mutation is required.
- **`guard` for early exits**. Use `guard` to handle invalid states at the top of a scope.
- **`for-where` loops**: Replace `for` + `if` with `for item in collection where item.condition`.
- **Use shorthand types**: `[Element]`, `[Key: Value]`, `Wrapped?` instead of `Array<Element>`, `Dictionary<Key, Value>`, `Optional<Wrapped>`.
- **Use Swift native types** over Objective-C bridged types (`String` over `NSString`, `Int` over `NSInteger`).
- **Access levels**: Use the minimum necessary visibility. Omit `internal` (it is the default). Do not put explicit access levels on `extension` declarations; put them on each member.
- **Nesting**: Nest related types (error enums, helper types) inside their parent type. Use caseless `enum` for namespaces.
- **Optional handling**: Use `Optional` for non-error absence; use `Error` types when there are multiple failure modes. Avoid sentinel values (e.g., `-1` for not found).
- **Force unwrapping/casting**: Strongly discouraged. Requires a justifying comment if used. Allowed freely in test code.
- **Implicitly unwrapped optionals**: Avoid except for `@IBOutlet` properties and test fixtures in `setUp()`.
- **Avoid custom operators** unless meaning is well-established in the problem domain and significantly improves readability.
- **Compile without warnings**. Remove all warnings the author can address.
- **Standard arithmetic**: Use trapping operators (`+`, `-`, `*`) by default. Use masking (`&+`, `&-`, `&*`) only for modular arithmetic (crypto, hashing).

## Documentation Comments

- Use `///` (triple-slash). Never `/** ... */`.
- Begin with a single-sentence summary (verb phrase for methods, noun phrase for properties), terminated with a period.
- Use `- Parameter name:` (singular) for single-parameter functions; `- Parameters:` (grouped) for multiple.
- Include `- Returns:` and `- Throws:` tags when applicable, in that order.
- Document every `public` and `open` declaration. Exceptions: trivial enum cases, overrides with no new behavior, test methods.

## Attributes

- Parameterized attributes (`@available(...)`, `@objc(...)`) go on their own line before the declaration.
- Non-parameterized attributes (`@objc`, `@IBOutlet`, `@discardableResult`) may be on the same line if space permits.
- Order attributes lexicographically.

---

## Enforcement

### swift-format (Apple)

Repo: https://github.com/apple/swift-format

#### `.swift-format` configuration

```json
{
  "version": 1,
  "lineLength": 100,
  "indentation": {
    "spaces": 2
  },
  "tabWidth": 2,
  "maximumBlankLines": 1,
  "respectsExistingLineBreaks": true,
  "lineBreakBeforeControlFlowKeywords": false,
  "lineBreakBeforeEachArgument": true,
  "lineBreakBeforeEachGenericRequirement": true,
  "prioritizeKeepingFunctionOutputTogether": false,
  "indentConditionalCompilationBlocks": true,
  "lineBreakAroundMultilineExpressionChainComponents": false,
  "indentSwitchCaseLabels": false,
  "rules": {
    "AllPublicDeclarationsHaveDocumentation": true,
    "AlwaysUseLiteralForEmptyCollectionInit": false,
    "AlwaysUseLowerCamelCase": true,
    "AmbiguousTrailingClosureOverload": true,
    "BeginDocumentationCommentWithOneLineSummary": true,
    "DoNotUseSemicolons": true,
    "DontRepeatTypeInStaticProperties": true,
    "FileScopedDeclarationPrivacy": true,
    "FullyIndirectEnum": true,
    "GroupNumericLiterals": true,
    "IdentifiersMustBeASCII": true,
    "NeverForceUnwrap": true,
    "NeverUseForceTry": true,
    "NeverUseImplicitlyUnwrappedOptionals": true,
    "NoAccessLevelOnExtensionDeclaration": true,
    "NoBlockComments": true,
    "NoCasesWithOnlyFallthrough": true,
    "NoEmptyTrailingClosureParentheses": true,
    "NoLabelsInCasePatterns": true,
    "NoLeadingUnderscores": false,
    "NoParensAroundConditions": true,
    "NoPlaygroundLiterals": true,
    "NoVoidReturnOnFunctionSignature": true,
    "OmitExplicitReturns": false,
    "OneCasePerLine": true,
    "OneVariableDeclarationPerLine": true,
    "OnlyOneTrailingClosureArgument": true,
    "OrderedImports": true,
    "ReplaceForceUnwrap": false,
    "ReturnVoidInsteadOfEmptyTuple": true,
    "UseEarlyExits": true,
    "UseLetInEveryBoundCaseVariable": true,
    "UseShorthandTypeNames": true,
    "UseSingleLinePropertyGetter": true,
    "UseSynthesizedInitializer": true,
    "UseTripleSlashForDocumentationComments": true,
    "UseWhereClausesInForLoops": true,
    "ValidateDocumentationComments": true
  }
}
```

### SwiftLint

Repo: https://github.com/realm/SwiftLint

#### `.swiftlint.yml` configuration

```yaml
# Google Swift Style Guide — SwiftLint config

opt_in_rules:
  - closure_body_length
  - closure_end_indentation
  - closure_spacing
  - collection_alignment
  - comma_inheritance
  - contains_over_filter_count
  - contains_over_filter_is_empty
  - contains_over_first_not_nil
  - contains_over_range_nil_comparison
  - convenience_type
  - discouraged_optional_boolean
  - empty_collection_literal
  - empty_count
  - empty_string
  - enum_case_associated_values_count
  - explicit_init
  - fallthrough
  - fatal_error_message
  - file_name_no_space
  - first_where
  - flatmap_over_map_reduce
  - force_unwrapping
  - implicit_return
  - implicitly_unwrapped_optional
  - joined_default_parameter
  - last_where
  - legacy_multiple
  - literal_expression_end_indentation
  - lower_acl_than_parent
  - modifier_order
  - multiline_arguments
  - multiline_function_chains
  - multiline_parameters
  - no_extension_access_modifier
  - operator_usage_whitespace
  - overridden_super_call
  - pattern_matching_keywords
  - prefer_self_in_static_references
  - prefer_self_type_over_type_of_self
  - private_over_fileprivate
  - redundant_nil_coalescing
  - redundant_type_annotation
  - sorted_imports
  - toggle_bool
  - trailing_closure
  - unavailable_function
  - unneeded_parentheses_in_closure_argument
  - vertical_parameter_alignment_on_call
  - yoda_condition

disabled_rules:
  - todo
  - trailing_whitespace

line_length:
  warning: 100
  error: 120
  ignores_urls: true
  ignores_comments: false
  ignores_function_declarations: false

type_body_length:
  warning: 250
  error: 350

file_length:
  warning: 500
  error: 1000

function_body_length:
  warning: 50
  error: 80

function_parameter_count:
  warning: 5
  error: 8

identifier_name:
  min_length:
    warning: 2
    error: 1
  max_length:
    warning: 50
    error: 60
  allowed_symbols: ["_"]
  validates_start_with_lowercase: error

type_name:
  min_length:
    warning: 3
    error: 1
  max_length:
    warning: 50
    error: 60

indentation: 2

trailing_comma:
  mandatory_comma: true

vertical_whitespace:
  max_empty_lines: 1

nesting:
  type_level:
    warning: 2
  function_level:
    warning: 3

reporter: "xcode"
```

### Pre-commit hooks

#### `.pre-commit-config.yaml` snippet

```yaml
repos:
  - repo: https://github.com/realm/SwiftLint
    rev: 0.57.0  # pin to latest stable
    hooks:
      - id: swiftlint
        args: ["--strict"]

  - repo: local
    hooks:
      - id: swift-format-lint
        name: swift-format lint
        entry: swift-format lint --strict --recursive
        language: system
        types: [swift]
      - id: swift-format
        name: swift-format format
        entry: swift-format format --in-place --recursive
        language: system
        types: [swift]
```

### Setup Instructions

#### macOS (Homebrew)

```bash
# Install swift-format (Apple)
brew install swift-format

# Install SwiftLint
brew install swiftlint

# Install pre-commit
brew install pre-commit
pre-commit install
```

#### Swift Package Manager

Add swift-format as a dependency in `Package.swift`:

```swift
dependencies: [
  .package(url: "https://github.com/apple/swift-format.git", from: "510.1.0"),
]
```

Add SwiftLint as a build tool plugin:

```swift
dependencies: [
  .package(url: "https://github.com/realm/SwiftLint.git", from: "0.57.0"),
],
targets: [
  .target(
    name: "MyTarget",
    plugins: [.plugin(name: "SwiftLintBuildToolPlugin", package: "SwiftLint")]
  ),
]
```

#### Run manually

```bash
# Format all Swift files in place
swift-format format --in-place --recursive .

# Lint without modifying
swift-format lint --strict --recursive .

# SwiftLint
swiftlint lint --strict
swiftlint lint --fix
```
