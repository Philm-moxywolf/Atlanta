## Code standards and the commenting requirement

The requirement recorded from the client, in their words, is one sentence: all the code is commented.

That sentence is worthless as written, because every developer already believes their code is commented.
This section turns it into a specification a reviewer can apply in sixty seconds and a validator can apply in two seconds.
The test is not "are there comments".
The test is: **can a competent shell programmer who has never seen this project read a file top to bottom, understand every decision it makes and why, and safely change it, without asking anyone a question?**

Everything below is normative.
Where a rule is machine-checkable, the check is written out in full in section 8 of this Code standards section.
Where it is not, the human question the reviewer asks is written out in full in section 8.4 of this Code standards section.

### How to read this section

Four conventions, stated once, so nothing below needs outside context.

**Paths.** The repository root is the absolute path `/Users/pmudh/Documents/GitHub/Atlanta`, cloned from `https://github.com/Philm-moxywolf/Atlanta`.
Every path written here without a leading slash is relative to that root.
So `scripts/validate.sh` means `/Users/pmudh/Documents/GitHub/Atlanta/scripts/validate.sh`, and `plugins/growth-engine/bin/ge` means `/Users/pmudh/Documents/GitHub/Atlanta/plugins/growth-engine/bin/ge`.
There are two exceptions, both narrow.

A path beginning `./growth-engine/` always means the founder's own output folder inside whatever working directory the founder opened Claude Code in, never anything in this repository.

A path written inside an example script comment, in a fenced code block, is relative to the plugin root `plugins/growth-engine/`, because that is the natural frame for a script that lives there and it is what will actually be typed in the file.
So `assets/ghl/social-planner-template.csv` inside a `# FORMAT:` comment means `/Users/pmudh/Documents/GitHub/Atlanta/plugins/growth-engine/assets/ghl/social-planner-template.csv`, and `schemas/ledger.md` inside a comment means `/Users/pmudh/Documents/GitHub/Atlanta/plugins/growth-engine/schemas/ledger.md`.
Neither of those two files exists yet. Both are created by the build.

**Section numbers.** A bare "section 3.2" or "section 8.1" always means the numbered subsection of this Code standards section, never a section of the PRD or of another part of the delivery plan.
References to the PRD are written out in full as `planning/PRD-growth-engine-v1.md`.

**Line format.** This document is written one sentence per physical line, so that a diff shows exactly which sentence changed.

**Verified state.** Every factual claim below about what the repository currently contains was checked against the working tree on 21 August 2026.
Line counts, file contents and helper names are as of that check.

---

### 0. What this section governs, and the two classes of code

Every executable file in this project falls into exactly one of two classes.
The class decides which rules apply.
Get the class wrong and you either ship a bash-ism to a founder's Windows machine, or you write painfully portable code in a file that only ever runs on one Mac.

**Class F: founder-path code.**
Ships inside `plugins/growth-engine/`, is installed on a founder machine by the marketplace, and may execute on any of the four surfaces (macOS Cowork, macOS desktop Code tab, Windows Pro/Enterprise Cowork, Windows Home desktop Code tab).
The Windows Home Code tab runs Git Bash, which is the runtime floor.
Class F is POSIX sh only, and every rule in this section applies without exception.

**Class R: repo-path code.**
Lives in the repository, runs on the builder's machine and on GitHub Actions, and never reaches a founder.
Class R may use bash and python3, because it already does and rewriting it buys nothing.
Class R still carries a compliant header, still comments why not what, and still follows the naming and error-message rules.
It is exempt only from section 7, the POSIX portability bans.

**Class table. This is the complete list. A file not on this list has no class, and adding a file means adding a row here in the same commit.**

Paths are relative to `/Users/pmudh/Documents/GitHub/Atlanta`.

| Path (relative to the repo root) | Class | Runtime | Notes |
|---|---|---|---|
| `plugins/growth-engine/bin/ge` | F | POSIX sh | Three-line exec shim. Needs the git exec bit. |
| `plugins/growth-engine/scripts/ge.sh` | F | POSIX sh | The dispatcher. |
| `plugins/growth-engine/scripts/lib/paths.sh` | F | POSIX sh | Anchor and parent-walk. Library, never writes. |
| `plugins/growth-engine/scripts/lib/date_compat.sh` | F | POSIX sh | BSD and GNU date. Library, never writes. |
| `plugins/growth-engine/scripts/lib/table.sh` | F | POSIX sh | Ledger and index row helpers. Library, never writes. |
| `tests/run.sh` | F | POSIX sh | Runs on three OS runners in CI, so it is held to the founder floor. |
| `scripts/validate.sh` | R | bash + python3 | Already exists at 312 lines. Section 8 extends it. |
| `scripts/build-folder.sh` | R | bash + python3 | Already exists at 92 lines. |
| `.github/workflows/validate.yml` | R | GitHub Actions | Not a shell script, but the header rule applies as YAML comments. |

Scope notes that belong here so nobody has to hunt for them, and so nobody writes a script for something that was cut.

**What is cut, and therefore has no class and no file.**
The client locked scope on 20 August 2026, and the following are cut.
Where the PRD at `planning/PRD-growth-engine-v1.md` still describes them, the PRD is out of date and this section overrides it.

- The `dm-inbox` skill is cut. Claude never reads the founder's inbox and never drafts DM replies. No skill directory named `dm-inbox` is created under `plugins/growth-engine/skills/`.
- `ge dmgate`, which is PRD task B-07, is cut. The 24-hour-window code is not built, and nothing in this codebase sends a DM.
- `plugins/growth-engine/commands/inbox.md` is cut. It is not created.
- PRD spike section S-04, headed "conversations", at `planning/spike-findings.md` line 119, is cut. It is not run and its PENDING marker is closed as "cut, not required".
- PRD task G2-02 is cut.
- Three GoHighLevel Private Integration Token scopes are no longer requested: `conversations.readonly`, `conversations/message.readonly`, `conversations/message.write`. The scope list requested from a founder is now exactly these seven strings: `socialplanner/post.readonly`, `socialplanner/post.write`, `socialplanner/account.readonly`, `socialplanner/statistics.readonly`, `contacts.readonly`, `contacts.write`, `locations.readonly`.

The identifier `dmgate` is a banned string in every script, checked by the validator addition in section 8.1, so a stale copy-paste from the PRD cannot land silently.

**What is not cut, stated because the word "DM" appears in both lists.**
Comment-to-DM capture and DM qualify-and-book are **in scope**.
They are GoHighLevel workflows, shipped inside the GHL snapshots, and Claude writes the copy that sits inside those workflows as namespaced custom values.
Our code never sends a DM and never reads one; GoHighLevel sends and receives, and the founder reads and replies inside the GoHighLevel app.
That is what removes the Meta 24-hour-window risk from our code.
Because none of it is shell code, none of it appears in the class table above.
It does appear in `plugins/growth-engine/assets/ghl/README.md`, which currently carries `TODO` rows for "Comment-to-DM capture" and "DM qualify and book". Those rows stay and must be filled, not deleted.

**Two skills that are not among the four locked systems but exist in the repository.**

`plugins/growth-engine/skills/growth-plan/` is treated as **in scope**. It is cheap, it is the Sunday deliverable, and it reads the Founder Brain. It will call `ge` like any other skill, so any helper it needs is Class F and every rule in this section applies to it.

`plugins/growth-engine/skills/playbook-export/` is treated as **deferred**, meaning no new script is written for it and no Class F helper is added for it.
This is a default, not a final decision. Whoever owns this section may reverse it.
If it is reversed, the playbook-export helper is Class F and every rule here applies to it unchanged, and a row is added to the class table in the same commit.

---

### 1. The file header

#### 1.1 The template, verbatim

Every script in Class F and Class R opens with exactly this shape, before any other line.

```sh
#!/bin/sh
# <name> — <one line: what this does>
#
# WHY IT EXISTS: <the failure this prevents>
# CALLED BY:     <skill(s)/hook(s)/humans>
# READS:         <files/env>       WRITES: <files it is the ONE writer of>
# POSTURE:       <fail-open|fail-closed> — <one clause why>
# PORTABILITY:   POSIX sh. No bash/python/node/jq. BSD+GNU date via lib/date_compat.sh.
# EVERY ERROR MESSAGE ENDS WITH A RECOVERY LINE ("→ run: ...").
set -u
```

Nothing goes above the shebang.
No blank line between the shebang and the title line.
No licence block, no author name, no date, no decorative rule of hash characters.
Git owns authorship and dates, and a hand-maintained date in a comment is wrong within a week.

#### 1.2 The em dash exception, stated once so nobody re-litigates it

House style bans em dashes and en dashes, and `scripts/validate.sh` hard-fails on them.
The header template above contains an em dash on the title line and another on the POSTURE line.
This is a real collision and it is resolved as follows.

The dash ban applies to founder-**readable** markdown: `README.md`, everything under `docs/`, and every `*.md` under `plugins/`.
This is exactly what `scripts/validate.sh` scans. Its `founder_files()` function, at lines 24 to 29 of that file, reads:

```bash
founder_files() {
  {
    [ -f "$REPO/README.md" ] && echo "$REPO/README.md"
    find "$REPO/docs" "$PLUGIN" -name '*.md' -type f 2>/dev/null
  } | sort
}
```

It globs `-name '*.md'` only, so `.sh` files are outside its reach today, and that is correct rather than an accident.
It also never looks inside `planning/`, so this delivery document is not scanned by it either.
Shell comments are not founder-facing prose.
A founder never opens `paths.sh`.

The exception is narrow and enforced as a whitelist, not a blanket pass:

- An em dash is permitted on **line 2** of a script, in the `# <name> — <one line>` position.
- An em dash is permitted on the **POSTURE** line, in the `<fail-open|fail-closed> — <one clause why>` position.
- An em dash or en dash **anywhere else in any file, including every other comment line, every error string, and every here-document**, is an error.
- Section 8.1 implements exactly that: it scans `.sh` files for `[—–]` and excludes only those two positions.

If anyone later generalises the dash scan across all file types, they must carry that exclusion with them or every script in the repo fails at once.

**Why this document itself contains em dashes.**
Name the objection first: house style bans em dashes, and this document is part of the delivery plan, so it looks like it is breaking its own rule.
Every em dash in this file sits inside a fenced code block or an inline code span, and every one of them is reproducing something that is normative and fixed: the header template, an example header line, the checklist line quoting that template, or the validator regex that matches it.
There is not one em dash in the running prose of this section.
Removing them would specify a header shape that fails the validator written in section 8.1 and contradicts the header template the build brief marks as exact, which is a worse defect than the style deviation.
The two en dashes in this file are both inside the bracket expression `[—–]` in the validator regex, which has to contain an en dash in order to catch one.
If open question 2 in section 9 is resolved by changing the template to `# name: one sentence`, this file loses its em dashes in the same commit and this paragraph is deleted with them.

#### 1.3 Field by field

**Line 1, the shebang.**
Class F: exactly `#!/bin/sh`, with no arguments and no `env`.
Not `#!/usr/bin/env sh`, because `env` adds a lookup for no benefit and Cowork VM images have been inconsistent about it.
Not `#!/bin/bash`, ever, in Class F.
Class R may use `#!/usr/bin/env bash`, which is what the two existing repo scripts already do.

Bad value: `#!/bin/sh -e`.
Setting shell options in the shebang is not portable across all sh implementations and hides the option from anyone grepping for `set -e`.
Set options on their own line.

**Line 2, the title.**
Format: `# <filename> — <one sentence, lower case, no full stop, present tense, says what this file does>`.
The filename is the bare basename with its extension, so a grep for the filename finds the header.
The sentence describes the file's job, not its category.

Good: `# paths.sh — finds the founder's growth-engine folder and reports where it is anchored.`
Bad: `# paths.sh — path utilities.`
"Path utilities" tells the reader nothing they could not guess from the filename, and it is the single most common failing value.
Bad: `# paths.sh — helper functions.`
Bad: `# paths.sh — Handles all path-related logic for the ge CLI system.`
Capitalised, vague, and "handles" is a word that means nothing.

**Line 3.**
A bare `#`.
It separates the title from the fields so the fields read as a block.

**WHY IT EXISTS.**
One or two sentences naming **the failure this file prevents**.
Not what it does, which line 2 already said.
The reader must be able to answer "what breaks if I delete this file" from this field alone.
Wrap onto continuation lines aligned under the first word of the value.

Good:
```
# WHY IT EXISTS: founders open Claude Code in whatever folder is in front of them,
#                so work lands in Downloads one day and Desktop the next and the
#                founder arrives in Atlanta with three partial brains. This file is
#                the single place that decides which folder is the real one.
```
Bad: `# WHY IT EXISTS: to find paths.`
That is a restatement of the title with fewer words.
Bad: `# WHY IT EXISTS: because we need path resolution.`
Circular. "We need it because we need it."
Bad: `# WHY IT EXISTS: cleanliness and separation of concerns.`
An architectural preference is not a failure. Name the failure.

**CALLED BY.**
The literal callers, by path, plus "humans" if a founder or the builder ever types it directly.
If nothing calls it, the file should not exist.
If more than four things call it, say the category and the count.

Good: `# CALLED BY:     scripts/ge.sh (every subcommand sources this first)`
Good: `# CALLED BY:     hooks/hooks.json SessionStart; skills/setup/SKILL.md; humans running "ge check"`
Bad: `# CALLED BY:     various`
Bad: `# CALLED BY:     the CLI`
Which part of the CLI. A reader changing a function signature needs to know exactly what they might break.

**READS and WRITES.**
`READS:` lists files and environment variables the file consumes.
`WRITES:` on the same line lists **only the files this script is the one writer of**.
That is the state-model rule set out in `planning/PRD-growth-engine-v1.md`, stated in four words: one writer per file.
Every state file has exactly one script permitted to write it, and the header is the only place that ownership is recorded.
A library that writes nothing says so in words, because a blank is ambiguous between "nothing" and "I forgot".

Good: `# READS:         $PWD, its parent chain, $HOME, growth-engine/.state/HOME`
Good, continued on the next comment line: `#                WRITES: nothing. A library never writes; ge init owns .state/HOME.`
Good: `# READS:         growth-engine/ledger.md   WRITES: growth-engine/ledger.md (sole writer)`
Bad: `# READS:         files       WRITES: files`
Bad: an empty `WRITES:` on a file that appends to `ops-log.md`.
That is the single most damaging bad value in the header, because the one-writer rule is enforced by reading these lines and nothing else.

**POSTURE.**
Exactly one of `fail-open` or `fail-closed`, then an em dash, then one clause of justification.
These are the postures locked for this project:

| Path | Posture |
|---|---|
| `ge snapshot` before a rewrite | fail-closed. No snapshot means no write. |
| SessionStart `ge context` | fail-open. Missing folder means exit 0, silent. |
| `ge lint` | warn-only. Advice, never a gate. |
| Publish read-back | fail-loud. A missing post id marks the ledger row `failed`. |

A file that contains both postures in different functions states the file default here and tags each divergent function with an inline `# FAIL-CLOSED:` or `# FAIL-OPEN:` comment per section 3.2.
`warn-only` and `fail-loud` are permitted values on the POSTURE line for the two paths named in the table above.

Good: `# POSTURE:       fail-closed — no snapshot means no write, because an irreversible autonomous mistake is the worst outcome we can produce.`
Bad: `# POSTURE:       fail-closed`
No justification. The next person will not know whether the posture was chosen or copied.
Bad: `# POSTURE:       depends`
Then split the file, or state the default and tag the exceptions.

**PORTABILITY.**
Class F: the fixed sentence, copied exactly.
`POSIX sh. No bash/python/node/jq. BSD+GNU date via lib/date_compat.sh.`

One file cannot say that truthfully: `lib/date_compat.sh` itself, which would be pointing at itself.
Its final clause becomes `This file IS the date compatibility layer.`
The validator therefore anchors on the fixed prefix `POSIX sh. No bash/python/node/jq.` and treats the remainder as free text.

Class R: replace the whole value with a sentence naming why the exemption is safe.
`# PORTABILITY:   Repo-only. bash 3.2+ and python3 permitted. Never installed on a founder machine.`

Bad value: silently dropping the line, or writing `# PORTABILITY:   yes`.

**The arrow notice.**
Copied exactly, on every file: `# EVERY ERROR MESSAGE ENDS WITH A RECOVERY LINE ("→ run: ...").`
It is shouty on purpose.
It is the last thing you read before you start writing code that can fail.

**set -u.**
Immediately after the header, on its own line, in every Class F file.
`set -u` turns an unset variable into an error instead of an empty string, which is the difference between `rm -rf "$GE_HOME/snapshots"` deleting a folder and deleting `/snapshots`.

`set -e` is **not** used in Class F.
Its behaviour differs between dash, the various ash builds and Git Bash's bash-as-sh, particularly inside functions, inside `&&` chains, and around command substitution.
Handle every failure explicitly with an `if` or an `|| { ...; }` block instead.
This is itself a decision that must be commented, once, in `ge.sh`, per section 3.1.

`set -o pipefail` is **not POSIX** and is banned in Class F.
Class R already uses it and may keep it.

#### 1.4 A fully worked Class F example

This is `plugins/growth-engine/scripts/lib/paths.sh`, header and enough real body to show the commenting standard in force.
Copy its shape.

```sh
#!/bin/sh
# paths.sh — finds the founder's growth-engine folder and reports where it is anchored.
#
# WHY IT EXISTS: founders open Claude Code in whatever folder is in front of them,
#                so work lands in Downloads one day and Desktop the next, and the
#                founder arrives in Atlanta with three partial brains and no idea
#                which is real. This file is the single place that decides which
#                folder is the real one, so no two subcommands can disagree.
# CALLED BY:     scripts/ge.sh (sourced by every subcommand before it does anything)
# READS:         $PWD and its parent chain, $HOME, growth-engine/.state/HOME
#                WRITES: nothing. A library never writes; "ge init" owns .state/HOME.
# POSTURE:       fail-open — a missing folder returns 1 and prints nothing, because
#                the caller decides whether that is fatal (the hook must stay silent,
#                "ge init" must offer to create it).
# PORTABILITY:   POSIX sh. No bash/python/node/jq. BSD+GNU date via lib/date_compat.sh.
# EVERY ERROR MESSAGE ENDS WITH A RECOVERY LINE ("→ run: ...").
set -u

# ge_find_home: prints the absolute path of the growth-engine folder, or nothing.
# Exit 0 when found, 1 when not. Never writes, never prompts, never calls exit,
# because the SessionStart hook needs silence where "ge init" needs an offer to
# create the folder, and one shared definition of "found" keeps them agreeing.
ge_find_home() {
    # POSIX: sh has no "local", so every variable here is global. The ge_fh_
    # prefix is the namespace. Renaming it without renaming every use will
    # collide with a caller's variable and the failure will look like a bug in
    # the caller, not here.
    ge_fh_dir=$(pwd -P)

    # -P resolves symlinks. macOS puts Desktop and Documents behind iCloud
    # symlinks, so the same folder reached two ways would otherwise compare as
    # two different anchors and the doctor would report a move that never happened.

    while :; do
        if [ -f "$ge_fh_dir/growth-engine/.state/HOME" ]; then
            printf '%s\n' "$ge_fh_dir/growth-engine"
            return 0
        fi

        # POSIX: no readlink -f and no realpath, so the parent comes from
        # dirname rather than stripping the text after the last slash. String
        # stripping mishandles a path containing "//" or a trailing slash, both
        # of which Git Bash produces when it translates a Windows path.
        ge_fh_parent=$(dirname "$ge_fh_dir")

        # dirname of "/" is "/", so this is the only reliable root test. We walk
        # to the root rather than to a fixed depth because a folder nested six
        # levels inside iCloud Drive is normal, not an edge case.
        if [ "$ge_fh_parent" = "$ge_fh_dir" ]; then
            break
        fi
        ge_fh_dir=$ge_fh_parent
    done

    # Last resort. Cowork hands the session a fresh working directory, so a
    # founder who ran "ge init" in Cowork last week has a valid anchor under
    # $HOME and a working directory that shares no ancestor with it. Without
    # this branch that founder is told their work is missing when it is not.
    if [ -f "$HOME/growth-engine/.state/HOME" ]; then
        printf '%s\n' "$HOME/growth-engine"
        return 0
    fi

    return 1
}
```

#### 1.5 A worked Class R example

This is the header to add to the top of the existing `scripts/validate.sh`.

That file currently opens with a shebang and a five-line comment block carrying none of the five required fields.
Verbatim, as it stands today, lines 1 to 8:

```bash
#!/usr/bin/env bash
# validate.sh: the automated check for this repo. Run before every commit.
# CI runs it on every push via .github/workflows/validate.yml.
#
# Errors block a commit. Warnings are things with a deadline attached.
# Founder-facing means README.md, docs/, and everything under plugins/.

set -uo pipefail
```

Note that its existing line 2 already uses a colon rather than an em dash, and reads perfectly well.
That is evidence for the alternative in open question 2 of section 9, not an argument that this file is already compliant. It is not compliant: it has no `WHY IT EXISTS`, no `CALLED BY`, no `READS` or `WRITES`, no `POSTURE`, no `PORTABILITY` and no recovery-line notice.

Replace lines 1 to 8 of `scripts/validate.sh` with the block below.
It reproduces the existing `set -uo pipefail` line unchanged, so nothing after line 8 of the current file moves or changes.
Everything from the current line 9, `export LC_ALL="en_US.UTF-8"`, downward stays exactly as it is.

```sh
#!/usr/bin/env bash
# validate.sh — the automated gate for this repo. Run before every commit.
#
# WHY IT EXISTS: this project has no runtime and no unit tests, so a broken
#                manifest, a bare command a founder cannot type, or a banned
#                dash reaches 130 people before anyone notices. This is the only
#                automated thing standing between a mistake and the cohort.
# CALLED BY:     humans before every commit; .github/workflows/validate.yml on push
# READS:         README.md, docs/, plugins/, .gitignore, git ls-files
#                WRITES: nothing. It prints and sets an exit code.
# POSTURE:       fail-closed — a non-zero exit blocks the commit, because a
#                warning nobody reads is the same as no check at all.
# PORTABILITY:   Repo-only. bash 3.2+ and python3 permitted. Never installed on
#                a founder machine, so the POSIX floor does not apply here.
# EVERY ERROR MESSAGE ENDS WITH A RECOVERY LINE ("→ run: ...").
set -uo pipefail
```

---

### 2. Inline comments: why, not what

#### 2.1 The rule

The code already says what it does.
A comment that repeats it is worse than no comment, because it doubles the maintenance surface and rots into a lie the first time the line changes.

A comment earns its place by answering one of these, and only these:

1. Why this and not the obvious alternative.
2. Why this is safe, or what makes it unsafe to change.
3. What is true about the outside world that forced this shape.
4. What breaks if you remove this line.
5. What this function's contract is: inputs, outputs, exit codes, side effects.

#### 2.2 Density

Every function gets a comment block above it stating its contract: what it prints, what it returns, whether it writes, whether it can exit.
That block is one to four lines. Never a template with empty `@param` fields.

Inside a function, comment the decision points, not the steps.
The working target for Class F: **no unbroken run of more than 15 executable lines without a comment**.
That is a smell threshold, not a quota, and section 8.1 checks it as a warning, never an error.
If a 40-line function has nothing worth commenting, it is probably four functions.

#### 2.3 Five before-and-after pairs, from code this project will actually contain

**Pair 1. Date compatibility between BSD and GNU, in `lib/date_compat.sh`.**

Bad:
```sh
# Convert an ISO timestamp to epoch seconds.
iso_to_epoch() {
    if [ "$GE_DATE_FLAVOUR" = "gnu" ]; then
        date -u -d "$1" +%s
    else
        date -u -j -f '%Y-%m-%dT%H:%M:%SZ' "$1" +%s
    fi
}
```
The comment restates the function name.
The reader still has no idea what `GE_DATE_FLAVOUR` is, why there are two branches, or which machine takes which.

Good:
```sh
# iso_to_epoch: prints epoch seconds for an ISO-8601 UTC timestamp, or prints
# nothing and returns 1. Callers must treat the empty result as "unknown" and
# never as "now", because every consumer of this function is doing date maths
# that decides whether a founder's work is stale.
#
# The two branches are not a style choice. macOS ships BSD date, where -d means
# "daylight saving" and -j -f is the only parse path; Git Bash on Windows ships
# GNU date, where -d is the parse flag and -j does not exist. Calling date
# directly anywhere else in this codebase produces a stamp that works on the
# builder's Mac and fails silently on a founder's Windows Home machine, which is
# roughly half the cohort. GE_DATE_FLAVOUR is probed once per process in
# ge_date_probe below, not per call, because this runs in a loop over the ledger.
iso_to_epoch() {
```
The reader now knows the constraint, the cost of ignoring it, who is affected, and why the probe is hoisted.

**Pair 2. The snapshot ring, in `ge.sh`, `ge snapshot`.**

Bad:
```sh
# Delete old snapshots and keep the newest 10.
ls "$GE_SNAP_DIR/$ge_snap_base".* | sort | head -n -10 | while read -r old; do
    rm -f "$old"
done
```
Restates the code, and the code is also wrong: `head -n -10` is a GNU extension, and the unquoted `read` loses trailing whitespace.

Good:
```sh
# The ring is capped at 10 per file. Ten is not arbitrary: it is roughly one
# working session of edits, which is the window inside which a founder realises
# a skill overwrote something they wanted. Beyond that they will not recognise
# which stamp to restore, so more copies buy confusion, not safety.
#
# Pruning sorts by filename, not by mtime. The stamp is a fixed-width UTC string
# produced by utc_stamp, so lexical order is chronological order. mtime is not
# usable here: a founder syncing the folder through iCloud or OneDrive gets the
# whole ring restamped with today's date, and we would prune the original.
```
The reader now knows why 10, why filename order, and the specific sync scenario that makes the obvious approach destroy the very file it is meant to protect.

**Pair 3. The append-only log, in `ge.sh`, `ge log`.**

Bad:
```sh
# Append the entry to ops-log.md.
printf -- '- %s %s: %s\n' "$ge_log_time" "$ge_log_type" "$ge_log_text" >> "$GE_HOME/ops-log.md"
```

Good:
```sh
# Append-only is a property of this line, not a promise in a document. The entry
# is appended with >> and nothing in this codebase ever reads ops-log.md into
# memory and writes it back. A read-modify-write here would mean a crash midway
# through leaves the founder with a truncated memory of their own decisions, and
# they would not know which entries were lost.
#
# ge check compares the byte count against the watermark in .state/log.bytes and
# reports FAIL if the file has shrunk. That check only means something while this
# stays a pure append. If you ever need to rewrite this file, you are changing
# the guarantee and the doctor's log-integrity check must change with it.
```
The reader now knows that a refactor to a temp-file-and-move pattern, which looks safer in isolation, silently invalidates a check in a different file.

**Pair 4. Path resolution walking parent directories, in `lib/paths.sh`.**

Bad:
```sh
# Loop up through the parent directories looking for the folder.
while :; do
    ...
    ge_fh_parent=$(dirname "$ge_fh_dir")
    [ "$ge_fh_parent" = "$ge_fh_dir" ] && break
    ge_fh_dir=$ge_fh_parent
done
```
Three comments' worth of non-obvious behaviour and the one comment present explains the only obvious part.

Good: the version in section 1.4, which comments three separate things.
Why `pwd -P` (iCloud symlinks would make one folder look like two).
Why `dirname` rather than text stripping (Git Bash emits doubled and trailing slashes).
Why comparing parent to self is the root test, and why the walk has no depth limit.

**Pair 5. Enum validation, in `ge.sh`, `ge ledger set-content`.**

Bad:
```sh
# Check the status is valid.
case "$ge_led_status" in
    draft|approved|scheduled|posted|failed|archived) ;;
    *) printf 'bad status\n' >&2; exit 1 ;;
esac
```

Good:
```sh
# The status enum is the contract in schemas/ledger.md and it is validated here
# rather than at read time, because ledger.md is the only machine-readable record
# of what has been published. One typo written into a row means "ge index" reports
# a piece as unposted forever and the founder republishes it to a live audience.
#
# A case statement, not a grep against a list: grep would match "post" inside
# "posted" without anchors, and anchoring in a portable way is more fragile than
# spelling the six values out. The six values are duplicated from schemas/ledger.md
# on purpose; "ge lint" compares the two and fails if they drift.
#
# FAIL-CLOSED: an unrecognised value exits 1. Do not coerce to "draft". A silent
# coercion turns a founder's typo into a wrong row that nobody can find later.
case "$ge_led_status" in
    draft|approved|scheduled|posted|failed|archived) ;;
    *)
        printf 'ge ledger: "%s" is not a status.\n' "$ge_led_status" >&2
        printf '  allowed: draft approved scheduled posted failed archived\n' >&2
        printf '  → run: ge ledger list C   to see the rows and their current status\n' >&2
        exit 1
        ;;
esac
```
The reader now knows the blast radius of a bad value, why the implementation looks clumsy, that the duplication is deliberate and guarded, and that coercion is forbidden.

---

### 3. What must always be commented

These five categories are mandatory.
Each has a tag so a human or a grep can find every instance.
The tag goes at the start of the comment, in capitals, followed by a colon.

#### 3.1 `# POSIX:` every non-obvious POSIX workaround

Any place where the code is uglier than it needs to be because bash is not available.
Without the tag, the next contributor "cleans it up" into a bash-ism and breaks Windows Home, and the failure will not surface until a founder is sitting in front of it.

```sh
# POSIX: sh has no arrays. The candidate list is a newline-separated string and
# IFS is set for exactly this read loop, then restored, because leaving IFS
# changed corrupts every unquoted expansion in whatever called us.
```

```sh
# POSIX: no "local". Every variable in this function is global, namespaced with
# the ge_snap_ prefix. Adding a variable here means adding the prefix.
```

Required on at minimum: the no-`local` prefix scheme, the no-array workaround, the no-`readlink -f` path handling, the no-`pipefail` failure handling, the `printf` instead of `echo` choice, and the `set -e` omission decision (commented once in `ge.sh`, referenced by the others).

#### 3.2 `# FAIL-CLOSED:` and `# FAIL-OPEN:` every posture decision at the point of decision

The header states the file's default.
Every branch that implements or diverges from it gets the tag on the line above the branch.
A posture that only exists in a header is a posture nobody enforces.

```sh
# FAIL-CLOSED: if the snapshot copy did not land, we do not write. The founder
# keeps a stale file, which is recoverable. A write with no undo is not.
if [ ! -f "$ge_snap_dest" ]; then
```

```sh
# FAIL-OPEN: no growth-engine folder means this is not a Launchhouse session.
# Exit 0 and print nothing. A hook that prints an error on every unrelated
# session teaches the founder to ignore everything this tool says.
ge_find_home >/dev/null 2>&1 || exit 0
```

#### 3.3 `# SWALLOWED:` every place an error is deliberately discarded

This is the rule most likely to catch a real bug in review.
Every `2>/dev/null`, every `|| true`, every `|| :` on a Class F path carries a `# SWALLOWED:` comment on the same line or the line above, saying **what error is being discarded and why discarding it is correct**.

Section 8.1 enforces the pairing mechanically.
There is no exemption. If you cannot write the sentence, you do not understand the failure you are hiding.

```sh
# SWALLOWED: mkdir -p reports EEXIST on some Windows filesystems even when it
# succeeded. We test for the directory on the next line instead of trusting the
# exit code, so the real failure is still caught.
mkdir -p "$GE_SNAP_DIR" 2>/dev/null || true
if [ ! -d "$GE_SNAP_DIR" ]; then
```

```sh
# SWALLOWED: rm on a snapshot that another process already pruned is not a
# problem, and the ring is rebuilt from the directory listing on the next run.
rm -f "$ge_snap_old" 2>/dev/null || true
```

Bad, and a review rejection:
```sh
cp "$ge_src" "$ge_dest" 2>/dev/null || true
```
That is the fail-closed snapshot copy with its failure hidden. The undo guarantee is gone and nothing says so.

#### 3.4 `# FORMAT:` every assumption about external data

Anywhere the code depends on the shape of something we do not control, the assumption is written down next to the code, with the source and the date it was verified.
When the external thing changes, the person debugging finds the assumption in seconds instead of inferring it from a regex.

Mandatory on at minimum:

- The GoHighLevel Social Planner CSV header row, which is a captured fixture, not a guess.
- Any GHL MCP response field the code reads, above all the post id used for publish read-back.
- Any Apollo MCP response field the code reads.
- The ISO-8601 timestamp shape accepted by `iso_to_epoch`.
- Every `ledger.md` row shape and field count.
- The `ops-log.md` day-header and entry shapes.
- The `index.md` table shape.

```sh
# FORMAT: the Social Planner import header is captured verbatim in
# assets/ghl/social-planner-template.csv, exported from a live GHL location on
# 2026-08-19. It is compared byte for byte, not parsed. GHL has changed this
# header before without notice, and a near-miss import silently drops columns
# rather than erroring, so an exact compare is the only honest check.
```

```sh
# FORMAT: a ledger content row is 8 pipe-separated fields:
# C|id|pillar|format|lane|status|ghl_post_id|scheduled_for
# Missing values are a literal "-", never empty, because an empty field makes
# the field count ambiguous when the row is cut and the count is how we detect
# corruption.
```

#### 3.5 `# SCAR:` defensive code that exists because of a specific past failure

The tag names the failure, the date, and what it cost.
A scar comment is the only thing that stops a future reader deleting a guard that looks redundant.

Two worked examples follow. Their status in the repository today differs, and the difference matters.

The first scar is **already fixed in the repository**. `/Users/pmudh/Documents/GitHub/Atlanta/.gitignore` carries `/growth-engine/` with the leading slash, and already carries a plain-English comment explaining why. `scripts/validate.sh` re-proves it in its Hygiene section, at lines 277 to 284, which fails on an unanchored `growth-engine/` and passes on the anchored form. When that comment is next touched, add the `# SCAR:` tag and the date so a grep finds it.

The second scar was **fixed on 20 August 2026**. `/Users/pmudh/Documents/GitHub/Atlanta/.gitattributes` now carries `*.sh text eol=lf` and `plugins/growth-engine/bin/ge text eol=lf` beneath the original `* text=auto`, with the reasoning in a comment above them. Verify it with `git check-attr text eol -- scripts/validate.sh`, which must print `text: set` and `eol: lf`. The pin is scoped to shell entry points rather than applied as a blanket `* text=auto eol=lf`, because a blanket rule renormalises an entire working tree into one large noisy diff. The example below is the comment that shipped.

```sh
# SCAR: on 2026-08-18 the .gitignore pattern "growth-engine/" was unanchored and
# also matched plugins/growth-engine/, which silently excluded every skill and
# command from the repository. Nothing failed loudly; the plugin simply installed
# empty. The leading slash is the fix and this check re-proves it on every run.
```

```sh
# SCAR: .gitattributes carried only "* text=auto". A Windows checkout with
# core.autocrlf=true rewrote every .sh file with CRLF endings, and Git Bash then
# fails with "bad interpreter: /bin/sh^M", which reads to a founder as a broken
# install. "*.sh text eol=lf" and "bin/ge text eol=lf" are the fix. Do not
# relax them.
```

A scar comment without a date and a named failure is not a scar comment, it is a superstition.

---

### 4. What must never appear

Each of these is a review rejection.
Where a machine check exists, it is in section 8.1.

**Commented-out code.**
Git has every version of every line.
Dead code in a comment is a note that says "someone was unsure", with no way to tell whether it was unsure last week or last year.
Delete it. If it matters, the commit message says why it was removed.

**A `TODO` without an owner, a date and a task id.**
The exact required format is:
```sh
# TODO(philip, 2026-09-01, C-02): swap this fixture for the exported header row.
```
Owner is a first name, lower case. Date is the date by which it is resolved, in `YYYY-MM-DD`. Task id is an existing id from either `planning/PRD-growth-engine-v1.md` or the build steps section of this delivery plan, in the shape `B-03` or `C-02` or `G-01`, never a new id invented on the spot.
Anything else fails the validator.
`FIXME`, `XXX`, `HACK` and `NOTE:` as a to-do marker are all banned outright; there is one marker and it is `TODO` in that exact shape.

The repository currently carries **10** untagged `TODO` markers, and every one of them needs this treatment or deletion before the toolkit freeze on Thursday 3 September 2026.
They are not in scripts. They are in two markdown files:

- `plugins/growth-engine/assets/ghl/README.md`, six rows, one per snapshot share link: B2B lead follow-up, B2B discovery booking, B2B proposal chase, B2C comment-to-DM capture, B2C DM qualify and book, B2C review request.
- `plugins/growth-engine/assets/forms/README.md`, four rows: three gate form links and one tracking sheet link.

`scripts/validate.sh` already warns on these, at lines 191 to 194, with the message "asset placeholders still open (six GHL share links, three form links, tracking sheet)".
That count of six plus three plus one is the same 10.
Because they are markdown under `assets/`, the script-level `TODO` check in section 8.1 does not see them. Section 9 open question 4 carries the decision about whether to extend the rule to `plugins/**/*.md`.

**Clever one-liners.**
Defined concretely so this is not a taste argument:

- A pipeline with four or more stages on one line. Split it, name the intermediate, comment the reason.
- Nested command substitution two or more deep.
- A `sed` invocation with more than two expressions, or any `sed` doing something a `case` statement would do more legibly.
- `awk` on a Class F path at all, unless it is a single field extraction with a comment saying why `cut` was not enough. `awk` versions differ between macOS and Git Bash more than people expect.
- Any use of `${var%%...}` and `${var##...}` chained together without a comment showing an example input and output.

If a line takes more than ten seconds to read, it goes on three lines with a comment.
The audience for this code includes whoever is fixing it at 11pm on 24 September in the fix window.

**Abbreviations.**
Section 6.4 of this Code standards section carries the banned list and the replacement for each one. Section 6.3 is a different list; it covers variable casing and the function-prefix scheme.

**Any comment that restates the line beneath it.**
`# increment the counter` above `count=$((count + 1))` is noise.
It trains the reader to skip comments, which means they skip the one comment in the file that mattered.

**Also banned, for completeness.**

- ASCII art, banner boxes, and decorative rules of hash characters inside scripts. The `# ---- section ----` divider style used in `validate.sh` is permitted in Class R only, where it already exists and aids a 312-line file.
- Author names, email addresses, or dates in comments other than in a `TODO(...)` or `# SCAR:` tag.
- Emoji anywhere in a script.
- Em dashes and en dashes outside the two whitelisted header positions in section 1.2.
- `set -x` left enabled.
- Debug `printf` or `echo` calls that are commented out rather than deleted.
- A `# shellcheck disable=SCxxxx` without a reason on the same line or the line above. The reason is the point; the suppression is just the mechanism.
- Marketing words, in comments as much as in prose. `supercharge`, `unlock`, `revolutionary`, `seamless`, `leverage`, `effortless`, `cutting-edge`, `game changer`, `turnkey`, `best-in-class`. A comment that says a function "seamlessly handles" anything says nothing.

---

### 5. Error messages

#### 5.1 The format

Every founder-visible failure is written to **stderr** and has this exact shape.

```
<command>: <what failed, plain, present tense, no blame>
  <evidence: the exact value, path or count that was observed>
  → run: <one command that fixes it, copy-pasteable, complete>
```

Rules that make it enforceable:

1. Line 1 starts with the command name as the founder typed it (`ge snapshot`, `ge ledger`), then a colon and a space.
2. Line 1 states the failure in plain words. No error codes, no function names, no stack context.
3. Line 2 onward is the evidence: what was actually observed. Two-space indent. The founder must be able to see for themselves that the tool is right. This is the "verify, don't assert" rule applied to failure.
4. The last line is the recovery. It begins with `  → run: ` and contains exactly one command.
5. The recovery command must actually resolve the failure. A recovery that just re-runs the failing command is not a recovery.
6. If a command cannot be given, the recovery is a named human action, still after the arrow, still one action. `  → run: /growth-engine:doctor` is the standard fallback, and after two failed attempts the fallback is the Slack channel.
7. Slash commands inside a recovery line are always namespaced, `/growth-engine:doctor`, never bare. A bare `/doctor` resolves to nothing when a founder types it. The existing bare-command check in `validate.sh` only scans markdown, so section 8.1 extends it to `.sh` files.
8. No exclamation marks. No "please". No "Oops". No "Sorry". No capitalised ERROR prefix. No blame directed at the founder: the tool failed to find something, the founder did not fail.
9. House style applies. No em dashes, no en dashes, no marketing words, short sentences.
10. Never echo a token, a PIT value, or any part of one. A masked length is acceptable evidence, the value never is.

#### 5.2 Exit codes

| Code | Meaning |
|---|---|
| 0 | Success, or a fail-open path that declined to act and printed nothing. |
| 1 | The operation was refused or failed. A recovery line was printed. |
| 2 | Usage error: wrong arguments, unknown subcommand. Usage text printed, plus a recovery line. |
| 3 | The environment cannot support the operation: unwritable folder, missing anchor. Recovery printed. |

`ge lint` is warn-only and exits 0 even when it reports problems, because it is advice.
`ge context --hook` exits 0 in every circumstance, including internal failure, because a broken hook must never wedge a session.

#### 5.3 Six real examples

**Missing folder.**
```
ge snapshot: no growth-engine folder here or in any folder above this one.
  looked in: /Users/sam/Downloads and 3 parent folders, and /Users/sam
  → run: ge init   creates the folder here and anchors it
```

**Missing brain.**
```
ge lint: founder-brain.md does not exist yet, so there is nothing to check.
  folder: /Users/sam/Documents/Launchhouse/growth-engine
  files present: content-30.md, ops-log.md, ledger.md
  → run: /growth-engine:brain   builds the Founder Brain, which everything else reads
```

**Failed snapshot. This one is fail-closed, so it says what did not happen.**
```
ge snapshot: could not copy founder-brain.md, so nothing has been written.
  target: /Users/sam/Documents/Launchhouse/growth-engine/.state/snapshots
  the folder is not writable by this user
  your founder-brain.md is unchanged and safe
  → run: /growth-engine:doctor   checks folder permissions and prints the fix
```
The third evidence line exists because a founder reading "could not copy" assumes they have lost something.
Telling them nothing was written is the difference between a support ticket and no support ticket.

**Bad enum.**
```
ge ledger: "posted_ok" is not a status.
  allowed: draft approved scheduled posted failed archived
  row: C|014|2|carousel|media|posted_ok|-|-
  → run: ge ledger set-content 014 status posted
```

**Unreachable API.**
```
ge check: the GoHighLevel read probe did not come back.
  probe: socialmediaposting get-account, no response in 20 seconds
  this is a connection problem, not a problem with your content
  → run: /growth-engine:doctor   re-tests the connection and shows the reconnect steps
```

**Stale token.**
```
ge check: your GoHighLevel token is 84 days old.
  created: 2026-06-29, recorded in .state/receipt.md
  HighLevel expires these at 90 days, so this stops working on 2026-09-27
  nothing is broken yet
  → run: /growth-engine:connect   creates a new token and records the new date
```
Note that this one names the exact expiry date rather than saying "soon", and says nothing is broken yet, so a founder does not stop what they are doing.

#### 5.4 The arrow character

`→` is U+2192, not a dash and not affected by the dash ban.

One open item: it must be confirmed to render correctly in the Windows Home Git Bash console.

Spike section S-06, headed "DECISION GATE B: hooks and the bin floor", lives at `planning/spike-findings.md` line 188 and is still marked PENDING.
It already puts a human in front of the exact surface that matters, because its third receipt block is "Windows Home, desktop Code tab, Git Bash".
It does not currently ask about glyph rendering, so add one line to that third block before the spike is run:

```
  arrow glyph: does "→ run: x" print as an arrow, or as mojibake?   arrow / mojibake
```

If it renders as mojibake there, the whole codebase switches to the ASCII `-> run: ` and the recovery-line check in the validator block in section 8.1 switches with it, changing `grep -q '→ run: '` to `grep -q -- '-> run: '`.
Decide this once, at S-06, and record the answer in `planning/spike-findings.md`.
Do not let two forms coexist.

---

### 6. Naming

#### 6.1 Subcommands

The pattern is `ge <verb>` for a whole-brain operation and `ge <noun> <verb>` where a noun owns several operations.
Verbs are plain English and imperative.
The complete set, which matches the state model's one-writer-per-file rule:

```
ge help
ge init
ge snapshot <file>
ge restore <file> [stamp]
ge undo
ge log <decision|result|blocker|note> <text>
ge ledger add-content | set-content | add-outreach | set-outreach | list
ge index
ge lint
ge context [--hook]
ge check
```

`ge dmgate` is cut and must not appear.

Rules:
- No abbreviated subcommands and no aliases. One name per operation. Two names means two things to document and two things a founder can get wrong.
- No flags where a subcommand is clearer. `ge undo` rather than `ge restore --latest`.
- The dispatcher's subcommands, as at the locked scope: `init`, `snapshot`, `restore`, `undo`, `log`, `ledger`, `index`, `lint`, `context`, `check`, `receipt`, `accounts`, `remember`. `ge remember` is the memory layer added on 20 August and is specified in section 08.
- Compound sub-subcommands are hyphenated and lower case: `add-content`, not `addContent` or `add_content`.
- Every subcommand prints evidence of what it did on success, not just silence, except `ge context --hook` which is silent by design.

#### 6.2 Files and functions

Files: lower case, one word where possible, `.sh` extension, underscore only where two words are genuinely needed.
`paths.sh`, `table.sh`, `date_compat.sh`.
Not `utils.sh`, `helpers.sh`, `common.sh`, `misc.sh`. A file named for a category rather than a job becomes the place things go to hide.

Functions: `ge_<area>_<verb>`, all lower case, underscore separated.
`ge_find_home`, `ge_snapshot_prune`, `ge_ledger_validate_status`, `ge_date_probe`.
The `ge_` prefix is not decoration: sh has a single flat function namespace, and these files are sourced into a shell that may already have the founder's own functions in it.

#### 6.3 Variables in sh

- `UPPER_SNAKE` for script-scope constants and configuration that is set once and read everywhere: `GE_HOME`, `GE_SNAP_DIR`, `GE_DATE_FLAVOUR`, `GE_RING_MAX`.
- `lower_snake` with a function prefix for anything scoped to a function, because POSIX sh has no `local`: `ge_fh_dir`, `ge_snap_dest`, `ge_led_status`.
- Every variable expansion is double-quoted unless there is a comment on the line saying why word splitting is wanted. There is almost never a good reason.
- Braces on expansion whenever the variable is adjacent to other characters: `"${ge_snap_base}.${ge_stamp}"`.
- No single-letter names. Not even `i`. `ge_ring_position` costs nothing to type and everything to omit at 11pm.
- No leading underscore. It reads as "private", sh has no private, and it invites people to believe in a scope that does not exist.
- Never shadow or reuse a name across functions in a sourced library. That is what the prefix prevents.

#### 6.4 Banned abbreviations, with replacements

| Banned | Write instead |
|---|---|
| `cfg`, `conf` | `config` |
| `tmpl` | `template` |
| `msg` | `message` |
| `idx` | `index` |
| `ctx` | `context` |
| `snap` in prose or a public name | `snapshot`. The `ge_snap_` variable prefix is the one permitted use, because it is a namespace token and is documented as such. |
| `fn`, `func` | `function`, or just name the thing |
| `res`, `ret` | `result`, or name what the result is |
| `val` | `value`, or name what the value is |
| `cnt`, `num` | `count` |
| `ts` | `timestamp` |
| `str` | drop it, name the content |
| `tmp` as a name | `scratch_path`, or name what is in it. `TMPDIR` the environment variable is fine. |
| `usr` | `user` |
| `dest`, `src` | permitted. They are the standard vocabulary of file copying and reading `source_path` and `destination_path` in a `cp` line is worse. |

Permitted because they are the domain's real words, not shortenings: `id`, `csv`, `url`, `api`, `utc`, `iso`, `cwd`, `dir`, `ghl`, `pit`, `mcp`, `b2b`, `b2c`, `dm`, `icp`.

---

### 7. POSIX portability rules

Every ban below applies to Class F.
Every one of them is a real difference between the shell on the builder's Mac and Git Bash on a founder's Windows Home machine, or between BSD and GNU userland.
The test column is what you actually run to prove compliance.

| Banned | Why it breaks | Portable idiom | How to test |
|---|---|---|---|
| Arrays: `arr=(a b)`, `${arr[@]}`, `${#arr[@]}` | Not in POSIX sh. `dash` and other `/bin/sh` targets fail to parse the file at all, so the failure is total, not partial. | A newline-separated string plus a `while IFS= read -r line` loop, or the positional parameters via `set -- a b c` and `"$@"`. | `dash -n file.sh`, and `checkbashisms file.sh` |
| `[[ ... ]]` | A bash keyword. In sh it is parsed as a command named `[[` and fails at runtime, sometimes only on the branch nobody tested. | `[ ... ]` with explicit quoting. For pattern matching use `case ... in pattern) ;; esac`, which is more portable and more readable than `[[ $x == pat* ]]`. | `checkbashisms`, `shellcheck -s sh` |
| `local` | Not POSIX. Widely implemented, differently: some shells make `local x=$(cmd)` swallow the command's exit status. | Prefix every function variable with a per-function namespace, as in section 6.3, and comment the prefix with a `# POSIX:` tag. If a specific function genuinely needs `local`, it needs a `# POSIX:` comment naming the shells verified and the reason. Default answer is no. | `shellcheck -s sh` flags it (SC3043) |
| `echo -e`, `echo -n` | The behaviour of `echo` with flags and backslashes is explicitly unspecified in POSIX and differs between `/bin/sh` on macOS and Git Bash. | `printf`. Always with a literal format string and the data as arguments: `printf '%s\n' "$value"`. Never `printf "$value"`, which makes a `%` in the founder's own text a format bug. | Grep for `echo -`; `shellcheck` SC2039/SC3037 |
| `$(( ))` pitfalls | Arithmetic itself is POSIX and fine. The traps: a variable holding an empty string makes `$((x + 1))` an error under `set -u` in some shells and silently 1 in others; a value with a leading zero is read as octal, so an eight or a nine in a zero-padded number is a syntax error; and `$(( ))` cannot do decimals at all. | Default the variable before use (`ge_count=${ge_count:-0}`), strip leading zeros before arithmetic on any value that came from a file or an API, and never do currency or fractional maths in sh. | Golden test in `tests/run.sh` with the inputs `""`, `"08"`, `"09"` |
| Process substitution: `<(cmd)`, `>(cmd)` | Bash only, needs `/dev/fd`. Fails on sh, and fails differently on Windows filesystems. | A pipeline, or an explicit scratch file created with `mktemp` and removed by a `trap`. | `checkbashisms` |
| `mapfile`, `readarray` | Bash 4 only. macOS ships bash 3.2, so these fail even on bash there. | `while IFS= read -r line; do ... done < file`. Note that a final line with no newline is not read by this loop, which is itself a `# FORMAT:` assumption worth stating. | `checkbashisms`, `shellcheck -s sh` |
| `sed -i` with no backup suffix | GNU accepts `sed -i`. BSD requires `sed -i ''`. The forms are mutually incompatible, and on BSD the GNU form silently eats the next argument as the suffix, mangling the command. | Do not edit in place. Write to a scratch file and move it over: `sed 's/a/b/' "$file" > "$scratch" && mv "$scratch" "$file"`. This is also safer, because a failed sed leaves the original intact. | Grep for `sed -i` in section 8.1 |
| `readlink -f`, `realpath` | `readlink -f` is GNU. macOS `readlink` has no `-f`. `realpath` is absent from stock macOS. | `cd "$dir" 2>/dev/null && pwd -P` in a subshell, or `dirname` and `basename` which are both POSIX. Section 1.4 shows the pattern. | Grep; run the golden path tests on a macOS runner |
| BSD versus GNU `date` | The single largest split. BSD: `date -u -j -f '<informat>' '<value>' '+%s'` to parse, `date -u -r <epoch> '+%F'` to format from epoch. GNU: `date -u -d '<value>' '+%s'` to parse, `date -u -d "@<epoch>" '+%F'` to format. `-d` means daylight-saving on BSD, so the GNU form does not error on BSD, it produces a wrong answer. | Never call `date` outside `lib/date_compat.sh`. That file probes once with a known-good value and sets `GE_DATE_FLAVOUR`, then exposes `now_epoch`, `iso_to_epoch` and `utc_stamp`. Everything else calls those. | `tests/run.sh` runs the fixture table on both branches by forcing `GE_DATE_FLAVOUR`, and CI runs it on macOS, Ubuntu and Windows |
| `stat` for size or mtime | Completely incompatible: GNU is `stat -c %s`, BSD is `stat -f %z`. `index.md` needs a bytes column and a modified column, so this will come up. | Bytes: `wc -c < "$file"` then strip whitespace, because BSD `wc` pads its output. Modified time: take it from the snapshot stamp or from `ls`, or store it yourself. Do not shell out to `stat`. | Grep for `stat `; golden index fixture compared on all three runners |
| `source file` | Bash spelling. | `. file`, with a space after the dot, and quote the path. | `checkbashisms` |
| `function name() {` | Bash spelling. | `name() {` | `checkbashisms` |
| `==` inside `[ ]` | Bash extension. POSIX `test` defines `=`. | `[ "$a" = "$b" ]` | `shellcheck -s sh` (SC3014) |
| `+=` for string or array append | Bash only. | `value="$value$more"` | `checkbashisms` |
| `${var,,}`, `${var^^}` case conversion | Bash 4. Absent on macOS bash 3.2 and on sh. | `tr '[:upper:]' '[:lower:]'`, in a command substitution. | `checkbashisms` |
| `${!var}` indirect expansion | Bash only. | Restructure. If you need indirection in sh you have a design problem, not a syntax problem. | `checkbashisms` |
| `read -a`, `read -p`, `read -s` | All bash flags. POSIX `read` takes `-r` and variable names only. `-s` matters here: there is no portable silent read, which is one reason tokens are never read from a prompt in our code. | `read -r` plus `IFS` for splitting. For secrets, do not prompt from a shell script at all. There are two sanctioned routes and neither goes through `read`: the founder types the token into the masked userConfig prompt the plugin client renders, or the founder opens the file `${CLAUDE_PLUGIN_DATA}/ghl.env`, mode 600, in TextEdit or Notepad and replaces `GHL_PIT=PASTE_TOKEN_HERE` and `GHL_LOCATION_ID=PASTE_LOCATION_ID_HERE` by hand. Either way the token never enters the conversation and no script ever echoes it. A masked length is acceptable evidence in an error message; the value never is. | `shellcheck -s sh` |
| `grep -P` | PCRE, not present in BSD grep. | `grep -E` with an ERE, or restructure with `case`. | Grep for `grep -P` |
| `seq` | Not POSIX and absent in minimal environments. | A `while` loop with `$(( ))`, or `set --` positional parameters. | `checkbashisms` |
| `let`, `((...))` as a statement | Bash. | `ge_count=$((ge_count + 1))` | `checkbashisms` |
| `which` | Not POSIX; output and exit codes vary. | `command -v name >/dev/null 2>&1` | `shellcheck` (SC2230) |
| `head -n -N`, `tail -n -N` with a negative count | GNU extension. BSD `head` rejects it. | Count the lines first with `wc -l`, compute the positive number, then use `head -n "$n"`. `tail -n +N` (plus sign) is POSIX and is fine. | Grep for `-n -` |
| `find -printf`, `find -maxdepth` beyond POSIX | `-printf` is GNU only. `-maxdepth` is widely present but not POSIX; it is permitted with a `# POSIX:` comment noting the exception, because every target we support has it. | `find ... -exec` or `find ... | while read`. Note filenames with spaces: the founder's folder is under "My Documents" on Windows. | `checkbashisms`; a test fixture with a space in the path |
| `mktemp` with no template | BSD and GNU differ on defaults and on `-t`. | `mktemp "${TMPDIR:-/tmp}/ge.XXXXXX"` with an explicit template, and a `trap 'rm -f "$scratch"' EXIT INT TERM` on the next line. | Run on macOS and on Git Bash |
| CRLF line endings in any `.sh` file or `bin/ge` | Git Bash executes `#!/bin/sh\r` and reports `bad interpreter: /bin/sh^M`, which a founder reads as a broken install. Fixed on 20 August 2026: `.gitattributes` now pins `*.sh` and `plugins/growth-engine/bin/ge` to `eol=lf`, confirmed with `git check-attr`. | Already applied. Keep the pin, and note the pattern for `bin/ge` must carry its full path, because a pattern containing a slash is anchored to the directory holding the `.gitattributes` file. Section 8.1 also checks the working tree. | `grep -lU $'\r' ` over the script set; the CI Windows runner |
| Missing exec bit on `bin/ge` | Git records mode 100755 or 100644. A file committed at 644 is not executable on macOS or Linux, and the PATH entry silently does nothing. | `git update-index --chmod=+x plugins/growth-engine/bin/ge` | `git ls-files -s` mode check in section 8.1 |
| `set -e` | Not banned by POSIX, banned by us. Its behaviour inside functions, inside `&&` chains and around command substitution differs enough between dash, macOS sh and Git Bash that code relying on it is not portable in practice. | Handle each failure explicitly: `if ! cmd; then ...; fi`, or `cmd || { message; exit 1; }`. Comment the omission once in `ge.sh` with a `# POSIX:` tag. | Human review |
| `set -o pipefail` | Not POSIX. | Restructure so the failing stage is the last one, or capture the intermediate to a scratch file and test it. | `checkbashisms` |

**Two general portability habits that are not single bans.**

Quote every path. The founder's folder may sit under `C:\Users\Sam Okoye\My Documents\`, which arrives in Git Bash as `/c/Users/Sam Okoye/My Documents/`, with two spaces in it.
An unquoted expansion there does not error, it produces a wrong path and a confusing message.

`wc` output is padded on BSD and not on GNU.
Every `wc` result that gets compared or printed goes through `tr -d ' '` or is captured with `wc -l < file` rather than `wc -l file`, and the reason is worth a `# POSIX:` tag the first time it appears.

---

### 8. How it is enforced

Enforcement has three layers: the validator, shellcheck, and the human.
The first two are cheap and catch shape.
The third catches meaning, which is most of what this section is about.

#### 8.1 The validator addition

Paste this block into `/Users/pmudh/Documents/GitHub/Atlanta/scripts/validate.sh`.

The exact insertion point, in the file as it stands today at 312 lines: the `Hygiene` section starts at line 275 with `head_ "Hygiene"` and its last statement is the closing `fi` on line 306.
The result block starts at line 308 with the comment `# ------------------------------------------------------------------- result`.
Insert the block below at line 307, between them.

It uses six helpers that already exist in that file, at these lines, so nothing new needs defining:

- `err()` at line 17, prints `FAIL` and increments `ERRORS`.
- `warn()` at line 18, prints `WARN` and increments `WARNINGS`.
- `ok()` at line 19, prints `ok`.
- `head_()` at line 20, prints a section heading.
- `rel()` at line 21, strips the absolute repo prefix from a path so output is readable.
- `show()` at line 22, prints an indented, truncated evidence line.

It also uses the two path variables defined at lines 11 and 12 of that file: `REPO`, the absolute repository root, and `PLUGIN`, which is `$REPO/plugins/growth-engine`.

It is Class R code, so bash is fine.

```bash
# ------------------------------------------------------ code standards

head_ "Code standards"

# Class F is everything that ships to a founder machine, plus the test runner,
# which runs on the Windows CI runner and is therefore held to the same floor.
founder_scripts() {
  {
    [ -f "$PLUGIN/bin/ge" ] && echo "$PLUGIN/bin/ge"
    find "$PLUGIN/scripts" -name '*.sh' -type f 2>/dev/null
    [ -f "$REPO/tests/run.sh" ] && echo "$REPO/tests/run.sh"
  } | sort
}

SCRIPTS=$(founder_scripts)

if [ -z "$SCRIPTS" ]; then
  warn "no founder-path scripts found yet. This section starts checking at task B-01"
fi

for f in $SCRIPTS; do
  rf=$(echo "$f" | rel)

  # The header is the contiguous run of comment lines from line 2 down. It is
  # NOT a fixed 10 lines: a real WHY IT EXISTS wraps to four or five lines, and
  # hard-coding a window rejects exactly the well-written headers we want.
  # exit runs the END block too, so "found" has to be set before exiting or
  # every header reports two line numbers and the arithmetic below explodes.
  HDR_END=$(awk 'NR>1 && $0 !~ /^#/ {print NR-1; found=1; exit}
                 END{if(!found) print NR}' "$f")
  HDR=$(sed -n "1,${HDR_END}p" "$f")

  # --- header shape -------------------------------------------------
  [ "$(sed -n '1p' "$f")" = '#!/bin/sh' ] \
    || err "$rf: line 1 must be exactly '#!/bin/sh'. Git Bash on Windows Home is the runtime floor"

  sed -n '2p' "$f" | grep -qE '^# [A-Za-z0-9_.-]+ — .+[^ ]$' \
    || err "$rf: line 2 must be '# <filename> — <one sentence>'. See planning/delivery/06-code-standards.md section 1.3"

  [ "$(sed -n '3p' "$f")" = '#' ] \
    || err "$rf: line 3 must be a bare '#' separating the title from the fields"

  # The five fields, in order, anywhere in the header block.
  ORDER=$(printf '%s\n' "$HDR" \
    | grep -oE '^# (WHY IT EXISTS|CALLED BY|READS|POSTURE|PORTABILITY):' \
    | sed 's/^# //;s/:$//' | tr '\n' ' ')
  [ "$ORDER" = "WHY IT EXISTS CALLED BY READS POSTURE PORTABILITY " ] \
    || err "$rf: header fields missing or out of order. Got: [$ORDER]"

  printf '%s\n' "$HDR" | grep -q 'WRITES:' \
    || err "$rf: the READS line carries no WRITES:. State the files this script is the ONE writer of, or write 'WRITES: nothing'"

  printf '%s\n' "$HDR" | grep -qE '^# POSTURE: +(fail-open|fail-closed|warn-only|fail-loud) — .+' \
    || err "$rf: POSTURE must be fail-open, fail-closed, warn-only or fail-loud, then an em dash, then one clause of why"

  printf '%s\n' "$HDR" | grep -qF '# PORTABILITY:   POSIX sh. No bash/python/node/jq.' \
    || err "$rf: PORTABILITY line does not start with the fixed sentence"

  printf '%s\n' "$HDR" | grep -qF 'EVERY ERROR MESSAGE ENDS WITH A RECOVERY LINE' \
    || err "$rf: the error-recovery notice line is missing from the header"

  # set -u sits on the first executable line, immediately after the header.
  sed -n "$((HDR_END + 1)),$((HDR_END + 3))p" "$f" | grep -qE '^set -u( |$)' \
    || err "$rf: 'set -u' must be the first line after the header block"

  if grep -qE '^set -[a-z]*e' "$f"; then
    err "$rf: 'set -e' is banned in founder-path code. Handle failures explicitly"
  fi

  # --- it must at least parse ---------------------------------------
  # On macOS /bin/sh is bash in sh-mode, so this is a weak check locally. The
  # strong one is "dash -n" in CI, section 8.2. Both, not either.
  sh -n "$f" 2>/dev/null || err "$rf: sh -n fails. It does not parse as POSIX sh"

  # --- dashes, everywhere except the two whitelisted positions ------
  BADDASH=$(grep -n '[—–]' "$f" | grep -vE '^2:' | grep -v 'POSTURE:' || true)
  if [ -n "$BADDASH" ]; then
    err "$rf: em or en dash outside the title line and the POSTURE line:"
    show "$BADDASH"
  fi

  # --- banned constructs --------------------------------------------
  # Whole-line comments are excluded, because a '# POSIX:' comment has to be
  # able to say the words "readlink -f" to explain why it is not used, and an
  # English sentence containing "which" is not a call to which(1). A line of
  # real code with a trailing comment is still checked; its escape hatch is a
  # trailing '# lint-ok: <reason>', which forces the author to write the reason.
  BANNED=$(grep -nE '\[\[|\blocal \b|echo -[en]|<\(|>\(|\bmapfile\b|\breadarray\b|sed -i|readlink -f|\brealpath\b|\bstat -[cf]\b|(^|[;&|(]) *source |function +[A-Za-z_]+ *\(\)|\bseq +[0-9$]|\blet \b|(^|[;&|(`]|\$\() *which |grep -P|read +-[aps]\b|\$\{[A-Za-z_]+,,\}|\$\{[A-Za-z_]+\^\^\}|pipefail|\bdmgate\b' "$f" \
    | grep -vE '^[0-9]+:[[:space:]]*#' \
    | grep -v '# lint-ok:' || true)
  if [ -n "$BANNED" ]; then
    err "$rf: banned construct. See planning/delivery/06-code-standards.md section 7:"
    show "$BANNED"
  fi

  # --- every swallowed error is explained ---------------------------
  # A line that discards a failure must carry '# SWALLOWED:' on itself or on
  # the line above it. This is the check most likely to catch a real bug.
  SWALLOW_LINES=$(grep -nE '2>/dev/null|\|\| true|\|\| :( |$)' "$f" \
    | grep -vE '^[0-9]+:[[:space:]]*#' | cut -d: -f1 || true)
  for ln in $SWALLOW_LINES; do
    prev=$((ln - 1))
    if ! sed -n "${prev},${ln}p" "$f" | grep -q '# SWALLOWED:'; then
      err "$rf line $ln: an error is discarded with no '# SWALLOWED:' comment saying which error and why"
    fi
  done

  # --- TODO discipline ----------------------------------------------
  BADTODO=$(grep -n 'TODO' "$f" | grep -vE 'TODO\([a-z]+, 20[0-9]{2}-[0-9]{2}-[0-9]{2}, [A-Za-z0-9-]+\):' || true)
  if [ -n "$BADTODO" ]; then
    err "$rf: TODO must read TODO(owner, YYYY-MM-DD, task-id): text"
    show "$BADTODO"
  fi
  MARKERS=$(grep -nE '\b(FIXME|XXX|HACK)\b' "$f" || true)
  if [ -n "$MARKERS" ]; then
    err "$rf: FIXME, XXX and HACK are banned. There is one marker and it is TODO(owner, date, task-id)"
    show "$MARKERS"
  fi

  # --- commented-out code -------------------------------------------
  # Heuristic: a comment whose body looks like a shell statement. Tagged
  # comments are exempt because they legitimately quote formats and commands.
  DEADCODE=$(grep -nE '^[[:space:]]*#[[:space:]]*(if |then$|fi$|for |while |case |esac$|done$|printf |[A-Za-z_][A-Za-z0-9_]*=|\. [\"$/])' "$f" \
    | grep -vE '# (POSIX|FORMAT|SCAR|SWALLOWED|FAIL-CLOSED|FAIL-OPEN|TODO)' || true)
  if [ -n "$DEADCODE" ]; then
    err "$rf: commented-out code. Delete it. Git has every version:"
    show "$DEADCODE"
  fi

  # --- error messages carry a recovery ------------------------------
  # Every block writing to stderr must have an arrow line within 4 lines.
  for ln in $(grep -n '>&2' "$f" | cut -d: -f1 || true); do
    if ! sed -n "${ln},$((ln + 4))p" "$f" | grep -q '→ run: '; then
      warn "$rf line $ln: writes to stderr with no '→ run: ' recovery line within 4 lines"
    fi
  done

  # --- bare slash commands inside error strings ---------------------
  # The alternation is spelled out rather than reusing the CMDS variable
  # defined at line 167 of this file, because CMDS lists only the ten command
  # files that exist on disk today and error strings also name subcommands
  # that have no command file: connect, publish, update, undo. Keep both in
  # step by hand; if a command file is added, add it to CMDS and to this list.
  BARECMD=$(grep -nE '(^|[^[:alnum:]_-])/(setup|doctor|brain|content|engine2|ops|plan|gate|playbook|status|connect|publish|update|undo)([^a-z0-9/-]|$)' "$f" \
    | sed 's|/growth-engine:[a-z0-9-]*||g' \
    | grep -E '(^|[^[:alnum:]_-])/(setup|doctor|brain|content|engine2|ops|plan|gate|playbook|status|connect|publish|update|undo)([^a-z0-9/-]|$)' || true)
  if [ -n "$BARECMD" ]; then
    err "$rf: bare command in script text. A founder typing it gets nothing. Use /growth-engine:<name>:"
    show "$BARECMD"
  fi

  # --- marketing words, in code as in prose -------------------------
  CODEWORDS=$(grep -niE '(^|[^-[:alnum:]])(supercharge[a-z]*|unlock[a-z]*|revolutionary|seamless[a-z]*|leverage[a-z]*|effortless[a-z]*|synergy|turnkey)([^-[:alnum:]]|$)' "$f" || true)
  if [ -n "$CODEWORDS" ]; then
    err "$rf: banned marketing word in a script:"
    show "$CODEWORDS"
  fi

  # --- shellcheck suppressions need a reason ------------------------
  BADSUPP=$(grep -n 'shellcheck disable=' "$f" | grep -vE 'disable=SC[0-9]+ +# .+' || true)
  if [ -n "$BADSUPP" ]; then
    err "$rf: every 'shellcheck disable=' needs a reason on the same line after a '#'"
    show "$BADSUPP"
  fi

  # --- CRLF ----------------------------------------------------------
  # A literal CR from printf, not "grep -U", which is GNU only and would fail
  # on the builder's Mac. The check has to run everywhere the commit does.
  if grep -q "$(printf '\r')" "$f"; then
    err "$rf: CRLF line endings. Git Bash reports 'bad interpreter: /bin/sh^M'. Add '*.sh text eol=lf' to .gitattributes and re-checkout"
  fi

  # --- comment density, advisory ------------------------------------
  RUN=$(awk 'BEGIN{run=0;worst=0}
             /^[[:space:]]*#/ {run=0; next}
             /^[[:space:]]*$/ {next}
             {run++; if (run>worst) worst=run}
             END{print worst}' "$f")
  if [ "$RUN" -gt 15 ]; then
    warn "$rf: $RUN executable lines in a row with no comment. Either it needs a why, or it needs splitting"
  fi
done

# --- .gitattributes must pin sh line endings -------------------------
if grep -q '^\*\.sh text eol=lf' "$REPO/.gitattributes" 2>/dev/null; then
  ok "*.sh is pinned to LF in .gitattributes"
else
  err ".gitattributes does not pin '*.sh text eol=lf'. A Windows checkout will CRLF every script"
fi

# --- bin/ge must be committed executable ------------------------------
if [ -d "$REPO/.git" ] && [ -f "$PLUGIN/bin/ge" ]; then
  MODE=$(cd "$REPO" && git ls-files -s plugins/growth-engine/bin/ge | cut -d' ' -f1)
  [ "$MODE" = "100755" ] \
    && ok "bin/ge is committed executable" \
    || err "bin/ge is committed as mode $MODE. Run: git update-index --chmod=+x plugins/growth-engine/bin/ge"
fi

# --- shellcheck, required in CI, best effort locally ------------------
# The -z guard matters today: no founder-path script exists yet, so SCRIPTS is
# empty, and shellcheck with no file arguments exits non-zero with a usage
# message that would be reported as a finding. Without this guard the section
# fails on a clean tree from the moment it is pasted in.
if [ -z "$SCRIPTS" ]; then
  : # nothing to check yet. The warn above already said so.
elif command -v shellcheck >/dev/null 2>&1; then
  SC_OUT=$(shellcheck -s sh -S style $SCRIPTS 2>&1) || true
  if [ -n "$SC_OUT" ]; then
    err "shellcheck findings:"
    show "$SC_OUT"
  else
    ok "shellcheck clean on $(echo "$SCRIPTS" | wc -w | tr -d ' ') founder-path scripts"
  fi
elif [ -n "${CI:-}" ]; then
  err "shellcheck is not installed on the CI runner. It is required in CI"
else
  warn "shellcheck not installed locally. CI will run it. Install: brew install shellcheck"
fi
```

**What this block reports the moment you paste it in, verified by running it against the repository on 21 August 2026.**

Two lines, and both are correct:

```
== Code standards
WARN  no founder-path scripts found yet. This section starts checking at task B-01
FAIL  .gitattributes does not pin '*.sh text eol=lf'. A Windows checkout will CRLF every script
```

The WARN is expected. No Class F script exists yet, so `SCRIPTS` is empty, the per-file loop does not run, and the shellcheck stage is skipped by the `-z` guard.

The FAIL shown above is what the check printed **before** the pin landed. It no longer fires.
`/Users/pmudh/Documents/GitHub/Atlanta/.gitattributes` was fixed on 20 August 2026 and now carries the lines below beneath the original `* text=auto`.
Confirm with `git check-attr text eol -- scripts/validate.sh`, which prints `text: set` and `eol: lf`.
Kept here because the check is worth understanding: had the pin not landed, this block would correctly have blocked every commit until it did.

```
*.sh text eol=lf
bin/ge text eol=lf
```

Then re-run `bash scripts/validate.sh` and confirm the line reads `ok    *.sh is pinned to LF in .gitattributes` before committing.
Do not paste the block and leave the fix for later, because a validator that is known to fail is a validator people start skipping.

Three honest limitations, stated so nobody trusts this more than it deserves.

The banned-construct grep is line-based and does not understand shell quoting.
Whole-line comments are excluded, because the `# POSIX:` tags exist precisely to name the banned construct and explain why it is avoided, and because an English sentence containing the word "which" is not a call to `which`.
A line of real code with a trailing comment is still checked, and its escape is a trailing `# lint-ok: <reason>`, which is deliberately a little annoying, because the author has to write down why.
A banned construct inside a here-document or a quoted string will still be flagged; use the escape and say so.

The commented-out-code check is a heuristic.
It will miss a one-word dead line and it will occasionally flag a comment that legitimately quotes a command.
The tagged-comment exemptions cover the common false positives.

The header-block detection treats the header as every comment line from line 2 until the first non-comment line.
A script that puts a blank line inside its header will have the block cut short and will fail with fields "missing".
That is the intended behaviour: the header is one unbroken block, and a blank line in the middle of it is itself a defect.

#### 8.2 shellcheck configuration

Create `.shellcheckrc` at the repository root:

```
# .shellcheckrc — shellcheck settings for the Atlanta repo.
#
# Founder-path scripts are checked as POSIX sh. The dialect is set per-invocation
# with -s sh rather than here, because scripts/validate.sh and
# scripts/build-folder.sh are bash by design and are checked separately.

# Style-level and above. Style catches the readability rules we care about.
severity=style

# Optional checks we opt in to, and why each one is worth the noise.
# quote-safe-variables: catches the unquoted path expansions that break on
#   "My Documents", which is the exact Windows failure we cannot debug remotely.
enable=quote-safe-variables
# require-variable-braces: enforces "${var}" adjacency, section 6.3.
enable=require-variable-braces
# check-extra-masked-returns: finds exit codes lost inside command substitution,
#   which is how a fail-closed path quietly becomes fail-open.
enable=check-extra-masked-returns
# deprecate-which: we require "command -v", section 7.
enable=deprecate-which
# add-default-case: every case statement on an enum needs its *) branch.
enable=add-default-case

# NOT enabled, deliberately: require-double-brackets. It would demand [[ ]],
# which is banned in this project. Never turn it on.

# Suppressed globally, with reasons:
# SC1091 - libraries are sourced through a path built at runtime, so shellcheck
#          cannot follow them. Every source line names its target in a comment.
disable=SC1091
```

CI invocation. The file `.github/workflows/validate.yml` currently contains exactly this, and nothing else:

```yaml
name: validate
on:
  push:
  pull_request:
jobs:
  validate:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - name: Run the repo validator
        run: bash scripts/validate.sh
```

Replace the whole file with this. It is complete, not a fragment to splice in:

```yaml
name: validate
on:
  push:
  pull_request:
jobs:
  validate:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      # checkbashisms is NOT its own apt package. It ships inside devscripts.
      # "apt-get install checkbashisms" fails with "unable to locate package",
      # and because apt-get returns non-zero the whole job dies on a wrong
      # package name rather than on a real finding. dash is already present on
      # ubuntu-latest, where /bin/sh is dash, so it is not installed here.
      - name: Install the static shell checkers
        run: sudo apt-get update && sudo apt-get install -y shellcheck devscripts
      - name: Parse every founder-path script as POSIX sh
        run: |
          set -e
          for f in plugins/growth-engine/bin/ge $(find plugins/growth-engine/scripts -name '*.sh' 2>/dev/null) tests/run.sh; do
            [ -f "$f" ] || continue
            echo "checking $f"
            dash -n "$f"
            checkbashisms -f "$f"
          done
      - name: Run the repo validator
        run: bash scripts/validate.sh
```

Two things about that job that are easy to get wrong.

The `find` carries `2>/dev/null` because `plugins/growth-engine/scripts/` does not exist yet, and an unredirected `find` on a missing directory writes to stderr and exits 1, which under command substitution inside `set -e` is not fatal but does clutter the log with a failure that is not one.
The `[ -f "$f" ] || continue` line is what actually makes the loop safe on a tree with no scripts in it, and it must not be removed as redundant.

The job is `runs-on: ubuntu-latest` only. That is deliberate: this job proves shape, and shape is OS-independent.
The three-OS behaviour matrix is a separate job and is described immediately below.

`dash -n` is the strongest single portability signal available.
`dash` is close to the minimal POSIX shell, so anything it parses will parse in Git Bash and in the Cowork VM.
`checkbashisms` catches the runtime bash-isms that parse fine but behave differently.
Both must be in CI before the first `ge` commit lands, not after.

The three-OS matrix specified in `planning/PRD-growth-engine-v1.md`, which runs `tests/run.sh` on `macos-latest`, `ubuntu-latest` and `windows-latest` runners, is what proves the date and path code.
It is a second job in the same workflow file, added when `tests/run.sh` first exists:

```yaml
  matrix:
    strategy:
      fail-fast: false
      matrix:
        os: [macos-latest, ubuntu-latest, windows-latest]
    runs-on: ${{ matrix.os }}
    steps:
      - uses: actions/checkout@v4
      - name: Run the golden tests
        shell: bash
        run: sh tests/run.sh
```

`shell: bash` on the Windows runner is what selects Git Bash rather than PowerShell, and Git Bash is the exact runtime a Windows Home founder gets in the desktop Code tab. That is the whole point of the Windows row.

Static checks prove shape; the matrix proves behaviour. Ship both.

#### 8.3 The commit gate

`bash scripts/validate.sh` must pass with zero errors before every commit.
One task, one commit.
Commit format: `<task-id>: <imperative summary>`, and the body states what changed plus the acceptance evidence in one line.

```
B-03: add the snapshot ring with restore and undo

Byte-exact copies into .state/snapshots, capped at 10 per file, fail-closed
when the copy cannot be made. ACCEPT: golden write-snapshot-mutate-undo run
cmp-identical to the original on macOS and Ubuntu runners; ring caps at 10;
snapshot to an unwritable dir exits 1 with a recovery line.
```

#### 8.4 What only a human can check

A machine can prove a comment exists.
It cannot prove the comment is true, and a false comment is worse than none, because it is believed.
These are the questions the reviewer asks, in this order, and the review is not done until each has an answer.

1. **Is every header field true today?**
   Open `CALLED BY` and confirm the callers actually call it. Open `WRITES` and confirm nothing else in the tree writes that file. This is the one-writer rule, and the header is the only place it is recorded.

2. **Does `WHY IT EXISTS` name a failure, or does it describe the code?**
   The test: cover line 2 and read the field alone. If you cannot say what breaks when the file is deleted, send it back.

3. **Does every comment tell the truth about the code beneath it?**
   Comments rot at the speed of edits. Read each comment against its code, not past it. A comment describing an old behaviour is a review rejection, not a nitpick.

4. **Is every `# SWALLOWED:` justification actually correct?**
   The validator proves the comment exists. Only a human can tell whether discarding that particular error is safe. Ask what happens on the day that command fails for the reason the comment did not anticipate.

5. **Does every recovery line actually recover?**
   Run it. Literally paste the command from the error message into a shell where that failure has been induced, and check that the failure goes away. A recovery line that has never been run is a guess.

6. **Would a stranger reach a different conclusion?**
   Read the file as someone who does not know why the shape is odd. Every place you would have asked "why is it like this", there should be a comment. Where there is not, that is the finding.

7. **Is the posture in the header the posture in the code?**
   A header saying `fail-closed` above a function with an `|| true` in the write path is the most dangerous single defect this standard exists to catch, because everything downstream believes the undo guarantee holds.

8. **Is the comment density honest?**
   A file with a comment above every line and nothing above the one branch that matters passes the density check and fails the standard. Comments cluster at decisions. If they are evenly spread, they are decoration.

9. **Does the founder-visible text pass house style?**
   Error strings and here-documents are prose a founder reads. Short sentences, no dashes, no marketing words, no blame, ends on an action.

10. **Is anything here a bash-ism that dash happened to parse?**
    `local`, `echo` with flags, and `read` flags all parse. They behave differently. The static checks catch most of it; a reviewer who has been bitten catches the rest.

#### 8.5 The sixty-second reviewer checklist

Print this. It is the compliance test the client's requirement reduces to.

- [ ] Line 1 is `#!/bin/sh`. Line 2 is `# name — one sentence`. Line 3 is `#`.
- [ ] All five fields present, in order, all filled with something specific.
- [ ] `WRITES:` names files, or says `nothing`.
- [ ] `POSTURE:` is one of the four values and carries a because-clause.
- [ ] `set -u` present. `set -e` absent. `pipefail` absent.
- [ ] Every function has a contract comment above it.
- [ ] Every `2>/dev/null`, `|| true`, `|| :` has a `# SWALLOWED:` explaining it.
- [ ] Every posture branch is tagged `# FAIL-CLOSED:` or `# FAIL-OPEN:`.
- [ ] Every external-format assumption is tagged `# FORMAT:` with its source.
- [ ] Every non-obvious portability workaround is tagged `# POSIX:`.
- [ ] Every guard that exists because something went wrong before is tagged `# SCAR:` with a date.
- [ ] No commented-out code. No `FIXME`, `XXX` or `HACK`. Every `TODO` has an owner, a date and a task id.
- [ ] No comment restates its line.
- [ ] Every stderr path ends with `→ run: ` and one runnable command, and the command was actually run.
- [ ] Every slash command in every string is namespaced `/growth-engine:<name>`.
- [ ] No banned construct from section 7. `dash -n` and `checkbashisms` both clean.
- [ ] No abbreviations from the section 6.4 list.
- [ ] `bash scripts/validate.sh` passes with zero errors.

---

### 9. Open questions for whoever owns this section

These are flagged, not answered, because answering them requires a decision or a test result nobody has yet.

1. **The arrow character on Windows Git Bash.** Confirm at spike section S-06, "DECISION GATE B: hooks and the bin floor", at `planning/spike-findings.md` line 188, that `→` (U+2192) renders correctly in the Windows Home desktop Code tab console under Git Bash. Add the one-line receipt shown in section 5.4 to S-06's third block before the spike is run. If it does not render, switch the whole codebase to `-> run: ` and change the validator check with it. Record the answer in `planning/spike-findings.md`, which currently carries seven PENDING sections, at lines 18, 47, 81, 121, 153, 190 and 232. Note that the marker at line 121 belongs to S-04, "conversations", which is cut, so that one is closed as "cut, not required" rather than answered.

2. **The em dash carve-out.** Section 1.2 permits the em dash in exactly two header positions, because the header template in the build brief is marked exact and `scripts/validate.sh` does not scan `.sh` files. The alternative is amending the template to `# name: one sentence` and having zero exceptions anywhere in the repo. `scripts/validate.sh` line 2 already uses that colon form and reads fine, so the alternative is proven, not theoretical. It is cleaner, but it breaks a template the brief marks as fixed. Decide before task B-01, because retrofitting touches every script, the validator regexes in section 8.1, and this document.

3. **`find -maxdepth`.** Listed in section 7 as permitted with a `# POSIX:` note. It is not in POSIX, though every target we support has it. If the reviewer wants a hard zero-exceptions line, the alternative is a hand-rolled walk, which is more code and more risk than the thing it avoids.

4. **The 10 existing asset TODOs.** They are markdown, in `plugins/growth-engine/assets/ghl/README.md` (six rows) and `plugins/growth-engine/assets/forms/README.md` (four rows), not in scripts, so the script-level check in section 8.1 does not see them. Either extend the `TODO(owner, date, task-id)` rule to `plugins/**/*.md` in the same commit, or accept that markdown TODOs stay governed by the existing warn-only asset check at lines 191 to 194 of `scripts/validate.sh`. The toolkit freeze on Thursday 3 September 2026 is the deadline either way.

5. **`scripts/validate.sh` and `scripts/build-folder.sh` currently have no compliant header.** Section 1.5 gives the exact replacement text for `scripts/validate.sh`, along with its current contents so the diff is obvious. `scripts/build-folder.sh` is 92 lines and needs the same treatment, written by whoever does the commit. Adding both is a five-minute commit and should happen before any Class F script is written, so the standard is never applied only to new code.

6. **`skills/playbook-export`.** Section 0 defaults it to deferred, which means no Class F helper script is written for it. It is not one of the four locked systems, but it exists in the repository at `plugins/growth-engine/skills/playbook-export/` and it was sold. This section does not decide it. Whoever owns the delivery plan does. If it comes back in, add a class-table row in the same commit.
