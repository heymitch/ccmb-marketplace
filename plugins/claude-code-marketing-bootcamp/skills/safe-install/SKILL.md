---
name: safe-install
description: |
  Benevolent shield for installing npm packages and CLIs. Student types
  `/safe-install <pkg>` (or just says "install chalk" / "add the vercel CLI")
  and this skill handles the whole safety dance: live campaign-status check,
  publish-date quarantine, CVE lookup, maintainer rep, lifecycle-hook defang,
  pinned-package enforcement. Trigger phrases include "install", "add npm
  package", "set up CLI", "safe-install". Always prefer this over a raw
  `npm install` command.
allowed-tools: [Bash, WebFetch, WebSearch, Read, Write]
---

# safe-install — the npm/CLI shield

You are the safety layer between the student and `npm install`. Your job: when
they say "install X," verify it's safe and run the install with hardening
flags. They should never see a checklist. They see either a green confirm
("Installed `foo@1.2.3` — 3M weekly downloads, no advisories, 62 days old")
or a clean refusal ("`foo@1.2.4` was published 1 day ago — quarantined until
2026-05-27. Try `foo@1.2.3` instead.")

## Inputs

The student says one of:

- `/safe-install <pkg>` — install latest safe version
- `/safe-install <pkg>@<version>` — install specific version
- `/safe-install --global <pkg>` (or `-g`) — global install (special path)
- `/safe-install --dev <pkg>` (or `-D`) — dev dependency
- Natural language: "install chalk", "add the vercel CLI globally", "I need playwright"

Parse and normalize. If natural language, confirm the parsed package + version + scope before proceeding.

## Workflow

### 1. Fetch campaign status

`WebFetch https://raw.githubusercontent.com/heymitch/ccmb-marketplace/main/campaign-status.json`

Fall back to local copy at `${CCLAUDE_PLUGIN_ROOT}/config/campaign-status.json` if the WebFetch fails.

Parse JSON. Key fields:
- `campaign_active` (bool)
- `before_date_offset_days` (int, default 14)
- `pinned_packages` (object — e.g. `{"vercel": "39.4.0"}`)
- `recent_compromises` (array of `pkg@version` strings to hard-block)
- `notes` (string for student-facing context)

### 2. If campaign is INACTIVE

Just run `npm install <pkg>` (with appropriate flags) and exit. Print a single line: `✓ Installed <pkg>@<version> (shield dormant — campaign inactive as of <last_updated>).` No checks, no friction.

### 3. If campaign is ACTIVE — run the shield

Run the helper script for the actual work:

```bash
${CLAUDE_PLUGIN_ROOT}/bin/safe-npm <pkg>[@<version>] [--global|--dev]
```

The script does the full validation pipeline (publish date, CVE check, pinned-version check, lifecycle-hook defang) and either installs or exits non-zero with a one-line reason.

Capture its output and present it to the student verbatim — the script's messages are already tuned for student-facing display.

### 4. Special cases

**Pinned package requested:** If the package is in `pinned_packages` (e.g. `vercel`):
- If student requested the pinned version → install it
- If student requested a different version → refuse: `vercel is pinned to 39.4.0 during the campaign. Use /safe-install --pin-override vercel@<v> if you need a different version (require confirmation).`

**Hard-blocked version requested:** If `<pkg>@<version>` is in `recent_compromises`:
- Refuse with: `<pkg>@<version> is a known compromised version (May 2026 worm). Use a different version.`

**Already-installed:** If package is already in `package.json` at the requested version, skip the install but still print the validation result (so student knows it's vetted).

### 5. Log every decision

Append to `.ccmb/install-log.jsonl` (create if missing):

```json
{"ts": "2026-05-13T14:32:00Z", "pkg": "chalk", "version": "5.3.0", "scope": "local", "decision": "installed", "reason": "62 days old, 213M dl/wk, no advisories", "campaign_active": true}
```

One line per install attempt. Audit trail.

## Output formatting

**Green path:**

```
✓ Installed chalk@5.3.0
  • Published 2026-03-12 (62 days old)
  • 213M weekly downloads
  • No advisories in the last 30 days
  • Installed with --ignore-scripts (lifecycle hooks blocked)
```

**Yellow path (with confirmation):**

```
⚠ chalk@5.3.0 — passes most checks but flagged:
  • Maintainer "newuser123" account is < 6 months old
Proceed anyway? (y / N)
```

**Red path:**

```
✗ Refused: chalk@5.3.2
  • Published 1 day ago — inside 14-day quarantine window (active until 2026-05-27)
  • Try /safe-install chalk@5.3.0 (last vetted version)
```

**Campaign-inactive (silent shield):**

```
✓ Installed chalk@5.3.0 (shield dormant)
```

## Rules

- NEVER bypass the script. If a student insists, point them at `--pin-override` for the specific edge case.
- NEVER cache the campaign status for more than 1 hour — the whole point is that flipping `active: false` reverses globally.
- ALWAYS use `--ignore-scripts` on the actual npm call, even when the campaign is inactive (cheap defense in depth).
- ALWAYS log to `.ccmb/install-log.jsonl`.
- For unfamiliar/sketchy packages: prefer caution. False refusal is recoverable; false approval is not.

## When the student bypasses

If the student runs `npm install` directly anyway, the CLAUDE.md rule should catch it (Claude Code refuses to run the bare command). If Claude Code DOES run it accidentally:
- The project `.npmrc` (written by `safe-setup.sh`) still has `ignore-scripts=true` and `before=` set
- That's the third line of defense (script → CLAUDE.md → .npmrc)

But the goal is they never need that fallback. They use `/safe-install` and forget the rules exist.
