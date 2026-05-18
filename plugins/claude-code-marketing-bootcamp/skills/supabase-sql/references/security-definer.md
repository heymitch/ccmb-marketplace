# SECURITY DEFINER — hardening and footguns

`SECURITY DEFINER` makes a function execute with the privileges of the user who *owns* it (normally `postgres`), not the user who *calls* it. This is how you let a low-privilege caller (the `anon` key) trigger a privileged read without granting them table access.

## The mandatory hardening line

```sql
set search_path = public
```

Without a pinned `search_path`, a caller who can create objects in a schema that appears earlier in the default search path can shadow the tables/functions your definer function references — and your function will execute *their* code with owner privileges. This is the canonical SECURITY DEFINER privilege-escalation attack. Always pin it. If you reference `extensions` schema objects, pin `set search_path = public, extensions`.

## Make it read-only and cheap

- `language sql` + `stable` — tells Postgres the function does not mutate and can be optimized; safe for read aggregates.
- Return `json` / `jsonb` via `json_build_object(...)` so the API surface is one predictable shape.
- Never `select *`. The function's return list is your security boundary. Enumerate exactly the aggregates you intend to expose.

## Parameterized aggregate (date-ranged funnel)

When the dashboard needs a window (last 7/30/90 days), parameterize — but validate the input domain to keep the surface tight:

```sql
create or replace function public.funnel_metrics(window_days int default 30)
returns json
language sql
security definer
set search_path = public
stable
as $$
  with bounds as (
    select now() - (least(greatest(window_days, 1), 365) || ' days')::interval as since
  )
  select json_build_object(
    'window_days', least(greatest(window_days, 1), 365),
    'visits',      (select count(*) from events, bounds where type='visit'  and created_at > since),
    'optins',      (select count(*) from events, bounds where type='optin'  and created_at > since),
    'booked',      (select count(*) from events, bounds where type in ('interview_booked','async_reply') and created_at > since)
  );
$$;

revoke all on function public.funnel_metrics(int) from public;
grant execute on function public.funnel_metrics(int) to anon, authenticated, service_role;
```

`least(greatest(window_days,1),365)` clamps the parameter so a caller can't pass `-1` or `999999` and probe behavior. Clamp every numeric parameter on a public-callable definer function.

## Granting execute — who should get it?

| Grant to | When |
|---|---|
| `anon` | dashboard calls it with the publishable key (aggregates only, safe) |
| `authenticated` | logged-in Supabase users may call it |
| `service_role` | always include — server paths use it too |

Always `revoke all ... from public` first, then grant explicitly. `public` includes every role; explicit grants are auditable.

## Rollback

A definer function is a single object with no data. Safe to drop:

```sql
drop function if exists public.dashboard_funnel_metrics();
```

No tables touched, no migrations to unwind. This is why the pattern is low-risk to ship: the entire new attack surface is one droppable function.

## When NOT to use SECURITY DEFINER

- The caller should only see *their own* rows → use a normal RLS policy with `auth.uid()`, not a definer function.
- The endpoint is already server-only and trusted → just use the `service_role` key; a definer function adds nothing.
- You need writes from the public → a definer function that mutates is a loaded gun; prefer an RLS `insert` policy with a `with check` constraint.
