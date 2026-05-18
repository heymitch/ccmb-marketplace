#!/usr/bin/env python3
"""Parse npm registry JSON from stdin. Requires REQUESTED_VERSION env (may be empty for 'latest')."""
import json, sys, os
from datetime import datetime, timezone

data = json.loads(sys.stdin.read())
requested = os.environ.get("REQUESTED_VERSION", "")

times = data.get("time", {})
versions = list(data.get("versions", {}).keys())
dist_tags = data.get("dist-tags", {})

if requested:
    if requested not in versions:
        print("ERR=version-not-found")
        sys.exit(0)
    resolved = requested
else:
    resolved = dist_tags.get("latest", versions[-1] if versions else "")

publish_iso = times.get(resolved, "")
if not publish_iso:
    print("ERR=no-publish-date")
    sys.exit(0)

publish_dt = datetime.fromisoformat(publish_iso.replace("Z", "+00:00"))
age_days = (datetime.now(timezone.utc) - publish_dt).days

maint = data.get("maintainers", [])
maint_name = maint[0].get("name", "unknown") if maint else "unknown"

print(f"RESOLVED={resolved}")
print(f"PUBLISH_DATE={publish_iso[:10]}")
print(f"AGE_DAYS={age_days}")
print(f"MAINTAINER={maint_name}")
print(f"VERSION_COUNT={len(versions)}")
