---
description: Gate A and B probe. Reports what this surface actually supports.
---

Report each of these plainly, as observed, never as assumed.

1. Run `ge-test manual`. Did it run, and what did it print? If "command not found", say so: that is the Gate B answer for this surface.
2. Did a `GATE-B-MARKER mode=hook` line appear at session start, before this command was typed? That is the SessionStart hook result.
3. List the MCP servers available. Is `spike` present? Try one call against it. A 401 from GoHighLevel is the SUCCESS case here: it proves the Authorization header was substituted and sent. A malformed-header or missing-server error is the failure case.
4. State the surface you are on: Cowork, desktop Code tab, or terminal, and the operating system.

Print the four answers as a short table. Do not fix anything. This is a probe.
