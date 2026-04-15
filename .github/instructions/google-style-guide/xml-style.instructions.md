---
description: "Use when writing, reviewing, or modifying XML document formats. Enforces Google XML Document Format Style Guide conventions for element design, attribute usage, naming, formatting, and schema design."
applyTo: "**/*.xml"
---

# Google XML Document Format Style Guide

Reference: https://google.github.io/styleguide/xmlstyle.html

## Elements vs Attributes

- Data that could contain substructure, spans multiple lines, is very large, or might appear more than once MUST go in elements.
- Use elements to represent independent objects and parent/child relationships.
- Use elements when data incorporates strict typing or relationship rules.
- If order matters between two pieces of data, use elements (attributes are inherently unordered).
- If data is in a natural language, use an element so `xml:lang` can be applied.
- Metadata, identifiers, IDs, code enumerations, and controlled vocabulary values SHOULD go in attributes.
- Hypertext references go in `href` attributes by convention.
- If data is applicable to an element and descendants (unless overridden), use an attribute (e.g., `xml:lang`, `xml:space`, `xml:base`).
- Mixed content (elements interleaved with text) MUST NOT be used.
- Wrapper elements that merely wrap repeating child elements SHOULD NOT be used.

## Naming

- All element, attribute, and enumerated value names MUST use `lowerCamelCase`.
- Names MUST contain only ASCII letters and digits.
- Names SHOULD NOT exceed 25 characters; devise concise, informative names.
- Published standard abbreviations MAY be used if well-known; ad hoc abbreviations MUST NOT be used.
- Acronyms MUST be treated as words for camel-casing: `informationUri`, not `informationURI`.
- When extending an existing schema, follow the implicit style of that schema for consistency.

## Formatting

- Character encoding MUST be UTF-8. Exceptions require extremely compelling circumstances.
- Pretty-print using 2-space indentation for child elements.
- Elements containing character content SHOULD NOT be wrapped.
- Long start-tags MAY be broken using newlines after any attribute value except the last.
- Use one space before each attribute in a start-tag; redundant whitespace SHOULD NOT be used.
- Attribute values MAY use either quotation marks or apostrophes; specifications MUST NOT require one form over the other.

## Namespaces

- Element names MUST be in a namespace (except when extending pre-existing formats without namespaces).
- A default namespace SHOULD be used for readability.
- Attribute names SHOULD NOT be in a namespace unless drawn from or meant for foreign document types.
- Namespace names SHOULD be HTTP URIs of the form `https://example.com/whatever/year`.
- Namespaces MUST NOT be changed unless element/attribute semantics change in drastically incompatible ways.
- Namespace prefixes SHOULD be short, contain only lower-case ASCII letters, and MUST NOT be single-letter.
- Namespaces SHOULD be declared in the root element; prefix mappings SHOULD remain constant throughout the document.
- Use well-known prefixes for standard namespaces: `html:`, `dc:`, `xs:`, etc.

## Schema Design

- Document formats SHOULD be expressed using a schema language, preferably RELAX NG compact syntax.
- Schemas SHOULD use "Salami Slice" style (one rule per element); "Russian Doll" style MAY be used for short, simple schemas.
- Regular expressions SHOULD be provided to validate complex values.
- Prefer elements over attributes for extensibility; limit elements to no more than 10 attributes.
- Design for forward compatibility: use elements when substructure may be needed later.
- DTDs and/or W3C XML Schemas MAY be provided for compatibility with existing tools.

## Values

- Numeric values SHOULD be 32-bit signed integers (`xsd:int`), 64-bit signed integers (`xsd:long`), or 64-bit IEEE doubles (`xsd:double`), all in base 10.
- Boolean values SHOULD NOT be used; prefer enumerations. If booleans must be used, express as `true`/`false` (not `1`/`0`).
- Dates SHOULD use RFC 3339 format (subset of ISO 8601 / `xsd:dateTime`). UTC times are preferred.
- Embedded syntax in character content and attribute values SHOULD NOT be used (exceptions: dates, URIs, XPath expressions).
- Document formats SHOULD give rules for whitespace stripping.

## Key-Value Pairs

- Simple key-value pairs SHOULD use an empty element (name = key) with a `value` attribute.
- Elements with a `value` attribute MAY also have a `unit` attribute; use the SI system for physical measurements.
- For large or unbounded key sets, use a generic element with `key`, `value`, and optional `unit` and `scheme` attributes.

## Comments

- Use `<!-- -->` for comments, with whitespace following `<!--` and preceding `-->`.
- Comments MUST NOT carry real data (parsers often discard them).
- Comments MAY contain TODOs in hand-written XML.
- Comments SHOULD NOT appear in publicly transmitted documents.
- Comments SHOULD appear only in the document prolog or in elements containing child elements, not in elements with character content.

## Empty Elements

- Empty elements MAY be expressed as self-closing tags (`<element/>`) or start-tag immediately followed by end-tag (`<element></element>`).
- No distinction should be made between these two forms by any application.

## CDATA

- CDATA sections MAY be used; they are equivalent to using `&amp;` and `&lt;`.
- Specifications MUST NOT require or forbid CDATA sections.
- Entity references other than `&amp;`, `&lt;`, `&gt;`, `&quot;`, and `&apos;` MUST NOT be used.
- Character references MAY be used, but actual characters are preferred when encoding is UTF-8.

## Binary Data

- Binary data MUST NOT be included directly in XML; it MUST be Base64-encoded.
- Line breaks required by Base64 MAY be omitted.
- An `xsi:type="xs:base64Binary"` attribute MAY be attached to signal Base64 encoding.

## Processing Instructions

- New processing instructions MUST NOT be created (except for purely local processing conventions) and SHOULD be avoided altogether.
- Existing standardized processing instructions MAY be used.

## Enforcement

### xmllint

```bash
# Validate XML against schema
xmllint --schema schema.xsd file.xml --noout

# Format / pretty-print XML
xmllint --format file.xml > formatted.xml

# Check well-formedness
xmllint --noout file.xml
```

### Prettier Configuration (for XML via plugin)

```json
{
  "plugins": ["@prettier/plugin-xml"],
  "xmlWhitespaceSensitivity": "ignore",
  "xmlSelfClosingSpace": true,
  "tabWidth": 2
}
```

### Pre-commit Configuration (`.pre-commit-config.yaml`)

```yaml
repos:
  - repo: https://github.com/pre-commit/pre-commit-hooks
    rev: v5.0.0
    hooks:
      - id: check-xml
      - id: trailing-whitespace
      - id: end-of-file-fixer

  - repo: local
    hooks:
      - id: xmllint-format
        name: xmllint format check
        entry: bash -c 'for f in "$@"; do xmllint --noout "$f"; done'
        language: system
        types: [xml]
```

### Setup Instructions

```bash
# xmllint is part of libxml2 (usually pre-installed on Linux/macOS)
# Install if needed:
# Ubuntu/Debian: sudo apt-get install libxml2-utils
# macOS: brew install libxml2

# Validate XML
xmllint --noout file.xml

# Pretty-print XML
xmllint --format file.xml

# Optional: Prettier with XML plugin
npm install --save-dev prettier @prettier/plugin-xml
npx prettier --write "**/*.xml"
```
