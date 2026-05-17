---
description: Build a research-grade email nurture sequence that converts lead-magnet opt-ins into booked 1:1 conversations, plus interview-prep and measurement-spec artifacts.
argument-hint: "[goal + audience, e.g. 'nurture quiz opt-ins to 1:1 interviews about their results']"
---

Invoke the `email-nurture` skill to build a nurture sequence.

User request: $ARGUMENTS

Follow the skill workflow in order. Do not skip:

- **Phase 0** — Genre-lock preflight. Pick the arc: research-nurture
  (conversation CTA) or Ship 30 FOMO sales (purchase CTA). Produce the 5-line
  summary naming the arc and confirm before drafting.
- **Phase 1** — Gather inputs, especially the file path to the product's
  source-of-truth artifact (quiz JSON / product spec). If none exists, flag
  every product claim as unverified.
- **Phase 5** — Grounding pass. Diff every product claim against the artifact.
  This is mandatory, not optional.
- **Phase 6** — HOLD any email needing a real anecdote or verifiable count.
  Never fabricate to look finished.
- **Phase 7** — Produce the arc-appropriate companion artifacts unless the
  user opts out (research-nurture: conversation-prep, notes-capture,
  transcript-spec, measurement-spec; FOMO: offer/proof inventory,
  post-purchase onboarding stub, measurement-spec).

For the FOMO arc, draft from the verbatim skeletons in
`assets/fomo-email-templates.md` — fill brackets only, never reword. Refine
all subject lines against the 5 rules in `references/fomo-campaign.md`.

Ship KIT-ready markdown with a README status table. Nothing auto-sends.
