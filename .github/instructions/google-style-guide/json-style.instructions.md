---
description: "Use when writing, reviewing, or modifying JSON data files or API responses. Enforces Google JSON Style Guide conventions for property naming, structure, data types, and reserved properties."
applyTo: "**/*.json"
---

# Google JSON Style Guide

Reference: https://google.github.io/styleguide/jsoncstyleguide.xml

## General

- **No comments** in JSON. JSON does not support comments of any kind.
- **Double quotes** are required for all strings and property names. Single quotes are not valid JSON.
- **UTF-8 encoding** must be used for all JSON files.
- **Flattened data** is preferred over structured hierarchy. Data should not be arbitrarily grouped for convenience; avoid unnecessary nesting.

## Property Names

- Use **camelCase** for all property names (e.g., `firstName`, `itemCount`, `startDate`).
- Property names must be **meaningful** and descriptive of the value they contain.
- **Avoid reserved JavaScript keywords** as property names (e.g., `default`, `class`, `export`, `function`, `new`, `return`, `var`, `void`, `while`, `with`).
- Use **singular** names for non-array properties and **plural** names for array properties (e.g., `"items": [...]`, `"name": "..."`).
- JSON map keys may use any Unicode character, but standard property names should stick to camelCase ASCII.
- Avoid naming conflicts by choosing a new property name or versioning the API rather than overloading existing names.

## Property Values

- Property values must be one of: **boolean**, **number**, **string**, **object**, **array**, or **null**.
- Use the correct JSON type — do **not** stringify numbers or booleans (use `42` not `"42"`, use `true` not `"true"`).
- **Empty or null values**: Consider removing properties with empty string `""` or `null` values entirely unless the client requires explicit presence. If `null` has semantic meaning, it may be retained.
- **Enum values** should be represented as **strings**, not integers (e.g., `"status": "active"` not `"status": 1`).

## Data Types

- **Dates** must be formatted per **RFC 3339**: `yyyy-MM-ddTHH:mm:ssZ` (e.g., `"2025-04-15T08:30:00Z"`).
- **Time durations** must be formatted per **ISO 8601** (e.g., `"P3Y6M4DT12H30M5S"`).
- **Latitude/Longitude** should be formatted per **ISO 6709** (e.g., `"+48.8577+002.295/"`).

## Reserved Properties

The following property names are reserved and must be used consistently when applicable:

### Top-Level Properties

| Property     | Type   | Description                                      |
|--------------|--------|--------------------------------------------------|
| `apiVersion` | string | Version of the API                               |
| `context`    | string | Client-specified context value                   |
| `id`         | string | Identifier for the request/response              |
| `method`     | string | Method name for the operation                    |
| `params`     | object | Request parameters                               |
| `data`       | object | Container for all response data                  |
| `error`      | object | Container for error information                  |

### Properties in the `data` Object

| Property     | Type    | Description                                     |
|--------------|---------|-------------------------------------------------|
| `kind`       | string  | Type of resource (should be **first property**)  |
| `fields`     | string  | Fields filter for partial responses              |
| `etag`       | string  | ETag for caching                                 |
| `id`         | string  | Unique identifier for the resource               |
| `lang`       | string  | Language (BCP 47 format)                         |
| `updated`    | string  | Last update timestamp (RFC 3339)                 |
| `deleted`    | boolean | Soft-delete indicator                            |
| `items`      | array   | Collection of resources (should be **last property**) |

### Paging Properties (in `data`)

| Property            | Type    | Description                            |
|---------------------|---------|----------------------------------------|
| `currentItemCount`  | integer | Number of items in this page           |
| `itemsPerPage`      | integer | Items per page                         |
| `startIndex`        | integer | Start index of this page               |
| `totalItems`        | integer | Total items across all pages           |
| `pageIndex`         | integer | Current page index                     |
| `totalPages`        | integer | Total number of pages                  |
| `nextLink`          | string  | URI to the next page                   |
| `previousLink`      | string  | URI to the previous page               |
| `selfLink`          | string  | URI to the current resource            |
| `editLink`          | string  | URI for editing the resource           |

## Structuring

- Prefer **flat structures** over deeply nested objects where practical.
- Maintain **consistent property ordering** within objects:
  - `kind` should be the **first** property.
  - `items` should be the **last** property in the `data` object.
- A top-level JSON response should contain either `data` or `error`, but **not both**.

## Error Representation

Errors must follow the standard error object structure:

```json
{
  "error": {
    "code": 404,
    "message": "Resource not found.",
    "errors": [
      {
        "domain": "global",
        "reason": "notFound",
        "message": "Resource not found.",
        "location": "id",
        "locationType": "parameter",
        "extendedHelp": "https://example.com/docs/errors#notFound",
        "sendReport": "https://example.com/report"
      }
    ]
  }
}
```

| Property                     | Type   | Description                               |
|------------------------------|--------|-------------------------------------------|
| `error.code`                 | integer| HTTP status code or application error code|
| `error.message`              | string | Human-readable error message              |
| `error.errors[]`             | array  | List of individual errors                 |
| `error.errors[].domain`      | string | Error domain/category                     |
| `error.errors[].reason`      | string | Machine-readable error reason             |
| `error.errors[].message`     | string | Human-readable per-error message          |
| `error.errors[].location`    | string | Location of the error (e.g., field name)  |
| `error.errors[].locationType`| string | Type of location (e.g., `"parameter"`, `"header"`) |

## Enforcement

### Prettier Configuration (`.prettierrc` — JSON section)

```json
{
  "tabWidth": 2,
  "useTabs": false,
  "endOfLine": "lf"
}
```

### Pre-commit Configuration (`.pre-commit-config.yaml`)

```yaml
repos:
  - repo: https://github.com/pre-commit/mirrors-prettier
    rev: v4.0.0-alpha.8
    hooks:
      - id: prettier
        types: [json]

  - repo: https://github.com/pre-commit/pre-commit-hooks
    rev: v5.0.0
    hooks:
      - id: check-json
      - id: pretty-format-json
        args: [--autofix, --indent, "2"]
      - id: trailing-whitespace
      - id: end-of-file-fixer
```

### Setup Instructions

```bash
# Install prettier
npm install --save-dev prettier

# Format JSON files
npx prettier --write "**/*.json"

# Validate JSON
python -m json.tool < file.json
```
