## The build, task by task

This is the revised task list under the scope locked on 20 August 2026.
It replaces Part Three of `/Users/pmudh/Documents/GitHub/Atlanta/planning/PRD-growth-engine-v1.md`.
Where a task id survives from that PRD, the id is kept so the two documents can be read side by side.
Where a task is new, it carries a new id and says why it exists.

Every path below is absolute, or is stated as relative to one of exactly two roots:

| Root | Absolute path | What it is |
|---|---|---|
| REPO | `/Users/pmudh/Documents/GitHub/Atlanta` | The public-bound product repo. Remote `https://github.com/Philm-moxywolf/Atlanta`. Marketplace name `launchhouse` |
| PRIVATE | `/Users/pmudh/Downloads/Atlanta/launchhouse-atlanta` | Client folder. Rates, mentor briefs, the gap register, the functional review, the scratch run folders. **Never** copy a file from here into REPO without reading it first |

Two source documents are referenced by task and must be open while working:

- `/Users/pmudh/Downloads/Atlanta/launchhouse-atlanta/planning/PRD-GAPS.md` : 75 verified gaps against the PRD, 4 of them blockers.
- `/Users/pmudh/Downloads/Atlanta/launchhouse-atlanta/planning/FUNCTIONAL-REVIEW.md` : 95 verified findings against the shipping toolkit. It is about 147KB. Grep it. Do not read it whole.

---

### Five conventions this document uses everywhere

Read these once. They are not repeated at each task.

**1. `⚑HUMAN` in a task heading** means the task cannot be done by the executor working alone.
It needs a live paid account, a browser session, a physical second machine, or a decision only the client can make.
Those tasks are Philip's.
Philip is the delivery owner and the account holder for the GoHighLevel agency account, the Apollo seat and the GitHub remote.
Everything without the flag is the executor's.

**2. Lane 1.0 and lane 1.1.**
Lane 1.0 is everything that must be inside the toolkit on the freeze date of Thursday 3 September 2026, because the repo goes public and the onboarding email goes out on Friday 4 September.
Lane 1.1 is everything that ships after the freeze, in an update the founders pull during the live drill at the start of Session 3.
Phases 0 to 9 of this document are lane 1.0.
Phase 10, the integration lane, is lane 1.1.
A task that says "slips to lane 1.1" means it moves from the 3 September freeze into that later update.

**3. Scratch runs live outside REPO, always.**
A scratch run is a folder where the executor plays a fictional founder and works through the commands for real.
The run script is at `/Users/pmudh/Downloads/Atlanta/launchhouse-atlanta/scripts/new-run.sh` and it writes its folders into `/Users/pmudh/Downloads/Atlanta/launchhouse-atlanta/runs/`.
It is a bash script (`#!/usr/bin/env bash`, `set -euo pipefail`, uses `BASH_SOURCE`), so invoke it with `bash`, never with `sh`.
Its argument form is fixed:

```sh
bash /Users/pmudh/Downloads/Atlanta/launchhouse-atlanta/scripts/new-run.sh <b2b|b2c|b2c-ecom|wrong-folder|fixture <name>> [label]
```

It seeds the run folder with the matching worked example's `founder-brain.md` so intake is not retyped.
The folder it creates is `/Users/pmudh/Downloads/Atlanta/launchhouse-atlanta/runs/<track>` when no label is given, and `/Users/pmudh/Downloads/Atlanta/launchhouse-atlanta/runs/<track>-<label>` when one is.
As of 21 August 2026 the script accepts `b2b`, `b2c`, `wrong-folder` and `fixture` only.
The `b2c-ecom` case does not exist yet; task FB-02 adds it, and no task before FB-02 may use it.
Nothing in this document ever creates a `runs/` folder inside REPO.
Founder-shaped output inside a public repo is a leak, and `REPO/.gitignore` does not exclude `runs/`.

**4. Rehearsal transcripts are the exception, and they go into REPO.**
A rehearsal transcript is a written receipt of what was typed and what came back.
Those live in `REPO/planning/rehearsals/`, which exists and is empty today.
They carry fictional founder material and product behaviour, never client commercials.
Read each one before committing it.

**5. Founder-facing quality bar.**
`REPO/scripts/validate.sh` is a bash script. Invoke it as `bash /Users/pmudh/Documents/GitHub/Atlanta/scripts/validate.sh`.
It treats `REPO/README.md`, everything under `REPO/docs/` and everything under `REPO/plugins/` as founder-facing, and hard-fails on an em dash, an en dash, a banned marketing word, a bare command name, or a promised reply.
It does not look at `REPO/planning/`, so nothing in that folder is style-checked.

---

### Effort under the revised scope

| Line | Dev-days |
|---|---|
| PRD Part Three as written | 31.00 |
| Less the DM inbox cut (S-04 0.25, B-07 0.5, G2-02 1.5) | **minus 2.25** |
| PRD baseline after the cut | 28.75 |
| Plus the work the gap register proved was never priced | **plus 10.45** |
| Subtotal, every task below EXCEPT B-10 and the section 04 merge | 39.20 |
| `B-10`, the memory layer (the task stub is printed below, in Phase 2) | plus 0.75 |
| The amendments B-10 makes to B-00, B-02, B-06, B-08, C-01 and SS-01 | plus 0.25 |
| Merged from section 04 Part B: `D-06`, `D-07`, `D-10`, `D-11` | plus 2.35 |
| Merged from section 04 Part A: `EX-01` to `EX-05` and `EX-11`, plus `EX-10` folded into `FB-02` | plus 2.60 |
| **Revised total** | **44.95 dev-days** |

Re-summing the task headings below gives 39.95, not 39.20, because `B-10` is printed in Phase 2 and carries its own 0.75.
The first row deliberately excludes it so the three added rows do not double-count. Full detail for `B-10` is in section 08.

Plus roughly 3.5 days of Philip's own time on the ⚑HUMAN tasks (S-01, S-02, S-03, S-05, S-06, S-07, O-01, and the clean-machine half of R-01).
That time runs alongside the executor's, it does not add to the 44.95.

The 10.45 added days are not scope creep.
They are work the PRD already assumed had happened: the schema files it points at, the `ge` subcommands two of its own state files need, the four command routers it declares twice and never builds, the approve step its publish precondition depends on, the two orphan skills that write founder files with no snapshot, and one end-to-end run of a twelve-skill chain that until now was first exercised by 130 founders on 25 September.

**What the DM inbox cut saved.** Exactly 2.25 dev-days: 0.25 for spike section S-04, 0.5 for `ge dmgate`, 1.5 for the `dm-inbox` skill and its command.
It also removed the only component that needed a live inbound Instagram or Facebook message to rehearse, which was the hardest thing in the build to test, and it removed every line of Meta 24-hour-window policy maths from code we ship.
The founder still reads and replies to DMs. They do it in the GoHighLevel app, against copy that Claude wrote into the snapshot's custom values.

---

### The cut order, kept as a record only

Cut in this order, top first.
Each line names what is lost and why the loss is survivable.
Stop as soon as the number fits.
Cuts 8 and 9 remove something that was sold, so neither happens without Philip saying yes in writing.

| # | Cut | Recovers | Why it is safe |
|---|---|---|---|
| 1 | **PB-01** playbook-export rewire | 0.50d | Already marked DEFERRED in `/Users/pmudh/Documents/GitHub/Atlanta/planning/delivery/00-scope.md`. It is not one of the four systems. The 0.1.0 skill still runs, and the file names it reads do not change, only their contents |
| 2 | **X-01 route 3** (the b2c-ecom full-arc run) | 0.70d | Ecom is the smallest slice of the cohort. The b2b and b2c-service runs still exercise every join between every skill. Cost: the `b2c-ecom-core` copy map reaches the 23 September clinic without an end-to-end run behind it |
| 3 | **D-04** doc reflow and trigger sync | 0.25d | Cosmetic. `scripts/validate.sh` already blocks banned dashes and banned words, so the founder-visible quality bar holds without it. Slips to lane 1.1 |
| 4 | **SS-02's rehearsed drill** (keep the mechanism, drop the rehearsal) | 0.50d | The Cowork Plugins Update button is a one-click vendor path. Replace the rehearsal with a written fallback in the Session 3 run sheet and a Slack message |
| 5 | **B-10** the curated memory layer | 1.00d | The four systems all still work. What is lost is that the toolkit stops remembering between sessions: angles can repeat on refill, and a founder returning in December starts from the Brain alone. Cut this before anything that stops a founder shipping, and after anything merely cosmetic. **The rest of the brain, B-00 to B-09, is never cut** |
| 6 | **A-02** status and gate folds | 0.50d | `status` keeps reporting file presence, which is what founders see today and what the 0.1.0 skill already does. Cost: gate answers stay file-shaped instead of ledger-shaped |
| 7 | **SS-03** reconnect flows | 1.00d | Replace with one page in `REPO/docs/CONNECTIONS.md` plus the Slack escape hatch. A Private Integration Token created at Session 2 is 11 to 13 days old at the event, well inside its life, so a 401 is rare. The doctor still names the failure |
| 8 | **C-03** publish through the GHL MCP | 2.00d | CSV bulk upload becomes the only publishing path. The CSV header is pinned to the real GHL template by C-02, and GHL's own importer is a supported product feature. Cost: the read-back verification promise goes, and system 1 loses its headline. **Requires Philip's yes** |
| 9 | **A-01** Apollo MCP flow | 2.00d | The manual export route becomes primary for every B2B founder, not just the Microsoft 365 ones. It is safe only because A-01 already builds and documents that route as first-class. Cost: no `{{first_line}}` write-back, no paused-enrollment proof, more founder clicking. **Requires Philip's yes** |

Total recoverable: **8.45 dev-days**.

**Never cut, at any pressure:** T-00, B-00 through B-09 (the brain and its schemas), CI-02's Windows Home leg, and X-01's b2b run.
Those are the difference between a product that founders can maintain themselves and a demo that breaks on 26 September with a one-day fix window.

---

### Two strings every task below reuses

**1. The `ge` write chain.**
Any task that produces or edits a file inside a founder's `./growth-engine/` folder writes this chain into the skill, in this order, as literal instruction text:

```
ge init                        # only if ./growth-engine/ is absent. Idempotent
ge snapshot <file>             # FAIL-CLOSED. Non-zero exit stops the skill here, before the write
<write the file>
ge log <decision|result|blocker|note> "<text>"
ge index
```

The fail-closed clause is not decoration.
If `ge snapshot` exits non-zero the skill says so, prints the recovery line, and does not write.
Three skills shipping today (`audience-b2c`, `growth-plan`, `playbook-export`) write founder files with no snapshot at all, which is why tasks AB-01, GP-01 and PB-01 exist.

**2. The invocation form.**
S-06's new DECISION GATE B2 decides whether skills write `ge <subcommand>` or the long form `sh "${CLAUDE_PLUGIN_ROOT}/scripts/ge.sh" <subcommand>`.
B-01 pins the winning string in `REPO/plugins/growth-engine/schemas/brain.md` under the heading `## Invocation`.
Every later task copies that one string. No task invents a second form.

---

## PHASE 0, triage and the spike (2.70d, do this first)

Nothing downstream is safe until the spike is filled, because PRD Part Zero rule 5 forbids using an API field, header, tool name or CSV column that is not recorded in `REPO/planning/spike-findings.md` with pasted evidence.
That file currently has seven PENDING sections and zero evidence.

---

### T-00, triage the 95 functional-review findings

**Status: NEW.** The PRD never references `FUNCTIONAL-REVIEW.md` and no task routes a single one of its findings. That is one of the four blockers in the gap register. Without this task the executor works top to bottom and never opens the review, and 4 blockers plus 23 highs resurface as founder failures in September.
**Effort: 0.5d.**
**Depends on: nothing. This is the first task in the build.**

**What to do**

1. Open `/Users/pmudh/Downloads/Atlanta/launchhouse-atlanta/planning/FUNCTIONAL-REVIEW.md`. Do not read it whole. It has seven area sections at lines 19, 207, 355, 513, 651, 799 and 887, and 95 findings, each a heading of the form `### [SEVERITY] <claim>`.
2. The findings carry no ids. Assign them, in document order, as `FR-<area>-<nn>` using these area codes: `FB` (founder-brain), `CE` (content-engine), `E2` (engine2-both), `OPP` (ops-plan-playbook), `SSG` (setup-status-gate), `EXT` (external-claims), `PVD` (promise-vs-delivery). Number restarts at 01 in each area.
3. Create `REPO/planning/review-triage.md`. One line per finding, 95 lines, in that order. Line format, pipe delimited so `grep -c` can count fields:
   `FR-CE-01|BLOCKER|CSV written from the unedited draft|fixed-by-task C-01`
4. The fourth field takes exactly one of four values, and nothing else:
   - `fixed-by-task <task-id>` where the task id is from this document.
   - `superseded-by-decision <section>` where the section is a heading in `REPO/planning/delivery/00-scope.md` or a numbered section of the PRD. Every engine2 finding about the DM inbox resolves here, to the cut in 00-scope.
   - `backlog` for anything real but post-event. These are collected again by R-04.
   - `wontfix: <reason in one clause>`. A bare `wontfix` is a failed line.
5. Every finding at BLOCKER or HIGH severity must resolve to `fixed-by-task` or `superseded-by-decision`. `backlog` and `wontfix` are available only to MEDIUM and LOW.
6. Add a five-line header to the file stating: the source document's absolute private path, its run date (18 August 2026), that the source is **not** copied into REPO because REPO is public, and the four permitted verdicts.
7. Before committing, read every line you wrote and confirm none of it carries client rates, mentor names, or anything from the PRIVATE folder beyond the finding's own claim text. The review discusses the product. It must not carry the commercials.

**ACCEPT**

```sh
cd /Users/pmudh/Documents/GitHub/Atlanta
# 95 lines, one per finding
grep -c '^FR-' planning/review-triage.md
# every line resolved to one of the four verdicts
grep -c '^FR-.*|\(fixed-by-task \|superseded-by-decision \|backlog$\|wontfix: \)' planning/review-triage.md
# no blocker or high left unresolved to a task or a decision
grep '^FR-.*|\(BLOCKER\|HIGH\)|' planning/review-triage.md | grep -vc 'fixed-by-task \|superseded-by-decision '
# no bare wontfix
grep -c 'wontfix$' planning/review-triage.md
# nothing leaked from the private folder
grep -ic 'rate\|retainer\|mentor brief\|invoice\|GBP' planning/review-triage.md
bash scripts/validate.sh
```

Output must show, in order: `95`, `95`, `0`, `0`, `0`, and validate.sh reporting 0 FAILs.

**COMMIT:** `T-00: triage the 95 functional-review findings into review-triage.md`

---

### S-01 ⚑HUMAN, accounts and the seven-scope token

**Status: AMENDED.** The scope list drops from nine strings to seven because the DM inbox is cut. A token that can read a founder's conversations is a token we no longer need and therefore must not ask for.
**Effort: 0.25d.**
**Depends on: nothing.**

**What to do**

1. Confirm a GoHighLevel paid account with API access and one test location.
2. In that location: Settings, then Private Integrations, create a Private Integration Token with **exactly** these seven scopes and no others:
   `socialplanner/post.readonly`, `socialplanner/post.write`, `socialplanner/account.readonly`, `socialplanner/statistics.readonly`, `contacts.readonly`, `contacts.write`, `locations.readonly`.
3. Record the locationId.
4. Record the GoHighLevel plan tier by name and monthly price. The PRD closes the tier question by assertion and never names a tier. A founder cannot buy an assertion. If comment-to-DM needs a higher tier than the one you are on, that fact belongs in this section and in the pre-work costs table.
5. Confirm a paid Apollo seat, with plan name and date.
6. Connect a test Facebook Page, and an Instagram Business account if one is available, to the test location's Social Planner.
7. Edit `REPO/planning/spike-findings.md` section S-01. The bullet in that file today reads "with **exactly** these nine scopes" and then lists ten strings, three of which are the conversations scopes that are now cut. Replace the whole bullet with "with **exactly** these seven scopes" and the seven strings above, in that order. Then fill the evidence block and delete the `PENDING` marker on its own line.

The three strings being removed, so the edit can be checked by eye, are `conversations.readonly`, `conversations/message.readonly` and `conversations/message.write`. They are no longer requested because Claude never reads a founder inbox. The DM inbox lives in the GoHighLevel app.

The token itself never goes in the file and never goes into chat. Record its creation date only.

**ACCEPT**

```sh
cd /Users/pmudh/Documents/GitHub/Atlanta
sed -n '/^## S-01/,/^## S-02/p' planning/spike-findings.md
sed -n '/^## S-01/,/^## S-02/p' planning/spike-findings.md | grep -c 'conversations'
grep -c '^PENDING' planning/spike-findings.md
```

The printed S-01 section must show a PIT creation date, seven scope strings, a locationId, a named GHL plan tier with its price, and an Apollo plan name.
The `conversations` count **inside the S-01 section** must be `0`.
Scope the grep to the section, as the command above does, because the S-04 section is still present and still titled `conversations` at this point in the build. S-04 is deleted later, by its own task.
The `^PENDING` count must be `6` at this point (S-02, S-03, S-04, S-05, S-06 and S-07 remain).
`grep -c '^PENDING'` anchors on the marker lines. A bare `grep -c 'PENDING'` returns one higher, because line 12 of the file is the instruction "Delete the `PENDING` marker when a section is complete."

**COMMIT:** `S-01: record accounts, seven-scope PIT, GHL tier and price`

---

### S-02 ⚑HUMAN, GHL MCP catalog, with a decision gate

**Status: AMENDED.** S-02 carried no decision gate, so there was no defined behaviour if the GoHighLevel MCP came back different. About 6.0 dev-days of build sit downstream of it. Adding the gate is the difference between a branch and a stall.
**Effort: 0.35d.**
**Depends on: S-01.**

**What to do**

1. In a terminal, with your own values substituted:
   ```
   claude mcp add --transport http ghl-test https://services.leadconnectorhq.com/mcp/ \
     --header "Authorization: Bearer <pit>" \
     --header "locationId: <id>"
   ```
2. List the tools. Paste the full list into `REPO/planning/spike-findings.md` section S-02.
3. Record whether `socialmediaposting_create-post` is present, and whether `socialmediaposting_get-account` and `socialmediaposting_get-post` are present. Do **not** record anything about `conversations_send-a-new-message`. It is out of scope and out of the token.
4. Probe `https://services.leadconnectorhq.com/mcp/anthropic/v2` the same way. Whichever endpoint yields **named** tools is the one the plugin ships with. State the chosen endpoint on its own line.
5. Add a `**DECISION GATE C**` block to section S-02 with three named branches:
   - **(a) Named tools present as documented.** Proceed. G-03 ships the endpoint recorded here. No effort change.
   - **(b) Named tools present, but one of the three publish tools is absent.** System 1 degrades to CSV only. C-03 is cut and CMD-02 ships `commands/publish.md` as a router into the CSV path instead. Recovers 2.0d. Say which tool was missing.
   - **(c) No named tools on either endpoint, or the endpoint demands OAuth rather than the PIT.** Stop and ask Philip. The choice is then between a costed REST v2 backstop task (estimate 2.5d, and it breaks the "no local runtime" floor because it needs an HTTP client on the founder path, so it is probably not viable) and cutting C-03. Record the decision here before any further GHL task starts.
6. Write the verdict on its own line as `GATE C VERDICT: a|b|c` with one sentence of evidence.

**ACCEPT**

```sh
cd /Users/pmudh/Documents/GitHub/Atlanta
sed -n '/## S-02/,/^---$/p' planning/spike-findings.md
grep -c 'GATE C VERDICT' planning/spike-findings.md
grep -c 'CHOSEN ENDPOINT' planning/spike-findings.md
```

The printed section must contain a non-empty pasted tool list, a `CHOSEN ENDPOINT:` line with a URL after it, and a `GATE C VERDICT:` line reading `a`, `b` or `c`.
Both counts must be `1`.

**COMMIT:** `S-02: record the GHL MCP catalog and set decision gate C`

---

### S-03 ⚑HUMAN, social write, timezone and rate limits

**Status: KEEP AS IS.** The section is correct and the timezone question is the single most load-bearing fact in the build.
**Effort: 0.5d.**
**Depends on: S-02 (needs the chosen endpoint).**

**What to do**

1. Through the MCP, in order: `get-account`, `create-post` as a draft, `create-post` scheduled for a known local time tomorrow, then check what the GoHighLevel user interface displays for that post, then `edit-post`, then `get-post` read-back, then delete or archive.
2. Paste the `get-account` response shape. This becomes the format for `.state/ghl-accounts.md`, which B-00 turns into a schema and B-09 turns into a writer.
3. State the timezone rule in one unambiguous sentence. If `scheduleDate` is read as UTC while the founder means 09:30 local, every scheduled post lands at the wrong hour for 130 people.
4. Fire fifteen rapid `get-posts` calls. Paste any 429 body and the rate observed before throttling. C-03's pacing pause is set from this number, not from a guess.
5. Download the in-app Social Planner CSV template and commit it verbatim as `REPO/plugins/growth-engine/assets/ghl/social-planner-template.csv`. Do not retype it. Do not reformat it. The header row is compared byte for byte by C-02 and by `ge lint`.
6. Fill section S-03 and delete its `PENDING` marker.

**ACCEPT**

```sh
cd /Users/pmudh/Documents/GitHub/Atlanta
test -f plugins/growth-engine/assets/ghl/social-planner-template.csv && head -1 plugins/growth-engine/assets/ghl/social-planner-template.csv
grep -c 'TIMEZONE RULE' planning/spike-findings.md
sed -n '/TIMEZONE RULE/,+3p' planning/spike-findings.md
bash scripts/validate.sh
```

The first command must print a real CSV header row with commas in it.
The `TIMEZONE RULE` count must be `1` and the three lines after it must contain a sentence, not a blank.
validate.sh must report 0 FAILs.

**COMMIT:** `S-03: timezone rule, rate ceiling, and the real Social Planner CSV fixture`

---

### S-04, conversations

**Status: CUT.** The DM inbox is out of scope as of 20 August 2026. Claude never reads a founder inbox, so no code of ours parses a `dateAdded` and nothing needs the message shape.
**Effort recovered: 0.25d.**

**What to do**

1. Delete the whole S-04 conversations section from `REPO/planning/spike-findings.md`, from the line beginning `## S-04` down to the `---` that closes it.
2. In its place put a four-line stub under the heading `## S-04, cut` stating: cut on 20 August 2026, the reason (the DM inbox lives in the GoHighLevel app), and a pointer to `REPO/planning/delivery/00-scope.md`.
3. Do not renumber S-05, S-06 or S-07. Their numbers are referenced by G-03, B-01 and A-01.

**ACCEPT**

```sh
cd /Users/pmudh/Documents/GitHub/Atlanta
grep -n '^## S-0' planning/spike-findings.md
grep -ic 'dateAdded\|send-a-new-message\|24-hour window' planning/spike-findings.md
```

The heading list must show S-01, S-02, S-03, S-04, S-05, S-06, S-07 with S-04 marked cut.
The second count must be `0`.

**COMMIT:** `S-04: cut the conversations spike, the DM inbox is out of scope`

---

### S-05 ⚑HUMAN, decision gate A, userConfig in Cowork

**Status: AMENDED.** One line added so the no-branch is observed rather than assumed. G-03 now has to build the fallback either way, and it is cheaper to know now whether the fallback connects at all.
**Effort: 0.35d.**
**Depends on: S-01.**

**What to do**

1. Install the probe plugin at `REPO/planning/spike/gate-ab-plugin/` through Cowork, then Customize, then Plugins.
2. When prompted for the spike token type `pit-DUMMY-not-real`. Never type a live token into a probe.
3. Run `/gate-ab-probe:spike-check` and paste what it reports. A 401 from GoHighLevel is the **success** case for the header question, because it proves the value was substituted and sent. A missing server, or an error about a malformed header, is the failure case.
4. **New step.** Whatever the answer, also confirm a `headersHelper` based server connects on the same surface. Add a second server entry to the probe's `.mcp.json` that names a two-line shell script reading `GHL_PIT` from a file at `${CLAUDE_PLUGIN_DATA}/ghl.env` with mode 600, and record whether the client accepts it and whether the header reaches GoHighLevel. Without this, G-03's second manifest variant is written against an unproven mechanism, which Part Zero rule 5 forbids.
5. Record the Cowork observation with a screenshot path. Also record the same two answers for macOS desktop Code tab, so the credential path is not left unrecorded on the surface half the cohort will use.
6. Write `GATE A VERDICT: yes|no` with the branch it selects.

**ACCEPT**

```sh
cd /Users/pmudh/Documents/GitHub/Atlanta
sed -n '/## S-05/,/^---$/p' planning/spike-findings.md
grep -c 'GATE A VERDICT' planning/spike-findings.md
grep -c 'headersHelper' planning/spike-findings.md
```

The section must show yes or no for the masked prompt, yes or no for header substitution, a screenshot path that exists on disk, a separate headersHelper result, and a `GATE A VERDICT:` line.
Both counts must be at least `1`.

**COMMIT:** `S-05: gate A verdict plus a probed headersHelper fallback`

---

### S-06 ⚑HUMAN, decision gate B, hooks and the bin floor, plus gate B2

**Status: AMENDED.** S-06 already records whether `ge-test` is on PATH but gate B branches only on hooks. Nothing decides what happens when `ge` itself is not directly invokable, and every skill task in this document assumes it is. Gate B2 fixes that with one paragraph and no extra probing.
**Effort: 0.25d.**
**Depends on: S-01.**

**What to do**

1. Install the same probe plugin and run `/gate-ab-probe:spike-check` on all three surfaces: macOS Cowork, macOS desktop Code tab, and Windows Home desktop Code tab under Git Bash. The Windows Home row cannot be skipped or inferred. It sets the floor for the entire brain.
2. Record for each: did the `GATE-B-MARKER mode=hook` line appear at session start before you typed anything, and does `ge-test manual` run at all.
3. Write `**DECISION GATE B**` with its two branches spelled out, then a `GATE B VERDICT: yes|no` line. The two branches are these, and nothing else. **Yes:** the `GATE-B-MARKER mode=hook` line appeared unprompted at session start on all three surfaces, so the SessionStart hook stays in the shipped manifest and `ge context --hook` is described in founder documentation as something that happens on its own. **No:** the marker did not appear on at least one surface, so the hook still ships, because it costs nothing where it works, but no founder-facing document ever promises hook behaviour, and every skill that depends on context calls `ge context` explicitly as its first step instead of assuming the hook already ran.
4. **New.** Add `**DECISION GATE B2**` with two branches:
   - `ge` is on PATH on all three surfaces, so every skill writes `ge <subcommand>`.
   - `ge` is not on PATH somewhere, so every skill writes `sh "${CLAUDE_PLUGIN_ROOT}/scripts/ge.sh" <subcommand>` and B-01 ships that exact string as the one documented invocation.
5. Write `GATE B2 VERDICT:` followed by the winning string, character for character, on its own line. B-01 copies it from here.

**ACCEPT**

```sh
cd /Users/pmudh/Documents/GitHub/Atlanta
sed -n '/## S-06/,/^---$/p' planning/spike-findings.md
grep -c 'GATE B VERDICT' planning/spike-findings.md
grep -c 'GATE B2 VERDICT' planning/spike-findings.md
```

Three surface receipts must be filled, none left as `yes / no`.
Both counts must be `1`, and the B2 line must be followed by a literal invocation string.

**COMMIT:** `S-06: three-surface receipts, gate B and the new gate B2 invocation form`

---

### S-07 ⚑HUMAN, Apollo paid, with a decision gate and three missing facts

**Status: AMENDED.** A-01 states three Apollo capabilities as fact that S-07 never gathers: enrichment returning an `email_status` field, writing a value into the `first_line` custom field, and sequence activation. Part Zero rule 5 then makes A-01 unbuildable. All three are minutes of extra work inside a session Philip is already running.
**Effort: 0.5d.**
**Depends on: S-01.**

**What to do**

1. OAuth-connect Apollo in Cowork and in the desktop Code tab. Record how each door was triggered and whether it worked.
2. Enumerate the action names and paste the list.
3. People-search returning one result. Record the action name and the count.
4. Create a contact. Paste the response.
5. **New fact 1.** Enrich that one contact. Paste the full response. Record the exact field name that carries deliverability status. A-01 writes `email_status` today. If the real field is called something else, A-01's text changes to match, and nothing is invented.
6. Create or confirm the `first_line` custom field (textarea, contact modality). Record its id.
7. **New fact 2.** Set a value into `first_line` on that contact through the MCP. Paste the request and the response. If custom-field writes are not exposed, say so in one sentence.
8. Create a test sequence with one `auto_email` touch using `{{first_line}}` and an opt-out line. Paste the response.
9. Add the test contact with `send_email_from_email_account_id` set to your own mailbox. Paste the paused-state proof. Confirm stop-on-reply is visible and on.
10. **New fact 3.** Attempt sequence activation through the MCP. Paste the result, or record in one sentence that activation is user-interface only. A-01's "or activate it here" branch lives or dies on this line.
11. Delete every test artifact.
12. Add `**DECISION GATE D**` with three named failure modes:
    - **No custom-field write.** `{{first_line}}` drops to a static opener chosen by the founder, and the skill says so in plain words. A-01 loses 0.25d of build and the outreach gets weaker, not broken.
    - **No sequence create.** The manual export route becomes primary for all B2B founders. A-01 shrinks to 1.0d and its acceptance changes to the manual set of 25.
    - **No contact create.** Stop and ask Philip. There is no Apollo path left and system 2's B2B half is a manual export product.
13. Write `GATE D VERDICT:` with the branch selected.

**ACCEPT**

```sh
cd /Users/pmudh/Documents/GitHub/Atlanta
sed -n '/## S-07/,/^---$/p' planning/spike-findings.md
grep -c 'GATE D VERDICT' planning/spike-findings.md
grep -ci 'enrich' planning/spike-findings.md
grep -c 'PAUSED STATE PROOF' planning/spike-findings.md
grep -c '^PENDING' planning/spike-findings.md
```

The section must show a pasted enrichment response with a named deliverability field, a pasted custom-field write result, a pasted paused-state proof, and an activation result or an explicit user-interface-only statement.
The verdict count must be `1`, the enrich count at least `1`, the paused-proof count `1`, and the `^PENDING` count must now be `0`.
Anchor the grep with `^PENDING`. A bare `grep -c 'PENDING'` returns `1` even when every section is filled, because line 12 of the file is the instruction "Delete the `PENDING` marker when a section is complete."

**COMMIT:** `S-07: Apollo enrichment, custom-field write, activation, and decision gate D`

---

## PHASE 1, groundwork (1.50d)

---

### G-01, contributor CLAUDE.md at the repo root

**Status: KEEP AS IS.**
**Effort: 0.25d.**
**Depends on: T-00.**

**What to do**

1. Create `REPO/CLAUDE.md`, at most 80 lines: the execution contract condensed, the shell script header template, the one-sentence-per-line doc rule, `bash /Users/pmudh/Documents/GitHub/Atlanta/scripts/validate.sh` before every commit, and pointers to `REPO/planning/PRD-growth-engine-v1.md`, `REPO/planning/delivery/`, `REPO/planning/spike-findings.md` and `REPO/planning/review-triage.md`.
2. State the folder boundary in two lines: REPO is public, the client folder at PRIVATE is not, and no file moves from PRIVATE to REPO.

**ACCEPT**

```sh
cd /Users/pmudh/Documents/GitHub/Atlanta
wc -l < CLAUDE.md
grep -c 'validate.sh' CLAUDE.md
grep -c 'review-triage.md' CLAUDE.md
bash scripts/validate.sh
```

Line count must be 80 or fewer. Both greps must be at least `1`. validate.sh must report 0 FAILs.

**COMMIT:** `G-01: add contributor CLAUDE.md (working agreements)`

---

### G-02, CHANGELOG and version bump to 0.2.0

**Status: KEEP AS IS.**
**Effort: 0.25d.**
**Depends on: G-01.**

**What to do**

1. Create `REPO/CHANGELOG.md` in Keep-a-Changelog format with one entry, `0.2.0 - internal dev toward 1.0.0`, listing this delivery plan and the PRD it revises.
2. Bump the version to `0.2.0` in both `REPO/plugins/growth-engine/.claude-plugin/plugin.json` and `REPO/.claude-plugin/marketplace.json`.

**ACCEPT**

```sh
cd /Users/pmudh/Documents/GitHub/Atlanta
grep -h '"version"' plugins/growth-engine/.claude-plugin/plugin.json .claude-plugin/marketplace.json
head -12 CHANGELOG.md
bash scripts/validate.sh
```

Both version strings must read `0.2.0`. validate.sh's version-agreement check must pass with 0 FAILs.

**COMMIT:** `G-02: start CHANGELOG, bump to 0.2.0`

---

### G-03, plugin manifests, both MCP variants, and the SessionStart hook

**Status: AMENDED.** Three changes. The Apollo and GHL servers stay. The `dm-inbox` assumptions go. And the Gate A no-branch gets a real specification with its own effort instead of one clause of prose, because `headersHelper` currently has one declaration and two consumers and no producer anywhere in the PRD.
**Effort: 1.0d** (0.5d as in the PRD, plus 0.5d for the second manifest variant and its helper script).
**Depends on: S-02 (chosen endpoint), S-05 (gate A verdict and the probed helper).**

**What to do**

1. Add the `userConfig` block to `REPO/plugins/growth-engine/.claude-plugin/plugin.json` verbatim as the PRD gives it, with two fields, `ghl_pit` (`sensitive: true`) and `ghl_location_id`.
2. Create `REPO/plugins/growth-engine/.mcp.json`, **variant A**, used when `GATE A VERDICT` is `yes`:
   ```json
   {
     "mcpServers": {
       "ghl": {
         "type": "http",
         "url": "<CHOSEN ENDPOINT from spike-findings S-02>",
         "headers": {
           "Authorization": "Bearer ${user_config.ghl_pit}",
           "locationId": "${user_config.ghl_location_id}"
         }
       },
       "apollo": { "type": "http", "url": "https://mcp.apollo.io/mcp" }
     }
   }
   ```
3. Create `REPO/plugins/growth-engine/.mcp.json.headers-variant`, **variant B**, used when `GATE A VERDICT` is `no`. It replaces the `headers` object with `"headersHelper": "sh ${CLAUDE_PLUGIN_ROOT}/scripts/ghl-headers.sh"` and keeps the Apollo entry unchanged.
4. Create `REPO/plugins/growth-engine/scripts/ghl-headers.sh`. It carries the standard header block. Its job is exactly this and nothing more:
   - Read `${CLAUDE_PLUGIN_DATA}/ghl.env`, a two-line file of the form `GHL_PIT=...` and `GHL_LOCATION_ID=...`.
   - If the file is missing, or its mode is not 600, or either value is still the literal `PASTE_TOKEN_HERE`, exit 1 with a message ending in a recovery line naming the exact absolute path to open and what to paste there.
   - On success, print the two header lines the client expects and nothing else. It never echoes the token to stdout in any other form, never logs it, and never writes it anywhere.
   - POSTURE: fail-closed. A header helper that emits a half-formed header produces a 401 the founder cannot diagnose.
5. Create `REPO/plugins/growth-engine/hooks/hooks.json` with the SessionStart entry running `sh "${CLAUDE_PLUGIN_ROOT}/scripts/ge.sh" context --hook` with a 10 second timeout.
6. Ship exactly one `.mcp.json`. Whichever variant the gate selects becomes `.mcp.json`; the other stays in the repo under its variant name so the branch is switchable in one file move, and so CI can parse both.
7. Add a line to `REPO/plugins/growth-engine/schemas/brain.md` under `## Credentials` naming which variant shipped and on what evidence. B-00 creates that file, so if B-00 has not run yet, note it in the commit body and add the line in B-00.

**ACCEPT**

```sh
cd /Users/pmudh/Documents/GitHub/Atlanta
for f in plugins/growth-engine/.mcp.json plugins/growth-engine/.mcp.json.headers-variant plugins/growth-engine/hooks/hooks.json; do
  python3 -c "import json,sys;json.load(open(sys.argv[1]));print('parsed ok:',sys.argv[1])" "$f"
done
sh -n plugins/growth-engine/scripts/ghl-headers.sh && echo "ghl-headers.sh parses"
# the helper refuses a missing env file with a recovery line
CLAUDE_PLUGIN_DATA=/tmp/ge-no-such-dir sh plugins/growth-engine/scripts/ghl-headers.sh; echo "exit=$?"
# the helper refuses a placeholder token
mkdir -p /tmp/ge-probe && printf 'GHL_PIT=PASTE_TOKEN_HERE\nGHL_LOCATION_ID=x\n' > /tmp/ge-probe/ghl.env && chmod 600 /tmp/ge-probe/ghl.env
CLAUDE_PLUGIN_DATA=/tmp/ge-probe sh plugins/growth-engine/scripts/ghl-headers.sh; echo "exit=$?"
grep -c 'conversations' plugins/growth-engine/.mcp.json
bash scripts/validate.sh
```

All three JSON files must print `parsed ok`.
`ghl-headers.sh` must parse.
Both refusal runs must print `exit=1` and a message whose last line begins with an arrow and a runnable instruction.
The `conversations` count in `.mcp.json` must be `0`.
validate.sh must report 0 FAILs.

**COMMIT:** `G-03: wire GHL and Apollo MCP, userConfig, headersHelper variant, SessionStart belt`

---

## PHASE 2, the brain (6.75d)

One CLI, POSIX sh, split as `bin/ge` (a three-line exec shim) into `scripts/ge.sh` (a dispatcher) into `scripts/lib/*.sh`.
Every subcommand prints evidence, returns a meaningful exit code, and ends every error with a recovery line.
`tests/run.sh` grows with every task in this phase.

---

### B-00, write the eight schema files

> **Amended by section 08.** See `/Users/pmudh/Documents/GitHub/Atlanta/planning/delivery/08-persistent-memory.md`: an eighth schema file, `schemas/memory.md`, and the acceptance count moves from 7 to 8.

**Status: NEW.** The PRD declares `schemas/` in three places and consumes it in two, and creates exactly one file inside it, `gates.md`, and then only as a side clause in B-06. The ledger header the PRD ships in its own sample output says `Format: schemas/ledger.md`, which is a dangling pointer written into 130 founders' folders. CI-01 adds a check against a directory that is four-fifths absent.
**Effort: 0.75d.**
**Depends on: T-00, G-02.**

**What to do**

Create eight files under `REPO/plugins/growth-engine/schemas/`. Each one has the same five sections: what the file is for, who the single writer is, the exact line format, a valid example block, and an invalid example block with one sentence saying what is wrong with it.

1. `schemas/brain.md` : the founder-brain.md section list, the `Track` enum (`b2b|b2c`), the `Model` enum (`service|ecommerce`, B2C only), the `Locked` date format, the Numbers block FB-01 adds, and the `## Invocation` heading holding the one `ge` invocation string from S-06 gate B2, and the `## Credentials` heading holding the G-03 variant decision.
2. `schemas/ledger.md` : the row formats, all three of them.
   - `C|<id>|<pillar#>|<format>|<lane text|media>|<status draft|approved|scheduled|posted|failed|archived>|<ghl_post_id|->|<scheduled_for|->`
   - `O|<email>|<first_name>|<company>|<status candidate|cut|contacted_ok|enrolled|replied|stopped>|<first_line y|n>`
   - `D|<handle>|<platform ig|fb|other>|<status target|opener_written|sent|replied|booked|no_reply>|<sent_at ISO|->` , **new**, because the outreach row is keyed on email with a B2B-only enum, so the 25 hand-sent DMs that half the cohort does on the Saturday have no representable state and `status` reports zero for them forever.
3. `schemas/ops-log.md` : `## YYYY-MM-DD` day headers, entries as `- HH:MM <decision|result|blocker|note>: <text>`, append-only by construction, and the `.state/log.bytes` watermark that proves it.
4. `schemas/index.md` : the fixed table `| file | gate | status | bytes | modified |` with `status` in `missing|empty|ok`.
5. `schemas/gates.md` : the gate table, moved out of `REPO/plugins/growth-engine/skills/status/SKILL.md` prose so there is one source. Three gates, each with its item list, each item marked `file-backed` or `self-reported`, and each branched by track where the tracks differ.
6. `schemas/receipt.md` : **new**, because `ge context` parses the receipt for the token creation date to raise the 80-day warning, and nothing defines the format it parses. One line per check, `<check> <PASS|FAIL|SKIP> <evidence>`, plus a `pit_created <YYYY-MM-DD>` line.
7. `schemas/ghl-accounts.md` : **new**, because C-03 reads it for account ids and nothing defines it. Format comes from the pasted `get-account` response shape in spike-findings S-03. One account per line, `<account_id>|<platform>|<display_name>`.

Every one of these files is founder-readable and lives under `plugins/`, so `scripts/validate.sh` will check it for banned dashes and banned words. Write it in house style.

**ACCEPT**

```sh
cd /Users/pmudh/Documents/GitHub/Atlanta
ls -1 plugins/growth-engine/schemas/
for f in plugins/growth-engine/schemas/*.md; do
  printf '%s: ' "$f"
  grep -c '^## ' "$f"
done
grep -l 'writer' plugins/growth-engine/schemas/*.md | wc -l
grep -c '^D|' plugins/growth-engine/schemas/ledger.md
bash scripts/validate.sh
```

The listing must show exactly seven files: `brain.md`, `gates.md`, `ghl-accounts.md`, `index.md`, `ledger.md`, `ops-log.md`, `receipt.md`.
Every file must report 5 or more `## ` headings.
The writer count must be `7`.
The `D|` count in ledger.md must be at least `1`.
validate.sh must report 0 FAILs.

**COMMIT:** `B-00: write the seven state schemas, one contract per file`

---

### B-01, ge skeleton and the libraries

**Status: AMENDED.** One addition: the invocation string chosen by S-06 gate B2 is pinned here, once, so every later skill copies one string rather than each inventing its own.
**Effort: 0.75d.**
**Depends on: B-00, S-06.**

**What to do**

1. `REPO/plugins/growth-engine/bin/ge` : a three-line exec shim into `scripts/ge.sh`.
2. `REPO/plugins/growth-engine/scripts/ge.sh` : the dispatcher, with `help`.
3. `REPO/plugins/growth-engine/scripts/lib/paths.sh` : `ge_find_home`, which walks cwd, then each parent, then `$HOME`, then `$HOME/Desktop`, `$HOME/Documents` and `$HOME/Downloads`, looking for `growth-engine/.state/HOME`. It compares the anchor and reports scatter when it finds more than one. The three extra directories are added because the common real case is a founder who built the folder on the Desktop and opened Claude somewhere else, and the PRD's walk misses exactly that.
4. `REPO/plugins/growth-engine/scripts/lib/date_compat.sh` : GNU versus BSD `date` detection, exposing `iso_to_epoch`, `now_epoch`, `utc_stamp`.
5. `REPO/plugins/growth-engine/scripts/lib/table.sh` : index and ledger row helpers.
6. Every file opens with the standard header block, `set -u`, and states its posture.
7. Copy the `GATE B2 VERDICT` string from `REPO/planning/spike-findings.md` into `REPO/plugins/growth-engine/schemas/brain.md` under `## Invocation`, character for character. Add a one-line comment in `ge.sh` pointing at it.
8. Create `REPO/tests/run.sh` and `REPO/tests/fixtures/`. Seed with the help case and both date-compat branches.

**ACCEPT**

```sh
cd /Users/pmudh/Documents/GitHub/Atlanta
for f in plugins/growth-engine/bin/ge $(find plugins/growth-engine/scripts -name '*.sh'); do
  sh -n "$f" && echo "parses: $f"
done
sh tests/run.sh; echo "tests exit=$?"
sed -n '/## Invocation/,+4p' plugins/growth-engine/schemas/brain.md
# bashisms, not the word "bash". Every header block contains the literal line
# "PORTABILITY:   POSIX sh. No bash/python/node/jq." so a bare grep for "bash"
# can never return zero and is not a usable check.
grep -rnE '(^|[^#])(\[\[|declare -|local -|\$\(\(.*\+\+|<\(|>\(|BASH_SOURCE|\bfunction )' \
  plugins/growth-engine/scripts/ plugins/growth-engine/bin/ | grep -v '^Binary' | wc -l
grep -rn '^#!' plugins/growth-engine/scripts/ plugins/growth-engine/bin/ | grep -vc '#!/bin/sh'
```

Every script must print `parses:`.
`tests exit=0`.
The Invocation section must print a literal command string.
The bashism count must be `0`, and the non-`#!/bin/sh` shebang count must be `0`, because the founder floor is POSIX sh under Git Bash on Windows Home.

**COMMIT:** `B-01: ge skeleton, path and date and table libs, invocation form pinned`

---

### B-02, ge init

> **Amended by section 08.** See `/Users/pmudh/Documents/GitHub/Atlanta/planning/delivery/08-persistent-memory.md`: `ge init` also seeds `growth-engine/memory.md` with its six managed blocks present and empty.

**Status: KEEP AS IS.**
**Effort: 0.5d.**
**Depends on: B-01.**

**What to do**

1. Create `growth-engine/` plus `.state/HOME` and `.state/snapshots/` in the founder's working folder.
2. Seed the founder files that do not exist yet, empty.
3. Write the absolute anchor path into `.state/HOME`, one line.
4. Idempotent. A re-run reports what already exists and clobbers nothing.
5. Print the absolute path and the sentence telling the founder to always open this folder.
6. Create the fixture the acceptance compares against: run `ge init` once in an empty folder, capture `find growth-engine -type f | sort` and save it verbatim as `REPO/tests/fixtures/init-tree.txt`. Nothing else writes that file, so if this step is skipped the acceptance below cannot run.

**ACCEPT**

```sh
cd /tmp && rm -rf ge-init-probe && mkdir ge-init-probe && cd ge-init-probe
sh /Users/pmudh/Documents/GitHub/Atlanta/plugins/growth-engine/scripts/ge.sh init
sh /Users/pmudh/Documents/GitHub/Atlanta/plugins/growth-engine/scripts/ge.sh init
find growth-engine -type f | sort
cat growth-engine/.state/HOME
cd /Users/pmudh/Documents/GitHub/Atlanta && sh tests/run.sh; echo "tests exit=$?"
```

The second `init` must report that the folder already exists and must not report creating anything.
The `find` output must match the fixture tree in `REPO/tests/fixtures/init-tree.txt`.
`.state/HOME` must contain `/tmp/ge-init-probe/growth-engine` and nothing else.
`tests exit=0`.

**COMMIT:** `B-02: ge init, the anchored working folder`

---

### B-03, ge snapshot, restore and undo

**Status: AMENDED.** Only the effort and deliverable list change. `commands/undo.md` was declared twice in the PRD's own component map and finished tree and built by no task; it now has a real owner in CMD-01, and B-03's acceptance is extended to prove the CLI half works before the router is written.
**Effort: 0.75d.**
**Depends on: B-02.**

**What to do**

1. `ge snapshot <file>` : byte copy to `.state/snapshots/<name>.<UTCstamp>`, a ring of the last 10 per file. If the copy cannot be made, exit 1 and print a recovery line. POSTURE: fail-closed. No snapshot means no write, and every skill downstream is told to stop on a non-zero exit.
2. `ge restore <file> [stamp]` : lists stamps when the choice is ambiguous, previews the line-count difference, restores byte-exact.
3. `ge undo` : restores the most recent snapshot across all files, and asks which when more than one file was snapshotted in the last hour.
4. Every error message ends with a runnable recovery.

**ACCEPT**

```sh
cd /tmp && rm -rf ge-snap-probe && mkdir ge-snap-probe && cd ge-snap-probe
GE=/Users/pmudh/Documents/GitHub/Atlanta/plugins/growth-engine/scripts/ge.sh
sh $GE init
printf 'original content\n' > growth-engine/founder-brain.md
cp growth-engine/founder-brain.md /tmp/ge-snap-probe/original.keep
sh $GE snapshot founder-brain.md
printf 'clobbered\n' > growth-engine/founder-brain.md
sh $GE undo
cmp growth-engine/founder-brain.md /tmp/ge-snap-probe/original.keep && echo "UNDO RESTORED BYTE EXACT"
# ring caps at 10
i=1; while [ $i -le 14 ]; do printf 'v%s\n' "$i" > growth-engine/founder-brain.md; sh $GE snapshot founder-brain.md; i=$((i+1)); done
ls growth-engine/.state/snapshots/ | grep -c '^founder-brain.md\.'
# fail-closed on an unwritable snapshot dir
chmod 500 growth-engine/.state/snapshots
sh $GE snapshot founder-brain.md; echo "exit=$?"
chmod 700 growth-engine/.state/snapshots
```

`UNDO RESTORED BYTE EXACT` must print.
The snapshot count must be `10`, not 14.
The unwritable run must print `exit=1` and a final line beginning with an arrow.

**COMMIT:** `B-03: snapshot ring plus restore and undo (fail-closed)`

---

### B-04, ge log and the append-only watermark

**Status: AMENDED.** `ge check` in B-08 compares the ops-log byte count against a `.state/log.bytes` watermark that no task writes and that is absent from the PRD's own state tree. Either the doctor fails on day one for every founder, or the check is silently skipped and a truncated log passes. B-04 is the only writer of `ops-log.md`, so B-04 writes the watermark.
**Effort: 0.5d.**
**Depends on: B-02, B-00.**

**What to do**

1. `ge log <decision|result|blocker|note> "<text>"` appends to `growth-engine/ops-log.md`.
2. Day-header dedupe: a second entry on the same date reuses the existing `## YYYY-MM-DD` header.
3. Refuse empty text with exit 1 and a recovery line.
4. Never rewrite an existing line. Append only, by construction.
5. **New.** After every successful append, write the new byte count of `ops-log.md` into `growth-engine/.state/log.bytes` as a single integer on one line.
6. Add `.state/log.bytes` to `schemas/ops-log.md` with `[writer: ge log]`.

**ACCEPT**

```sh
cd /tmp && rm -rf ge-log-probe && mkdir ge-log-probe && cd ge-log-probe
GE=/Users/pmudh/Documents/GitHub/Atlanta/plugins/growth-engine/scripts/ge.sh
sh $GE init
sh $GE log decision "brain locked (track=b2b)"
sh $GE log result "30 pieces generated"
grep -c '^## ' growth-engine/ops-log.md
cat growth-engine/.state/log.bytes
wc -c < growth-engine/ops-log.md
sh $GE log note ""; echo "exit=$?"
```

The day-header count must be `1` after two entries on the same day.
The number in `.state/log.bytes` must equal the byte count printed by `wc -c`.
The empty-text run must print `exit=1` with a recovery line.

**COMMIT:** `B-04: ops-log, the append-only memory spine, with a byte watermark`

---

### B-05, ge ledger, three row types and the approve transition

**Status: AMENDED.** Two additions, both closing verified gaps. The `D|` row exists because hand-sent DMs had no representable state. The approve transition exists because nothing anywhere set a row to `approved`, which made C-03's stated precondition impossible to meet, which meant `/growth-engine:publish` would find zero eligible rows on every founder's machine.
**Effort: 1.0d** (0.75d as in the PRD, plus 0.25d for the D row and the approve verbs).
**Depends on: B-03, B-00.**

**What to do**

1. `ge ledger add-content`, `set-content <id> <field> <value>`, `add-outreach`, `set-outreach <email> <field> <value>`, `list [C|O|D] [--status X]`.
2. **New.** `ge ledger add-dm <handle> <platform>` and `set-dm <handle> <field> <value>`, writing `D|` rows per `schemas/ledger.md`.
3. **New.** `ge ledger approve <id>` and `ge ledger approve --all-text` : sets one content row, or every text-lane row, from `draft` to `approved`. It refuses any row not currently `draft` and says which status it found. It stamps the approval time into `.state/approved-at` so B-06's lint can compare it against the modification time of `content-30.md`.
4. Enum validation on every field, per `schemas/ledger.md`. An invalid value exits 1 and prints the allowed values in the message.
5. Every mutation calls `ge snapshot ledger.md` first. A failed snapshot stops the mutation.

**ACCEPT**

```sh
cd /tmp && rm -rf ge-ledger-probe && mkdir ge-ledger-probe && cd ge-ledger-probe
GE=/Users/pmudh/Documents/GitHub/Atlanta/plugins/growth-engine/scripts/ge.sh
sh $GE init
sh $GE ledger add-content 1 1 short-post text
sh $GE ledger add-content 2 1 reel-script media
sh $GE ledger add-outreach sofia@example.com Sofia BrightOps
sh $GE ledger add-dm @sofia.k ig
sh $GE ledger approve --all-text
sh $GE ledger list C --status approved
sh $GE ledger list D
grep -c '^D|' growth-engine/ledger.md
# an invalid enum is refused, with the allowed values named
sh $GE ledger set-content 1 status posted_maybe; echo "exit=$?"
# approving an already-approved row is refused
sh $GE ledger approve 1; echo "exit=$?"
# a snapshot exists for every mutation
ls growth-engine/.state/snapshots/ | grep -c '^ledger.md\.'
```

`list C --status approved` must show row 1 and must not show row 2, because row 2 is media lane.
The `D|` count must be `1`.
The invalid enum run must print `exit=1` and list the six allowed content statuses.
The re-approve run must print `exit=1` and name the status it found.
The ledger snapshot count must be 5 or more.

**COMMIT:** `B-05: the ledger, one writer, three row types, and the approve transition`

---

### B-06, ge index and ge lint

> **Amended by section 08.** See `/Users/pmudh/Documents/GitHub/Atlanta/planning/delivery/08-persistent-memory.md`: `ge lint` also warns on the memory budget and reports any managed block whose start marker has no matching end marker.

**Status: AMENDED.** The `gates.md` clause moves out to B-00, and two lint checks are added that make the approve transition enforceable rather than decorative.
**Effort: 1.0d** (0.75d as in the PRD, plus 0.25d for the divergence checks).
**Depends on: B-05, B-00.**

**What to do**

1. `ge index` : rebuild `growth-engine/.state/index.md` as the file table from `schemas/index.md`, with a gate label per file read from `schemas/gates.md`.
2. `ge lint` : POSTURE warn-only. It never blocks a write. The doctor surfaces what it finds.
3. Lint checks, each naming the file and line:
   - Brain headings present, `Track` and `Model` enums valid, `Locked` date parseable.
   - **New.** The Numbers block is present, and a warning when every value in it reads `unknown`, because `growth-plan` projects from those numbers and cannot project from nothing.
   - Ledger field counts correct per row type, enums valid.
   - CSV row count 90 or fewer, and the header row compared with `cmp` against `assets/ghl/social-planner-template.csv`.
   - **New, divergence check 1.** For every data row in `content-30.csv`, the first 40 characters of its content cell must match the corresponding numbered item in `content-30.md`. This catches the case where the founder edited the markdown for voice and the CSV is still frozen at generation.
   - **New, divergence check 2.** No ledger row may hold status `approved` if `.state/approved-at` is older than the modification time of `content-30.md`. Approval is of a specific text. Edit the text and the approval is stale.
4. Every warning ends with a recovery line naming the command that fixes it.

**ACCEPT**

```sh
cd /Users/pmudh/Documents/GitHub/Atlanta
# a seeded folder with exactly five known faults
rm -rf /tmp/ge-lint-probe && cp -R tests/fixtures/lint-seeded /tmp/ge-lint-probe
cd /tmp/ge-lint-probe
GE=/Users/pmudh/Documents/GitHub/Atlanta/plugins/growth-engine/scripts/ge.sh
sh $GE index
diff growth-engine/.state/index.md /Users/pmudh/Documents/GitHub/Atlanta/tests/fixtures/index-expected.md && echo "INDEX MATCHES FIXTURE"
sh $GE lint; echo "lint exit=$?"
sh $GE lint | grep -c 'WARN'
sh $GE lint | grep -c '→'
```

`INDEX MATCHES FIXTURE` must print.
`lint exit=0`, because lint is warn-only and never blocks.
The `WARN` count must be exactly `5`, one per seeded fault, and the seeded faults must include one stale-approval and one CSV divergence.
The arrow count must equal the WARN count, because every warning carries its recovery.

**COMMIT:** `B-06: derived index and structural lint, including approval divergence`

---

### B-07, ge dmgate

**Status: CUT.** Nothing we ship sends a direct message, so no code of ours does 24-hour window arithmetic. The window is GoHighLevel's to enforce inside its own app.
**Effort recovered: 0.5d.**

**What to do**

1. Do not build it. If any file already references `dmgate`, remove the reference.
2. Confirm `REPO/plugins/growth-engine/scripts/lib/date_compat.sh` survives. It is still needed by `ge snapshot` for UTC stamps and by `ge lint` for the Locked date and the approval comparison.

**ACCEPT**

```sh
cd /Users/pmudh/Documents/GitHub/Atlanta
grep -rin 'dmgate\|24-hour window\|24 hour window' \
  --include='*.md' --include='*.sh' --include='*.json' --exclude-dir='.git' . \
  | grep -v 'planning/delivery/' | grep -v 'planning/PRD-growth-engine-v1.md' | wc -l
test -f plugins/growth-engine/scripts/lib/date_compat.sh && echo "date_compat survives"
```

The reference count must be `0` outside this delivery plan and the superseded PRD.
`date_compat survives` must print.

**COMMIT:** `B-07: cut dmgate, no code of ours sends a DM`

---

### B-08, ge context and ge check

> **Amended by section 08.** See `/Users/pmudh/Documents/GitHub/Atlanta/planning/delivery/08-persistent-memory.md`: `ge context` also reads `memory.md` and carries the newest decision and the newest open thread, inside the existing fifteen-line ceiling rather than beyond it.

**Status: AMENDED.** The PIT-age leg now reads the schema'd field defined in B-00 and written by B-09, instead of parsing prose. The log-integrity leg now has a watermark to compare against, written by B-04.
**Effort: 1.0d.**
**Depends on: B-04, B-05, B-06, B-09.**

**What to do**

1. `ge context [--hook]` : at most 15 lines. The anchor verdict, the gate summary read from the index, unresolved Flags from the brain, and a token-age warning when `pit_created` in `.state/receipt.md` is more than 80 days old. POSTURE: fail-open. No folder means exit 0 and print nothing. A broken hook must never wedge a session.
2. `ge check` : the doctor core. Each line reads `PASS|FAIL` then evidence then, on failure, a recovery. The legs are:
   - anchor: `.state/HOME` against the current working directory.
   - write probe: create, read and delete a canary file inside `growth-engine/`.
   - index freshness: the index is not older than the newest founder file.
   - lint summary: the count of warnings, not their text.
   - snapshot ring health: how many files are ringed, and the newest stamp.
   - log integrity: the current byte count of `ops-log.md` compared against `.state/log.bytes`. Shrunk means FAIL.
   - token age: `pit_created` from the receipt, or SKIP when no receipt exists yet.

**ACCEPT**

```sh
cd /tmp && rm -rf ge-check-probe && mkdir ge-check-probe && cd ge-check-probe
GE=/Users/pmudh/Documents/GitHub/Atlanta/plugins/growth-engine/scripts/ge.sh
sh $GE init && sh $GE log note "seed" && sh $GE index
sh $GE check; echo "healthy exit=$?"
sh $GE check | grep -c 'FAIL'
# induced failure 1: the log shrank
printf '' > growth-engine/ops-log.md
sh $GE check | grep 'ops-log'
# induced failure 2: the anchor points elsewhere
printf '/tmp/somewhere-else/growth-engine\n' > growth-engine/.state/HOME
sh $GE check | grep 'anchor'
# fail-open: no folder at all means silence and exit 0
cd /tmp && rm -rf ge-empty && mkdir ge-empty && cd ge-empty
sh $GE context --hook; echo "context exit=$? output-bytes=$(sh $GE context --hook | wc -c)"
```

The healthy run must print `healthy exit=0` and a FAIL count of `0`.
The shrunk-log line must read FAIL and end with a recovery.
The anchor line must read FAIL, print both paths, and end with a recovery naming the folder to open.
The empty-folder context run must print `context exit=0` and `output-bytes=0`.

**COMMIT:** `B-08: context injection and the evidence doctor core`

---

### B-09, ge receipt and ge accounts

**Status: NEW.** The PRD's own state tree says `.state/receipt.md` and `.state/ghl-accounts.md` are written "via ge", and no `ge` subcommand anywhere writes either, while the same document forbids skills from hand-editing state. B-08's token-age check is unimplementable without this, and C-03 parses an account cache that nothing defines or produces.
**Effort: 0.5d.**
**Depends on: B-00 (schemas), B-03 (snapshot).**

**What to do**

1. `ge receipt set <check> <PASS|FAIL|SKIP> "<evidence>"` : writes or replaces one line in `.state/receipt.md` per `schemas/receipt.md`. Snapshot first.
2. `ge receipt set pit-created <YYYY-MM-DD>` : the one line B-08's age check reads. The subcommand refuses anything that is not a parseable date.
3. `ge receipt show` : prints the receipt.
4. `ge accounts write` : reads account rows on stdin, one per line as `<account_id>|<platform>|<display_name>`, and writes `.state/ghl-accounts.md` per `schemas/ghl-accounts.md`, with a UTC stamp line at the top so C-03 can decide whether the cache is stale. Snapshot first.
5. Neither subcommand ever accepts, prints, stores or logs a token value. `ge receipt set` rejects any evidence string matching `pit-` followed by anything, with a recovery line explaining that the receipt records that a token exists and when it was made, never the token.

**ACCEPT**

```sh
cd /tmp && rm -rf ge-receipt-probe && mkdir ge-receipt-probe && cd ge-receipt-probe
GE=/Users/pmudh/Documents/GitHub/Atlanta/plugins/growth-engine/scripts/ge.sh
sh $GE init
sh $GE receipt set plugin PASS "growth-engine 0.2.0"
sh $GE receipt set pit-created 2026-09-14
printf 'acc_1|facebook|Lumen Skin\nacc_2|instagram|@lumenskin\n' | sh $GE accounts write
sh $GE receipt show
cat growth-engine/.state/ghl-accounts.md
# a token in the evidence field is refused
sh $GE receipt set ghl PASS "pit-abc123def"; echo "exit=$?"
# a bad date is refused
sh $GE receipt set pit-created "last tuesday"; echo "exit=$?"
grep -rc 'pit-' growth-engine/ | grep -v ':0' | wc -l
```

The receipt must show a `plugin PASS` line and a `pit_created 2026-09-14` line.
The accounts file must show two account rows and a stamp line.
Both refusal runs must print `exit=1` with a recovery line.
The final count must be `0`, proving no file in the folder contains a token-shaped string.

**COMMIT:** `B-09: ge receipt and ge accounts, one writer for the last two state files`

---

### B-10, ge remember, the curated memory layer

**Status: NEW, specified in full in section 08.**
The task body, the numbered steps, the runnable acceptance block and the commit line are at `/Users/pmudh/Documents/GitHub/Atlanta/planning/delivery/08-persistent-memory.md`.

**Effort: 0.75d.** **Depends on:** `B-00`, `B-03`, `B-04`, `B-05`. **Blocks:** the amended `B-08` and `C-01`.

It adds `growth-engine/memory.md`, the curated layer that persists what the toolkit learns about a founder across sessions, together with the managed-block mechanism that lets `ge` write inside a file the founder also edits, and the hold rule that refuses an edit whose anchor text has moved.
Ported from the Glitch vault model at `/Users/pmudh/Documents/GitHub/glitch`.

---

## PHASE 3, the founder brain (2.00d)

---

### FB-01, founder-brain v2

**Status: AMENDED.** The PRD's SPEC deltas are exhaustive and add a model subtype and a media flag, and no numbers. `growth-plan` is told to base projections on actual list size, audience size and conversion assumptions, from a brain that carries a revenue band and a price. The two worked examples look numerate only because they were hand-written. Adding the Numbers block here is what makes GP-01 possible.
**Effort: 1.25d** (1.0d as in the PRD, plus 0.25d for the Numbers block and its template section).
**Depends on: B-05, B-06, B-09, B-00.**

**SNAPSHOT CHAIN.** This skill writes `growth-engine/founder-brain.md`. It runs, in this order and as literal instruction text in the skill: `ge init` if the folder is absent, then `ge snapshot founder-brain.md` and stop on a non-zero exit, then write the file, then `ge log decision "brain locked (track=..., model=...)"`, then `ge index`.

**What to do**

1. Edit `REPO/plugins/growth-engine/skills/founder-brain/SKILL.md`.
2. Add the Model question, B2C only: `service | ecommerce`. For ecommerce add three intake questions: platform, average order value band, repeat-purchase share.
3. Add `- **Model:**` to the brain template block.
4. Add the media-capability flag: can the founder record video. C-01 reads it to set the text or media lane.
5. **New.** Add a Numbers block to Group 4, and a matching template section. Ask for: current monthly revenue, audience size per active channel, email list size, current monthly leads or enquiries, and close rate if known. `unknown` is a permitted answer for any of them and must be offered explicitly, because a founder who does not know their close rate should say so rather than guess. Then change the 90-day goal question from a category menu to a number with a unit and a deadline.
6. Add the ecom flavour notes for content groups 3 and 4.
7. Write the ge chain into the skill in the exact form pinned in `schemas/brain.md` under `## Invocation`.
8. Take the closing gate line from `ge index`, not from prose.
9. Keep every piece of existing intake craft verbatim: the groups, the thesis, voice paths A, B and C, and the Flags honesty rule.
10. Run the rewritten skill once end to end as a fictional founder, in a scratch folder created by `bash /Users/pmudh/Downloads/Atlanta/launchhouse-atlanta/scripts/new-run.sh b2b fb01`, and write the transcript to `REPO/planning/rehearsals/fb-dryrun.md`: what you were asked, what you answered, what the file came out as, and every place the questioning was unclear. Nothing else creates that file, and the acceptance below checks for it.
11. Record in the commit body which `FR-FB-*` triage lines this closes.

**ACCEPT**

```sh
cd /Users/pmudh/Documents/GitHub/Atlanta
S=plugins/growth-engine/skills/founder-brain/SKILL.md
grep -c 'ge snapshot founder-brain.md' $S
grep -c 'ge log decision' $S
grep -c 'ge index' $S
grep -ci 'Model:' $S
grep -ci 'email list size\|close rate\|audience size' $S
grep -ci 'unknown' $S
# the snapshot instruction comes before the write instruction
awk '/ge snapshot founder-brain.md/{s=NR} /write the file|Write the Brain/{w=NR} END{print (s>0 && w>s) ? "ORDER OK" : "ORDER WRONG"}' $S
bash scripts/validate.sh
ls planning/rehearsals/fb-dryrun.md
```

Every grep must return at least `1`.
`ORDER OK` must print.
validate.sh must report 0 FAILs.
The dry-run transcript file must exist.

**COMMIT:** `FB-01: founder-brain v2, model subtype, numbers block, brain-backed writes`

---

### FB-02, templates and the three worked examples

**Status: AMENDED.** The PRD generates a third example and leaves the two existing ones carrying no `Model` field and no Numbers block, while `assets/examples/README.md` calls them the calibration standard for founders and the marking standard for mentors.
**Effort: 0.75d** (0.5d as in the PRD, plus 0.25d to regenerate the two existing examples).
**Depends on: FB-01.**

**SNAPSHOT CHAIN.** Every example is produced by running the skill, so the chain runs three times inside a scratch run folder under `/Users/pmudh/Downloads/Atlanta/launchhouse-atlanta/runs/`, never inside REPO, and the finished `founder-brain.md` is then read in full and copied into `REPO/plugins/growth-engine/assets/examples/` afterwards.

**What to do**

1. Regenerate `REPO/plugins/growth-engine/assets/examples/b2b-northfield/founder-brain.md` by running the v2 skill as Sam Okoye. Generated, never hand-written.
2. Regenerate `REPO/plugins/growth-engine/assets/examples/b2c-lumen/founder-brain.md` as Priya Raman, now carrying `Model: ecommerce`, because she sells three products through a website, plus the Numbers block.
3. Generate a third, `REPO/plugins/growth-engine/assets/examples/b2c-service-brighthound/founder-brain.md`, as Cara Whitfield of Bright Hound, dog behaviour and training in Bristol. Fictional only. No real business, no real person, no real numbers.
   The missing example is **b2c-service, not b2c-ecom**. Priya Raman at `b2c-lumen` sells three products through a website, so she already is the ecommerce example. Neither existing example books an appointment, so neither exercises the `b2c-service-core` snapshot, the comment-to-DM capture that ends in a booking, or the DM qualify-and-book workflow. The full character brief for Cara is in section 04.
   This supersedes PRD task `FB-02` at line 331, which asks for `b2c-ecom-<name>`.
4. Update the table in `REPO/plugins/growth-engine/assets/examples/README.md` to three rows, each naming track and model.
5. Every example must pass `ge lint` with zero warnings.
6. **New, and every task after this one depends on it.** Teach the scratch-run script the two named B2C routes. The script is at `/Users/pmudh/Downloads/Atlanta/launchhouse-atlanta/scripts/new-run.sh`, which is in the PRIVATE folder, not in REPO, so this edit never reaches the public repo.
   Today its `case "$TRACK"` block accepts `b2b`, `b2c`, `wrong-folder` and `fixture` only, and its usage line reads `usage: %s <b2b|b2c|wrong-folder|fixture <name>> [label]`.
   Add two cases and keep the old one working:
   - `b2c-ecom` sets `SRC="$EXAMPLES/b2c-lumen/founder-brain.md"` and `WHO="Priya Raman, Lumen Skin"`. Keep the existing bare `b2c` as an alias for it, so run folders created before today still work.
   - `b2c-service` sets `SRC="$EXAMPLES/b2c-service-brighthound/founder-brain.md"` and `WHO="Cara Whitfield, Bright Hound"`, pointing at the folder step 3 created.
   Update the usage line to `usage: %s <b2b|b2c-ecom|b2c-service|wrong-folder|fixture <name>> [label]`.
   Without this, tasks C-01, AB-01, X-01 and O-03 cannot create their run folders and their acceptance blocks cannot be run.

**ACCEPT**

```sh
cd /Users/pmudh/Documents/GitHub/Atlanta
GE=plugins/growth-engine/scripts/ge.sh
for d in plugins/growth-engine/assets/examples/*/; do
  test -f "$d/founder-brain.md" || continue
  printf '%s ' "$d"
  grep -c '^\- \*\*Model:\*\*' "$d/founder-brain.md"
done
grep -l 'Numbers' plugins/growth-engine/assets/examples/*/founder-brain.md | wc -l
grep -c '^|' plugins/growth-engine/assets/examples/README.md
bash scripts/validate.sh
```

Each of the three example folders must report `1` for the Model field.
The Numbers count must be `3`.
The README table must have 5 rows (a header, a separator, and three examples).
validate.sh must report 0 FAILs.

**COMMIT:** `FB-02: three worked brains, model and numbers on all of them`

---

## PHASE 4, the content engine (2.75d)

---

### C-01, content-engine rewire, captions, and the approve step

> **Amended by section 08.** See `/Users/pmudh/Documents/GitHub/Atlanta/planning/delivery/08-persistent-memory.md`: refill mode also reads the `angles` block in `memory.md` and refuses an angle already listed there.

**Status: AMENDED.** Three additions. The ecom pillar variant is taken unchanged from the PRD's own C-01 delta: pillar 3, transformation, becomes product-led outcome, leaning on user-generated content and social proof. The approve step is new and closes a blocker: nothing anywhere set a ledger row to `approved`, so C-03's precondition could never be met on any machine. The caption rule is new and closes a verified high: 23 of a B2C founder's 30 pieces are video scripts and carousels, and the media lane classifies them and never gives them publishable text, so once the founder has shot the video there is still nothing to post with it.
**Effort: 2.0d** (1.5d as in the PRD, plus 0.5d for captions and the approve step).
**Depends on: B-05, B-06, FB-01.**

**SNAPSHOT CHAIN.** This skill writes `growth-engine/content-30.md`. It runs `ge init` if absent, then `ge snapshot content-30.md` and stops on non-zero, then writes, then `ge ledger add-content` once per piece, then `ge log result "30 pieces generated"`, then `ge index`. The ledger writes snapshot `ledger.md` themselves inside `ge ledger`, so the skill does not snapshot it separately.

**What to do**

1. Edit `REPO/plugins/growth-engine/skills/content-engine/SKILL.md`.
2. Keep the generation rules as they are: four pillars, 30 pieces, batches of 10, voice from the brain, never invent proof.
3. Move the never-invent rule out of the b2b branch and into the "Both tracks" section, because today the b2c branch and the shared section carry no constraint on claims at all.
4. Add the ecom pillar variant: transformation becomes product-led outcome, with a lean toward user-generated content and social proof.
5. **New caption rule, b2c branch.** Every piece, including video scripts and carousels, also gets a publishable caption of one to three sentences. The caption is the ledger's publishable text and the CSV `content` cell. The spoken script, the on-screen text and the frame breakdown live in `content-30.md` and are summarised in `media_note`. A media-lane row is then publishable the moment a media URL exists.
6. **New.** At least ten of the 30 captions carry the comment-to-DM keyword call to action, taken from the ops copy map, so the inbound workflow the founder imports at the clinic has traffic. The skill reads that keyword from `assets/ghl/snapshots/<slug>.md` rather than inventing a second version of it.
7. On export: run the snapshot chain, then `ge ledger add-content` one row per piece, setting `lane` to `media` for any piece whose format needs an asset.
8. **New approve step, a new Step 6 in the skill.** After the founder's edit pass, the trigger phrase "approve my content" re-reads `content-30.md`, runs `ge ledger approve --all-text`, and then rebuilds `content-30.csv` from the edited markdown by calling the C-02 export path. The skill states plainly that approving is approving a specific text, and that editing the markdown afterwards makes the approval stale, which `ge lint` will say.
9. Refill mode reads the ledger, never the file. It refuses to reuse an angle whose row is not `archived`, and it archives the previous batch by setting status, not by renaming a file.
10. Record in the commit body which `FR-CE-*` triage lines this closes.

**ACCEPT**

```sh
cd /Users/pmudh/Documents/GitHub/Atlanta
S=plugins/growth-engine/skills/content-engine/SKILL.md
grep -c 'ge snapshot content-30.md' $S
grep -c 'ge ledger add-content' $S
grep -c 'ge ledger approve' $S
grep -ci 'caption' $S
grep -ci 'never invent\|do not invent' $S
grep -c 'approve my content' $S
# create the scratch folder, as a b2c ecommerce founder
bash /Users/pmudh/Downloads/Atlanta/launchhouse-atlanta/scripts/new-run.sh b2c-ecom c01-dryrun
```

That prints the run folder path, which is `/Users/pmudh/Downloads/Atlanta/launchhouse-atlanta/runs/b2c-ecom-c01-dryrun`.
Now open Claude Code in that folder and work the skill by hand as the fictional founder: run `/growth-engine:content`, do the edit pass, then say "approve my content".
The dry run is a conversation, not a script, so it cannot be part of a command block.
When it has finished, run this second block:

```sh
GE=/Users/pmudh/Documents/GitHub/Atlanta/plugins/growth-engine/scripts/ge.sh
cd /Users/pmudh/Downloads/Atlanta/launchhouse-atlanta/runs/b2c-ecom-c01-dryrun
grep -c '^C|' growth-engine/ledger.md
grep -c '^C|.*|media|' growth-engine/ledger.md
sh $GE ledger list C --status approved | wc -l
sh $GE lint | grep -c 'WARN'
```

Every grep on the skill must return at least `1`.
The dry run must produce exactly `30` `C|` rows.
The media-lane count must be greater than `0` for a b2c founder.
The approved list must equal the text-lane count, not 30, because `--all-text` approves text-lane rows only.
The `b2c-ecom` case of the run script does not exist until FB-02 adds it, so FB-02 must be done before this acceptance can run.
The lint warning count must be `0`.

**COMMIT:** `C-01: content engine writes through the brain, with captions and an approve step`

---

### C-02, CSV export pinned to the real template

**Status: AMENDED.** Two additions. The export is now rebuilt from the approved markdown rather than frozen at generation, and the quoting rule is stated, because the CSV spec named four columns and nothing else in a file whose fields are 80 to 300 words of prose.
**Effort: 0.75d** (0.5d as in the PRD, plus 0.25d for quoting and the rebuild path).
**Depends on: C-01, S-03 (the fixture), B-06 (lint).**

**SNAPSHOT CHAIN.** This writes `growth-engine/content-30.csv`. `ge snapshot content-30.csv`, stop on non-zero, write, `ge log result "CSV exported (<n> rows)"`, `ge index`.

**What to do**

1. Edit `REPO/plugins/growth-engine/skills/content-engine/SKILL.md`, the export section.
2. Build `content-30.csv` with **exactly** the header row from `REPO/plugins/growth-engine/assets/ghl/social-planner-template.csv`. Copy it. Do not retype it.
3. Leave the scheduled-date column blank. Scheduling happens at publish or at the clinic, not at export.
4. **New quoting rule, stated in the skill in plain words.** Every field is wrapped in double quotes. A double quote inside a field is doubled. A newline inside a field is kept, inside the quotes, and the skill says that a founder opening the file in Excel will see it as one cell. If the target importer rejects embedded newlines, the fallback is to replace them with a single space, and the skill says which it did.
5. **New.** The export is callable on its own, so C-01's approve step can rebuild it from the edited markdown. State that a CSV built before the edit pass is the one thing this skill must never leave on disk.
6. `ge lint` runs on every export. State the 90-row limit and the public-media-URL limit, both from the fixture's own documentation.

**ACCEPT**

```sh
cd /Users/pmudh/Downloads/Atlanta/launchhouse-atlanta/runs/b2c-ecom-c01-dryrun
head -1 growth-engine/content-30.csv > /tmp/exported-header.txt
head -1 /Users/pmudh/Documents/GitHub/Atlanta/plugins/growth-engine/assets/ghl/social-planner-template.csv > /tmp/fixture-header.txt
cmp /tmp/exported-header.txt /tmp/fixture-header.txt && echo "HEADER BYTE IDENTICAL"
wc -l < growth-engine/content-30.csv
GE=/Users/pmudh/Documents/GitHub/Atlanta/plugins/growth-engine/scripts/ge.sh
sh $GE lint | grep -c 'WARN'
# now edit the markdown and prove lint catches the divergence
printf '\n<!-- edited for voice -->\n' >> growth-engine/content-30.md
sh $GE lint | grep -i 'approv\|diverg'
```

`HEADER BYTE IDENTICAL` must print.
The row count must be 91 or fewer (a header plus at most 90 data rows).
The first lint must report `0` warnings.
After the edit, lint must print at least one line naming a stale approval or a CSV divergence, ending in a recovery.

**COMMIT:** `C-02: CSV fallback pinned to the real template, with quoting and rebuild`

---

## PHASE 5, the two orphan skills (2.50d counted, plus one deferred)

These three skills write founder files today and none of them has an owning task in the PRD.
All three write with no snapshot, so `ge undo` cannot recover any of five founder files, and the claim that every skill snapshots first is false for a quarter of the skill surface.

---

### GP-01, growth-plan v2

**Status: NEW.** `skills/growth-plan/SKILL.md` is 46 lines, contains the string `track` zero times, and has no owning task anywhere in the PRD. Both tracks currently receive an identical 90-day plan, which breaks design rule 1 on the Sunday deliverable, in the room, in front of 130 people. It also writes `90-day-plan.md` with no snapshot.
**Effort: 1.0d.**
**Depends on: FB-01 (the Numbers block it projects from), B-03, B-04, B-06.**

**SNAPSHOT CHAIN.** Writes `growth-engine/90-day-plan.md`. `ge init` if absent, `ge snapshot 90-day-plan.md` and stop on non-zero, write, `ge log result "90-day plan written (track=...)"`, `ge index`.

**What to do**

1. Edit `REPO/plugins/growth-engine/skills/growth-plan/SKILL.md`.
2. Add a track fork immediately after Prerequisites. It reads `Track` and `Model` from `founder-brain.md`. If the field is missing, the skill stops and says to run the brain first, with the exact command.
3. **B2B skeleton:** messages sent, reply-rate assumption, calls booked, close rate, contract value, retainers needed. Named in that order, as a chain, with the founder's own numbers from the Numbers block where they exist.
4. **B2C service skeleton:** posts per week, reach, profile visits, enquiries, conversion, price. The email list is its own line.
5. **B2C ecommerce skeleton:** posts per week, reach, sessions, conversion rate, average order value, repeat-purchase share. The email list is its own line.
6. Every plan must name which single number it is pushing and which numbers it is holding constant. A plan that moves four numbers at once is not a plan.
7. **Anti-invention guard, stated once, plainly.** Model only activity the founder controls: pieces published, messages sent, DMs sent, calls held. Never model a reply rate, a conversion rate or a revenue figure as if it were a promise. Where an assumption is needed, name it as an assumption, show the arithmetic, and say what happens if it is half as good.
8. Add the monthly content refill as a standing Days 1 to 30 action, with the exact trigger phrase, because nothing anywhere currently tells a founder when to run it.
9. Read `unknown` values gracefully: where a Numbers field says `unknown`, the plan asks for it once, and if it is still unknown it states the range it is assuming and marks the line.

**ACCEPT**

```sh
cd /Users/pmudh/Documents/GitHub/Atlanta
S=plugins/growth-engine/skills/growth-plan/SKILL.md
grep -c 'Track' $S
grep -c 'ge snapshot 90-day-plan.md' $S
grep -c 'ge log result' $S
grep -ci 'assumption' $S
grep -ci 'never model\|do not model' $S
# two scratch folders, one per track
bash /Users/pmudh/Downloads/Atlanta/launchhouse-atlanta/scripts/new-run.sh b2b gp01
bash /Users/pmudh/Downloads/Atlanta/launchhouse-atlanta/scripts/new-run.sh b2c gp01
```

Those create `/Users/pmudh/Downloads/Atlanta/launchhouse-atlanta/runs/b2b-gp01` and `/Users/pmudh/Downloads/Atlanta/launchhouse-atlanta/runs/b2c-gp01`.
Open Claude Code in each in turn and run `/growth-engine:plan` as that fictional founder.
When both plans exist, run this second block:

```sh
diff /Users/pmudh/Downloads/Atlanta/launchhouse-atlanta/runs/b2b-gp01/growth-engine/90-day-plan.md \
     /Users/pmudh/Downloads/Atlanta/launchhouse-atlanta/runs/b2c-gp01/growth-engine/90-day-plan.md > /tmp/plan-diff.txt
wc -l < /tmp/plan-diff.txt
grep -ci 'retainer\|contract value' /Users/pmudh/Downloads/Atlanta/launchhouse-atlanta/runs/b2b-gp01/growth-engine/90-day-plan.md
grep -ci 'average order value\|attach\|list' /Users/pmudh/Downloads/Atlanta/launchhouse-atlanta/runs/b2c-gp01/growth-engine/90-day-plan.md
bash /Users/pmudh/Documents/GitHub/Atlanta/scripts/validate.sh
```

Every grep on the skill must return at least `1`.
The diff must be at least 20 lines, proving the two plans are structurally different rather than the same plan with two nouns swapped.
The b2b plan must mention a retainer or contract value; the b2c plan must mention average order value, attach rate or the list.
validate.sh must report 0 FAILs.

**COMMIT:** `GP-01: growth-plan v2, track fork, real numbers, brain-backed writes`

---

### AB-01, audience-b2c v2

**Status: NEW.** This is the entire B2C half of system 2, for roughly 65 founders, and it has no owning task in the PRD. It is 87 lines, has zero occurrences of `ecommerce` or `ecom`, makes no `ge` calls, and is the only skill in the plugin with no anti-invention guard, while being the one skill that writes messages sent by hand into strangers' private inboxes 25 times from the founder's own account.
**Effort: 1.5d.**
**Depends on: FB-01, B-05 (the D row), O-02 (the copy map it reads the keyword from).**

**SNAPSHOT CHAIN.** Writes three founder files: `dm-openers.md`, `hook-bank.md`, `inbound-scripts.md`. For each, in turn: `ge snapshot <file>`, stop on non-zero, write, then after all three, `ge log result "engine 2 built (25 openers, <n> hooks)"`, then `ge index`. Openers also write ledger rows: one `ge ledger add-dm <handle> <platform>` per target, then `set-dm <handle> status opener_written` once the opener exists.

**What to do**

1. Edit `REPO/plugins/growth-engine/skills/audience-b2c/SKILL.md`.
2. **Anti-invention guard.** Copy the no-fabrication sentence from `REPO/plugins/growth-engine/skills/outreach-b2b/SKILL.md` verbatim into Step 2, and add: if a target has no usable specific detail, drop that target and pick another account. The current wording permits an empty-detail case, which makes an invented plausible detail the path of least resistance in a message that is instantly checkable by its recipient.
3. **Model branch.** Add a `service` and an `ecommerce` fork that reads `Model` from the brain. Service targeting is by problem and locality. Ecommerce targeting is by product interest, competitor followings the founder does not imitate, and category hashtags. The openers differ in what they open on. The hook bank differs in format mix. The inbound scripts differ in what the qualifying question is.
4. **The 25 openers stay manual.** State it once, plainly, at the top of the openers step: these are sent by hand, spread out, from the founder's own account, and nothing in this toolkit sends them. Automated cold DMs get accounts restricted, and the Instagram API only permits messaging after the user starts the conversation. Do not offer to automate. Do not offer a scheduler.
5. **Ledger rows.** One `D|` row per target, so `status` can report the Saturday's work and so a second session does not re-target the same handle.
6. **The caption call to action.** Name as a required output the exact comment-to-DM keyword line, taken from the ops copy map at `assets/ghl/snapshots/<slug>.md`, and instruct the founder to add it to at least ten of their 30 captions before the clinic. The skill reads that keyword. It never writes a second version of it.
7. **Inbound scripts read the copy map.** The qualify-and-book copy lives in the GoHighLevel snapshot's custom values, owned by O-02 and O-03. This skill produces the founder's voice for those values and nothing else, so there is one source and the two cannot drift.
8. **Offer tests.** Keep the existing Step 4 of `REPO/plugins/growth-engine/skills/audience-b2c/SKILL.md`, headed `## Step 4: offer tests`, which asks for three variants of how the offer is framed, a different angle rather than different wording, added to `./growth-engine/hook-bank.md` under an Offer tests heading. Keep it word for word. Add one line: an offer test is a test, so it names in advance what result would make it a failure.
9. Record in the commit body which `FR-E2-*` triage lines this closes.

**ACCEPT**

```sh
cd /Users/pmudh/Documents/GitHub/Atlanta
S=plugins/growth-engine/skills/audience-b2c/SKILL.md
grep -ciE 'invent|fabricat' $S
grep -ci 'ecommerce\|ecom' $S
grep -c 'ge snapshot dm-openers.md' $S
grep -c 'ge snapshot hook-bank.md' $S
grep -c 'ge snapshot inbound-scripts.md' $S
grep -c 'ge ledger add-dm' $S
grep -ci 'by hand' $S
grep -ciE 'automat(e|ed|ion)' $S
# two scratch folders, one per B2C model
bash /Users/pmudh/Downloads/Atlanta/launchhouse-atlanta/scripts/new-run.sh b2c ab01-service
bash /Users/pmudh/Downloads/Atlanta/launchhouse-atlanta/scripts/new-run.sh b2c-ecom ab01
```

Those create `/Users/pmudh/Downloads/Atlanta/launchhouse-atlanta/runs/b2c-ab01-service` and `/Users/pmudh/Downloads/Atlanta/launchhouse-atlanta/runs/b2c-ecom-ab01`.
Open Claude Code in each and run `/growth-engine:engine2` as that fictional founder.
When both have finished, run this second block:

```sh
GE=/Users/pmudh/Documents/GitHub/Atlanta/plugins/growth-engine/scripts/ge.sh
cd /Users/pmudh/Downloads/Atlanta/launchhouse-atlanta/runs/b2c-ecom-ab01
grep -c '^D|' growth-engine/ledger.md
sh $GE ledger list D | head -3
sh $GE lint | grep -c 'WARN'
```

The invent or fabricate count must be at least `1`, where it is `0` today.
The ecommerce count must be at least `3`.
All three snapshot greps must return at least `1`.
The `by hand` count must be at least `1`.
Every match on the automation grep must be a prohibition, so read them, do not just count them.
The ecom dry run must produce exactly `25` `D|` rows and `0` lint warnings.

**COMMIT:** `AB-01: audience-b2c v2, model fork, anti-invention guard, ledger-backed DMs`

---

### PB-01, playbook-export v2

**Status: NOT BUILT in v1.0.** Decided 21 August 2026: `playbook-export` is rebuilt once the architecture is settled end to end. The skill and its command stay in the repository untouched at 0.1.0, so no count, table or validator check moves. This task body is kept for that rebuild. `/Users/pmudh/Documents/GitHub/Atlanta/planning/delivery/00-scope.md` defers it, and this section does not overrule that. It is written here so the decision is visible rather than silent. It is the first item on the cut order and it is not counted in the 44.95 total.
**Effort if taken: 0.5d.**
**Depends on: GP-01, AB-01, C-01, and whichever of C-03 and A-01 survive.**

**Why it is deferred.** The skill compiles a personalised insert from every other file in the folder, and every one of those files is changing shape. Compiling from a moving target before the target settles wastes the work.

**Why it is not cut.** The insert is Session 3 homework for 130 founders and a PDF the README promises. The 0.1.0 skill still runs and the file names it reads do not change, only their contents, so a founder who runs it gets an insert. What they do not get is a snapshot before the overwrite, so a second run silently replaces the first with no undo path.

**What to do if it is taken**

1. Edit `REPO/plugins/growth-engine/skills/playbook-export/SKILL.md` onto the ge chain: `ge snapshot playbook-insert.md`, stop on non-zero, write, `ge log result "playbook insert generated"`, `ge index`.
2. Replace "Read every file in ./growth-engine/" with an explicit read list that excludes `.state/`, `ledger.md`, `ops-log.md` and `content-30.csv`. Those are machine files and they will land in the founder's printed insert if the instruction stays as it is.
3. Update the Contents list so the engine-2 and 90-day-plan sections name what GP-01 and AB-01 actually produce.

**ACCEPT if taken**

```sh
cd /Users/pmudh/Documents/GitHub/Atlanta
S=plugins/growth-engine/skills/playbook-export/SKILL.md
grep -c 'ge snapshot playbook-insert.md' $S
grep -c 'Read every file' $S
bash /Users/pmudh/Downloads/Atlanta/launchhouse-atlanta/scripts/new-run.sh b2b pb01
```

That creates `/Users/pmudh/Downloads/Atlanta/launchhouse-atlanta/runs/b2b-pb01`.
Open Claude Code there, run `/growth-engine:playbook`, then run:

```sh
grep -ci 'ledger.md\|ops-log.md\|\.state' /Users/pmudh/Downloads/Atlanta/launchhouse-atlanta/runs/b2b-pb01/growth-engine/playbook-insert.md
```

The snapshot grep must return `1`.
The "Read every file" grep must return `0`.
The machine-file count inside the produced insert must be `0`.

**COMMIT if taken:** `PB-01: playbook-export onto the ge chain, with an explicit read list`

**If it stays deferred:** write one line into `REPO/planning/review-triage.md` resolving every `FR-OPP-*` playbook finding to `backlog`, and one line into `REPO/CHANGELOG.md` under 0.2.0 saying the playbook insert ships unchanged at 0.1.0 behaviour. Do not leave the decision unrecorded.

---

## PHASE 6, self-service and the command surface (2.15d)

---

### SS-01, doctor v2

> **Amended by section 08.** See `/Users/pmudh/Documents/GitHub/Atlanta/planning/delivery/08-persistent-memory.md`: the doctor gains one line for memory: present, block integrity intact, entry count against budget.

**Status: AMENDED.** The dm-inbox leg is removed. The Apollo leg becomes conditional on track, so a B2C founder is not shown a failing Apollo check for a system they do not use.
**Effort: 1.0d.**
**Depends on: B-08, B-09.**

**What to do**

1. Rebuild the diagnosis section of `REPO/plugins/growth-engine/skills/setup/SKILL.md` and `REPO/plugins/growth-engine/commands/doctor.md` around evidence.
2. Run `ge check` and show its output verbatim. The doctor does not paraphrase the doctor core.
3. Then the live legs, each printing `PASS` or `FAIL` then evidence then a recovery:
   - plugin version, read from the manifest at `${CLAUDE_PLUGIN_ROOT}`.
   - GoHighLevel read probe, one call, `locations_get-location`.
   - Apollo read probe, one call, and only when `Track` is `b2b`. For `b2c` it prints `SKIP, b2c track, Apollo is not part of your engine`.
4. Keep the two-attempts-then-Slack rule word for word. It is the paragraph in `REPO/plugins/growth-engine/skills/setup/SKILL.md` that begins **"I cannot get any of this working."** and tells the founder to stop after two failed attempts, post in the Slack channel, and be sorted individually, because a founder stuck alone for an hour is worse than one who asked for help after ten minutes.
5. Update the common-problems runbook for the shipped reality: no dm-inbox, seven token scopes, the folder anchor, the update path.
6. The doctor never asserts anything it did not just observe. If a probe was not run, the line says `SKIP` with the reason.
7. Rehearse the doctor in four states and write one transcript per state, to exactly these four paths. Nothing else creates them, and the acceptance below checks all four:
   - `REPO/planning/rehearsals/doctor-healthy.md` : a folder where everything passes.
   - `REPO/planning/rehearsals/doctor-moved-folder.md` : run the doctor from a directory that is not the anchor in `.state/HOME`. The recovery line must name the absolute folder to open.
   - `REPO/planning/rehearsals/doctor-revoked-pit.md` : delete the Private Integration Token in GoHighLevel, run the doctor, capture the 401 and its recovery, then recreate the token.
   - `REPO/planning/rehearsals/doctor-apollo-disconnected.md` : with Apollo not connected, on a `b2b` brain and again on a `b2c` brain, so both the FAIL and the SKIP are on record.

**ACCEPT**

```sh
cd /Users/pmudh/Documents/GitHub/Atlanta
grep -ci 'dm-inbox\|check my DMs' plugins/growth-engine/skills/setup/SKILL.md plugins/growth-engine/commands/doctor.md
grep -c 'ge check' plugins/growth-engine/skills/setup/SKILL.md
grep -c 'SKIP' plugins/growth-engine/skills/setup/SKILL.md
ls planning/rehearsals/doctor-healthy.md planning/rehearsals/doctor-moved-folder.md planning/rehearsals/doctor-revoked-pit.md planning/rehearsals/doctor-apollo-disconnected.md
grep -c '→' planning/rehearsals/doctor-moved-folder.md
bash scripts/validate.sh
```

The dm-inbox count must be `0`.
The `ge check` and `SKIP` greps must be at least `1`.
All four rehearsal transcripts must exist.
The moved-folder transcript must contain at least one recovery arrow, and reading it must show the recovery actually names the absolute folder path.

**COMMIT:** `SS-01: a doctor that proves, with track-aware probes`

---

### SS-02, the update mechanism and the drill

**Status: AMENDED.** The command file moves to CMD-01 so the command surface has one owner. SS-02 keeps the mechanism, the version comparison and the drill.
**Effort: 0.75d** (1.0d as in the PRD, less 0.25d for the command file moving to CMD-01).
**Depends on: G-02 (CHANGELOG), B-08.**

**What to do**

1. Write the update logic as a skill section, not a command file: read the installed version from `${CLAUDE_PLUGIN_ROOT}`, fetch the latest `marketplace.json` from `https://github.com/Philm-moxywolf/Atlanta` through the client's own web fetch, and compare.
2. If the founder is behind, show the steps for **their** surface only, never a menu of four:
   - Cowork: the Plugins screen, the Update button.
   - Desktop Code tab: `/plugin marketplace update launchhouse`.
3. Show the CHANGELOG entries between the two versions.
4. State plainly that an update never touches `growth-engine/` or `.state/receipt.md`, and prove it in the drill.
5. Write `REPO/planning/update-drill.md`: the one Slack message, and the Session 3 live drill script.
6. Rehearse once: install 0.2.0, release 0.2.1, run the drill, land current, confirm the folder is untouched. Take a checksum of every file under the founder's `growth-engine/` before and after (`find growth-engine -type f | sort | xargs shasum`) and paste both lists. Write the whole rehearsal to `REPO/planning/rehearsals/update-drill-receipt.md`. Nothing else creates that file, and the acceptance below checks for it.

**ACCEPT**

```sh
cd /Users/pmudh/Documents/GitHub/Atlanta
ls planning/update-drill.md
grep -c 'plugin marketplace update launchhouse' planning/update-drill.md
grep -ci 'Cowork' planning/update-drill.md
ls planning/rehearsals/update-drill-receipt.md
grep -ci 'untouched\|unchanged' planning/rehearsals/update-drill-receipt.md
bash scripts/validate.sh
```

The drill file must exist and must name both surfaces.
The rehearsal receipt must exist and must record that the founder folder was unchanged, with a byte count or a checksum, not an assertion.

**COMMIT:** `SS-02: the update mechanism and the rehearsed drill`

---

### CMD-01, the undo and update commands

**Status: NEW.** `commands/undo.md` is declared twice in the PRD, in the component map and in the finished tree, and built by no task. B-03 builds the `ge undo` subcommand only. Without a command file there is no trigger phrase and no router, so the only way to reverse a bad rewrite is to type a shell command, which is precisely what the Windows Home founder in the PRD's own narrative cannot do. `commands/update.md` moves here so all four routers have one owner and one shape.
**Effort: 0.4d.**
**Depends on: B-03, SS-02.**

**What to do**

1. Create `REPO/plugins/growth-engine/commands/undo.md`. It is a thin router. It runs `ge undo`, shows the line-count difference preview, and asks before restoring. Trigger phrases include "undo that", "put it back", "I did not mean to overwrite that".
2. Create `REPO/plugins/growth-engine/commands/update.md`. It routes into the SS-02 skill section. Trigger phrases include "update the toolkit", "am I on the latest version".
3. Both files carry the namespaced form in every example: `/growth-engine:undo`, `/growth-engine:update`. A command name written without the `growth-engine:` prefix never resolves, and both validators fail on one in founder-facing text.
4. Update the hard-coded command count in `REPO/scripts/validate.sh`. As of 21 August 2026 the line reads `[ "$CMD_COUNT" -eq 10 ] && ok "10 commands found" || warn "expected 10 commands, found $CMD_COUNT"`. Change both the number and the message to 12. Also change `warn` to `err` on that line and on the matching skill-count line above it, because a count that drifts silently is the exact failure this check exists to catch, and a warning does not stop a commit.
5. Add both to the command table in `REPO/README.md` with a plain-language column.

**ACCEPT**

```sh
cd /Users/pmudh/Documents/GitHub/Atlanta
ls -1 plugins/growth-engine/commands/
grep -c 'growth-engine:undo' plugins/growth-engine/commands/undo.md README.md
grep -c 'growth-engine:update' plugins/growth-engine/commands/update.md README.md
# no bare command anywhere in founder-facing text
grep -rnE '(^|[^:a-z-])/(undo|update|publish|connect|brain|content|plan|status|doctor|gate|ops|setup)\b' README.md docs/ plugins/growth-engine/ | wc -l
bash scripts/validate.sh
```

The command listing must show 12 files at this point: the ten that ship at 0.1.0 (`brain.md`, `content.md`, `doctor.md`, `engine2.md`, `gate.md`, `ops.md`, `plan.md`, `playbook.md`, `setup.md`, `status.md`) plus `undo.md` and `update.md`.
Both namespaced greps must return at least `1` in each file.
The bare-command count must be `0`. That check already exists in `REPO/scripts/validate.sh` and is already a FAIL, so a bare name blocks the commit on its own.
validate.sh must report 0 FAILs and 0 WARNs about the command or skill count.

**COMMIT:** `CMD-01: undo and update command routers, command count pinned`

---

## PHASE 7, docs (4.25d)

> **Merged from section 04 on 21 August 2026.** Section 04 Part B defined `D-01` through `D-12`.
> `D-01` to `D-04` are the four tasks already in this phase and they agree.
> `D-05`, `D-08`, `D-09` and `D-12` duplicate work this document already counts as `G2-03`, `G-02`, `G-01` and `O-02`, so they add nothing and are recorded as absorbed.
> `D-06`, `D-07`, `D-10` and `D-11` are genuinely new, total 2.25d, and are the four stubs at the end of this phase.
> Full task bodies for all of them are in `/Users/pmudh/Documents/GitHub/Atlanta/planning/delivery/04-examples-and-docs.md`, Part B.

### D-06, the day-to-day manual, `docs/USING-IT.md`

**Status: NEW, merged from section 04 Part B. Effort: 1.10d** (1.0d plus 0.1d for the memory section section 08 adds).
**Depends on:** all four systems built, because it documents them. **Blocks:** the 4 September onboarding email.

This is the document a founder opens on a Tuesday in October. It covers regenerating one piece, regenerating the whole batch, the monthly refill, editing voice after generation, what happens to the CSV when the markdown is edited, how to undo, how to archive, what the toolkit remembers, and what must never be hand-edited because `ge` owns it.
**This is client requirement 3 and until this task existed there was no task for it anywhere.**
Full outline: `/Users/pmudh/Documents/GitHub/Atlanta/planning/delivery/04-examples-and-docs.md`, section B.5.

**COMMIT** `D-06: write the day-to-day manual`

### D-07, `docs/TROUBLESHOOTING.md`

**Status: NEW, merged from section 04 Part B. Effort: 0.75d.**
**Depends on:** `SS-01`, so the doctor's real output can be quoted rather than imagined.

Full outline: `/Users/pmudh/Documents/GitHub/Atlanta/planning/delivery/04-examples-and-docs.md`, section B.6.

**COMMIT** `D-07: write the troubleshooting guide`

### D-10, the six screenshots, `docs/img/`

**Status: NEW, merged from section 04 Part B. Effort: 0.25d. HUMAN, Philip.**
**Depends on:** a GoHighLevel account with the settings screens reachable.
**Blocks:** `D-02`, whose acceptance requires a screenshot slot per step, and `G2-01`, whose token walk references them.

**COMMIT** `D-10: capture the six setup screenshots`

### D-11, the asset readmes and the TODO gate

**Status: NEW, merged from section 04 Part B. Effort: 0.25d.**
**Depends on:** `O-01` for the three snapshot share links.

Rewrites `plugins/growth-engine/assets/ghl/README.md` and `plugins/growth-engine/assets/forms/README.md` so no TODO remains, and turns the CI TODO gate hard. Sequencing is decision 6 in the plan index.

**COMMIT** `D-11: fill the asset readmes and arm the TODO gate`

---

## PHASE 7 continues, the original four docs tasks


---

### D-01, README v2

**Status: AMENDED.** The command table is sized to the real surface, and the DM inbox is not promised.
**Effort: 0.5d.**
**Depends on: CMD-01, SS-01.**

**What to do**

1. Rewrite `REPO/README.md`.
2. Correct the two-store truth: install where you will work, and doing both takes two installs.
3. Prerequisites per operating system and surface. For Windows: no terminal is needed, you install Git for Windows once, two clicks, because the Code tab needs it.
4. The paid plans table: Claude, GoHighLevel paid with API access and the tier named in spike S-01, Apollo paid for B2B founders. Say why each is needed in one line. No free plans survive in this file.
5. The command table, sized to what actually ships. Count the files in `commands/` and match it. Every row carries the namespaced command and a plain-language alternative.
6. "What finished looks like" updated to the four systems named in `/Users/pmudh/Documents/GitHub/Atlanta/planning/delivery/00-scope.md`: the content engine, the outbound engine, back-end ops, and the brain. Do not describe a DM inbox. Claude never reads a founder inbox. Where the README needs to say what happens to DM replies, say that they arrive in GoHighLevel and the founder reads and replies there.
7. Link `REPO/docs/CONNECTIONS.md`. **Ordering warning.** That file does not exist until task G2-03, which is in lane 1.1, and D-01 is in lane 1.0. Either move the link into G2-03 as a step, so the 1.0.0 README never points at a missing file, or ship the link in 1.0.0 and create `REPO/docs/CONNECTIONS.md` here as a one-paragraph stub that G2-03 then replaces. Pick one and say which in the commit body. Do not ship a README with a dead link to 130 founders.
8. Keep the pre-release banner until 1.0.0.

**ACCEPT**

```sh
cd /Users/pmudh/Documents/GitHub/Atlanta
# the README table row count matches the command file count
echo "commands on disk: $(ls -1 plugins/growth-engine/commands/*.md | wc -l)"
echo "README table rows: $(sed -n '/| Command |/,/^$/p' README.md | grep -c '^| /growth-engine:')"
grep -ci 'free plan\|free tier' README.md
grep -ci 'dm inbox\|check my dms\|reply to my messages' README.md
grep -c 'CONNECTIONS.md' README.md
grep -c 'plugin marketplace add Philm-moxywolf/Atlanta' README.md
bash scripts/validate.sh
```

The two counts must be equal.
The free-plan and DM-inbox counts must both be `0`.
The CONNECTIONS and install-command greps must be at least `1`.
validate.sh must report 0 FAILs.

**COMMIT:** `D-01: README v2, the honest install and the real product`

---

### D-02, PRE-WORK v2

**Status: AMENDED.** One paragraph resolved rather than left contradictory, and the screenshots given an owner.
**Effort: 0.75d** (0.75d as in the PRD; the screenshot work absorbs the 0.25d that the removed DM section frees).
**Depends on: D-01, and a decision from Philip on the Session 2 question below.**

**What to do**

1. Rewrite `REPO/docs/PRE-WORK.md`, restructured per surface, with an explicit Windows path: install Git for Windows, then Claude desktop, then the Plugins screen, then `/growth-engine:setup`.
2. Account creation: GoHighLevel paid plus a location, Apollo paid seat on a work email for B2B founders, and the model-training-off privacy note that Apollo's terms require.
3. **Resolve the Session 2 contradiction before this file is written.** The PRD's own narrative and this file both promise "we create your token together at Session 2", while the connect skill sits in the 1.1 lane that founders do not receive until the Session 3 update drill. Pick one, in writing, and make it consistent in this file, in `REPO/README.md` and in the Session 2 run sheet:
   - **Option A.** G2-01 moves into the 1.0 lane and ships inside 1.0.0. Costs a sub-freeze and pulls 1.5d forward.
   - **Option B.** Token creation moves to the 23 September clinic and Session 2 ends at content plus CSV. Costs nothing to build, and this sentence must change before the 4 September onboarding email goes out.
   This file cannot be written until that is decided, because its text is frozen by the 4 September email.
4. Create `REPO/docs/images/` and produce the screenshots the token walk needs. Every step gets a screenshot slot and an "if this fails" line. Screenshots are Philip's to capture; the slots are the executor's to place.
5. Keep the two time-critical items word for word. They are section 5 of `REPO/docs/PRE-WORK.md`, headed `## 5. TIME-CRITICAL if you sell to businesses` (buy and correctly configure a separate sending domain now, because 25 messages is low volume and correct setup matters more than months of warming), and section 6, headed `## 6. TIME-CRITICAL if you sell to consumers` (convert Instagram to a Business or Creator account and link it to a Facebook Page). Both must keep the `TIME-CRITICAL` marker in the heading, because the line at the top of the file promises two marked items.
6. Costs table updated with no free tiers, using the tier and price recorded in spike S-01.
7. The one-folder rule, and the Slack escape hatch in every section.

**ACCEPT**

```sh
cd /Users/pmudh/Documents/GitHub/Atlanta
grep -ci 'Git for Windows' docs/PRE-WORK.md
grep -ci 'Session 2' docs/PRE-WORK.md
# every screenshot slot resolves to a file that exists
grep -o '(images/[^)]*)' docs/PRE-WORK.md | tr -d '()' \
  | while read -r img; do
      if [ -f "docs/$img" ]; then echo "ok $img"; else echo "MISSING $img"; fi
    done > /tmp/screenshot-check.txt
cat /tmp/screenshot-check.txt
echo "slots: $(grep -c . /tmp/screenshot-check.txt)  missing: $(grep -c '^MISSING' /tmp/screenshot-check.txt)"
grep -ci 'if this fails' docs/PRE-WORK.md
grep -ci 'free' docs/PRE-WORK.md
bash scripts/validate.sh
```

The Git for Windows grep must be at least `1`.
Every screenshot path must print `ok`, and the `missing:` count must be `0`.
The "if this fails" count must be at least as high as the number of numbered steps.
The `free` count must be `0`.
validate.sh must report 0 FAILs.

**COMMIT:** `D-02: PRE-WORK v2, per-surface, Windows first-class, screenshots landed`

---

### D-03, the Launchhouse folder

**Status: KEEP AS IS.**
**Effort: 0.5d.**
**Depends on: D-01.**

**What to do**

1. Edit `REPO/scripts/build-folder.sh` so it stops copying skills and commands into the zip. The plugin is the sole carrier of skills. Copying them into the zip creates version skew and rests on an unverified claim that the desktop app loads skills from a folder.
2. The zip contains: `READ-ME-FIRST.md`, a rewritten `CLAUDE.md` that routes to the installed plugin and, if commands are missing, gives the plugin install walk, a seeded `growth-engine/` folder, and `VERSION`.
3. Add a check to `REPO/scripts/validate.sh` that FAILs if either the staged folder `dist/Launchhouse/` or the built `dist/Launchhouse.zip` contains a `.claude/skills` or `.claude/commands` path. Check both, because the acceptance below plants a file in the staged folder and the guard must bite before the zip is rebuilt.

**ACCEPT**

```sh
cd /Users/pmudh/Documents/GitHub/Atlanta
sh scripts/build-folder.sh
unzip -l dist/Launchhouse.zip | grep -ci 'skills/\|commands/'
unzip -l dist/Launchhouse.zip
# prove the guard bites
mkdir -p dist/Launchhouse/.claude/skills/planted && printf 'x\n' > dist/Launchhouse/.claude/skills/planted/SKILL.md
bash scripts/validate.sh; echo "guard exit=$?"
rm -rf dist/Launchhouse/.claude
bash scripts/validate.sh; echo "clean exit=$?"
```

The skills and commands count inside the zip must be `0`.
The zip listing must show exactly four top-level entries plus the seeded folder.
`guard exit` must be non-zero with a FAIL naming the planted path.
`clean exit=0`.

**COMMIT:** `D-03: the folder carries work, the plugin carries skills`

---

### D-04, doc hygiene and the trigger map

**Status: KEEP AS IS.** Third on the cut order.
**Effort: 0.25d.**
**Depends on: D-01, D-02, CMD-01.**

**What to do**

1. Reflow every founder-facing document touched in this build to one sentence per physical line.
2. Add a check to `REPO/scripts/validate.sh`: every "Or just say" phrase in `README.md` must appear in the description triggers of the skill it names.

**ACCEPT**

```sh
cd /Users/pmudh/Documents/GitHub/Atlanta
bash scripts/validate.sh
# prove the new check bites
sed -i.bak 's/Or just say "build my founder brain"/Or just say "assemble my founder cortex"/' README.md
bash scripts/validate.sh; echo "planted exit=$?"
mv README.md.bak README.md
bash scripts/validate.sh; echo "restored exit=$?"
```

`planted exit` must be non-zero, with a FAIL naming the unmatched phrase.
`restored exit=0`.

**COMMIT:** `D-04: doc hygiene and the trigger map pinned`

---

## PHASE 8, CI (2.00d)

---

### CI-01, validate.sh v2

**Status: AMENDED.** Two changes. The checks that cover 1.1-lane artifacts are added but skipped by version, so the ACCEPT can actually be run in the 1.0 lane. And the TODO gate is widened, because it was scoped to one asset README and bit only at 1.1.0, so the four placeholder links in `assets/forms/README.md` would have passed CI at every version.
**Effort: 1.0d.**
**Depends on: everything built so far. It is the check that pins it.**

**What to do**

Add to `REPO/scripts/validate.sh`:

1. `sh -n` on every file under `plugins/growth-engine/scripts/` and on `plugins/growth-engine/bin/ge`.
2. shellcheck, required in CI, best effort locally.
3. JSON parse for `.mcp.json`, `.mcp.json.headers-variant`, `hooks/hooks.json`, and the `userConfig` block inside `plugin.json`.
4. CSV fixture header check, per C-02.
5. Copy-map key lint, per O-02: keys match `^lh_[a-z0-9_]+$` and are unique per file.
6. Zip guard, per D-03.
7. Trigger sync, per D-04.
8. **Widened TODO gate.** Zero TODOs in `assets/ghl/README.md` **and** `assets/forms/README.md` **and** anywhere else under `plugins/`, at every version, not only 1.1.0. Nothing inside the plugin ships with a placeholder. Today that check is `warn`, scoped to `$PLUGIN/assets`, and its message still names "six GHL share links" when three snapshots ship. Widen its scope to all of `$PLUGIN`, promote it from `warn` to `err`, and rewrite the message to name the file it found rather than a fixed count.
9. `ge lint` run against every example folder under `assets/examples/`.
10. **Version-gated checks.** The GHL copy-map and snapshot-link checks only run when the manifest version is 1.1.0 or higher, and they print `SKIP (lane 1.1)` below that. Without this, CI-01's own acceptance is unrunnable in the lane it sits in.
11. Update the hard-coded skill and command counts to what actually ships, and confirm both are `err` and not `warn`. As of 21 August 2026 they are `[ "$SKILL_COUNT" -eq 9 ]` and `[ "$CMD_COUNT" -eq 10 ]`, both emitting `warn`.
12. Add a check that the string `dmgate` appears nowhere under `plugins/`, `docs/` or `README.md`.

**ACCEPT**

```sh
cd /Users/pmudh/Documents/GitHub/Atlanta
bash scripts/validate.sh; echo "baseline exit=$?"
# prove each new check red then green, one at a time
printf 'TODO: get the link\n' >> plugins/growth-engine/assets/forms/README.md && bash scripts/validate.sh; echo "todo-gate exit=$?"
git checkout plugins/growth-engine/assets/forms/README.md
printf 'echo ${BASH_SOURCE}\n' >> plugins/growth-engine/scripts/lib/table.sh && bash scripts/validate.sh; echo "shellcheck exit=$?"
git checkout plugins/growth-engine/scripts/lib/table.sh
printf '{ broken\n' > /tmp/mcp.bak && cp plugins/growth-engine/.mcp.json /tmp/mcp.keep && cp /tmp/mcp.bak plugins/growth-engine/.mcp.json && bash scripts/validate.sh; echo "json exit=$?"
cp /tmp/mcp.keep plugins/growth-engine/.mcp.json
bash scripts/validate.sh; echo "final exit=$?"
```

`baseline exit=0` and `final exit=0`.
Each planted violation must produce a non-zero exit and a FAIL line naming the exact file and the exact rule.
List all planted-violation results in the commit body, one line each.

**COMMIT:** `CI-01: validate.sh v2, every new claim pinned`

---

### CI-02, the three-OS matrix

**Status: KEEP AS IS.**
**Effort: 1.0d.**
**Depends on: CI-01, B-01 through B-09, `tests/run.sh`.**

**What to do**

1. Rewrite `REPO/.github/workflows/validate.yml`.
2. **ubuntu:** `bash scripts/validate.sh`, shellcheck, `npm i -g @anthropic-ai/claude-code@<pinned version>`, `claude plugin validate ./plugins/growth-engine`, `sh tests/run.sh`.
3. **macos:** `sh tests/run.sh`. This is the BSD `date` leg and it is the only place that branch is exercised.
4. **windows:** `bash tests/run.sh` under Git Bash. This is the founder floor. It is the leg that must never be removed.

**ACCEPT**

```sh
cd /Users/pmudh/Documents/GitHub/Atlanta
git push
gh run watch
# then prove the floor bites: plant a bashism and push to a branch
git checkout -b ci-probe
printf 'declare -A m\n' >> plugins/growth-engine/scripts/lib/table.sh
git commit -am "ci-probe: plant a bashism" && git push -u origin ci-probe
gh run watch
git checkout - && git branch -D ci-probe && git push origin --delete ci-probe
```

All three jobs must be green on the first watch.
On the probe branch, the macos and windows jobs must both fail, and the failure text must name `table.sh`.

**COMMIT:** `CI-02: ubuntu and macos and windows, the founder floor is CI`

---

## PHASE 9, the full-arc runs and the 1.0.0 freeze (3.50d)

---

### The examples harness, merged from section 04 Part A

> Section 04 Part A defined `EX-01` to `EX-11`, total 5.10d. Six of them are genuinely new and are stubbed below, total 2.50d.
> `EX-07`, `EX-08` and `EX-09` generate the three worked examples, which is the same work `X-01` already does, so they are the detailed procedure for `X-01` rather than additional tasks and add no days.
> `EX-10` folds into `FB-02`, which already rewrites the examples README, at plus 0.10d.
> `EX-06` was a rename that has already been applied by hand, so it is closed.
> Full task bodies: `/Users/pmudh/Documents/GitHub/Atlanta/planning/delivery/04-examples-and-docs.md`, Part A.

| Id | What | Effort | Status |
|---|---|---|---|
| `EX-01` | Extend `new-run.sh` to three routes and add the model dimension | 0.25d | NEW. Supersedes step 6 of `FB-02` |
| `EX-02` | Write `import-example.sh`: the scrub gate, the copy, the manifest | 0.50d | NEW |
| `EX-03` | Write `scripts/check-examples.sh` and wire it into `validate.sh` | 0.50d | NEW |
| `EX-04` | Write the three `inputs/answers.md` answer scripts | 0.50d | NEW |
| `EX-05` | Name and domain clearance for every invented entity | 0.25d | NEW. HUMAN, Philip |
| `EX-11` | Full regeneration sweep before the mentor deadline of 1 September | 0.50d | NEW |
| `EX-06` | Rename that has already been applied | 0.10d | CLOSED |
| `EX-07` to `EX-09` | Generate the three examples end to end | 2.25d | ABSORBED by `X-01` |
| `EX-10` | Rewrite the examples README | 0.25d | ABSORBED by `FB-02`, plus 0.10d |

**Why the scrub gate matters.** `EX-02`'s import script is the thing that stops a run folder crossing from the private working folder into the public repository unread. Every example is generated in `/Users/pmudh/Downloads/Atlanta/launchhouse-atlanta/runs/`, and that boundary is the one place founder-shaped output could reach 130 people by accident.

---

### X-01, the full-arc fictional founder runs

**Status: NEW.** This closes the fourth blocker. No task anywhere runs a fictional founder through the whole arc. The PRD's only clean-machine rehearsal stops at CSV export and covers none of the integration lane, and every per-task acceptance is a component rehearsal, never a sequence. This build wires twelve skills through a new command-line tool, and hand-off defects between skills are the failure mode a chain of that length actually has. Without X-01 the first full run is 130 founders on 25 September. It also produces the finished worked-example folders the mentors are booked to review.
**Effort: 2.0d.**
**Depends on: every skill task in lanes 1.0 and 1.1 that survives. Run it as late as possible and still leave a fix window.**

**Ordering contradiction, and it must be resolved before this task starts.** X-01 sits in phase 9, which is lane 1.0 and freezes on Thursday 3 September 2026, yet it depends on `connect`, `publish` and `outreach-b2b`, which are phase 10 and lane 1.1. It cannot depend on both and run once. Run it twice, and budget it that way:
- **X-01a, before the 1.0.0 freeze, 1.25d.** The lane 1.0 arc only: `/growth-engine:setup`, `/growth-engine:brain`, `/growth-engine:content`, "approve my content", `/growth-engine:engine2`, `/growth-engine:ops`, `/growth-engine:plan`, `/growth-engine:status`, `/growth-engine:gate`. This is what 130 founders receive on 4 September, so this is the run that cannot be skipped.
- **X-01b, inside phase 10 before R-03, 0.75d.** The same three folders again, from cold, with `/growth-engine:connect` and `/growth-engine:publish` in place.

The 2.0d total does not change. Only its placement does. Both halves write into the same three rehearsal files, under dated headings.

**What to do**

1. Create three scratch run folders. Never run one inside REPO, or founder-shaped output ends up committed, and `REPO/.gitignore` does not exclude `runs/`.

   ```sh
   bash /Users/pmudh/Downloads/Atlanta/launchhouse-atlanta/scripts/new-run.sh b2b arc
   bash /Users/pmudh/Downloads/Atlanta/launchhouse-atlanta/scripts/new-run.sh b2c-service arc
   bash /Users/pmudh/Downloads/Atlanta/launchhouse-atlanta/scripts/new-run.sh b2c-ecom arc
   ```

   That produces exactly these three folders:
   - `/Users/pmudh/Downloads/Atlanta/launchhouse-atlanta/runs/b2b-arc` : Sam Okoye, construction operations, B2B.
   - `/Users/pmudh/Downloads/Atlanta/launchhouse-atlanta/runs/b2c-service-arc` : Cara Whitfield of Bright Hound, dog behaviour and training, B2C service. This is the founder `FB-02` creates.
   - `/Users/pmudh/Downloads/Atlanta/launchhouse-atlanta/runs/b2c-ecom-arc` : Priya Raman of Lumen Skin, B2C ecommerce. She sells three products through a website, so she is the ecommerce example, not the service one.

2. Open Claude Code in each folder in turn and run every command in the order a founder meets them, from a cold folder. Namespaced form only, because a bare command name never resolves: `/growth-engine:setup`, `/growth-engine:brain`, `/growth-engine:content`, then say "approve my content", then `/growth-engine:connect` and `/growth-engine:publish` if C-03 survived the cut order, then `/growth-engine:engine2`, then `/growth-engine:ops`, then `/growth-engine:plan`, and `/growth-engine:status` and `/growth-engine:gate` at each gate point.
3. Record every friction in `REPO/planning/rehearsals/arc-b2b.md`, `REPO/planning/rehearsals/arc-b2c-service.md` and `REPO/planning/rehearsals/arc-b2c-ecom.md`: what you typed, what came back, what was wrong. One file per route, named exactly as listed. Every friction becomes either a documentation fix or a task, and neither is optional.
4. Copy the finished `growth-engine/` contents from each run into `REPO/plugins/growth-engine/assets/examples/b2b-northfield/`, `REPO/plugins/growth-engine/assets/examples/b2c-lumen/` and `REPO/plugins/growth-engine/assets/examples/b2c-service-brighthound/`, so the examples are generated output rather than hand-written prose, and so the mentors review what founders will actually get. Read every file before it crosses from the run folder into REPO. The run folders live under PRIVATE, REPO is public, and nothing crosses that boundary unread. Do not copy `.state/`, `ledger.md` or `ops-log.md`: they are machine files and the examples are for reading.
5. Fictional only. No real business, no real person, no real customer, no real number. Never invent proof inside the runs either: where a fictional founder's proof is thin, the output must say so in Flags, and if it does not, that is a skill defect and it goes on the list.
6. Run `ge check` and `ge lint` at the end of each arc and paste the output into the rehearsal file. Both must be clean.

**ACCEPT**

```sh
GE=/Users/pmudh/Documents/GitHub/Atlanta/plugins/growth-engine/scripts/ge.sh
RUNS=/Users/pmudh/Downloads/Atlanta/launchhouse-atlanta/runs
for r in b2b-arc b2c-service-arc b2c-ecom-arc; do
  printf '=== %s\n' "$r"
  ls "$RUNS/$r/growth-engine/"
  ( cd "$RUNS/$r" && sh $GE check | grep -c 'FAIL' )
  ( cd "$RUNS/$r" && sh $GE lint | grep -c 'WARN' )
  ( cd "$RUNS/$r" && sh $GE ledger list C | wc -l )
  grep -c '^## ' "$RUNS/$r/growth-engine/ops-log.md"
done
cd /Users/pmudh/Documents/GitHub/Atlanta
ls planning/rehearsals/arc-*.md | wc -l
ls -d plugins/growth-engine/assets/examples/*/ | wc -l
bash scripts/validate.sh
```

Each run's `growth-engine/` listing must contain `founder-brain.md`, `content-30.md`, `content-30.csv`, `ledger.md`, `ops-log.md`, `hook-bank.md` or `outreach-sequence.md` depending on track, `ops-workflow.md` and `90-day-plan.md`.
Every `FAIL` count and every `WARN` count must be `0`.
Every content list must be `30`.
Three rehearsal files must exist.
Three example folders must exist.
validate.sh must report 0 FAILs.

**COMMIT:** `X-01: full-arc runs on three routes, examples generated from them`

---

### R-01, the clean-machine rehearsal

**Status: AMENDED.** It now runs the whole arc rather than stopping at CSV export, and it names the four surfaces rather than three.
**Effort: 1.0d.**
**Depends on: X-01, D-02, D-03.**

**What to do**

1. On a clean macOS machine, both Cowork and the desktop Code tab, and on a clean Windows Home machine, the desktop Code tab under Git Bash.
2. Follow `REPO/docs/PRE-WORK.md` exactly as written, as a founder would, with no shortcuts and no prior knowledge. Where the document is wrong, that is the finding.
3. Install through the marketplace: `/plugin marketplace add Philm-moxywolf/Atlanta` then `/plugin install growth-engine@launchhouse`.
4. Run `/growth-engine:setup` and keep the receipt.
5. Then the arc, as far as the lane that has shipped reaches on that day.
6. Every friction becomes a documentation fix or a task. Write receipts to `REPO/planning/rehearsals/clean-<surface>.md`.

**ACCEPT**

```sh
cd /Users/pmudh/Documents/GitHub/Atlanta
ls planning/rehearsals/clean-macos-cowork.md planning/rehearsals/clean-macos-code.md planning/rehearsals/clean-windows-home-code.md
for f in planning/rehearsals/clean-*.md; do printf '%s frictions: ' "$f"; grep -c '^FRICTION' "$f"; done
grep -h '^FRICTION' planning/rehearsals/clean-*.md | grep -c 'fixed-in\|task '
```

All three receipts must exist.
Every friction line must resolve to either a `fixed-in <commit>` or a `task <id>`. The third count must equal the total friction count.

**COMMIT:** `R-01: clean-machine rehearsal on all four surfaces`

---

### R-02, the v1.0.0 freeze

**Status: KEEP AS IS.**
**Effort: 0.5d.**
**Depends on: R-01, CI-02.**

**What to do**

1. Write the `1.0.0` CHANGELOG entry.
2. Set `1.0.0` in both `REPO/plugins/growth-engine/.claude-plugin/plugin.json` and `REPO/.claude-plugin/marketplace.json`.
3. Tag `v1.0.0`.
4. Confirm the repository is public and the install command in `README.md` and `docs/PRE-WORK.md` reads exactly `/plugin marketplace add Philm-moxywolf/Atlanta` then `/plugin install growth-engine@launchhouse`.
5. Pre-work goes out. Fixes only after this.

**ACCEPT**

```sh
cd /Users/pmudh/Documents/GitHub/Atlanta
grep -h '"version"' plugins/growth-engine/.claude-plugin/plugin.json .claude-plugin/marketplace.json
git tag | grep v1.0.0
bash scripts/validate.sh
gh run watch
gh repo view --json visibility -q .visibility
```

Both versions must read `1.0.0`.
The tag must exist.
validate.sh must report 0 FAILs and all three CI jobs must be green.
Visibility must read `PUBLIC`.

**COMMIT:** `R-02: freeze v1.0.0`

---

## PHASE 10, the integration lane (11.35d)

**Ordering note, and it matters.** The PRD put publish (C-03, its phase 4) ahead of connect (G2-01, its phase 5), while C-03's stated preconditions are the connect receipt and the `ghl-accounts.md` cache, both of which only G2-01 produces. Under an in-order execution contract the executor reaches publish with no receipt writer and no account cache, and either stalls or builds an ad hoc connect path that G2-01 then duplicates. **G2-01 now heads this lane.** It is a reordering, not an effort change, and it also unblocks A-01, which shares the Apollo half of the same door.

---

### G2-01, the connect skill

**Status: AMENDED.** The DM scopes are gone. The Gate A no-branch now consumes a manifest variant that G-03 actually built and S-05 actually probed. The receipt and the account cache are now written through `ge receipt` and `ge accounts` from B-09 rather than hand-edited, which is what the one-writer rule requires.
**Effort: 1.5d.**
**Depends on: G-03, B-09, S-01, S-02, S-05, S-07.**

**SNAPSHOT CHAIN.** This skill writes `.state/receipt.md` and `.state/ghl-accounts.md`. It never writes either directly. It calls `ge receipt set` and `ge accounts write`, which snapshot for themselves. It then calls `ge log result "GHL connected"` and `ge index`.

**What to do**

1. Create `REPO/plugins/growth-engine/skills/connect/SKILL.md`. One skill, two systems.
2. **GoHighLevel branch.** Walk the founder through Settings, then Private Integrations, in plain words, with the **seven-scope** checklist and the screenshots from `REPO/docs/images/`. Then, on Gate A yes, they enter the token and the location id into the masked userConfig prompts, and the skill explains where that prompt appears on their particular surface. On Gate A no, the skill creates `${CLAUDE_PLUGIN_DATA}/ghl.env` containing `GHL_PIT=PASTE_TOKEN_HERE` and `GHL_LOCATION_ID=PASTE_LOCATION_ID_HERE`, sets mode 600, and tells the founder to open it in TextEdit or Notepad, replace both values, save, and say done. Either way the token never enters the conversation.
3. **Verification, by reading, not by asserting.** Two live calls: `locations_get-location` and `socialmediaposting_get-account`. Then `ge receipt set ghl PASS "location <name>, <n> social accounts"`, `ge receipt set pit-created <today>`, and pipe the account rows into `ge accounts write`.
4. **Apollo branch, B2B only.** Trigger the OAuth door for their surface: `/mcp` in the Code tab, the connector sign-in prompt in Cowork. Verify by listing connected mailboxes. Record the mailbox provider into the brain's Channels block. A Microsoft 365 mailbox means the manual route, stated plainly, as a first-class path, with no apology and no Apollo needed.
5. **Every failure has a recovery.** 401 means the recreate-token walk. Zero social accounts means connect them inside GoHighLevel first, with the path. A missing `ghl.env` means the absolute path to open.
6. The skill never prints a token, never asks for one in chat, and never writes one to any file it controls.
7. The command router for this skill is CMD-02, not this task.
8. Rehearse both branches of Gate A and write one transcript each, to exactly `REPO/planning/rehearsals/connect-gate-a-yes.md` and `REPO/planning/rehearsals/connect-gate-a-no.md`. Run the losing branch too, by temporarily swapping in the other `.mcp.json` variant, because a branch that was never run is a branch that does not work. Neither transcript may contain a token value: redact to the first four characters and the length. Nothing else creates these two files, and the acceptance below checks for both.

**ACCEPT**

```sh
cd /Users/pmudh/Documents/GitHub/Atlanta
S=plugins/growth-engine/skills/connect/SKILL.md
grep -c 'socialplanner/post.readonly' $S
grep -ci 'conversations' $S
grep -c 'ge receipt set' $S
grep -c 'ge accounts write' $S
grep -ci 'never.*chat\|not into the conversation\|never enters' $S
ls planning/rehearsals/connect-gate-a-yes.md planning/rehearsals/connect-gate-a-no.md
# the token must not appear in any file the founder folder holds
grep -rc 'pit-' /Users/pmudh/Downloads/Atlanta/launchhouse-atlanta/runs/b2b-arc/growth-engine/ | grep -v ':0' | wc -l
bash scripts/validate.sh
```

The seven-scope grep must be at least `1`; the `conversations` count must be `0`.
Both `ge receipt set` and `ge accounts write` must appear.
Both rehearsal receipts must exist, one per gate branch.
The token-shaped-string count inside the founder folder must be `0`.

**COMMIT:** `G2-01: one connect door, GHL PIT and Apollo OAuth, verified with reads`

---

### G2-02, dm-inbox

**Status: CUT.** Claude never reads a founder inbox. The DM inbox lives in the GoHighLevel app, where the founder reads and replies to copy that Claude wrote into the workflow.
**Effort recovered: 1.5d.**

**What to do**

1. Do not create `skills/dm-inbox/`. Do not create `commands/inbox.md`.
2. Confirm nothing references either. The trigger phrases "check my DMs" and "reply to my messages" must appear nowhere in the repository outside this delivery plan and the superseded PRD.
3. Where a founder-facing document needs to say what happened to DM replies, say it once, plainly: the DMs arrive in GoHighLevel, you read and reply there, and the copy waiting for you is the copy you wrote at the clinic.

**ACCEPT**

```sh
cd /Users/pmudh/Documents/GitHub/Atlanta
test -d plugins/growth-engine/skills/dm-inbox && echo "EXISTS, WRONG" || echo "absent, correct"
test -f plugins/growth-engine/commands/inbox.md && echo "EXISTS, WRONG" || echo "absent, correct"
grep -rin 'check my DMs\|reply to my messages\|dm-inbox' \
  --include='*.md' --include='*.json' --exclude-dir='.git' . \
  | grep -v 'planning/delivery/' | grep -v 'planning/PRD-growth-engine-v1.md' | wc -l
```

Both tests must print `absent, correct`.
The reference count must be `0`.

**COMMIT:** `G2-02: cut dm-inbox, the inbox lives in GoHighLevel`

---

### G2-03, docs/CONNECTIONS.md

**Status: AMENDED.** The conversations row is removed and the seven scopes are named.
**Effort: 0.5d.**
**Depends on: G2-01.**

**What to do**

1. Write `REPO/docs/CONNECTIONS.md` as a plain-words data contract.
2. What connects: GoHighLevel and Apollo, through their official MCP endpoints, named.
3. What the token can reach: the seven scopes, each in one line of plain English. Say explicitly that it cannot read messages, because that scope is no longer requested.
4. What is stored where: the keychain or credentials store, the plugin data directory, the receipt. And what is never stored: the token itself, in any file the founder folder holds.
5. What leaves the machine, and when: a publish, a sequence enroll. Each only on the founder's yes. Nothing runs on a timer, nothing runs while they are away.
6. How to disconnect, and how to rotate the token.
7. The Apollo model-training-off note, which their terms require.
8. Link it from `REPO/README.md` and `REPO/docs/PRE-WORK.md`.
9. In the commit body, map every claim in the file to the mechanism in this build that makes it true. A claim with no mechanism is deleted, not softened.

**ACCEPT**

```sh
cd /Users/pmudh/Documents/GitHub/Atlanta
grep -c 'socialplanner/post.write' docs/CONNECTIONS.md
grep -ci 'conversations\|read your messages' docs/CONNECTIONS.md
grep -ci 'never stored\|is not stored' docs/CONNECTIONS.md
grep -c 'CONNECTIONS.md' README.md docs/PRE-WORK.md
bash scripts/validate.sh
```

The scope grep must be at least `1`.
The conversations count must be `0`, except where the file explicitly says the token cannot read messages, so read the matches rather than only counting them.
Both link greps must be at least `1`.

**COMMIT:** `G2-03: CONNECTIONS, the plain-words data contract`

---

### C-03, the ghl-publish skill

**Status: AMENDED.** Reordered to sit after connect. Its precondition now points at a real producer. Media-lane rows now have captions, from C-01, so the two roads it offers are both real.
**Effort: 2.0d.** Seventh on the cut order.
**Depends on: G2-01, B-05 (the approve transition), B-09, C-01, C-02, S-03 (timezone rule and rate ceiling), S-02 gate C.**

**SNAPSHOT CHAIN.** This skill does not write a founder markdown file. It mutates the ledger, and every `ge ledger set-content` snapshots `ledger.md` for itself. It ends with `ge log result "<n> scheduled, <n> failed"` and `ge index`.

**What to do**

1. Create `REPO/plugins/growth-engine/skills/ghl-publish/SKILL.md`.
2. **Preconditions, checked and named.** The connect receipt exists and its `ghl` line reads PASS. The ledger holds at least one `approved` text-lane row. If there are none, say the exact sentence: run the content engine, do the edit pass, then say "approve my content", and stop there.
3. Read `.state/ghl-accounts.md`. Refresh it through `socialmediaposting_get-account` if the stamp is more than seven days old, then `ge accounts write`.
4. Propose slots. Default five per week, on the founder's posting days, read from the Channels block of the brain, asked once and stored there.
5. **Preview table before anything is sent:** post number, the first line of the post, the platform, and the local date and time. Local, per the timezone rule from spike S-03. Never UTC in front of a founder.
6. One yes per batch, batches of ten or fewer. No autonomous loop, no standing approval.
7. Per row: `socialmediaposting_create-post` with accountIds, type, summary, `status: "scheduled"` and `scheduleDate` built by the S-03 rule. Capture the returned id. Then `get-post` as a read-back. Then `ge ledger set-content <id> status scheduled` and store the post id.
8. **POSTURE: fail-loud on the read-back.** A missing post id marks the row `failed` and prints a recovery. A silent half-publish is a lie in the ledger.
9. Pace between calls using the rate ceiling from spike S-03, not a guess.
10. **Media-lane rows are never auto-posted.** List them with their `media_note` and their caption, and give the two roads: upload the asset to the GoHighLevel Media Library, paste the public URL, and it posts; or keep it for the CSV path.
11. Summary table at the end. Failures listed with recoveries, and the note that already-scheduled rows are skipped by the ledger, so running publish again is safe.
12. A "post as drafts instead" flag, which sends `status: "draft"`.
13. The command router is CMD-02.
14. Rehearse it live against the S-01 test location and write the transcript to `REPO/planning/rehearsals/publish-live.md`. Schedule three text posts, capture the three post ids returned, capture the three `get-post` read-backs, screenshot or transcribe the local time each one shows in the GoHighLevel Social Planner interface, and paste the matching ledger rows. Then force one failure on purpose with a bad accountId and capture the `failed` row and its recovery line. Delete the test posts afterwards. Nothing else creates that file, and the acceptance below checks for it.

**ACCEPT**

```sh
cd /Users/pmudh/Documents/GitHub/Atlanta
S=plugins/growth-engine/skills/ghl-publish/SKILL.md
grep -c 'approved' $S
grep -c 'get-post' $S
grep -ci 'read-back\|read back' $S
grep -ci 'local' $S
grep -c 'ge ledger set-content' $S
grep -ci 'media_note' $S
ls planning/rehearsals/publish-live.md
grep -c 'scheduled' planning/rehearsals/publish-live.md
grep -c 'failed' planning/rehearsals/publish-live.md
```

Every skill grep must return at least `1`.
The rehearsal receipt must record three text posts scheduled against the test location, three read-backs with real post ids, the local time each shows in the GoHighLevel Social Planner interface, and the matching ledger rows.
It must also record one deliberately forced failure, using a bad accountId, landing as `failed` with its recovery line printed.

**COMMIT:** `C-03: publish through GHL with read-back verification`

---

### CMD-02, the connect and publish commands

**Status: NEW.** The PRD builds the connect skill and the publish skill but never builds a command file for either, so neither has a trigger phrase or a router, and the only way to reach them is to hope the skill description fires on its own. Every other command in the plugin has a file. These two get one too, from the same owner, in the same shape, so the routers cannot drift from the skills they route into and the hard-coded command count in `REPO/scripts/validate.sh` cannot go stale.
**Effort: 0.35d.**
**Depends on: G2-01, C-03.**

**What to do**

1. Create `REPO/plugins/growth-engine/commands/connect.md`, routing into the connect skill. Trigger phrases include "connect my accounts", "set up GoHighLevel", "connect Apollo".
2. Create `REPO/plugins/growth-engine/commands/publish.md`, routing into the ghl-publish skill. Trigger phrases include "publish my content", "schedule my posts". If S-02's gate C landed on branch (b), this file routes into the CSV path instead and says so plainly in one sentence.
3. Namespaced form only, in every example: `/growth-engine:connect`, `/growth-engine:publish`.
4. Update the command count in `REPO/scripts/validate.sh` and the command table in `REPO/README.md`.

**ACCEPT**

```sh
cd /Users/pmudh/Documents/GitHub/Atlanta
ls -1 plugins/growth-engine/commands/ | wc -l
grep -c 'growth-engine:connect' plugins/growth-engine/commands/connect.md README.md
grep -c 'growth-engine:publish' plugins/growth-engine/commands/publish.md README.md
grep -rnE '(^|[^:a-z-])/(connect|publish)\b' README.md docs/ plugins/growth-engine/ | wc -l
bash scripts/validate.sh
```

The command file count must be `14`: the twelve after CMD-01 plus `connect.md` and `publish.md`. Update the constant in `REPO/scripts/validate.sh` to 14 in the same commit, or the check FAILs.
Both namespaced greps must return at least `1` in each file.
The bare-command count must be `0`.
validate.sh must report 0 FAILs, including its updated count check.

**COMMIT:** `CMD-02: connect and publish command routers`

---

### A-01, outreach-b2b through Apollo

**Status: AMENDED.** The three capabilities it states as fact are now gathered by spike S-07, and the branch it takes when one of them is missing is named by gate D rather than discovered mid-task. Eighth on the cut order.
**Effort: 2.0d**, reduced per gate D: 1.75d if custom-field writes are unavailable, 1.0d if sequence creation is unavailable and the manual route becomes primary.
**Depends on: G2-01 (the Apollo door), S-07 and gate D, B-05.**

**SNAPSHOT CHAIN.** Writes `growth-engine/outreach-sequence.md` and the export files. For each: `ge snapshot <file>`, stop on non-zero, write. Then one `ge ledger add-outreach` per contact, then `ge log result "sequence created, 25 enrolled paused"`, then `ge index`.

**What to do**

1. Edit `REPO/plugins/growth-engine/skills/outreach-b2b/SKILL.md`.
2. Keep Step 0's mailbox question. Its answer now routes between the Apollo MCP path and the manual path. Microsoft 365 means manual, unchanged, and first-class, with no suggestion that it is a lesser route.
3. Run the three search variants live. Show the counts.
4. Build 35. The founder can veto any row.
5. Cut to 25 with the founder. Say what each cut was for.
6. Enrich the 25. Read the deliverability field by the exact name spike S-07 recorded. Flag unverified rows and let the founder decide, one at a time.
7. Create the contacts. Search results must be saved as contacts before they can be sequenced.
8. Write the first lines in batches of five, against the real enriched rows, never against a placeholder. Then write each into the `first_line` custom field. If gate D says custom-field writes are unavailable, the first line becomes one static opener the founder chooses, and the skill says so in one plain sentence rather than pretending.
9. Create the sequence: four to five touches, each under 120 words, an opt-out line in every touch, waits stated, `{{first_line}}` opening touch one, standard merge variables elsewhere. **Every touch also carries the founder's real business name and a postal address**, because that is what the cold-email rules require and only the opt-out half of it was carried forward.
10. Add the 25 with `send_email_from_email_account_id` set to their connected mailbox. **Verify paused.** Show the proof.
11. Tell the founder exactly where to press go in Apollo. If gate D confirmed activation through the MCP, offer it here as one explicit yes and nothing more. Never a default, never a batch.
12. Every row lands in the ledger as an `O|` row.
13. Keep `## Step 4: deliverability brief` of `REPO/plugins/growth-engine/skills/outreach-b2b/SKILL.md` verbatim. Keep `## Step 5: export` and the files it produces, whatever gate D said, because the export is also the founder's own record of who they contacted.
14. Never promise replies. Not in this skill, not in any output it writes. Replies depend on list quality, offer and timing, and saying so once is more useful than any number.
15. Rehearse it live against the paid Apollo seat from spike S-01 and write the transcript to `REPO/planning/rehearsals/apollo-live.md`: a two-contact sequence created and confirmed paused, then activated by hand, one send observed landing in a mailbox Philip owns, and stop-on-reply confirmed visible and on. Delete every test artifact afterwards. Nothing else creates that file, and the acceptance below checks for it.

**ACCEPT**

```sh
cd /Users/pmudh/Documents/GitHub/Atlanta
S=plugins/growth-engine/skills/outreach-b2b/SKILL.md
grep -ci 'paused' $S
grep -ci 'opt-out\|unsubscribe' $S
grep -ci 'postal address\|business address' $S
grep -c 'ge ledger add-outreach' $S
grep -ciE 'guarantee|expect [0-9]+ (repl|meeting)|you will get' $S
ls planning/rehearsals/apollo-live.md
grep -ci 'paused' planning/rehearsals/apollo-live.md
grep -ci 'stop on reply\|stop-on-reply' planning/rehearsals/apollo-live.md
# the manual route still produces a complete set of 25, whatever gate D said
grep -c '^O|' /Users/pmudh/Downloads/Atlanta/launchhouse-atlanta/runs/b2b-arc/growth-engine/ledger.md
```

The paused, opt-out, postal-address and ledger greps must each return at least `1`.
The reply-promise grep must return `0`.
The rehearsal receipt must record a two-contact sequence created paused against the paid test seat, activated by hand, one send observed to a mailbox Philip owns, and stop-on-reply confirmed on.
The b2b arc run must show `25` `O|` rows regardless of which gate D branch was taken.

**COMMIT:** `A-01: outreach through Apollo MCP, search to paused enrollment`

---

### A-02, status, gate and setup read the brain

**Status: AMENDED.** The gate command gets the rewrite it never had, and the B2C DM count now has a row type to read. Fifth on the cut order.
**Effort: 0.5d.**
**Depends on: B-05, B-06, B-00 (`schemas/gates.md`), AB-01 (the `D|` rows).**

**What to do**

1. Edit `REPO/plugins/growth-engine/skills/status/SKILL.md` so it reads `ge index` plus ledger counts: content by status, outreach by status, DMs by status. Not bare file existence.
2. Rewrite `REPO/plugins/growth-engine/commands/gate.md`. It is 17 lines today and says "For each gate item, DONE or NOT DONE" with no item list, no gate number and no track fork. It must: ask which of the three gates is being submitted, read the item list for that gate from `schemas/gates.md`, branch by track where the tracks differ, mark file-backed items from ledger and index truth, and ask the founder directly about the self-reported items (domain warmed, Instagram account converted, pods confirmed) rather than guessing or silently omitting them.
3. **State explicitly, in the skill text, whether the B2C gate counts `D|` rows or falls back to file presence.** Pick one. An unstated fallback is how a gate quietly reports zero for 65 people.
4. Edit `REPO/plugins/growth-engine/skills/setup/SKILL.md` to read the connect receipt rather than probing blind.

**ACCEPT**

```sh
cd /Users/pmudh/Documents/GitHub/Atlanta
grep -c 'ge index' plugins/growth-engine/skills/status/SKILL.md
grep -c 'ge ledger list' plugins/growth-engine/skills/status/SKILL.md
grep -ci 'which gate\|gate 1\|gate 2\|gate 3' plugins/growth-engine/commands/gate.md
grep -c 'schemas/gates.md' plugins/growth-engine/commands/gate.md
grep -ci 'track' plugins/growth-engine/commands/gate.md
grep -c 'D|' plugins/growth-engine/skills/status/SKILL.md
cd /Users/pmudh/Downloads/Atlanta/launchhouse-atlanta/runs/b2c-arc \
  && sh /Users/pmudh/Documents/GitHub/Atlanta/plugins/growth-engine/scripts/ge.sh index \
  && cat growth-engine/.state/index.md
```

Every grep must return at least `1`.
The index printed from the b2c arc run must show a gate label against every founder file, and no file marked `missing` that the arc actually produced.

**COMMIT:** `A-02: status and gates read the brain, not the filesystem guess`

---

### O-01 ⚑HUMAN, build the three GoHighLevel snapshots

**Status: AMENDED.** Only the DM-reply workflow's framing changes: the qualify-and-book conversation runs entirely inside GoHighLevel, which is now the whole story rather than half of one.
**Effort: 1.5d, in the GoHighLevel user interface.**
**Depends on: S-01.**

**What to do**

1. In the agency account, build three snapshots:
   - `b2b-core` : lead follow-up, discovery booking, proposal chase.
   - `b2c-service-core` : comment-to-DM capture, DM qualify and book, review request.
   - `b2c-ecom-core` : comment-to-DM capture, abandoned-checkout chase, post-purchase review.
2. **Every founder-facing message in every workflow is a namespaced custom value**, `{{custom_values.lh_<snapshot>_<msg>}}`. Copy is data. A workflow with copy baked into it cannot be personalised by 130 people.
3. Test-import each one through its share link into a clean location, and confirm the custom-value placeholders render. Write what you did and what rendered to `REPO/planning/rehearsals/snapshot-import-test.md`, including at least one screenshot or pasted line showing a `{{custom_values.lh_...}}` placeholder resolving to its value. Nothing else creates that file, and the acceptance below checks for it.
4. Record the three live share links in `REPO/plugins/growth-engine/assets/ghl/README.md`. Zero TODOs. CI-01's widened gate fails the build if a placeholder survives.
5. Record which GoHighLevel plan tier each workflow needs, especially comment-to-DM. That answer goes into spike S-01 and into the costs table in `docs/PRE-WORK.md`.

**ACCEPT**

```sh
cd /Users/pmudh/Documents/GitHub/Atlanta
grep -c 'https://' plugins/growth-engine/assets/ghl/README.md
grep -ci 'TODO' plugins/growth-engine/assets/ghl/README.md
grep -c 'b2b-core\|b2c-service-core\|b2c-ecom-core' plugins/growth-engine/assets/ghl/README.md
ls planning/rehearsals/snapshot-import-test.md
bash scripts/validate.sh
```

Three share-link URLs must be present.
The TODO count must be `0`.
All three snapshot slugs must be named.
The import-test receipt must exist and must show a rendered custom-value placeholder.

**COMMIT:** `O-01: three snapshots built, imported and linked`

---

### O-02, the copy maps

**Status: KEEP AS IS.**
**Effort: 0.5d.**
**Depends on: O-01.**

**What to do**

1. Write `REPO/plugins/growth-engine/assets/ghl/snapshots/b2b-core.md`, `b2c-service-core.md` and `b2c-ecom-core.md`.
2. Each lists every `lh_*` key, where it appears (workflow and step), its channel (email, SMS or DM), and length guidance.
3. The comment-to-DM keyword lives here, in exactly one place, because C-01 and AB-01 both read it and neither may write a second version.
4. Add the key lint to `REPO/scripts/validate.sh`: keys match `^lh_[a-z0-9_]+$` and are unique within a file.

**ACCEPT**

```sh
cd /Users/pmudh/Documents/GitHub/Atlanta
ls -1 plugins/growth-engine/assets/ghl/snapshots/
for f in plugins/growth-engine/assets/ghl/snapshots/*.md; do
  # -o and -c cannot be combined: grep -c counts matching LINES and silently
  # ignores -o, so a line with two keys would count as one. Pipe to wc instead.
  total=$(grep -o 'lh_[a-z0-9_]*' "$f" | wc -l | tr -d ' ')
  uniq=$(grep -o 'lh_[a-z0-9_]*' "$f" | sort -u | wc -l | tr -d ' ')
  printf '%s keys=%s unique=%s\n' "$f" "$total" "$uniq"
done
grep -rhoE 'lh_[A-Za-z0-9_-]*' plugins/growth-engine/assets/ghl/snapshots/ \
  | grep -cE 'lh_[A-Z]|-' 
bash scripts/validate.sh
# prove the lint bites
printf '{{custom_values.lh_BadKey}}\n' >> plugins/growth-engine/assets/ghl/snapshots/b2b-core.md
bash scripts/validate.sh; echo "planted exit=$?"
git checkout plugins/growth-engine/assets/ghl/snapshots/b2b-core.md
```

Three files must exist.
For each file, `keys` must equal `unique`.
The malformed-key count must be `0`.
`planted exit` must be non-zero with a FAIL naming the bad key.

**COMMIT:** `O-02: snapshot copy maps, copy as data`

---

### O-03, ghl-workflows v2

**Status: AMENDED.** The snapshot selection change is taken unchanged from the PRD's own O-03 delta: the skill picks the snapshot from `Track` plus `Model` instead of asking the founder to choose. What is added is the configuration a live workflow actually needs at the 23 September clinic, which the PRD's version does not require: a publish step, a test-contact run, timezone and business hours on the waits, the sending identity, and the SMS prerequisite warning. A workflow that is built but never published does nothing on the Monday.
**Effort: 0.75d** (0.5d as in the PRD, plus 0.25d for the clinic configuration).
**Depends on: O-02, FB-01.**

**SNAPSHOT CHAIN.** Writes `growth-engine/ops-workflow.md`. `ge snapshot ops-workflow.md`, stop on non-zero, write, `ge log result "ops copy written (<slug>)"`, `ge index`.

**What to do**

1. Edit `REPO/plugins/growth-engine/skills/ghl-workflows/SKILL.md`.
2. Snapshot selection is automatic, from track plus model, and stated in one line: "You are B2C ecommerce, so your snapshot is b2c-ecom-core." The founder does not choose. They already chose once, in the brain.
3. The bottleneck diagnostic is kept verbatim, but its job changes: it now orders which workflow's copy gets written first. It no longer picks the snapshot.
4. Output is the key-to-copy table from the copy map, every key filled, in the founder's captured voice, plus the trigger, the waits, the exit condition and the tags.
5. **New, the clinic configuration block**, written into `ops-workflow.md` as a checklist the founder works through at the 23 September clinic:
   - Publish the workflow. A saved draft does not run.
   - Run one test contact through it end to end and confirm each step fired.
   - Set the timezone on every wait, and set business hours, so a 2am automated reply does not go out.
   - Set the sending identity: which email address, which from-name, which phone number.
   - The SMS prerequisite warning: SMS needs a registered number and, in the United States, campaign registration, which takes days and cannot be done in the room. If they have not done it, the SMS steps stay off and the email steps carry the workflow.
6. Keep `## Step 4: n8n escape hatch` of `REPO/plugins/growth-engine/skills/ghl-workflows/SKILL.md` unchanged.

**ACCEPT**

```sh
cd /Users/pmudh/Documents/GitHub/Atlanta
S=plugins/growth-engine/skills/ghl-workflows/SKILL.md
grep -c 'b2c-ecom-core' $S
grep -ci 'publish the workflow\|a saved draft does not run' $S
grep -ci 'test contact' $S
grep -ci 'business hours\|timezone' $S
grep -ci 'sending identity\|from-name' $S
grep -ci 'registration\|registered number' $S
grep -c 'ge snapshot ops-workflow.md' $S
# one arc run per model path, each filling its map with no missing keys
# no process substitution: this block must run under plain sh, including Git Bash
RUNS=/Users/pmudh/Downloads/Atlanta/launchhouse-atlanta/runs
MAPS=/Users/pmudh/Documents/GitHub/Atlanta/plugins/growth-engine/assets/ghl/snapshots
for r in b2b-arc b2c-arc b2c-ecom-arc; do
  W="$RUNS/$r/growth-engine/ops-workflow.md"
  slug=$(grep -o 'b2[bc][a-z-]*core' "$W" | head -1)
  grep -o 'lh_[a-z0-9_]*' "$MAPS/$slug.md" | sort -u > /tmp/keys-map.txt
  grep -o 'lh_[a-z0-9_]*' "$W"             | sort -u > /tmp/keys-run.txt
  printf '%s slug=%s missing keys: %s\n' "$r" "$slug" "$(comm -23 /tmp/keys-map.txt /tmp/keys-run.txt | wc -l | tr -d ' ')"
done
```

Every skill grep must return at least `1`.
Every run must report `0` missing keys.

**COMMIT:** `O-03: ops engine, model-picked snapshot, copy by contract, clinic-ready config`

---

### SS-03, reconnect flows and the error-catalogue pass

**Status: AMENDED.** The Apollo leg stays, the DM leg goes. Sixth on the cut order.
**Effort: 1.0d.**
**Depends on: G2-01, SS-01, B-09.**

**What to do**

1. A GoHighLevel 401 anywhere routes to the reconnect walk: recreate the token with the same seven scopes, re-enter it through the same door as connect, and `ge receipt set pit-created <today>` refreshes the date.
2. A token older than 80 days makes both the doctor and `ge context` nudge, using the same walk. One walk, one place, so it cannot drift.
3. An Apollo authentication failure re-runs the OAuth door for the founder's surface.
4. **The error-catalogue pass.** Grep every skill for founder-visible failure text. Every single one ends with a recovery. There is no exception for a failure that seems obvious.
5. Rehearse the 401 walk once, end to end, against the test location: revoke the Private Integration Token, hit the 401, follow the walk the skill prints, recreate the token with the same seven scopes, re-enter it, and confirm `ge receipt show` now carries a refreshed `pit_created` date. Write it to `REPO/planning/rehearsals/reconnect-401.md`. Nothing else creates that file, and the acceptance below checks for it.

**ACCEPT**

```sh
cd /Users/pmudh/Documents/GitHub/Atlanta
# every founder-visible failure line carries a recovery
grep -rn -iE "can't|cannot|failed|error|not found|missing" plugins/growth-engine/skills/ | grep -v '^Binary' > /tmp/failure-lines.txt
wc -l < /tmp/failure-lines.txt
grep -c '→' /tmp/failure-lines.txt
ls planning/rehearsals/reconnect-401.md
grep -ci 'pit-created\|token created' planning/rehearsals/reconnect-401.md
bash scripts/validate.sh
```

Paste both counts into the commit body. Where the arrow count is lower than the line count, list every line without a recovery in the commit body and explain why each is not founder-visible. An unexplained gap is a failed acceptance.
The 401 rehearsal transcript must exist and must show the receipt date refreshed.

**COMMIT:** `SS-03: reconnect flows, and no error without a recovery`

---

### R-03, close the integration lane

**Status: AMENDED.** The dmgate rehearsal drops out of the sweep.
**Effort: 0.5d.**
**Depends on: everything in phase 10 that survived the cut order.**

**What to do**

1. Re-download the GoHighLevel Social Planner CSV template from the same in-app screen spike S-03 took it from, and save it to exactly `/tmp/redownloaded-template.csv`. The acceptance block below compares that path byte for byte against `REPO/plugins/growth-engine/assets/ghl/social-planner-template.csv`. If it changed, C-02 changes with it, today, not in September.
2. Re-probe both MCP catalogs. Tool names move. Record any difference in `REPO/planning/spike-findings.md` with a dated note.
3. Re-run one live publish rehearsal and one live Apollo rehearsal against the test accounts.
4. Bump to `1.1.0` in both manifests, write the CHANGELOG entry, tag.
5. Session 3 opens with the live update drill from SS-02.

**ACCEPT**

```sh
cd /Users/pmudh/Documents/GitHub/Atlanta
cmp /tmp/redownloaded-template.csv plugins/growth-engine/assets/ghl/social-planner-template.csv && echo "CSV TEMPLATE UNCHANGED"
grep -h '"version"' plugins/growth-engine/.claude-plugin/plugin.json .claude-plugin/marketplace.json
ls planning/rehearsals/sweep-$(date +%Y%m%d).md
git tag | grep v1.1.0
bash scripts/validate.sh
gh run watch
```

`CSV TEMPLATE UNCHANGED` must print, or the sweep file must record exactly what changed and which task absorbed it.
Both versions must read `1.1.0`.
The sweep file and the tag must exist.
validate.sh must report 0 FAILs and all three CI jobs must be green.

**COMMIT:** `R-03: re-verification sweep and the 1.1.0 lane close`

---

### R-04, the backlog

**Status: AMENDED.** It now also absorbs everything T-00 routed to `backlog`, so the triage has a destination rather than a dead end.
**Effort: 0.25d.**
**Depends on: T-00, R-03.**

**What to do**

1. Create `REPO/planning/backlog.md`.
2. Carry across every line in `REPO/planning/review-triage.md` whose verdict is `backlog`, keeping its `FR-` id so the two files stay joined.
3. Add the v1.2 candidates: statistics-weighted refill (a statistics MCP read into a ledger performance column), a flow tuner, media-lane automation (which needs a media-upload endpoint nobody has verified, so record it as a spike question rather than a feature), an extension kit under `growth-engine/extensions/` and `my-data/` as reserved namespaces, and a monthly re-verification ritual.
4. Add the deferred items from this delivery plan by name: PB-01 if it stayed deferred, and every cut-order item that was actually taken.

**ACCEPT**

```sh
cd /Users/pmudh/Documents/GitHub/Atlanta
grep -c '^FR-' planning/backlog.md
grep -c 'backlog' planning/review-triage.md
grep -ci 'PB-01\|playbook' planning/backlog.md
bash scripts/validate.sh
```

The `FR-` count in the backlog must equal the `backlog` count in the triage file.
The playbook grep must be at least `1` if PB-01 stayed deferred.

**COMMIT:** `R-04: the backlog, joined to the triage by finding id`

---

## The dependency graph

Read left to right. An arrow means the task on the right cannot start until the task on the left is done and its ACCEPT has passed.

```
T-00 ─────────────────────────────────────────────────────────────────────┐
 (triage 95 findings, first task in the build)                            │
                                                                          │
SPIKE, all ⚑HUMAN                                                         │
  S-01 ──┬── S-02 ──┬── S-03 ─────────────────────────────────┐           │
         │          └── GATE C ── (b) cuts C-03 ── (c) stop   │           │
         ├── S-05 ── GATE A ───────────────────┐              │           │
         ├── S-06 ── GATE B + GATE B2 ─────┐   │              │           │
         └── S-07 ── GATE D ───────────┐   │   │              │           │
  S-04  CUT                            │   │   │              │           │
                                       │   │   │              │           │
GROUNDWORK                             │   │   │              │           │
  T-00 ── G-01 ── G-02 ── G-03 ◄───────────┘   │              │           │
                    │       ▲ (needs GATE A and the S-02 endpoint)        │
                    │                                          │          │
THE BRAIN                                                      │          │
  G-02 ── B-00 ─┬── B-01 ◄── GATE B2                           │          │
                │     │                                        │          │
                │     └── B-02 ─┬── B-03 ──┬── B-05 ── B-06 ─┐ │          │
                │               │          │                 │ │          │
                │               ├── B-04 ──┘                 │ │          │
                │               └── B-09 ───────────┐        │ │          │
                │                                   │        │ │          │
                └────────────────── B-08 ◄──────────┴────────┘ │          │
  B-07  CUT                                                    │          │
                                                               │          │
THE BRAIN SKILL                                                │          │
  B-05,B-06,B-09,B-00 ── FB-01 ── FB-02                        │          │
                            │                                  │          │
CONTENT                     │                                  │          │
  FB-01,B-05,B-06 ── C-01 ──┴── C-02 ◄── S-03 (CSV fixture) ◄──┘          │
                       │                                                  │
ORPHAN SKILLS          │                                                  │
  FB-01,B-03,B-04,B-06 ── GP-01                                           │
  FB-01,B-05,O-02 ─────── AB-01                                           │
  GP-01,AB-01,C-01 ────── PB-01  DEFERRED                                 │
                                                                          │
SELF-SERVICE AND COMMANDS                                                 │
  B-08,B-09 ── SS-01                                                      │
  G-02,B-08 ── SS-02 ──┬── CMD-01 ◄── B-03                                │
                       │                                                  │
DOCS                   │                                                  │
  CMD-01,SS-01 ── D-01 ─┬── D-02 (blocked on the Session 2 decision)      │
                        ├── D-03                                          │
                        └── D-04 ◄── CMD-01                               │
                                                                          │
CI                                                                        │
  everything above ── CI-01 ── CI-02                                      │
                                                                          │
FREEZE                                                                    │
  all skills ── X-01 ── R-01 ◄── D-02, D-03 ── R-02  (v1.0.0)             │
                                                                          │
INTEGRATION LANE, connect first, this is the reordering                   │
  G-03,B-09,S-01,S-02,S-05,S-07 ── G2-01 ─┬── G2-03                       │
                                          │                               │
                                          ├── C-03 ◄── B-05 approve, C-01, C-02, S-03
                                          │      │                        │
                                          │      └── CMD-02 ◄── G2-01     │
                                          │                               │
                                          └── A-01 ◄── GATE D ── A-02 ◄── AB-01
  G2-02  CUT                                                              │
                                                                          │
  S-01 ── O-01 ── O-02 ─┬── O-03 ◄── FB-01                                │
                        └── AB-01 (reads the comment-to-DM keyword)       │
                                                                          │
  G2-01,SS-01,B-09 ── SS-03                                               │
                                                                          │
  everything in the lane ── R-03  (v1.1.0) ── R-04 ◄────────────────────  ┘
                                                    (backlog absorbs T-00's routing)
```

**The four chains that carry the most risk, in order:**

1. `S-02 → G-03 → G2-01 → C-03` : if gate C lands on (b) or (c), system 1 becomes CSV only and 2.0 days come back. Everything about publishing sits on one spike answer.
2. `S-07 → A-01` : gate D decides whether roughly 65 B2B founders get the Apollo path or the manual export path. A-01 cannot start until that answer exists.
3. `B-00 → B-05 → C-01 → C-03` : the approve transition. Without it the publish precondition is unreachable and the CSV stays frozen at generation. This chain was entirely absent from the PRD.
4. `S-06 → B-01 → every skill` : the invocation form. One string, decided once, copied everywhere. Get it wrong and every `ge` call in every skill fails at runtime on the surface that was not tested.
