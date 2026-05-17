#!/usr/bin/env python3
"""Read npm registry JSON from stdin + OFFSET_DAYS env, print the latest version
published more than OFFSET_DAYS ago. Empty output if none found."""
import json, sys, os
from datetime import datetime, timezone, timedelta

data = json.loads(sys.stdin.read())
offset = int(os.environ.get("OFFSET_DAYS", "14"))
cutoff = datetime.now(timezone.utc) - timedelta(days=offset)

safe = []
for v, t in data.get("time", {}).items():
    if v in ("created", "modified"):
        continue
    try:
        dt = datetime.fromisoformat(t.replace("Z", "+00:00"))
        if dt < cutoff:
            safe.append((v, dt))
    except Exception:
        pass

if safe:
    safe.sort(key=lambda x: x[1], reverse=True)
    print(safe[0][0])
