## Persistent local memory, per founder

This section ports the memory model from the Glitch repository at `/Users/pmudh/Documents/GitHub/glitch` into this product.
It is additive.
Nothing already specified in sections 00 to 07 is withdrawn, and every existing `ge` subcommand keeps the behaviour those sections give it.

Read section 02 first for the task list this feeds into.

### What Glitch does, and which parts port

Glitch keeps a local vault at `glitch-mem/` that is the assistant's memory.
The parts worth copying are architectural rather than technical, because Glitch runs on Python with a search index and this product runs on POSIX sh with neither.

| Glitch mechanism | Ports? | What we do instead |
|---|---|---|
| A vault directory that is the only place the assistant may write | Yes | `growth-engine/` already is exactly this |
| `daily/` raw append-only logs capturing everything | Yes, already built | `ops-log.md` with day headers, task B-04 |
| `MEMORY.md`, curated and slim, loaded every session | **Yes, missing today** | `memory.md`, new, task B-10 below |
| Marker-delimited blocks the code owns inside a human-edited file | **Yes, missing today** | `GE:<NAME>:START` and `GE:<NAME>:END`, below |
| Snapshot before every autonomous write, refuse the write if the backup fails | Yes, already built | `ge snapshot`, task B-03, same fail-closed posture |
| An edit whose anchor text is not present verbatim is held, never blind-written | **Yes, missing today** | The hold rule, below |
| Restore previews the diff and waits for a confirm | Yes, already built | `ge restore`, task B-03 |
| Line endings forced to LF so a Windows checkout cannot corrupt the vault | **Yes, was missing** | `.gitattributes`, fixed, and the read rule below |
| A scheduled dream that consolidates memory overnight | **No** | The PRD forbids autonomous loops. A skill calls `ge remember` in-session, with the founder present |
| Hybrid RAG search over the vault | **No** | PRD section 1.5 non-goal. `grep` over a file that is deliberately kept short |
| A people directory with typed notes and a projector | **No** | The ledger's `O|` rows already carry prospects. A second entity store is not earned |
| Heartbeat and habits files | **No** | Placeholders even in Glitch, and there is no scheduler here |

### Why the curated layer is the missing piece

Today the brain has raw capture and a derived index, and nothing in between.

`ops-log.md` records everything that happened, append-only, and grows forever.
`.state/index.md` is derived and rebuildable, so it holds no history.
`ge context` injects at most fifteen lines at session start, built from the index and the Brain's Flags.

So there is nowhere for what a founder's toolkit *learns* to accumulate.
Which content angles are used up.
What a mentor said about their positioning.
That their voice reads better when they open with the objection rather than the promise.
That a subject line worked, or that a pillar keeps producing nothing.

Glitch's own line is the right one: the daily logs capture everything, `MEMORY.md` captures what matters, and only the second one loads every session.
Without that layer this is a tool that starts fresh every Monday.
With it, the toolkit that a founder takes home in September is still useful to them in December, which is exactly what the ninety-day promise depends on.

### The file

`growth-engine/memory.md`.
Sole writer: `ge remember`.
Read by: `ge context`, the content engine's refill mode, and any skill that is about to answer a question about a past decision.

It is markdown so the founder can read it, and line-oriented inside each block so `sed` and `awk` can parse it without `jq`.

```markdown
# Memory

Curated. What matters, not everything. The full record is in ops-log.md.
Written by: ge remember. Do not hand-edit inside the marked blocks.

## Decisions
<!-- GE:DECISIONS:START -->
- 2026-09-14 Chose the b2c-ecom snapshot over service, because the booking flow never applied (detail → ops-log.md 2026-09-14)
<!-- GE:DECISIONS:END -->

## What worked
<!-- GE:WORKED:START -->
- 2026-09-29 Opening with the objection outperformed opening with the promise on the first three posts (detail → ops-log.md 2026-09-29)
<!-- GE:WORKED:END -->

## What did not
<!-- GE:DIDNOT:START -->
<!-- GE:DIDNOT:END -->

## Voice notes
<!-- GE:VOICE:START -->
- 2026-09-15 She says "calm" not "soothing", corrected twice during the edit pass (detail → ops-log.md 2026-09-15)
<!-- GE:VOICE:END -->

## Angles used
<!-- GE:ANGLES:START -->
- 2026-09-20 pillar 2, the ingredient-list teardown, pieces 8 and 11 (detail → content-30.md)
<!-- GE:ANGLES:END -->

## Open threads
<!-- GE:THREADS:START -->
<!-- GE:THREADS:END -->

## Notes
Anything below this heading is yours. ge never writes here.
```

**Entry format, one per line, inside a block:**

`- YYYY-MM-DD <text> (detail → <pointer>)`

Slim, with a pointer to where the detail lives.
An entry that needs a paragraph belongs in `ops-log.md`, and this file points at it.

**Budget.** `ge lint` warns above 60 entries or 8 KB, whichever comes first.
A memory that grows without bound stops being curated and becomes a second log.
The warning names the oldest entries in the largest block, and the founder or the skill decides what to drop.

### Managed blocks: how autonomous writes stay safe inside a file a human edits

This is the mechanism that resolves a real tension in the existing design.

Section 02 requires one writer per file.
But founders genuinely do edit `founder-brain.md` and `content-30.md`, and skills genuinely do need to update parts of them.
Today the only way to satisfy both is to rewrite the whole file with a snapshot first, which means a founder's unsaved judgement can be overwritten by a correct-looking regeneration.

Glitch's answer is a byte-exact marker pair, and it is the right one.

**The rule.**
`ge` writes only between `<!-- GE:<NAME>:START -->` and `<!-- GE:<NAME>:END -->`.
Everything outside every marker pair belongs to the founder and is never touched, moved, or reflowed.

**The four hard constraints:**

1. The markers are matched byte-exactly, including the spaces inside the comment. A near-miss is a missing block, not a fuzzy match.
2. If a block's start marker is present and its end marker is not, `ge` writes nothing and exits 1 with a recovery line. A half-marked file is a damaged file and guessing where the block ends is how a founder loses a paragraph.
3. If a block is absent entirely, `ge` appends the whole block, markers included, under its heading. It never inserts a bare entry into unmarked prose.
4. Snapshot first, as everywhere else. If the snapshot cannot be taken the write does not happen.

**Where blocks apply.** `memory.md`, in the six blocks above.
Nothing else adopts markers in version 1.0.
`founder-brain.md` and `content-30.md` keep whole-file rewrite with snapshot-first, because changing their write model mid-build touches five tasks and buys less than it costs.
Section 07's backlog is where that belongs.

### The hold rule: an edit that cannot find its anchor is held, not forced

Glitch's dream applies anchored edits, and an edit whose `old` text is not present verbatim is held rather than blind-written.

Adopt it for `ge remember --amend` and for any future in-place edit.

If the anchor text is not found byte-exactly, `ge` changes nothing, prints what it was looking for and what it found instead, and exits 1 with a recovery line.
It never falls back to appending, and never writes to a best-guess position.

The failure this prevents: a founder reworded a line, a skill later tries to update that line, the anchor misses, and a blind write leaves the file with two contradictory entries and no way to tell which is current.

### CRLF: read tolerantly, write strictly

Windows Home founders run everything under Git Bash, and their text editors will sometimes save a file with carriage returns.

**Reading.** Every `ge` subcommand strips a trailing `\r` before parsing any line of any founder file. A carriage return in `ledger.md` must never turn a valid status into an unknown enum.

**Writing.** `ge` always writes LF, never CRLF, on every platform.

**Shipping.** `.gitattributes` at the repository root now pins `*.sh` and `plugins/growth-engine/bin/ge` to `eol=lf` in the working tree. Without that, `* text=auto` alone normalises to LF inside the repository but converts to CRLF on a Windows checkout, and a carriage return on a shebang gives `bad interpreter: /bin/sh^M`. That failure is invisible on macOS and Linux, so no amount of local testing would have found it.

The pin is scoped to shell entry points rather than applied as a blanket `* text=auto eol=lf`, which is the same discipline Glitch uses in its own root `.gitattributes` and for the same reason: a blanket rule renormalises an entire working tree into one large noisy diff.

Section 03's CI already refuses a carriage return in any shell script. That check guards the repository. This pin guards the founder's checkout, which CI never sees. Both are needed.

### Search memory before answering

A rule for skills, matching Glitch's hard rule.

Before answering a founder's question about a past decision, a past result, or a preference they have already stated, a skill reads `memory.md` first.
It does not answer from what is in the current conversation, because after five weeks most of it is not.

When a skill does look something up and uses it, it says so in one short clause, naming the date: "you decided on the 14th to go with the ecommerce snapshot".
That is for real lookups, not for every glance.

If `memory.md` does not have it, the skill says it does not know rather than inferring. An invented recollection is worse than an admitted gap, and it is the same rule as never inventing proof.

### The new task

Add this to section 02, Phase 2, after `B-06` and before `B-08`. It is numbered `B-10` so no existing task id moves.

---

#### B-10, `ge remember`, the curated memory layer

**Status: NEW.** Ported from the Glitch memory model. Closes the gap that the brain has raw capture and a derived index but nothing that accumulates what the toolkit learns.

**Effort: 0.75d.**

**Depends on:** `B-00` for `schemas/memory.md`, `B-03` for the snapshot ring, `B-04` for the ops-log the entries point at, `B-05` for the table helpers.

**Blocks:** the amended `B-08`, and the content refill behaviour in `C-01`.

**SNAPSHOT CHAIN.** Every mutation runs `ge snapshot memory.md` first. If the snapshot fails the write does not happen. Same fail-closed posture as `B-03`.

**What to do**

1. Create `plugins/growth-engine/scripts/lib/blocks.sh` with the managed-block helpers, carrying the header template from section 06.
   `block_read <file> <name>` prints the lines between the markers, or nothing if the block is absent.
   `block_write <file> <name> <tmpfile>` replaces the block contents byte-exactly between the markers.
   `block_ensure <file> <name> <heading>` appends the heading and an empty marker pair when the block is absent.
   A start marker with no matching end marker exits 1 with a recovery line and writes nothing.
   Every read strips a trailing `\r` before matching, so a Windows editor cannot hide a marker.

2. Add `ge remember <type> "<text>" [--detail <pointer>]` to the dispatcher at `plugins/growth-engine/scripts/ge.sh`.
   Types: `decision`, `worked`, `didnot`, `voice`, `angle`, `thread`, mapping to the six blocks.
   An unknown type exits 1 and prints the six allowed values, matching the enum-error style `B-05` sets.
   Empty text is refused the same way `ge log` refuses it in `B-04`.
   The entry is written as `- YYYY-MM-DD <text> (detail → <pointer>)`, with the date from `lib/date_compat.sh` and the detail clause omitted when no pointer is given.

3. Add `ge remember list [<type>]` printing the current entries, newest first, and `ge remember forget <type> <n>` removing entry `n` as `list` numbers it, snapshotted first.

4. Add `ge remember --amend <type> <n> "<new text>"` using the hold rule: the existing entry text must match byte-exactly or nothing is written.

5. `schemas/memory.md` is written by task `B-00`, not here, because `B-00` is the single owner of the schema set and writes all of them in one pass with one shared five-section shape.
   This task supplies `B-00` with the content: the file format, the six block names, the entry format, the budget, and the rule that everything outside the markers belongs to the founder.
   If `B-00` has already been executed when this task starts, add the eighth file here and update that task's acceptance count from 7 to 8 in the same commit.

6. Teach `ge init` in `B-02` to seed `memory.md` from the template above, with all six blocks present and empty. Seeding it empty at init means no skill ever has to create the file, which removes a whole class of first-write failure.

7. Add the budget warning to `ge lint` in `B-06`: warn above 60 entries or 8 KB, naming the oldest entries in the largest block. Warn only, never fail.

**ACCEPT**

```sh
cd /Users/pmudh/Downloads/Atlanta/launchhouse-atlanta
rm -rf runs/b10 && mkdir -p runs/b10 && cd runs/b10
GE=/Users/pmudh/Documents/GitHub/Atlanta/plugins/growth-engine/bin/ge

sh "$GE" init
grep -c 'GE:.*:START' growth-engine/memory.md          # must print 6
sh "$GE" remember decision "chose ecom snapshot" --detail "ops-log.md 2026-09-14"
sh "$GE" remember voice "says calm not soothing"
sh "$GE" remember list | wc -l                          # must print 2

# the block boundary holds: text outside the markers survives a write
printf '\n## Notes\nmy own note\n' >> growth-engine/memory.md
sh "$GE" remember worked "objection-first openers"
grep -c 'my own note' growth-engine/memory.md           # must print 1

# a half-marked file is refused, not guessed at
sed -i.bak '/GE:VOICE:END/d' growth-engine/memory.md
sh "$GE" remember voice "should not be written"; echo "exit=$?"   # must print exit=1
grep -c 'should not be written' growth-engine/memory.md # must print 0

# the hold rule: a missed anchor writes nothing
sh "$GE" remember --amend decision 1 "new text" ; echo "exit=$?"

# CRLF cannot hide a marker
printf 'x\r\n' >> growth-engine/memory.md
sh "$GE" remember thread "crlf tolerated"; echo "exit=$?"        # must print exit=0
```

Every line above must produce the stated output.
Paste the terminal transcript into the commit body.

**COMMIT**

`B-10: ge remember, the curated memory layer with managed blocks`

---

### What else changes, and where

These are amendments to tasks that already exist. Each is small and each is listed so nothing is discovered later.

| Task | Amendment |
|---|---|
| `B-02`, `ge init` | Seeds `memory.md` with all six blocks present and empty |
| `B-06`, `ge lint` | Adds the memory budget warning, and a marker-integrity check that reports any start marker without its end |
| `B-08`, `ge context` | Reads `memory.md` and includes the newest decision and the newest open thread, inside the existing fifteen-line ceiling. It does not grow the budget; if the ceiling is reached, the anchor verdict and unresolved Flags win, because a founder in the wrong folder needs that before anything else |
| `B-00`, the schema files | Gains `schemas/memory.md` as an eighth file. `B-00` currently writes seven (`brain`, `ledger`, `ops-log`, `index`, `gates`, `receipt`, `ghl-accounts`), and its acceptance counts them, so the count in that task's ACCEPT block moves from 7 to 8 |
| `C-01`, content engine | Refill mode reads the `angles` block and refuses an angle already listed, which is stronger than the current rule of reading the ledger alone, because an angle can be reused across batches without the row status changing |
| `SS-01`, the doctor | Adds one line: memory present, block integrity intact, entry count against budget, with the `PASS or FAIL, evidence, fix` shape every other doctor line uses |
| Section 04, `docs/USING-IT.md` | Gains a section on what the toolkit remembers, how to read it, how to correct it, and the fact that everything under `## Notes` is theirs and is never written to |
| Section 07, definition of done | Gains: memory seeded at init with six blocks, an entry survives a founder editing the same file, and a half-marked file is refused rather than guessed |

### Effort

`B-10` is 0.75 days.
The amendments above are 0.25 days in total, because each is a small addition to a task that is already being written.

**Total added: 1.0 day.** The revised build total moves from 39.2 to **40.2 dev-days**.

`B-10` is now cut position 5 of 9 in section 02's cut order, between the update-drill rehearsal and the status and gate folds.
It is cuttable, unlike the rest of the brain: `B-00` to `B-09` stay on the never-cut list and `B-10` does not join them, because the four systems all still work without it.
What is lost if it goes is that the toolkit stops remembering between sessions, which costs the refill its angle history and costs a founder returning in December everything except the Brain.
