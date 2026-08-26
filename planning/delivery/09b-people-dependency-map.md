# Work in progress: the person layer dependency map

Written 24 August 2026, against the nine sections under `/Users/pmudh/Documents/GitHub/Atlanta/planning/delivery/` and the index at `/Users/pmudh/Documents/GitHub/Atlanta/planning/DELIVERY-PLAN.md`.

This is a survey, not a specification.
It exists because the last cross-cutting change to this plan was propagated by hand, reached some sections and not others, and produced 47 regressions.
Every place a person is represented, referenced, counted or consumed is listed below with its file, its line, and its exact text.

Read Part 0 first.
It resolves the central design question, and the answer changes what half the rows in Part 1 have to become.

---

## Part 0: the central design question, resolved

### The question

Option 2 adds a per-person entity layer.
The ledger already represents people thinly: `O|` rows keyed on email are B2B prospects, `D|` rows keyed on handle are B2C direct message targets.
So does the new person layer duplicate those rows, replace them, or sit alongside them?

### The proposal put forward, and why it is rejected

The lead proposal was: the person FILE becomes authoritative, `ge person` is its sole writer, and the ledger's `O|` and `D|` rows become DERIVED, rebuilt from the person files by `ge index`, exactly as `.state/index.md` is already derived and rebuildable.

Reject it. Four reasons, in order of severity.

**1. It puts two writers on `ledger.md`, which is the one rule that cannot bend.**
`ge ledger` is the sole writer of `ledger.md` today.
Under the proposal `ge index` also writes it, because it rebuilds the `O|` and `D|` rows into it.
Section 03's check V-12 reads a declared map at `plugins/growth-engine/schemas/writers.md`, one row per founder file, and prints `TWOWRITERS` when two owners claim one file.
`ledger.md` would need two owners declared, which turns the check from a gate into a comment.
Section 07's state model at line 282 says `ledger.md   one writer: ge ledger`, in a diagram whose whole point is that each line has exactly one owner.

**2. `ge index` is the wrong owner, twice over.**
Section 02 line 141 puts `ge index` at the end of the standard write chain, so it runs after every skill on every founder machine many times a session.
Every one of those runs would now mutate `ledger.md`, which means every one of them must `ge snapshot ledger.md` first.
The snapshot ring is 10 per file (task `B-03`).
Ten index rebuilds evict every real mutation snapshot, and `ge undo` on the ledger stops meaning anything.
Separately, section 07's simplification `S-08c` is marked ADOPT and makes `ge index` print to stdout by default, writing a file only on `ge index --write`.
A stdout-only index cannot rebuild persisted rows.
The proposal and `S-08c` cannot both be true.

**3. Derivation gives the fact two homes anyway, and the second home is the one every check reads.**
Every consumer in this plan greps `^O|` or `^D|` out of `ledger.md`.
If the person file changes and the rebuild does not run, those consumers read the old status, report it as truth, and pass.
That is the exact failure class the 47 regressions came from, industrialised.
See list D.

**4. It is a worse stepping stone, not a better one.**
Option 3's projector reads line-oriented person files into typed rows.
A derived pipe-delimited roster inside `ledger.md` is a second grammar that a projector would have to learn and then delete.

### The shape to adopt instead

**People move out of `ledger.md` entirely. They are not duplicated there and they are not derived into it.**

| Thing | Owner | Where it lives |
|---|---|---|
| Content rows, `C|` | `ge ledger` | `growth-engine/ledger.md`, which becomes content only |
| One person | `ge person` | `growth-engine/people/<key>.md`, one file per person |
| Everything the toolkit knows about that person | `ge person` | The same file. Header fields for the typed facts, managed blocks for the notes |

`ge person` is the sole writer of everything under `growth-engine/people/`.
`ge ledger` loses `add-outreach`, `set-outreach`, `add-dm` and `set-dm`, and loses `O` and `D` from `ge ledger list`.
`schemas/ledger.md` loses two of its three row grammars and gains a pointer to `schemas/person.md`.

**Why retirement rather than derivation.**

Every un-migrated consumer fails loudly instead of reading stale data quietly.
`grep -c '^O|' growth-engine/ledger.md` returns 0 where the acceptance block says it must return 25.
That is a build failure on the day the change lands, in the executor's own terminal, which is exactly what the 47-regression history says to design for.
A derived roster returns 25 and keeps returning 25 long after the underlying facts have moved.

A fact then has exactly one home, with no rebuild step between the truth and the reader, so there is no staleness concept to explain to a founder and no freshness check for the doctor to run.

Scale supports it.
About 25 people per founder means `grep -h '^status:' growth-engine/people/*.md | sort | uniq -c` is a complete reporting engine.
No index, no roster file, no cache.

It reuses machinery already specified rather than inventing any.
Section 08's managed blocks (`<!-- GE:<NAME>:START -->`) are exactly right for the notes half of a person file: `ge` owns the marked blocks, the founder owns everything outside them, a half-marked file is refused, and an amend whose anchor has moved is HELD.
Section 08 currently says at line 125 that nothing except `memory.md` adopts markers in version 1.0.
That sentence has to change, and it is the only thing in section 08 that does.

**The key, and the two enums.**

The person file is keyed on a slug, not on an email and not on a handle, because a B2B prospect has no handle and a B2C target has no email.
The file carries `kind: prospect|target`, and `status:` is validated against the enum for that kind.

Keep both enums exactly as they are.
Prospect keeps `candidate|cut|contacted_ok|enrolled|replied|stopped`.
Target keeps `target|opener_written|sent|replied|booked|no_reply`.
Unifying them looks tidy and would silently change the meaning of nine gate items and two fallback specifications in section 07.
Two enums selected by one field is the smaller change and the honest one.

**What this costs, stated plainly.**

About 40 edits across 9 files, listed in Part 1.
Four task acceptance blocks stop passing until they are rewritten, which is the point.
The one thing genuinely lost is that a founder can no longer see content and outreach in one file, which nobody asked for and which `ge status` was always going to render anyway.

**The middle path, if the client wants minimum churn.**

Person files hold only narrative and attribution.
Status stays in `ledger.md`, keyed as today, and `ge person` never writes a status.
No fact is duplicated, because status exists only in the ledger and notes exist only in the person file.
It costs about 12 edits instead of 40.
What it does not do is close the gap: "tell me about Sofia" still needs two files and two commands, and the person key and the ledger key can drift with only a lint to catch it.
Name it here so it is a decision rather than a discovery.

---

## Part 1: every hit, with what changes

Column 5 assumes the shape adopted above: person file authoritative, `O|` and `D|` rows retired from `ledger.md` rather than derived into it.
Where the lead proposal would have produced a different answer, that is noted.

### 08-persistent-memory.md

| Line | Exact text | What it asserts | What must change |
|---|---|---|---|
| 26 | `| A people directory with typed notes and a projector | **No** | The ledger's `O|` rows already carry prospects. A second entity store is not earned |` | The person layer was considered and explicitly refused, with the ledger named as the reason | Reversed outright. The row becomes **Yes**, and the "what we do instead" cell names `growth-engine/people/`, `ge person`, and the fact that `O|` and `D|` rows are retired rather than kept alongside. This is the single most load-bearing contradiction in the plan |
| 125 | `**Where blocks apply.** `memory.md`, in the six blocks above.` | Managed blocks are scoped to one file in v1.0 | Becomes `memory.md` and `growth-engine/people/*.md`. The next sentence, `Nothing else adopts markers in version 1.0.`, is deleted |
| 127 | ``founder-brain.md` and `content-30.md` keep whole-file rewrite` | Names the files that do not adopt markers | Unchanged, but the surrounding paragraph's reasoning ("changing their write model mid-build touches five tasks") must not be read as also excluding person files, which are new and have no prior write model |
| 145 | `A carriage return in `ledger.md` must never turn a valid status into an unknown enum.` | The CRLF strip rule is illustrated on the ledger | Add person files to the example. This is the enum that most needs it, because a founder will open a person file in Notepad |
| 179 | `**Depends on:** `B-00` for `schemas/memory.md`...` | B-10's dependency line | The new person task depends on `B-10` for `lib/blocks.sh`, which is the reuse that makes the person notes cheap |
| 187 | `Create `plugins/growth-engine/scripts/lib/blocks.sh` with the managed-block helpers` | `blocks.sh` is created by B-10 | Unchanged, but it is now consumed by two subcommands, so its header `WRITES:` line and its comment about scope change |
| 261 | ``B-00` currently writes seven ... so the count in that task's ACCEPT block moves from 7 to 8` | The schema count arithmetic | Moves again, from 8 to 9, for `schemas/person.md`. If `schemas/writers.md` from V-12 is also counted it moves to 10. See list C, which is where this count is going to break |
| 265 | `Section 07, definition of done | Gains: memory seeded at init...` | The pattern for amending the definition of done | Followed again for the person layer. Section 07's list already has two items numbered 50, two numbered 51 and two numbered 52 |
| 275 | ``B-10` is now cut position 5 of 9 in section 02's cut order` | The cut order has 9 positions | A person task needs a position, and inserting one renumbers the rest unless it is appended |

### 00-scope.md

| Line | Exact text | What it asserts | What must change |
|---|---|---|---|
| 12 | `B2B: a live Apollo search, 35 prospects built and cut to 25, enriched, made into contacts, and a sequence with a per-contact opening line ... B2C: 25 DM openers sent by hand` | The two person populations, and their counts | Gains one clause naming that every one of those people gets a file in `growth-engine/people/`. Without it the scope table describes the outputs but not where the people land |
| 14 | `**The brain** | `bin/ge`: schema'd state, one writer per file, snapshot before every overwrite with undo, an append-only ops log, a **curated memory that persists across sessions** ... a derived index, and a doctor` | The brain's component list, which is the canonical one | Gains "a per-person entity layer" in the same list, with a pointer to the new section as line 14 already points at section 08 for the memory |
| 76 to 78 | `**POSIX sh only.** ... State files are line-oriented, never JSON, because there is no `jq` to read them.` | The runtime floor | No change. This is the constraint the person file format has to satisfy, and it is the reason the file is header fields plus managed blocks rather than JSON or YAML |
| 82 | `No automated cold Instagram or Facebook DMs, ever. The 25 B2C openers are sent by hand.` | Design rule 1 | No change, but the person file must not gain a field that reads as a send queue. `last_touch:` records what the founder tells it, never what a tool did |
| 88 | `Everything a founder generates writes to `./growth-engine/` in their own working folder.` | The write boundary | No change. `people/` is inside it |

### 01-state.md

| Line | Exact text | What it asserts | What must change |
|---|---|---|---|
| 43 | ``bin/ge` · `.mcp.json` · `hooks/hooks.json` · `schemas/` · `tests/` · `CHANGELOG.md` · `CLAUDE.md` · `docs/CONNECTIONS.md`` | What does not exist yet | No change, `schemas/` already covers it |
| 28 to 29 | `Nine skills: ... Ten commands: ...` | The shipped surface counts | No change if `ge person` ships with no new command file. If it gains one, this count and four others move together. See list C |

### 02-build-steps.md

| Line | Exact text | What it asserts | What must change |
|---|---|---|---|
| 96 to 105 | The effort table ending `| **Revised total** | **44.95 dev-days** |` | The build total | Gains a row for the person task and a row for its amendments, and the total moves. The note below it about re-summing to 39.95 has to be re-stated |
| 107 to 125 | The cut order table, nine rows | What goes first under pressure | Gains a row. Position matters: the person layer is cuttable in the way `B-10` is cuttable, because the four systems run without it, so it belongs adjacent to `B-10` at position 5. Appending it as position 10 avoids renumbering nine rows that are referenced elsewhere |
| 122 | `Cost: no `{{first_line}}` write-back, no paused-enrollment proof` | Cut 9, A-01, describes what is lost | The first-line fact now lives in the person file as well as in Apollo, so the cost line changes: the founder still has all 25 first lines locally even if the write-back dies |
| 141 | `ge index` (inside the standard write chain block) | The five-line chain every skill writes | Under the adopted shape, unchanged. **Under the lead proposal this line becomes a ledger mutation and the whole chain needs a snapshot inserted, in every skill.** That alone is the argument |
| 578 | `### B-00, write the eight schema files` | The heading | Becomes nine. Note the heading already says eight while the body creates seven and the acceptance asserts seven |
| 588 | `Create eight files under `REPO/plugins/growth-engine/schemas/`.` | The count in the body | Becomes nine, and a ninth numbered item is added for `schemas/person.md` |
| 592 | `- `C|<id>|<pillar#>|<format>|<lane text|media>|<status draft|approved|scheduled|posted|failed|archived>|<ghl_post_id|->|<scheduled_for|->`` | The content row grammar | Unchanged. It becomes the only row grammar in the file |
| 593 | `- `O|<email>|<first_name>|<company>|<status candidate|cut|contacted_ok|enrolled|replied|stopped>|<first_line y|n>`` | The B2B prospect row | **Deleted from `schemas/ledger.md`.** Its four facts move to header fields in `schemas/person.md`. The status enum moves verbatim |
| 594 | `- `D|<handle>|<platform ig|fb|other>|<status target|opener_written|sent|replied|booked|no_reply>|<sent_at ISO|->` , **new**, because the outreach row is keyed on email with a B2B-only enum...` | The B2C target row, and the reasoning that created it | **Deleted from `schemas/ledger.md`.** Its justification paragraph is worth keeping, moved into `schemas/person.md`, because it is the record of why two enums exist |
| 591 | `2. `schemas/ledger.md` : the row formats, all three of them.` | Three row types | Becomes one |
| 613 | `grep -c '^D|' plugins/growth-engine/schemas/ledger.md` | An acceptance command | Deleted, or inverted to assert 0. Left as is it asserts the presence of a grammar that no longer exists |
| 618 | `The listing must show exactly seven files: `brain.md`, `gates.md`, `ghl-accounts.md`, `index.md`, `ledger.md`, `ops-log.md`, `receipt.md`.` | The named file list | Gains `memory.md` and `person.md`, and the count moves from seven to nine. It is already wrong by one because of section 08 |
| 620 | `The `D|` count in ledger.md must be at least `1`.` | An assertion | Deleted |
| 620 (writer count) | `The writer count must be `7`.` | One declared writer per schema | Becomes 9 |
| 622 | `**COMMIT:** `B-00: write the seven state schemas, one contract per file`` | The commit line | Number moves |
| 681 | `2. Seed the founder files that do not exist yet, empty.` | `ge init` seeding | Gains `people/` as a directory with a `.gitkeep` or equivalent, so no skill ever has to create it. Same argument section 08 makes for seeding `memory.md` empty |
| 686 | `run `ge init` once in an empty folder, capture `find growth-engine -type f | sort` and save it verbatim as `REPO/tests/fixtures/init-tree.txt`` | The init tree fixture | The fixture changes. Every test that compares against it fails until it is regenerated, which is correct behaviour |
| 786 | `### B-05, ge ledger, three row types and the approve transition` | The heading | Becomes one row type. The task shrinks |
| 788 | `The `D|` row exists because hand-sent DMs had no representable state.` | The status note | Rewritten. The representable state now exists in the person file |
| 790 | `**Effort: 1.0d** (0.75d as in the PRD, plus 0.25d for the D row and the approve verbs).` | The effort | Drops by roughly 0.25d as the D row leaves, and that 0.25d moves to the person task |
| 794 | `1. `ge ledger add-content`, `set-content <id> <field> <value>`, `add-outreach`, `set-outreach <email> <field> <value>`, `list [C|O|D] [--status X]`.` | The subcommand surface | Becomes `add-content`, `set-content`, `list [--status X]`. Three verbs removed |
| 795 | `2. **New.** `ge ledger add-dm <handle> <platform>` and `set-dm <handle> <field> <value>`, writing `D|` rows per `schemas/ledger.md`.` | Two more verbs | Deleted from B-05, re-specified as `ge person add` and `ge person set` in the new task |
| 808 | `sh $GE ledger add-outreach sofia@example.com Sofia BrightOps` | Acceptance line | Deleted from B-05, appears in the person task's acceptance as `ge person add prospect sofia@example.com ...` |
| 809 | `sh $GE ledger add-dm @sofia.k ig` | Acceptance line | Same |
| 811 | `sh $GE ledger list D` | Acceptance line | Deleted |
| 813 | `grep -c '^D|' growth-engine/ledger.md` | Acceptance line | Deleted |
| 823 | `The `D|` count must be `1`.` | Assertion | Deleted |
| 828 | `**COMMIT:** `B-05: the ledger, one writer, three row types, and the approve transition`` | Commit line | Rewritten |
| 847 | `- Ledger field counts correct per row type, enums valid.` | A `ge lint` check | Splits. The ledger half narrows to `C|` only. A new lint leg covers person files: required header fields present, `kind` valid, `status` valid for that `kind`, key matches the filename, no duplicate key across files |
| 851 | `4. Every warning ends with a recovery line naming the command that fixes it.` | The lint contract | No change, but the new person warnings must each carry a runnable `ge person` recovery |
| 866 | `The `WARN` count must be exactly `5`, one per seeded fault` | The lint fixture count | Moves if person faults are seeded into `tests/fixtures/lint-seeded`, which they should be |
| 921 | `- lint summary: the count of warnings, not their text.` | A `ge check` leg | No change in shape. The doctor gains one person leg per section 08's precedent for the memory leg |
| 993 to 1007 | The `B-10` stub, `**Depends on:** `B-00`, `B-03`, `B-04`, `B-05`.` | The memory task's place in Phase 2 | The person task sits immediately after it, numbered so no existing id moves, and depends on `B-10` for `lib/blocks.sh` |
| 1126 | `The caption is the ledger's publishable text and the CSV `content` cell.` | C-01, the ledger holds content text | No change. C-01 touches only `C|` rows |
| 1284 | `Openers also write ledger rows: one `ge ledger add-dm <handle> <platform>` per target, then `set-dm <handle> status opener_written` once the opener exists.` | AB-01's snapshot chain | Rewritten to `ge person add target <handle> <platform>` then `ge person set <key> status opener_written`. Note the chain also has to gain the snapshot posture sentence, because a person write is a write |
| 1292 | `5. **Ledger rows.** One `D|` row per target, so `status` can report the Saturday's work and so a second session does not re-target the same handle.` | Why the rows exist | Rewritten as person files. The de-duplication reason gets stronger, because a person file keyed on a slug cannot be added twice |
| 1308 | `grep -c 'ge ledger add-dm' $S` | Acceptance grep on the skill text | Becomes `grep -c 'ge person add'` |
| 1323 | `grep -c '^D|' growth-engine/ledger.md` | Acceptance grep on the run folder | Becomes `ls growth-engine/people/ | wc -l` |
| 1333 | `The ecom dry run must produce exactly `25` `D|` rows and `0` lint warnings.` | The count assertion | Becomes 25 person files. **This is one of the four that will fail loudly and correctly if missed** |
| 2151 | `Then one `ge ledger add-outreach` per contact, then `ge log result "sequence created, 25 enrolled paused"`, then `ge index`.` | A-01's snapshot chain | Rewritten to `ge person add prospect` per contact |
| 2162 | `Then write each into the `first_line` custom field.` | A-01 step 8 | Gains: and record it locally with `ge person set <key> first_line ...`, so the founder keeps the 25 lines whatever Apollo does. This is the concrete win the person layer buys on the B2B side |
| 2166 | `12. Every row lands in the ledger as an `O|` row.` | The B2B state landing | Rewritten. Every prospect lands as a person file |
| 2179 | `grep -c 'ge ledger add-outreach' $S` | Acceptance grep | Becomes `grep -c 'ge person add'` |
| 2185 | `grep -c '^O|' /Users/pmudh/Downloads/Atlanta/launchhouse-atlanta/runs/b2b-arc/growth-engine/ledger.md` | Acceptance grep on the arc run | Becomes a count of `growth-engine/people/` |
| 2191 | `The b2b arc run must show `25` `O|` rows regardless of which gate D branch was taken.` | The count assertion | Becomes 25 person files. **Second of the four loud failures** |
| 2201 | `**Depends on: B-05, B-06, B-00 (`schemas/gates.md`), AB-01 (the `D|` rows).**` | A-02's dependency line | The dependency moves from `AB-01 (the D| rows)` to the person task |
| 2205 | `1. Edit ... `skills/status/SKILL.md` so it reads `ge index` plus ledger counts: content by status, outreach by status, DMs by status.` | What status reports | Content by status from the ledger, people by status from `ge person list`. Two sources, two commands, no derived middle |
| 2207 | `3. **State explicitly, in the skill text, whether the B2C gate counts `D|` rows or falls back to file presence.** Pick one. An unstated fallback is how a gate quietly reports zero for 65 people.` | The gate counting rule, and its warning | The rule is now settled by construction: the gate counts person files, and file presence and the count are the same fact. This paragraph is the one place in the plan that already names the failure mode this whole document is about |
| 2219 | `grep -c 'D|' plugins/growth-engine/skills/status/SKILL.md` | Acceptance grep | Becomes a grep for `ge person`. **Left as is it returns 0 and fails, which is the correct loud failure. Third of the four** |
| 1642 to 1676 | D-03, `a seeded `growth-engine/` folder` in the zip | The Launchhouse zip contents | The seeded folder gains `people/`. The acceptance line `The zip listing must show exactly four top-level entries plus the seeded folder` still holds, but the fixture behind it changes |
| 1711 to 1756 | CI-01, the validate.sh v2 task | The check list | Gains the person-file checks, and item 11's hard-coded counts move if a command is added |
| 1832 | `Do not copy `.state/`, `ledger.md` or `ops-log.md`: they are machine files and the examples are for reading.` | X-01 step 4, the example import exclusion list | **Must gain `people/`.** This is a privacy line, not a tidiness line. Person files carry names, companies and email addresses. See list D, item D-9 |
| 1860 | `( cd "$RUNS/$r" && sh $GE ledger list C | wc -l )` | X-01 acceptance | No change, it was already scoped to C. Add a person count line beside it |
| 1866 | `Each run's `growth-engine/` listing must contain `founder-brain.md`, `content-30.md`, ...` | The arc completeness assertion | Gains `people/` with a per-route expected count |

### 03-review-process.md

| Line | Exact text | What it asserts | What must change |
|---|---|---|---|
| 56 | `| 2 | The golden test suite | Every commit touching `plugins/growth-engine/bin/`, `plugins/growth-engine/scripts/`, `plugins/growth-engine/schemas/` or `tests/` |` | The golden trigger | No change, the paths already cover a new subcommand |
| 1770 | Same trigger restated at the head of section 2 | | No change |
| 1780 to 1785 | `> **Amended by section 08.** The suite gains a case group for `ge remember` ... Fixtures go under `tests/fixtures/09-remember/`. Add 0.1d to the suite's effort.` | The precedent for adding a case group | Followed again for `ge person`. **Note the number collision: `09-remember` is claimed here while `09-date-compat.sh` already exists at line 1811.** Do not compound it. Take the next free number |
| 1806 to 1816 | The case list: `01-help.sh` through `10-scatter.sh`, including `05-ledger.sh` | The suite contents | `05-ledger.sh` narrows to `C|` only. A new case covers `ge person`: add, set, an invalid status for the kind, a duplicate key, a half-marked notes block, an amend with a moved anchor, and a CRLF-carrying file |
| 1843 | `A ledger row with seven fields where the schema says eight.` | Why byte-exact matters | Still true. Add the person analogue: a header field that lost its colon |
| 940 to 945 | V-11's example markers, `<!-- example:valid file=ledger.md -->` and `C|001|1|post|text|draft|-|-` | Schema examples are executed against `ge lint` | `schemas/person.md` needs its own valid and invalid example blocks. The fixture builder at line 962 writes the example to `"$box/growth-engine/$target"`, a flat path. **A person example's target is `people/<key>.md`, two levels deep, and the builder does not `mkdir -p` the parent.** See list D, item D-6 |
| 999 to 1006 | The writers map body: `founder-brain.md|founder-brain|ge snapshot` ... `ledger.md|ge ledger|internal` | One declared writer per founder file | Gains a person row. **The map is one row per FILE and person state is a DIRECTORY.** Either the map grammar gains a glob form, or the row reads `people/|ge person|internal`. Decide it here, once, or V-12 silently skips the person layer. See list D, item D-5 |
| 1024 | `others=$(grep -rl "writes \`$file\`" "$PLUGIN/skills" 2>/dev/null | grep -v "/$skill/" || true)` | The TWOWRITERS detector | Under the adopted shape it keeps working. **Under the lead proposal it fires on `ledger.md` and the only way to quiet it is to weaken the check** |
| 1036 | `warn "no schemas/writers.md yet. One writer per file is unenforced until it exists"` | The deferred state | No change |
| 622 to 674 | V-07, no secret-shaped string is ever committed | The secret scan | Person files are not secrets, but they are personal data, and the scan does not look for names or email addresses. The gap is covered by the example scrub patterns in section 04, not here. Say so in one line so nobody assumes V-07 covers it |
| 1325 to 1372 | V-16, no automated Instagram or Facebook direct messages | Design rule 1 enforcement | The person file must not introduce a phrase that reads as a send queue. A field named `queue` or `scheduled_send` would trip this check, correctly. Choose `last_touch:` and nothing else |
| 2528 | `**Step 9** on a B2B route enrols into an Apollo sequence and must land PAUSED. ... On a B2C route it produces 25 DM openers and the tester confirms that nothing in the output offers to send them.` | The rehearsal's engine 2 step | Gains: and 25 person files exist afterwards, with the right kind and status |
| 2705 | `- [ ] The publish read-back passed, and the forced-failure case produced a `failed` ledger row with a recovery line.` | Release gate 5 | Unchanged. Gains a person line: the arc left 25 person files per route with valid statuses |
| 2697 | `- [ ] The three example folders are complete, not Brain-only: `find plugins/growth-engine/assets/examples -type f | wc -l` = ____` | The example file count | The number moves if person files are exported to examples, and does not if they are excluded. Decide once and record it here, because this checklist is ticked by hand |
| 2803 | `| `outreach-b2b` | `outreach-sequence.md`, `outreach-firstlines.csv`, `ledger.md` O rows | b2b-northfield only |` | The regeneration map | `ledger.md` O rows becomes `people/` prospect files |
| 2804 | `| `audience-b2c` | `dm-openers.md`, `hook-bank.md`, `inbound-scripts.md`, `ledger.md` D rows | b2c-lumen and b2c-ecom |` | The regeneration map | `ledger.md` D rows becomes `people/` target files |
| 2813 | `| `bin/ge` or `scripts/**` | `.state/index.md`, `ops-log.md` formatting, snapshot names | Re-run `ge index` in all three, commit the diff |` | What a `ge` change stales | Gains person file formatting, and the remedy line gains a person regeneration step |
| 2824 to 2832 | The `.generated-with` stamp block, one line per skill | Staleness detection | No new line needed if the person layer is `ge`-side only. If `ge person` gains its own template the stamp needs a row |

### 04-examples-and-docs.md

| Line | Exact text | What it asserts | What must change |
|---|---|---|---|
| 158 | `| `ledger.md` | `ge ledger` | 2 to 4 KB | Thirty content rows plus the route's outreach or DM rows. ... Header line names `ge ledger` as the only writer |` | The example ledger's expected shape | Loses "plus the route's outreach or DM rows". Size band drops. A new row is added for `people/` unless it is excluded from examples |
| 183 | `| `prospects-35.csv` | outbound engine, B2B branch | 5 to 8 KB, 36 lines | The 35 built from the live search, before the cut...` | A person representation outside the ledger entirely | Must be reconciled. Is `prospects-35.csv` still produced, or does the person layer replace it? The 10 people cut at line 184 have no person file under one reading and 10 files with `status: cut` under another. Decide, because the counts in list C depend on it |
| 184 | `| `prospects-25.csv` | ... The 25 that survived the cut, enriched, each row carrying an `email_status` value. Ten rows fewer than the file above` | The second person representation | Same question. `email_status` is a fact about a person that currently lives only in a CSV and has no home in `O|` |
| 186 | `| `outreach-firstlines.csv` | ... One first line per prospect, each referencing something specific and checkable about that company.` | The third person representation | The first line is now also a person file field. Either the CSV becomes an export view of the person files, or the same fact has two homes. Recommend: it becomes an export, generated on demand, and says so |
| 197 | `| `dm-openers.md` | ... Twenty five openers, each tied to a named target account` | The B2C person representation | Same. The opener text is a fact about a target and belongs in that target's file, with `dm-openers.md` as the readable export |
| 344 | `4. writes `MANIFEST.md`;` | The import script steps | No change |
| 366 to 400 | The `MANIFEST.md` shape and the `## Sources this folder was generated from` list | Provenance | Gains `scripts/ge.sh` coverage already; no new row needed unless a person template ships |
| 416 | `b2c-service-brighthound  MISSING MANIFEST` | The `check-examples.sh` output shape | No change |
| 433 | `| the outbound engine skill, B2B branch | `icp.md`, `prospects-35.csv`, `prospects-25.csv`, `outreach-sequence.md`, `outreach-firstlines.csv`, `manual-route.md`, the outreach rows of `ledger.md` |` | The example staleness map | `the outreach rows of ledger.md` becomes `the prospect files under people/` |
| 434 | `| the audience engine skill, B2C branch | `dm-openers.md`, `hook-bank.md`, `inbound-scripts.md`, `offer-tests.md` |` | The B2C half | Gains the target files under `people/`. Note it does not currently name the ledger at all, which is already a gap |
| 453 | `Three invented founders, three invented businesses, invented customers, invented numbers, invented prospects.` | The fiction rule | Gains: and invented person files |
| 461 | `| Real prospect data of any kind: names, companies, job titles, email addresses, phone numbers | These are real people's contact details, published to a public repository by a tool that promised their data stays on the founder's machine | Straight out of a live Apollo search during the B2B run. This is the single highest risk in Part A |` | The highest-risk leak in the whole plan | **The person layer increases this risk, because it creates 25 well-structured files of exactly this data per founder.** The row must name `people/` as a second route in |
| 470 to 478 | `**Handling the B2B prospect problem.** ... two passes ... a fixture list of 35 invented UK construction firms` | The two-pass fiction procedure | Applies unchanged to person files, and must say so explicitly, because a reader will assume it covers only the CSVs it names |
| 479 | `The same fixture approach covers Cara's DM targets. Her 25 openers must not name 25 real Instagram accounts.` | The B2C half of the same rule | Gains: nor may 25 person files |
| 487 to 494 | The scrub patterns block for `import-example.sh` | What blocks an import | Person files are the highest-value target for this gate and no pattern currently matches a name or a company. Add nothing naive (a name pattern would false-positive on everything), but **either exclude `people/` from import entirely or add an explicit human read step**. Recommend exclusion. See list D, item D-9 |
| 505 to 512 | `Check every one of these: ... Every account name in Cara's and Priya's DM opener targets` | EX-05's clearance list | Gains: and every person file key and company field in each example |
| 562 to 566 | The EX task table, `EX-02` scrub gate, `EX-05` clearance | The harness tasks | `EX-02` and `EX-05` both gain person scope. `EX-03`'s `check-examples.sh` unaffected |
| 697 to 706 | The CONNECTIONS outline: `contacts.readonly reads contacts` ... `Contact rows, to GoHighLevel, when you create contacts.` | What leaves the machine | Gains one line: person files never leave the machine. That is a promise worth making explicitly, because the file looks like a CRM and founders will assume it syncs |
| 748 to 760 | The USING-IT file map table, `| `ledger.md` | `ge ledger` only | **No** |` and the rest | Who may hand-edit what | Gains a `people/` row. The answer is nuanced and must be stated: the founder may edit inside the notes blocks and outside the markers, and may not edit the header fields |
| 753 | `| `outreach-sequence.md`, `outreach-firstlines.csv` | outbound engine, then you | Yes for the sequence. The first-lines CSV is regenerated, so edit the sequence and rerun |` | The hand-edit rule for the first-lines CSV | Consistent with making the CSV an export of the person files. Say which file the edit should be made in instead |
| 824 | `Sharing it with a mentor: send the specific file, not the folder, because the folder contains your prospect list.` | The sharing warning | Already correct in spirit and now more true. Update the wording: the folder contains a file per person |
| 860 to 900 | The TROUBLESHOOTING entry list, `*State and recovery* 25. I edited the ledger by hand.` | The symptom list | Gains at least two entries: "I edited a person file by hand", and "the same person is in there twice" |
| 991 | `2. **What it contains.** The workflows in it, named, in the order they fire.` | The snapshot doc | No change |
| 1005 | `8. **The test-contact run.**` | The clinic checklist | No change. "Test contact" here is a GoHighLevel contact, not a person file. Worth one clarifying clause so the two do not blur |

### 05-routes-and-platforms.md

| Line | Exact text | What it asserts | What must change |
|---|---|---|---|
| 96 to 105 | The route axis table, ending `| What ships on Saturday | 25 cold emails, or an Apollo sequence activated | 25 Instagram DMs sent by hand | 25 Instagram DMs sent by hand |` | What each route builds | Gains a row: what the person layer holds per route, 25 prospects or 25 targets |
| 793 | `| 3 | `/growth-engine:content` | "build my content engine" | Yes | `content-30.md`, `content-30.csv`, `rss-feeds.md`, 30 ledger rows |` | The command output table | No change |
| 855 | `| 3 | `/growth-engine:content` | `content-30.md`, `content-30.csv`, 30 ledger rows | Nothing |` | The b2b journey | No change |
| 858 | `| 6 | `/growth-engine:engine2` | `outreach-sequence.md`, `outreach-firstlines.csv`, 25 `O` rows in the ledger, an Apollo sequence enrolled paused | ...` | The b2b journey's engine 2 output | `25 O rows in the ledger` becomes `25 prospect files under people/` |
| 883 | `| The 25 messages | A sequence with `{{first_line}}` per contact | 25 finished messages, written out in full...` | The manual route comparison table | No change to the row, but the manual route's state landing changes with section 07's F-04 |
| 884 | `| `outreach-firstlines.csv` | An import file | A checklist. Who, the opening line, and a column to tick when sent |` | The CSV's dual role | If the CSV becomes an export of person files, ticking a column in it no longer records anything. The founder ticks by running `ge person set <key> status contacted_ok`. **This is a real founder-facing behaviour change and it must be written into the manual route, not left implied** |
| 908 | `| 3 | `/growth-engine:content` | ... 30 ledger rows split text lane and media lane |` | The b2c journey | No change |
| 911 | `| 6 | `/growth-engine:engine2` | `dm-openers.md` with 25 openers, `hook-bank.md` with 30 hooks and 3 offer tests, `inbound-scripts.md` | Build the list of 25 real target accounts...` | The b2c journey's engine 2 output | Gains 25 target files under `people/`. Note this row does not currently mention the `D|` rows at all, which is already a gap between section 05 and section 02 |
| 919 to 925 | `Automated cold DMs get accounts restricted. ... **The pacing warning belongs in `dm-openers.md`, not only in the session.**` | Design rule 1 in the journey | No change, and the person layer must not soften it. A `sent_at` style field records what the founder did, after the fact |
| 1037 | `| A8 | 30 content pieces exist and are in the ledger | ... `ledger.md` contains 30 rows beginning `C|` |` | Gate item A8 | No change. It was already `C|` scoped |
| 1059 | `| B7 | 25 contacts exist with a personalised first line each | `outreach-firstlines.csv` has 25 data rows and no empty `first_line` cell |` | Gate item B7, verified against a CSV | The verification moves to the person files, or the CSV stays as an export and the item names which is authoritative. **Left as is, a founder who corrects a first line in the person file passes B7 against a stale CSV** |
| 1061 | `| B9 | On the Apollo route: the sequence is enrolled and paused | Open Apollo. The sequence shows 25 contacts and its state is paused |` | Gate item B9 | No change, it is verified in Apollo |
| 1076 | `| C4 | `dm-openers.md` contains 25 openers against 25 real handles | Count them. Every one has a handle beside it and no handle is a placeholder |` | Gate item C4 | Same question as B7. Recommend: verified by counting person files with `kind: target`, with `dm-openers.md` as the readable form |
| 1079 | `| C7 | The pacing warning is inside `dm-openers.md`, not only in a session |` | Gate item C7 | No change |
| 1088 | `| C13 | At least one of the 25 DMs has been sent by hand and the founder knows the pacing plan | Ask them how many they are sending per hour |` | Gate item C13, self-reported | Becomes file-backed and better: at least one person file has `status: sent`. Section 02's `schemas/gates.md` marks each item `file-backed` or `self-reported`, so this item's marking changes |
| 1103 | `**b2b is live** when 25 authenticated, personalised, opt-out-carrying messages are either enrolled in a paused Apollo sequence ... or written out in full` | The b2b definition of live | No change to the promise. The evidence path changes |
| 1105 | `**b2c-service is live** when ... 25 openers exist against 25 real handles with a pacing plan the founder can describe.` | The b2c definition of live | Same |

### 06-code-standards.md

| Line | Exact text | What it asserts | What must change |
|---|---|---|---|
| 117 | `# READS:         <files/env>       WRITES: <files it is the ONE writer of>` | The header template | No change to the template. The new person library's header has to fill it in, and the value is a directory glob |
| 230 to 237 | `` `WRITES:` on the same line lists **only the files this script is the one writer of**. ... Good: `# READS:         growth-engine/ledger.md   WRITES: growth-engine/ledger.md (sole writer)` `` | The one-writer rule expressed in the header | The worked example uses the ledger, and after this change the ledger example is thinner. Add a person example showing a directory form, because that is a shape the rule has never had to express |
| 897 | `ge ledger add-content | set-content | add-outreach | set-outreach | list` | The complete subcommand set, in a code block presented as authoritative | Becomes `ge ledger add-content | set-content | list`, and a new line `ge person add | set | list | show | note` is added. **This block is already stale: it omits `add-dm`, `set-dm`, `approve`, `receipt`, `accounts` and `remember`** |
| 903 | `The dispatcher's subcommands, as at the locked scope: `init`, `snapshot`, `restore`, `undo`, `log`, `ledger`, `index`, `lint`, `context`, `check`, `receipt`, `accounts`, `remember`.` | The dispatcher list, which is the one that is current | Gains `person`. This is the authoritative list and the code block above it is not, which is itself worth fixing in the same commit |
| 904 | `- No abbreviated subcommands and no aliases. One name per operation.` | The naming rule | Constrains the new verbs. `ge person add` and `ge person set`, never `ge p` and never both `add` and `create` |
| 906 | `- Compound sub-subcommands are hyphenated and lower case: `add-content`, not `addContent`` | The naming rule | Person sub-verbs follow it |
| 1083 | `|| err "$rf: the READS line carries no WRITES:. State the files this script is the ONE writer of, or write 'WRITES: nothing'"` | The header check in validate | No change to the check, but it now has to accept a directory value without complaint |

### 07-quality-and-simplicity.md

| Line | Exact text | What it asserts | What must change |
|---|---|---|---|
| 15 | `2. Outbound engine. B2B: Apollo MCP, from an ICP to a live search to 35 built to 25 cut to enriched to contacts to a sequence carrying a `{{first_line}}` merge field, enrolled paused. ... B2C: 25 direct message openers sent by hand` | The scope summary at the head of the section | Gains the person layer in one clause, matching the change to `00-scope.md` line 12 |
| 17 | `4. The brain: `bin/ge`, POSIX sh, schema-described state, one writer per file, snapshot-before-write with undo, an append-only ops log, a derived index and an evidence doctor. The one exception is a managed block...` | The brain summary, and the single stated exception to one-writer | Gains the person layer. The managed-block exception sentence already generalises correctly and needs only the file list widened |
| 72 | `the skill reads every file in the founder's folder, which for B2B includes `outreach-firstlines.csv` holding real named prospects and their email addresses, with no rule excluding them from a document that goes to a printer.` | The playbook privacy finding | **`people/` joins that list and makes the finding worse.** The exclusion list at line 89 must name it |
| 87 | `a skill that pulls named prospect email addresses into a document headed for a print run is a data incident waiting for a founder to run it.` | Why playbook-export is deferred | Reinforced, and worth one added sentence, because this is now a stronger argument for the deferral holding |
| 89 | `an explicit exclusion list naming `outreach-firstlines.csv` and any file matching `*contacts*`` | The exclusion list if the deferral is reversed | Gains `growth-engine/people/` |
| 251 | `The PRD's section 2.3 declares these machine-read files: `.state/HOME`, `.state/index.md`, `.state/receipt.md`, `.state/ghl-accounts.md`, `.state/snapshots/`, plus `ledger.md` and `ops-log.md`` | The state model inventory | Gains `people/`. Note `memory.md` is also absent from this list, which section 08 added and this line never caught up with |
| 249 | `#### S-08 Cut the state model from seven machine-read files to five. ADOPT.` | The simplification heading, with a count in it | The count moves. A heading with an arithmetic claim in it is exactly the kind of thing that goes stale silently |
| 281 to 288 | The state tree drawing: `growth-engine/` / `├── ledger.md    one writer: ge ledger` / `├── ops-log.md   one writer: ge log, append only` / `└── .state/ ...` | The canonical one-writer diagram | Gains `├── people/   one writer: ge person`. It is already missing `memory.md` |
| 290 | `Five things, each with exactly one writer, and nothing derived sitting on disk pretending to be truth.` | The closing claim | The number moves, and the second half of the sentence is the argument against the lead proposal, stated by the plan itself before the question was asked |
| 304 | `` `schemas/state.md` holds every machine format in one place: the `HOME` line, the `C|` and `O|` ledger row grammars with their enums, the `ops-log.md` day header and entry grammar, and the receipt section list.`` | S-09's proposed two-file schema set | Already out of date: it names `C|` and `O|` and not `D|`. Under the adopted shape it names `C|` only and points at the person format. **S-09 and B-00 already contradict each other on the schema count. Do not add a third answer** |
| 475 | `| R-03 | Apollo's MCP action set does not expose custom-field writes, sequence creation, or contact creation | `{{first_line}}` personalisation dies mid-build...` | The Apollo risk row | The mitigation improves. With person files, a failed `first_line` write-back loses the Apollo automation but not the founder's 25 lines. Update the impact column |
| 529 | `PRD task B-05 specifies `ge ledger` with `add-content`, `set-content <id> <field> <value>`, `add-outreach`, `set-outreach <email> ...` and `list [C|O] [--status X]`` | The B-05 surface quoted inside a fallback spec | Rewritten. Note it quotes `[C|O]` where section 02 says `[C|O|D]`, so this line is already one version behind |
| 581 | `1. `outreach-firstlines.csv`: 25 rows, each with first name, company, email, and the personalised first line.` | F-04's manual route artifact list | Either regenerated from person files or the person files are the artifact and the CSV is the export |
| 585 | `**State left behind.** `O|` rows in the ledger with status `contacted_ok`, set by the founder as they go, one command per day rather than per row.` | F-04's state landing | Rewritten as person files. The command the founder types changes, and this is one of two places the founder-typed command is written out |
| 600 | `**State left behind.** `O|` rows at `enrolled`. Activation does not change the ledger, because activation is the founder's act and the ledger records what the toolkit did.` | F-05's state landing, and the principle behind it | Rewritten. **The principle in the second clause must survive verbatim: the person file records what the toolkit did or what the founder told it, never an inference.** That is hard constraint 5 stated in the plan's own words |
| 852 (item 24) | `Every skill that writes a file named in `schemas/state.md` names `ge snapshot` in the same file.` | Definition of done item 24 | The person layer is written through `ge person`, not by a skill directly, so the item holds. Say so, or a reviewer will read it as uncovered |
| 892 (item 26) | `Content: a full generation run produces 30 ledger rows with the correct lane on each` | Item 26 | No change |
| 909 (item 32) | `Outbound B2B: the manual route produces a complete sendable set of 25 ... the run folder contains `outreach-firstlines.csv` with 25 rows` | Item 32 | The check gains or moves to a person file count |
| 911 (item 33) | `Outbound B2C: 25 openers, a hook bank, and the pacing block containing the three action-block lines.` | Item 33 | Gains 25 target files |
| 936 (item 49) | `Neither worked example contains an invented number, customer or result.` | Item 49 | Gains: nor an invented person presented as real, and no real person at all |
| 938 to 942 (items 50 to 52) | `50. `ge init` seeds `growth-engine/memory.md` ... 51. A memory entry survives the founder editing the same file. 52. A half-marked memory file is refused` | The three memory items | Three person analogues added. **The list already has two items numbered 50, two numbered 51 and two numbered 52.** Renumber before adding, or the collision triples |

---

## Part 2, list A: files that must change, with an edit count each

An edit is one contiguous passage that has to be rewritten, not one changed character.

| # | File | Edits | The heaviest of them |
|---|---|---|---|
| 1 | `planning/delivery/02-build-steps.md` | **34** | `B-00` schema set and its acceptance (9), `B-05` shrinking to one row type (10), `AB-01` (5), `A-01` (5), `A-02` (3), effort and cut order (2) |
| 2 | `planning/delivery/03-review-process.md` | **12** | The writers map grammar in V-12 (2), V-11's example builder path bug (2), the golden case list (2), the regeneration map (3) |
| 3 | `planning/delivery/04-examples-and-docs.md` | **17** | The three prospect CSVs and `dm-openers.md` reconciliation (4), the fiction and scrub rules (5), the USING-IT file map (2), TROUBLESHOOTING entries (2) |
| 4 | `planning/delivery/05-routes-and-platforms.md` | **11** | Gate items B7, C4 and C13 (3), the two journey tables (2), the manual route tick-column behaviour (1) |
| 5 | `planning/delivery/07-quality-and-simplicity.md` | **16** | The state tree and `S-08` (4), `S-09`'s schema list (1), F-04 and F-05 (2), definition of done items and their renumbering (5) |
| 6 | `planning/delivery/08-persistent-memory.md` | **9** | Line 26, the row that refuses the person layer (1), the marker scope at line 125 (1), the schema count at line 261 (1) |
| 7 | `planning/delivery/00-scope.md` | **3** | The four systems table, rows 2 and 4 |
| 8 | `planning/delivery/06-code-standards.md` | **5** | The subcommand code block at line 897, which is stale already |
| 9 | `planning/DELIVERY-PLAN.md` | **4** | The section 08 row in the sections table, the effort figures, the id-series table, the "what changed" note |
| 10 | `planning/delivery/01-state.md` | **0 or 2** | Only if a new command file ships |

**Total: 111 to 113 edits across 9 or 10 files.**

The three files that carry more than half of it are 02, 04 and 07, and they are the three that were written by different passes and have already drifted from each other on the schema count, the subcommand list and the `[C|O]` versus `[C|O|D]` selector.

---

## Part 3, list B: task ids whose body or acceptance block must be amended

| Task | Where | What changes in it |
|---|---|---|
| **New task, id to be assigned** | Section 02 Phase 2, after `B-10` | The whole person layer. Numbered so no existing id moves, exactly as `B-10` was. Depends on `B-00` for the schema, `B-03` for the snapshot ring, `B-04` for the ops log, `B-10` for `lib/blocks.sh`. Blocks `AB-01`, `A-01` and `A-02` |
| `B-00` | 02:578 to 624 | Heading count, body count, the ledger row list drops two grammars, a ninth schema file is added, the acceptance file list, the writer count 7 to 9, the `D|` grep deleted, the commit line |
| `B-02` | 02:670 to 706 | `ge init` seeds `people/`. The `tests/fixtures/init-tree.txt` fixture is regenerated, which is a fixture change with its own commit-body evidence |
| `B-05` | 02:786 to 830 | Heading, status note, effort down 0.25d, four verbs removed, three acceptance lines removed, two assertions removed, commit line |
| `B-06` | 02:832 to 876 | The ledger lint leg narrows. A person lint leg is added: required fields, kind, status against the right enum, key matches filename, no duplicate key. The seeded-fault WARN count moves |
| `B-08` | 02:904 to 951 | `ge check` gains a person leg in the `PASS or FAIL, evidence, fix` shape, matching what section 08 does for the memory leg |
| `B-10` | 02:993, 08:173 to 249 | Gains a "blocks" entry for the person task, because `lib/blocks.sh` is shared |
| `AB-01` | 02:1278 to 1337 | Snapshot chain, step 5, two acceptance greps, the 25-row assertion. Its dependency line loses `B-05 (the D row)` and gains the person task |
| `A-01` | 02:2145 to 2195 | Snapshot chain, step 8 gains a local first-line write, step 12, two acceptance greps, the 25-row assertion |
| `A-02` | 02:2197 to 2232 | Dependency line, step 1's source of counts, step 3 becomes settled rather than a choice, the `D|` grep in the acceptance |
| `X-01` | 02:1819 to 1880 | Step 4's example exclusion list gains `people/` on privacy grounds. The acceptance gains a person count per route. The completeness assertion at line 1866 |
| `CI-01` | 02:1711 to 1756 | The check list gains the person-file structural checks and the `people/` scan. Item 11's hard-coded counts if a command ships |
| `D-03` | 02:1642 to 1676 | The seeded `growth-engine/` folder inside the zip gains `people/` |
| `D-06` | 02:1511, 04:744 to 830 | `docs/USING-IT.md` gains a person section: what is in a person file, which parts are the founder's, how to correct one, and that it never leaves the machine |
| `D-07` | 02:1522, 04:860 to 900 | `docs/TROUBLESHOOTING.md` gains two entries at minimum |
| `G2-03` | 02:2026, 04:680 to 710 | `docs/CONNECTIONS.md` gains the line that person files never leave the machine |
| `EX-02` | 04:562 | `import-example.sh` must decide `people/`: exclude, or gate behind a read step |
| `EX-05` | 04:505 to 512, 565 | Name clearance extends to every person file key and company field |
| `EX-11` | 04:566 | The full regeneration sweep now regenerates person files too |
| `PB-01` | 02:1339, 07:89 | Deferred, so no build change, but its exclusion list gains `people/` in case the deferral is reversed |
| `R-01`, `R-02` | 02:1882, 02:1913 | The clean-machine rehearsal and the freeze both inherit the arc changes. No independent edit, but they must not be signed off against the old arc evidence |
| The golden suite | 03:1766 to 2056 | `05-ledger.sh` narrows. A new case is added at the next free number, avoiding the existing `09` collision. Effort plus 0.1d, matching the precedent at 03:1785 |

**Twenty two task ids, one of them new.**

---

## Part 4, list C: counts and enums that appear in more than one section and must move together

Each block below is one fact stated in more than one place.
Change one without the others and the plan disagrees with itself, which is how the last 47 happened.

**C-1. The schema file count.**
Stated at 02:578 (heading, "eight"), 02:588 (body, "eight"), 02:591 to 597 (seven numbered items), 02:618 (acceptance, "exactly seven files"), 02:620 (writer count 7), 02:622 (commit, "seven"), 08:261 (7 to 8), 07:296 to 311 (`S-09` says two files, not five).
**Six places, and they already disagree three ways before this change.** Fix the existing disagreement in the same commit or the new number lands on top of a contradiction.

**C-2. The ledger row grammars.**
Stated at 02:591 ("all three of them"), 02:592 to 594 (the three lines), 03:940 to 945 (V-11's example blocks), 07:304 (`S-09`, names `C|` and `O|` only), 04:158 (the example ledger description), 06:897 (the subcommand block's `list` selector), 07:529 (`list [C|O]`), 02:794 (`list [C|O|D]`).
**Eight places. 07:304, 07:529 and 06:897 are already stale.**

**C-3. The two status enums.**
Prospect: `candidate|cut|contacted_ok|enrolled|replied|stopped`, at 02:593, and consumed at 07:585 (`contacted_ok`) and 07:600 (`enrolled`).
Target: `target|opener_written|sent|replied|booked|no_reply`, at 02:594, and consumed at 02:1284 (`opener_written`) and 05:1088 (a `sent` DM).
**Six places. Both enums move to `schemas/person.md` unchanged, and every consumer keeps its meaning. Unify them and all six shift meaning at once.**

**C-4. The number 25, per route.**
02:1333 (25 `D|` rows), 02:2191 (25 `O|` rows), 05:858 (25 `O` rows), 05:911 (25 openers), 05:1059 (B7, 25 rows), 05:1076 (C4, 25 openers), 05:1103 and 05:1105 (the live definitions), 07:15, 07:581, 07:909, 07:911, 00:12, 04:184, 04:186, 04:197.
**Fifteen places.** The number does not change. What changes is what is counted, and it must change in all fifteen or the gate and the acceptance count different things.

**C-5. The number 35, and the 10 cut.**
00:12, 04:183, 04:184, 04:476, 07:15.
**Five places.** Open question in Part 6: do the 10 cut prospects get person files with `status: cut`, or no file at all? The answer changes the expected `people/` count in every B2B acceptance.

**C-6. The `ge` subcommand list.**
06:897 (the code block), 06:903 (the dispatcher list), 02:794 to 796 (B-05's verbs), 07:529 (quoted inside F-03).
**Four places, and 06:897 and 07:529 are already behind 06:903.**

**C-7. The one-writer state model.**
07:281 to 290 (the tree drawing and the "five things" claim), 07:251 (the file inventory), 03:999 to 1006 (`schemas/writers.md`), 00:14 (the brain description), 07:17 (the brain summary), 06:230 to 237 (the header rule).
**Six places. `memory.md` is already absent from four of them**, which is the live proof that this cluster does not get updated together.

**C-8. The skill and command counts.**
01:28 to 29, 03:144 (CK-14), 03:152 (CK-17), 03:1472 to 1573 (V-18's MANIFEST), 02:1481 (CMD-01 changes 10 to 12), 02:1740 (CI-01 item 11), 00:54 (playbook stays so no count moves).
**Seven places.** They move only if `ge person` gains a command file. Recommend it does not, and that `status` and the new person reporting are reached through the existing `/growth-engine:status`. That keeps this entire cluster still.

**C-9. The definition of done item numbers.**
07:822 to 960. Items 50, 51 and 52 each appear twice already.
Adding three person items on top of a live collision guarantees a mis-tick.
**Renumber first, in its own commit, then add.**

**C-10. The golden test case numbers.**
03:1806 to 1816 lists `01` through `10`. 03:1785 claims `09-remember`, colliding with `09-date-compat.sh`.
**Resolve the existing collision before claiming a number for the person case.**

**C-11. The build total.**
DELIVERY-PLAN.md:30 (44.95), 02:96 to 105 (the table and the 39.95 re-sum note), 08:272 to 273 (the 39.2 to 40.2 to 44.95 chain).
**Three places, one arithmetic chain.**

**C-12. The cut order positions.**
02:107 to 125 (nine rows), 08:275 (`B-10` is position 5 of 9), 00:54 and 07:740 to 760.
**Four places.** Append rather than insert, or 08:275 is wrong the moment a row goes in above position 5.

---

## Part 5, list D: what would break silently

This is the important list.
Everything here keeps running, keeps printing, and keeps passing while being wrong.
Ordered worst first.

---

**D-1. Under the lead proposal, every `^O|` and `^D|` consumer reads a stale derived row and reports it as fact.**

The consumers are: 02:2185 (A-01's acceptance), 02:1323 (AB-01's acceptance), 02:2219 (A-02's acceptance), 05:1059 (gate item B7 by way of the CSV), 05:1076 (gate item C4), 05:1088 (gate item C13), the `status` skill, the `gate` command, and `ge lint`'s row checks at 02:847.

If `ge index` is the rebuilder and it has not run since the last `ge person` write, all nine read the previous state.
Nothing anywhere prints "these rows are derived and may be stale".
A founder who marks a prospect `stopped` and then submits a gate has a gate that says `enrolled`.
There is no failure, no warning, and no arrow.

This is the single strongest argument for retirement over derivation and it is why Part 0 rejects the proposal.
**Under the adopted shape this entire class disappears, because there is no derived copy to be stale.**

---

**D-2. The three CSV and markdown person exports become stale copies with no freshness check at all.**

`outreach-firstlines.csv` (04:186, 05:884, 05:1059, 07:581, 07:909), `prospects-25.csv` (04:184), `prospects-35.csv` (04:183) and `dm-openers.md` (04:197, 05:911, 05:1076, 05:1079, 07:911) all carry per-person facts.

Section 02's `B-06` has a divergence check for exactly this shape, at 02:848: the first 40 characters of each `content-30.csv` row must match `content-30.md`.
**No equivalent exists for any person export.**

So: a founder corrects a first line in the person file, the CSV still holds the old one, gate item B7 at 05:1059 reads the CSV, passes, and 25 emails go out with the old line.
`ge lint` says nothing. The doctor says nothing. Nothing is red.

Fix: either the exports are regenerated by `ge person` on every write and never hand-edited, or `B-06` gains a divergence check per export in the shape it already uses for the CSV.
**Do not ship the person layer without one of the two.** This is the most likely real-world failure in the whole change.

---

**D-3. Gate item C13 flips from self-reported to file-backed and nobody notices the marking is wrong.**

05:1088 reads `At least one of the 25 DMs has been sent by hand and the founder knows the pacing plan | Ask them how many they are sending per hour`.
`schemas/gates.md` (02:596) marks every item `file-backed` or `self-reported`, and 02:2207 says the gate must branch on that marking.

With person files, `status: sent` makes C13 file-backed.
If `schemas/gates.md` is not updated in the same commit, the gate keeps asking the founder and keeps ignoring the file.
The gate passes either way, so nothing fails, and 65 B2C founders are graded on an answer rather than on evidence.

---

**D-4. `ge index` freshness stops covering the truth, and the doctor keeps saying the index is fresh.**

02:918 gives `ge check` an `index freshness: the index is not older than the newest founder file` leg.
`.state/index.md` is the file table.
If person state lives in `people/` and the index does not enumerate it, the doctor reports a fresh index against a folder whose person half it never looked at.

Under the lead proposal it is worse: the index is fresh, and the ledger rows it produced are stale, and the freshness leg reports on the wrong file.

Fix: `ge index` must either enumerate `people/` or the doctor leg must state plainly that it does not cover it.

---

**D-5. V-12's writers map skips the person layer entirely and prints ok.**

03:999 to 1006 defines `schemas/writers.md` as one row per FILE:

```
ledger.md|ge ledger|internal
ops-log.md|ge log|append-only
```

and 03:1017 parses it with `grep -E '^[a-z0-9.-]+\|'`.

`people/prospect-sofia-brightops.md` does not match that pattern, because of the slash.
So a person row either cannot be written, or is written and silently filtered out by the grep.
Either way the loop body never runs for the person layer, `$TMP/writers.out` stays empty, and the check prints `ok    every founder file has one writer and a snapshot-first instruction`.

**It passes while covering nothing.** That is the same failure mode as 03:296, the empty `FLOOR_SCRIPTS` case, which this plan already found once and guarded loudly. Guard it the same way.

---

**D-6. V-11's schema example harness cannot build a person fixture, and fails in a way that reads like a schema bug.**

03:962 does `mkdir -p "$box/growth-engine/.state"` and then writes the example to `"$box/growth-engine/$target"`.
For `schemas/person.md` the target is `people/<key>.md`.
`people/` is never created, so the `awk` redirect fails, the file is empty, `ge lint` sees nothing, the valid example is reported as `BADVALID` and the invalid example as `BADINVALID`.

A reader sees two schema failures and edits the schema.
The schema is fine.
The harness needs one `mkdir -p "$(dirname ...)"`.

This one is not silent, it is loud and misattributed, which costs an afternoon rather than an event.

---

**D-7. The snapshot ring gives per-file undo, and 25 person files means undo becomes per-person.**

`B-03` (02:707) is a ring of 10 per file.
`ge undo` at 02:713 restores the most recent snapshot across all files, and asks which when more than one file was snapshotted in the last hour.

A single `ge person` bulk operation over 25 targets snapshots 25 files in one second.
`ge undo` then has 25 candidates, asks the founder to choose, and the founder cannot undo the operation, only one file of it.

The write is safe. The recovery is not.
Nothing fails, and the founder discovers it only when they need it.

Fix: either bulk person operations take one directory-level snapshot, or `ge undo` learns to group by operation.
Say which, in the task body, because 02:713's current wording promises the founder a choice that is unusable at 25.

---

**D-8. `ge lint` warns and never fails, so a malformed person file reports and is then used anyway.**

02:840 sets `ge lint` POSTURE to warn-only, and 02:864's acceptance asserts `lint exit=0` because it never blocks.
A person file with a status from the wrong enum, or a key that does not match its filename, produces a WARN and nothing more.

The skill that reads that file next has no obligation to check.
Section 02's write chain at 02:141 runs `ge index` at the end, never `ge lint`.

So an invalid person file flows into `dm-openers.md` or the sequence with a warning nobody read.
This is consistent with the existing design and should stay warn-only, but the person task must say which reads are strict.
Recommend: `ge person set` validates strictly and refuses, `ge lint` warns on files it did not write.

---

**D-9. Person files leak into the public repository through the example import, and every existing guard misses them.**

04:487 to 494 lists the scrub patterns that block an import: absolute paths, token shapes, location ids, UK mobile numbers.
**None of them matches a name, a company, a job title or an email address.**
04:461 already names real prospect data as the single highest risk in Part A, and the route in is the Apollo run.

The person layer creates 25 well-formed, machine-readable files of exactly that data per founder, in a folder that looks like part of the output.

02:1832 tells X-01 to exclude `.state/`, `ledger.md` and `ops-log.md` from the example copy, on the grounds that they are machine files.
`people/` is not on that list and does not read as a machine file, so a careful executor following the instruction as written copies it.

`scripts/validate.sh` would not fail: person files are markdown under `plugins/`, so they are style-checked for dashes and banned words and pass.
V-07's secret scan does not look for personal data.
**The commit is green and 25 real people are in a public repository.**

This is the worst outcome in this document and the guard is one line: add `people/` to 02:1832's exclusion list and to 04:487's gate, with a sentence saying why.

---

**D-10. `content-30.csv`'s style asymmetry now applies to a second file class.**

04:352 records that `content-30.csv` is not a `.md` file, so `validate.sh` never scans it, and that if the CSV is ever produced by a path other than the markdown, style violations enter unseen.

Person files as `.md` are scanned, which is good.
But `outreach-firstlines.csv` and `prospects-25.csv` are not, and they now carry text generated from person files.
A dash or a banned word written into a person note and exported to the CSV is invisible to the validator on both legs.

Not founder-fatal, but it is a documented blind spot getting wider, and 04:352 is the place that already says so.

---

**D-11. The regeneration map at 03:2803 and 03:2804 stops naming the real artifact, and staleness detection keeps reporting FRESH.**

`.generated-with` (03:2824) hashes each skill's `SKILL.md` and compares.
The map at 03:2803 and 03:2804 says which example files a skill change stales.

If those two rows still say `ledger.md` O rows and `ledger.md` D rows after the change, then an `audience-b2c` edit correctly marks the example stale, an executor regenerates `dm-openers.md` and the ledger, and does not regenerate `people/` because the map did not name it.
`check-examples.sh` re-hashes the sources, finds them matching, and prints `FRESH`.

The stamp is honest. The map behind it is not.

---

**D-12. `ge context`'s fifteen-line ceiling silently drops the person layer, and nothing says it was dropped.**

02:912 caps `ge context` at 15 lines.
08:260 already amends it to carry the newest decision and the newest open thread inside that ceiling, explicitly not growing it, with the anchor verdict and unresolved Flags winning if the ceiling is reached.

Add a person line and it competes for the same fifteen.
The losing line is not reported as omitted, because a fail-open context prints what fits.
So a founder may or may not be told about their people at session start depending on how many Flags are unresolved that day, and the behaviour looks like a bug and is not.

Either the person layer takes no context line, which is the honest answer at 25 people, or the ceiling changes and 02:912, 02:945, 08:260 move together.

---

**D-13. The `init-tree.txt` fixture is compared with `diff`, and a missing `people/` passes if the directory is empty.**

02:686 captures `find growth-engine -type f | sort` as the fixture.
`-type f` does not list directories.
If `ge init` creates `people/` empty, the fixture is unchanged, the acceptance at 02:690 passes, and nobody knows whether `people/` was created or not.

Seed a `.gitkeep` or equivalent so the directory appears in `-type f`, or the seeding step at 02:681 is untested by its own acceptance.

---

**D-14. `ge ledger list` keeps accepting `O` and `D` after the rows are gone, and returns empty with exit 0.**

02:794's selector is `list [C|O|D]`.
If the verbs are removed but the selector is not, `ge ledger list D` prints nothing and exits 0.
Every skill text and every doc that still says `ge ledger list D` reads as working.

Make the removed selectors exit 1 with a recovery line naming `ge person list`.
A removed verb that returns success is the quietest possible break.

---

**D-15. The GoHighLevel contact and the local person file are two records with no stated relationship.**

A-01 step 7 (02:2161) creates GoHighLevel and Apollo contacts.
05:1045 and 04:1005 talk about a "test contact".
Nothing anywhere says whether a person file is the same entity, a mirror, or unrelated.

Left unstated, a skill will eventually reconcile them by inference, which is a fact about a person that nobody supplied.
That is a direct breach of hard constraint 5, and it will not look like one, because it will look like helpfulness.

State it once, in `schemas/person.md`: a person file records what the founder supplied or what an API returned, with the source named, and it never claims a local record and a remote record are the same person unless something returned an id that says so.

---

## Part 6: open, and not resolvable from the sources

1. **Do the 10 cut prospects get person files?** 00:12 and 04:184 say 35 built, 25 kept, 10 removals visible in `ops-log.md` with a reason. `O|`'s enum has `cut`, which implies a row exists for them. If files exist for all 35, every "25" acceptance becomes "25 with kind prospect and status not cut", which is a different grep. Needs a decision before any acceptance block is written.

2. **Do `prospects-35.csv`, `prospects-25.csv`, `outreach-firstlines.csv` and `dm-openers.md` survive as artifacts, or become exports?** 04:176 says the outbound section is authoritative on the naming and that section 04's list is a working assumption. The outbound section (02:2145) names only `outreach-sequence.md` and "the export files". The two documents do not settle it.

3. **Does `ge person` get a command file?** It decides whether cluster C-8's seven count sites move. Nothing in the plan indicates a preference, and 07:182's `S-06` argues for shrinking the command surface, not growing it.

4. **The `email_status` field from Apollo.** 02:419 says the real field name is unknown until spike `S-07` runs and forbids inventing it. A person file wants a deliverability field. It cannot be named until `S-07` lands, so the schema needs a placeholder marked UNVERIFIED in the way section 05 does at its head.

5. **Whether `S-09`'s two-file schema set or `B-00`'s eight-file set is the plan.** 07:296 marks `S-09` ADOPT and 02:588 builds eight files. They contradict each other today and the person layer makes it worse either way. Not caused by this change, but it must be settled before `schemas/person.md` is written, because it decides whether that file exists at all or is a section inside `schemas/state.md`.

6. **The golden test number and the definition-of-done number to use.** Both series have live collisions (03:1785 against 03:1811, and 07:938 to 942). Whoever renumbers has to decide whether stability of existing references outranks correctness, and that is a call for the plan owner.
