## Quality, simplicity and risk

This section exists because the client asked for the opposite of most engineering sections.
The instruction was: improve quality, improve delivery, and make the thing simpler, without introducing anything that creates difficulty.
So every item below has to pass one test.

**The test.** An item earns its place only if it removes work, removes a failure mode, or removes founder confusion.
If an item adds work, the section states what it buys back and the buy-back has to be larger than the cost.
Items that only add rigour, with no named thing they prevent, are not here.

**What is being delivered, restated so this section stands alone.**
The client locked the scope to exactly four systems on 20 August 2026.

1. Content engine: 30 on-voice pieces, tracked in a ledger, exported to CSV, scheduled into the GoHighLevel Social Planner through the official GoHighLevel MCP with read-back verification.
2. Outbound engine. B2B: Apollo MCP, from an ICP to a live search to 35 built to 25 cut to enriched to contacts to a sequence carrying a `{{first_line}}` merge field, enrolled paused. Founders on Microsoft 365 take a first-class manual route instead. B2C: 25 direct message openers sent by hand, a hook bank, and offer tests.
3. Back-end ops: three GoHighLevel snapshots (`b2b-core`, `b2c-service-core`, `b2c-ecom-core`), selected automatically by track plus business model, with every message stored as a namespaced custom value. This includes comment-to-DM capture and DM qualify-and-book, which run as GoHighLevel workflows carrying copy that Claude writes.
4. The brain: `bin/ge`, POSIX sh, schema-described state, one writer per file, snapshot-before-write with undo, an append-only ops log, a derived index and an evidence doctor. The one exception is a managed block: inside a file carrying `GE:<NAME>:START` and `END` markers, `ge` owns the marked blocks and the founder owns everything outside them, which is how `memory.md` stays both machine-written and hand-editable. See section 08.

**What was cut on 20 August 2026, restated so nothing below is read as still coming.**
The `dm-inbox` skill is cut: Claude never reads a founder inbox and never drafts a direct message reply.
`ge dmgate` (PRD task B-07) and all 24-hour-window code are cut: nothing in our code sends a direct message.
`commands/inbox.md` is cut.
Spike section S-04 of `/Users/pmudh/Documents/GitHub/Atlanta/planning/spike-findings.md` (conversations) is cut and is to be deleted from that file.
PRD task G2-02 is cut.
Three Private Integration Token scopes are no longer requested: `conversations.readonly`, `conversations/message.readonly` and `conversations/message.write`.
The DM inbox itself lives inside the GoHighLevel application, where the founder reads and replies by hand.
Comment-to-DM capture is **not** cut. It stays, as a GoHighLevel workflow, with the copy inside it written by Claude and delivered as a copy map. Our code sends nothing.

**Two items that are neither in the four systems nor cut.**
`skills/growth-plan` is IN. It is cheap, it is the Sunday deliverable in Atlanta, and it reads the Founder Brain.
`skills/playbook-export` is DEFERRED, pending the reader's decision. Section 7.1 item S-01 below recommends deleting it outright and states the case; if the reader keeps it instead, S-01 also states the minimum viable version.

**A naming warning, because two different S-numbering schemes appear below.**
Items numbered `S-01` to `S-13` inside section 7.1 are simplification proposals and exist only in this document.
Sections numbered `S-01` to `S-07` inside `/Users/pmudh/Documents/GitHub/Atlanta/planning/spike-findings.md` are spike evidence sections and are unrelated.
Every reference to the second kind below is written as "spike section S-nn". A bare `S-nn` always means a simplification item in section 7.1.

**Public repository warning.**
Everything here is written to be safe in a public repository.
`planning/` is tracked by git (running `git ls-files planning` from `/Users/pmudh/Documents/GitHub/Atlanta` returns eight paths on 21 August 2026) and the repository at `https://github.com/Philm-moxywolf/Atlanta` has been public since 18 August 2026, so this file will be readable by anyone who finds the URL from the moment it is pushed.
For that reason the register below names roles, not people, and carries no rates, no commercial terms and no mentor names.
The private counterpart of each row lives in `/Users/pmudh/Downloads/Atlanta/launchhouse-atlanta/STATE.md`, which is outside the repository and stays there.
That fact is itself a risk row, R-13 in Table A of section 7.2.

---

### 7.1 Simplifications available now

Twelve candidates were examined against the PRD at `/Users/pmudh/Documents/GitHub/Atlanta/planning/PRD-growth-engine-v1.md` and against the repository as it stands on 21 August 2026.
Nine are recommended for adoption, three are recommended for rejection.
Rejections are included on purpose: a list where everything is a yes is not a review.

**Path convention. This applies to all of section 7, not only to 7.1, and section 7.6 restates it for the definition of done.**
Any path written without a leading `/` is relative to the repository root, which is `/Users/pmudh/Documents/GitHub/Atlanta`.
So `scripts/validate.sh` means `/Users/pmudh/Documents/GitHub/Atlanta/scripts/validate.sh`, and `plugins/growth-engine/skills/setup/SKILL.md` means `/Users/pmudh/Documents/GitHub/Atlanta/plugins/growth-engine/skills/setup/SKILL.md`.
The one exception is a path beginning `./growth-engine/`, which always means the founder's own working folder on their own machine, never anything in this repository.
Every command block in this section is copy-pasteable from a shell whose working directory is `/Users/pmudh/Documents/GitHub/Atlanta`.

Each item is written as: what it removes, what it costs, and the recommendation.
Where an item also closes a verified gap, the gap is named by its location in `/Users/pmudh/Downloads/Atlanta/launchhouse-atlanta/planning/PRD-GAPS.md` or `/Users/pmudh/Downloads/Atlanta/launchhouse-atlanta/planning/FUNCTIONAL-REVIEW.md`, with the line number, so the reader can check the claim.

#### S-01 Delete `skills/playbook-export` and `commands/playbook.md` from v1.0.0. ADOPT.

**What it removes.**
One skill file (`plugins/growth-engine/skills/playbook-export/SKILL.md`, 35 lines), one command file, one entry in the README command table, and one line in the validate.sh skill count.
It also removes seven verified findings in `/Users/pmudh/Downloads/Atlanta/launchhouse-atlanta/planning/FUNCTIONAL-REVIEW.md` at a stroke, plus three rows in `/Users/pmudh/Downloads/Atlanta/launchhouse-atlanta/planning/PRD-GAPS.md`, because deletion resolves them all.
Line numbers are given so every claim can be checked with `sed -n '<n>p' <file>`:

- FUNCTIONAL-REVIEW.md:599, the skill contradicts itself on timing (its contents include the 90-day plan, which is built on the Sunday in Atlanta, while its Delivery section says founders receive the insert before Atlanta).
- FUNCTIONAL-REVIEW.md:609 and :993, the insert is promised as a PDF and nothing in the toolkit produces a PDF.
- FUNCTIONAL-REVIEW.md:619, a six-page ceiling over a six-section contents list with no page budget and no cut order.
- FUNCTIONAL-REVIEW.md:629, the skill reads every file in the founder's folder, which for B2B includes `outreach-firstlines.csv` holding real named prospects and their email addresses, with no rule excluding them from a document that goes to a printer.
- FUNCTIONAL-REVIEW.md:639, no completeness check on the files it compiles.
- FUNCTIONAL-REVIEW.md:983, the insert can never contain its final section, for every founder.
- PRD-GAPS.md:74 and :506 and :728, the skill has no owning task in the PRD, so it keeps writing `playbook-insert.md` outside `ge` with no snapshot before overwrite.

**What it costs.**
The proposal's deliverables table has a personalised insert column.
Removing the skill means the insert is not generated by the plugin.

**Recommendation. Delete it.**
The buy-back is larger than the cost by a wide margin.
The insert was never producible as specified: the skill promises a PDF that nothing renders, and it cannot contain its final section because that section is built two days after the insert is supposed to exist.
What founders actually carry into the room is their own `growth-engine/` folder, which is already complete, already readable, and already theirs.
The printed playbook is printed by the programme, on the schedule already fixed for the printer, and does not depend on this skill.
Say this plainly in the README rather than leaving a skill on disk that produces a document nobody can use.
The privacy finding alone (FUNCTIONAL-REVIEW.md:629) justifies the decision: a skill that pulls named prospect email addresses into a document headed for a print run is a data incident waiting for a founder to run it.

If the reader decides to keep it instead, the minimum viable version is: markdown only with the PDF promise removed everywhere, an explicit exclusion list naming `outreach-firstlines.csv` and any file matching `*contacts*`, and the 90-day plan section replaced by a printed blank page the founder fills in on the Sunday.
That is roughly 0.5 dev-days and it still leaves the six-page ceiling unresolved.

#### S-02 Fold `connect` into `setup`. ADOPT, and this is the highest-value item in the section.

**What it removes.**
One skill (`skills/connect/SKILL.md`, unbuilt), one command (`commands/connect.md`, unbuilt), one trigger phrase founders have to learn, and one precondition chain between skills.

**What it buys back, which is the real point.**
The PRD puts the guided token walk at Session 2 (w/c 14 September) in two places: section 4.1 says "At Session 2 the mentors walk PIT creation together", and D-02's own PRE-WORK copy says "we create your token together at Session 2, do not create it alone".
But the PRD schedules the `connect` skill in lane 1.1, which is dated ready 19 September and reaches founders through the update drill at the top of Session 3 on 21 or 22 September.
That is PRD-GAPS.md:698, a verified HIGH: founders are told to create a token with a skill that does not exist in the version they have installed.

`setup` is lane 1.0.
It ships at the freeze.
Folding the GHL connection walk into `setup` moves the token walk from 19 September to the freeze date, and the date conflict disappears without a re-plan.

It also fixes a second thing.
Founders in a panic type one word.
The word they type is "setup" or "doctor", never "connect".
`setup` is already the skill both `commands/setup.md` and `commands/doctor.md` route to, so this puts every "is my machine right" question behind one skill.

**What it costs.**
`skills/setup/SKILL.md` grows from 87 lines to roughly 130.
It gains one branch: if `.state/receipt.md` already has a GHL section with a location name and an account count, skip the walk and print the receipt line instead of re-probing.
Skipping is not optional, it is the thing that stops a founder re-entering a token every session.

**Recommendation. Fold it in, and do it in the 1.0 lane.**
The connect walk is a checklist and two verification reads.
It contains no judgement, no voice, no generation, and no branching worth its own file.
Naming the seven Private Integration Token scopes exactly as the founder will see them in the GoHighLevel UI is the whole substance of the skill:
`socialplanner/post.readonly`, `socialplanner/post.write`, `socialplanner/account.readonly`, `socialplanner/statistics.readonly`, `contacts.readonly`, `contacts.write`, `locations.readonly`.
That list is now seven strings, not ten.
The three that were dropped with the DM inbox are `conversations.readonly`, `conversations/message.readonly` and `conversations/message.write`.
They are named here once so that a reader comparing this plan against an older PRD can see exactly which strings disappeared, and they must appear nowhere in any founder-facing file.
A shorter scope list is itself a simplification worth naming to founders: three fewer checkboxes to get wrong in a UI they have never seen, and no reason for anyone to ask why the plugin wants read access to their private messages.

#### S-03 Delete `skills/status/SKILL.md` and make `status` and `gate` thin routers over `ge index`. ADOPT.

**What it removes.**
One skill file (37 lines), one prose gate table that duplicates `schemas/gates.md`, and one class of drift where the gate list in the skill and the gate list in the forms disagree.

**What it costs.**
The status skill currently carries a safety net that `setup` does not: line 14 says "If you cannot find it, ask the founder where they built it. Do not assume they have done nothing."
That line is the only place in the toolkit that catches the most common failure in the programme.
It must move, not vanish.
Move it into `lib/paths.sh` behaviour and into the folded `setup` skill, and it is stronger there than it is in a skill nobody runs when they are lost.

**Recommendation. Delete the skill, keep both commands.**
`commands/status.md` becomes: run `ge index`, print it, add one sentence naming the next action.
`commands/gate.md` becomes: ask which of the three gates is being submitted, read `schemas/gates.md` for that gate and that track, cross it against `ge index` and the ledger, print the paste block.
That second router closes FUNCTIONAL-REVIEW.md:657, which is a BLOCKER: the current `/gate` never names the gate items, never asks which gate, and never branches by track.
It also closes FUNCTIONAL-REVIEW.md:667 (gate has no parent-or-home folder fallback) because `ge index` resolves the folder through `ge_find_home` before it prints anything.
So one deletion closes a blocker, closes a high, and removes a file.

#### S-04 Do not merge `ghl-publish` into `content-engine`. REJECT.

This is the obvious merge and it is wrong.

**The case for merging.**
Founders think of one thing: "my content".
Both skills own `content-30.md` and the `C|` rows in `ledger.md`.
A single skill means one ledger contract and no cross-skill precondition.

**Why it is still wrong.**
Three reasons, in order of weight.

First, the lanes.
Content generation is lane 1.0 and freezes on 3 September.
Publishing is lane 1.1 and lands 19 September.
Merging them means the 1.1 work edits a file that is under freeze, and every 1.1 change re-opens a 1.0 artifact three weeks after it was signed off.
Two files keep the freeze meaningful.

Second, the preconditions genuinely differ.
Generation needs a locked Founder Brain and nothing else.
Publishing needs a connect receipt, a live MCP, an accounts cache, a batch approval loop, pacing between calls, read-back verification and a failure path per row.
That is roughly 80 lines of operational instruction with no relationship to voice or pillars, and putting it in the same file makes the generation skill worse at the thing it is for.

Third, and this is the one that decides it: a founder who runs the content skill in Session 2 must not be offered publishing.
They have not connected yet, and the session does not have time for it.
A merged skill will offer it, because the instructions are in the file, and the model will read them.

**Recommendation. Keep them separate.**
Two files, two commands, two moments in the calendar.
The ledger contract is enforced by `ge ledger` in both cases, which is where the shared contract belongs.

#### S-05 Do not merge `outreach-b2b` and `audience-b2c`. REJECT.

Design rule 1 is that founders choose their track once and never see the other track's material.
One file holding both engines means the model is holding both engines in context every time either runs, and the failure mode is a B2C founder getting a cold-email deliverability brief.
The fork already lives in exactly one place, `commands/engine2.md`, which reads the `track` field and routes.
That is correct and it should not be touched.

#### S-06 Shrink the command surface from fifteen to twelve. ADOPT.

The PRD's component map implies fifteen commands: the ten that exist today plus `connect`, `publish`, `inbox`, `update` and `undo`.
PRD-GAPS.md:134 records that the PRD's own stated command surface is three short of what its architecture implies, and that D-01 was specified against the smaller number.

After the client's cut and the two folds above, the surface is twelve:

| Command | Routes to | Lane | Note |
|---|---|---|---|
| `/growth-engine:setup` | setup skill | 1.0 | Now also carries the GHL connect walk (S-02) |
| `/growth-engine:doctor` | setup skill | 1.0 | Same skill, symptom-first entry. Not a second skill |
| `/growth-engine:brain` | founder-brain | 1.0 | |
| `/growth-engine:content` | content-engine | 1.0 | |
| `/growth-engine:publish` | ghl-publish | 1.1 | |
| `/growth-engine:engine2` | outreach-b2b or audience-b2c by track | 1.1 | |
| `/growth-engine:ops` | ghl-workflows | 1.1 | |
| `/growth-engine:plan` | growth-plan | 1.0 | |
| `/growth-engine:status` | inline over `ge index` | 1.0 | No skill (S-03) |
| `/growth-engine:gate` | inline over `ge index` and `schemas/gates.md` | 1.0 | No skill (S-03) |
| `/growth-engine:update` | inline | 1.0 | |
| `/growth-engine:undo` | inline over `ge undo` | 1.0 | PRD declares it twice and no task built it (PRD-GAPS.md:190) |

Removed against the PRD's implied fifteen: `connect` (folded into setup by S-02), `inbox` (cut by the client on 21 August, along with the `dm-inbox` skill, `ge dmgate` and PRD task B-07), `playbook` (S-01).

Ten of the twelve commands do not exist yet. On 21 August 2026 `/Users/pmudh/Documents/GitHub/Atlanta/plugins/growth-engine/commands/` contains exactly ten files: `brain.md`, `content.md`, `doctor.md`, `engine2.md`, `gate.md`, `ops.md`, `plan.md`, `playbook.md`, `setup.md`, `status.md`.
Reaching the twelve above therefore means: delete `playbook.md` (S-01), and add `publish.md`, `update.md` and `undo.md`.

**What it costs.** Nothing. Every removed command's function is still reachable.

**A side effect worth banking.**
The PRD's own 1.0 cut line, in its lane-fit table, lists "B-07 dmgate to 1.1" as one of the four things it would cut to bring the 1.0 lane from roughly 15.5 dev-days down to roughly 12.0.
B-07 is now cut outright by the client, not deferred, so that saving is permanent rather than pushed into a lane that is already full.

**Recommendation. Adopt, and pin the number in CI.**
`scripts/validate.sh` line 133 currently reads, verbatim:

```sh
[ "$SKILL_COUNT" -eq 9 ] && ok "9 skills found" || warn "expected 9 skills, found $SKILL_COUNT"
```

Two problems with it. The constant is 9 and the target is 8, and the result is a `warn`, which does not fail the run.
Change the constant to 8, change `warn` to `err` so the count is enforced, and add the matching command constant in the same commit, so the count is a check rather than a comment.
PRD-GAPS.md:320 records that CI-01 does not update these hard-coded counts, which means the counts silently become wrong the moment a skill is added.

#### S-07 Eight skills, not twelve. ADOPT.

The PRD declares twelve skills.
After the client's cut and the folds above the plugin ships eight:

`setup`, `founder-brain`, `content-engine`, `ghl-publish`, `outreach-b2b`, `audience-b2c`, `ghl-workflows`, `growth-plan`.

Gone from the PRD's twelve: `dm-inbox` (client cut), `connect` (S-02), `playbook-export` (S-01), `status` (S-03).

**What it costs.**
Nothing is lost that a founder uses.
The build saving is real: PRD-GAPS.md:160 records that three of the twelve declared skills have no owning task in Part Three at all, and two of those three are now deleted, so the unbudgeted work shrinks rather than needing to be found.

**Recommendation. Adopt.**
Then add the one task that PRD-GAPS.md:728 demands and the PRD never wrote.
That gap names three shipped skills that write founder files and have no owning task in the PRD's Part Three: `audience-b2c`, `growth-plan` and `playbook-export`.
`playbook-export` is deleted by S-01, so it drops out.
That leaves `audience-b2c` and `growth-plan`, and `ghl-workflows` is added to the list because it also writes a founder file (the copy map) and is equally unwired.
The task is: apply the FB-01 and C-01 rewire pattern (init, snapshot, write, log, index) to `audience-b2c`, `growth-plan` and `ghl-workflows`, so that every remaining skill that writes a founder file goes through `ge snapshot` first.
Budget 0.75 dev-days.
Add a check to `scripts/validate.sh` that fails if a skill writes a file named in the state model without naming `ge snapshot` in the same file.
Without the CI check the rule is prose and it will drift again, which is exactly how it drifted the first time.

#### S-08 Cut the state model from seven machine-read files to five. ADOPT.

The PRD's section 2.3 declares these machine-read files:
`.state/HOME`, `.state/index.md`, `.state/receipt.md`, `.state/ghl-accounts.md`, `.state/snapshots/`, plus `ledger.md` and `ops-log.md`, plus `.state/log.bytes` which B-08 reads and no task writes (PRD-GAPS.md:240).

Three reductions.

**8a. Merge `.state/ghl-accounts.md` into `.state/receipt.md`.**
Removes one file, one schema, one writer and one staleness question.
Both files hold the same class of thing: what we verified about the founder's GoHighLevel connection and when.
The receipt gains a `## GHL accounts` section listing account id, platform and name, one per line.
Cost: refreshing the account cache now rewrites the receipt, so the receipt needs a snapshot before write, which it should have had anyway.

**8b. Delete `.state/log.bytes` and change the doctor check.**
The watermark exists so `ge check` can prove `ops-log.md` never shrank.
But `ge log` is the only writer and it only ever appends, and the snapshot ring already covers recovery.
The watermark is an undeclared file, an extra writer, an extra failure mode, and a schema that no task writes.
Replace the check with something that needs no state: `ops-log.md` line 1 is the fixed header, the file is non-empty, and every day header is in ascending date order.
Cost: a founder who hand-edits their own ops log down to nothing is no longer detected.
That is an acceptable loss. Nobody hand-edits that file, and if they do, `ge undo` gets it back.

**8c. Make `ge index` print to stdout by default and write the file only on `ge index --write`.**
This is the one worth arguing for.
`index.md` is derived and rebuildable, which means it is a cache, which means it can be stale, which means the doctor needs an index-freshness check, which means there is a failure mode ("your index is stale") that founders will hit and will not understand.
Printing on demand removes the staleness concept entirely.
`status`, `gate` and `context` all read it fresh.
Cost: a few file stat calls per invocation, which at this scale is free.
Keep `--write` so a rehearsal can capture the table as evidence.

**Result.** The machine-read state becomes:

```
growth-engine/
├── ledger.md                 one writer: ge ledger
├── ops-log.md                one writer: ge log, append only
└── .state/
    ├── HOME                  one writer: ge init. One line, absolute path
    ├── receipt.md            one writer: ge receipt. Setup evidence + GHL accounts
    └── snapshots/            one writer: ge snapshot. Ring of 10 per file
```

Five things, each with exactly one writer, and nothing derived sitting on disk pretending to be truth.

**Recommendation. Adopt all three.**
The anchor file `HOME` is not negotiable and is not on this list.
It is the mechanism that fixes the single most common failure in the programme, and it stays.

#### S-09 Two schema files, not five. ADOPT.

The PRD declares `schemas/{ledger,ops-log,index,gates,brain}.md`.
PRD-GAPS.md:170 records that no task writes four of them: only `gates.md` is created, and then only as a side clause inside B-06.

**Recommendation.**
Ship two files.

`schemas/state.md` holds every machine format in one place: the `HOME` line, the `C|` and `O|` ledger row grammars with their enums, the `ops-log.md` day header and entry grammar, and the receipt section list.
Each format is four to eight lines. One file keeps them synchronised with `ge` and gives CI one lint target.

`schemas/gates.md` stays separate because it is not a format, it is founder-facing content: the list of items each of the three gates requires, forked by track.
It is read by `commands/gate.md` and by `ge index`, and it is the single source that FUNCTIONAL-REVIEW.md:657 says is currently missing.

**What it removes.** Three files, three lint targets, and three opportunities for a format to be documented in one place and implemented in another.

#### S-10 Never let `bin/ge` on PATH be load-bearing. ADOPT.

Decision Gate B asks whether hooks fire and whether `bin/` lands on PATH across the four surfaces.
PRD-GAPS.md:200 records that the gate branches only on hooks, and nothing decides what happens when `ge` is not directly invokable, while every skill task assumes it is.

**Recommendation.**
Write every `ge` call in every skill in the long form from day one:

```
sh "${CLAUDE_PLUGIN_ROOT}/scripts/ge.sh" <subcommand> ...
```

Ship `bin/ge` as a three-line shim anyway, for humans typing at a terminal.
But no skill, no command and no document ever depends on it.

**What it removes.**
One entire branch of Decision Gate B, and the possibility of discovering on 21 September that Windows Home founders have no working brain.
**What it costs.**
Skill text is slightly longer and slightly uglier.
That is a good trade for removing a whole-platform failure mode.

#### S-11 Ship the SessionStart hook, promise nothing about it. ADOPT.

The hook is four lines of JSON and it is fail-open by design: no folder means exit 0, silent.
Ship it.
But write no documentation that depends on it firing, put the PIT age nudge in `ge check` as well as in `ge context`, and do not spend a task on it beyond the `hooks.json` file.
PRD-GAPS.md:788 notes that the Gate B fallback names "skills call `ge` directly" as the remaining guarantee, and then no task makes any skill call `ge context`.
Fix that by adding one line to the SPEC of each skill that gates on folder state, in the 1.0 lane, before Gate B is answered.
Then the hook is a convenience and the answer to Gate B stops mattering.

#### S-12 Delete `planning/spike/gate-ab-plugin/` once Gates A and B are answered. ADOPT.

A throwaway probe plugin with its own `.claude-plugin/plugin.json`, `.mcp.json` and `bin/ge-test` currently sits inside a public repository.
On 21 August 2026 `git ls-files planning/spike` from `/Users/pmudh/Documents/GitHub/Atlanta` returns five tracked files: `planning/spike/gate-ab-plugin/.claude-plugin/plugin.json`, `planning/spike/gate-ab-plugin/.mcp.json`, `planning/spike/gate-ab-plugin/bin/ge-test`, `planning/spike/gate-ab-plugin/commands/spike-check.md`, `planning/spike/gate-ab-plugin/hooks/hooks.json`.
Anyone browsing the repo finds two plugin manifests and has to work out which one is real.
Once spike sections S-05 (Decision Gate A, userConfig in Cowork) and S-06 (Decision Gate B, hooks and the bin floor) of `/Users/pmudh/Documents/GitHub/Atlanta/planning/spike-findings.md` carry their verdicts, the probe has no further use.

**Recommendation.** Delete it in the same commit that records the Gate A and Gate B verdicts, and say so in the commit body.
The exact command, run from `/Users/pmudh/Documents/GitHub/Atlanta`:

```sh
git rm -r --quiet planning/spike/gate-ab-plugin && bash scripts/validate.sh
```

Zero cost, one fewer confusing artifact in a public repo that 130 founders will be sent to.

#### S-13 Make the dash check in `scripts/validate.sh` locale-independent before it fails on the wrong thing. ADOPT.

This item is about two literal characters that this document is not allowed to contain, so both are written by their Unicode code point throughout: U+2014 EM DASH and U+2013 EN DASH.
Any command below that needs one of them builds it with `printf` rather than embedding it, which is also why every command below is copy-pasteable into a file that the house style forbids from containing the characters themselves.

**What is there now.**
Line 201 of `/Users/pmudh/Documents/GitHub/Atlanta/scripts/validate.sh` is a `grep` whose pattern is a two-element bracket expression containing U+2014 and U+2013, assigned to a variable named `DASHES` and filtered through the `founder_files` helper defined at line 24.
Line 9 of the same file already does `export LC_ALL="en_US.UTF-8"`, which is the right instinct and is why the check works today.

**The residual bug.**
A bracket expression holding multibyte characters is only a character class if the active locale is a UTF-8 locale.
`export LC_ALL="en_US.UTF-8"` does not guarantee that: if the locale is not installed on the machine, glibc and Git Bash silently fall back to the C locale rather than failing.
Minimal Ubuntu CI images frequently ship without `en_US.UTF-8` generated, and Windows Git Bash locale support varies by installer version.
Under the C locale `grep` matches the pattern byte by byte.
U+2014 is the byte sequence `E2 80 94` and U+2013 is `E2 80 93`, so the class collapses to the six-byte set `{E2, 80, 94, 93}` and matches any character containing any of those bytes.
Box-drawing characters are exactly that: U+2500 BOX DRAWINGS LIGHT HORIZONTAL is `E2 94 80`, and U+251C BOX DRAWINGS LIGHT VERTICAL AND RIGHT is `E2 94 9C`.

**Reproduce it in one line.**
Run this from anywhere. It builds the two box-drawing characters and the two dash characters from their byte sequences, so nothing here depends on your editor:

```sh
printf '\342\224\234\342\224\200\n' | LC_ALL=C grep -c "[$(printf '\342\200\224\342\200\223')]"
```

It prints `1`, which is a false positive: the input contains no dash of any kind.
Run the same thing with a working UTF-8 locale and it prints `0`:

```sh
printf '\342\224\234\342\224\200\n' | LC_ALL=en_US.UTF-8 grep -c "[$(printf '\342\200\224\342\200\223')]" || echo "0 matches, correct"
```

**Why it has not bitten yet.**
The repository passes today because no founder-facing file contains a tree diagram.
The first person who puts a folder tree in `README.md` or in a skill, on a runner whose locale did not resolve, gets a hard failure that says "em dash or en dash in a founder-facing file" and points at a line containing neither.
That is a check creating difficulty, which is the thing this whole section exists to remove.

**Fix.** Match the two exact byte sequences instead of a character class, which needs no locale at all.
Replace line 201 with:

```sh
DASHES=$(grep -rn -e "$(printf '\342\200\224')" -e "$(printf '\342\200\223')" $(founder_files) 2>/dev/null || true)
```

Two `-e` patterns, each a fixed three-byte sequence, so there is no bracket expression for a locale to reinterpret.
`scripts/validate.sh` starts `#!/usr/bin/env bash`, so `$'\xe2\x80\x94'` would also work, but the `printf` form above is POSIX and survives if the script is ever moved to `#!/bin/sh`.

Keep line 9's `export LC_ALL="en_US.UTF-8"` as well. It is harmless and it makes `sort` deterministic elsewhere in the file.

**Acceptance, two halves.**
`founder_files` at line 24 covers `README.md`, every `*.md` under `docs/`, and every `*.md` under `plugins/growth-engine/`, so the probe file has to live in one of those.

First, a tree diagram must not trip the check. Run from `/Users/pmudh/Documents/GitHub/Atlanta`:

```sh
printf 'tree probe x\342\224\234\342\224\200x\n' > docs/_dashprobe.md && bash scripts/validate.sh | grep -i 'dash'; rm -f docs/_dashprobe.md
```

That must print the `ok    no em or en dashes` line and nothing else.

Second, a real dash must still trip it. Run from the same directory:

```sh
printf 'real probe x\342\200\224x\n' > docs/_dashprobe.md && bash scripts/validate.sh | grep -i 'dash'; rm -f docs/_dashprobe.md
```

That must print the `FAIL` line naming `docs/_dashprobe.md`.
Both halves are required. A check that never fires is not a fixed check.

Ten minutes, and it removes a future hard failure with a message that lies about its own cause.

#### Summary of section 7.1

| Dimension | PRD as written | After these simplifications |
|---|---|---|
| Skills | 12 | 8 |
| Commands | 15 implied | 12 |
| Machine-read state files | 7 (one of them undeclared) | 5 |
| Schema files | 5 declared, 1 built | 2 |
| FUNCTIONAL-REVIEW findings closed by deletion alone | 0 | 9 |

The nine are FUNCTIONAL-REVIEW.md lines 599, 609, 619, 629, 639, 983 and 993, all closed by S-01, plus lines 657 (a BLOCKER) and 667, both closed by S-03.
"Closed by deletion alone" means no new code is written to close them: the file that carried the defect stops existing.

Net effect on the build: roughly 2.5 dev-days removed from a lane the PRD's own table admits is over by 4.5 days, and four fewer files that a single maintainer has to keep correct through three release lanes.

---

### 7.2 The risk register

The PRD carries no risk surface at all.
The word "risk" appears zero times in its 547 lines, and the five-row register from the plan it supersedes (`planning/glitch-standard-plan-2026-08-20.md`, section 7) was deleted without replacement.
That is PRD-GAPS.md:678, a verified HIGH, and its consequence is exact: Part Zero rule 10 declares anything not in the PRD to be post-event backlog, so a risk discovered on 2 September has nowhere to be written down and no owner.

This rebuilds the register as a live document.

**Where it lives.** `/Users/pmudh/Documents/GitHub/Atlanta/planning/RISKS.md`, in the repository, so that the executor session working in the repo can read and update it without a second folder.
Anything commercial, personal or rate-related goes in `/Users/pmudh/Downloads/Atlanta/launchhouse-atlanta/STATE.md` instead, which is outside the repository.

**How a row is worked.**
A row is open until its Resolve-by date, on which one of exactly three things is written into the row: `RESOLVED: <one sentence of evidence>`, `TRIGGERED: <which mitigation was taken>`, or `SLIPPED: <new date and why>`.
A row may slip once.
A second slip on the same row is escalated to the client in writing rather than moved again.

**When it is reviewed.**
Three fixed points: Tuesday 26 August (post spike), Tuesday 2 September (the day before freeze), Monday 15 September (the re-verification sweep).
Plus once on Thursday 24 September, the fix window, when the only question is which rows are still open going into the event.

**How a new risk is added.**
Any session, at any time, appends a row.
This overrides PRD Part Zero rule 10 for risks specifically: a risk is not a scope change and does not go to backlog.

#### Table A, build risks, now to the 3 September freeze

| ID | Risk | Exposure | Early warning sign | Mitigation | Owner | Resolve by |
|---|---|---|---|---|---|---|
| R-01 | The GoHighLevel MCP does not behave as documented: fewer tools, unnamed tools, or OAuth required rather than a Private Integration Token | Roughly 6.0 of the 12.0 dev-days in lane 1.1 plus G-03 in lane 1.0. Publish, connect and reconnect all stall | Spike section S-02 returns a tool count below 36, or a tool list without `socialmediaposting_create-post`, or a 401 that names OAuth | Add a three-way decision gate to spike section S-02 before it is run: (a) named tools present, proceed; (b) present but one required tool missing, name which system degrades and to what, publish drops to CSV; (c) no named tools on either endpoint, or OAuth required, stop and take the CSV plus manual path for v1. Cost each branch in dev-days in the same edit | Maintainer | 25 Aug |
| R-02 | The GoHighLevel tier founders are told to buy does not expose Private Integration Tokens, or does not carry comment-to-DM capture | Connect, publish and the whole B2C inbound machine fail for every founder even though all of it passed on the agency account. Surfaces at the 23 September clinic, one day before the fix window | The vendor rep answers verbally but not in writing, or the test location is on a different tier from the one the onboarding email will name | Pin the spike test location to the exact tier founders will buy. Get the tier name, the price and the PIT and comment-to-DM confirmation in writing. If the tier does not carry it, the CSV path and a manual inbound script ship instead and both are kept working regardless | Maintainer, with the vendor rep | 26 Aug |
| R-03 | Apollo's MCP action set does not expose custom-field writes, sequence creation, or contact creation | `{{first_line}}` personalisation dies mid-build, or the Apollo route dies for roughly 65 B2B founders | Spike section S-07 enumerates actions and one of the three is absent from the list | Add a decision gate to spike section S-07 with three named failure modes: no custom-field write, the opener drops to a static line and the skill says so; no sequence create, the manual export route becomes primary for all B2B with its own effort figure; no contact create, stop. Add one line to the outbound task's acceptance proving the manual route still produces a complete sendable set of 25 whatever the gate says | Maintainer | 25 Aug |
| R-04 | The paid Apollo seat was not in the tool stack that was sold, and no price is recorded anywhere | Roughly 65 founders are told on 4 September to buy something that was not in the commercial promise, at a cost nobody has written down | The onboarding costs table is being drafted and there is still no figure to put in it | Agree the seat cost and record a figure before the PRE-WORK rewrite is written, because PRE-WORK is what tells founders to spend the money. If it is not agreed by 28 August, state in the outbound skill that the manual route is the documented default for B2B and Apollo is the upgrade | Maintainer, with the client | 28 Aug |
| R-05 | Decision Gate A returns no: no masked credential prompt appears in Cowork, or the header does not substitute | The credential path inverts. The fallback (a token typed into a local file in a text editor) is materially harder for non-technical founders and has no verbatim manifest, no component-map entry and no effort figure | The probe plugin installs but no prompt appears, or a header error rather than a 401 | Write the fallback manifest as a second verbatim block now, before the gate is run, and put a delta figure against it even if it is only +0.5 dev-days. Then the gate is a choice between two costed things rather than a discovery | Maintainer | 25 Aug |
| R-06 | Decision Gate B returns no: hooks do not fire, or `bin/` is not on PATH, on one or more of the four surfaces | Founders on the hardest configuration (Windows Home, Code tab, Git Bash) get no session-start context and, in the PATH case, no working brain at all | Any one of the three probe receipts comes back with a no in either field | S-10 removes the PATH half entirely by writing every `ge` call in long form. S-11 removes the hook half by putting every hook-delivered warning in `ge check` too. Take both before the gate is run and the gate stops being able to hurt | Maintainer | 25 Aug |
| R-07 | The spike slips past 25 August | The execution contract says the executor works in order and marks Phase 0 "DO THIS FIRST", so a three-day spike slip costs three days of total progress rather than three days of integration progress, against a lane already over by 4.5 days | 23 August arrives with any of spike sections S-02, S-03, S-05, S-06 or S-07 still marked PENDING | Add one paragraph to the execution contract: Phase 0 gates only the tasks that cite a finding. The brain (Phase 2) and the Founder Brain rewrite (Phase 3), roughly 7.0 spike-independent dev-days, proceed in parallel from day one. Then add the dated checkpoint: if the spike is not complete by 25 August, the integration lane drops to CSV plus manual and the executor is told so in writing rather than waiting | Maintainer | 25 Aug |
| R-08 | One maintainer carrying the build, the spike, the sessions, the mentor chasing and the printer handover | Any illness, any family event, any two-day loss, and there is no second person who can pick up a POSIX sh brain, a plugin manifest and three GoHighLevel snapshots | Two consecutive days with no commits, or a review point passing with no rows updated | Three things, in order of value. First, the cut lines in section 7.5 are pre-agreed so a cut can be made by someone else. Second, a second technical anchor is named and given repository access and one walkthrough before 4 September. Third, `planning/` in the repository is kept current enough that a competent stranger can resume from it, which is what this delivery plan is for | Maintainer, with the client | 28 Aug |
| R-09 | A vendor changes a free tier, a rate limit or an API mid-runway | Apollo's all-plans OAuth was described as available for a limited time. The GoHighLevel MCP is new. Google Forms free tier is what all three gate forms run on. Any one of them moving between the freeze and the event breaks a path that was verified in August | A tool that worked in the spike returns a different shape, a 402, or a new consent screen | Do not re-verify once. Re-verify on a fixed ritual: the 15 September sweep re-runs one publish, one Apollo enrollment and one form submission against live accounts, and the 24 September fix window re-runs the same three. Keep every fallback path working rather than documented, which means the CSV export and the manual send sheet are exercised in the full-arc rehearsal, not just written | Maintainer | 15 Sept, then 24 Sept |
| R-10 | No rollback path. Nothing states what a founder does if 1.1.0 is worse for them than 1.0.0, or if the Session 3 update does not land | The update drill is the delivery mechanism for two thirds of the product, run live at the top of Session 3, four days before the event. The only documented escape today is a generic two-attempts-then-Slack rule | The update rehearsal produces any surface where the version does not move, or moves and then cannot be moved back | Three lines added to the update command, and they must exist at the freeze, not at 1.1. First, the recovery for an update that does not land: the reinstall walk, named per surface. Second, the rollback: `/plugin marketplace update launchhouse` then install the pinned previous version by tag, with the exact string written out. Third, the honest floor: name plainly what still works on 1.0.0 (brain, content, CSV, ops copy, manual outbound, the 90-day plan) so a stuck founder knows they are not stranded. Rehearse the rollback once, in the same rehearsal as the update | Maintainer | 3 Sept |
| R-11 | Lane 1.1 does not fit. It carries 12.0 dev-days into 10 working days, plus whatever the 1.0 cut line pushes into it, plus four live session deliveries, and it names no cut order | An unplanned cut gets made under pressure in the week of the event, removing a system that was sold, in front of 130 people, with no time to re-plan the session | 8 September arrives with less than half of the 1.1 lane complete | Write the cut order now, in section 7.5, in the same form as the 1.0 lane's. Recompute the lane with the pushed-in items and the four session days deducted. Set a midpoint decision on 8 September and a hard call on 12 September, both in the register | Maintainer | 8 Sept, hard call 12 Sept |
| R-12 | Nothing runs a fictional founder through the whole arc | Every join between eight skills chained through a new CLI is first exercised by 130 founders on 25 September. Hand-off defects between skills are the failure mode a chain of this length actually has, and there is no test that can find them | The 1 September mentor review arrives and the worked example folders still contain only `founder-brain.md` | One full-arc run per track, as the two existing fictional founders, through every command in order, output landing in `plugins/growth-engine/assets/examples/`. Budget 1.5 dev-days. It replaces nothing and it is the only test that exercises the joins. It also produces the finished examples the mentors are booked to review | Maintainer | 1 Sept |
| R-13 | Internal planning documents sit inside a public repository | `planning/` is tracked by git and the repository has been public since 18 August. Anything written into `planning/delivery/` is readable by anyone with the URL from the moment it is pushed | A commit adds a file under `planning/` naming a person, a rate, a mentor brief or a client term | Two things. Add a validate.sh check that fails on a name-or-money pattern under `planning/` (a small explicit deny list of surnames and a currency symbol is enough and takes ten minutes). And keep the split the project already decided: internal state stays in the private folder outside the repository | Maintainer | 22 Aug |
| R-14 | The freeze date is stated two ways | The project's locked fact table says Thursday 3 September for the v1.0.0 freeze, with 4 September as ship day. The PRD's release task says 4 September, colliding freeze with ship | Nobody notices until the onboarding email is due and the tag does not exist | Use 3 September for the freeze and 4 September for the public link and the onboarding email, per the locked fact table, and correct the PRD's release task in the same commit that opens the delivery plan | Maintainer | 22 Aug |

#### Table B, delivery risks, 4 September to the event

| ID | Risk | Exposure | Early warning sign | Mitigation | Owner | Resolve by |
|---|---|---|---|---|---|---|
| R-15 | Founders scatter work across folders | The single most common failure in the programme. It hits the same founder in week 1, week 2 and week 3, each time costing a support message and risking a duplicate Founder Brain, against one maintainer | Any Slack message that starts "it says I have not done anything" | The anchor is the whole answer and it must be everywhere: `ge init` writes `.state/HOME`; `ge init` also writes a short `CLAUDE.md` marker into the folder so any future session in it self-identifies; `ge check` compares the anchor against the current directory and prints the full path of the right folder; `setup` asks where they built it before ever creating a second folder; the search recipe is written per surface, including the Cowork case where the model can only see the folder they picked | Maintainer | 3 Sept |
| R-16 | Scheduled posts land at the wrong hour | If `scheduleDate` is interpreted as UTC and the founder means 09:30 local, every scheduled post for 130 people lands at the wrong time, and it is discovered by their audience | The spike timezone line is filled in with a hedge rather than one unambiguous sentence | The spike must state the rule in one sentence with pasted evidence of what the GoHighLevel UI displayed. The publish skill shows the preview table in the founder's local time and takes their yes against that table. Before any batch, one test post is scheduled 15 minutes out and read back | Maintainer | 25 Aug, re-verified 15 Sept |
| R-17 | The CSV is written from the unedited draft | A verified blocker. The CSV is written before the founder's edit pass and nothing regenerates it, so the founder edits `content-30.md` and then imports the unedited `content-30.csv` at the clinic. Every founder who edits is affected | Any founder's `content-30.csv` has an older modification time than their `content-30.md` | Make CSV export the last step of the edit pass, not a step before it. Add a `ge lint` check that fails when `content-30.csv` is older than `content-30.md`, and surface it in `ge check`. This is one comparison and it closes a blocker | Maintainer | 3 Sept |
| R-18 | A B2C founder discovers that few or none of their 30 pieces can be scheduled | The PRD sets the B2C mix at 15 short-form video scripts, 8 carousel outlines and 7 single-image captions, so 23 of 30 are media lane on the PRD's own arithmetic. FUNCTIONAL-REVIEW.md:835 corrects that upward for Instagram specifically: Instagram accepts no caption-only post, so the 7 single-image captions need an image too and the schedulable count on Instagram is 0 of 30 until media is recorded and uploaded to GoHighLevel Media Storage. Social Planner requires a public media URL in `imageUrls` or `videoUrls`. If the publish preview shows 7 rows, or 0, when the founder expects 30, the room reads it as the product not working | The publish rehearsal on a B2C example shows a single-digit or zero schedulable count and nobody has written the sentence that explains it | Four things. Disclose the split at generation time, not at publish time: the content skill states how many pieces are text lane and how many are media lane the moment it finishes, and states the Instagram case separately from the LinkedIn and Facebook case. Emit a shot list alongside `content-30.md` for B2C. Generate a publishable caption for every media piece so the row is at least exportable. Move the recording into Session 2 homework rather than the 23 September clinic. Never let a founder believe 30 posts are going out | Maintainer | 3 Sept |
| R-19 | Rate limiting during the clinic | 130 founders publishing inside the same hour on 23 September, through one vendor API, is the highest concurrent load this system will ever see, and the 429 shape is currently unknown | The spike's rapid-call probe produces a 429 with no documented retry-after, or produces none at all because 15 calls was too few | Pace calls inside the publish skill, cap a batch at 10, and make re-running idempotent by skipping rows the ledger already marks scheduled. Then stagger the clinic by track so both halves of the room are not publishing at the same minute. The idempotent re-run is the important half: it turns a rate limit from a failure into a wait | Maintainer | 15 Sept |
| R-20 | Instagram action-blocks a founder mid-Saturday | The toolkit itself predicts this in the B2C skill's pacing warning. Some proportion of roughly 65 founders will hit it during a timed Saturday sprint, and nothing tells them what a block looks like, that it is temporary, or that they must stop rather than retry | The first block happens in the room and the answer is improvised | Three lines in the output file and the same three lines in the Saturday run sheet: what the block message looks like, stop immediately and do not retry, resume the remainder over the following days and mark where you stopped. The room answer and the file answer must be identical | Maintainer | 3 Sept |
| R-21 | A founder pastes a token into the conversation | Secrets in a transcript, on 130 machines, with no way to un-say it | Any support message containing a string starting `pit-` | Masked prompt as the primary path. The connect walk says the sentence explicitly before the founder opens the vendor UI. `ge check` greps the founder's folder for `pit-` and fails loud if it finds one, naming the file. Skills never echo token values, which is already a policy wall and should also be a CI grep over the skill text | Maintainer | 3 Sept |
| R-22 | The venue network fails, or does not carry 130 concurrent sessions | Every MCP call is client-side HTTPS. With no network, publishing, enrollment and any live vendor read stop | The written internet specification does not arrive from the venue contact, or arrives without a concurrent-user figure | Get the specification in writing before 18 September. Then sequence the weekend so network-dependent steps are never on the critical path: generation, the Founder Brain, workflow copy and the 90-day plan all work offline, and only publish and enroll do not. Carry mobile hotspots as the physical fallback | Client contact, chased by the maintainer | 18 Sept |
| R-23 | The Session 3 update does not land for some founders | Two thirds of the product arrives through one live drill, four days before the event | The update rehearsal shows any surface where the version does not move | R-10's three lines, plus: run the drill as the first ten minutes of Session 3 rather than the last, so there is a session left in which to fix it, and have the assistants read `ge check`'s version line rather than asking founders what version they think they have | Maintainer | 19 Sept |
| R-24 | The assistants are not trained on features that do not exist until 19 September | Four to six people are the support layer for 130 founders across three days, on a product whose event-week half lands two days before the event | 19 September arrives with no walkthrough booked | Book the walkthrough for 19 or 20 September and give it the full-arc rehearsal transcript as its material rather than the source. If the 1.1 lane slips, the walkthrough covers the fallback routes instead, which is why section 7.3 has to be written before then | Maintainer | 19 Sept |
| R-25 | The three snapshot share links have never been imported into a clean location | The clinic is built entirely on those three imports. A share link that only works inside the agency account fails for all 130 at once | The asset README still carries TODO placeholders inside a released version | Test-import each of the three into a genuinely clean location and confirm the custom value placeholders render, before the freeze. Extend the CI TODO gate to every asset README, at every version, not just one file at 1.1.0 | Maintainer | 3 Sept |

---

### 7.3 Fallbacks that must be specified

A fallback is not a sentence that says something is a fallback.
It is a route: a trigger, a named path, who does it, what state the system is left in, and how the founder knows it worked.
Everything below is written to that shape.
Anything that reduces to "then do it by hand" without a run sheet is not on this list, because it is not a fallback.

#### F-01 Publishing when the GoHighLevel MCP is unavailable

**Trigger.** Any of: the tool is absent from the catalog, three consecutive calls return 5xx, or the founder has no connect receipt.

**Route.** The CSV path, which is the documented backstop and which must be exercised, not merely written.

1. The content skill regenerates `./growth-engine/content-30.csv` in the founder's working folder, as the final step of the edit pass, with the header row byte-identical to the fixture at `/Users/pmudh/Documents/GitHub/Atlanta/plugins/growth-engine/assets/ghl/social-planner-template.csv`.
   That fixture does not exist yet. On 21 August 2026 `plugins/growth-engine/assets/ghl/` contains only `README.md`. The fixture is produced by spike section S-03, which downloads the in-app Social Planner CSV template and commits it verbatim. Until that download happens this fallback has no header to compare against, which makes spike section S-03 a hard precondition for F-01 rather than a nice-to-have.
2. `ge lint` confirms the header matches (a `cmp` of the first line against the fixture) and that the row count is within the Social Planner import limit of 90.
3. The founder imports the file in the Social Planner UI, at the 23 September clinic, with an assistant present.
4. The founder marks the batch as scheduled with one command rather than per row:

   ```sh
   sh "${CLAUDE_PLUGIN_ROOT}/scripts/ge.sh" ledger set-content --all-approved status scheduled
   ```

   The `--all-approved` selector is new. PRD task B-05 specifies `ge ledger` with `add-content`, `set-content <id> <field> <value>`, `add-outreach`, `set-outreach <email> ...` and `list [C|O] [--status X]`, and it has no bulk form. Add `--all-approved` to B-05's scope, with the same snapshot-first behaviour as every other ledger mutation. Without it this fallback asks a founder to run 30 commands by hand at a clinic, which nobody will do correctly.

**State left behind.** Ledger rows read `scheduled` with `-` in the post id column, which is the honest record: scheduled, not read-back-verified.
The doctor does not treat a missing post id as a failure when the receipt shows no GHL connection.

**How the founder knows it worked.** They see their posts in the Social Planner calendar with their own eyes, at the clinic, with someone standing next to them.
That is a weaker verification than a read-back and the skill says so in one sentence rather than pretending otherwise.

**What must be true for this to work on the day.** The CSV must have been generated after the edit pass (R-17), and the header fixture must have been re-downloaded and compared during the 15 September sweep.

#### F-02 A publish batch that fails part way through

**Trigger.** A 429, a 401, or a network drop after some rows have been created.

**Route.** Nothing clever. The ledger is the recovery mechanism.

Each row is written to the ledger the moment its post id comes back, before the next call is made.
Re-running the publish command skips any row already marked `scheduled`.
So the recovery instruction is one line: wait a minute, run publish again.

**State left behind.** A mix of `scheduled` and `approved` rows, which is accurate.
Rows that were attempted and failed are marked `failed` with the reason in the ops log, so the founder can see which ones and why.

**Why this is the right design.** It removes the need for any retry logic, any backoff table, and any partial-batch reconciliation.
The idempotent re-run does all of it.

#### F-03 The GoHighLevel token stops working mid-session

Private Integration Tokens are static and do not expire on a timer, but they can be revoked, regenerated, or scoped wrongly, and the vendor recommends rotation at 90 days.

**Trigger.** Any 401 from any GoHighLevel call, anywhere in the plugin.

**Route.** One walk, reached from wherever the 401 happened.

1. The skill stops. It does not retry, and it does not continue with the rest of the batch.
2. It prints the reconnect walk: open the vendor settings, private integrations, create a token with the seven scopes listed in full in the message, then re-enter it through the same masked prompt as the first time.
3. `ge receipt` is rewritten with the new creation date.
4. The founder re-runs the command they were running. The ledger makes that safe (F-02).

**Pre-emption, so the walk is rarely needed.** `ge check` warns when the receipt's recorded creation date is more than 80 days old, and prints the same walk before anything breaks.

**The thing that must not happen.** The founder must never be asked to paste a token into the conversation to "check it".
If a diagnostic needs to know whether the token works, it makes a read call and reports pass or fail. It never asks to see the value.

#### F-04 Apollo will not connect, or lacks a capability

**Trigger.** OAuth does not complete on the founder's surface, the founder is on Microsoft 365, the founder declined the paid seat, or the spike found a missing capability (R-03).

**Route.** The manual send path, which is first-class and must read as a route rather than a consolation.

The outbound skill produces the same artifacts either way:

1. `outreach-firstlines.csv`: 25 rows, each with first name, company, email, and the personalised first line.
2. `outreach-sequence.md`: the four to five touches, each under 120 words, with the wait between each stated in days, an opt-out line in every touch, and the founder's real business name and postal address in the signature block.
3. A run sheet: five sends a day for five days, from their own mailbox, with the exact copy-and-paste order, and the instruction to reply-all to themselves rather than to a list.

**State left behind.** `O|` rows in the ledger with status `contacted_ok`, set by the founder as they go, one command per day rather than per row.

**How the founder knows it worked.** Their own sent folder.

**Why this is genuinely first-class.** The Microsoft 365 founders take this route regardless of any spike result, so it is on the critical path for a real slice of the cohort and gets the same rehearsal attention as the automated path.
If it is only good enough for the fallback case, it is not good enough.

#### F-05 A sequence enrolls but the founder cannot find the activation control

**Trigger.** The enrollment lands paused, as designed, and the founder does not know what to do next.

**Route.** The skill ends with the location of the control, named in the vendor's own words, and the sentence that it is paused until they press it.
It offers to activate through the tool on one explicit yes, and if that offer fails it falls back to the named control.
It never activates without the yes, which is a policy wall.

**State left behind.** `O|` rows at `enrolled`. Activation does not change the ledger, because activation is the founder's act and the ledger records what the toolkit did.

#### F-06 The snapshot import fails at the clinic

**Trigger.** A share link does not resolve, or imports into the founder's location with missing steps.

**Route.** The copy map is the fallback and it is already the deliverable.

Every snapshot has a file at `plugins/growth-engine/assets/ghl/snapshots/<slug>.md` listing each namespaced custom value key, where it appears, the channel, and the length guidance.
The founder's own copy is written into that table by the ops skill.
If the import fails, an assistant builds the workflow by hand in the founder's location and pastes the copy from the table.
That is slower, it is not pretty, and it works.

**Pre-emption.** R-25: test-import all three into a clean location before the freeze.
A share link that has never been tested outside the account that created it is not a deliverable.

#### F-07 The founder's GoHighLevel tier does not carry comment-to-DM capture

**Scope note, because this is easy to misread.**
Comment-to-DM capture and DM qualify-and-book are IN scope. They are part of system 3, back-end ops.
They run as GoHighLevel workflows, inside the founder's own GoHighLevel location, built from a snapshot.
Claude writes the copy that sits inside those workflows and stores it as namespaced custom values.
Nothing in our code sends a direct message, which is why this survived the 21 August cut while the `dm-inbox` skill, `ge dmgate` and all 24-hour-window code did not.
This fallback is about the tier not carrying the workflow, not about the feature being cut.

**Trigger.** R-02 resolves badly, or an individual founder is on a lower tier than the onboarding email named.

**Route.** The manual inbound script.
The same copy the workflow would have sent is delivered as a script the founder uses by hand: they reply to comments themselves, with the qualifying question and the booking link, from the same copy table.
The ops skill writes the script whether or not the workflow can be built, because the copy is the deliverable and the workflow is the delivery mechanism.

**What this deliberately does not do.** It does not send anything from our code, and it does not automate a direct message.
That is a policy wall and the fallback respects it exactly as the primary path does.

#### F-08 Hooks do not fire, or `ge` is not on PATH

Covered structurally rather than as a runtime fallback, by S-10 and S-11.
Every `ge` call is written in long form so PATH is never load-bearing, and every warning the session-start hook would have delivered is also delivered by `ge check`.
There is nothing left for a fallback to catch.

#### F-09 No network in the room

**Trigger.** Venue network failure, or saturation.

**Route.** Sequence around it rather than solve it.
These work with no network: the Founder Brain, content generation, the edit pass, CSV export, workflow copy, the 90-day plan, the hook bank, the direct message openers.
These do not: publish, enroll, any live vendor read, and the update drill.

The run sheet for each day puts the network-dependent steps in a single named window rather than scattered through the day, so a network failure moves one block instead of stopping everything.
Mobile hotspots are the physical fallback and are the client contact's item (R-22).

#### F-10 A gate form is unavailable

**Trigger.** The forms provider is down, or a link is wrong.

**Route.** `/growth-engine:gate` already produces a plain-text block designed to be pasted.
If the form will not load, the founder pastes the same block into the Slack channel.
Nothing about the gate depends on the form existing, which is the reason the command produces text rather than submitting anything.

#### F-11 An individual founder's update does not land at Session 3

Covered by R-10 and R-23.
The route is: the reinstall walk named per surface, then the rollback string, then the honest floor, which is the sentence naming what still works on the frozen version.
That sentence has to be written and true before the freeze, not improvised in the room.

---

### 7.4 What is most likely to go wrong on the day, ranked

Ranked by probability multiplied by blast radius.
Each item names the pre-emption and, where it comes from a verified finding, the source line.

**1. Founders open Claude in the wrong folder.**
Near-certain, all 130, repeatedly.
FUNCTIONAL-REVIEW.md:687 and :717 record that the search covers only three locations, names no tool call, and has no step that asks the founder where they built it before creating a second folder.
The common real case, built in one folder and now opened in another more than one level away, misses all three locations.
On the Cowork surface the model can only see the folder the founder picked, so a home directory search cannot run at all.
**Pre-emption.** The anchor at `.state/HOME`, a `CLAUDE.md` marker written into the folder at init so any future session in it self-identifies, `ge check` printing the full path of the correct folder rather than saying it is wrong, the "ask them where they built it" step before ever creating a second folder, and a per-surface search recipe. Assistants get the one-line fix on a card.

**2. The plugin was never actually installed.**
FUNCTIONAL-REVIEW.md:757 records this as the highest-volume first-contact problem on the desktop route: the marketplace was added, the install step was skipped, and the commands do not resolve.
**Pre-emption.** The setup skill names this cause first, before any other diagnosis, and the receipt records the plugin version read from the plugin root so there is evidence rather than belief.

**3. The founder arrives at the clinic with no GoHighLevel connection.**
Two of the four systems run through it.
FUNCTIONAL-REVIEW.md:727 records that the status checklist has no rows for GoHighLevel readiness, so a founder can be told they are complete while nothing is connected.
**Pre-emption.** S-02 folds connect into setup so the walk exists at the freeze rather than at 19 September. The receipt carries a GHL row. The assistants' clinic checklist reads the receipt, not the founder's memory.

**4. Scheduled posts land at the wrong hour.**
Low probability, total blast radius, and discovered by the founder's audience rather than by the founder.
**Pre-emption.** R-16. One unambiguous timezone sentence in the spike with pasted evidence, a preview table in local time that the founder says yes to, and one test post scheduled 15 minutes out and read back before any batch.

**5. The CSV that gets imported is the unedited draft.**
A verified blocker, FUNCTIONAL-REVIEW.md:213.
The founder does the edit pass, which is the work the gate actually measures, and then imports the version from before it.
**Pre-emption.** R-17. Export is the last step of the edit pass, and a lint check fails when the CSV is older than the markdown.

**6. A B2C founder is action-blocked mid-sprint.**
FUNCTIONAL-REVIEW.md:1003.
The toolkit predicts it and then says nothing about what it looks like or what to do.
A blocked founder reads it as the toolkit damaging their account, which is the worst version of this failure.
**Pre-emption.** R-20. Three lines in the output file and the same three lines in the run sheet.

**7. The publish preview shows 7 rows, or 0, when the founder expected 30.**
FUNCTIONAL-REVIEW.md:835 and :233.
Every one of the 30 B2C pieces needs a media file the toolkit never produces and never asks for, and nothing defines what goes in the CSV `content` cell for scripts and carousels.
On LinkedIn and Facebook the 7 single-image captions can go out as text, so the preview shows 7.
On Instagram nothing goes out at all, because Instagram accepts no caption-only post, so the preview shows 0.
**Pre-emption.** R-18. Disclose the split at generation time and name the Instagram case separately, emit a B2C shot list, generate a caption for every media piece, move the recording into Session 2 homework, and never let the count be a surprise at publish time.

**8. Rate limiting during the clinic hour.**
**Pre-emption.** R-19. Pacing, batches capped at 10, an idempotent re-run driven by the ledger, and the clinic staggered by track.

**9. A sequence is activated by accident, or never activated at all.**
**Pre-emption.** F-05. Paused enrollment is a policy wall, the activation control is named in the vendor's own words, and activation through the tool requires one explicit yes.

**10. The Session 3 update does not land.**
**Pre-emption.** R-10 and R-23. Rehearsed drill, rollback string, the honest floor sentence, the drill run in the first ten minutes of the session rather than the last.

**11. The wrong track is recorded in the Founder Brain.**
Every downstream output is then structurally wrong, and FUNCTIONAL-REVIEW.md:737 records that the current remedy only says "regenerate the content", leaving the other track's engine files sitting in the folder where the gate command reads them.
**Pre-emption.** The lock line at the end of the brain intake, a `ge lint` check on the track enum, and a documented switch procedure that archives the other track's files by status rather than leaving them.

**12. Two Founder Brains exist, in two folders.**
The direct consequence of item 1 combined with a setup skill that creates a new folder rather than asking.
**Pre-emption.** Same as item 1, plus: setup never creates a second folder without asking, and `ge check` reports scatter by name when it finds more than one anchor.

**13. A founder pastes a token into the conversation.**
**Pre-emption.** R-21. Masked prompt, an explicit sentence in the walk, a `ge check` grep for the token prefix in the founder's folder, and a CI grep over skill text.

**14. A Windows Home founder cannot get to a working state.**
No Hyper-V means no Cowork, which forces the Code tab, which requires Git for Windows.
Every step of that chain is a place to stop.
**Pre-emption.** The clean-machine rehearsal on a real Windows Home box is not optional and is not a cut candidate. Two clicks for Git for Windows, named as two clicks, with a screenshot slot per step and an "if this fails" line per step.

**15. The network fails in the room.**
**Pre-emption.** F-09. Sequence network-dependent steps into one named window per day. Hotspots.

---

### 7.5 What to cut if time runs out

The 1.0 lane is over by 4.5 dev-days on the PRD's own arithmetic, and the 1.1 lane carries 12.0 dev-days into 10 working days that already contain four live session deliveries.
PRD-GAPS.md:688 records that the 1.1 lane names no cut order at all, which is how a system that was sold gets removed under pressure in the week of the event.

This is the cut order.
It is written now so that the decision is a lookup rather than a judgement call made at 11pm on 12 September.

**How a cut is made.**
At the two decision points (8 September midpoint, 12 September hard call) count the remaining 1.1 dev-days against the remaining working days.
If remaining work exceeds remaining days, cut from the top of this list until it does not.
Record which cut was taken in the risk register, in the row it belongs to, and tell the client the same day in writing.

#### The cut list, first to go

**1. `playbook-export`. Saves 0.5 dev-days and closes six findings.**
Safe because the printed playbook is printed by the programme on its own schedule, and the insert as specified was never producible: it promises a PDF nothing renders and it cannot contain its final section for any founder.
This one is recommended as a permanent simplification (S-01) rather than a time cut, so it should already be gone.

**2. The third worked example folder. Saves 0.5 dev-days.**
Safe because two worked examples already calibrate the standard, and the ecommerce fork is carried by the Model field in the Founder Brain, which the skills read regardless of whether an example folder exists.
The cost is that ecommerce founders calibrate against a service example, which is a small loss of polish and no loss of function.

**3. The three-OS CI matrix drops to Ubuntu plus one recorded manual run. Saves 0.75 dev-days.**
This is a cut of work not yet done rather than a removal of something built: on 21 August 2026 `.github/workflows/validate.yml` already runs Ubuntu only, so taking this cut means never building the matrix at all.
Safe only if the clean-machine rehearsal on real macOS and real Windows Home has already happened, because that rehearsal is what the matrix is a cheap proxy for.
If the rehearsal has not happened, this is not safe and the next item is cut instead.
The cost is that a bash-ism introduced after the cut is not caught automatically, which is mitigated by the fact that no new shell code should be landing that late.

**4. The `update` drill rehearsal reduces to one written Slack message. Saves 0.5 dev-days.**
Safe only if the 1.1 lane has already landed, so the drill is a nicety rather than the delivery mechanism.
If 1.1 is still in flight, this is not safe: the drill is how two thirds of the product reaches founders, and it goes to the bottom of the list rather than the top.

**5. `growth-plan` drops its numeric projections and ships as cadence plus actions. Saves 0.5 dev-days.**
Safe, and arguably an improvement.
FUNCTIONAL-REVIEW.md:529 records that the plan is told to project from list size, audience size and conversion assumptions that the Founder Brain never captures, and the plan never asks for the missing numbers.
Cutting the projections removes the invented-number risk entirely, which is policy wall 5.
The plan still delivers what the Sunday session is for: what to do, in what order, on what cadence, for 90 days.

**6. Publishing drops to the CSV path only. Saves 2.0 dev-days, the largest single saving on this list.**
Safe because the CSV path is ship-ready, is the documented backstop, and the clinic already has a human in the room and a paste step in the plan.
The cost is real and must be stated to the client rather than absorbed quietly: "scheduled through the tool with read-back verification" becomes "imported at the clinic and seen in the calendar".
Take this cut before touching the outbound engine, because outbound has no equivalent in-room support step.

**7. Apollo drops to the manual export route for all B2B. Saves 2.0 dev-days.**
Safe because the manual route is already first-class, is already on the critical path for every Microsoft 365 founder, and produces the same three artifacts (F-04).
The cost is 65 founders doing more clicking on the Saturday, in a room with assistants, which is a fair trade against not shipping.

**8. The comment-to-DM and qualify-and-book workflows ship as copy tables plus a manual script, without the built workflows. Saves 1.0 dev-days of the human snapshot work.**
To be clear, because the wording invites the wrong reading: comment-to-DM capture and DM qualify-and-book are in scope and are not cut.
They are part of system 3, back-end ops. They run as GoHighLevel workflows, carrying copy that Claude writes.
This cut removes only the assembly of the workflows inside the snapshots, not the feature and not the copy.
This is the last thing on the list and it is close to the line.
It is safe only in the sense that the founder still leaves with the copy, which is the part that needs the founder's voice and cannot be produced later.
The workflow assembly can be done by an assistant, or by the founder afterwards from the map.
If this cut is being considered, the client is told before it is taken, not after.

#### What is never cut, whatever happens

Three things.
Not features. Properties.

**1. The anchor and the doctor: `ge init`, `.state/HOME`, `ge check`.**
Because folder scatter is the failure that happens to every founder, more than once each, and it is the difference between 130 people who fix themselves and 130 messages to one maintainer.
Nothing else on the list changes the support load by an order of magnitude.
It is also cheap, roughly 1.5 dev-days of the brain, and it is spike-independent, so it can be built from day one regardless of what any vendor does.

**2. Snapshot before write, fail-closed, with undo.**
Because every skill in the product overwrites a founder file, and the files it overwrites are the founder's own edited work.
A founder who loses their edited 30 pieces on the Saturday morning has lost the event, and no apology recovers it.
Fail-closed is the specific requirement: if the snapshot cannot be written, the write does not happen.
An irreversible autonomous mistake is the worst outcome this product can produce and this is the only thing standing in front of it.

**3. One complete route from Founder Brain to sent message, per track, even if every leg of it is a fallback.**
This is the property that matters more than any individual system.
A B2B founder must be able to get from the brain to 25 sent messages, and a B2C founder from the brain to 30 pieces and 25 hand-sent openers, using only routes that have been rehearsed end to end.
If that route is CSV plus manual sending on both tracks, the event still works.
If any leg of it is untested, the event does not work no matter how many systems shipped.
This is why the full-arc rehearsal (R-12) is not on the cut list: it is the only thing that proves the property exists.

---

### 7.6 Definition of done

One list, for the whole product.
Every item is checkable by running something or looking at something.
No item is a judgement call, and no item is satisfied by an assertion that something should work.

The check is written after each item.
Paths are absolute.
Where a command is given it is copy-pasteable from a shell whose working directory is `/Users/pmudh/Documents/GitHub/Atlanta`.

#### A. Repository and CI

1. `bash scripts/validate.sh` exits 0 with no FAIL lines.
2. The GitHub Action passes on Ubuntu, macOS and Windows for the head commit. Check: the three job checkmarks on the commit page at `https://github.com/Philm-moxywolf/Atlanta`.

   This starts red and needs work first. On 21 August 2026 `/Users/pmudh/Documents/GitHub/Atlanta/.github/workflows/validate.yml` declares a single job with `runs-on: ubuntu-latest` and one step, `bash scripts/validate.sh`. There is no `strategy.matrix`. Turning it into three jobs means adding a matrix over `[ubuntu-latest, macos-latest, windows-latest]` and, for the Windows job, setting `shell: bash` so the step runs under Git Bash rather than PowerShell. That Windows job is the cheapest proxy the project has for the Windows Home Git Bash runtime floor, which is why item 3 of the cut list in section 7.5 is guarded rather than free.
3. `/Users/pmudh/Documents/GitHub/Atlanta/plugins/growth-engine/.claude-plugin/plugin.json` and `/Users/pmudh/Documents/GitHub/Atlanta/.claude-plugin/marketplace.json` declare the same version string. Check: validate.sh's version agreement line reads ok. Both read `0.1.0` on 21 August 2026, so they agree today and must still agree at `1.0.0`.
4. Every shell file parses under POSIX `sh`. Check:

   ```sh
   for f in $(git ls-files '*.sh'); do sh -n "$f" || echo "FAIL $f"; done
   [ -f plugins/growth-engine/bin/ge ] && { sh -n plugins/growth-engine/bin/ge || echo "FAIL bin/ge"; }
   ```

   Both lines print nothing. `bin/ge` does not exist on 21 August 2026, which is why its check is guarded rather than inline: an unguarded `sh -n` on a missing file prints an error that reads like a failure and is not one. Note that `scripts/validate.sh` itself starts `#!/usr/bin/env bash` and is deliberately allowed to use bash, because it never runs on a founder machine.
5. No file under `plugins/`, `docs/` or `README.md` contains an em dash or an en dash. Check: validate.sh's house style line reads ok.
6. No file under `plugins/` contains the string `TODO`. Check: `grep -rn TODO plugins/ ; echo "exit $?"` prints `exit 1` and no matching lines. There are 15 such placeholders on 21 August 2026, so this starts red.
7. The built zip contains no skills and no commands. Check:

   ```sh
   bash scripts/build-folder.sh && unzip -l dist/Launchhouse.zip | grep -cE '\.claude/(skills|commands)/' ; echo "exit $?"
   ```

   prints `0` then `exit 1`. `grep -c` exits 1 when the count is zero, so the `exit 1` is the pass condition, not a failure.
8. The skill count and command count constants in `scripts/validate.sh` match what is on disk, and the counts are 8 and 12. Check: `bash scripts/validate.sh | grep -E 'skills found|commands found'` prints `ok` lines for both, with no `WARN` and no `FAIL`.
9. `planning/spike/gate-ab-plugin/` no longer exists. Check: `git ls-files planning/spike ; echo "exit $?"` prints only `exit 0` with no file paths. On 21 August 2026 it prints five paths, so this starts red.
10. No name, surname or currency symbol appears under `planning/`. Check: validate.sh's public-safety line reads ok.

#### B. Evidence gathered

11. `/Users/pmudh/Documents/GitHub/Atlanta/planning/spike-findings.md` contains no occurrence of the string `PENDING`. Check: `grep -c PENDING planning/spike-findings.md` prints `0`. On 21 August 2026 it prints `7`, one per section.
12. Spike sections S-01, S-02, S-03, S-05, S-06 and S-07 each carry a filled `_finding:_` sentence and a pasted evidence block. Spike section S-04 (conversations) is deleted from the file, because the DM inbox is cut. Check: `grep -n '^## S-' planning/spike-findings.md` lists six sections and no `S-04`, and read each `_finding:_` line.
13. Spike sections S-02 (GoHighLevel MCP catalog) and S-07 (Apollo paid) each carry a written decision gate verdict, with three named outcomes and the one that was taken. Check: read the file.
14. `/Users/pmudh/Documents/GitHub/Atlanta/planning/review-triage.md` exists with 95 lines, one per finding in `/Users/pmudh/Downloads/Atlanta/launchhouse-atlanta/planning/FUNCTIONAL-REVIEW.md` (which holds exactly 95 findings, confirmed by `grep -c '^### \[' ` on it). Each line resolves to exactly one of `fixed-by-task <id>`, `superseded-by-decision <section>`, `backlog`, or `wontfix: <reason>`. Every BLOCKER and every HIGH resolves to a task id or an explicit decision, never to `backlog`. Check, run from `/Users/pmudh/Documents/GitHub/Atlanta`:

    ```sh
    wc -l < planning/review-triage.md
    grep -E 'BLOCKER|HIGH' planning/review-triage.md | grep -c 'backlog' ; echo "exit $?"
    ```

    The first prints `95`. The second prints `0` then `exit 1`, which is the pass condition.
15. `/Users/pmudh/Documents/GitHub/Atlanta/planning/gap-triage.md` does the same for the 75 rows in `/Users/pmudh/Downloads/Atlanta/launchhouse-atlanta/planning/PRD-GAPS.md`, with its four BLOCKER rows each resolved to a task id. Check: `wc -l < planning/gap-triage.md` prints `75`, and the same two-line grep pattern as item 14 applied to `planning/gap-triage.md`.
16. `/Users/pmudh/Documents/GitHub/Atlanta/planning/RISKS.md` exists and no row is past its Resolve-by date without one of `RESOLVED:`, `TRIGGERED:` or `SLIPPED:` written into it. Check: read the file against today's date.

#### C. The brain

17. `sh plugins/growth-engine/scripts/ge.sh help` prints usage and exits 0.
18. `sh tests/run.sh` is green on Ubuntu, macOS and Windows Git Bash. Check: the three CI job logs.
19. Snapshot and undo round-trip byte-exactly. Check: the golden test named `snapshot-undo-identical` in `tests/run.sh` passes, and its fixture comparison is a `cmp`, not a diff of selected lines.
20. A snapshot into an unwritable directory exits non-zero and the write does not happen. Check: the golden test named `snapshot-failclosed` passes.
21. `ge check` against a healthy fixture folder prints all PASS. Check: `sh tests/run.sh doctor-healthy`.
22. Each induced failure flips exactly its own line and prints a runnable fix. Check: the three doctor tests `doctor-moved-folder`, `doctor-no-receipt` and `doctor-token-in-folder` pass.
23. Every founder-visible failure message ends with a recovery line, which by the code standard is an arrow followed by `run:` and a runnable command. Check, run from `/Users/pmudh/Documents/GitHub/Atlanta`:

    ```sh
    grep -rn 'FAIL' plugins/growth-engine/scripts plugins/growth-engine/skills 2>/dev/null | grep -v 'run:' ; echo "exit $?"
    ```

    prints `exit 1` and no matching lines. `plugins/growth-engine/scripts/` does not exist on 21 August 2026, which is why `2>/dev/null` is present: without it the command prints a directory-not-found error that reads like a failure and is not one. The filter is on the literal `run:` rather than on the arrow character, because matching a multibyte arrow in a bracket-free pattern is fine but matching it reliably across locales is the same trap S-13 describes.
24. Every skill that writes a file named in `schemas/state.md` names `ge snapshot` in the same file. Check: validate.sh's snapshot-first line reads ok.
25. Every `ge` invocation in every skill is written in the long form `sh "${CLAUDE_PLUGIN_ROOT}/scripts/ge.sh"` (S-10). Check, run from `/Users/pmudh/Documents/GitHub/Atlanta`:

    ```sh
    grep -rnE '(^|[^A-Za-z0-9_/.-])ge ' plugins/growth-engine/skills plugins/growth-engine/commands | grep -v 'ge\.sh'
    ```

    Every remaining hit is prose about the brain, not a command a founder or the model would run. Read them and confirm that, one by one. The pattern uses `-E` with an explicit leading character class rather than `\b`, because `\b` is a GNU extension and this check has to give the same answer on macOS BSD `grep` as it does on an Ubuntu runner.

#### D. The four systems, proven on live accounts

26. Content: a full generation run produces 30 ledger rows with the correct lane on each, and a refill run refuses a duplicate angle. Check: the content-engine portion of the three arc transcripts, `planning/rehearsals/arc-b2b.md`, `arc-b2c-service.md` and `arc-b2c-ecom.md`, each of which runs generation and refill in sequence.
There is no separate `content-run.md`; task X-01 produces the arc transcripts and nothing else produces a content-only one.
27. Content: `content-30.csv`'s first line is byte-identical to the committed fixture. Check: `head -1` on both, compared with `cmp`.
28. Content: `content-30.csv` is never older than `content-30.md`. Check: `ge lint` reports ok in the rehearsal transcript.
29. Publish: at least three text posts scheduled through the tool, read back by post id, visible in the Social Planner UI at the correct local time, ledger rows updated. Check: `planning/rehearsals/publish-live.md` with the read-back responses pasted.
30. Publish: one forced failure lands the row as `failed` with a recovery line, and re-running skips the rows already scheduled. Check: same transcript.
31. Outbound B2B: a two-contact sequence created paused, activated by explicit act, one send observed, stop-on-reply confirmed on, all test artifacts deleted. Check: `planning/rehearsals/apollo-live.md` with the paused-state response pasted.
32. Outbound B2B: the manual route produces a complete sendable set of 25, regardless of the Apollo gate outcome. Check: the run folder contains `outreach-firstlines.csv` with 25 rows and `outreach-sequence.md` with an opt-out line in every touch.
33. Outbound B2C: 25 openers, a hook bank, and the pacing block containing the three action-block lines. Check, against the B2C full-arc run folder produced by item 37:

    ```sh
    grep -ci 'action block' plugins/growth-engine/assets/examples/b2c-lumen/dm-openers.md
    ```

    prints at least `1`, and reading the surrounding lines shows all three: what the block message looks like, stop immediately and do not retry, resume over the following days and mark where you stopped.
34. Back-end ops: each of the three snapshots imports into a genuinely clean location from its share link, and the custom value placeholders render. Check: `planning/rehearsals/snapshot-import-test.md`, three receipts.
35. Back-end ops: each copy map file has every key filled, every key matches `^lh_[a-z0-9_]+$`, and keys are unique within the file. Check: validate.sh's copy-map line reads ok.
36. Back-end ops: `assets/ghl/README.md` carries three live share links and zero placeholders, at every version, not only at 1.1.0.

#### E. The founder arc, end to end

37. One full-arc run per route exists as a transcript plus a finished folder, produced by running every command in order as a fictional founder. There are three routes, so there are three of each. Check: `planning/rehearsals/arc-b2b.md`, `planning/rehearsals/arc-b2c-service.md` and `planning/rehearsals/arc-b2c-ecom.md` all exist, and `plugins/growth-engine/assets/examples/` contains three complete folders (`b2b-northfield`, `b2c-lumen`, `b2c-service-brighthound`), not three lone `founder-brain.md` files.
38. Every friction found in those runs became either a doc fix or a task, and each is linked from the transcript. Check: the transcript's closing list, every line naming a commit.
39. A clean-machine install rehearsal exists for macOS Cowork, macOS Code tab and Windows Home Code tab. Check: three receipts under `planning/rehearsals/`, each showing the install, the setup receipt, and the plugin version read from the plugin root.
40. The install from the public marketplace works with the exact strings that will be in the onboarding email: `/plugin marketplace add Philm-moxywolf/Atlanta` then `/plugin install growth-engine@launchhouse`. Check: the rehearsal receipts contain those two lines verbatim.
41. The update path is rehearsed: install one version, release the next, run the drill, land on current. Check: `planning/rehearsals/update-drill-receipt.md`.
42. The rollback path is rehearsed: from the newer version back to the frozen one, on at least one surface. Check: same transcript.

#### F. Founder-facing correctness

43. Every command named in `README.md` resolves against a file in `plugins/growth-engine/commands/`. Check: validate.sh's command routing line reads ok.
44. No founder-facing file contains a bare command form. Check: validate.sh's namespacing line reads ok.
45. Every "Or just say" phrase in `README.md` appears in the corresponding skill's description triggers. Check: validate.sh's trigger sync line reads ok.
46. No founder-facing file promises replies. Check: validate.sh's design rules line reads ok.
47. No founder-facing file offers automated cold direct messages. Check: validate.sh's DM line produces no warning, and each match refuses rather than offers.
48. Every cold email touch in the generated sequence carries an opt-out line and a sender identification with a real business name and postal address. Check: the two full-arc run folders.
49. Neither worked example contains an invented number, customer or result. Check: read both `founder-brain.md` files and both content files, and confirm every number traces to something the fictional founder was given in the intake.
50. `ge init` seeds `growth-engine/memory.md` with all six managed blocks present and empty. Check: run `ge init` in a fresh directory and confirm `grep -c 'GE:.*:START' growth-engine/memory.md` returns 6.
51. A memory entry survives the founder editing the same file. Check: append a line under `## Notes`, run `ge remember worked "x"`, and confirm the founder's line is still present byte-for-byte.
52. A half-marked memory file is refused rather than guessed at. Check: delete one `GE:*:END` marker, run `ge remember` against that block, and confirm it exits 1, writes nothing, and prints a recovery line.
50. `docs/CONNECTIONS.md` exists and every claim in it maps to a mechanism that was actually built. Check: the commit body lists the mapping, claim by claim.
51. The seven Private Integration Token scopes are stated identically everywhere they appear, and the list is exactly: `socialplanner/post.readonly`, `socialplanner/post.write`, `socialplanner/account.readonly`, `socialplanner/statistics.readonly`, `contacts.readonly`, `contacts.write`, `locations.readonly`. Check, run from `/Users/pmudh/Documents/GitHub/Atlanta`:

    ```sh
    grep -rn 'socialplanner/post.readonly' README.md docs plugins planning
    ```

    Every hit names the same seven strings in the same order. The search is scoped to those four paths on purpose: an unscoped `grep -rn ... .` also walks `.git` and `dist/`, which produces duplicate and packed-object noise that makes the check unreadable.
52. No conversations scope string remains anywhere in the repository, since the DM inbox, `ge dmgate`, `commands/inbox.md` and PRD task G2-02 are all cut. Check, run from `/Users/pmudh/Documents/GitHub/Atlanta`:

    ```sh
    grep -rnE 'conversations\.readonly|conversations/message\.(readonly|write)|dmgate|dm-inbox|commands/inbox' README.md docs plugins scripts planning ; echo "exit $?"
    ```

    The pattern targets the scope strings and the cut identifiers, **not** the bare word `conversations`. A bare-word search fails permanently for an innocent reason: `plugins/growth-engine/skills/founder-brain/SKILL.md:123` uses "conversations" in ordinary English, about what a founder's audience is already talking about, and that sentence is correct and stays.

    The pass condition differs by path, because a shipped file and a historical planning document are not the same thing.

    - Under `README.md`, `docs/`, `plugins/` and `scripts/`: zero hits. These ship to founders or run on their machines. Nothing cut may survive here.
    - Under `planning/`: hits are allowed only where the surrounding text marks the item as cut. On 21 August 2026 the search returns unmarked hits at `planning/PRD-growth-engine-v1.md` lines 67, 104, 178, 210, 317, 319, 355, 356, 357, 432, 440 and 502, and at `planning/spike-findings.md` lines 26 and 127. Every one of those is a live instruction that now contradicts the locked scope, so each must be edited to say the item is cut, in the same commit that opens the delivery plan. Do not simply delete them: a reader arriving at the PRD needs to see that the scope changed, not find a gap.
    - `planning/glitch-standard-plan-2026-08-20.md` is the superseded plan. Leave it untouched and add one line at its top stating that it is superseded by the PRD and by this delivery plan.

    Two of those PRD lines are worth naming individually because they are load-bearing elsewhere. Line 210 is spike section S-01's scope list and still names all ten scopes; it must be cut to the seven in item 51. Line 440 is the lane-fit table and lists "B-07 dmgate to 1.1" as a 1.0 cut candidate; B-07 is now cut outright, so that line must say so.

#### G. The things that must be true on 25 September

53. Each of the three tracks (b2b, b2c-service, b2c-ecom) has one complete rehearsed route from Founder Brain to sent message, using only steps that appear in a rehearsal transcript.
54. Each of the two platforms (macOS, Windows) has one complete rehearsed install, on a machine that had never seen the plugin before.
55. Every fallback in section 7.3 has been executed at least once by a human, not just written.
56. The assistants have walked the full-arc transcript for both tracks and can each name, without looking, the fix for the wrong-folder failure.
57. `planning/RISKS.md` has no row still open without a decision written against it.

Item 53 is the one that decides whether the event works.
Everything above it exists to make it true.
Run the two full-arc rehearsals, in order, on a clean machine, and read what comes out.
