---
description: Build and deploy a landing/sales page (offer → copy → design → images → live URL)
argument-hint: "[optional: product name, or the phase to jump to]"
---

Run the **Landing Page Builder**.

Invoke the `landing-page` skill and follow it exactly. Run Preflight silently,
then go phase by phase: Offer Stack → Copywriting → Design → Images → Deploy.
One phase at a time, with approval gates — never generate the whole page and
deploy without sign-off.

If the user passed arguments, treat them as the product name or the phase to
jump to; otherwise begin at Preflight and create `landing-page-brief.md`.

User input: $ARGUMENTS
