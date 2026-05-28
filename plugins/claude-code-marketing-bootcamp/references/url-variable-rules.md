# URL Variable Rules

This document defines how dynamic URL segments are identified, normalized, and parameterized in `endpoints.json` and `monkey.js`.

## Why This Matters

When the Sniffer captures raw URLs, they contain real IDs and values:

```
GET https://example.com/api/v1/posts/189289551
GET https://example.com/api/v1/posts/189290001
GET https://example.com/api/v1/posts/189291234
```

These are all the same endpoint. The Sniffer normalizes them into a single pattern:

```
GET /api/v1/posts/:id
```

This deduplication is what makes `endpoints.json` readable and `monkey.js` reusable.

---

## Normalization Rules

The Sniffer applies these rules in order when normalizing URL path segments:

### Rule 1: UUID segments → `:uuid`

A UUID is an 8-4-4-4-12 hex string. Replace with `:uuid`.

```
Pattern: /^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$/i
Before:  /api/v1/workspaces/550e8400-e29b-41d4-a716-446655440000/pages
After:   /api/v1/workspaces/:uuid/pages
```

### Rule 2: Long hex strings (8+ chars) → `:id`

Common in content management and git-based systems.

```
Pattern: /^[0-9a-f]{8,}$/i
Before:  /api/v1/commits/a3f4b2c1d9e8
After:   /api/v1/commits/:id
```

### Rule 3: Numeric IDs (3+ digits) → `:id`

Most common type. Any path segment that is purely numeric and 3+ digits long.

```
Pattern: /^\d{3,}$/
Before:  /api/v1/posts/189289551
After:   /api/v1/posts/:id
```

Note: 1 or 2 digit numbers are often part of the path structure (e.g., `/api/v2/`) and are NOT replaced.

### Rule 4: Query parameters — keep as-is in the pattern

Query parameters are documented in `endpoints.json` but are not normalized into the path pattern. They appear as a `queryParams` field.

```
Before:  /api/v1/posts?page=2&limit=20&sort=desc
Pattern: /api/v1/posts
queryParams: { page: "number", limit: "number", sort: "string" }
```

---

## In endpoints.json

Each endpoint stores both the raw URL and the normalized pattern:

```json
{
  "method": "GET",
  "url": "https://heymitch.substack.com/api/v1/drafts/189289551",
  "normalized": "https://heymitch.substack.com/api/v1/drafts/:id",
  "status": 200,
  "parameters": {
    "path": { "id": "number — the draft's numeric ID, visible in the editor URL" },
    "query": {},
    "body": {}
  }
}
```

---

## In monkey.js

When writing a function for a parameterized endpoint, use a function parameter:

```javascript
/**
 * @param {number} draftId - The draft's numeric ID (from the editor URL)
 */
async function updateDraft(draftId, ...) {
  return await callAPI("PUT", `/api/v1/drafts/${draftId}`, { ... });
}
```

Never hardcode real IDs in function signatures. The user provides the ID at call time.

---

## How to Find an ID

Common ways the user can get IDs to pass to Monkey functions:

| ID type | How to find it |
|---------|----------------|
| Substack draft ID | In the URL when editing: `/publish/post/189289551` → ID is `189289551` |
| Notion page ID | In the URL: `notion.so/workspace/Page-Title-abc123def456` → ID is the hex suffix |
| UUID | Often visible in the URL or returned in a prior API response |
| Row/record ID | Call the list endpoint first (e.g., `GET /api/v1/posts`) and extract from the response |

---

## Special Cases

### Slugs vs IDs

Some APIs use slugs (human-readable strings) instead of numeric IDs:

```
/api/v1/publications/my-publication-name
```

Slugs are NOT normalized — they are kept as-is in the pattern and documented as `slug` type parameters.

### Nested resources

When an endpoint has multiple dynamic segments, each gets its own parameter name:

```
Before:  /api/v1/publications/12345/posts/189289551
After:   /api/v1/publications/:publicationId/posts/:postId
```

Use descriptive names in `monkey.js` functions to avoid confusion:

```javascript
async function getPost(publicationId, postId) {
  return await callAPI("GET", `/api/v1/publications/${publicationId}/posts/${postId}`);
}
```

### Version segments

API version prefixes like `v1`, `v2` are NOT replaced:

```
/api/v1/posts/:id  ← v1 stays, 189289551 becomes :id
/api/v2/posts/:id  ← separate endpoint family, document both
```