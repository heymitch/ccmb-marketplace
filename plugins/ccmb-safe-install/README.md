# safe-install — the CCMB benevolent install shield

Students type `/safe-install <pkg>` (or just say "install chalk"). The plugin does the entire safety pipeline. They never edit `.npmrc`, never bump dates, never switch to the browser to paste-and-ask.

## How it works

1. **Live campaign status** — every invocation fetches `campaign-status.json` from `heymitch/ccmb-marketplace` on GitHub. Mitch controls one file; every student inherits the policy instantly.
2. **If campaign INACTIVE** — pass-through. `npm install --ignore-scripts <pkg>` and done. The shield is silent.
3. **If campaign ACTIVE** — full validation:
   - Hard-block against the `recent_compromises` list
   - Pinned-version enforcement (e.g., `vercel@39.4.0`)
   - Quarantine: refuse any version published in the last N days (default 14)
   - Surface the *last safe version* if the requested one is quarantined
   - Run install with `--ignore-scripts` (defangs lifecycle hooks regardless of `.npmrc`)
4. **Audit log** — every decision appended to `.ccmb/install-log.jsonl` per project.

## Files

```
safe-install/
├── .claude-plugin/plugin.json
├── README.md
├── skills/safe-install/SKILL.md   # the policy + orchestration
├── bin/safe-npm                    # the bash worker that does the heavy lifting
└── config/campaign-status.json    # local fallback when offline
```

## Update the campaign signal

Update the JSON at `heymitch/ccmb-marketplace/main/campaign-status.json`. Every student's shield reads it on every invocation (cached locally at `~/.cache/ccmb-safe-install/campaign-status.json` for offline fallback).

To **deactivate the shield globally**, change `campaign_active` to `false` and commit. Every install across every CCMB student goes back to silent pass-through.

To **add a hard-block** on a newly disclosed compromised version, append to `recent_compromises`. Students immediately refuse to install those versions.

To **pin a new package** (e.g., a freshly-poisoned CLI), add to `pinned_packages`. Students can only install the pinned version unless they pass `--pin-override`.

## Defense in depth

Even though `/safe-install` is the front door, three layers back it up:

1. **The skill** — student-facing UX, runs through the script
2. **`safe-npm` bash script** — runnable independently from terminal (`bash safe-npm chalk`)
3. **Project `.npmrc`** — written by `safe-setup.sh`, contains `ignore-scripts=true` and `before=<date>`. Catches anything that bypasses the skill (raw `npm install` calls Claude Code accidentally fires)

The CLAUDE.md template tells Claude Code to **always** use `/safe-install` over a raw `npm install`. If something slips through, `.npmrc` catches it.

## Usage examples

```bash
# Inside Claude Code
/safe-install chalk
/safe-install chalk@5.3.0
/safe-install --global vercel
/safe-install --dev typescript

# Natural language also works
"install playwright"
"add the openai package"
"set up the supabase CLI globally"

# From terminal (no Claude needed)
bash ~/.claude/plugins/safe-install/bin/safe-npm chalk@5.3.0
```

## Requirements

- `bash`, `curl`, `python3` (all standard)
- Network for the live status fetch (offline fallback via local cache + bundled `config/campaign-status.json`)
