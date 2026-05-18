# PATTERNS — Process patterns and artifact specs

Load this for Phases 4-7.

## AI-pattern cleanse checklist (Phase 4)

Call the separate `ai-hunter` skill for the full audit. This is the fast
pre-check so you don't hand it obviously dirty copy:

- **Em-dashes**: zero. Search `—`, `–`, and spaced-hyphen-as-dash. Replace
  with period, comma, parens, or restructure. Non-negotiable.
- **Negative parallelism**: repeated "it's not X, it's Y" / "Not A. Not B. C."
  This is the deepest AI tell. One isolated negative is fine; the *pattern*
  repeated is the kill. Restructure to direct assertion.
- **Rule-of-three staccato**: three short parallel fragments. "Their
  literature. Their science. Their dreams." Collapse to two, or to prose
  with an Oxford list inside one sentence.
- **Throat-clearing openers**: "Here's the thing", "I'll be straight with
  you", "The truth is". Replace the canned phrase, keep the function (e.g.
  "A confession, then an ask").
- **Formulaic hooks**: "Most people", "Nobody talks about". Soften to a
  specific observation.
- **Flat rhythm**: 3+ consecutive similar-length sentences. Vary.

Target: not 100/100. Target = "does not read as AI" while preserving the
brand's literary register. B+ that is *grounded* beats A that lies.

## Grounding pass (Phase 5 — the differentiator)

The lesson this skill exists to teach: **voice-clean + AI-clean ≠ correct.**

Procedure:

1. Open the Phase 1 source-of-truth artifact (quiz JSON, product spec, etc.).
2. Extract the canonical list of every category / archetype / feature / claim
   the product actually makes.
3. Diff the copy against it:
   - Every named thing in the copy exists in the artifact ✔
   - If the product sorts people into N buckets, the copy treats **all N** as
     the strong form of a real position. No bucket is the rhetorical loser. ✔
   - Every number is verifiable or flagged with a pre-send check ✔
   - Every implied prior event is true at send time or carries a
     soften-for-first-wave note ✔
4. Any failure → rewrite the copy to match the artifact, not the other way.
5. Record a `revision_note` in frontmatter when a draft changed because of
   this pass, so the correction is not silently lost.

Real failure this caught: an email scored B+ on ai-hunter, was voice-perfect,
and invented a 3-group framing when the quiz returned 5 archetypes — and the
collapse quietly positioned 2 of 5 reader-types as the wrong answer.

## The HOLD pattern (Phase 6)

Content requiring real-world data is never faked to look finished.

A HOLD file has:

- Filename ends `-HOLD` (e.g. `email-4-day-12-HOLD.md`) so status is
  unmissable in a file listing
- Frontmatter `status: HOLD — DO NOT LOAD` and a `hold_reason`
- A loud `> **DO NOT SEND.**` banner at the top of the body
- The **structural beats preserved** (the email's job in the sequence, as a
  list) so the rewrite is a fill-in, not a redraft
- A **capture roadmap**: exactly what real data to collect, from where, with
  what permission, to fill the shell
- A **replacement workflow**: numbered steps ending in "rename off `-HOLD`,
  re-run ai-hunter, then load"

The placeholder body uses bracketed `[REAL X GOES HERE: ...]` slots, never
plausible-looking fiction. Fiction in a placeholder is how fabricated
content ships by accident.

## Companion artifact specs (Phase 7)

### Notes-capture template

Per-conversation file `YYYY-MM-DD-firstname-initial-archetype.md`. Frontmatter:
date, first name, archetype, dimension scores, format (sync/async), duration,
`attribution_permission`, `follow_up_permission`, `publishable_for`. Body
sections: context (2 lines max), their result, **the moment** (verbatim where
possible), surrounding context, the micro-shift (observation not
interpretation), quotes with `green/yellow/red` publish-readiness flags,
**disagreements I had with them** (feeds the transcript library), what I
learned, follow-up actions, archetype temptation noted.

The disagreements section is mandatory and load-bearing: the future
sample-transcript library needs honest disagreement to prove the conversation
is not adversarial.

### Sample-transcript spec

A transcript qualifies only if ALL hold: written permission at the chosen
attribution level; a genuine unsmoothed disagreement; interviewee finished
feeling heard; thorough anonymization where requested; disagreement is on
substance not tone. Linked from prep-doc Section 0, which stays inactive
until the first qualifying transcript exists. Activation = one edit.

### Measurement spec (SPEC ONLY — do not build the dashboard)

`dashboard-notes.md` format:

- Primary conversion events table (with weights — a booked call and an async
  reply can both be full conversions)
- Per-email metrics list (delivered/opened/clicked/replied/unsubscribed)
- Sequence-level metrics (opt-ins in, exits by reason, overall conversion,
  time-to-conversion, email-of-conversion, drop-off heatmap, share rate)
- Benchmark targets table tuned for warm-lead research recruitment (NOT
  generic lead-nurture numbers)
- A/B test register: id, email, variable, A, B, primary metric, min sample,
  status. Block any test that needs an honest number until the number exists.
- Instrumentation needs, suppression/counting rules, open questions,
  explicit out-of-scope list

## File / packaging conventions (Phase 8)

- One email per file, `email-N-day-N.md`, HOLD files keep `-HOLD`
- `README.md` with a status table: # | file | day | status | notes — so load
  order and HOLD state are obvious without opening files
- Companion artifacts in their own dirs (`interviews/`, root `dashboard-notes.md`)
- KIT setup notes per file: trigger, personalization tokens, exit condition
- Nothing auto-sends. The bundle is load-ready, not live.
