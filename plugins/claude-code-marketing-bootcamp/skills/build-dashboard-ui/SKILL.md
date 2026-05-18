---
name: build-dashboard-ui
description: Use when /api/metrics exists and you need a dashboard page that renders those numbers in the user's own design system, not a generic template. Third step of marketing-dashboard-kit. Each bootcamp student's dashboard must look like THEIR brand. Triggers - "build the dashboard page", "dashboard UI", "make it match my design", "render the metrics".
---

# Build Dashboard UI

## Overview

The dashboard is a **dumb renderer**: static HTML with `data-k` hooks, one `fetch('/api/metrics')`, and a tiny script that fills the hooks. Zero numbers in the markup. The hard part is not the rendering — it's making it look like *this user's brand*, not a generic SaaS template. Every bootcamp student gets a dashboard in their own design language.

Core principle: **Detect the existing design system and inherit it. The dashboard is a new page in an existing site, not a new product.**

**REQUIRED BACKGROUND:** The contract is defined by `dashboard-data-layer` (see its `references/metrics-contract.md`). If a `frontend-design` skill is available, its detect→match discipline applies here directly.

## Step 1: Detect the design system (do not skip)

Before writing a line of dashboard HTML, find what the site already uses. Look for, in order:

1. A tokens file — `colors_and_type.css`, `theme.css`, `tailwind.config.*`, CSS custom properties (`--color-*`, `--font-*`, `--s-*`)
2. The existing landing page / app — open it, read its `<style>`, note: fonts, accent color, surface colors, border radius, spacing rhythm, dark vs light
3. Component conventions — how are cards, labels, numbers styled? Is there an eyebrow/mono-caps motif? A serif/mono pairing?

Write a one-line **visual thesis** capturing it, e.g. *"Dark scholarly: parchment-on-near-black, Crimson Pro serif numerals, IBM Plex Mono caps labels, oxblood accent, hairline rules, no card chrome."* Every dashboard decision flows from that thesis. If no system exists, ask the user for their brand or pick one deliberately — never default to generic Inter-on-white cards.

## Step 2: Compose, don't decorate

Dashboard-specific composition rules (these override generic instincts):

- **Numbers carry the page.** The metric value is the largest type on each tile, in the brand's display font. Labels are small mono/caps. This is the single highest-leverage move for "looks designed."
- **Cardless by default.** A funnel is a row of values separated by hairlines, not six floating cards. Use a card only when the unit is interactive.
- **One accent, used for state.** Live = accent/success dot. Pending = muted/warning dot. Don't rainbow the dashboard.
- **Honest empty state.** `null` → `—` in muted color. Never a fake number, never `0` when you mean "no data." A `—` with a "pending" source dot is more trustworthy than a plausible lie.
- **Source provenance is visible.** Every section header carries a small "source · status" line that flips live/pending from the contract's `sources` block.

## Step 3: The renderer

The asset [assets/dashboard-template.html](assets/dashboard-template.html) is a complete, working, brand-neutral dashboard. Adapt it: replace the token block with the detected design system, keep the `data-k` wiring and the fetch logic.

The wiring contract:

```html
<!-- Bind any element to a contract key. Trailing .pct span / .bar div are preserved. -->
<div class="n" data-k="quiz_completes">—</div>
<span class="pct" data-k="complete_rate">—</span>
```

```js
const fmt = (n, t='int') =>
  n == null || Number.isNaN(n) ? '—'
  : t === 'pct1' ? (Math.round(n*1000)/10).toFixed(1)+'%'
  : new Intl.NumberFormat('en-US').format(Math.round(n));

const setText = (k, v) => document.querySelectorAll(`[data-k="${k}"]`).forEach(el => {
  const first = el.firstChild;
  if (first && first.nodeType === Node.TEXT_NODE) first.nodeValue = v + ' ';
  else el.insertBefore(document.createTextNode(v + ' '), el.firstChild);  // keep child .pct/.bar
  if (v !== '—') el.classList.remove('muted');
});

const r = await fetch('/api/metrics', { credentials: 'same-origin' });
if (r.status === 401) { location = '/login'; }     // gate handles the rest
const d = await r.json();
setText('quiz_completes', fmt(d.funnel.quiz_completes));
setText('complete_rate', d.funnel.complete_rate != null ? fmt(d.funnel.complete_rate,'pct1') : '—');
// ...iterate d.emails, set source dots from d.sources
```

**Why text-node surgery instead of `innerHTML = v`:** tiles often contain a trailing `.pct` span and a `.bar` mini-chart. Replacing `innerHTML` nukes them. Replacing only the leading text node preserves structure. This was a real bug; the helper above is the fix.

## Step 4: Verify visually

Screenshot the rendered dashboard. Check against the visual thesis: does it read as the same brand as the landing page? Are numbers the dominant element? Is every `—` paired with a pending dot? One pass, fix glaring issues, move on. If the metrics endpoint isn't deployed yet, load the template with a stubbed JSON to verify layout.

## Common mistakes

- **Skipping design-system detection** → generic dashboard that doesn't match the student's brand. The #1 failure for this skill.
- **`innerHTML = value`** wiping `.pct`/`.bar` children. Use the text-node setter.
- **Rendering `0` for missing data.** `null → —`. Always.
- **Cards everywhere.** Funnels and stat strips are cardless; hairlines and scale do the work.
- **No source dots.** Provenance is a feature, not clutter — it's what makes the dashboard trustworthy.
- **Not handling `401`.** The fetch must redirect to `/login` so an expired session doesn't render an empty dashboard.

## Next in the chain

Hand off to **deploy-gated-site** — it puts `/login`, the Edge Middleware gate, and the password in front of this page and ships it.
