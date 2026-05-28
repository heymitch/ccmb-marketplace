# endpoints.json — Schema Reference

This document defines the exact format of `endpoints.json` files written by the Sniffer skill.

## File Location

Save to:
```
[working-folder]/[site-name]/endpoints.json
```

Where `site-name` is the bare domain without protocol (e.g., `substack.com`, `notion.so`, `heymitch.substack.com` for subdomain-scoped APIs).

---

## Top-Level Schema

```json
{
  "site": "example.com",
  "base_url": "https://example.com",
  "sniffed_at": "2026-02-26T12:00:00Z",
  "sniffed_from_page": "https://example.com/dashboard",
  "auth_required": true,
  "total_raw": 87,
  "filtered": 23,
  "unique": 11,
  "api_style": "REST",
  "notes": "Free-text notes about anything unusual about this API",
  "endpoints": [ ... ]
}
```

### Top-level fields

| Field | Type | Description |
|-------|------|-------------|
| `site` | string | Bare domain, e.g. `"substack.com"` |
| `base_url` | string | Full origin, e.g. `"https://substack.com"` |
| `sniffed_at` | ISO 8601 | When the sniffer ran |
| `sniffed_from_page` | string | The page URL where sniffer was injected |
| `auth_required` | boolean | Whether session auth was active during sniff |
| `total_raw` | number | Total captured requests before filtering |
| `filtered` | number | After removing analytics/CDN/static noise |
| `unique` | number | After deduplication by normalized path |
| `api_style` | string | `"REST"`, `"GraphQL"`, `"RPC"`, or `"mixed"` |
| `notes` | string | Any quirks, observations, or warnings |
| `endpoints` | array | The actual endpoint records (see below) |

---

## Endpoint Record Schema

```json
{
  "method": "PUT",
  "url": "https://heymitch.substack.com/api/v1/drafts/189289551",
  "normalized": "https://heymitch.substack.com/api/v1/drafts/:id",
  "path_pattern": "/api/v1/drafts/:id",
  "status": 200,
  "type": "fetch",
  "hasJson": true,
  "bodyLength": 3842,
  "parameters": {
    "path": {
      "id": "number — the draft's numeric ID, visible in the editor URL"
    },
    "query": {},
    "body": {
      "draft_title": "string — the post title",
      "draft_subtitle": "string — the post subtitle/description",
      "draft_body": "string — JSON-stringified ProseMirror document",
      "draft_podcast_url": "string|null",
      "draft_podcast_duration": "number|null"
    }
  },
  "responseShape": {
    "id": "number",
    "draft_title": "string",
    "draft_subtitle": "string",
    "draft_body": "string",
    "draft_created_at": "string",
    "draft_updated_at": "string"
  },
  "notes": "Main write endpoint for posts. Body must be JSON-stringified ProseMirror. Proven working 2026-02-26.",
  "proven": true,
  "proven_at": "2026-02-26T12:00:00Z",
  "monkey_function": "updateDraft"
}
```

### Endpoint fields

| Field | Type | Description |
|-------|------|-------------|
| `method` | string | HTTP method: `GET`, `POST`, `PUT`, `PATCH`, `DELETE` |
| `url` | string | Raw URL captured from the browser (with real IDs) |
| `normalized` | string | URL with dynamic segments replaced per URL variable rules |
| `path_pattern` | string | Just the path portion of `normalized` |
| `status` | number | HTTP status returned during capture |
| `type` | string | `"fetch"` or `"xhr"` |
| `hasJson` | boolean | Whether the response was parseable JSON |
| `bodyLength` | number | Response body byte length |
| `parameters.path` | object | Dynamic path segments with descriptions |
| `parameters.query` | object | Query string parameters with descriptions |
| `parameters.body` | object | Request body fields with types and descriptions |
| `responseShape` | object | Top-level keys of the JSON response with inferred types |
| `notes` | string | Human-readable notes about this endpoint |
| `proven` | boolean | Whether Replay has successfully called this (HTTP 2xx) |
| `proven_at` | ISO 8601 | When Replay last confirmed it works |
| `monkey_function` | string | Name of the function in monkey.js that wraps this endpoint |

---

## GraphQL Variant

If `api_style` is `"GraphQL"`, endpoint records look slightly different:

```json
{
  "method": "POST",
  "url": "https://example.com/graphql",
  "normalized": "https://example.com/graphql",
  "operation_name": "GetUserProfile",
  "operation_type": "query",
  "fields_requested": ["id", "name", "email", "avatar"],
  "status": 200,
  "notes": "User profile query — called on page load"
}
```

For GraphQL, enumerate operations instead of paths.

---

## Working Folder Structure

A fully populated working folder for a site looks like:

```
[working-folder]/
└── substack.com/
    ├── endpoints.json      ← API surface map (this file)
    ├── monkey.js           ← Proven, executable fetch() functions
    └── notes.md            ← Optional: session notes, quirks, gotchas
```

The Sniffer creates `endpoints.json` and a skeleton `monkey.js`. The Replay skill fills in `proven` fields and appends functions to `monkey.js` after confirmed calls.