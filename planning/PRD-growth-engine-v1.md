# PRD — Oneday Growth Engine v1.0 ("Glitch-grade")

**Date:** 2026-08-20 · **Repo:** `Philm-moxywolf/Atlanta` at `413b436` · **Supersedes:** `planning/glitch-standard-plan-2026-08-20.md`
**Audience of this document:** the Claude session opened in this repo (the "executor"), plus Philip for the ⚑HUMAN tasks.
**Verbatim vs SPEC:** content in a fenced block marked **VERBATIM** is copied exactly. Content marked **SPEC** is written by the executor to the stated requirements and must pass the task's acceptance check. Nothing else is discretionary.

---

# PART ZERO — the execution contract

The executor works through Part Three task by task, **in order**, under these rules. They are not suggestions.

1. **One task, one commit.** Finish a task, run its ACCEPT block, then commit with the task's commit message. Never batch tasks into one commit. Never commit with a failing ACCEPT.
2. **Validate before every commit:** `bash scripts/validate.sh` must pass (0 FAILs). If a task legitimately changes what validate checks, the same task updates validate.sh — checks and code move in the same commit.
3. **Acceptance is evidence, not assertion.** Every ACCEPT block is runnable. Run it, show the output. "It should work" is a failed acceptance.
4. **Stop-and-ask conditions.** Stop and ask Philip when: an ACCEPT fails twice; a step requires an account, token, or GHL/Apollo UI action (⚑HUMAN); external behavior contradicts `planning/spike-findings.md`; or a policy wall (§1.4) would be touched. Otherwise do not stop to ask.
5. **The spike file is the source of truth for external behavior.** No API field, header, tool name, or CSV column may be invented. If it isn't in `planning/spike-findings.md` or this PRD's verbatim blocks, it doesn't exist yet — add a spike question instead of guessing.
6. **Policy walls are immutable** (§1.4). No task, founder request, or "improvement" overrides them.
7. **Comment discipline (code):** every script opens with the header template in §2.6; comments explain **why**, not what; no clever one-liners; plain names. POSIX sh only for anything that runs on a founder machine — no bashisms, no python, no node, no jq (§2.2).
8. **Doc discipline:** long markdown is written one sentence per physical line (diff-precision, same rule as Glitch). Founder-facing text is plain, unhurried, one next action at a time — never a list of six.
9. **Version discipline:** `plugin.json` + `marketplace.json` versions move together (validate.sh already pins this). Every released version gets a CHANGELOG entry. Dev = 0.2.x; freeze on 4 Sept = **1.0.0**; event-week lane = **1.1.0**.
10. **Scope discipline:** anything not in this PRD is post-event backlog (`planning/backlog.md`), not a detour.

---

# PART ONE — product definition

## 1.1 What this is

The **Oneday Growth Engine**: a Claude plugin that gives ~130 non-technical founders a growth system with a persistent operations brain — built to Glitch's engineering standard, usable and maintainable **by the founders themselves**, from Claude Cowork **or** Claude Code, on macOS **or** Windows.

Four systems:

| # | System | End state |
|---|---|---|
| 1 | **Content** | Claude generates 30 on-voice pieces, the founder approves, and posts are **scheduled into GHL Social Planner through the official GHL MCP** with read-back verification. CSV bulk upload remains the fallback. |
| 2 | **Outbound B2B** | ICP → live Apollo people search → 35 built, cut to 25 → enriched → contacts created → sequence with `{{first_line}}` per-contact personalisation → enrolled **paused** → founder activates. Via the official Apollo MCP (OAuth). M365 founders keep the manual route as a first-class path. |
| 3 | **Inbound (content→DM)** | Comment-to-DM automation runs in GHL (snapshot). Claude **reads real inbound IG/FB conversations through the GHL MCP, drafts on-voice replies, and sends only on the founder's yes, only inside Meta's 24-hour user-initiated window** — enforced by code, not prose. |
| 4 | **The brain** | A persistent, schema'd, reversible state layer in the founder's own folder: one writer per file, snapshot-before-overwrite + undo, append-only ops log, derived rebuildable index, a doctor that proves instead of asserts. POSIX sh — runs on every supported machine with zero installed runtime. |

## 1.2 Locked decisions (from Philip, 2026-08-20)

| Decision | Consequence |
|---|---|
| **Apollo paid plan** | Custom fields available → `{{first_line}}` works as designed. No free-tier degradation ladder. Work-email signup still advised. |
| **GHL paid plan with API access** | PITs available. The $97-plan question is moot. |
| **Claude paid plan** | Given (plugins require paid). |
| **GHL transport = the official MCP** | `https://services.leadconnectorhq.com/mcp/` — 36 named tools including `socialmediaposting_create-post` (confirmed from GHL's own MCP docs). Auth = PIT + locationId headers. OAuth "planned", not current. REST v2 stays the documented backstop only. |
| **3 snapshots, not 6** | `b2b-core`, `b2c-service-core`, `b2c-ecom-core`. Selection by **track + model**, automatic — the bottleneck diagnostic now orders which workflow's copy gets written first, it no longer picks the snapshot. |
| **3 sessions, weekly** | S1 w/c 7 Sep · S2 w/c 14 Sep · S3 w/c 21 Sep · clinic 23 Sep · event 25–27 Sep. Repo structure is correct as-is. |
| **Windows is first-class** | Windows Home has no Hyper-V → no Cowork for that slice → desktop **Code tab** (requires Git for Windows → Git Bash present). Sets the runtime floor: **POSIX sh, no python/node/jq on founder machines.** State files are line-oriented, never JSON. All API calls go through **remote MCP** (client-side HTTPS — no local runtime, no egress-allowlist exposure). |

## 1.3 The quality bar (what "same as Glitch" means, operationally)

1. **Determinism split** — sh scripts gather/validate/write; the model reasons only where judgment is genuine (voice, copy, triage).
2. **Schema'd state, one writer** — every machine-read file has a documented format and exactly one writer (`ge`). Skills never hand-edit state.
3. **Reversible autonomous writes** — snapshot-before-overwrite; if the snapshot fails, the write does not happen. `/undo` exists.
4. **Verify, don't assert** — the doctor runs checks and prints evidence; setup produces a receipt; publishes are read back.
5. **Every error carries its recovery** — no founder-visible failure without a "→ do this next" line.
6. **Deliberate failure posture** — enforcement scripts fail **closed** on the undo path, **open** on convenience paths (context injection, lint), and each script's header states which.
7. **Claims pinned by CI** — versions agree, headers match fixtures, the zip carries no skills, scripts parse, golden tests pass on ubuntu + macOS + windows runners.
8. **Cross-OS by construction** — BSD/GNU `date` split handled once in `ge`; CI runs the founder floor on all three OS runners.

## 1.4 Policy walls (immutable)

1. **No automated cold IG/FB DMs, ever.** The 25 openers are sent by hand. Automation is inbound-only.
2. **DM replies are draft-only** — sent one at a time on the founder's explicit yes, only inside the 24-hour user-initiated window, enforced by `ge dmgate`. **Never** use or suggest the `HUMAN_AGENT` tag from code.
3. **Cold email never goes through GHL.** GHL = CRM + publisher + inbound. Apollo (or the founder's own mailbox) = the cold sender.
4. **Sequences enroll PAUSED.** Activation is the founder's act. Stop-on-reply is confirmed, not assumed.
5. **No invented proof, numbers, customers, or outcomes.** Thin proof is named in Flags, never papered over.
6. **Per-batch human approval on all publishing.** No autonomous posting loop.
7. **An opt-out line in every cold-email touch.** (Existing rule, kept.)
8. **Apollo data is never used to train models** (Apollo ToS) — onboarding tells the founder to confirm training is off in their Claude privacy settings; Apollo-derived data stays in their own files/workflows.
9. **Secrets never enter chat.** A PIT is typed into a masked prompt or a local file — never pasted into the conversation. Skills never echo token values.

## 1.5 Non-goals / do-not-build (verified dead ends)

- A GHL **marketplace OAuth app** (weeks of review; PIT is the sanctioned internal-tool path).
- **Community** GHL/Apollo MCP servers (unofficial code holding live tokens).
- A **hosted proxy/backend/webhook receiver** — the official MCP made it unnecessary; nothing Oneday must keep running.
- **Workflow/snapshot write automation** — no API exists (`workflows.readonly` only; snapshot import is a manual share-link click).
- A **local stdio MCP server** — needs a runtime the Windows floor doesn't have.
- **SQLite / vector RAG** in the plugin — the brain is files + sh, deliberately.
- A second marketplace as the Apollo path (their plugin is a documented fallback only; two marketplaces double install failure modes).
- Autonomous loops of any kind (auto-send, reply-watchers, schedulers) — the MCP is a synchronous doorway; everything runs in-session with the founder present.

---

# PART TWO — target architecture

## 2.1 Component map

```
Philm-moxywolf/Atlanta  (marketplace "launchhouse")
└── plugins/growth-engine/
    ├── .claude-plugin/plugin.json      versions, userConfig (GHL PIT + locationId)
    ├── .mcp.json                       remote MCP: ghl (PIT headers) + apollo (OAuth)
    ├── hooks/hooks.json                SessionStart → ge context   (belt, fail-open)
    ├── bin/ge                          the brain CLI, on PATH while plugin enabled
    ├── scripts/ge.sh                   implementation (POSIX sh; bin/ge execs it)
    ├── scripts/lib/*.sh                date-compat, paths, table helpers
    ├── skills/                         12 skills (9 existing reworked + 3 new)
    │     setup · founder-brain · content-engine · ghl-publish(NEW)
    │     dm-inbox(NEW) · connect(NEW) · outreach-b2b · audience-b2c
    │     ghl-workflows · growth-plan · playbook-export · status
    ├── commands/                       thin routers (+ connect · publish · inbox · update · undo)
    ├── schemas/*.md                    the state contracts (human-readable, CI-linted)
    └── assets/
          ghl/social-planner-template.csv   the REAL header row (spike fixture)
          ghl/snapshots/{b2b-core,b2c-service-core,b2c-ecom-core}.md   copy maps
          examples/{b2b-northfield,b2c-lumen,b2c-ecom-…}/              3 worked examples
tests/run.sh + tests/fixtures/          golden tests for ge (run on 3 OS runners)
docs/PRE-WORK.md · docs/CONNECTIONS.md  founder docs
CLAUDE.md                               contributor working agreements (this repo)
CHANGELOG.md
```

## 2.2 The runtime floor (why every founder machine works)

| Config | Surface | Shell | API transport |
|---|---|---|---|
| macOS + Cowork | plugin full (skills, hooks, MCP) | VM sh | remote MCP via client |
| macOS + Code tab | plugin full | /bin/sh | remote MCP via client |
| Windows Pro/Ent + Cowork | plugin full | VM sh | remote MCP via client |
| **Windows Home + Code tab** | plugin full (Git for Windows required — PRE-WORK step) | **Git Bash sh** | remote MCP via client |

**Floor = POSIX sh.** Therefore: no JSON state (no jq) — line-oriented formats only; no python/node on founder paths; MCP calls are made by the Claude client itself (host-side HTTPS), so the Cowork VM egress allowlist is irrelevant to integrations.

## 2.3 The state model (the brain)

Everything lives in the founder's working folder. Founder-facing files stay readable markdown; machine state sits under `.state/`.

```
growth-engine/
├── founder-brain.md          the locked record (v2: + Model field)
├── content-30.md             the 30 pieces, numbered, grouped by pillar
├── content-30.csv            fallback export (real GHL headers)
├── ledger.md                 machine state of every piece + outreach rows  [writer: ge ledger]
├── ops-log.md                append-only decisions/results/blockers        [writer: ge log]
├── rss-feeds.md · hook-bank.md · dm-openers.md · inbound-scripts.md
├── outreach-sequence.md · ops-workflow.md · 90-day-plan.md · playbook-insert.md
└── .state/
    ├── HOME                  one line: the anchored absolute path            [writer: ge init]
    ├── index.md              derived gate/status table — rebuildable        [writer: ge index]
    ├── receipt.md            setup receipt with evidence                    [writer: setup skill via ge]
    ├── ghl-accounts.md       cached socialmediaposting_get-account result   [writer: connect skill via ge]
    └── snapshots/            byte-exact undo ring, last 10 per file         [writer: ge snapshot]
```

**Formats (schemas/ carries one file per format; CI lints examples against them):**

- `HOME` — exactly one line, an absolute path.
- `ledger.md` — after a fixed header comment, one row per line, `|`-delimited:
  `C|<id>|<pillar#>|<format>|<lane text|media>|<status draft|approved|scheduled|posted|failed|archived>|<ghl_post_id|->|<scheduled_for|->`
  `O|<email>|<first_name>|<company>|<status candidate|cut|contacted_ok|enrolled|replied|stopped>|<first_line y|n>`
- `ops-log.md` — `## YYYY-MM-DD` day headers; entries `- HH:MM <decision|result|blocker|note>: <text>`. Append-only by construction (`ge log` only ever appends; the doctor flags a shrunken file).
- `index.md` — fixed table `| file | gate | status | bytes | modified |`, `status ∈ missing|empty|ok`.

**Rules:** one writer per file (the `ge` subcommand named above); every skill snapshot-first (`ge snapshot <file>`) before overwriting any founder file; if the snapshot fails the skill **stops** (fail-closed undo, Glitch's `snapshot_for_rewrite` posture).

## 2.4 Credentials

| System | Path | Storage |
|---|---|---|
| Apollo | **OAuth** through the client (`/mcp` in Code; connector sign-in prompt in Cowork). No key exists. | Client-managed |
| GHL | **PIT + locationId** via `plugin.json` `userConfig` (`sensitive:true`) → masked prompt at enable → OS keychain / credentials store → `${user_config.*}` substituted into `.mcp.json` headers | Keychain |
| GHL fallback (Gate A fails) | `headersHelper` sh script reading `${CLAUDE_PLUGIN_DATA}/ghl.env` (600 perms). The connect skill creates the file with a `PASTE_TOKEN_HERE` placeholder and has the founder **edit it in their own text editor** — the token never enters chat. | Plugin data dir (survives updates, outside the founder folder so it can't be zipped/shared by accident) |

PITs are static; the receipt records the creation date and the doctor warns at 80 days (GHL recommends 90-day rotation) with the reconnect flow.

## 2.5 Failure postures (chosen deliberately, stated in each script header)

| Path | Posture | Why |
|---|---|---|
| `ge snapshot` before a rewrite | **fail-closed** (no snapshot → no write) | An irreversible autonomous mistake is the worst outcome |
| SessionStart `ge context` | fail-open (missing folder → exit 0, silent) | A broken hook must never wedge a session |
| `ge lint` | warn-only exit codes; doctor surfaces | Advice, not a gate |
| `ge dmgate` | **fail-closed** (unparseable timestamp → "out of window") | Never send on uncertain policy math |
| Publish read-back | fail-loud (missing post id → row marked `failed` + recovery) | A silent half-publish is a lie in the ledger |

## 2.6 Code standards (verbatim templates)

**VERBATIM — sh script header template** (every script under `scripts/`):

```sh
#!/bin/sh
# <name> — <one line: what this does>
#
# WHY IT EXISTS: <the failure this prevents, in one or two sentences>
# CALLED BY:     <skill(s)/hook(s)/humans>
# READS:         <files/env>       WRITES: <files it is the ONE writer of>
# POSTURE:       <fail-open|fail-closed> — <one clause why>
# PORTABILITY:   POSIX sh. No bash/python/node/jq. BSD+GNU date via lib/date_compat.sh.
# EVERY ERROR MESSAGE ENDS WITH A RECOVERY LINE ("→ run: ...").
set -u
```

**VERBATIM — commit message format:** `<task-id>: <imperative summary>` body states what changed + the ACCEPT evidence in one line.

---

# PART THREE — the build, task by task

Effort in dev-days. ⚑HUMAN = Philip (accounts, GHL UI, machines). Release lane column: **1.0** (freeze 4 Sept), **1.1** (ready 19 Sept — before S3 w/c 21 Sept and the 23 Sept clinic), **1.2** (post-event).

## PHASE 0 — the spike (2.0d · ⚑HUMAN + executor · lane 1.0 · DO THIS FIRST)

> Every downstream integration task cites `planning/spike-findings.md`. Format: one `## S-0n` section per task, each finding a single sentence with a pasted-evidence block under it.

**S-01 ⚑HUMAN — accounts (0.25d).** Create/confirm: GHL paid account with API access + one test location; in Settings → Private Integrations create a PIT with exactly these scopes: `socialplanner/post.readonly`, `socialplanner/post.write`, `socialplanner/account.readonly`, `socialplanner/statistics.readonly`, `conversations.readonly`, `conversations/message.readonly`, `conversations/message.write`, `contacts.readonly`, `contacts.write`, `locations.readonly`. Record locationId. Apollo **paid** seat. A test FB Page (+ IG Business if available) connected to the test location's Social Planner.
ACCEPT: spike-findings §S-01 lists PIT-created date, scope list, locationId.

**S-02 — GHL MCP catalog (0.25d).** In Claude Code: `claude mcp add --transport http ghl-test https://services.leadconnectorhq.com/mcp/ --header "Authorization: Bearer <pit>" --header "locationId: <id>"`. List tools. Confirm the 36 named tools (esp. `socialmediaposting_create-post`, `conversations_send-a-new-message`). Also probe `/mcp/anthropic/v2`; record which endpoint yields **named** tools — that endpoint wins.
ACCEPT: findings list actual tool names + chosen endpoint.

**S-03 — social write + timezone + limits (0.5d).** Via MCP: `get-account` (capture shape → this becomes the `ghl-accounts.md` cache format); `create-post` a **draft**; `create-post` **scheduled** for a known local time tomorrow → check the GHL UI shows that local time (records the `scheduleDate` timezone semantics); `edit-post`; `get-post` read-back; delete/archive. Fire 15 rapid `get-posts` calls; record any 429 body. **Download the in-app Social Planner CSV template** and commit it verbatim as `plugins/growth-engine/assets/ghl/social-planner-template.csv`.
ACCEPT: findings state timezone rule + 429 shape; fixture file committed.

**S-04 — conversations (0.25d).** From the test IG/FB (or SMS as proxy): send an inbound message; `search-conversation` → `get-messages` → record the **exact `dateAdded` format**; `send-a-new-message` a reply within the window; confirm the IG/FB type value used.
ACCEPT: findings show a real message-shape block + the dateAdded format string.

**S-05 — Gate A: userConfig in Cowork (0.25d).** Build a throwaway plugin (5 files) with a `userConfig` `sensitive:true` field wired into an `.mcp.json` header. Install via **Cowork → Customize → Plugins**. Does a masked prompt appear and the header substitute?
DECISION GATE A: **yes** → credentials via userConfig (2.4 primary). **no** → `headersHelper` fallback becomes primary; task G2-01 branches.
ACCEPT: findings record the observed Cowork UI with a screenshot path.

**S-06 — Gate B: hooks + bin floor (0.25d).** Same throwaway plugin: `bin/ge-test` (sh) + SessionStart command hook echoing a marker. Test on: macOS Cowork, macOS Code, **Windows Home Code (Git Bash)**. Record where the hook fires and whether `ge-test` is on PATH.
DECISION GATE B: hooks fire everywhere → keep the SessionStart belt. Anywhere they don't → hooks stay shipped but the design's stated primary (skills call `ge` directly) is the only guarantee; docs never promise hook behavior.
ACCEPT: three receipts in findings.

**S-07 — Apollo paid (0.25d).** OAuth-connect in Cowork and in Code. Enumerate actions. On the paid seat: people-search 1 result; create a **contact**; create a **custom field** `first_line` (textarea, contact modality) or confirm it exists; create a test sequence (1 auto_email touch using `{{first_line}}` + opt-out line); add the test contact with `send_email_from_email_account_id` = own mailbox; confirm it lands **paused**; confirm stop-on-reply is visible/on; delete all test artifacts.
ACCEPT: findings record action names used + paused-state proof.

## PHASE 1 — groundwork (1.0d · lane 1.0)

**G-01 — root `CLAUDE.md` (0.25d).** SPEC: contributor working agreements for THIS repo: the execution contract (Part Zero, condensed), code standards (§2.6), doc discipline, "run `bash scripts/validate.sh` before every commit", pointer to this PRD and spike findings. ≤80 lines.
ACCEPT: file exists; validate.sh passes.
COMMIT: `G-01: add contributor CLAUDE.md (working agreements)`

**G-02 — `CHANGELOG.md` + version bump (0.25d).** SPEC: Keep-a-Changelog format; entry `0.2.0 — internal dev toward 1.0.0` listing this PRD. Bump both manifests to `0.2.0`.
ACCEPT: `validate.sh` version-agreement check passes.
COMMIT: `G-02: start CHANGELOG, bump to 0.2.0`

**G-03 — plugin manifests (0.5d).** Add to `plugins/growth-engine/.claude-plugin/plugin.json` (Gate A = yes):

**VERBATIM (userConfig block):**
```json
"userConfig": {
  "ghl_pit": {
    "type": "string", "sensitive": true,
    "title": "GoHighLevel Private Integration Token",
    "description": "Created in GHL: Settings > Private Integrations. Looks like pit-… Never share it."
  },
  "ghl_location_id": {
    "type": "string",
    "title": "GoHighLevel Location ID",
    "description": "Settings > Business Profile in your sub-account."
  }
}
```

Create `plugins/growth-engine/.mcp.json` — **VERBATIM** (endpoint per S-02):
```json
{
  "mcpServers": {
    "ghl": {
      "type": "http",
      "url": "https://services.leadconnectorhq.com/mcp/",
      "headers": {
        "Authorization": "Bearer ${user_config.ghl_pit}",
        "locationId": "${user_config.ghl_location_id}"
      }
    },
    "apollo": { "type": "http", "url": "https://mcp.apollo.io/mcp" }
  }
}
```

Create `hooks/hooks.json` — **VERBATIM:**
```json
{ "hooks": { "SessionStart": [ { "hooks": [ {
  "type": "command",
  "command": "sh \"${CLAUDE_PLUGIN_ROOT}/scripts/ge.sh\" context --hook",
  "timeout": 10
} ] } ] } }
```
ACCEPT: `python3 -c 'import json;json.load(open(...))'` on all three in CI-land (validate.sh); plugin still installs locally (`claude plugin validate` if available).
COMMIT: `G-03: wire GHL+Apollo MCP, userConfig, SessionStart belt`

## PHASE 2 — the brain: `ge` (5.0d · lane 1.0)

> One CLI, POSIX sh, split as `bin/ge` (3-line exec shim) → `scripts/ge.sh` (dispatcher) → `scripts/lib/*.sh`. Every subcommand: evidence output, meaningful exit codes, recovery line on every error. `tests/run.sh` grows with every task (golden fixtures under `tests/fixtures/`).

**B-01 — skeleton + lib (0.75d).** `bin/ge` shim; dispatcher with `help`; `lib/paths.sh` (`ge_find_home`: walk cwd→parents→`$HOME` for `growth-engine/.state/HOME`, compare anchor, report scatter); `lib/date_compat.sh` (GNU vs BSD `date` detection: `iso_to_epoch`, `now_epoch`, `utc_stamp`); `lib/table.sh` (index/ledger row helpers). Header template §2.6 on every file.
ACCEPT: `sh -n` all scripts; `tests/run.sh` green (help + date-compat cases incl. both date styles via fixture branch).
COMMIT: `B-01: ge skeleton, path/date/table libs`

**B-02 — `ge init` (0.5d).** Create `growth-engine/` + `.state/{HOME,snapshots/}` + seed empty founder files that don't exist; write the anchor; idempotent (re-run reports, never clobbers); prints the absolute path and "always open this folder".
ACCEPT: golden test: fresh dir → init → re-init → tree matches fixture; HOME contains the right path.
COMMIT: `B-02: ge init — the anchored working folder`

**B-03 — `ge snapshot | restore | undo` (0.75d).** `snapshot <file>`: byte copy to `.state/snapshots/<name>.<UTCstamp>`, ring of 10, **exit 1 + recovery if the copy cannot be made**. `restore <file> [stamp]` lists stamps when ambiguous, previews `diff` line-count, restores byte-exact. `undo` = restore latest across files (asks which if >1 candidate in last hour).
ACCEPT: golden: write→snapshot→mutate→undo→`cmp` original = identical; ring caps at 10; snapshot-to-unwritable-dir exits 1.
COMMIT: `B-03: snapshot ring + restore/undo (fail-closed)`

**B-04 — `ge log` (0.5d).** Append-only `ops-log.md`; day-header dedupe; types `decision|result|blocker|note`; refuses empty text; never rewrites.
ACCEPT: golden log sequence matches fixture; double-run same day = one header.
COMMIT: `B-04: ops-log, the append-only memory spine`

**B-05 — `ge ledger` (0.75d).** `add-content`, `set-content <id> <field> <value>`, `add-outreach`, `set-outreach <email> …`, `list [C|O] [--status X]`; enum validation per §2.3; every mutation snapshots `ledger.md` first (calls B-03).
ACCEPT: golden CRUD run matches fixture; invalid enum exits 1 with the allowed values in the message.
COMMIT: `B-05: the ledger — one writer for machine state`

**B-06 — `ge index` + `ge lint` (0.75d).** `index`: rebuild `.state/index.md` (file table §2.3 + gate labels — move the gate table out of `status/SKILL.md` prose into `schemas/gates.md`, single source). `lint`: brain headings/track/model enums/Locked date; ledger field counts; CSV row-count ≤90 and **header row `cmp` against the S-03 fixture**; warn-only.
ACCEPT: fixture folder with 3 seeded errors → lint names exactly those 3; index matches fixture.
COMMIT: `B-06: derived index + structural lint`

**B-07 — `ge dmgate` (0.5d).** `ge dmgate <dateAdded-ISO>` → prints `in_window yes|no`, hours since inbound, hours left; **any parse failure = out of window** (fail-closed). Uses `lib/date_compat.sh`; the ISO format is the exact S-04 finding.
ACCEPT: table of fixture timestamps (23h59m in / 24h01m out / garbage = out) passes on GNU and BSD paths.
COMMIT: `B-07: dmgate — 24h window math, fail-closed`

**B-08 — `ge context` + `ge check` (1.0d).** `context [--hook]`: ≤15 lines — anchor verdict, gate summary (from index), unresolved Flags, PIT-age warning if receipt >80d; **no folder → exit 0 silent** (fail-open). `check`: the doctor core — anchor, write-probe (create/read/delete canary in `growth-engine/`), index freshness, lint summary, snapshot-ring health, log integrity (never shrunk: compare byte count vs `.state/log.bytes` watermark), each line `PASS|FAIL — evidence → fix`.
ACCEPT: golden healthy run all-PASS; each induced failure flips exactly its line and prints a runnable fix.
COMMIT: `B-08: context injection + the evidence doctor core`

## PHASE 3 — founder-brain v2 (1.5d · lane 1.0)

**FB-01 — skill rewrite (1.0d).** SPEC deltas to `skills/founder-brain/SKILL.md`: add the **Model** question (B2C only: `service | ecommerce`, with 3 ecom intake adds — platform, AOV band, repeat-purchase share); add `- **Model:**` to the file template; media-capability flag (can they record video? feeds the content media lane); ecom flavor notes for Group 3/4; on write: `ge init` if needed → `ge snapshot founder-brain.md` → write → `ge log decision "brain locked (track=…, model=…)"` → `ge index`; the closing gate line comes from `ge index`. All existing intake craft (groups, thesis, voice paths A/B/C, Flags honesty) is kept verbatim.
ACCEPT: skill names the ge calls in order; `validate.sh` skill checks pass; manual dry-run transcript in `planning/rehearsals/fb-dryrun.md`.
COMMIT: `FB-01: founder-brain v2 — model subtype + brain-backed writes`

**FB-02 — templates + third example (0.5d).** Update the brain template block; generate `assets/examples/b2c-ecom-<name>/founder-brain.md` by running the skill as a fictional ecommerce founder (same rule as the existing two: generated, never hand-written; fictional only).
ACCEPT: example passes `ge lint`; examples README table gains the third row.
COMMIT: `FB-02: ecom example founder + template`

## PHASE 4 — content v2 (4.0d · gen+ledger+CSV = lane 1.0 · publish = lane 1.1)

**C-01 — content-engine rewire (1.5d · 1.0).** SPEC deltas: generation rules unchanged (pillars, 30, batches of 10, voice, never-invent); **ecom pillar variant** (transformation → product-led outcome, UGC/social-proof lean); on export: `ge snapshot content-30.md` → write → `ge ledger add-content` one row per piece (`lane` = `media` for any piece whose format needs an asset — reels, carousels, image captions with media_note) → `ge index`. Refill mode reads the **ledger** (never re-uses an angle whose row isn't `archived`) and archives the old batch by status, not by file rename.
ACCEPT: dry-run produces 30 ledger rows with correct lanes; refill dry-run refuses duplicate angles.
COMMIT: `C-01: content engine writes through the brain`

**C-02 — CSV export against the real template (0.5d · 1.0).** SPEC: build `content-30.csv` with **exactly** the fixture header row; scheduled_date column left blank (unchanged rule: scheduling happens at publish/clinic); `ge lint` validates on every export; the skill states the 90-row and public-media-URL limits from the fixture doc.
ACCEPT: exported CSV first line `cmp`-identical to fixture; lint green.
COMMIT: `C-02: CSV fallback pinned to GHL's real template`

**C-03 — `ghl-publish` skill + command (2.0d · **1.1**).** NEW `skills/ghl-publish/SKILL.md` + `commands/publish.md` ("publish my content", "schedule my posts"). Flow: preconditions (connect receipt exists; ledger has `approved` text-lane rows) → read `ghl-accounts.md` cache (refresh via `socialmediaposting_get-account` if stale) → propose slots (default 5/week, founder's posting days from a one-time question stored in the brain Channels block) → **preview table** (post #, first line, platform, local datetime) → founder's one yes per batch (≤10) → per row: `socialmediaposting_create-post` (accountIds, type, summary, `status:"scheduled"`, scheduleDate per S-03 timezone rule) → capture id → `get-post` read-back → `ge ledger set-content <id> status scheduled` + post id → pacing pause between calls → summary table + failures with recovery ("row 7: 429 → wait a minute, run publish again; already-scheduled rows are skipped by the ledger"). **Media-lane rows are never auto-posted:** the skill lists them with their media_note and the two roads (upload to GHL Media Library → paste the public URL → it posts; or keep them for the CSV). Draft-mode flag: "post as drafts instead" → `status:"draft"`.
ACCEPT: rehearsal against the test location — 3 text posts scheduled, read back, visible in Social Planner UI at the right local time, ledger rows updated; a forced failure (bad accountId) lands as `failed` + recovery line.
COMMIT: `C-03: publish through GHL with read-back verification`

## PHASE 5 — connect + inbound DM (3.5d · lane 1.1)

**G2-01 — `connect` skill + command (1.5d).** ONE skill, two branches. **GHL:** plain-words PIT walk (Settings → Private Integrations → the exact scope checklist from S-01, screenshots referenced from PRE-WORK) → the founder enters PIT + locationId into the **masked userConfig prompts** (Gate A yes; the skill explains where the prompt appears per surface) → verification reads: `locations_get-location` + `socialmediaposting_get-account` → write `.state/receipt.md` connect section (date, location name, account count — **never the token**) + `ghl-accounts.md` cache → `ge log result "GHL connected"`. Gate A **no** branch: create `${CLAUDE_PLUGIN_DATA}/ghl.env` containing `GHL_PIT=PASTE_TOKEN_HERE`, `chmod 600`, tell the founder to open it in TextEdit/Notepad, replace, save, say done → same verification; `.mcp.json` uses `headersHelper` instead. **Apollo:** trigger the OAuth door per surface (`/mcp` in Code; connector sign-in in Cowork) → verify by listing connected mailboxes → mailbox provider recorded in the brain Channels block (M365 → manual route stated plainly, no Apollo needed). Every failure state has a recovery line (401 → recreate PIT walk; no accounts → connect socials in GHL first).
ACCEPT: rehearsal receipts for both branches on the test accounts; token absent from every written file (grep the folder for `pit-` = only the env file in fallback mode).
COMMIT: `G2-01: one connect door — GHL PIT + Apollo OAuth, verified with reads`

**G2-02 — `dm-inbox` skill + command (1.5d).** NEW ("check my DMs", "reply to my messages"). Flow: preconditions (GHL connected; track b2c or founder asks anyway) → `conversations_search-conversation` (recent window, unread first) → per conversation `get-messages` → triage list (new lead / question / continuing thread / no-reply-needed) → for each the founder picks: draft replies **in the captured voice** → per send: `ge dmgate <last-inbound dateAdded>` → in-window + founder's yes → `conversations_send-a-new-message` → `ge log result` → out-of-window: say it plainly + the two roads (wait for their next message; or reply by hand in the GHL app — a human may, code must not). Never batch-send, never auto-approve, never HUMAN_AGENT. Session ends with a one-line summary logged.
ACCEPT: rehearsal on the test IG/FB conversation: one in-window send lands; a fabricated 25h-old fixture is refused by dmgate with the exact posture line.
COMMIT: `G2-02: dm-inbox — read, draft, window-gated send on your yes`

**G2-03 — `docs/CONNECTIONS.md` (0.5d).** SPEC, in `truly-local.md`'s register: what connects (GHL, Apollo), through what (official MCP endpoints), what is stored where (keychain / plugin data dir / receipt — and what is **never** stored), what leaves the machine when (a publish, a DM send, a sequence enroll — each only on your yes), how to disconnect and rotate, the model-training-off note (Apollo ToS). Linked from README + PRE-WORK.
ACCEPT: every claim in the file maps to a mechanism built in this PRD (executor lists the mapping in the commit body).
COMMIT: `G2-03: CONNECTIONS — the plain-words data contract`

## PHASE 6 — Apollo outbound v2 (2.5d · lane 1.1)

**A-01 — outreach-b2b rewrite (2.0d).** SPEC deltas (paid plan): keep Step 0's mailbox question but the answer now routes **Apollo-MCP vs manual** (M365 = manual, unchanged and first-class). New MCP flow after list criteria: run the three search variants live → show counts → build 35 (founder can veto rows) → cut to 25 with the founder → enrich the 25 (emails + `email_status`; unverified rows flagged, founder decides) → **create contacts** (search results must be saved as contacts before sequencing — S-07) → first lines in batches of 5 against real enriched rows → write `first_line` into the custom field → create the sequence (4–5 touches, <120 words, opt-out line in every touch, waits stated, `{{first_line}}` opens touch 1, standard merge vars elsewhere) → add the 25 with `send_email_from_email_account_id` = their connected Gmail → **verify paused** → tell the founder exactly where to press go in Apollo (or "activate it" here → one explicit yes → activate via MCP). Every row lands in the ledger (`O|` rows); deliverability brief kept verbatim; export files kept for the manual route.
ACCEPT: full rehearsal on the paid test seat to a self-owned mailbox: 2-contact sequence created paused, activated, one send observed, stop-on-reply confirmed on; ledger shows the O rows.
COMMIT: `A-01: outreach through Apollo MCP — search to paused enrollment`

**A-02 — status/gate/setup folds (0.5d).** `status` reads `ge index` + ledger counts (content by status, outreach by status) instead of bare file existence; `gate` adds DONE/NOT-DONE from ledger truth; `setup` gains the two connect checks (read receipt, never re-probe blind).
ACCEPT: status dry-run on the fixture folder matches fixture output.
COMMIT: `A-02: status and gates read the brain, not the filesystem guess`

## PHASE 7 — ops engine: 3 snapshots (2.5d · lane 1.1 · mostly ⚑HUMAN)

**O-01 ⚑HUMAN — build the 3 snapshots (1.5d, GHL UI).** In the agency account: `b2b-core` (lead follow-up · discovery booking · proposal chase), `b2c-service-core` (comment-to-DM capture · DM qualify & book · review request), `b2c-ecom-core` (comment-to-DM capture · abandoned-checkout chase · post-purchase review). **Every founder-facing message references a namespaced custom value** `{{custom_values.lh_<snapshot>_<msg>}}` — copy is data. Test-import each via share link into a clean location; record the three share links in `assets/ghl/README.md` (zero TODOs).
ACCEPT: three live share links recorded; a test import shows custom-value placeholders rendering.

**O-02 — copy maps (0.5d).** `assets/ghl/snapshots/<slug>.md` per snapshot: every `lh_*` key, where it appears (workflow/step), channel (email/SMS/DM), and length guidance. CI: keys match `^lh_[a-z0-9_]+$`, unique per file.
ACCEPT: validate.sh new check green; three files complete.
COMMIT: `O-02: snapshot copy maps — copy as data`

**O-03 — ghl-workflows v2 (0.5d).** SPEC deltas: snapshot selection = **track+model, automatic, stated in one line** ("You're B2C ecommerce, so your snapshot is b2c-ecom-core"); the bottleneck diagnostic (kept verbatim) now orders which workflow's copy is written first; output = the key→copy table per the copy map (every key filled, captured voice) + trigger/waits/exit/tags; clinic instructions reference the paste-at-clinic step; n8n escape-hatch rule kept.
ACCEPT: dry-run for each of the three model paths fills its map with zero missing keys.
COMMIT: `O-03: ops engine — model-picked snapshot, copy by contract`

## PHASE 8 — self-service (3.0d · doctor+update = 1.0 lane · reconnect = 1.1)

**SS-01 — doctor v2 (1.0d · 1.0).** `doctor` command + setup skill's diagnosis section rebuilt around **evidence**: run `ge check` and show its output verbatim; then the live legs (plugin version from `${CLAUDE_PLUGIN_ROOT}`; GHL read probe; Apollo read probe — each `PASS|FAIL → fix`); keep the two-attempts-then-Slack rule and the existing common-problems runbook (updated for v2 realities). The doctor never asserts anything it didn't just observe.
ACCEPT: transcripts for healthy + 3 induced failures (moved folder, revoked PIT, disconnected Apollo), each showing the recovery line actually given.
COMMIT: `SS-01: a doctor that proves`

**SS-02 — `update` command + drill (1.0d · 1.0).** NEW `commands/update.md` ("update the toolkit"): read installed version; fetch latest `marketplace.json` via the client's web-fetch; if behind — per-surface steps only for **their** surface (Cowork Plugins UI Update button / `/plugin marketplace update launchhouse`); show the CHANGELOG entries between; confirm receipt-and-folder are untouched by updates. `planning/update-drill.md`: the one Slack message + the S3 live drill ("everyone run update now" — rehearsed once before 4 Sept).
ACCEPT: rehearsal: install 0.2.0, release 0.2.1, run the drill, land current.
COMMIT: `SS-02: the update door + the drill`

**SS-03 — reconnect flows (1.0d · 1.1).** GHL 401 anywhere → the reconnect walk (recreate PIT, same scope list, re-enter via the same door as connect; receipt date refreshed); PIT age >80d → the doctor and `ge context` nudge with the same walk; Apollo auth failure → re-run the OAuth door. Error-catalog pass: grep every skill for founder-visible failure text; every one ends with "→".
ACCEPT: grep proof committed in the commit body (`grep -rn "fail" skills/ | <filter>` shows recovery lines); 401 rehearsal transcript.
COMMIT: `SS-03: reconnect flows + no error without a recovery`

## PHASE 9 — docs + onboarding rewrite (2.0d · lane 1.0)

**D-01 — README v2 (0.5d).** SPEC: correct the two-store truth ("install where you will work; doing both takes two installs"); prerequisites per OS/surface — **Windows box: "No terminal needed. You'll install Git for Windows once (two clicks); the Code tab needs it."**; the paid plans table (Claude, GHL paid w/ API, Apollo paid) with why each; the 12-command table with plain-language column; "what finished looks like" updated to the four systems; CONNECTIONS.md linked; pre-release banner retained until 1.0.0.
ACCEPT: validate.sh doc checks green (install-suffix, owner-url); no reference to free plans survives.
COMMIT: `D-01: README v2 — the honest install and the real product`

**D-02 — PRE-WORK v2 (0.75d).** SPEC: restructured per surface with an explicit **Windows path** (1. install Git for Windows → 2. Claude desktop → 3. Plugins UI → 4. `/growth-engine:setup`); account creation section (GHL paid + location + *"we create your token together at Session 2 — don't create it alone"*; Apollo paid seat, work email; model-training-off privacy note); the two time-critical items kept word-for-word; costs table updated (no free tiers); the one-folder rule; Slack escape hatch every section.
ACCEPT: a cold read-through by Philip (⚑HUMAN, 15 min) — every step has a screenshot slot and an "if this fails" line.
COMMIT: `D-02: PRE-WORK v2 — per-surface, Windows first-class`

**D-03 — Launchhouse folder v2 (0.5d).** `build-folder.sh`: **stop copying skills/commands into the zip** (the plugin is the sole skill carrier — kills the version-skew and the unverified desktop-folder-loading claim); the zip = READ-ME-FIRST + CLAUDE.md (rewritten: route to the *installed plugin*; if commands missing → the plugin install walk) + seeded `growth-engine/` + VERSION. validate.sh: FAIL if the zip stages `.claude/skills`.
ACCEPT: rebuilt zip contains no skills; guard red when a skill is planted, green after.
COMMIT: `D-03: the folder carries work, the plugin carries skills`

**D-04 — one-sentence-per-line + trigger sync (0.25d).** Reflow the founder-facing docs touched in this PRD; add the README⇄skills trigger-phrase sync check to validate.sh (every "Or just say" phrase appears in that skill's description triggers).
ACCEPT: validate.sh new check green.
COMMIT: `D-04: doc hygiene + trigger-map pinned`

## PHASE 10 — CI (2.0d · lane 1.0)

**CI-01 — validate.sh v2 (1.0d).** Add: `sh -n` every `scripts/**/*.sh` + `bin/ge`; shellcheck (required in CI, best-effort locally); JSON parse for `.mcp.json`/`hooks.json`/userConfig; CSV fixture header check (C-02); copy-map key lint (O-02); zip guard (D-03); trigger sync (D-04); TODO gate (`assets/ghl/README.md` zero TODOs **when version ≥1.1.0**); schemas/ examples lint via `ge lint`.
ACCEPT: all green on the repo; each new check proven red-then-green with a planted violation (list them in the commit body).
COMMIT: `CI-01: validate.sh v2 — every new claim pinned`

**CI-02 — the three-OS matrix (1.0d).** `.github/workflows/validate.yml` v2: **ubuntu** (validate.sh + shellcheck + `npm i -g @anthropic-ai/claude-code@<pinned>` + `claude plugin validate ./plugins/growth-engine` + `tests/run.sh`); **macos** (`tests/run.sh` — the BSD date leg); **windows** (`bash tests/run.sh` under Git Bash — the founder floor leg).
ACCEPT: all three jobs green on push; a planted bashism fails macos/windows.
COMMIT: `CI-02: ubuntu+macos+windows — the founder floor is CI`

## PHASE 11 — release + rehearsal (2.0d + ⚑HUMAN · lanes 1.0/1.1)

**R-01 ⚑HUMAN+executor — clean-machine rehearsal (1.0d · 1.0).** On a clean macOS (Cowork + Code) and a clean **Windows Home** (Code): PRE-WORK v2 → install → `/growth-engine:setup` (receipt!) → brain → content gen → CSV. Every friction becomes a doc fix or a task. Receipts to `planning/rehearsals/`.
**R-02 — v1.0.0 freeze (0.5d · 4 Sept).** CHANGELOG; both manifests 1.0.0; tag; PRE-WORK goes out.
**R-03 — v1.1.0 lane (0.5d + the 1.1 tasks · ready 19 Sept).** C-03, G2-01..03, A-01..02, O-01..03, SS-03 land behind the update drill; **re-verification sweep w/c 15 Sept**: re-download the CSV template (`cmp` fixture), re-probe both MCP catalogs, re-run one publish + one dmgate rehearsal. S3 opens with the live update drill.
**R-04 — backlog record (0.25d).** `planning/backlog.md`: v1.2 = stats-weighted refill (statistics MCP read → ledger perf column), flow-tuner, media-lane automation (needs the unverified media-upload endpoint — spike question recorded), extension kit (`growth-engine/extensions/` + `my-data/` reserved namespaces), monthly re-verification ritual.
COMMITs: `R-01..R-04` per above.

## Effort + calendar honesty

| Lane | Dev-days | Window | Fit |
|---|---|---|---|
| **1.0** (P0,1,2,3, C-01/02, SS-01/02, D, CI, R-01/02) | ≈ **15.5** | 20 Aug → 4 Sept ≈ 11 working days | **Over by ~4.5** → cut line, in order: SS-02 drill rehearsal→1.1 · B-07 dmgate→1.1 (not needed until DM ships) · D-04→1.1 · shellcheck local-only. With those: ≈ 12.0 — tight but real. Anything further slips, slip **C-01/02 to early 1.1** before touching P2 or docs. |
| **1.1** (C-03, G2, A, O, SS-03, R-03) | ≈ **12.0** + 1.5 ⚑HUMAN | 5 → 19 Sept ≈ 10 working days | Fits, with the sweep and drill inside it. |
| **1.2** (R-04 backlog) | ≈ 8–10 | post-event | Product fork. |

The brain (P2) and the docs/CI (P9/P10) are **never** cut — they are the Glitch quality. Features slip; the standard doesn't.

---

# PART FOUR — what done looks like (the real output)

## 4.1 The founder's arc

**Pre-work week (from 4 Sept).** Maya (B2C ecom, Windows laptop, has never opened a terminal) follows PRE-WORK: installs Git for Windows (two clicks), Claude desktop, adds the marketplace in the Plugins screen, installs growth-engine. Types `/growth-engine:setup`. It **proves** her install: plugin 1.0.0 ✓, creates `growth-engine/` on her Desktop, writes/reads/deletes a canary ✓, writes `receipt.md`, and stops: *"You're set up. We build the rest together in Session 1."*

**S1 (w/c 7 Sept).** "build my founder brain." Twenty minutes of conversation → `founder-brain.md` locked: `Track: b2c · Model: ecommerce`. The brain snapshots before every rewrite; `ops-log.md` gets its first line. Gate 1 paste comes off `ge index`, not vibes.

**S2 (w/c 14 Sept).** "build my content engine." Four pillars (ecom-flavored), 30 pieces in batches of 10, ledger rows created — 7 text-lane, 23 media-lane. At Session 2 the mentors walk PIT creation together; she enters it into a **masked prompt** — it never appears in chat. `connect` verifies with two live reads and writes the receipt.

**S3 (w/c 21 Sept).** Everyone runs `/growth-engine:update` live (the drill). Then: *"publish my content."*

```
Ready to schedule 7 text posts to: Instagram (@lumenskin), Facebook (Lumen Skin).
  #  post opens with…                     platform   when (your time)
  3  "The ingredient list is lying…"      IG+FB      Mon 29 Sep 09:30
  8  "We read 214 reviews of…"            IG+FB      Wed 1 Oct 09:30
  …
Schedule these 7? (your 23 video pieces are listed below with what each needs)
> yes
✓ 7 scheduled · 7 verified by read-back · ledger updated
✗ 0 failed
```

**The weekend.** Snapshot `b2c-ecom-core` imported at the clinic; her copy pasted from the key→copy table. Saturday she sends her 25 DMs by hand, spread out, as designed. Sunday: the 90-day plan.

**The Tuesday after.** A comment-keyword post fires; 14 DMs arrive. *"check my DMs."*

```
12 conversations, 9 in the 24-hour reply window.
1. @sofia.k — asked if the set works on sensitive skin → draft ready
2. @marcusvt — price question → draft ready
3. @jl_moss — window closed 3h ago → reply by hand in the GHL app, or wait for their next message
Send draft 1? (I'll only ever send on your yes, inside the window)
> yes
✓ sent · logged
```

Her `ops-log.md` now reads like a memory: `- 14:22 result: comment-to-DM post pulled 14 DMs, 3 booked`. When something breaks — she moved the folder — the doctor doesn't guess: `FAIL — anchor says Desktop, you're in Downloads → open the Desktop folder (full path shown)`. She fixes it herself. Nobody Slacks Philip.

## 4.2 The finished tree (delta view)

```
Atlanta/
├── CLAUDE.md CHANGELOG.md                    NEW
├── planning/{PRD…, spike-findings.md, rehearsals/, update-drill.md, backlog.md}
├── docs/{PRE-WORK.md v2, CONNECTIONS.md NEW}
├── scripts/{validate.sh v2, build-folder.sh v2}
├── tests/{run.sh, fixtures/…}                NEW  ← runs on ubuntu+macos+windows
└── plugins/growth-engine/
    ├── .claude-plugin/plugin.json            +userConfig, 1.x
    ├── .mcp.json  hooks/hooks.json           NEW
    ├── bin/ge  scripts/{ge.sh, lib/*.sh}     NEW  ← the brain, POSIX sh
    ├── schemas/{ledger.md, ops-log.md, index.md, gates.md, brain.md}   NEW
    ├── skills/  (9 reworked + ghl-publish + dm-inbox + connect)
    ├── commands/ (+connect publish inbox update undo)
    └── assets/ghl/{social-planner-template.csv, snapshots/*.md, README (3 live links)}
```

## 4.3 Sample artifacts (as they will exist)

**`growth-engine/ledger.md`** (excerpt)
```
# Ledger — one writer: ge ledger. Do not hand-edit. Format: schemas/ledger.md
C|3|1|short-post|text|scheduled|66f2a…|2026-09-29T09:30+01:00
C|11|2|reel-script|media|approved|-|-
O|sofia@brightops.co|Sofia|BrightOps|enrolled|y
```

**`growth-engine/.state/receipt.md`** (excerpt)
```
# Setup receipt — written by /growth-engine:setup · 2026-09-05
plugin      PASS  growth-engine 1.0.0 (${CLAUDE_PLUGIN_ROOT} manifest)
folder      PASS  C:\Users\maya\Desktop\growth-engine (anchor matches)
write-probe PASS  canary created, read back, deleted
ghl         PASS  location "Lumen Skin" · 2 social accounts · PIT created 2026-09-14
apollo      SKIP  b2c track — not needed
```

**`ge check` on a broken day**
```
anchor      FAIL  HOME says …\Desktop\growth-engine, cwd is …\Downloads
                  → open the Desktop folder in Claude and work there
snapshots   PASS  9 files ringed, newest 2026-09-30T08:12Z
ops-log     PASS  append-only intact (4,102 bytes ≥ watermark)
```

## 4.4 The scorecard this earns

| Dimension | Atlanta today | Done |
|---|---|---|
| Determinism split | F (all prose) | **A** — ge owns every state write |
| State & reversibility | F | **A** — schema'd, one-writer, snapshot+undo |
| Verification | C (repo lint only) | **A** — receipts, read-backs, evidence doctor, 3-OS CI |
| Integrations | F (CSV + typed filters) | **A−** — official MCPs, preview-then-confirm, policy-gated |
| Install truth | C | **A** — per-surface, Windows first-class, rehearsed on clean machines |
| Maintainable by founders | D | **A** — doctor/undo/update/reconnect, every error carries its exit |
| Governance | A (LICENSE+CI — already ahead of Glitch) | A |

*End of PRD. The executor starts at S-01.*
