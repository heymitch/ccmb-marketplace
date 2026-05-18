# RLS, keys, and PostgREST counting

## RLS mental model

- RLS **off** (default): any valid key can do anything the role's GRANTs allow. Effectively wide open.
- RLS **on, no policies**: `anon` and `authenticated` get **nothing**. `service_role` still bypasses everything.
- RLS **on, with policies**: each policy grants a specific operation to a specific role under a condition.

Enable RLS on every table that holds real data. Then add the *minimum* policies.

## The public-form pattern (write-only)

A landing page form must insert but must never read the table back (so a scraper with the anon key can't dump your leads):

```sql
alter table quiz_contacts enable row level security;

create policy "anon inserts only" on quiz_contacts
  for insert to anon
  with check (true);

-- Deliberately NO select/update/delete policy for anon.
grant insert on quiz_contacts to anon;
```

Generate the row id server-side and use `Prefer: return=minimal` so the insert doesn't need a SELECT policy to return the row:

```js
await fetch(`${SUPABASE_URL}/rest/v1/quiz_contacts`, {
  method: 'POST',
  headers: {
    apikey: SUPABASE_ANON_KEY,
    Authorization: `Bearer ${SUPABASE_ANON_KEY}`,
    'content-type': 'application/json',
    Prefer: 'return=minimal',
  },
  body: JSON.stringify({ id: crypto.randomUUID(), email, ... }),
});
```

## Counting without pulling rows

To show "1,432 opt-ins" you need a count, not 1,432 rows. PostgREST returns the exact count in a header when you ask:

```js
const r = await fetch(`${SUPABASE_URL}/rest/v1/quiz_contacts?select=id`, {
  headers: {
    apikey: KEY, Authorization: `Bearer ${KEY}`,
    Prefer: 'count=exact',
    Range: '0-0',                 // ask for zero rows; we only want the count
  },
});
const total = Number(r.headers.get('content-range')?.split('/')[1] || 0);
```

`content-range` looks like `0-0/1432`; the number after the slash is the total. This is dramatically cheaper than fetching rows and `.length`-ing them. (For aggregates across multiple tables, prefer a single SECURITY DEFINER function over many count calls — one round trip, one security boundary.)

## Counting / suppression rules for funnels

When the numbers feed a funnel, define and document the rules so the dashboard is defensible:

- Don't count an opt-in as "in sequence" until the first email is `delivered`.
- Dedupe replies by sender, not by message (one human = one reply).
- Attribution: last opened/clicked email within 72h of the conversion event.
- A user who unsubscribed before email N is out of the denominator for N+ but still in the overall denominator.

These belong in a `marketing/dashboard-notes.md` style spec, referenced by the data-layer skill, so the SQL and the dashboard agree on what each number means.

## Key storage checklist

- [ ] `SUPABASE_URL` — safe anywhere
- [ ] `SUPABASE_ANON_KEY` — safe in client; still set as env var for tidiness
- [ ] `SUPABASE_SERVICE_ROLE_KEY` — server env var ONLY; never client, never committed, never `NEXT_PUBLIC_`/`VITE_`
- [ ] Set env vars with `printf`, not `echo` (echo appends `\n`, which silently corrupts the key — a real bug we hit)
- [ ] Rotate `service_role` immediately if it ever touches a client bundle or a public repo
