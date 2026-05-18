# Lead Magnet — Copy-Paste Patterns

Extracted from the Disciple AI `quickstart.html` build (PR #2). Adapt token
names to the host site; the structure is what matters.

---

## §1. Print-safe inversion

The host brand is dark-on-color. To print without bricking ink: white canvas,
accents preserved on **thin strokes and text only**, never background fills.

```css
/* Override the dark tokens locally — keep the SAME font vars from the
   linked design-system file, only remap surface/ink/accents. */
:root{
  --bg:#FFFFFF; --ink:#1A1613; --ink-2:#2B241E; --ink-3:#5A4E44;
  --rule:#D9CFC0; --ox:#6E2019; --gilt:#B08A3E;   /* accents = identity */
}
html,body{background:var(--bg);} body{color:var(--ink);}

@page{ size:letter; margin:0.6in 0.7in; }

@media print{
  html,body{background:#FFFFFF;}
  body{font-size:11pt;line-height:1.45;}
  .page{padding:0;max-width:none;}

  /* Strip web-only chrome from the printed copy */
  .welcome,.print-btn,.next-up{display:none;}

  /* Don't split reference rows / cards across pages */
  .section,.card,.glossary-row{break-inside:avoid-page;page-break-inside:avoid;}
  h2{break-after:avoid;page-break-after:avoid;}

  a{color:var(--ink);text-decoration:none;}

  /* Cheap inkjets render bright accents as muddy washes.
     Darken them ~15% so they print as crisp ribbons. */
  .eyebrow,.section-num,.label{color:#7A5E2A;}      /* gilt → deeper */
  h1 em,h2 em,.prompt::before{color:#5A1A14;}        /* oxblood → deeper */
}
```

Key moves:
- Remap **surfaces and ink**, not fonts — fonts come from the linked token file.
- `display:none` the welcome strip, print button, and "what's next" so paper
  copies start at the title and end at the colophon.
- `break-inside:avoid-page` on any list/card the reader scans as a unit.
- Darken accents only inside `@media print` — screen keeps the true brand hue.

---

## §2. Fire-and-redirect form (no backend)

For a **code-native landing page** (in-repo, not a Kit-hosted page). One form:
POST to the email provider — it handles the subscription + confirm email
server-side — then redirect to the asset. We can't read a `no-cors` response
and don't need to; the side effect is server-side.

This pattern is provider-agnostic. Get the exact `action` URL + hidden fields
from the provider's own embed/HTML export, then drop in the handler below.

**Kit (ConvertKit) — canonical.** In Kit: Grow → Landing Pages & Forms →
your form → **Embed → HTML**. Copy the `action` (looks like
`https://app.kit.com/forms/<FORM_ID>/subscriptions`) and any hidden fields.

```html
<!-- KIT (canonical) -->
<form class="signup" id="signup-form"
      action="https://app.kit.com/forms/FORM_ID/subscriptions"
      method="POST" target="_blank">  <!-- target = no-JS fallback -->
  <input type="email" name="email_address" required aria-label="Email address">
  <!-- paste Kit's hidden fields from the embed export here -->
  <button type="submit" id="signup-submit">Send the guide →</button>
</form>
```

> Note Kit's email field is `name="email_address"` (not `email`). Match
> whatever the embed export uses — update the handler's selector accordingly.

**Substack — adapter (Disciple AI).** Same handler, swap the form:

```html
<!-- SUBSTACK (adapter) -->
<form class="signup" id="signup-form"
      action="https://YOURPUB.substack.com/api/v1/free?nojs=true"
      method="POST" target="_blank">
  <input type="email" name="email" required aria-label="Email address">
  <!-- substack hidden fields (first_url, source, …) -->
  <button type="submit" id="signup-submit">Send the guide →</button>
</form>
```

```javascript
(function(){
  var form = document.getElementById('signup-form');
  if(!form) return;
  form.addEventListener('submit', function(e){
    // Kit: input[name="email_address"]; Substack: input[name="email"]
    var email = form.querySelector('input[type="email"]');
    if(!email || !email.value) return;        // let native validation fire
    e.preventDefault();
    form.removeAttribute('target');           // JS is taking over now
    var btn = document.getElementById('signup-submit');
    if(btn){ btn.disabled = true; btn.textContent = 'Sending…'; }
    var go = function(){ window.location.href = '/quickstart.html'; };
    // no-cors: opaque response, but the signup + confirm email still fire.
    fetch(form.action, { method:'POST', mode:'no-cors',
                         body:new FormData(form) })
      .then(go).catch(go);                    // redirect either way
  });
})();
```

Why it works:
- `mode:'no-cors'` + `FormData` body = a "simple request", no CORS preflight.
- `.then(go).catch(go)` — visitor never strands on a spinner.
- `target="_blank"` stays in markup; only removed once JS confirms control, so
  JS-off visitors still subscribe (provider opens in a new tab).

Provider note: **Kit is canonical.** The norm in the Launch System playbook is
a Kit-hosted landing page + Visual Automation (no code) — use that when there's
no repo to deploy. This code-native pattern is the acceleration for when the
asset lives in a repo we ship (Vercel etc.). Substack/Beehiiv/Mailchimp are
adapters: same handler, swap `action` + hidden fields from their embed export.

---

## §3. Vercel route + cache

Match whatever convention is already in `vercel.json`.

```json
{
  "rewrites": [
    { "source": "/quickstart", "destination": "/quickstart.html" }
  ],
  "headers": [
    { "source": "/quickstart(.*)",
      "headers": [
        { "key": "Cache-Control", "value": "public, max-age=300, must-revalidate" }
      ] }
  ]
}
```

---

## §4. Memory entry template

Save the pairing so it's never re-derived:

```markdown
---
name: <Project> lead-magnet pairing
description: <asset>.html is the post-opt-in delivery asset for <page>.html.
type: project
---

- `<page>.html` — landing page; opt-in form POSTs to <provider> then
  redirects to `<asset>.html`.
- `<asset>.html` — the lead magnet / thank-you asset. <one line on content>.

Why: the opt-in promises <X>. Provider handles email; this asset is what
they see/print once in. Edits to either must keep the promise true on both.
```
