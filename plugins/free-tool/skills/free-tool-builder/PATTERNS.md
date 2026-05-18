# Free Tool Code Patterns

Reusable, framework-agnostic patterns extracted from a production build.
Load for workflow steps 6–10. Vanilla by default — adopt the workspace's
stack if it has one.

---

## 1. Inherit, never re-declare (the cardinal rule)

The workspace has a design-token stylesheet (colors, type, spacing, motion).

**Do:**
```css
/* tool.css */
body { background: var(--bg); color: var(--fg); font-family: var(--font-body); }
.card { background: var(--bone); border: 1px solid var(--rule); }
```

**Never:**
```css
:root { --bg: #0A0908; --fg: #F4ECDD; }   /* desyncs the tool from the site */
```

Re-declaring tokens caused, in one session, BOTH a sitewide visual mismatch
and a hidden routing bug that went unnoticed during smoke testing. If you
need a token that doesn't exist, add it *additively*, never shadow an
existing one. Detect the token file first (`grep -l 'font-display\|--bg' *.css`).

---

## 2. Pure scoring engine + TDD

Scoring is a **pure module**: inputs in, result out. No DOM, no fetch, no
globals. Unit-test it before any UI exists.

```js
// scoring.js
export function scoreTool(answers) {
  const primary = plurality(answers, SCORING_KEYS);
  const coherence = matches(answers, primary) / SCORING_KEYS.length;
  const dimensionBreadth = hitDimensions(answers, primary) / DIMENSIONS.length;
  const monocultureFlag = coherence >= 0.9;
  const driftFlag = answers.gate === 'drift';
  const grade = lookupGrade({ coherence, dimensionBreadth, monocultureFlag, driftFlag, primary });
  return { tier: primary, coherence, dimensionBreadth, monocultureFlag, driftFlag, grade,
           dimensionGrades: perDimension(answers, primary) };
}
```

```js
// scoring.test.js  (node --test, zero deps)
import { test } from 'node:test';
import assert from 'node:assert/strict';
import { scoreTool } from '../<tool>/js/scoring.js';

test('coherent primary tier wins', () => {
  assert.equal(scoreTool(allOneTier()).tier, 'expected');
});
test('monoculture caps at B', () => {
  assert.equal(scoreTool(tenOfTen()).grade, 'B');
});
test('scattered answers grade D/F', () => {
  assert.ok(['D','F'].includes(scoreTool(scattered()).grade));
});
```

Tests travel: a pure module with one ESM import runs unchanged after you
relocate it (e.g. tutorial dir → real repo).

---

## 3. Module-relative fetch (the path-resolution bug)

`fetch('./content.json')` resolves against the **document URL**, not the
script. A page served at `/tool` (no slash) re-roots `./content.json` to
`/content.json` → 404 → init throws → the whole tool is dead, silently.

```js
// Resolve relative to THIS module, robust to trailing-slash + routing.
const url = new URL('../content/questions.json', import.meta.url);
const res = await fetch(url);
if (!res.ok) throw new Error(`content ${res.status}`);  // fail loud, not silent
```

HTML `<link>`/`<script>`: use **absolute** paths (`/tool/…`,
`/colors_and_type.css`), not relative. Belt: set `trailingSlash: false` +
`cleanUrls: true` in the host routing config so the base URL is canonical.

---

## 4. Anon-INSERT-only storage via PostgREST

Extend the lead-magnet skill's Supabase storage. Every tool endpoint is a
**pure INSERT** (split submissions vs contacts so you never need UPDATE).

Migration:
```sql
create table if not exists <tool>_submissions (
  id uuid primary key default gen_random_uuid(),
  created_at timestamptz not null default now(),
  session_id uuid not null,
  responses jsonb not null,
  computed jsonb not null,
  referrer text, user_agent_hash text
);
alter table <tool>_submissions enable row level security;
create policy "<tool>_submissions public insert"
  on <tool>_submissions for insert to public with check (true);
grant insert on <tool>_submissions to anon;
-- NO select/update/delete policy: reads via service role / dashboard only.
```

> RLS controls *which rows*; `GRANT` controls *whether the statement is
> allowed*. You need **both** the policy and `GRANT INSERT TO anon`.

Serverless insert — **generate the UUID server-side, `return=minimal`**:
```js
import { randomUUID } from 'node:crypto';
const id = randomUUID();
const r = await fetch(`${SUPABASE_URL}/rest/v1/<tool>_submissions`, {
  method: 'POST',
  headers: {
    apikey: SUPABASE_ANON_KEY,
    Authorization: `Bearer ${SUPABASE_ANON_KEY}`,
    'Content-Type': 'application/json',
    Prefer: 'return=minimal',          // representation needs a SELECT policy
  },
  body: JSON.stringify({ id, session_id, responses, computed }),
});
if (!r.ok) { /* log + 502 */ }
res.json({ id });                      // return the id we generated
```

`Prefer: return=representation` triggers an internal `RETURNING *` that flows
through RLS — on an insert-only table it fails with a misleading "violates
row-level security" (the row *was* written; the read-back was blocked).
`return=minimal` + server-gen UUID sidesteps it entirely.

Routing config: `cache-control: no-store` on `/api/(.*)` so the edge never
serves a stale submission id to a different user.

---

## 5. Animate a re-render without a framework

Replace the element so the CSS animation re-runs:
```js
const old = document.getElementById('step');
const fresh = old.cloneNode(false);
fresh.innerHTML = render();        // .step { animation: enter 220ms } re-fires
old.parentElement.replaceChild(fresh, old);
```
Honor `@media (prefers-reduced-motion: reduce) { animation:none }`.

---

## 6. Anchor with site chrome

A centered card in an empty viewport reads as a standalone document. Inherit
the workspace's existing nav + footer markup so the tool is a *page of the
site*. Dark nav/footer bands over a light tool body read as editorial
masthead → interior page → colophon. That contrast is what "balanced" means.

---

## 7. Ship spine

`brainstorm → spec/PRD → phased plan → TDD scoring → static UI on inherited
tokens → wire to existing storage → funnel+consent → PR → auto-deploy →
live smoke test`. Deploy mechanics belong to the workspace pipeline, not this
skill — but always finish with a real end-to-end check against production
(submit a synthetic row, confirm it lands, delete it).
