> **SUPERSEDED 2026-08-20 (same day, later).** The build order now lives in `planning/PRD-growth-engine-v1.md`, which folds in four rounds of decisions this file predates: paid GHL/Apollo/Claude plans, the official GHL MCP confirmed to carry `socialmediaposting_create-post`, 3 snapshots (track+model) instead of 6, and the Windows-first POSIX-sh floor. Keep this file as the research record; execute from the PRD.

# Atlanta → Glitch standard: the verified gap analysis and build plan

**Date:** 2026-08-20 · **Baseline:** Atlanta `413b436` vs Glitch `130489f`
**Method:** full read of both repos + 3 live web-research agents (GHL, Apollo, Claude plugin platform) + 5 system-design agents + 3 adversarial verifiers (feasibility / scope / correctness). 11 agents, all findings cross-checked; every integration claim below carries its confidence.
**Location note:** this file lives in `planning/`, which `scripts/validate.sh` does not lint (it scans README, `docs/`, `plugins/` only).

---

## 0. Where Atlanta stands against the Glitch bar

| Dimension | Glitch | Atlanta today |
|---|---|---|
| Size | ~112k Python + 156k test LOC | 1,739 lines, all markdown + 2 shell scripts |
| Determinism split | 200 modules do gather/validate/write | **Zero** — every behavior is model-trusted prose |
| State | Schema'd vault, 67-table DB, snapshot-undo, one writer per file | Flat files in `./growth-engine/`, no schema, no undo, folder-scatter is the known #1 failure |
| Integrations | Real APIs, preview-then-confirm | **None** — GHL = a CSV a human uploads; Apollo = filters a human types |
| Verification | 6,595 tests; doctor verifies with evidence | `validate.sh` lints the **repo** well; nothing verifies a **founder's install or state** |
| Governance | No LICENSE, no CI (ever) | **LICENSE + CI present — Atlanta already beats Glitch here** |
| Judgment quality | A | A — the prompt-ware is genuinely good (policy walls, `first_line` naming discipline, honest gates) |

**Verdict:** the *judgment* is already at Glitch standard; the *machinery* (determinism, state discipline, verification, integration) is at zero. All four of your target systems currently end at a human-does-the-last-mile boundary. Total designed work to close it: ~56 build items ≈ 62.5 maintainer-days raw, **~25–30 days after the merges and cuts below**.

---

## 1. The three research facts that change the plan

### 1.1 GHL has an official MCP server — but the $97 plan may not reach it
- Official HighLevel MCP: `https://services.leadconnectorhq.com/mcp/anthropic/v2` — unified toolset (`search_operations` / `execute_operation` …) spanning Contacts, **Conversations & Messages (read AND send, IG/FB DM types)**, **Social Planner**, Calendars, Opportunities, Payments, Invoices. **Not** workflows (read-only scope only — no workflow write API exists), **not** snapshots (no programmatic import at all; share link = manual browser click). *(high confidence, official docs)*
- Full Social Media Posting API v2 exists: `POST /social-media-posting/:locationId/posts` with draft/scheduled status, per-platform detail objects, plus a CSV-upload API. Auth: sub-account access token **or Private Integration Token (PIT)** with `socialplanner/*` scopes. *(high confidence)*
- **THE binding constraint:** GHL's pricing page puts "Basic API Access" on the **$297 Unlimited** plan. The programme mandates $97 Starter. Whether Settings → Private Integrations exists on Starter is **officially unconfirmed** — the single most important unknown in this whole plan.
- **The likely way out (test in the spike):** Oneday presumably operates the **agency** account (the snapshot-clinic model already implies it). PITs can be created at **agency level** (up to 5) and location-scoped; the agency's plan carries the API entitlement, founders' $97 buys the sub-account. If that holds, the Starter gate is irrelevant — the agency issues each founder's token. If it doesn't hold, the choice is $297/founder (dead on cost ceiling) or agency-mediated everything.
- Meta policy: replying inside the **user-initiated 24-hour window** is compliant (promotional allowed); `HUMAN_AGENT` extends to 7 days but must be genuinely manual. Comment-to-DM = user-initiated = sanctioned. *(high confidence)*
- Social Planner CSV: max 90 posts/file, public image URLs only; **exact header row only obtainable from the in-app template** — the current skill's invented columns (`content/platform/scheduled_date/media_note`) will fail a real import.

### 1.2 Apollo solved itself — an official MCP AND an official Claude plugin exist
- Official remote MCP: `https://mcp.apollo.io/mcp`, **OAuth (no API key)**, all plans **including free** ("for a limited time" per the Feb 2026 PR — a perishable fact to re-verify in September). ~58 actions: people/company search, enrichment, contact CRUD, **sequence create/update, add-contacts-to-sequence, send via connected Gmail**, analytics. *(high confidence)*
- Apollo ships its own Claude plugin (`apolloio/apollo-mcp-plugin` — `/apollo:prospect`, `/apollo:sequence-load`, …). Decision: use their **MCP endpoint** inside our plugin's `.mcp.json` as primary (one marketplace, one install), document their plugin as fallback only. Two marketplaces doubles install failure modes for this audience.
- Free-plan fault lines the design must absorb: **(a)** free accounts on a *personal* email cannot use search/enrichment → PRE-WORK must say "sign up with your work email"; **(b)** people search costs 0 credits but returns **no emails** — enrichment credits reveal them; **(c)** custom fields (the `{{first_line}}` variable) are **plan-gated** → the free rung personalises touch 1 by writing the full message per contact instead; **(d)** free = **Gmail-only** mailbox connect — which lands exactly on the existing skill's Google/M365 split. The M365 manual route stays first-class, unchanged.

### 1.3 The Claude plugin platform can carry Glitch-grade machinery — with two unknowns
- Plugins bundle: skills, commands, agents, **hooks** (30+ events), **MCP servers (stdio + remote HTTP/OAuth)**, scripts, `bin/`; `${CLAUDE_PLUGIN_ROOT}` resolves to the install dir; **`${CLAUDE_PLUGIN_DATA}` survives updates**. *(high confidence, official docs)*
- Cowork officially supports plugins fully; **hooks run in Cowork** (not in plain chat). Cowork sessions run inside an **Ubuntu VM** — third-party teardown reports Python 3.10, Node 22, git preinstalled. So deterministic Python *is* plausible on the founder surface — but that's *reported, not official*: **gate every Python-dependent item on one rehearsal check** (`python3 --version` via the Bash tool in a real Cowork session).
- `userConfig sensitive:true` fields (masked prompt → OS keychain → `${user_config.KEY}` into MCP headers) are documented **for Claude Code; unconfirmed in Cowork**. Until confirmed, **OAuth is the only founder-facing credential path in Cowork**; a PIT pasted into chat persists in conversation history — treat as a hazard, never instruct it.
- Desktop/Cowork plugin store and Claude Code CLI store are **separate installs** — the README's "install once, works in both" is wrong and must be corrected.
- Open platform unknowns to spike: Cowork VM **egress allowlist** (Jan 2026 teardown saw pypi/npm/anthropic only — would block script-side `curl` to GHL/Apollo; MCP calls go through the client, so they cross regardless); whether `/reload-plugins` and `/mcp` exist in Cowork at all (PRE-WORK already references them!); **Windows Home has no Hyper-V → some founders may be unable to run Cowork, full stop** — the install rehearsal must cover Windows and the fallback story.

---

## 2. The decision you have to make first

**Event toolkit or product?** Your four target systems are product-shaped: refill engines first fire in late October, reply-triage and the ops-brain memory loop only pay off with continued use. The event needs a fraction of this. The verifiers' calendar math is blunt: **62.5 designed pre-Sept-4 days against ~11 working days is 5.7× overcommitted** — but the GHL clinic is **23 September**, so *nothing GHL-facing is used by any founder before then*. That creates a legitimate second lane.

**Recommendation:** commit to the product fork explicitly, and ship in three honest lanes:

| Lane | Deadline | Contents |
|---|---|---|
| **A — pre-work ship** | 4 Sept | The spike, Apollo wiring, install/setup truth, CI hardening. What 130 founders install must be bulletproof; integrations they don't touch until the 23rd can wait |
| **B — event week** | 22 Sept (clinic 23rd) | GHL connect + publish + DM inbox + snapshots, dress-rehearsed, delivered as a plugin update at the clinic |
| **C — product** | Oct+ | The ops brain proper, refill engines, tuning loops — what makes it Glitch-like |

---

## 3. Lane A — ship by 4 Sept (~11 working days; reserve 2 for release + support)

**A1 · THE spike (1.5–2d, start immediately, decision gate 28 Aug).** Three designs independently budgeted this — merged to one. Buy/borrow **one real $97 Starter sub-account** (+ the agency view) and **one free work-email Apollo account**; answer with recorded evidence in ONE findings doc (`planning/spike-findings.md`):
- GHL: PIT on Starter? **Agency-issued location-scoped PIT** (the way out)? MCP v2 exposes Social Planner *writes* or reads only? IG/FB DM **send** at MCP layer? `{{custom_values.x}}` rendering inside workflow **DM** sends? `scheduleDate` timezone semantics? Exact in-app CSV header row (pin as fixture)? Documented rate limits + the 429 shape?
- Apollo: OAuth prompt appears in **Cowork** for a plugin-bundled remote MCP? Sequence create on free? **Standard merge vars (`{{contact.first_name}}`) render in free auto-email touches?** (assumed by the current shipped skill and never verified)
- Platform: `python3` from the Bash tool in Cowork? Egress allowlist? `/reload-plugins`, `/mcp` exist in Cowork? **Two remote MCPs in one plugin** prompting correctly? Windows + Hyper-V check.

**A2 · Apollo lane (2.5–3d).** `.mcp.json` with the official Apollo remote entry (0.5d). Rewrite `outreach-b2b` around a **capability probe + degradation ladder** — rung 0 = today's manual route kept verbatim; rung 1 = free MCP (search → 35 → cut to 25 → enrich → paused sequence → founder-approved enroll; full-text touch 1, standard merge vars on touches 2–5 *if the spike confirms rendering*); rung 2 = paid custom-field path, post-event polish (2d). **Preview-then-confirm before anything is created or enrolled; never require paid.** Rehearse the send flow end-to-end twice on the real account before ship (1d, only if the rewrite ships).

**A3 · PRE-WORK edits (0.5d, ship regardless of everything else).** Work-email Apollo signup + Gmail connect instructions (founders can't retro-create accounts at the event); correct the **two-store install truth** (desktop store ≠ CLI store — "install where you'll work"); desktop Plugins UI becomes the one primary path; Windows/Hyper-V note.

**A4 · Install & setup truth (3–4d).**
- **folder-story-unify (1d):** strip `.claude/skills` + `commands` out of the Launchhouse zip — it's a guaranteed version-skew against the plugin and its desktop loading was never verified. The zip becomes the *working-folder kit* only (READ-ME-FIRST, CLAUDE.md, pre-created `growth-engine/`). CI guard: the zip must contain no skills.
- **setup v2 — verify, don't assert (1.5–2d):** plugin proof (read `${CLAUDE_PLUGIN_ROOT}/.claude-plugin/plugin.json`), folder proof (**write probe**: create/read-back/delete a canary in `growth-engine/`), version currency (via the client's fetch, never script-side curl — egress), then a written **receipt** (`growth-engine/.setup-receipt.md`). Pre-work mode STOPS after proving ("we build the rest in Session 1").
- **CI hardening (1–1.5d, one merged item — four designs grew `validate.sh` independently):** run the official `claude plugin validate` in CI; zip-contents guard; version-agreement checks already present stay.
- **Clean-machine install rehearsal (1d):** fresh Mac + fresh Windows, desktop store path, evidence recorded. This is the "prove the real experience" step for the thing 130 people touch first.

**Cut line if the calendar bites (in cut order):** A2 rehearsal → A2 rewrite (ship wiring + docs only, rewrite in Lane B) → setup receipt (keep the write probe). The spike and A3 are never cut.

---

## 4. Lane B — event week, ready before the 23 Sept clinic (~12–14d, spike-gated)

- **B1 · ONE `/growth-engine:connect` skill (2d).** The verifiers found *three* GHL connect flows with *two* secret-storage conventions across the designs — build **one**, OAuth-primary in Cowork; agency-issued PIT as the administered path (mentors at the clinic), never pasted into chat. One storage convention, decided by the spike's userConfig answer.
- **B2 · Snapshots become real (3–4d, GHL-UI work — delegable to a mentor).** Build the six snapshots in the agency account with every founder-facing message as a namespaced custom value (`{{custom_values.lh_c2d_auto_dm_1}}`) — copy becomes data. Publish the share links (all six are TODO today; CI: zero TODOs in `assets/ghl/README.md` before a release tag). Rewire `audience-b2c` Step 5 / `ghl-workflows` Step 3 to emit key→copy tables against the snapshot's copy map (1d).
- **B3 · `ghl-publish` (3d).** Read approved posts → deterministic scheduler → **preview → one yes per batch → post via MCP/API → read-back verify** (status per post recorded). CSV export against the **pinned real header row** stays as the universal fallback (1d, decoupled from any state engine).
- **B4 · `dm-inbox` (3–3.5d).** The Glitch `/email` posture ported: read real IG/FB conversations via MCP → triage → **draft-only replies in the founder's voice → founder approves each send** → `dm_gate.py` (stdlib, window math + append-only ledger) enforces the 24-hour user-initiated window deterministically. **No autonomous send exists.** Python-gated on the spike's Cowork check; if python fails, drafts-only ships and the send step is manual-in-GHL.
- **B5 · Dress rehearsal + re-verification sweep (1d, w/c 15 Sept).** Full founder journey on the clean account; re-run the perishable facts (CSV headers, Apollo "limited time" OAuth, MCP catalogs).
- **Fast-follow path:** auto-update is OFF for third-party marketplaces — document the "update now" drill (one Slack message + `/growth-engine:update`) and rehearse it once. A broken 4 Sept release with no drilled update path is near-unrecoverable with 130 installs.

---

## 5. Lane C — the product fork (Oct+): the actual Glitch-like brain (~15–18d)

- **State contract:** `growth-engine/.state/` (HOME anchor kills folder-scatter deterministically), schema'd files, **one writer per file**, snapshot-before-overwrite + `/undo` (skill-called scripts primary; hooks as the belt once Cowork hook-liveness is proven — the verifier inverted the original design's primacy, correctly).
- **Memory loop:** `ops-log.md` (append-only, dated `decision|result|blocker` entries — the digest analogue) → weekly review ritual → refill engines read it (content anti-repeat, list refresh). This is the self-linking spine; without it "refill mode" is a ritual, not an engine.
- **Content state ledger** (`content_state.py`, stdlib): approved/scheduled/published/failed per post; stats read-back (`socialplanner/statistics`) weights the next batch by what performed instead of "most proof".
- **Reply triage** ("check my outreach"): sequence stats + replies into chat, stop-on-reply *verified*, drafts for the founder to send.
- **flow-tuner:** keyword-flow metrics from real conversation data → proposed copy changes → (if the spike confirmed custom-values write) preview-then-confirm push, previous values snapshotted.
- **Founder expansion contract:** `growth-engine/extensions/` + `my-data/` reserved namespaces plugin updates never touch — how a founder takes it further without breaking updates (the Glitch `_local/` pattern).
- **Doctor that verifies** with evidence; CHANGELOG + version surface; userConfig credential migration once Cowork support is confirmed; media-lane posting (verify the Media Library endpoint first — it appears in no research fact).

---

## 6. Policy walls — carried forward unchanged, now enforced not just stated

1. **No automated cold IG DMs, ever** (the 25 are sent by hand; the automation is inbound-only) — now also enforced by `dm_gate.py`'s window math.
2. **Cold email never through GHL** — GHL is CRM + publisher; Apollo/manual is the cold sender.
3. **Never require paid Apollo** — the ladder degrades to free and then to manual, both first-class.
4. **Draft-only replies** — no send without the founder's yes, same as Glitch's email brain.
5. **No invented proof/numbers** — unchanged.
6. **Per-batch approval on all publishing** — no autonomous posting loop.

**Do-not-build (verified):** community GHL/Apollo MCP servers (unofficial code holding live tokens); a GHL marketplace OAuth app (weeks of review lead time); any hosted backend/webhook receiver/daemon; snapshot-import automation (no API exists); a second marketplace as the primary Apollo path; SQLite/vector-RAG in the plugin (no guaranteed runtime — the ops brain uses files + stdlib, which is the right-sized Glitch pattern here).

---

## 7. Cost & risk register

| Risk | Exposure | Mitigation |
|---|---|---|
| PIT unavailable on $97 Starter **and** agency-issued PIT fails | Lanes B GHL items collapse to CSV/manual | Spike answers by 28 Aug; CSV path is ship-ready regardless |
| Apollo all-plans OAuth is "limited time" and ends | Rung 1 collapses to rung 0 (manual) | Rung 0 stays first-class; re-verify w/c 15 Sept |
| Cowork VM lacks python / egress blocks scripts | dm_gate + ledgers degrade | Every python item spike-gated; MCP calls cross regardless (client-side) |
| Windows Home founders can't run Cowork | Install support spike | Rehearsal covers Windows; desktop-chat + Claude Code fallback documented |
| One maintainer, 15 days, plus event logistics | Over-commitment | The three-lane triage above IS the mitigation; cut lines named |

---

## 8. How far, in one sentence each

- **Content→GHL:** one spike + ~5 days from real (Lane B); the CSV path becomes correct (real headers) in Lane A.
- **Outbound B2B via Apollo MCP:** *closest of the four* — official MCP + OAuth means ~3 days to a working free-plan ladder in Lane A.
- **Inbound content→DM:** ~6 days in Lane B, policy-safe by construction (draft-only, window-gated), gated on one MCP capability check.
- **Ops brain like Glitch:** the real product work — ~15–18 days in Lane C; the pattern ports (files + stdlib + one-writer + snapshot-undo + append-only log), the heavy machinery (SQLite/RAG/hooks-as-enforcement) deliberately does not.
- **Friendlier install:** Lane A makes the desktop store the one path, the zip a pure working-folder kit, and setup something that *proves* itself with a receipt — that plus the clean-machine rehearsal is the whole answer.
