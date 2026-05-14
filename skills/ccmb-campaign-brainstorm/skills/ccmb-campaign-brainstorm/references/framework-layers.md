# The 5 framework layers (workshop mode walks these in order)

The campaign anatomy from the digital-marketing framework, adapted for CCMB-native MarTech.

## Layer 1 — Strategic Foundation (4-5 questions)

The "bones." What success looks like, who you're talking to, what you can spend.

- **Goal**: SMART statement. The agent applies the 5-check on capture.
- **KPIs**: 3-5 measurable numbers with declared sources.
- **Audience**: persona name, size estimate (weekly reachable), platforms they live on.
- **Budget**: total + allocation across channels (ads / tools / contingency).

✓ Checkpoint: agent restates the strategic frame and asks: *"Drift-check: does this feel like a real plan or wishful thinking?"*

## Layer 2 — Content & Assets (3-4 questions)

The "meat." The actual things shipped to the audience.

- **Offer**: what's being launched, price, what's included, billing cadence.
- **Hook / messaging pillars**: 3-5 talking points. The take, not the topic.
- **Proof points**: testimonials, case studies, results — what gets cited across assets.
- **Asset checklist**: LP, magnet, emails, social, video. Each tagged with status + owner skill.

✓ Checkpoint: agent shows asset → owner-skill map, surfaces what's `needs_build` vs `existing` vs `planned`.

## Layer 3 — Channel Strategy (2-3 questions)

The "channels." Where the content meets the audience.

- **Channel mix**: which platforms, with role per platform (primary / amplifier / long-form-proof).
- **Cadence**: posting rhythm per channel.
- **Audience-platform match**: why these channels for THIS persona.

✓ Checkpoint: agent shows the channel calendar shape (rough weekly cadence across the launch window).

## Layer 4 — Execution (Claude-native MarTech) (2-3 questions)

The "nervous system." How the campaign actually fires.

- **claude_stack**: which CCMB skills + MCPs + schedulers run this. Detection-first per `martech-native-map.md`.
- **Schedulers**: Vercel Cron, Inngest, or manual.
- **Data sources**: where KPIs are read from.
- **Remarketing segments** (optional): who didn't convert, what re-engages them.

✓ Checkpoint: agent shows the full Claude-native MarTech stack and confirms nothing was missed.

## Layer 5 — Risk & Mitigation (1-2 questions)

The pre-mortem.

- **Audience objections**: top 3 reasons your target persona says no.
- **Execution risks**: top 3 things that could derail the plan.
- **Drift-check date**: when to re-read this brief mid-campaign.

✓ Final checkpoint: full brief preview. Save? Edit? Abort?

## Notes for the agent

- Smart mode skips a layer's questions whose answers are already in context. Workshop mode walks all 5.
- Each layer's checkpoint is a hard stop. Student can break out anytime — partial brief saves with `status: draft`.
- Layer 5 risks: if student blanks, agent draws from `common-risks.md` and asks for confirmation/replacement.
