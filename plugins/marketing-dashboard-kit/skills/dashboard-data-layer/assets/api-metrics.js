// GET /api/metrics — the projection layer. Node serverless runtime.
// Verifies the session cookie (defense-in-depth with the Edge gate), then
// fans out to independent adapters and assembles the contract. One dead
// adapter degrades its own tile to `—`; it never 500s the page.
//
// Env: SESSION_SECRET, SUPABASE_URL, SUPABASE_ANON_KEY, plus the public
//      Substack feed URL (or whatever feeds this user's connector map).

import crypto from 'node:crypto';

const COOKIE_NAME = 'dash_session';
const SUPABASE_URL = process.env.SUPABASE_URL;
const SUPABASE_ANON_KEY = process.env.SUPABASE_ANON_KEY;
const SUBSTACK_FEED = process.env.SUBSTACK_FEED_URL; // e.g. https://x.substack.com/feed

// ---- auth (mirror of the Edge middleware, Node crypto here) ----------------
function verifySession(req) {
  const secret = process.env.SESSION_SECRET;
  if (!secret) return false;
  const raw = (req.headers.cookie || '').split(';').map(s => s.trim())
    .find(s => s.startsWith(COOKIE_NAME + '='));
  if (!raw) return false;
  const [exp, sig] = decodeURIComponent(raw.slice(COOKIE_NAME.length + 1)).split('.');
  if (!exp || !sig) return false;
  const expected = crypto.createHmac('sha256', secret).update(exp).digest('hex');
  const ok = expected.length === sig.length &&
    crypto.timingSafeEqual(Buffer.from(expected), Buffer.from(sig));
  return ok && Date.now() <= Number(exp);
}

// ---- adapters: each returns {configured, error?, ...data} ------------------
async function fetchFunnel() {
  if (!SUPABASE_URL || !SUPABASE_ANON_KEY) return { configured: false };
  try {
    const r = await fetch(`${SUPABASE_URL}/rest/v1/rpc/dashboard_funnel_metrics`, {
      method: 'POST',
      headers: { apikey: SUPABASE_ANON_KEY, Authorization: `Bearer ${SUPABASE_ANON_KEY}`,
                 'content-type': 'application/json' },
      body: '{}',
    });
    if (!r.ok) return { configured: true, error: 'rpc_failed' };
    return { configured: true, ...(await r.json()) };
  } catch { return { configured: true, error: 'fetch_failed' }; }
}

async function fetchSubstack() {
  if (!SUBSTACK_FEED) return null;
  try {
    const res = await fetch(SUBSTACK_FEED, { headers: { 'user-agent': 'dashboard/1.0' } });
    if (!res.ok) return null;
    const xml = await res.text();
    const items = [...xml.matchAll(/<item>([\s\S]*?)<\/item>/g)].map(m => m[1]);
    const title = b => (b.match(/<title><!\[CDATA\[(.*?)\]\]><\/title>/)
                     || b.match(/<title>(.*?)<\/title>/) || [])[1] || null;
    return { post_count: items.length, latest_post: items[0] ? title(items[0]) : null };
  } catch { return null; }
}

// ---- handler ---------------------------------------------------------------
export default async function handler(req, res) {
  if (!verifySession(req)) return res.status(401).json({ error: 'unauthorized' });

  const [q, sub] = await Promise.all([fetchFunnel(), fetchSubstack()]);
  const live = q.configured && !q.error;
  const rate = (n, d) => (d > 0 ? n / d : null);

  res.setHeader('cache-control', 'private, max-age=60');
  return res.status(200).json({
    updated_at: new Date().toISOString(),
    funnel: {
      visits: null, visits_delta: null,
      quiz_started:   live ? q.quiz_started   : null,
      start_rate:     null,
      quiz_completes: live ? q.quiz_completes : null,
      complete_rate:  live ? rate(q.quiz_completes, q.quiz_started) : null,
      optins:         live ? q.optins         : null,
      optin_rate:     live ? rate(q.optins, q.quiz_completes)       : null,
      open_to_meet:   live ? (q.open_to_meet ?? null) : null,
      otm_rate:       live ? rate(q.open_to_meet, q.optins)         : null,
      booked: null, booked_rate: null,
    },
    emails: [1,2,3,4,5].map(num => ({
      num, delivered: null, open_rate: null, ctr: null, reply_rate: null,
      unsubscribed: null, bounced: null,
    })),
    cold: { sent:null, opened:null, open_rate:null, replied:null,
            reply_rate:null, booked:null, booked_rate:null, bounced:null },
    substack: sub
      ? { subscribers:null, post_count:sub.post_count, latest_post:sub.latest_post,
          avg_open_rate:null, avg_ctr:null, growth_30d:null }
      : { subscribers:null, post_count:null, latest_post:null,
          avg_open_rate:null, avg_ctr:null, growth_30d:null },
    sources: {
      funnel:   live ? { status:'live', note:'Supabase RPC · live' }
                     : { status:'pending', note:'Deploy dashboard_funnel_metrics + set SUPABASE_ANON_KEY' },
      emails:   { status:'pending', note:'ESP webhooks · pending wiring' },
      cold:     { status:'manual',  note:'CSV import / SQL updates' },
      substack: { status: sub ? 'live' : 'pending', note: sub ? 'RSS · live' : 'RSS feed not set' },
    },
    bench_note: live && q.quiz_completes
      ? `${q.quiz_completes} completed · ${q.optins} opt-ins`
      : 'Awaiting first completion',
  });
}
