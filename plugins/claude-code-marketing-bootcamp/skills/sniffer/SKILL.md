---
name: sniffer
description: >
  Discovery phase of the Sniffer and Monkey system. Intercepts all fetch() and XHR calls on a live browser tab to map a site's API surface.
  Say "sniff [site]", "discover APIs on [site]", "learn [site]'s API", "map [site]'s endpoints", "watch what [site] calls", or "first time on [site]".
  Also triggers automatically when Monkey routes to this phase because no endpoints.json exists yet.
user-invocable: true
---

# Sniffer — Discovery Phase

The Sniffer intercepts real network calls from inside the browser tab to build an accurate map of a site's API surface. It always reflects real behavior — not guesses from reading page source.

## How Sniffer Works

1. Navigate to the target site (user must already be logged in)
2. Inject the intercept script into the page via `browser_evaluate`
3. Trigger network activity by interacting with the page
4. Harvest the captured calls
5. Filter noise (analytics, CDNs, static assets)
6. Write `endpoints.json` to the working folder
7. Write a skeleton `monkey.js` to the working folder

## Step 1: Pre-flight Check

Before injecting, confirm:
- The user is logged into the target site (auth must be ambient — no credentials needed in code)
- There is a working folder available to save output files
- The browser tab is on the correct domain

Ask the user to navigate to the most data-rich page of the site (e.g., their dashboard, a content editor, a list view) before injection. The richer the page, the more calls get captured.

## Step 2: Inject the Intercept Script

Use `browser_evaluate` with this script on the target tab:

```javascript
(function() {
  if (window.__apiSniffer) return 'already active';
  window.__apiSniffer = true;
  window.__capturedRequests = [];
  const _origFetch = window.fetch;
  window.fetch = async function(...args) {
    const req = new Request(...args);
    const entry = { type: 'fetch', url: req.url, method: req.method, headers: Object.fromEntries(req.headers.entries()), timestamp: Date.now() };
    try {
      const res = await _origFetch.apply(this, args);
      const clone = res.clone();
      entry.status = res.status;
      entry.resHeaders = Object.fromEntries(res.headers.entries());
      try { const text = await clone.text(); entry.bodyLength = text.length; if (text.length < 50000) { try { entry.json = JSON.parse(text); } catch { entry.bodyPreview = text.slice(0, 500); } } } catch {}
      window.__capturedRequests.push(entry);
      return res;
    } catch (e) { entry.error = e.message; window.__capturedRequests.push(entry); throw e; }
  };
  const _origOpen = XMLHttpRequest.prototype.open;
  const _origSend = XMLHttpRequest.prototype.send;
  const _origSetHeader = XMLHttpRequest.prototype.setRequestHeader;
  XMLHttpRequest.prototype.open = function(method, url, ...rest) {
    this.__capture = { type: 'xhr', method, url: new URL(url, location.href).href, headers: {}, timestamp: Date.now() };
    return _origOpen.call(this, method, url, ...rest);
  };
  XMLHttpRequest.prototype.setRequestHeader = function(name, value) {
    if (this.__capture) this.__capture.headers[name] = value;
    return _origSetHeader.call(this, name, value);
  };
  XMLHttpRequest.prototype.send = function(body) {
    if (this.__capture) {
      this.__capture.requestBody = typeof body === 'string' && body.length < 5000 ? body : undefined;
      this.addEventListener('load', () => {
        this.__capture.status = this.status;
        this.__capture.bodyLength = (this.responseText || '').length;
        if (this.responseText && this.responseText.length < 50000) { try { this.__capture.json = JSON.parse(this.responseText); } catch { this.__capture.bodyPreview = this.responseText.slice(0, 500); } }
        window.__capturedRequests.push(this.__capture);
      });
    }
    return _origSend.call(this, body);
  };
  return 'sniffer active';
})();
```

Confirm the script returns `'sniffer active'`.

## Step 3: Trigger Network Activity

After injection, interact with the page to surface API calls. For each action, wait 2–3 seconds:

1. Wait 3 seconds for auto-loaded calls
2. Scroll to 50% of the page
3. Wait 2 seconds
4. Scroll to bottom
5. Wait 2 seconds
6. Click any tabs, dropdowns, "load more" buttons, or navigation items visible
7. If there's a search bar, type a short query
8. Wait 2 seconds

For content creation apps (Substack, Notion, etc.), also:
- Open a content editor or creation modal
- Type a few characters (triggers autosave/draft APIs)
- Wait 3 seconds

## Step 4: Harvest

Run this via `browser_evaluate` to count captures:

```javascript
JSON.stringify(window.__capturedRequests.length + ' requests captured');
```

Then run the full harvest and filter:

```javascript
(function() {
  var BASE = location.origin;
  var NOISE = ['google-analytics.com','googletagmanager.com','facebook.net','doubleclick.net','googlesyndication.com','analytics.','tracking.','pixel.','beacon.','sentry.io','hotjar.com','segment.com','mixpanel.com','amplitude.com','fullstory.com','clarity.ms','newrelic.com','datadoghq.com','intercom.io','crisp.chat','drift.com','hubspot.com','cdn.','fonts.googleapis.com','fonts.gstatic.com','unpkg.com','cdnjs.cloudflare.com','ads.','adservice.','recaptcha.','gstatic.com','accounts.google.com'];
  var EXTS = ['.js','.css','.png','.jpg','.jpeg','.gif','.svg','.ico','.woff','.woff2','.ttf','.eot','.map','.webp'];
  function bad(u) { var l=u.toLowerCase(); if(NOISE.some(function(d){return l.indexOf(d)>-1})) return true; try{var p=new URL(u).pathname; if(EXTS.some(function(e){return p.endsWith(e)})) return true;}catch(e){} return false; }
  function norm(u) { try{var o=new URL(u,BASE); var s=o.pathname.split('/').map(function(x){if(/^[0-9a-f]{8,}$/i.test(x))return':id';if(/^\d{3,}$/.test(x))return':id';if(/^[0-9a-f]{8}-/.test(x))return':uuid';return x;}); return o.origin+s.join('/');}catch(e){return u;} }
  function shape(o) { if(Array.isArray(o)) return {type:'array',len:o.length,keys:o[0]?Object.keys(o[0]).slice(0,15):[]}; if(o&&typeof o==='object'){var k=Object.keys(o).slice(0,20),s={};k.forEach(function(x){var v=o[x];s[x]=Array.isArray(v)?'array['+v.length+']':v&&typeof v==='object'?'object':typeof v;});return s;} return typeof o; }
  var raw=window.__capturedRequests||[];
  var api=raw.filter(function(r){return !bad(r.url);});
  var seen={}, out=[];
  api.forEach(function(r){var k=r.method+' '+norm(r.url);if(!seen[k]){seen[k]=1;out.push({method:r.method,url:r.url,normalized:norm(r.url),status:r.status,type:r.type,hasJson:!!r.json,bodyLength:r.bodyLength,responseShape:r.json?shape(r.json):null,bodyPreview:r.bodyPreview||null});}});
  return JSON.stringify({total_raw:raw.length,filtered:api.length,unique:out.length,base:BASE,endpoints:out},null,2);
})();
```

## Step 5: Write Output Files

### endpoints.json

Write to `[working-folder]/[site-name]/endpoints.json`. Format:

```json
{
  "site": "example.com",
  "base_url": "https://example.com",
  "sniffed_at": "2026-02-26T00:00:00Z",
  "total_raw": 42,
  "filtered": 18,
  "unique": 11,
  "endpoints": [
    {
      "method": "GET",
      "url": "https://example.com/api/v1/posts",
      "normalized": "https://example.com/api/v1/posts",
      "status": 200,
      "type": "fetch",
      "hasJson": true,
      "responseShape": { "posts": "array[10]", "total": "number" },
      "notes": "List endpoint — returns paginated posts"
    }
  ]
}
```

Add a `notes` field to each endpoint summarizing what it appears to do based on the URL pattern and response shape.

### monkey.js (skeleton)

Write a skeleton `monkey.js` to `[working-folder]/[site-name]/monkey.js`. This is a template — real function bodies are filled in after the first successful Replay run. See `references/monkey-js-template.md` for the exact format.

The skeleton should include:
- One commented-out function stub per interesting endpoint
- The `callAPI` base helper (always included)
- A header comment with the site name and sniff date

## Step 6: Report to User

Show a clean summary table:

```
Site: example.com
Sniffed: 42 raw → 18 relevant → 11 unique endpoints

METHOD  PATTERN                        STATUS  TYPE    NOTES
GET     /api/v1/posts                  200     fetch   List posts (paginated)
POST    /api/v1/posts                  201     fetch   Create post
PUT     /api/v1/drafts/:id             200     fetch   Update draft
GET     /api/v1/user/profile           200     fetch   Current user info
GET     /api/v1/publications/:id/...   200     fetch   Publication config

Files saved to your working folder:
  [site-name]/endpoints.json  — full API surface map
  [site-name]/monkey.js       — ready for Replay phase
```

Then prompt the user:

> "Want to try automating something right now? Tell me what you want to do on [site] and I'll use these endpoints to do it directly."

## Tips

- **Authenticated pages only** — The sniffer captures calls the logged-in user's session makes. If the user isn't logged in, the API map will be sparse.
- **Run twice** — A second pass after page interaction captures calls missed in the first pass due to race conditions.
- **Content editors are goldmines** — Opening a draft or document editor typically triggers autosave calls, which reveal the most useful write endpoints.
- **GraphQL** — If you see a single `POST /graphql` endpoint repeatedly, the site uses GraphQL. Document the operation names from the request bodies instead of URL patterns.

## Security Notes

- Never log or store captured auth tokens (Authorization headers, cookie values) in `endpoints.json` or `monkey.js`
- If captured headers contain API keys or tokens, warn the user and strip them from the output
- `monkey.js` uses `credentials: "include"` — auth is always via browser session, never hardcoded