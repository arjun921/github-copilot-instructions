---
description: "Use when writing, reviewing, or modifying C# code. Enforces Google C# Style Guide conventions for formatting, naming, whitespace, indentation, braces, var usage, LINQ, expression bodies, properties, and language features."
applyTo: "**/*.cs"
---

# Google C# Style Guide

Reference: https://google.github.io/styleguide/csharp-style.html

## Formatting

- **Indentation**: 2 spaces. Never tabs.
- **Line length**: 100 characters max.
- **One statement per line**, one assignment per statement.
- **No line break before opening brace** (K&R / Java style, NOT Allman).
- **No line break between closing brace and `else`**.
- **Braces always used**, even when optional (single-line `if`, `for`, etc.).
- **Space after keywords** (`if`, `for`, `while`, etc.) and after commas.
- **No space** after `(` or before `)`.
- **No space** between a unary operator and its operand. One space around all other operators.
- **Continuation lines**: indented 4 spaces. Brace-delimited blocks (lambdas, object initializers) do not count as continuations.
- **Empty blocks** may be concise: `void DoNothing() {}`.

## Naming Conventions

| Type | Convention |
|------|-----------|
| Classes, Methods, Enums, Public Fields, Public Properties, Namespaces | `PascalCase` |
| Local variables, Parameters | `camelCase` |
| Private/Protected/Internal fields and properties | `_camelCase` |
| Interfaces | `IPascalCase` (prefix with `I`) |
| Constants (`const`, `static readonly`) | `PascalCase` (naming unaffected by modifiers) |
| Filenames, Directory names | `PascalCase` (e.g., `MyClass.cs`) |

- Treat acronyms as whole words: `MyRpc`, not `MyRPC`.
- One core class per file where possible; filename matches the main class name.

## Organization

- **Modifier order**: `public protected internal private new abstract virtual override sealed static readonly extern unsafe volatile async`.
- **`using` declarations** go at the top, outside namespaces. `System` imports first, then alphabetical.
- **Class member ordering** (each group ordered by accessibility: public → internal → protected internal → protected → private):
  1. Nested classes, enums, delegates, events
  2. Static, const, and readonly fields
  3. Fields and properties
  4. Constructors and finalizers
  5. Methods
- Group interface implementations together where possible.

## The `var` Keyword

- Use `var` when the type is obvious from the right-hand side:
  ```csharp
  var apple = new Apple();
  var request = Factory.Create<HttpRequest>();
  ```
- **Do not** use `var` with basic types, compiler-resolved numerics, or when the type is unclear:
  ```csharp
  // Bad
  var success = true;
  var number = 12 * ReturnsFloat();
  var listOfItems = GetList();
  ```

## Expression Bodies and Properties

- Use expression body (`=>`) for single-line **read-only properties**:
  ```csharp
  int SomeProperty => _someProperty;
  ```
- Use `{ get; set; }` syntax for everything else.
- Do not use expression body syntax on method definitions (prefer block bodies).

## Language Features

- **Prefer `nameof()`** over string literals for member names.
- **Prefer string interpolation** (`$"Hello {name}"`) over concatenation for readability. Use `StringBuilder` when performance matters.
- **Use field initializers**: `public int Foo = 0;` is encouraged.
- **Prefer named constants** over magic numbers. Use `const` where possible, `readonly` otherwise.
- **Use `out` for outputs** (not also inputs); place `out` parameters last.
- **Avoid `ref`** except when mutating an input is truly necessary.
- **Attributes** on their own line above the member, one per line.
- **LINQ**: Prefer member extension syntax (`myList.Where(x)`) over query syntax. Avoid `Container.ForEach(...)` for multi-statement bodies.
- **Prefer `List<>`** over arrays for public APIs unless size is fixed and known at construction.
- **Prefer named class** over `Tuple<>` for return types.
- **Lambdas**: If non-trivial (more than a couple of statements), extract to a named method.
- **Call delegates** with `?.Invoke()`: `SomeDelegate?.Invoke()`.
- **Use `IReadOnlyCollection` / `IReadOnlyList`** for immutable input parameters.
- **Object initializer syntax** is fine for POD types; avoid for types with constructors. Indent one block level.

## Structs vs Classes

- Almost always use a class.
- Consider struct only when the type is small, short-lived, or commonly embedded in other objects (e.g., `Vector3`, `Quaternion`).

## Namespace Naming

- Namespaces should be no more than 2 levels deep.
- Don't force file/folder layout to match namespaces.
- New top-level namespace names must be globally unique and recognizable.

## Argument Clarity

- Replace `bool` arguments with `enum` arguments for self-describing call sites.
- Use named arguments for ambiguous literals.
- Consider an options class/struct for functions with many configuration parameters.

---

## Enforcement

### EditorConfig (`.editorconfig`)

```ini
# Google C# Style Guide
root = true

[*.cs]
indent_style = space
indent_size = 2
tab_width = 2
end_of_line = lf
charset = utf-8
trim_trailing_whitespace = true
insert_final_newline = true
max_line_length = 100

# Brace placement — K&R / Java style (same line)
csharp_new_line_before_open_brace = none
csharp_new_line_before_else = false
csharp_new_line_before_catch = false
csharp_new_line_before_finally = false
csharp_new_line_before_members_in_object_initializers = true
csharp_new_line_before_members_in_anonymous_types = true
csharp_new_line_between_query_expression_clauses = true

# Indentation
csharp_indent_case_contents = true
csharp_indent_switch_labels = true
csharp_indent_block_contents = true
csharp_indent_braces = false

# Spacing
csharp_space_after_cast = false
csharp_space_after_keywords_in_control_flow_statements = true
csharp_space_between_method_declaration_parameter_list_parentheses = false
csharp_space_between_method_call_parameter_list_parentheses = false
csharp_space_before_colon_in_inheritance_clause = true
csharp_space_after_colon_in_inheritance_clause = true
csharp_space_around_binary_operators = before_and_after

# Wrapping
csharp_preserve_single_line_blocks = true
csharp_preserve_single_line_statements = false

# var preferences
csharp_style_var_when_type_is_apparent = true:suggestion
csharp_style_var_for_built_in_types = false:suggestion
csharp_style_var_elsewhere = false:suggestion

# Expression-bodied members
csharp_style_expression_bodied_properties = when_on_single_line:suggestion
csharp_style_expression_bodied_methods = false:none
csharp_style_expression_bodied_constructors = false:none
csharp_style_expression_bodied_accessors = when_on_single_line:suggestion
csharp_style_expression_bodied_lambdas = true:suggestion

# Code style
csharp_prefer_braces = true:warning
csharp_style_prefer_switch_expression = true:suggestion
csharp_prefer_simple_using_statement = true:suggestion
csharp_style_namespace_declarations = file_scoped:suggestion
csharp_style_prefer_utf8_string_literals = true:suggestion

# using directives
dotnet_sort_system_directives_first = true
dotnet_separate_import_directive_groups = false

# Naming rules
dotnet_naming_rule.public_members_pascal.severity = warning
dotnet_naming_rule.public_members_pascal.symbols = public_symbols
dotnet_naming_rule.public_members_pascal.style = pascal_style

dotnet_naming_symbols.public_symbols.applicable_kinds = class, struct, interface, enum, property, method, field, event, delegate, namespace
dotnet_naming_symbols.public_symbols.applicable_accessibilities = public, internal

dotnet_naming_style.pascal_style.capitalization = pascal_case

dotnet_naming_rule.private_fields_underscore_camel.severity = warning
dotnet_naming_rule.private_fields_underscore_camel.symbols = private_fields
dotnet_naming_rule.private_fields_underscore_camel.style = underscore_camel_style

dotnet_naming_symbols.private_fields.applicable_kinds = field
dotnet_naming_symbols.private_fields.applicable_accessibilities = private, protected, internal, protected_internal

dotnet_naming_style.underscore_camel_style.capitalization = camel_case
dotnet_naming_style.underscore_camel_style.required_prefix = _

dotnet_naming_rule.local_vars_camel.severity = warning
dotnet_naming_rule.local_vars_camel.symbols = local_symbols
dotnet_naming_rule.local_vars_camel.style = camel_style

dotnet_naming_symbols.local_symbols.applicable_kinds = parameter, local
dotnet_naming_symbols.local_symbols.applicable_accessibilities = *

dotnet_naming_style.camel_style.capitalization = camel_case

dotnet_naming_rule.interfaces_i_prefix.severity = warning
dotnet_naming_rule.interfaces_i_prefix.symbols = interface_symbols
dotnet_naming_rule.interfaces_i_prefix.style = i_prefix_style

dotnet_naming_symbols.interface_symbols.applicable_kinds = interface
dotnet_naming_symbols.interface_symbols.applicable_accessibilities = *

dotnet_naming_style.i_prefix_style.capitalization = pascal_case
dotnet_naming_style.i_prefix_style.required_prefix = I
```

### Roslyn Analyzers — `Directory.Build.props`

```xml
<Project>
  <PropertyGroup>
    <AnalysisLevel>latest-recommended</AnalysisLevel>
    <EnforceCodeStyleInBuild>true</EnforceCodeStyleInBuild>
    <EnableNETAnalyzers>true</EnableNETAnalyzers>
    <TreatWarningsAsErrors>false</TreatWarningsAsErrors>
  </PropertyGroup>

  <ItemGroup>
    <!-- StyleCop Analyzers for naming, ordering, and documentation rules -->
    <PackageReference Include="StyleCop.Analyzers" Version="1.2.0-beta.*">
      <PrivateAssets>all</PrivateAssets>
      <IncludeAssets>runtime; build; native; contentfiles; analyzers</IncludeAssets>
    </PackageReference>
  </ItemGroup>
</Project>
```

### StyleCop Settings — `.globalconfig`

```ini
is_global = true

# SA1101: Prefix local calls with this — Google style does not require this
dotnet_diagnostic.SA1101.severity = none

# SA1200: Using directives should be placed correctly (outside namespace per Google)
dotnet_diagnostic.SA1200.severity = warning

# SA1309: Field names should not begin with underscore — DISABLE (Google uses _camelCase)
dotnet_diagnostic.SA1309.severity = none

# SX1309: Field names should begin with underscore — ENABLE (matches Google _camelCase)
dotnet_diagnostic.SX1309.severity = warning

# SA1413: Use trailing comma in multi-line initializers
dotnet_diagnostic.SA1413.severity = suggestion

# SA1028: Code should not contain trailing whitespace
dotnet_diagnostic.SA1028.severity = warning

# SA1502: Element should not be on a single line — allow empty blocks
dotnet_diagnostic.SA1502.severity = none

# SA1513: Closing brace should be followed by blank line
dotnet_diagnostic.SA1513.severity = suggestion

# SA1516: Elements should be separated by blank line
dotnet_diagnostic.SA1516.severity = suggestion

# IDE0011: Add braces
dotnet_diagnostic.IDE0011.severity = warning

# IDE0090: Use 'new(...)' (target-typed new)
dotnet_diagnostic.IDE0090.severity = suggestion

# CA1062: Validate arguments of public methods
dotnet_diagnostic.CA1062.severity = suggestion

# CA1707: Identifiers should not contain underscores (conflicts with _camelCase fields)
dotnet_diagnostic.CA1707.severity = none
```

### CSharpier Configuration (`.csharpierrc.yaml`)

```yaml
printWidth: 100
useTabs: false
tabWidth: 2
endOfLine: lf
```

> **Note**: CSharpier enforces Allman-style braces by default and does not support K&R.
> For strict Google style brace placement, rely on `.editorconfig` + `dotnet format`
> rather than CSharpier alone.

### Pre-commit Configuration (`.pre-commit-config.yaml`)

```yaml
repos:
  - repo: https://github.com/dotnet/format
    rev: v9.0.0  # pin to your .NET SDK major version
    hooks:
      - id: dotnet-format
        name: dotnet-format
        entry: dotnet format --verbosity normal --no-restore
        language: system
        types: [c#]
        pass_filenames: false

  - repo: local
    hooks:
      - id: dotnet-build
        name: dotnet build
        entry: dotnet build --no-restore --warnaserror
        language: system
        types: [c#]
        pass_filenames: false

  - repo: https://github.com/pre-commit/pre-commit-hooks
    rev: v5.0.0
    hooks:
      - id: trailing-whitespace
      - id: end-of-file-fixer
      - id: check-yaml
      - id: check-added-large-files
```

### Setup Instructions

```bash
# Install StyleCop analyzers (if not in Directory.Build.props)
dotnet add package StyleCop.Analyzers --version 1.2.0-beta.556

# Install CSharpier (optional formatter)
dotnet tool install -g csharpier

# Install pre-commit and hooks
pip install pre-commit
pre-commit install

# Run dotnet format manually
dotnet format              # apply .editorconfig + analyzer fixes
dotnet format --verify-no-changes  # CI check (fails if changes needed)

# Run CSharpier manually
dotnet csharpier .         # format all files
dotnet csharpier --check . # CI check

# Build with analyzer warnings
dotnet build --warnaserror
```
