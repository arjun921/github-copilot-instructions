---
description: "Use when writing, reviewing, or modifying Markdown documentation. Enforces Google Markdown Style Guide conventions for headings, lists, links, code blocks, line length, and document structure."
applyTo: "**/*.md"
---

# Google Markdown Style Guide

Reference: https://google.github.io/styleguide/docguide/style.html

## Document Layout

- Start with a level-one heading (`# Title`) that matches or closely matches the filename.
- Follow with a short introduction (1–3 sentences).
- Place `[TOC]` directive (if supported) after the introduction, before the first H2.
- Use `## Topic` sections for the body content.
- End with a `## See also` section for miscellaneous links.
- **Character line limit**: 80 characters. Exceptions: links, tables, headings, and code blocks.
- **Trailing whitespace**: Do not use trailing whitespace for line breaks. Use a trailing backslash (`\`) sparingly if a hard break is needed. Prefer paragraph separation with blank lines.

## Headings

- **ATX-style only**: Use `#` syntax. Do not use `=` or `-` underline headings.
- **Spacing**: Always include a space after `#`. Add a blank line before and after every heading.
- **One H1 per document**: The first heading must be `#` (H1) and serves as the document title. All subsequent headings must be `##` or deeper.
- **Do not skip levels**: Follow `##` with `###`, not `####`.
- **Unique, descriptive names**: Every heading (including sub-sections) must have a unique, fully descriptive name to produce clear anchor links.
- **Capitalization**: Follow sentence case or title case consistently per the [Google Developer Documentation Style Guide](https://developers.google.com/style/capitalization#capitalization-in-titles-and-headings).

## Lists

- **Lazy numbering for long lists**: Use `1.` for every item in long or frequently changing ordered lists. For short, stable lists, prefer fully numbered (`1.`, `2.`, `3.`).
- **Nested list indentation**: Use a 4-space indent for both numbered and bulleted lists. Continuation text for wrapped lines also uses a 4-space indent.
- **Bullet marker**: Use dashes (`-`) consistently for unordered lists.
- **Simple lists**: When lists are small, not nested, and single-line, one space after the marker suffices.

## Code

- **Inline code**: Use backticks for short code quotations, field names, file names, and commands (e.g., `` `my_script.sh` ``).
- **Code span for escaping**: Wrap fake paths or example URLs in backticks to prevent unwanted autolinking.
- **Fenced code blocks**: Use triple backticks (`` ``` ``) for multi-line code. Do not use 4-space indented code blocks.
- **Declare the language**: Always specify a language identifier after the opening fence (e.g., `` ```python ``).
- **Escape newlines**: In command-line snippets, use a trailing backslash (`\`) to escape long lines.
- **Nest code blocks within lists**: Indent fenced code blocks to align with the list item text so they don't break the list.

## Links

- **Use explicit paths**: Link to Markdown files with explicit paths (`[text](/path/to/page.md)`), not full URLs.
- **Avoid deep relative paths**: Use relative links only within the same directory. Avoid `../../` paths.
- **Informative link text**: Write the sentence naturally, then wrap the most appropriate phrase as the link. Never use "click here", "link", or "here" as link text. Never duplicate the raw URL as link text.
- **Reference-style links**: Use reference links (`[text][ref]`) when:
  - The URL is long enough to disrupt readability.
  - The same URL is referenced multiple times.
  - Inside tables, to keep cells short.
- **Reference link placement**: Define reference links just before the next heading (end of the section where first used). Multi-section references go at the end of the document.

## Images

- Use images sparingly; prefer simple screenshots when visuals aid understanding.
- **Always include alt text**: Provide descriptive `alt` text for every image so non-sighted readers can understand the content (e.g., `![Screenshot of settings page](settings.png)`).

## Tables

- Use tables only for genuinely tabular data that benefits from two-dimensional scanning.
- Prefer lists and subheadings when data is sparse, unbalanced, or contains long prose.
- Align pipes (`|`) for readability in source.
- Use reference links inside table cells to keep lines short.

## Line Breaks and Paragraphs

- Separate paragraphs with a blank line.
- Do not use trailing spaces for `<br />` breaks.
- Use a trailing backslash (`\`) only when a hard line break is truly necessary.

## Emphasis

- Use `*italic*` for italic text (single asterisks).
- Use `**bold**` for bold text (double asterisks).
- Do not use underscores (`_`) for emphasis.

## Prefer Markdown over HTML

- Strongly prefer standard Markdown syntax. Avoid HTML hacks.
- If it cannot be done in Markdown, reconsider whether it is truly necessary.

## Enforcement

### markdownlint Configuration (`.markdownlint.json`)

```json
{
  "default": true,
  "MD003": { "style": "atx" },
  "MD004": { "style": "dash" },
  "MD007": { "indent": 4 },
  "MD013": { "line_length": 80, "code_blocks": false, "tables": false },
  "MD024": { "siblings_only": true },
  "MD029": { "style": "one" },
  "MD033": false,
  "MD036": false
}
```

### Pre-commit Configuration (`.pre-commit-config.yaml`)

```yaml
repos:
  - repo: https://github.com/igorshubovych/markdownlint-cli
    rev: v0.43.0
    hooks:
      - id: markdownlint
        args: [--fix]

  - repo: https://github.com/pre-commit/pre-commit-hooks
    rev: v5.0.0
    hooks:
      - id: trailing-whitespace
      - id: end-of-file-fixer
```

### Setup Instructions

```bash
# Install markdownlint-cli
npm install --save-dev markdownlint-cli

# Run markdownlint
npx markdownlint "**/*.md"

# Autofix
npx markdownlint --fix "**/*.md"
```
