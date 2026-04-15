---
description: "Use when writing, reviewing, or modifying HTML or CSS code. Enforces Google HTML/CSS Style Guide conventions for formatting, naming, structure, selectors, properties, and best practices."
applyTo:
  - "**/*.html"
  - "**/*.css"
  - "**/*.htm"
---

# Google HTML/CSS Style Guide

Reference: https://google.github.io/styleguide/htmlcssguide.html

## General Formatting

- **Indentation**: Use 2 spaces. Never use tabs or mix tabs and spaces.
- **Capitalization**: Use only lowercase for HTML element names, attributes, attribute values (unless `text/CDATA`), CSS selectors, properties, and property values (except strings).
- **Encoding**: Use UTF-8 (no BOM). Specify via `<meta charset="utf-8">` in HTML. Do not specify encoding for CSS (UTF-8 is assumed).
- **Trailing whitespace**: Remove all trailing white spaces.
- **Protocol**: Use HTTPS (`https:`) for embedded resources (images, media, stylesheets, scripts) where possible.
- **Comments**: Explain code as needed. Mark action items with `TODO: action item`.

## HTML Rules

### Document Type
- Always use HTML5: `<!doctype html>`.

### Validity
- Use valid HTML where possible. Validate with the [W3C HTML validator](https://validator.w3.org/nu/).

### Semantics
- Use elements for their intended purpose: headings for headings, `<p>` for paragraphs, `<a>` for anchors, etc.
- Prefer semantic elements for accessibility, reuse, and efficiency.

### Multimedia Fallback
- Provide meaningful `alt` text for images.
- Provide transcripts and captions for video and audio where available.
- Use `alt=""` for purely decorative images.

### Separation of Concerns
- Keep structure (HTML), presentation (CSS), and behavior (JS) strictly separate.
- Minimize the number of linked stylesheets and scripts.
- Do not use inline styles or inline event handlers.

### Entity References
- Do not use entity references (e.g., `&mdash;`, `&rdquo;`) when using UTF-8 encoding.
- Exception: characters with special meaning in HTML (`<`, `&`) and control/invisible characters.

### `type` Attributes
- Omit `type` attributes for stylesheets and scripts. HTML5 defaults to `text/css` and `text/javascript`.

```html
<!-- Not recommended -->
<link rel="stylesheet" href="style.css" type="text/css">
<script src="app.js" type="text/javascript"></script>

<!-- Recommended -->
<link rel="stylesheet" href="style.css">
<script src="app.js"></script>
```

### `id` Attributes
- Avoid unnecessary `id` attributes. Prefer `class` for styling and `data-*` for scripting.
- When `id` is required, always include a hyphen (e.g., `user-profile`, not `userProfile`).

### HTML Formatting
- Use a new line for every block, list, or table element. Indent child elements.
- Use double quotation marks (`""`) for attribute values.
- Break long lines if it significantly improves readability; indent continuation lines.

### Optional Tags
- Consider omitting optional tags for file size optimization (per the [HTML5 spec](https://html.spec.whatwg.org/multipage/syntax.html#syntax-tag-omission)), but apply consistently across the project.

## CSS Rules

### Validity
- Use valid CSS. Validate with the [W3C CSS validator](https://jigsaw.w3.org/css-validator/).

### Class Naming
- Use meaningful or generic class names that reflect the element's purpose.
- Keep class names as short as possible but as long as necessary.
- Separate words with hyphens (`-`). Do not use underscores or camelCase.

```css
/* Not recommended */
.yee-1901 {}
.button-green {}
.demoimage {}
.error_status {}

/* Recommended */
.gallery {}
.login {}
.video-id {}
.ads-sample {}
```

### Selectors
- **Avoid ID selectors**: Use class selectors in all situations.
- **Avoid type selectors** qualifying class names (e.g., use `.example` not `ul.example`).
- **Prefixes** (optional): In large projects, use short namespace prefixes (e.g., `.adw-help`).

### Shorthand Properties
- Use shorthand properties where possible (e.g., `font`, `padding`, `border`, `margin`).

```css
/* Not recommended */
padding-top: 0;
padding-right: 1em;
padding-bottom: 2em;
padding-left: 1em;

/* Recommended */
padding: 0 1em 2em;
```

### Values
- **0 and units**: Omit units after `0` values unless required (e.g., `flex: 0px`).
- **Leading 0s**: Always include leading `0`s for values between -1 and 1 (e.g., `font-size: 0.8em`).
- **Hex colors**: Use 3-character hex notation where possible (e.g., `#ebc` not `#eebbcc`).
- **`!important`**: Avoid `!important` declarations. Use selector specificity to override properties.
- **Quotation marks**: Use single quotes (`''`) for attribute selectors and property values. No quotes in `url()`.

```css
/* Not recommended */
color: #eebbcc;
font-size: .8em;
margin: 0px;

/* Recommended */
color: #ebc;
font-size: 0.8em;
margin: 0;
```

### Hacks
- Avoid user agent detection and CSS hacks. Try a different approach first.

## CSS Formatting

### Declaration Order
- Sort declarations alphabetically within a project for consistency.
- Ignore vendor-specific prefixes for sorting purposes, but keep multiple vendor prefixes for the same property sorted.

```css
background: fuchsia;
border: 1px solid;
-moz-border-radius: 4px;
-webkit-border-radius: 4px;
border-radius: 4px;
color: black;
text-align: center;
text-indent: 2em;
```

### Block Content Indentation
- Indent all block content (rules within rules, declarations) to reflect hierarchy.

```css
@media screen, projection {

  html {
    background: #fff;
    color: #444;
  }

}
```

### Declaration Stops
- Use a semicolon after every declaration, including the last one.

### Property Name Colon Spacing
- Use a single space after the colon. No space between property name and colon.

```css
/* Not recommended */
h3 {
  font-weight:bold;
}

/* Recommended */
h3 {
  font-weight: bold;
}
```

### Declaration Block Separation
- Use a single space between the last selector and the opening brace.
- Opening brace on the same line as the last selector.

### Selector and Declaration Separation
- Start a new line for each selector and each declaration.

```css
/* Not recommended */
a:focus, a:active {
  position: relative; top: 1px;
}

/* Recommended */
h1,
h2,
h3 {
  font-weight: normal;
  line-height: 1.2;
}
```

### Rule Separation
- Always put a blank line between rules.

### Section Comments
- Group stylesheet sections with comments. Separate sections with new lines.

```css
/* Header */

.adw-header {}

/* Footer */

.adw-footer {}
```

## Enforcement

### Prettier Configuration (`.prettierrc`)

```json
{
  "printWidth": 80,
  "tabWidth": 2,
  "useTabs": false,
  "singleQuote": false,
  "htmlWhitespaceSensitivity": "css",
  "endOfLine": "lf"
}
```

### Stylelint Configuration (`.stylelintrc.json`)

```json
{
  "extends": "stylelint-config-standard",
  "rules": {
    "selector-class-pattern": "^[a-z][a-z0-9]*(-[a-z0-9]+)*$",
    "selector-id-pattern": "^[a-z][a-z0-9]*(-[a-z0-9]+)*$",
    "no-descending-specificity": true,
    "shorthand-property-no-redundant-values": true,
    "declaration-block-no-redundant-longhand-properties": true,
    "color-hex-length": "short",
    "length-zero-no-unit": true,
    "number-leading-zero": "always",
    "declaration-block-single-line-max-declarations": 1
  }
}
```

### HTMLHint Configuration (`.htmlhintrc`)

```json
{
  "tagname-lowercase": true,
  "attr-lowercase": true,
  "attr-value-double-quotes": true,
  "doctype-first": true,
  "tag-pair": true,
  "spec-char-escape": true,
  "id-unique": true,
  "src-not-empty": true,
  "alt-require": true
}
```

### Pre-commit Configuration (`.pre-commit-config.yaml`)

```yaml
repos:
  - repo: https://github.com/pre-commit/mirrors-prettier
    rev: v4.0.0-alpha.8
    hooks:
      - id: prettier
        types_or: [html, css]

  - repo: https://github.com/pre-commit/pre-commit-hooks
    rev: v5.0.0
    hooks:
      - id: trailing-whitespace
      - id: end-of-file-fixer
```

### Setup Instructions

```bash
# Install tools
npm install --save-dev prettier stylelint stylelint-config-standard htmlhint

# Run prettier
npx prettier --write "**/*.{html,css}"

# Run stylelint
npx stylelint "**/*.css"

# Run htmlhint
npx htmlhint "**/*.html"
```
