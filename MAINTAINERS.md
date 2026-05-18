# Maintainers

Internal operations for the CCMB marketplace. Students never read this — see `README.md` for install-and-use docs.

## Repo layout

```
.claude-plugin/
  marketplace.json        ← marketplace manifest. ONE plugin entry.
plugins/
  claude-code-marketing-bootcamp/
    .claude-plugin/plugin.json   ← plugin manifest (name + inline hooks block)
    skills/<name>/SKILL.md       ← 24 skills, each with its own references/assets intact
    commands/skyscraper-setup.md ← the one legit command (one-time setup entrypoint)
    hooks/vibe-code-detector.sh  ← UserPromptSubmit hook (skyscraper auto-nudge)
    bin/safe-npm + bin/lib/*.py  ← auto-added to PATH when plugin enabled (safe-install)
    config/campaign-status.json  ← offline fallback for the shield
    .env.example
campaign-status.json      ← LIVE policy file for the safe-install shield (repo root)
references/vibe-editing.md
CHANGELOG.md
```

**One plugin, not ten.** The bootcamp ships as a single plugin (`claude-code-marketing-bootcamp`) with 24 skills in its `skills/` directory — the compound-engineering model. Students run two commands: add marketplace, install the one plugin. There is no `displayName` field in the plugin schema; the plugin `name` *is* the display name and skill namespace (`claude-code-marketing-bootcamp:landing-page`). `name` must be kebab-case.

## Why everything is in one plugin

Decided 2026-05-18. The expiring bonuses (Campaign Pack, Vibe Workshop) are handled separately on the landing page; the 24 skills here are "everything everyone gets." Splitting into per-session or per-bonus plugins fragmented the menu (10 entries instead of 1) and didn't match the compound-engineering single-plugin model the product targets. Voice Lab, skyscraper, safe-install, campaign-brainstorm are skills *inside* the one plugin, not separate installs.

## Plugin-root machinery (NOT skills)

Three components are plugin-root, auto-discovered when the plugin is enabled — they can't live in `skills/`:

- **`bin/`** — `safe-npm` + `bin/lib/*.py`. Claude Code auto-adds `bin/` to PATH. No manifest reference needed.
- **`hooks/vibe-code-detector.sh`** — wired via the inline `hooks` block in `plugin.json` (UserPromptSubmit, matcher `.*`). The hook command path uses **`${CLAUDE_PLUGIN_ROOT}`** — the correct variable. (The pre-consolidation skyscraper plugin used `${PLUGIN_DIR}`, which does not resolve; fixed during the merge. If the auto-nudge ever stops firing, check this variable first.)
- **`config/campaign-status.json`** — offline fallback. The live root copy wins when reachable (see below).

## The campaign-status kill-switch (for `safe-install`)

`campaign-status.json` at the repo root is the live policy file the shield reads on every invocation:

```
https://raw.githubusercontent.com/heymitch/ccmb-marketplace/main/campaign-status.json
```

```json
{ "campaign_active": true, "campaign_name": "...", "before_date_offset_days": 14,
  "pinned_packages": {"vercel": "39.4.0"}, "recent_compromises": [], "last_updated": "..." }
```

- **Deactivate globally:** flip `campaign_active` to `false`. Every student's shield becomes pass-through on next install. No emails.
- **Hard-block a compromised version:** append to `recent_compromises` (e.g. `"foo@1.2.3"`).
- **Pin a package:** add to `pinned_packages`. Override flag: `--pin-override`.

## Versioning

- Backwards-compatible fixes → straight to `main`. Students get them via `/plugin marketplace update ccmb-marketplace`.
- Breaking changes → bump `version` in `plugins/claude-code-marketing-bootcamp/.claude-plugin/plugin.json` AND the matching `marketplace.json` entry.
- Structural changes (skills added/removed) → bump `marketplace.json` `metadata.version`.

## Adding a skill

1. Drop `skills/<name>/SKILL.md` (+ its `references/`, `assets/`) into the one plugin.
2. Skill name (folder == frontmatter `name`) must be unique across all 24.
3. Add a row to the README's relevant table.
4. CHANGELOG entry. Bump plugin version if it's a breaking change.

## Release checklist

- [ ] `python3 -m json.tool .claude-plugin/marketplace.json` parses
- [ ] `python3 -m json.tool plugins/claude-code-marketing-bootcamp/.claude-plugin/plugin.json` parses
- [ ] `marketplace.json` `source` resolves to the real plugin dir
- [ ] Every skill folder still has its `references/`/`assets/` (no SKILL-only regressions on skills that had support files — see CHANGELOG 2.0.0 for the inventory)
- [ ] `hooks/vibe-code-detector.sh` is executable (`chmod +x`) and the manifest hook path uses `${CLAUDE_PLUGIN_ROOT}`
- [ ] `bin/safe-npm` is executable
- [ ] README tables match the actual skill set
- [ ] `campaign-status.json` `last_updated` current if policy changed
