---
description: Build a Free Tool — an ungameable lead-magnet mini-app (quiz, calculator, assessment, or diagnostic) with a tiered opt-in funnel, on top of the lead-magnet skill's storage.
argument-hint: "[tool type + purpose, e.g. 'readiness assessment for SaaS founders']"
---

Invoke the **free-tool-builder** skill to design and build a Free Tool.

User request: $ARGUMENTS

Before doing anything, confirm the prerequisite and scope:

1. **Storage prerequisite** — the lead-magnet skill must have run first
   (Supabase + SQL storage + base funnel). If storage doesn't exist, stop
   and direct the user to run the lead-magnet skill.
2. **Inherit the design system** — detect the workspace's existing design
   tokens and consume them. Do NOT create a design system or re-declare
   `:root` tokens.
3. Follow the `free-tool-builder` SKILL.md workflow in order. Load
   `PLAYBOOK.md` for scoring/funnel design (steps 2–5, 9) and `PATTERNS.md`
   for code patterns (steps 6–10).

Honor the Ungameable Law: every option attractive within its tier; grade the
pattern, not the answers. Ship copy as flagged stubs for separate voice
review. Finish with a live end-to-end smoke test.
