## Functional review processes

### Who and where, before anything else

This section names people, paths and version numbers.
None of them are assumed known.

**The roots.**

| Name used below | Absolute path | Public? |
|---|---|---|
| the repo | `/Users/pmudh/Documents/GitHub/Atlanta` | Yes, public on GitHub from 18 August 2026 at `https://github.com/Philm-moxywolf/Atlanta` |
| the PRD | `/Users/pmudh/Documents/GitHub/Atlanta/planning/PRD-growth-engine-v1.md` | Yes, it is inside the repo |
| the spike findings | `/Users/pmudh/Documents/GitHub/Atlanta/planning/spike-findings.md` | Yes, it is inside the repo |
| the private working folder | `/Users/pmudh/Downloads/Atlanta/launchhouse-atlanta` | No. Never copy a file from here into the repo |
| the gap register | `/Users/pmudh/Downloads/Atlanta/launchhouse-atlanta/planning/PRD-GAPS.md` | No |
| the prior functional review | `/Users/pmudh/Downloads/Atlanta/launchhouse-atlanta/planning/FUNCTIONAL-REVIEW.md` | No |

Every relative path in this section, for example `scripts/validate.sh` or `plugins/growth-engine/skills/`, is relative to the repo root `/Users/pmudh/Documents/GitHub/Atlanta` unless the sentence says otherwise.
Every command block assumes you have already run `cd /Users/pmudh/Documents/GitHub/Atlanta`.

**The people.**

| Name | Role | What they can decide |
|---|---|---|
| Philip | Owner of the build, holds the design intent and the client relationship | Scope, release go or no-go, quality verdict on founder-facing copy |
| The executor | Whoever is writing code in this repo at the time, which today is Philip | Implementation, task order inside a locked scope |
| Juan | The client who commissioned the toolkit | Scope changes, hard dates |
| Eric | The B2B mentor booked for the event | Whether the B2B output stands up commercially |
| Helen | The B2C mentor booked for the event | Whether the B2C output stands up commercially |

Philip and the executor are the same person today.
That is the bus factor problem process 7 exists to reduce, and it is why the two roles are still written separately: the moment a second person is available, the split is already defined.

**The dates that appear below, all 2026.**
Toolkit freeze at version 1.0.0 is Thursday 3 September.
Repo link published to founders, onboarding email sent, playbook to printer, Friday 4 September.
Version 1.1.0 ready Saturday 19 September.
Setup clinic Wednesday 23 September.
Fix window Thursday 24 September.
The event runs Friday 25 to Sunday 27 September.
Cohort is 130 founders, roughly 65 per track.

### What this section is for

Juan, the client, asked for review processes to be in place, not for a review to be run once.
A one-off review produces a list that decays the moment the next commit lands.
Standing machinery produces a red light at the moment the mistake is made, by the person who made it, on their own machine, before anyone else has to care.

This section defines seven standing processes.
Each one is stated with the same four facts, because a process nobody can trigger and nobody owns is a document, not a process.

| # | Process | Trigger | Owner | Artifact | On failure |
|---|---|---|---|---|---|
| 1 | The pre-commit gate | Every commit, and every push through CI | Executor | Console output, exit code 0 or 1 | Commit does not happen. Fix the code or fix the check, in the same commit |
| 2 | The golden test suite | Every commit touching `plugins/growth-engine/bin/`, `plugins/growth-engine/scripts/`, `plugins/growth-engine/schemas/` or `tests/` | Executor | `tests/.work/` diff output, exit code | Commit does not happen. A red test is a bug until proven a stale fixture |
| 3 | The CI matrix, four jobs across three operating systems | Every push and every pull request | Executor | GitHub Actions run, four jobs | Branch is not merged. A red Windows leg blocks the release, not just the merge |
| 4 | The end to end rehearsal | Before every version tag, and after any skill rewrite | Philip plus executor | `planning/rehearsals/<date>-<route>-<surface>.md` | Tag does not happen. Every friction becomes a doc fix or a task with an id |
| 5 | The release checklist | Before `git tag` on any version | Philip | `planning/releases/<version>.md`, ticked | Tag does not happen. No partial ticks, no verbal sign off |
| 6 | The regression rule | Every skill file change | Executor | Regenerated examples plus `.generated-with` stamps | Validate goes red on a stale stamp. Regenerate, do not patch |
| 7 | Second pair of eyes | Weekly on Friday, and before the 3 September freeze | Reviewer (rotating, unpaid, 30 minutes) | `planning/review/<date>-<reviewer>.md` | Findings become tasks with ids. A finding is never closed by argument alone |

All paths in the table above, and everywhere below, are relative to the repo root `/Users/pmudh/Documents/GitHub/Atlanta`.

A note on scope before the detail.
`skills/growth-plan` is treated as IN throughout this section: it is read by the rehearsal, it is covered by the regression map, and it appears in the release checklist.
`skills/playbook-export` is treated as DEFERRED: it stays in the repo, it stays in validate's structural checks (frontmatter, style, namespacing), and it is explicitly excluded from the rehearsal arc and from the regeneration map.
Wherever the two differ, this section says which one it means rather than saying "the skills".
If the reader decides to pull `playbook-export` back in, the changes needed are named inline at each point.

A second note on the runtime floor, because it is the single most misread constraint in this project.
The POSIX sh floor applies to code that runs on a founder machine.
That is `plugins/growth-engine/bin/ge`, `plugins/growth-engine/scripts/**`, and anything they source.
It also applies to `tests/run.sh` and everything under `tests/`, because the tests are the only thing that proves the floor.
It does not apply to `scripts/validate.sh` or `scripts/build-folder.sh`.
Those two are developer tooling.
They run on the executor's Mac and on the ubuntu CI runner, never on a founder machine, so they may keep bash and may keep `python3`.
Mixing those two rules is how a repo ends up either with a crippled validator or with a founder script that dies on a Windows Home laptop at Session 1.
The split is enforced mechanically in check V-02 below.

---

## 1. The pre-commit gate

**Trigger.** Every commit, run by hand as `bash scripts/validate.sh` from the repo root.
Also run by CI on every push and pull request (see process 3).
Also wired as a git hook so it cannot be forgotten (see 1.4).

**Owner.** The executor. Nobody else runs it, which is exactly why it must be impossible to skip.

**Artifact.** Console output grouped by section, a final count line, and an exit code.
Exit 0 prints `PASS`. Exit 1 prints `FAIL. Do not commit until these are clear.`

**On failure.** The commit does not happen.
There are exactly two legitimate responses: fix the code, or fix the check because the check is now wrong.
The second response lands in the same commit as the code change.
That is not a preference invented here.
It is rule 2 of Part Zero of the PRD at `/Users/pmudh/Documents/GitHub/Atlanta/planning/PRD-growth-engine-v1.md`, which reads: validate before every commit, `bash scripts/validate.sh` must pass with zero FAILs, and if a task legitimately changes what validate checks then the same task updates `scripts/validate.sh`, so checks and code move in the same commit.
There is no third response.
`--no-verify` is not a response, and 1.4 explains how that is made visible rather than merely forbidden.

### 1.1 What `scripts/validate.sh` checks today

Read from the file at `/Users/pmudh/Documents/GitHub/Atlanta/scripts/validate.sh` as it stands on 20 August 2026.
It is 11,673 bytes, bash, `set -uo pipefail` (deliberately not `-e`, because it must report every failure in one pass rather than stopping at the first).
It defines `founder_files()` as `README.md` plus every `*.md` under `docs/` and under `plugins/growth-engine/`.
That definition matters: it is what "founder-facing" means to every style and fact check below.

Thirty one checks in nine groups.
The nine groups are confirmed by `grep -n 'head_ ' /Users/pmudh/Documents/GitHub/Atlanta/scripts/validate.sh`, which on 21 August 2026 returns nine hits, at lines 33, 94, 137, 160, 181, 199, 222, 247 and 275.
The check ids `EX-01` to `EX-31` below are numbering invented in this document for reference.
They are existing checks. New checks are numbered `V-01` upward.
Neither series is a build task; build task ids live in section 02 and use different prefixes.
They do not appear in `validate.sh` itself, so do not grep for them there.
Running `bash scripts/validate.sh` from `/Users/pmudh/Documents/GitHub/Atlanta` on 21 August 2026 gives `0 error(s), 2 warning(s)` and `PASS`.

**Group: Manifests**

| Id | Check | Severity |
|---|---|---|
| EX-01 | `.claude-plugin/marketplace.json` exists at the repo root | FAIL |
| EX-02 | `.claude-plugin/marketplace.json` exists and parses as JSON via `python3 -c "import json; json.load(...)"` | FAIL |
| EX-03 | `plugins/growth-engine/.claude-plugin/plugin.json` exists and parses as JSON | FAIL |
| EX-04 | Every `plugin install growth-engine@<x>` string in `README.md` and `docs/` has `<x>` equal to `marketplace.json` `name` | FAIL |
| EX-05 | `marketplace.json` `owner.url` equals `https://github.com/<path>` where `<path>` is the first documented `plugin marketplace add <path>` | FAIL |
| EX-06 | `marketplace.json` `version` equals `plugin.json` `version`, and neither is empty | FAIL |
| EX-07 | If `plugin.json` declares `SEE LICENSE IN LICENSE`, then `plugins/growth-engine/LICENSE` exists | FAIL |

EX-07 exists because the marketplace installs only `./plugins/growth-engine`.
A LICENSE at the repo root is not carried into an install.

**Group: Skills**

| Id | Check | Severity |
|---|---|---|
| EX-08 | Every `skills/<name>/` directory contains `SKILL.md` | FAIL |
| EX-09 | `SKILL.md` line 1 is exactly `---` | FAIL |
| EX-10 | `SKILL.md` line 2 is not blank (a blank line inside frontmatter silently breaks parsing) | FAIL |
| EX-11 | `name:` exists in the first 12 lines and equals the directory name | FAIL |
| EX-12 | `description:` exists in the first 12 lines | FAIL |
| EX-13 | No repeated markdown headings outside fenced code blocks | WARN |
| EX-14 | Exactly 9 skill directories exist | WARN |

**Group: Commands**

| Id | Check | Severity |
|---|---|---|
| EX-15 | Every `commands/*.md` opens with `---` and carries `description:` in the first 6 lines | FAIL |
| EX-16 | Every `<word> skill` phrase in a command file names a skill directory that exists | FAIL |
| EX-17 | Exactly 10 command files exist | WARN |

EX-16 has two problems, both confirmed by reading lines 148 to 153 of `/Users/pmudh/Documents/GitHub/Atlanta/scripts/validate.sh` on 21 August 2026.

The first is a trap that will bite the moment someone writes naturally.
The pattern is `grep -o '[a-z][a-z0-9-]* skill'`, unanchored, so a command file containing the ordinary English words "this skill" or "the skill" produces `routes to skill 'this', which does not exist` and fails the build.
It passes today only because no command file happens to contain those phrases.

The second is that EX-16 only checks that a named skill exists.
It never checks that a skill is named.
A command file that routes to nothing passes silently.
`plugins/growth-engine/commands/gate.md` is exactly that file today: `grep -inE '(use|run) the [a-z][a-z0-9-]* skill' plugins/growth-engine/commands/gate.md` returns nothing, so `/growth-engine:gate` routes to no skill and the validator is content.

Check V-19 below anchors the pattern, makes it case-insensitive so `engine2.md`'s lower-case `use the` still resolves, and adds the missing second direction.

**Group: Command namespacing**

| Id | Check | Severity |
|---|---|---|
| EX-18 | No bare `/setup`, `/doctor`, `/brain`, `/content`, `/engine2`, `/ops`, `/plan`, `/gate`, `/playbook`, `/status` in founder-facing files | FAIL |

The implementation first strips every `/growth-engine:<name>` occurrence, then excludes lines beginning `description:` (so a skill description may carry a bare form as a natural language trigger), then greps for a bare command preceded by a non word character.
This is the check that stops 130 people typing something that resolves to nothing.

**Group: Placeholders**

| Id | Check | Severity |
|---|---|---|
| EX-19 | No `ONEDAY_ORG` or `REPO_NAME` token survives in founder-facing files | FAIL |
| EX-20 | No file under `plugins/growth-engine/assets/` contains `TODO` | WARN |

EX-20 is the one that currently fires.
Counted on 21 August 2026 by running `grep -rn TODO plugins/growth-engine/assets` from the repo root: 6 in `plugins/growth-engine/assets/ghl/README.md` and 4 in `plugins/growth-engine/assets/forms/README.md`, which is 10 occurrences across 2 files, and no others anywhere under `plugins/growth-engine/`.
Note that this contradicts the figure of 15 that circulates in the project status notes.
Ten is the number the repo actually contains today.
If a status document still says 15, correct the status document rather than hunting for five TODOs that are not there.

**Group: House style, founder-facing only**

| Id | Check | Severity |
|---|---|---|
| EX-21 | No em dash and no en dash anywhere in a founder-facing file | FAIL |
| EX-22 | No banned marketing word: `supercharge*`, `unlock*`, `revolutionary`, `seamless*`, `leverage*`, `effortless*`, `synergy`, `turnkey`, and the phrases `game changer`, `cutting edge`, `best in class` | FAIL |

**Group: Design rules**

| Id | Check | Severity |
|---|---|---|
| EX-23 | Nothing guarantees or promises a reply, unless the line also carries a negation | FAIL |
| EX-24 | Any mention of DM automation is surfaced for manual confirmation that the line refuses it | WARN |
| EX-25 | `commands/engine2.md` still contains the word `track` (the two track fork is the product) | FAIL |

**Group: Locked facts**

| Id | Check | Severity |
|---|---|---|
| EX-26 | No clinic date other than 23 September appears in a founder-facing file | FAIL |
| EX-27 | Typeform is never named as the gate destination without a negation | FAIL |
| EX-28 | No founder-facing file references `TASKS.md`, `MASTERPLAN.md`, `RUNBOOK.md` or `AUDIT.md`, which live outside the repo | FAIL |

**Group: Hygiene**

| Id | Check | Severity |
|---|---|---|
| EX-29 | `.gitignore` carries `/growth-engine/` anchored, and specifically not the unanchored form which also excluded `plugins/growth-engine/` | FAIL |
| EX-30 | No file under `growth-engine/` is tracked in git, and the tracked skill and command counts match what exists on disk | FAIL |
| EX-31 | No internal material is tracked: `MASTERPLAN.md`, `TASKS.md`, `RUNBOOK.md`, `AUDIT.md`, `EXECUTE.md`, `STATE.md`, anything matching `proposal`, `brief`, `sessions-and-mentor` | FAIL |

EX-30's second half is subtle and worth keeping: it compares `git ls-files` counts against disk counts, which is what caught the unanchored gitignore silently excluding every skill from the published plugin.

**Known weaknesses in the current gate, all closed below.**

- It needs `python3` for every JSON read.
  Acceptable on a developer Mac and on ubuntu CI, not acceptable if anyone ever tries to run it on the Windows leg.
  V-02 makes the developer/founder split explicit so this never migrates.
- Skill count and command count are WARN, so adding a tenth skill or an eleventh command passes silently.
  V-18 turns counts into a manifest comparison against a declared list.
- `founder_files()` does not cover `CHANGELOG.md`, `CLAUDE.md`, or any non `.md` asset.
  V-17 widens style coverage to `CHANGELOG.md` and to `plugins/growth-engine/assets/**/*.csv` headers.
- Nothing checks that a shell script parses, because there are no founder shell scripts yet.
  V-01 to V-03 fix that on the day `bin/ge` lands.
- Nothing checks anything the locked scope forbids.
  V-13 and V-14 pin the cut list so a rewrite cannot quietly reintroduce the DM inbox skill, `ge dmgate`, `commands/inbox.md`, or the three withdrawn conversations PIT scopes.
- EX-21, the dash check, is written as a bracket expression holding two multi-byte characters, which silently degrades to a byte match when `LANG` and `LC_ALL` are unset.
  It then reports a false em dash on any file containing an arrow or a box-drawing character.
  Verified on 21 August 2026: it passes today only because no founder-facing markdown file contains an arrow yet, and the code standard is about to put arrows in every recovery line.
  V-17 replaces it with an exact byte-sequence match.
- EX-16 only proves that a named skill exists, never that a skill is named, so `commands/gate.md` routing to nothing passes.
  It is also case-sensitive in a way that does not matter yet but will: `commands/engine2.md` writes `use the` in lower case.
  V-19 fixes both directions.
- Nothing compares the README's plain-language trigger column against the descriptions of the skills those commands route to.
  V-10 adds that, and finds five real disagreements on the current repo.
- EX-14 and EX-17 assert exactly 9 skill directories and exactly 10 command files.
  Both figures are correct as of 21 August 2026 and both are about to change under the locked scope, which adds `ghl-publish` and `connect` skills and the `publish`, `connect`, `undo` and `update` commands.
  V-18 replaces the magic numbers with a declared manifest.

### 1.2 The new checks

Each new check is given an id, what it catches, the exact shell, and a red then green proof.
They are written as functions in `scripts/validate.sh` v2 and called from the existing section structure.
Every one of them uses the existing `err`, `warn`, `ok` and `show` helpers, so output style stays uniform.

All shell below assumes the variables already defined at the top of `/Users/pmudh/Documents/GitHub/Atlanta/scripts/validate.sh`.
Verified present on 21 August 2026 at lines 11 to 24 of that file: `REPO`, `PLUGIN`, and the helpers `err`, `warn`, `ok`, `head_`, `rel`, `show` and `founder_files`.
`rel` is a filter, used as `$(echo "$path" | rel)`.
`show` takes one string argument and truncates it to 150 characters.

Four more variables are added near them, once, before any of the new checks run.
Every new check below reads them, so they are defined in one place rather than inside V-01:

```bash
TMP="$(mktemp -d "${TMPDIR:-/tmp}/lh-validate.XXXXXX")"
trap 'rm -rf "$TMP"' EXIT

# The founder floor: everything that runs on a founder machine.
# Parsed with sh, checked for bashisms, checked for a standard header.
FLOOR_SCRIPTS=$(find "$PLUGIN/bin" "$PLUGIN/scripts" "$REPO/tests" -type f \
  \( -name '*.sh' -o -name 'ge' \) 2>/dev/null | sort | tr '\n' ' ')

# Developer tooling: runs on the executor's Mac and on the ubuntu CI runner only.
# bash and python3 are permitted here and nowhere else.
DEV_SCRIPTS="$REPO/scripts/validate.sh $REPO/scripts/build-folder.sh"
```

**The empty case matters and is easy to get wrong.**
As of 21 August 2026 `plugins/growth-engine/bin/` does not exist, `plugins/growth-engine/scripts/` does not exist, and `tests/` does not exist.
`FLOOR_SCRIPTS` is therefore the empty string until PRD task B-01 lands `bin/ge`.
An unquoted empty variable passed to `grep -rnE "$PATTERN" $FLOOR_SCRIPTS` gives `grep` no file operand, so `grep` reads standard input and the validator hangs forever with no output.
Guard it once, immediately after the definition above:

```bash
if [ -z "$FLOOR_SCRIPTS" ]; then
  warn "no founder-floor scripts on disk yet. V-01 to V-05 and V-12 are deferred, not passing."
  FLOOR_CHECKS=0
else
  FLOOR_CHECKS=1
fi
```

Every check that consumes `FLOOR_SCRIPTS` opens with `[ "$FLOOR_CHECKS" -eq 1 ] || return 0` if it is a function, or is wrapped in `if [ "$FLOOR_CHECKS" -eq 1 ]; then ... fi` if it is inline.
Deferring loudly is correct here.
Silently passing a check that examined nothing is how a gate stops being a gate.

---

#### V-01. Every shell script parses (`sh -n` on the founder floor, `bash -n` on developer tooling)

**Catches.** A syntax error, an unbalanced quote, an unterminated `case`, a stray `fi`.
Today nothing parses any script, so a broken `ge` ships and fails in a founder's terminal at Session 2 with a raw shell error and no recovery line.

**Shell.**

```bash
head_ "Script syntax"

# FLOOR_SCRIPTS and DEV_SCRIPTS are defined once, above, with the TMP setup.
# The founder floor is parsed with sh, because sh is what Windows Home runs.
for s in $FLOOR_SCRIPTS; do
  if sh -n "$s" 2>"$TMP/synerr"; then
    ok "sh -n $(echo "$s" | rel)"
  else
    err "sh -n failed on $(echo "$s" | rel)"
    show "$(cat "$TMP/synerr")"
  fi
done

for s in $DEV_SCRIPTS; do
  [ -f "$s" ] || continue
  if bash -n "$s" 2>"$TMP/synerr"; then
    ok "bash -n $(echo "$s" | rel)"
  else
    err "bash -n failed on $(echo "$s" | rel)"
    show "$(cat "$TMP/synerr")"
  fi
done
```

**Prove it.**
This proof needs a founder-floor script to exist, so it can only be run once PRD task B-01 has landed `plugins/growth-engine/bin/ge` and its `scripts/lib/` helpers.
Until then, V-01 correctly reports the deferral warning described above.

Once `plugins/growth-engine/scripts/lib/paths.sh` exists:

```sh
cd /Users/pmudh/Documents/GitHub/Atlanta
printf 'if [ -f x ]; then\n' >> plugins/growth-engine/scripts/lib/paths.sh
bash scripts/validate.sh ; echo "exit=$?"
```

Expect the line `FAIL  sh -n failed on plugins/growth-engine/scripts/lib/paths.sh` and `exit=1`.
Then remove the planted line and rerun:

```sh
cd /Users/pmudh/Documents/GitHub/Atlanta
sed -i.bak '$d' plugins/growth-engine/scripts/lib/paths.sh && rm -f plugins/growth-engine/scripts/lib/paths.sh.bak
bash scripts/validate.sh ; echo "exit=$?"
```

Expect `ok    sh -n plugins/growth-engine/scripts/lib/paths.sh` and `exit=0`.
The `-i.bak` form with an explicit suffix is used because BSD `sed` on macOS requires an argument to `-i` and GNU `sed` accepts one.

---

#### V-02. No bashism on the founder floor

**Catches.** The single failure mode the Windows Home slice cannot survive.
`[[ ]]`, `local`, arrays, `source`, `echo -e`, `read -p`, `${var,,}`, `<<<`, `function name()`, `==` inside `[ ]`.
Git Bash is bash, and macOS `/bin/sh` is bash in sh mode, so neither of those runners reliably rejects a bashism.
This check plus `shellcheck -s sh` plus the dash leg in CI are what actually hold the floor.

**Shell.**

```bash
head_ "POSIX floor"

BASHISM='(\[\[|\]\])|(^|[[:space:];])local[[:space:]]|(^|[[:space:];])source[[:space:]]|(^|[[:space:];])function[[:space:]]+[A-Za-z_]|echo[[:space:]]+-e|read[[:space:]]+-p|<<<|\$\{[A-Za-z_][A-Za-z0-9_]*,,\}|\$\{[A-Za-z_][A-Za-z0-9_]*\^\^\}|=\(|\bpipefail\b'
[ "$FLOOR_CHECKS" -eq 1 ] || FLOOR_SCRIPTS="/dev/null"   # never let grep fall back to stdin
HITS=$(grep -rnE "$BASHISM" $FLOOR_SCRIPTS 2>/dev/null | grep -v '# posix-ok' || true)
if [ -n "$HITS" ]; then
  err "bashism on the founder floor. Windows Home founders run Git Bash but the floor is POSIX sh:"
  show "$HITS"
else
  ok "no bashisms in bin/ge, plugin scripts or tests"
fi

# Belt: refuse python, node and jq on any founder path.
RUNTIME=$(grep -rnE '(^|[^a-z])(python3?|node|npx|jq)([^a-z]|$)' $FLOOR_SCRIPTS 2>/dev/null | grep -v '# posix-ok' || true)
if [ -n "$RUNTIME" ]; then
  err "founder-path script calls a runtime that is not on every founder machine:"
  show "$RUNTIME"
else
  ok "no python, node or jq on any founder path"
fi
```

The `# posix-ok` escape exists for the one case that will come up: a comment or an error message that mentions `jq` in prose.
Every use of the escape needs a reason on the same line.

**Prove it.**
Needs a founder-floor script on disk, so it runs after PRD task B-01.

```sh
cd /Users/pmudh/Documents/GitHub/Atlanta
printf 'demo_fn() { local x=1; }\n' >> plugins/growth-engine/scripts/lib/paths.sh
bash scripts/validate.sh ; echo "exit=$?"
```

Expect `FAIL  bashism on the founder floor` naming `plugins/growth-engine/scripts/lib/paths.sh` and the line number, and `exit=1`.
Change `local x=1` to `x=1`, rerun, expect `ok    no bashisms in bin/ge, plugin scripts or tests`.
Then append `jq -r .name plugin.json` to the same file and confirm the second half fires on its own with `FAIL  founder-path script calls a runtime that is not on every founder machine`.
Remove both planted lines before committing anything.

---

#### V-03. shellcheck, required in CI, best effort locally

**Catches.** Unquoted expansions that break on a path with a space (which is most Windows Desktop paths), `cd` without a guard, useless `cat`, subshell variable loss, glob injection.
Founders put their working folder in `C:\Users\First Last\Documents`, and an unquoted `$HOME` is a live outage on day one.

**Shell.**

```bash
head_ "shellcheck"

if command -v shellcheck >/dev/null 2>&1; then
  SC_FAIL=0
  for s in $FLOOR_SCRIPTS; do
    shellcheck -s sh -S warning "$s" >"$TMP/sc.out" 2>&1 || { SC_FAIL=1; show "$(cat "$TMP/sc.out")"; }
  done
  for s in $DEV_SCRIPTS; do
    [ -f "$s" ] || continue
    shellcheck -s bash -S warning "$s" >"$TMP/sc.out" 2>&1 || { SC_FAIL=1; show "$(cat "$TMP/sc.out")"; }
  done
  [ "$SC_FAIL" -eq 0 ] && ok "shellcheck clean at warning level" \
                       || err "shellcheck findings above. Fix them or add a justified disable directive"
else
  warn "shellcheck not installed locally. CI runs it, so this can only be deferred, not skipped. → run: brew install shellcheck"
fi
```

**Prove it.**
Install shellcheck first if `command -v shellcheck` is empty:

```sh
brew install shellcheck
```

Then, once a founder-floor script exists (PRD task B-01):

```sh
cd /Users/pmudh/Documents/GitHub/Atlanta
printf 'cp $HOME/growth-engine/founder-brain.md /tmp/x\n' >> plugins/growth-engine/scripts/lib/paths.sh
bash scripts/validate.sh ; echo "exit=$?"
```

Expect shellcheck code SC2086 ("Double quote to prevent globbing and word splitting") in the output and `exit=1`.
Change the line to `cp "$HOME/growth-engine/founder-brain.md" /tmp/x`, rerun, expect `ok    shellcheck clean at warning level`.
Remove the planted line before committing.

---

#### V-04. Every error message ends with a recovery line

**Catches.** The exact failure the code standard exists to prevent: a founder sees `ge: cannot write` and has nothing to do next.
The standard says every error message ends with `→ run: ...`.
This makes it structural rather than aspirational.

**Design first.** Standardise on one helper in `plugins/growth-engine/scripts/lib/die.sh`:

```sh
# die <message> <recovery>. Both arguments are required.
die() {
  [ "$#" -eq 2 ] || { printf 'ge: internal: die called without a recovery line\n' >&2; exit 70; }
  printf '%s\n  → run: %s\n' "$1" "$2" >&2
  exit 1
}
```

**Shell.**

```bash
head_ "Recovery lines"

[ "$FLOOR_CHECKS" -eq 1 ] || FLOOR_SCRIPTS="/dev/null"   # never let grep fall back to stdin

# Any error path that is not die() must carry the arrow itself.
RAW=$(grep -rnE '(printf|echo).*>&2' $FLOOR_SCRIPTS 2>/dev/null | grep -v '→ run:' | grep -v 'die()' || true)
if [ -n "$RAW" ]; then
  err "error written to stderr without a recovery line. Use die \"<what>\" \"<fix>\":"
  show "$RAW"
else
  ok "every stderr write carries a recovery line or goes through die()"
fi

# die() must always be called with two arguments.
ONEARG=$(grep -rnE '(^|[^a-z_])die[[:space:]]+"[^"]*"[[:space:]]*$' $FLOOR_SCRIPTS 2>/dev/null || true)
if [ -n "$ONEARG" ]; then
  err "die() called with one argument. The second argument is the recovery line:"
  show "$ONEARG"
else
  ok "every die() call carries a recovery line"
fi
```

**Prove it.**
Runs after PRD task B-01.

```sh
cd /Users/pmudh/Documents/GitHub/Atlanta
printf "printf 'ge: no folder\\n' >&2\n" >> plugins/growth-engine/scripts/lib/paths.sh
bash scripts/validate.sh ; echo "exit=$?"
```

Expect `FAIL  error written to stderr without a recovery line` naming the file and line, and `exit=1`.
Replace that line with `die "ge: no growth-engine folder here" "ge init"`, rerun, expect `ok    every stderr write carries a recovery line or goes through die()`.
Remove the planted line before committing.

---

#### V-05. Every script carries the standard header

**Catches.** A script with no stated posture.
The postures are load bearing: `ge snapshot` is fail closed, `ge context` is fail open, `ge lint` is warn only.
If the header is missing, the next person to touch the file does not know which one they are in, and a fail closed path quietly becomes fail open.

**Shell.**

```bash
head_ "Script headers"

# A for loop over an empty FLOOR_SCRIPTS simply does not execute, so no
# stdin guard is needed here. The deferral warning is already printed above.
for s in $FLOOR_SCRIPTS; do
  miss=""
  for k in 'WHY IT EXISTS:' 'CALLED BY:' 'READS:' 'WRITES:' 'POSTURE:' 'PORTABILITY:'; do
    head -20 "$s" | grep -q "$k" || miss="$miss $k"
  done
  head -20 "$s" | grep -qE 'POSTURE:[[:space:]]*(fail-open|fail-closed|warn-only)' \
    || miss="$miss POSTURE-value"
  head -20 "$s" | grep -q 'set -u' || miss="$miss set-u"
  if [ -n "$miss" ]; then
    err "$(echo "$s" | rel) header missing:$miss"
  else
    ok "$(echo "$s" | rel) header complete"
  fi
done
```

**Prove it.**
Runs after PRD task B-01 has created `plugins/growth-engine/scripts/lib/date_compat.sh`.

```sh
cd /Users/pmudh/Documents/GitHub/Atlanta
cp plugins/growth-engine/scripts/lib/date_compat.sh /tmp/date_compat.keep
grep -v '^# POSTURE:' /tmp/date_compat.keep > plugins/growth-engine/scripts/lib/date_compat.sh
bash scripts/validate.sh ; echo "exit=$?"
```

Expect `FAIL  plugins/growth-engine/scripts/lib/date_compat.sh header missing: POSTURE: POSTURE-value` and `exit=1`.
Restore it and confirm green:

```sh
cd /Users/pmudh/Documents/GitHub/Atlanta
cp /tmp/date_compat.keep plugins/growth-engine/scripts/lib/date_compat.sh
rm -f /tmp/date_compat.keep
bash scripts/validate.sh ; echo "exit=$?"
```

---

#### V-06. JSON parses on every manifest, not just two

**Catches.** A trailing comma in `.mcp.json` that makes the plugin fail to enable, with no message the founder can act on.
Today only `marketplace.json` and `plugin.json` are parsed.
The revised build adds `.mcp.json` and `hooks/hooks.json`.

**Shell.**

```bash
head_ "All manifests"

for f in "$REPO/.claude-plugin/marketplace.json" \
         "$PLUGIN/.claude-plugin/plugin.json" \
         "$PLUGIN/.mcp.json" \
         "$PLUGIN/hooks/hooks.json"; do
  if [ ! -f "$f" ]; then
    case "$f" in
      *marketplace.json|*plugin.json) err "missing: $(echo "$f" | rel)" ;;
      *) warn "not present yet: $(echo "$f" | rel)" ;;
    esac
    continue
  fi
  if python3 -c "import json,sys; json.load(open(sys.argv[1]))" "$f" 2>"$TMP/jsonerr"; then
    ok "$(echo "$f" | rel) parses"
  else
    err "$(echo "$f" | rel) is not valid JSON"
    show "$(cat "$TMP/jsonerr")"
  fi
done

# Every ${user_config.X} used in .mcp.json must be declared in plugin.json userConfig.
if [ -f "$PLUGIN/.mcp.json" ]; then
  USED=$(grep -o '\${user_config\.[A-Za-z0-9_]*}' "$PLUGIN/.mcp.json" | sed 's/.*\.\(.*\)}/\1/' | sort -u)
  DECL=$(python3 -c "import json;d=json.load(open('$PLUGIN/.claude-plugin/plugin.json'));print('\n'.join((d.get('userConfig') or {}).keys()))" 2>/dev/null | sort -u)
  for k in $USED; do
    if echo "$DECL" | grep -qx "$k"; then
      ok "userConfig key '$k' is declared"
    else
      err "\${user_config.$k} used in .mcp.json but not declared in plugin.json userConfig. The header will substitute empty and every MCP call will 401"
    fi
  done
fi
```

**Prove it.**
Runs once `plugins/growth-engine/.mcp.json` exists.
That file does not exist as of 21 August 2026; until it does, V-06 prints `WARN  not present yet: plugins/growth-engine/.mcp.json`, which is the intended behaviour.

With the file present, edit the GoHighLevel MCP server's `headers` block in `plugins/growth-engine/.mcp.json` and change the correctly spelled key `${user_config.locationId}` to the misspelled `${user_config.locationIdd}`, then:

```sh
cd /Users/pmudh/Documents/GitHub/Atlanta
bash scripts/validate.sh ; echo "exit=$?"
```

Expect `FAIL  ${user_config.locationIdd} used in .mcp.json but not declared in plugin.json userConfig` and `exit=1`.
Correct the spelling back to `${user_config.locationId}`, rerun, expect `ok    userConfig key 'locationId' is declared` and `exit=0`.

---

#### V-07. No secret shaped string is ever committed

**Catches.** The one mistake that cannot be undone by a revert, because the repo is public from 18 August.
A pasted PIT in a doc, a Bearer token in a spike finding, an `ghl.env` accidentally added.

**Shell.**

```bash
head_ "Secrets"

SECRET='(pit-[A-Za-z0-9_-]{8,})|(Bearer[[:space:]]+[A-Za-z0-9._-]{20,})|(sk-[A-Za-z0-9]{16,})|(eyJ[A-Za-z0-9_-]{20,}\.)'
LEAK=$(grep -rInE "$SECRET" "$REPO" \
  --exclude-dir=.git --exclude-dir=dist --exclude-dir=node_modules 2>/dev/null \
  | grep -v 'PASTE_TOKEN_HERE' | grep -v '<pit>' | grep -v 'pit-example' || true)
if [ -n "$LEAK" ]; then
  err "a secret-shaped string is in the tree. This repo is public. Rotate the credential, then remove it:"
  show "$LEAK"
else
  ok "no secret-shaped strings"
fi

if [ -d "$REPO/.git" ]; then
  ENVFILE=$(cd "$REPO" && git ls-files | grep -E '(^|/)(ghl\.env|\.env)$' || true)
  [ -n "$ENVFILE" ] && err "a credentials file is tracked: $ENVFILE" || ok "no credentials file tracked"
fi
```

**Prove it.**
`docs/CONNECTIONS.md` is created by PRD task SS-01 and does not exist as of 21 August 2026.
The only file in `docs/` today is `docs/PRE-WORK.md`, confirmed by `ls /Users/pmudh/Documents/GitHub/Atlanta/docs`.
So plant the string in a scratch file inside the tree instead, which exercises the same recursive grep:

```sh
cd /Users/pmudh/Documents/GitHub/Atlanta
printf 'Authorization: Bearer pit-9f2a4c118b7d6e0a5533\n' > docs/SECRET-PROBE.md
bash scripts/validate.sh ; echo "exit=$?"
```

Expect `FAIL  a secret-shaped string is in the tree. This repo is public. Rotate the credential, then remove it:` and `exit=1`.
Then:

```sh
cd /Users/pmudh/Documents/GitHub/Atlanta
rm -f docs/SECRET-PROBE.md
bash scripts/validate.sh ; echo "exit=$?"
```

Expect `ok    no secret-shaped strings` and `exit=0`.
Do not commit at any point while the probe file exists.
The token above is a made-up string with no account behind it, but the muscle memory of committing one is the thing being trained against.

---

#### V-08. CSV header fixture comparison

**Catches.** The header row drifting between the real downloaded GoHighLevel Social Planner template and every place the toolkit writes or documents it.
When it drifts, the founder's import fails at the 23 September clinic, in a room of 130 people, with an unhelpful GoHighLevel error.

**Design first.** One fixture is the truth: `plugins/growth-engine/assets/ghl/social-planner-template.csv`, committed verbatim from the GoHighLevel in-app Social Planner CSV download.
That download is PRD spike S-03, defined at `/Users/pmudh/Documents/GitHub/Atlanta/planning/PRD-growth-engine-v1.md` and answered in `/Users/pmudh/Documents/GitHub/Atlanta/planning/spike-findings.md`.
As of 21 August 2026 the S-03 section of `spike-findings.md` is still PENDING and the fixture file does not exist, so V-08 fails loudly until someone with a GoHighLevel login does the download.
That failure is correct: there is no honest way to check a CSV header against a template nobody has looked at.
Every file that restates the header marks it with an HTML comment so it can be extracted without guessing.

```markdown
<!-- csv-header -->
```
account,content,scheduled_date,media_url
```
```

**Shell.**

```bash
head_ "CSV header"

FIX="$PLUGIN/assets/ghl/social-planner-template.csv"
if [ ! -f "$FIX" ]; then
  err "no CSV fixture at $(echo "$FIX" | rel). Commit the real GHL Social Planner template download → run: answer spike S-03 in planning/spike-findings.md, then commit the download"
else
  head -1 "$FIX" | tr -d '\r' > "$TMP/header.truth"
  DECLARERS=$(grep -rl '<!-- csv-header -->' "$PLUGIN" "$REPO/tests" 2>/dev/null || true)
  for d in $DECLARERS; do
    awk '/<!-- csv-header -->/{f=1;next} f&&/^```/{if(seen){exit}else{seen=1;next}} f&&seen{print;exit}' "$d" \
      | tr -d '\r' > "$TMP/header.claim"
    if cmp -s "$TMP/header.truth" "$TMP/header.claim"; then
      ok "CSV header matches the fixture in $(echo "$d" | rel)"
    else
      err "CSV header in $(echo "$d" | rel) does not match assets/ghl/social-planner-template.csv"
      show "fixture: $(cat "$TMP/header.truth")"
      show "file:    $(cat "$TMP/header.claim")"
    fi
  done
  [ -z "$DECLARERS" ] && warn "no file declares the CSV header with <!-- csv-header -->. schemas/csv.md and content-engine should"
fi
```

**Prove it.**
Change one column name in `schemas/csv.md` inside the marked block.
Validate prints both rows side by side and fails.
Restore, green.
Then change the fixture itself and confirm every declarer goes red at once, which is the behaviour you want when GoHighLevel changes the template.

---

#### V-09. The zip carries no skills

**Catches.** Version skew between the plugin (which is the sole skill carrier) and the downloadable Launchhouse folder.
Today `scripts/build-folder.sh` copies `skills/` and `commands/` into `dist/Launchhouse/.claude/`.
Confirmed on 21 August 2026 at lines 31 and 32 of `/Users/pmudh/Documents/GitHub/Atlanta/scripts/build-folder.sh`, which read `cp -R "$PLUGIN/skills"   "$STAGE/.claude/skills"` and `cp -R "$PLUGIN/commands" "$STAGE/.claude/commands"`.
PRD task D-03, in `/Users/pmudh/Documents/GitHub/Atlanta/planning/PRD-growth-engine-v1.md`, stops that: the plugin becomes the sole skill carrier and the zip becomes READ-ME-FIRST plus CLAUDE.md plus a seeded `growth-engine/` folder plus VERSION.
Without a guard, someone restores the copy while fixing something else and 130 founders end up running a stale duplicate of every skill.

**Shell.**

```bash
head_ "Launchhouse folder"

if [ -x "$REPO/scripts/build-folder.sh" ]; then
  ( cd "$REPO" && bash scripts/build-folder.sh >"$TMP/build.out" 2>&1 ) || {
    err "build-folder.sh failed"; show "$(tail -5 "$TMP/build.out")"; }

  for forbidden in ".claude/skills" ".claude/commands" "SKILL.md"; do
    if [ -e "$REPO/dist/Launchhouse/$forbidden" ] \
       || find "$REPO/dist/Launchhouse" -name "$forbidden" -print -quit 2>/dev/null | grep -q .; then
      err "the Launchhouse zip stages '$forbidden'. The plugin is the only skill carrier. → run: edit scripts/build-folder.sh, remove the cp -R of skills and commands"
    else
      ok "zip stage carries no $forbidden"
    fi
  done

  if command -v unzip >/dev/null 2>&1 && [ -f "$REPO/dist/Launchhouse.zip" ]; then
    if unzip -l "$REPO/dist/Launchhouse.zip" | grep -qE '\.claude/(skills|commands)/'; then
      err "the built zip itself contains skills or commands"
    else
      ok "built zip contains no skills or commands"
    fi
  fi

  # The zip must still carry the four things it is for.
  for required in "READ-ME-FIRST.md" "CLAUDE.md" "VERSION" "growth-engine"; do
    [ -e "$REPO/dist/Launchhouse/$required" ] && ok "zip carries $required" \
      || err "zip is missing $required"
  done
fi
```

**Prove it.**
This proof runs in the opposite direction from the others, because the defect is present today and the fix removes it.
First land PRD task D-03 and confirm green.
Then re-add the line `cp -R "$PLUGIN/skills" "$STAGE/.claude/skills"` to `/Users/pmudh/Documents/GitHub/Atlanta/scripts/build-folder.sh`.
Validate goes red on all three forbidden patterns and on the zip listing.
Remove it, green.
Confirm the four `required` checks stay green throughout, so the guard cannot be satisfied by producing an empty zip.

---

#### V-10. Trigger phrase sync between README and skill descriptions

**Catches.** The README's "Or just say" column promising a plain language phrase that no skill description contains, so the phrase does not route.
This is the alternative path for every founder who will not type a slash command, which on a cohort of 130 non technical founders is most of them.

**Design first.** The README table row format is fixed, and matches the table already at lines 30 to 41 of `/Users/pmudh/Documents/GitHub/Atlanta/README.md`:

```
| `/growth-engine:<cmd>` | "phrase one" or "phrase two" | description |
```

The command file names its skill with the phrase `Use the <skill> skill.`
Match it case-insensitively.
Checked on 21 August 2026: eight of the ten command files write `Use the`, and `plugins/growth-engine/commands/engine2.md` writes `use the` in lower case at lines 7 and 8 because the phrase sits mid-sentence after a track condition.
A case-sensitive pattern silently treats `engine2` as routing nowhere, which is the opposite of what is true.
`engine2.md` is the one router that names two skills, so the check requires the phrase to appear in at least one of them.

**Shell.**

```bash
head_ "Trigger phrase sync"

# Step 1: flatten the README command table into one "cmd<TAB>phrase" line per
# quoted phrase. Done entirely in awk. An earlier draft used sed with \x01 as a
# field separator, which is a GNU sed extension: BSD sed on macOS treats it as a
# literal 'x01' and the whole check silently matches nothing.
awk -F'|' '
  $2 ~ /`\/growth-engine:/ {
    cmd = $2
    sub(/.*growth-engine:/, "", cmd)
    sub(/`.*/, "", cmd)
    gsub(/[ \t]/, "", cmd)
    n = split($3, part, "\"")
    for (i = 2; i <= n; i += 2) {
      if (part[i] != "") printf "%s\t%s\n", cmd, part[i]
    }
  }
' "$REPO/README.md" > "$TMP/pairs.tsv"

# Step 2: check each pair.
#
# TWO TRAPS, BOTH VERIFIED THE HARD WAY ON 21 AUGUST 2026:
#
# 1. Do NOT write `while IFS="$TAB" read -r cmd phrase`. The narrowed IFS leaks
#    into the loop body in real shells, so the later `for t in $targets` then
#    splits on tabs instead of on whitespace and every target arrives with a
#    trailing space glued to it. The path "skills/setup /SKILL.md" does not
#    exist, every lookup misses, and the check reports that every phrase in the
#    README is broken. Split the line with parameter expansion instead and leave
#    IFS at its default throughout.
# 2. The loop reads from a file, not from a pipe. A while loop on the right of a
#    pipe runs in a subshell and everything it writes to a variable is lost.
TAB=$(printf '\t')
: > "$TMP/trigger.out"
while read -r line; do
  [ -n "$line" ] || continue
  cmd=${line%%"$TAB"*}
  phrase=${line#*"$TAB"}
  cf="$PLUGIN/commands/$cmd.md"
  if [ ! -f "$cf" ]; then
    printf 'MISSINGCMD %s\n' "$cmd" >> "$TMP/trigger.out"
    continue
  fi
  # Case-insensitive: engine2.md writes "use the" in lower case, mid-sentence.
  targets=$(grep -oiE '(use|run) the [a-z][a-z0-9-]* skill' "$cf" \
            | sed -e 's/^[Uu]se the //' -e 's/^[Rr]un the //' -e 's/ skill$//' \
            | sort -u)
  if [ -z "$targets" ]; then
    printf 'NOROUTE %s\n' "$cmd" >> "$TMP/trigger.out"
    continue
  fi
  hit=0
  for t in $targets; do
    grep -m1 '^description:' "$PLUGIN/skills/$t/SKILL.md" 2>/dev/null \
      | grep -qiF "$phrase" && hit=1
  done
  [ "$hit" -eq 1 ] \
    || printf 'MISS %s|%s|%s\n' "$cmd" "$phrase" "$(echo $targets | tr '\n' ' ')" \
       >> "$TMP/trigger.out"
done < "$TMP/pairs.tsv"

if grep -qE '^MISS|^NOROUTE|^MISSINGCMD' "$TMP/trigger.out"; then
  err "README promises a plain-language phrase that the routed skill's description does not carry, so it will not trigger:"
  show "$(cat "$TMP/trigger.out")"
else
  ok "every README trigger phrase appears in the routed skill's description"
fi
```

**This check is already red, and that is the finding.**

The block above was run against the repo as it stands on 21 August 2026, using `/Users/pmudh/Documents/GitHub/Atlanta/README.md` and the ten files in `plugins/growth-engine/commands/`.
It produced five entries, every one of them a real disagreement between what the README promises a founder can say and what the routed skill's description will actually trigger on:

```
MISS     engine2  | build my outreach engine  | audience-b2c outreach-b2b
MISS     engine2  | build my audience engine  | audience-b2c outreach-b2b
MISS     ops      | find my bottleneck        | ghl-workflows
MISS     playbook | generate my playbook insert | playbook-export
NOROUTE  gate
```

Read them one at a time.

`engine2`: the README offers "build my outreach engine" and "build my audience engine".
`skills/outreach-b2b/SKILL.md` triggers on "build my outreach", without the word engine.
The founder who reads the README literally and types the longer phrase is relying on a substring match that the description does not guarantee.

`ops`: the README offers "find my bottleneck".
That exact phrase is not in the `ghl-workflows` description.

`playbook`: the README offers "generate my playbook insert".
That exact phrase is not in the `playbook-export` description.
Note this one is DEFERRED scope, so it is fixed by editing the README row rather than by touching the skill.

`gate`: `plugins/growth-engine/commands/gate.md` contains no `Use the <skill> skill` line at all.
It routes to nothing.
`/growth-engine:gate` is one of the ten shipped commands and it is on the founder's homework path for all three gates.
This is the most serious of the five and it is invisible to the current validator, because check EX-16 only verifies that a named skill exists, never that a skill is named.
Check V-19's second half catches it from the other direction.

Fix all five before the 3 September freeze.
Each one is fixable from either side: change the README phrase to match the description, or add the phrase to the description.
The check does not decide which side is right.
It refuses to let them disagree.

**Prove it.**
Once the five above are cleared and the check is green, plant a sixth:

```sh
cd /Users/pmudh/Documents/GitHub/Atlanta
sed -i.bak 's/"build my content engine"/"build my content machine"/' README.md
bash scripts/validate.sh ; echo "exit=$?"
mv README.md.bak README.md
bash scripts/validate.sh ; echo "exit=$?"
```

Expect the middle run to print `MISS content|build my content machine|content-engine` under a FAIL line, with `exit=1`, and the final run to print `ok    every README trigger phrase appears in the routed skill's description` with `exit=0`.

---

#### V-11. Schema examples lint clean, and the deliberately broken ones do not

**Catches.** A schema document that describes a format `ge` does not actually accept, or a `ge lint` that has quietly stopped enforcing a rule.
This is the check that keeps `schemas/*.md` honest, because a human readable contract nobody executes is a wish.

**Design first.** Every file under `plugins/growth-engine/schemas/` carries at least one valid example and at least one invalid example, each marked:

```markdown
<!-- example:valid file=ledger.md -->
```
C|001|1|post|text|draft|-|-
```

<!-- example:invalid file=ledger.md expect=enum -->
```
C|002|1|post|text|halfdone|-|-
```
```

**Shell.**

```bash
head_ "Schema examples"

GE="$PLUGIN/bin/ge"
if [ ! -x "$GE" ]; then
  warn "bin/ge not present yet, schema example lint deferred"
else
  for sch in "$PLUGIN"/schemas/*.md; do
    [ -f "$sch" ] || continue
    # Each marked block becomes a one-file fixture folder, linted on its own.
    # The sandbox is named after the source line number, not an incrementing
    # counter: this while loop is on the right of a pipe, so it runs in a
    # subshell and any counter it increments resets on the next schema file,
    # which would make two sandboxes collide and produce a false pass.
    grep -n '<!-- example:' "$sch" | while IFS=: read -r ln marker; do
      kind=$(printf '%s' "$marker" | sed 's/.*example:\([a-z]*\).*/\1/')
      target=$(printf '%s' "$marker" | sed -n 's/.*file=\([^ ]*\).*/\1/p')
      box="$TMP/schema.$(basename "$sch" .md).$ln"
      mkdir -p "$box/growth-engine/.state"
      printf '%s\n' "$box/growth-engine" > "$box/growth-engine/.state/HOME"
      awk -v start="$ln" 'NR>start && /^```/{f=!f; if(!f) exit; next} NR>start && f' "$sch" \
        > "$box/growth-engine/$target"
      if "$GE" lint --root "$box/growth-engine" >"$box/lint.out" 2>&1; then res=pass; else res=fail; fi
      case "$kind:$res" in
        valid:fail)   printf 'BADVALID %s:%s\n' "$sch" "$ln" ;;
        invalid:pass) printf 'BADINVALID %s:%s\n' "$sch" "$ln" ;;
      esac
    done
  done > "$TMP/schema.out"

  if [ -s "$TMP/schema.out" ]; then
    err "schema examples disagree with ge lint. A valid example failed, or an invalid example passed:"
    show "$(cat "$TMP/schema.out")"
  else
    ok "every schema example lints as declared"
  fi
fi
```

Note the direction of the second half.
Most people write only the happy path fixture, which proves the linter runs and proves nothing about whether it enforces anything.
The `invalid:pass` case is the one that catches a linter that has been accidentally neutered.

**Prove it.**
Comment out the ledger enum validation inside `ge lint`.
Validate reports `BADINVALID schemas/ledger.md:<line>` and fails.
Restore the validation, green.
Separately, change the valid ledger example to have seven fields instead of eight and confirm `BADVALID` fires.

---

#### V-12. Snapshot before write, per skill

**Catches.** A skill that overwrites a founder file with no undo.
The design rule is fail closed: no snapshot means no write.
That rule is enforced inside `ge`, but a skill can bypass `ge` entirely by telling Claude to write the file directly, which is exactly what all nine skills do today.

**Design first.** One declared map at `plugins/growth-engine/schemas/writers.md`, one row per founder file:

```
founder-brain.md|founder-brain|ge snapshot
content-30.md|content-engine|ge snapshot
content-30.csv|content-engine|ge snapshot
ledger.md|ge ledger|internal
ops-log.md|ge log|append-only
90-day-plan.md|growth-plan|ge snapshot
playbook-insert.md|playbook-export|DEFERRED
```

**Shell.**

```bash
head_ "Snapshot-first"

MAP="$PLUGIN/schemas/writers.md"
if [ -f "$MAP" ]; then
  grep -E '^[a-z0-9.-]+\|' "$MAP" | while IFS='|' read -r file skill mode; do
    case "$mode" in
      internal|append-only|DEFERRED) continue ;;
    esac
    sk="$PLUGIN/skills/$skill/SKILL.md"
    [ -f "$sk" ] || { printf 'NOSKILL %s %s\n' "$file" "$skill"; continue; }
    grep -q "ge snapshot $file" "$sk" || printf 'NOSNAP %s %s\n' "$file" "$skill"
    # Exactly one skill may claim a file.
    others=$(grep -rl "writes \`$file\`" "$PLUGIN/skills" 2>/dev/null | grep -v "/$skill/" || true)
    [ -n "$others" ] && printf 'TWOWRITERS %s %s\n' "$file" "$others"
  done > "$TMP/writers.out"

  if [ -s "$TMP/writers.out" ]; then
    err "a skill overwrites a founder file without ge snapshot, or two skills claim one file:"
    show "$(cat "$TMP/writers.out")"
  else
    ok "every founder file has one writer and a snapshot-first instruction"
  fi
else
  warn "no schemas/writers.md yet. One writer per file is unenforced until it exists"
fi
```

**Prove it.**
Delete the line `ge snapshot content-30.md` from `skills/content-engine/SKILL.md`.
Validate reports `NOSNAP content-30.md content-engine` and fails.
Restore, green.
Then add "writes `content-30.md`" to `skills/growth-plan/SKILL.md` and confirm `TWOWRITERS` fires.

---

#### V-13. The cut list stays cut

**Catches.** A rewrite quietly reintroducing something Juan removed from scope on 21 August 2026.
Scope decisions decay fastest when they are only recorded in a conversation, and this one carries platform-policy weight: nothing in this code sends a direct message.

**Exactly what was cut, so the check is not guessed at.**

- The `dm-inbox` skill. Claude never reads the founder's inbox and never drafts a DM reply.
- `ge dmgate`, which is PRD task B-07, and all of the Meta 24-hour user-initiated window arithmetic that went with it.
- `commands/inbox.md`.
- PRD spike section S-04, the conversations spike.
- PRD task G2-02.
- Three GoHighLevel Private Integration Token scopes that were previously requested and are now withdrawn: `conversations.readonly`, `conversations/message.readonly`, `conversations/message.write`.

**Exactly what is NOT cut, and must never be flagged by this check.**

Comment-to-DM capture, and DM qualify-and-book, are both IN.
They ship as GoHighLevel workflows inside the three snapshots, and Claude writes the copy that goes inside those workflows as namespaced custom values.
The founder reads and replies in the GoHighLevel app.
The distinction is the whole point of the cut: the automation lives in GoHighLevel where Meta's rules are GoHighLevel's problem, and our code writes text files.
So `comment-to-DM`, `comment to DM`, `qualify and book` and `ops-workflow.md` are all expected strings in `plugins/growth-engine/skills/ghl-workflows/SKILL.md`, and the `CUT_STRINGS` pattern below is deliberately written not to match any of them.
If someone later widens that pattern to something like `DM` on its own, it will start failing on legitimate in-scope material, which is worse than useless.

**Shell.**

```bash
head_ "Cut scope"

CUT_FILES="skills/dm-inbox commands/inbox.md"
for c in $CUT_FILES; do
  [ -e "$PLUGIN/$c" ] && err "$c is cut scope and exists on disk. → run: git rm -r plugins/growth-engine/$c" \
                      || ok "$c absent, as scoped"
done

CUT_STRINGS='ge dmgate|dm-inbox|dmgate|24-hour window|24 hour window|inbox skill'
CUT_HITS=$(grep -rInE "$CUT_STRINGS" "$PLUGIN" "$REPO/README.md" "$REPO/docs" 2>/dev/null \
  | grep -viE 'we do not|never|is not built|removed|not included' || true)
if [ -n "$CUT_HITS" ]; then
  err "shipped material references cut scope. Claude never reads the founder inbox and never sends a DM:"
  show "$CUT_HITS"
else
  ok "no shipped file references the DM inbox, dmgate, or the 24-hour window"
fi

# The positive half: comment-to-DM is IN and must still be described somewhere.
# Without this, deleting ghl-workflows entirely would pass every check above.
WF="$PLUGIN/skills/ghl-workflows/SKILL.md"
if [ -f "$WF" ]; then
  grep -qiE 'comment[ -]to[ -]DM' "$WF" \
    && ok "ghl-workflows still describes comment-to-DM capture, which is in scope" \
    || err "ghl-workflows no longer describes comment-to-DM capture. It is IN scope: it runs as a GHL workflow with Claude-written copy"
  grep -qiE 'qualif' "$WF" \
    && ok "ghl-workflows still describes DM qualify-and-book, which is in scope" \
    || err "ghl-workflows no longer describes DM qualify-and-book. It is IN scope, as a GHL workflow"
else
  err "plugins/growth-engine/skills/ghl-workflows/SKILL.md is missing. Back-end ops is one of the four delivered systems"
fi

SENDS=$(grep -rInE 'conversations_send-a-new-message|send-a-new-message' "$PLUGIN" 2>/dev/null || true)
if [ -n "$SENDS" ]; then
  err "a shipped file names a message-sending MCP tool. Our code never sends a DM:"
  show "$SENDS"
else
  ok "no message-sending tool named anywhere in the plugin"
fi
```

**Prove it.**
Three planted defects, run one at a time from `/Users/pmudh/Documents/GitHub/Atlanta`.

File half:

```sh
cd /Users/pmudh/Documents/GitHub/Atlanta
: > plugins/growth-engine/commands/inbox.md
bash scripts/validate.sh ; echo "exit=$?"
rm -f plugins/growth-engine/commands/inbox.md
bash scripts/validate.sh ; echo "exit=$?"
```

Expect the first run to print `FAIL  commands/inbox.md is cut scope and exists on disk.` followed by the `git rm` recovery line, with `exit=1`, and the second run to print `ok    commands/inbox.md absent, as scoped` with `exit=0`.

String half:

```sh
cd /Users/pmudh/Documents/GitHub/Atlanta
printf '\nThis skill calls dmgate before sending.\n' >> plugins/growth-engine/skills/status/SKILL.md
bash scripts/validate.sh ; echo "exit=$?"
```

Expect `FAIL  shipped material references cut scope.` naming that file and line.
Remove the planted line before doing anything else.

Positive half, which is the one people forget to test:

```sh
cd /Users/pmudh/Documents/GitHub/Atlanta
cp plugins/growth-engine/skills/ghl-workflows/SKILL.md /tmp/wf.keep
grep -iv 'comment-to-dm' /tmp/wf.keep > plugins/growth-engine/skills/ghl-workflows/SKILL.md
bash scripts/validate.sh ; echo "exit=$?"
cp /tmp/wf.keep plugins/growth-engine/skills/ghl-workflows/SKILL.md && rm -f /tmp/wf.keep
```

Expect `FAIL  ghl-workflows no longer describes comment-to-DM capture. It is IN scope` on the middle run.
A check that only ever proves an absence will happily pass an empty repo.

---

#### V-14. The PIT scope list is stated exactly, everywhere

**Catches.** A founder creating a Private Integration Token with the wrong scopes at Session 2, then hitting a 401 on the first publish with no way to tell which scope is missing.
Also catches the three removed conversation scopes creeping back in, which would be asking 130 founders for inbox permissions the toolkit does not use.

**Design first.** One fixture, `plugins/growth-engine/assets/ghl/pit-scopes.txt`, one scope per line, exactly seven lines:

```
socialplanner/post.readonly
socialplanner/post.write
socialplanner/account.readonly
socialplanner/statistics.readonly
contacts.readonly
contacts.write
locations.readonly
```

**Shell.**

```bash
head_ "PIT scopes"

SCOPES="$PLUGIN/assets/ghl/pit-scopes.txt"
if [ ! -f "$SCOPES" ]; then
  err "no assets/ghl/pit-scopes.txt. The scope list has no single source"
else
  # grep -c '' counts lines including a final line with no trailing newline.
  # wc -l counts newline characters, so a file whose last line is unterminated
  # reports 6 for a 7-scope fixture and this check fails for the wrong reason.
  NSCOPES=$(grep -c '' "$SCOPES")
  [ "$NSCOPES" -eq 7 ] && ok "scope fixture has 7 lines" \
    || err "scope fixture must have exactly 7 lines, has $NSCOPES. → run: check assets/ghl/pit-scopes.txt for a missing or duplicated scope"

  BANNED_SCOPES='conversations\.readonly|conversations/message\.readonly|conversations/message\.write'
  BS=$(grep -rInE "$BANNED_SCOPES" "$PLUGIN" "$REPO/docs" "$REPO/README.md" 2>/dev/null || true)
  [ -n "$BS" ] && { err "a removed conversations scope is still requested somewhere:"; show "$BS"; } \
                || ok "no conversations scopes requested"

  # Every doc that lists scopes must list all seven and nothing else.
  for d in $(grep -rl 'socialplanner/post.write' "$PLUGIN" "$REPO/docs" 2>/dev/null); do
    missing=""
    while IFS= read -r s; do
      grep -qF "$s" "$d" || missing="$missing $s"
    done < "$SCOPES"
    [ -n "$missing" ] && err "$(echo "$d" | rel) lists scopes but omits:$missing" \
                      || ok "$(echo "$d" | rel) lists all seven scopes"
  done
fi
```

**Prove it.**
`docs/CONNECTIONS.md` is created by PRD task SS-01 and does not exist as of 21 August 2026, so until it lands, plant the strings in `plugins/growth-engine/assets/ghl/README.md`, which does exist and is already inside the `$PLUGIN` grep root.

Banned-scope half:

```sh
cd /Users/pmudh/Documents/GitHub/Atlanta
printf '\nAlso request conversations.readonly.\n' >> plugins/growth-engine/assets/ghl/README.md
bash scripts/validate.sh ; echo "exit=$?"
```

Expect `FAIL  a removed conversations scope is still requested somewhere:` naming the file and line, and `exit=1`.
Remove the planted line.

Omission half:

```sh
cd /Users/pmudh/Documents/GitHub/Atlanta
cp plugins/growth-engine/assets/ghl/pit-scopes.txt /tmp/scopes.keep
grep -v '^contacts.write$' /tmp/scopes.keep > plugins/growth-engine/assets/ghl/pit-scopes.txt
bash scripts/validate.sh ; echo "exit=$?"
cp /tmp/scopes.keep plugins/growth-engine/assets/ghl/pit-scopes.txt && rm -f /tmp/scopes.keep
```

Expect `FAIL  scope fixture must have exactly 7 lines, has 6` on the middle run.
Then restore the fixture and instead delete the line `contacts.write` from a document that lists the scopes, and expect `FAIL  <file> lists scopes but omits: contacts.write`.

Note that the fixture is exactly seven lines and the phrase "six scopes" appears nowhere.
Four of the seven are Social Planner scopes, two are contacts scopes, one is locations.
Anyone counting families rather than strings will say six, and a founder typing six strings into the GoHighLevel Private Integration Token screen gets a 401 on the first publish.
Seven strings, exactly as listed.

---

#### V-15. Apollo enrolment stays paused, and cold email never touches GoHighLevel

**Catches.** The two commercial rules that carry the most risk if a rewrite loses them.

**Shell.**

```bash
head_ "Outbound rules"

OB="$PLUGIN/skills/outreach-b2b/SKILL.md"
if [ ! -f "$OB" ]; then
  err "plugins/growth-engine/skills/outreach-b2b/SKILL.md is missing. Outbound B2B is one of the four delivered systems. → run: git log --diff-filter=D -- plugins/growth-engine/skills/outreach-b2b/"
else
  grep -qi 'paused' "$OB" && ok "outreach-b2b names paused enrolment" \
    || err "outreach-b2b no longer says enrolment lands paused. Rule 3 is gone"
  BADACT=$(grep -niE 'activate (the )?sequence (automatically|for (you|them))|auto-activate|start sending' "$OB" || true)
  [ -n "$BADACT" ] && { err "outreach-b2b implies automatic activation:"; show "$BADACT"; } \
                   || ok "activation stays the founder's explicit act"

  # Opt-out in every cold email touch.
  #
  # TWO IDIOMS THAT LOOK RIGHT AND ARE NOT:
  # 1. `grep -c` already prints 0 when it matches nothing, and exits 1 while
  #    doing so. `$(grep -c ... || echo 0)` therefore captures the two-line
  #    string "0" newline "0", and the arithmetic test that follows is a shell
  #    syntax error rather than a comparison. Use `|| true`.
  # 2. Counting opt-out lines and comparing that count against the touch count
  #    assumes the skill repeats the opt-out sentence per touch. It does not.
  #    Checked on 21 August 2026: the current skill states the rule once, at
  #    line 63, as an instruction covering every touch. Counting would fail a
  #    correct file. Check for the instruction, not for N copies of a sentence.
  #
  # The touch headings are bullets in the current file, not markdown headings,
  # so the pattern accepts both forms.
  TOUCHES=$(grep -cE '^([-*] |#+ )Touch [0-9]' "$OB" 2>/dev/null || true)
  [ -n "$TOUCHES" ] || TOUCHES=0
  if [ "$TOUCHES" -lt 4 ]; then
    err "outreach-b2b names $TOUCHES touches. The sequence is four to five touches. → run: read plugins/growth-engine/skills/outreach-b2b/SKILL.md and restore the touch list"
  else
    ok "outreach-b2b names $TOUCHES touches"
  fi

  if grep -qiE '(opt[ -]?out|unsubscribe).{0,80}every touch|every touch.{0,80}(opt[ -]?out|unsubscribe)' "$OB"; then
    ok "outreach-b2b requires an opt-out line in every touch"
  else
    err "outreach-b2b no longer requires an opt-out line in every cold-email touch. → run: restore the sentence that scopes the opt-out to every touch, not to the sequence as a whole"
  fi
fi

# Cold email never routes through GHL.
GHLMAIL=$(grep -rInE '(cold email|sequence|outreach).{0,60}(GoHighLevel|GHL)' "$PLUGIN" 2>/dev/null \
  | grep -viE 'never|not through|does not' || true)
[ -n "$GHLMAIL" ] && { err "cold email appears to route through GoHighLevel, which it must never do:"; show "$GHLMAIL"; } \
                  || ok "cold email never routes through GoHighLevel"
```

**Prove it.**
Establish the baseline first, because this check was written against the file as it stands on 21 August 2026, which uses bullet touch headings at lines 52 to 56 and states the opt-out rule once at line 63:

```sh
cd /Users/pmudh/Documents/GitHub/Atlanta
grep -cE '^([-*] |#+ )Touch [0-9]' plugins/growth-engine/skills/outreach-b2b/SKILL.md
grep -niE 'opt.out' plugins/growth-engine/skills/outreach-b2b/SKILL.md
```

Expect `5` from the first command and a hit at line 63 from the second.

Now plant the defect:

```sh
cd /Users/pmudh/Documents/GitHub/Atlanta
cp plugins/growth-engine/skills/outreach-b2b/SKILL.md /tmp/ob.keep
grep -vi 'opt-out line in the body of every touch' /tmp/ob.keep \
  > plugins/growth-engine/skills/outreach-b2b/SKILL.md
bash scripts/validate.sh ; echo "exit=$?"
cp /tmp/ob.keep plugins/growth-engine/skills/outreach-b2b/SKILL.md && rm -f /tmp/ob.keep
bash scripts/validate.sh ; echo "exit=$?"
```

Expect the middle run to print `FAIL  outreach-b2b no longer requires an opt-out line in every cold-email touch.` with `exit=1`, and the final run to print `ok    outreach-b2b requires an opt-out line in every touch` with `exit=0`.

Then prove the touch-count half separately by deleting the `Touch 4` and `Touch 5` bullets and confirming `FAIL  outreach-b2b names 3 touches.` fires.

---

#### V-16. No automated Instagram or Facebook direct messages

**Catches.** Design rule 1, which is the one that gets founder accounts restricted.
The existing EX-24 is a WARN that asks a human to read the lines.
It stays, because context matters, but the unambiguous forms become a FAIL.

**Shell.**

```bash
head_ "DM automation"

HARD=$(grep -rInE '(automat[a-z]*|bulk|mass|schedul[a-z]*)[[:space:]-]{0,3}(cold[[:space:]-]{0,3})?DMs?|DM[[:space:]-]{0,3}(automation|bot|blast)' \
  $(founder_files) 2>/dev/null \
  | grep -viE 'never|do not|don.t|refuse|not automate|by hand|manually|gets accounts restricted' || true)
if [ -n "$HARD" ]; then
  err "a line reads as offering automated DMs. The 25 openers are sent by hand, always:"
  show "$HARD"
else
  ok "no line offers automated DMs"
fi

AB="$PLUGIN/skills/audience-b2c/SKILL.md"
if [ -f "$AB" ]; then
  grep -qiE 'by hand|manually|you send (these|them) yourself' "$AB" \
    && ok "audience-b2c states the openers are sent by hand" \
    || err "audience-b2c no longer states that the 25 openers are sent by hand"
fi
```

**Prove it.**

```sh
cd /Users/pmudh/Documents/GitHub/Atlanta
printf '\nWe can schedule your DMs for you.\n' >> plugins/growth-engine/skills/audience-b2c/SKILL.md
bash scripts/validate.sh ; echo "exit=$?"
```

Expect `FAIL  a line reads as offering automated DMs. The 25 openers are sent by hand, always:` and `exit=1`.
Then replace that planted line with `You send these by hand, 5 a day.` and rerun, expecting `ok    no line offers automated DMs` and `exit=0`.

```sh
cd /Users/pmudh/Documents/GitHub/Atlanta
sed -i.bak '$d' plugins/growth-engine/skills/audience-b2c/SKILL.md && rm -f plugins/growth-engine/skills/audience-b2c/SKILL.md.bak
bash scripts/validate.sh ; echo "exit=$?"
```

---

#### V-17. Style coverage widened, the dash check made locale-safe, and one sentence per line

**Catches.** Three gaps in the current style enforcement.

First, `CHANGELOG.md` is founder readable (the update command shows it) but `founder_files()` in `/Users/pmudh/Documents/GitHub/Atlanta/scripts/validate.sh` does not include it, so no style rule reaches it.

Second, and this one is a live defect rather than a gap, the existing EX-21 dash check is written as a bracket expression containing two multi-byte characters:

```bash
DASHES=$(grep -rn '[<EM><EN>]' $(founder_files) 2>/dev/null || true)
```

where `<EM>` is U+2014 and `<EN>` is U+2013.
In a UTF-8 locale that behaves as intended.
With `LANG` and `LC_ALL` unset, which is the state of a GitHub Actions ubuntu runner and of many terminals, `grep` treats the brackets as a set of raw bytes: `0xE2`, `0x80`, `0x94`, `0x93`.
Every character in the U+2000 to U+27BF range begins `0xE2`, so the check then matches the arrow `U+2192` and every box-drawing character.
Verified on 21 August 2026 by running, from `/Users/pmudh/Documents/GitHub/Atlanta`:

```sh
printf 'arrow \342\206\222 run\n' > /tmp/dashprobe.txt
LC_ALL=C  grep -c '[<EM><EN>]' /tmp/dashprobe.txt   # prints 1, a false positive
LC_ALL=en_US.UTF-8 grep -c '[<EM><EN>]' /tmp/dashprobe.txt   # prints 0, correct
rm -f /tmp/dashprobe.txt
```

It does not fire today only because no founder-facing `.md` file currently contains an arrow.
The code standard requires every error message to end with an arrow and a recovery line, and section 4 of this document requires those recovery lines to be documented, so the first founder-facing file that quotes one will produce a FAIL that names an em dash which is not there.
Fix it by matching the exact byte sequences instead of a bracket set.

Third, the one sentence per physical line rule for long markdown is written down nowhere executable.

**Shell.** This block replaces the existing EX-21 body as well as adding new coverage.

```bash
head_ "Style coverage"

# Match the exact UTF-8 byte sequences for U+2014 and U+2013.
# Doing it this way is locale-proof: a bracket expression containing the
# characters themselves degrades into a byte set when LANG is unset, and
# then matches every arrow and every box-drawing character.
EMDASH=$(printf '\342\200\224')
ENDASH=$(printf '\342\200\223')

DASHES=$(grep -rn -e "$EMDASH" -e "$ENDASH" $(founder_files) "$REPO/CHANGELOG.md" 2>/dev/null || true)
if [ -n "$DASHES" ]; then
  err "em dash or en dash in a founder-facing file. Break the sentence, or use a comma, colon or brackets:"
  show "$DASHES"
else
  ok "no em or en dashes in any founder-facing file"
fi

# One sentence per line, warn-only: a prose line with a sentence boundary mid-line.
MULTI=$(grep -rnE '[a-z][.!?][[:space:]]+[A-Z]' $(founder_files) 2>/dev/null \
  | grep -vE '\|' | grep -vE '^\s*[0-9]+\.' | grep -viE 'e\.g\.|i\.e\.|Mr\.|vs\.' || true)
if [ -n "$MULTI" ]; then
  warn "two sentences on one physical line. Long markdown is one sentence per line for diff precision:"
  show "$MULTI"
else
  ok "founder-facing prose is one sentence per line"
fi

# Ranges must be written with "to", never a hyphen between numbers.
RANGE=$(grep -rnE '[0-9]+[[:space:]]*-[[:space:]]*[0-9]+' $(founder_files) 2>/dev/null \
  | grep -viE 'utf-8|iso-8859|http|v[0-9]|[0-9]-[0-9]{4}' || true)
[ -n "$RANGE" ] && { err "numeric range written with a hyphen. Write '11 to 13':"; show "$RANGE"; } \
                || ok "numeric ranges written with 'to'"
```

The sentence check is warn only on purpose.
Tables, lists and code will produce false positives, and a warn keeps it useful without teaching the executor to ignore red.
If false positives run above roughly five per run, tighten the filter rather than deleting the check.

**Prove it.**
Three separate proofs, because this check has three halves.

Range half: write `11-13 founders` into `/Users/pmudh/Documents/GitHub/Atlanta/README.md`.
Run `bash scripts/validate.sh` from `/Users/pmudh/Documents/GitHub/Atlanta`.
Validate goes red on the range check.
Change it to `11 to 13 founders`, rerun, green.

Dash half, correctness: add a real em dash to `/Users/pmudh/Documents/GitHub/Atlanta/README.md`.
Validate goes red.
Remove it, green.

Dash half, locale safety: add the line `  ge init failed. Arrow then run: ge init` to `README.md`, with a real U+2192 arrow in place of the words "Arrow then", then run the validator twice:

```sh
cd /Users/pmudh/Documents/GitHub/Atlanta
LC_ALL=en_US.UTF-8 bash scripts/validate.sh ; echo "utf8 exit=$?"
env -u LANG -u LC_ALL bash scripts/validate.sh ; echo "no-locale exit=$?"
```

Both must exit with the same code, and neither may report a dash.
Under the current EX-21 implementation the second run reports a dash that does not exist.
Under this V-17 implementation both are clean.
That difference is the whole point of the change.

---

#### V-18. Counts become a declared manifest, not a magic number

**Catches.** A skill or command added or removed without anyone noticing, which today only produces a WARN with a hardcoded 9 and 10.
After the rewrite the numbers change, and a hardcoded number that is now wrong is worse than no check because it trains people to ignore the warning.

**Design first.** `plugins/growth-engine/MANIFEST.txt`, one line per shipped skill and command, written by hand and reviewed like code.

**Read the list below as the target state after the locked-scope rewrite, not as today's disk.**
Today, verified on 21 August 2026 by `ls plugins/growth-engine/skills` and `ls plugins/growth-engine/commands`, the repo holds 9 skills (`audience-b2c`, `content-engine`, `founder-brain`, `ghl-workflows`, `growth-plan`, `outreach-b2b`, `playbook-export`, `setup`, `status`) and 10 commands (`brain`, `content`, `doctor`, `engine2`, `gate`, `ops`, `plan`, `playbook`, `setup`, `status`).
The target adds the `connect` and `ghl-publish` skills and the `connect`, `publish`, `undo` and `update` commands.
When you create `MANIFEST.txt`, seed it from disk with the generator in the shell block below, then edit it to the target as each new skill or command actually lands.
Declaring something that does not exist yet makes the check red every day until it does, which is noise, not a gate.

```
# MANIFEST.txt: the declared contents of the plugin, post-rewrite target.
# One line per skill directory and per command file. Sorted. No blank lines.
skill:setup
skill:founder-brain
skill:content-engine
skill:ghl-publish
skill:connect
skill:outreach-b2b
skill:audience-b2c
skill:ghl-workflows
skill:growth-plan
skill:playbook-export
skill:status
command:setup
command:doctor
command:brain
command:connect
command:content
command:publish
command:engine2
command:ops
command:plan
command:gate
command:status
command:undo
command:update
command:playbook
```

**Shell.**

```bash
head_ "Manifest agreement"

MF="$PLUGIN/MANIFEST.txt"
if [ ! -f "$MF" ]; then
  err "no plugins/growth-engine/MANIFEST.txt. Skill and command counts are unpinned"
else
  { for d in "$PLUGIN"/skills/*/; do [ -d "$d" ] && echo "skill:$(basename "$d")"; done
    for f in "$PLUGIN"/commands/*.md; do [ -f "$f" ] && echo "command:$(basename "$f" .md)"; done
  } | sort > "$TMP/disk.txt"
  sort "$MF" | grep -v '^#' | grep -v '^$' > "$TMP/declared.txt"
  if diff -u "$TMP/declared.txt" "$TMP/disk.txt" > "$TMP/manifest.diff"; then
    ok "MANIFEST.txt matches disk exactly"
  else
    err "MANIFEST.txt and disk disagree. Adding a skill is a deliberate act, so declare it:"
    show "$(sed -n '4,20p' "$TMP/manifest.diff")"
  fi
fi
```

**Seed it from disk once**, so the first version is not typed from memory:

```sh
cd /Users/pmudh/Documents/GitHub/Atlanta
{
  printf '# MANIFEST.txt: the declared contents of the plugin.\n'
  printf '# One line per skill directory and per command file. Sorted. No blank lines.\n'
  for d in plugins/growth-engine/skills/*/; do
    [ -d "$d" ] && printf 'skill:%s\n' "$(basename "$d")"
  done
  for f in plugins/growth-engine/commands/*.md; do
    [ -f "$f" ] && printf 'command:%s\n' "$(basename "$f" .md)"
  done
} > plugins/growth-engine/MANIFEST.txt
cat plugins/growth-engine/MANIFEST.txt
```

Run against the repo as it stands on 21 August 2026 that produces 2 comment lines, 9 `skill:` lines and 10 `command:` lines.
Read it before committing it.

**Prove it.**

```sh
cd /Users/pmudh/Documents/GitHub/Atlanta
mkdir -p plugins/growth-engine/skills/scratch
printf -- '---\nname: scratch\ndescription: probe\n---\n' > plugins/growth-engine/skills/scratch/SKILL.md
bash scripts/validate.sh ; echo "exit=$?"
rm -rf plugins/growth-engine/skills/scratch
bash scripts/validate.sh ; echo "exit=$?"
```

Expect the middle run to print `FAIL  MANIFEST.txt and disk disagree.` with the diff line `+skill:scratch` shown beneath it, and `exit=1`.
Expect the final run to print `ok    MANIFEST.txt matches disk exactly` and `exit=0`.
The legitimate alternative resolution is to keep the directory and add `skill:scratch` to `MANIFEST.txt`, which is exactly the deliberate act the check exists to force.

---

#### V-19. Command routing check, corrected

**Catches.** The same thing EX-16 catches, without the false positive on "this skill" that will fire the first time someone writes a normal English sentence in a command file.

**Shell.** Replace the EX-16 loop body with the block below.
Note the `-i` on both greps: `plugins/growth-engine/commands/engine2.md` writes `use the` in lower case at lines 7 and 8, and a case-sensitive pattern would report that file as routing nowhere while it routes correctly.

```bash
  for ref in $(grep -oiE '(use|run) the [a-z][a-z0-9-]* skill' "$f" \
               | sed -e 's/^[Uu]se the //' -e 's/^[Rr]un the //' -e 's/ skill$//' \
               | sort -u); do
    [ -d "$PLUGIN/skills/$ref" ] \
      || err "commands/$cmd.md routes to skill '$ref', which does not exist. → run: ls plugins/growth-engine/skills"
  done
  grep -qiE '(use|run) the [a-z][a-z0-9-]* skill' "$f" \
    || err "commands/$cmd.md names no skill with the phrase 'Use the <skill> skill'. It routes nowhere. → run: add that sentence to plugins/growth-engine/commands/$cmd.md"
```

**The second half is already red.**
Run on 21 August 2026, `grep -inE '(use|run) the [a-z][a-z0-9-]* skill' plugins/growth-engine/commands/*.md` returns hits for `brain`, `content`, `doctor`, `engine2` (twice), `ops`, `plan`, `playbook`, `setup` and `status`, and no hit at all for `plugins/growth-engine/commands/gate.md`.
`/growth-engine:gate` therefore routes to no skill.
Fix that file before the freeze.

**Prove it.**
Three runs, all from `/Users/pmudh/Documents/GitHub/Atlanta`.

False-positive half, which is the reason this check is being changed at all:

```sh
cd /Users/pmudh/Documents/GitHub/Atlanta
printf '\nRead this skill before starting.\n' >> plugins/growth-engine/commands/ops.md
bash scripts/validate.sh ; echo "exit=$?"
```

Under the EX-16 pattern as it stands today this prints `FAIL  commands/ops.md routes to skill 'this', which does not exist` and `exit=1`, which is wrong: the sentence is ordinary English.
Under V-19 the same run is clean and `exit=0`.
Remove the planted line either way.

True-positive half, which must still fire under V-19:

```sh
cd /Users/pmudh/Documents/GitHub/Atlanta
printf '\nUse the nosuch skill.\n' >> plugins/growth-engine/commands/ops.md
bash scripts/validate.sh ; echo "exit=$?"
sed -i.bak '$d' plugins/growth-engine/commands/ops.md && rm -f plugins/growth-engine/commands/ops.md.bak
```

Expect `FAIL  commands/ops.md routes to skill 'nosuch', which does not exist` and `exit=1`.

Routes-nowhere half:

```sh
cd /Users/pmudh/Documents/GitHub/Atlanta
cp plugins/growth-engine/commands/ops.md /tmp/ops.keep
grep -v 'Use the ghl-workflows skill' /tmp/ops.keep > plugins/growth-engine/commands/ops.md
bash scripts/validate.sh ; echo "exit=$?"
cp /tmp/ops.keep plugins/growth-engine/commands/ops.md && rm -f /tmp/ops.keep
```

Expect `FAIL  commands/ops.md names no skill with the phrase 'Use the <skill> skill'. It routes nowhere`.
Check the exact routing phrase first with `grep -n 'Use the' plugins/growth-engine/commands/ops.md`, because if the file words it differently the grep above removes nothing and the proof silently does not run.

---

#### V-20. TODO gate, scoped and versioned

**Catches.** The gate form links and the GoHighLevel share links shipping empty.
Today it is one broad WARN over the whole assets tree, which is right for early development and useless as a release gate.

**Shell.**

```bash
head_ "TODO gate"

VER=$(python3 -c "import json;print(json.load(open('$PLUGIN/.claude-plugin/plugin.json'))['version'])" 2>/dev/null || echo 0.0.0)
ver_ge() { [ "$(printf '%s\n%s\n' "$2" "$1" | sort -t. -k1,1n -k2,2n -k3,3n | head -1)" = "$2" ]; }

# The broad warn stays, always.
TODOS=$(grep -rln 'TODO' "$PLUGIN/assets" 2>/dev/null || true)
[ -n "$TODOS" ] && { warn "asset placeholders still open:"; show "$TODOS"; } || ok "no asset TODOs"

# Gate-1 forms must be real by 1.0.0, because gate 1 precedes the 1.1 lane.
if ver_ge "$VER" "1.0.0"; then
  grep -q 'TODO' "$PLUGIN/assets/forms/README.md" 2>/dev/null \
    && err "version $VER ships with TODOs in assets/forms/README.md. Gate 1 opens before the 1.1 lane" \
    || ok "forms links are real at $VER"
fi

# Snapshot share links must be real by 1.1.0.
if ver_ge "$VER" "1.1.0"; then
  grep -q 'TODO' "$PLUGIN/assets/ghl/README.md" 2>/dev/null \
    && err "version $VER ships with TODOs in assets/ghl/README.md. The three snapshot share links must be live" \
    || ok "snapshot share links are real at $VER"
fi
```

**Prove it.**
Both manifests are at `0.1.0` on 21 August 2026, and `plugins/growth-engine/assets/forms/README.md` contains 4 TODOs, so the warn half is already live.

```sh
cd /Users/pmudh/Documents/GitHub/Atlanta
bash scripts/validate.sh ; echo "exit=$?"
```

Expect `WARN  asset placeholders still open:` and `exit=0`.

Now bump both version fields to 1.0.0 and rerun.
Both files must move together or check EX-06 fails first and masks this one:

```sh
cd /Users/pmudh/Documents/GitHub/Atlanta
sed -i.bak 's/"version": "0.1.0"/"version": "1.0.0"/' \
  .claude-plugin/marketplace.json \
  plugins/growth-engine/.claude-plugin/plugin.json
rm -f .claude-plugin/marketplace.json.bak plugins/growth-engine/.claude-plugin/plugin.json.bak
bash scripts/validate.sh ; echo "exit=$?"
```

Expect `FAIL  version 1.0.0 ships with TODOs in assets/forms/README.md. Gate 1 opens before the 1.1 lane` and `exit=1`.

Put the version back:

```sh
cd /Users/pmudh/Documents/GitHub/Atlanta
sed -i.bak 's/"version": "1.0.0"/"version": "0.1.0"/' \
  .claude-plugin/marketplace.json \
  plugins/growth-engine/.claude-plugin/plugin.json
rm -f .claude-plugin/marketplace.json.bak plugins/growth-engine/.claude-plugin/plugin.json.bak
bash scripts/validate.sh ; echo "exit=$?"
```

The same TODOs now produce only the warn, and `exit=0`.
That is the intended behaviour: placeholders are fine during development and fatal at release.

### 1.3 Order and runtime

Sections run in the order they already have in `/Users/pmudh/Documents/GitHub/Atlanta/scripts/validate.sh`, which as of 21 August 2026 is nine `head_` groups at lines 33, 94, 137, 160, 181, 199, 222, 247 and 275: Manifests, Skills, Commands, Command namespacing, Placeholders, House style, Design rules, Locked facts, Hygiene.
The new checks are inserted so cheap ones fail first.
The full v2 run should stay under 20 seconds on a developer Mac, and under 40 seconds when it builds the zip for V-09.
If it exceeds a minute, people stop running it locally and it becomes a CI only check, which loses the whole point.
Two ways to keep it fast: gate V-09 behind a `--full` flag for local runs (CI always passes `--full`), and cache the shellcheck run when no script changed.
State the flag in the header so nobody assumes a local pass is a CI pass:

```
Usage: bash scripts/validate.sh [--full]
  default   every check except the zip rebuild (V-09). Fast, for the commit loop.
  --full    everything, including the zip rebuild. CI always uses this.
```

### 1.4 Making the gate unskippable

Add `.githooks/pre-commit`:

```sh
#!/bin/sh
# pre-commit: run the repo validator before every commit.
#
# WHY IT EXISTS: a commit that fails validate.sh reaches CI, wastes a cycle,
#                and sometimes reaches the public repo before anyone notices.
# CALLED BY:     git, on commit
# READS:         the whole worktree      WRITES: nothing
# POSTURE:       fail-closed, a red validator blocks the commit.
# PORTABILITY:   POSIX sh. No bash/python/node/jq. BSD+GNU date via lib/date_compat.sh.
# EVERY ERROR MESSAGE ENDS WITH A RECOVERY LINE ("→ run: ...").
set -u

if ! bash scripts/validate.sh; then
  printf 'commit blocked by scripts/validate.sh\n  → run: bash scripts/validate.sh and fix every FAIL line\n' >&2
  exit 1
fi
```

Enable once per clone:

```sh
cd /Users/pmudh/Documents/GitHub/Atlanta
mkdir -p .githooks
chmod +x .githooks/pre-commit
git config core.hooksPath .githooks
git config --get core.hooksPath
```

The last line must print `.githooks`.
Record that whole block in `/Users/pmudh/Documents/GitHub/Atlanta/CLAUDE.md`, which PRD task G-01 creates, because a hook that requires a manual opt in and is documented nowhere is not a process.
The hook script itself calls `bash scripts/validate.sh` with a path relative to the working directory, and git runs hooks from the top of the worktree, so that relative path is correct as written.

`git commit --no-verify` still exists and cannot be disabled locally.
That is fine, because CI re-runs the same script on push and the branch does not merge.
The hook is there to save a round trip, not to be a security boundary.

---

## 2. The golden test suite

**Trigger.** Every commit that touches `plugins/growth-engine/bin/`, `plugins/growth-engine/scripts/`, `plugins/growth-engine/schemas/`, or `tests/`.
Run as `sh tests/run.sh` from the repo root.
Also run by all four CI jobs on every push.

**Owner.** The executor.

**Artifact.** Per case PASS or FAIL lines, a summary count, and on failure a unified diff between expected and actual written to `tests/.work/<case>/diff.txt`.

**On failure.** The commit does not happen.
A red test is a bug in the code until someone proves it is a stale expectation, and proving that means reading the diff and deciding the new output is correct, then updating the fixture with `--update` and showing the fixture diff in the commit body.

### 2.1 Why golden tests and not unit tests

`ge` is a POSIX sh CLI whose entire job is to produce files and text.
There is no unit to isolate that is smaller than "run the command and look at what it made".
A golden test is therefore the natural shape: put a known folder in, run a known command, compare everything that came out against a committed expectation, byte for byte.

Byte exact matters more here than it usually does, because the failure modes this project actually has are byte level.
A CRLF that Git for Windows introduced.
A trailing newline that BSD `sed` added and GNU `sed` did not.
A snapshot filename whose UTC stamp is formatted differently by BSD `date`.
A ledger row with seven fields where the schema says eight.
None of those is visible to a test that only checks an exit code.

### 2.2 Layout

```
tests/
├── run.sh                    the runner (POSIX sh, no bashisms, no python)
├── lib/
│   ├── assert.sh             assert_file, assert_tree, assert_out, assert_exit
│   └── scrub.sh              normalises paths, timestamps and byte counts
├── cases/
│   ├── 01-help.sh
│   ├── 02-init.sh
│   ├── 03-snapshot.sh
│   ├── 04-log.sh
│   ├── 05-ledger.sh
│   ├── 06-index-lint.sh
│   ├── 07-context.sh
│   ├── 08-check.sh
│   ├── 09-date-compat.sh
│   └── 10-scatter.sh
├── fixtures/
│   ├── 03-snapshot/
│   │   ├── in/               the starting tree, copied into the sandbox
│   │   └── expect/           the tree and stdout after the run
│   └── ...
└── .work/                    sandbox per run, gitignored, deleted at start
```

`tests/.work/` goes in `.gitignore` alongside `/dist/`.

### 2.3 The determinism problem, and how it is solved

Three things make a naive golden comparison flap.

**Timestamps.** Snapshot filenames carry a UTC stamp, `ops-log.md` carries day headers and `HH:MM`, `index.md` carries a modified column.
Solution: `lib/date_compat.sh` reads an override.

```sh
# in lib/date_compat.sh
utc_stamp() {
  if [ -n "${GE_FAKE_NOW:-}" ]; then printf '%s\n' "$GE_FAKE_NOW"; return 0; fi
  date -u +%Y%m%dT%H%M%SZ
}
```

`GE_FAKE_NOW` is test only and must never be documented to founders.
Guard it: validate check V-02's runtime grep already refuses `python`, and add one line to the same section refusing `GE_FAKE_NOW` in any file under `skills/`, `commands/` or `docs/`.

**Absolute paths.** `.state/HOME` holds an absolute path, and error messages quote paths.
Solution: `lib/scrub.sh` rewrites the sandbox root to `@ROOT@` before comparison.

```sh
scrub() {
  sed -e "s|$SANDBOX|@ROOT@|g" \
      -e "s|/private@ROOT@|@ROOT@|g" \
      -e 's|[0-9]\{8\}T[0-9]\{6\}Z|@STAMP@|g' \
      -e 's|[0-9]\{4\}-[0-9]\{2\}-[0-9]\{2\} [0-9]\{2\}:[0-9]\{2\}|@TS@|g' \
      -e 's/\r$//'
}
```

The `/private@ROOT@` line is not decoration.
macOS resolves `/tmp` to `/private/tmp`, and a test that passes on ubuntu and fails on macOS for that reason alone will cost an afternoon.

**Byte counts and modification times in `index.md`.** Scrub the numeric columns to `@N@` in the same pass, or better, have `ge index` write sizes only when `GE_FAKE_NOW` is unset.
The first is simpler and does not put test awareness into shipped code, so prefer it.

### 2.4 A complete worked example: `tests/cases/03-snapshot.sh`

This is the whole file, ready to copy.

```sh
#!/bin/sh
# 03-snapshot.sh: golden test for ge snapshot, restore and undo.
#
# WHY IT EXISTS: snapshot is the fail-closed guard in front of every founder
#                file rewrite. If it silently no-ops, an undo is impossible
#                and the founder loses work with no way back.
# CALLED BY:     tests/run.sh
# READS:         tests/fixtures/03-snapshot/{in,expect}    WRITES: tests/.work/03-snapshot/
# POSTURE:       fail-closed, any mismatch fails the suite.
# PORTABILITY:   POSIX sh. No bash/python/node/jq. BSD+GNU date via lib/date_compat.sh.
# EVERY ERROR MESSAGE ENDS WITH A RECOVERY LINE ("→ run: ...").
set -u

CASE=03-snapshot
. "$TESTS/lib/assert.sh"
. "$TESTS/lib/scrub.sh"

SANDBOX="$TESTS/.work/$CASE"
rm -rf "$SANDBOX"
mkdir -p "$SANDBOX"
cp -R "$TESTS/fixtures/$CASE/in/." "$SANDBOX/"

GE_FAKE_NOW=20260821T090000Z
export GE_FAKE_NOW

cd "$SANDBOX" || exit 1

# 1. A snapshot of an existing file lands in the ring.
"$GE" snapshot founder-brain.md > "$SANDBOX/out.1" 2>&1
assert_exit 0 $? "snapshot of an existing file"

# 2. The file is mutated, then undone, and comes back byte-exact.
cp founder-brain.md "$SANDBOX/original.keep"
printf 'this line should not survive undo\n' >> founder-brain.md
GE_FAKE_NOW=20260821T091500Z "$GE" undo > "$SANDBOX/out.2" 2>&1
assert_exit 0 $? "undo after a mutation"
assert_bytes_equal "$SANDBOX/original.keep" founder-brain.md "undo restores byte-exact"

# 3. The ring caps at 10 and drops the oldest.
i=1
while [ "$i" -le 12 ]; do
  GE_FAKE_NOW="202608${i}T120000Z" "$GE" snapshot founder-brain.md >/dev/null 2>&1
  i=$((i + 1))
done
COUNT=$(find growth-engine/.state/snapshots -name 'founder-brain.md.*' | wc -l | tr -d ' ')
assert_equals "10" "$COUNT" "snapshot ring caps at 10"

# 4. A snapshot into an unwritable directory is fail-closed: exit 1, recovery line.
chmod 500 growth-engine/.state/snapshots
"$GE" snapshot content-30.md > "$SANDBOX/out.4" 2>&1
RC=$?
chmod 700 growth-engine/.state/snapshots
assert_exit 1 "$RC" "snapshot into an unwritable dir is fail-closed"
assert_contains "$SANDBOX/out.4" '→ run:' "the failure carries a recovery line"

# 5. The whole resulting tree matches the expectation.
assert_tree "$TESTS/fixtures/$CASE/expect" "$SANDBOX" "resulting tree"

# 6. Stdout of the first snapshot matches, scrubbed.
scrub < "$SANDBOX/out.1" > "$SANDBOX/out.1.scrubbed"
assert_files_equal "$TESTS/fixtures/$CASE/expect.stdout/out.1" "$SANDBOX/out.1.scrubbed" "snapshot stdout"
```

The fixture layout for that case:

```
tests/fixtures/03-snapshot/
├── in/
│   └── growth-engine/
│       ├── founder-brain.md            48 lines, a trimmed copy of b2b-northfield
│       ├── content-30.md               3 pieces, enough to snapshot
│       └── .state/
│           ├── HOME                    single line: @ROOT@/growth-engine
│           └── snapshots/              empty directory, kept by .gitkeep
├── expect/
│   └── growth-engine/
│       ├── founder-brain.md            byte-identical to in/
│       ├── content-30.md               byte-identical to in/
│       └── .state/
│           ├── HOME
│           └── snapshots/
│               ├── founder-brain.md.@STAMP@        (10 of these after scrubbing)
│               └── .gitkeep
└── expect.stdout/
    └── out.1
```

`expect/.../HOME` contains the literal string `@ROOT@/growth-engine`, because `assert_tree` scrubs the actual side before comparing.
`assert_tree` compares in two passes: first `find . | sort` on both sides, scrubbed, so a missing or extra file is named directly; then a per file `cmp` for every regular file.
The two pass order matters, because "expected 47 files, found 46" is a far better first line than a byte offset.

`assert_tree` in `lib/assert.sh`:

```sh
assert_tree() {
  exp="$1"; act="$2"; label="$3"
  ( cd "$exp" && find . -print | sort ) > "$SANDBOX/.tree.exp"
  ( cd "$act" && find . -path ./out.\* -prune -o -print ) | sort | scrub > "$SANDBOX/.tree.act"
  if ! diff -u "$SANDBOX/.tree.exp" "$SANDBOX/.tree.act" > "$SANDBOX/tree.diff"; then
    fail "$label: file list differs" "$SANDBOX/tree.diff"
    return 1
  fi
  ( cd "$exp" && find . -type f -print ) | while IFS= read -r f; do
    scrub < "$act/$f" > "$SANDBOX/.one.act" 2>/dev/null
    cmp -s "$exp/$f" "$SANDBOX/.one.act" || printf '%s\n' "$f"
  done > "$SANDBOX/.mismatch"
  if [ -s "$SANDBOX/.mismatch" ]; then
    while IFS= read -r f; do
      diff -u "$exp/$f" "$SANDBOX/.one.act" >> "$SANDBOX/diff.txt" 2>&1
    done < "$SANDBOX/.mismatch"
    fail "$label: content differs in $(wc -l < "$SANDBOX/.mismatch" | tr -d ' ') file(s)" "$SANDBOX/diff.txt"
    return 1
  fi
  pass "$label"
}
```

### 2.5 The runner

`tests/run.sh` is deliberately small.

```sh
#!/bin/sh
# run.sh: the golden test suite for ge.
#
# WHY IT EXISTS: ge writes the founder's only copy of their work. Nothing else
#                proves that a change to it still produces the same bytes on
#                GNU date, BSD date and Git Bash.
# CALLED BY:     humans, .githooks/pre-commit, .github/workflows/validate.yml
# READS:         tests/fixtures/**       WRITES: tests/.work/**
# POSTURE:       fail-closed, a mismatch is a failure, never a warning.
# PORTABILITY:   POSIX sh. No bash/python/node/jq. BSD+GNU date via lib/date_compat.sh.
# EVERY ERROR MESSAGE ENDS WITH A RECOVERY LINE ("→ run: ...").
set -u

TESTS=$(cd "$(dirname "$0")" && pwd)
REPO=$(cd "$TESTS/.." && pwd)
GE="$REPO/plugins/growth-engine/bin/ge"
export TESTS REPO GE

[ -x "$GE" ] || {
  printf 'tests: bin/ge is not executable\n  → run: chmod +x plugins/growth-engine/bin/ge\n' >&2
  exit 1
}

UPDATE=0
[ "${1:-}" = "--update" ] && UPDATE=1
export UPDATE

rm -rf "$TESTS/.work"
mkdir -p "$TESTS/.work"

PASSED=0; FAILED=0
for c in "$TESTS"/cases/*.sh; do
  name=$(basename "$c" .sh)
  if sh "$c"; then
    PASSED=$((PASSED + 1)); printf 'PASS  %s\n' "$name"
  else
    FAILED=$((FAILED + 1)); printf 'FAIL  %s   see tests/.work/%s/diff.txt\n' "$name" "$name"
  fi
done

printf '\n%d passed, %d failed\n' "$PASSED" "$FAILED"
[ "$FAILED" -eq 0 ] || {
  printf 'tests failed\n  → run: sh tests/run.sh and read tests/.work/<case>/diff.txt\n' >&2
  exit 1
}
```

Note that each case is run with `sh "$c"` rather than sourced.
A sourced case that calls `exit` kills the runner and reports a false clean.

### 2.6 How to add a test

1. Pick the next number.
   Numbers are stable and never reused, because commit messages reference them.
2. `mkdir -p tests/fixtures/NN-name/in tests/fixtures/NN-name/expect`.
3. Build the `in/` tree by hand.
   Keep it minimal: a fixture with 30 content pieces when the test is about a snapshot ring makes the diff unreadable.
   Trim the worked example Brains rather than copying them whole.
4. Write `tests/cases/NN-name.sh` with the standard header, the `POSTURE: fail-closed` line, and one assertion per behaviour.
5. Run `sh tests/run.sh --update` once to generate `expect/`.
6. **Read every line of the generated expectation before committing it.**
   This is the step that separates a golden test from a rubber stamp.
   A generated expectation is a claim that the current behaviour is correct, and nobody has checked that yet except you, right now.
7. `bash scripts/validate.sh`, then commit the case, the fixture, and the code in one commit.

### 2.7 How to update an expected fixture deliberately

The only supported command is:

```sh
sh tests/run.sh --update
git diff --stat tests/fixtures/
git diff tests/fixtures/
```

The rules around it:

- Never run `--update` to make a red suite go green without first reading the diff.
  If you cannot explain each changed byte in one sentence, the code is wrong, not the fixture.
- A fixture update lands in its own commit, or in the same commit as the code change that caused it, never bundled with unrelated work.
- The commit body carries the fixture diff summary and one sentence of justification:

```
B-03: cap the snapshot ring at 10 and stamp in UTC

Ring previously kept every snapshot, which grew without bound in a
founder folder. Fixture 03-snapshot expect/ now shows 10 files, not 12.
Acceptance: sh tests/run.sh green on ubuntu, macos and Git Bash.
Regression-test: tests/cases/03-snapshot.sh (ring cap assertion)
```

### 2.8 The rule: a bug fix lands with the test that would have caught it

Stated plainly, and enforced.

Every commit whose summary begins `fix` or whose body describes a defect must carry a `Regression-test:` trailer naming a test case file and the assertion inside it.
That assertion must be new or newly strengthened in the same commit.

Enforced by `.githooks/commit-msg`:

```sh
#!/bin/sh
# commit-msg: a fix lands with the test that would have caught it.
#
# WHY IT EXISTS: a fix with no test is a fix that returns. This project has
#                one maintainer and no memory beyond the repo.
# CALLED BY:     git, on commit
# READS:         $1 (the commit message file)   WRITES: nothing
# POSTURE:       fail-closed, no trailer, no commit.
# PORTABILITY:   POSIX sh. No bash/python/node/jq. BSD+GNU date via lib/date_compat.sh.
# EVERY ERROR MESSAGE ENDS WITH A RECOVERY LINE ("→ run: ...").
set -u

MSG="$1"
SUMMARY=$(head -1 "$MSG")

case "$SUMMARY" in
  *": fix"*|*": correct"*|*": repair"*|fix*)
    if ! grep -q '^Regression-test: ' "$MSG"; then
      printf 'a fix commit needs a Regression-test: trailer naming the case that would have caught it\n' >&2
      printf '  → run: add a line "Regression-test: tests/cases/NN-name.sh (<assertion>)" to the commit body\n' >&2
      exit 1
    fi
    ;;
esac
```

There is one honest exception, and it should be written into `CLAUDE.md` rather than left to judgement: a fix to a markdown skill file that has no executable behaviour cannot always have a golden test.
For those, the trailer names the validate check instead: `Regression-test: scripts/validate.sh V-12 (snapshot-first)`.
If neither a test nor a check exists, the fix commit adds one.
That is the whole discipline, and it is what stops a 75 item gap register from regrowing.

---

## 3. The CI matrix: four jobs across three operating systems

**Trigger.** Every push to any branch and every pull request.

**Owner.** The executor, who is also the only person who can go and read a red run.

**Artifact.** A GitHub Actions run with four jobs, each with a green or red badge and full logs retained for 90 days.

**On failure.** The branch does not merge, and the version is not tagged.
A red Windows leg is not a "flaky runner", it is the founder floor telling you something.
Treat a red Windows job as a release blocker even when the same commit is green everywhere else.

### 3.1 Why each job exists

**ubuntu.** The general purpose leg.
It runs `bash scripts/validate.sh --full` (the only leg that runs the validator, because the validator needs bash and `python3` and only ever runs on developer machines).
It runs `shellcheck` at warning level with `-s sh` on the founder floor and `-s bash` on developer tooling.
It runs the official plugin validator, `claude plugin validate ./plugins/growth-engine`, against a pinned Claude Code version, which is the only automated statement that the plugin will actually install.
It runs `sh tests/run.sh` with GNU coreutils, GNU `date`, GNU `sed`.

**ubuntu-dash.** The leg that actually holds the POSIX floor, and the reason this matrix has four jobs rather than three.
This is worth being blunt about, because PRD task CI-02, at `/Users/pmudh/Documents/GitHub/Atlanta/planning/PRD-growth-engine-v1.md`, specifies a three-job matrix of ubuntu, macos and windows, and its acceptance line claims a planted bashism fails the macos and windows legs.
That claim is false.
Git Bash on Windows is bash.
macOS `/bin/sh` is bash 3.2 running in sh compatibility mode.
Both tolerate `[[ ]]`, `local`, and most other bashisms.
So neither of those legs reliably rejects a bashism, and relying on them produces a false sense of portability.
`dash` is a genuinely minimal POSIX shell and rejects them immediately.
This job installs dash and runs `dash tests/run.sh`, plus `dash -n` over every founder floor script.

**macos.** The BSD leg.
`date` on macOS has no `-d` and formats differently.
`sed -i` needs an argument on BSD and does not on GNU.
`stat` flags differ.
`/tmp` resolves to `/private/tmp`, which breaks naive path comparisons.
Roughly half the founders and the entire demo path run on macOS, so `lib/date_compat.sh` must be proven on BSD `date` and not merely written to handle it.

**windows.** The founder runtime floor leg, run under Git Bash via `shell: bash`.
What it genuinely proves, and what it does not, matters.

It proves: the scripts survive CRLF handling by Git for Windows (a shebang with a trailing `\r` produces `bad interpreter: /bin/sh^M`, which is one of the most common Windows shell failures and is invisible on any other platform); paths containing spaces and drive prefixes like `/c/Users/...`; a case insensitive filesystem, which catches a `require SKILL.md` that on disk is `Skill.md`; the absence of `python3`, `jq` and `realpath`; MSYS path translation mangling an argument that begins with a slash.

It does not prove: absence of bashisms.
That is `ubuntu-dash`'s job and `shellcheck -s sh`'s job.

### 3.2 The complete workflow

`.github/workflows/validate.yml`:

```yaml
name: validate

on:
  push:
  pull_request:

permissions:
  contents: read

concurrency:
  group: validate-${{ github.ref }}
  cancel-in-progress: true

jobs:
  ubuntu:
    name: ubuntu (validate + shellcheck + plugin validator + tests)
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4

      - name: Install shellcheck
        run: sudo apt-get update && sudo apt-get install -y shellcheck

      - name: Run the repo validator
        run: bash scripts/validate.sh --full

      - name: shellcheck the founder floor as POSIX sh
        run: |
          set -e
          FILES=$(find plugins/growth-engine/bin plugins/growth-engine/scripts tests \
                    -type f \( -name '*.sh' -o -name 'ge' \) 2>/dev/null || true)
          if [ -n "$FILES" ]; then shellcheck -s sh -S warning $FILES; fi

      - name: shellcheck developer tooling as bash
        run: shellcheck -s bash -S warning scripts/validate.sh scripts/build-folder.sh

      - name: Set up Node for the plugin validator
        uses: actions/setup-node@v4
        with:
          node-version: '20'

      - name: Install the pinned Claude Code CLI
        run: npm install -g @anthropic-ai/claude-code@2.0.14

      - name: Validate the plugin the way the marketplace will
        run: claude plugin validate ./plugins/growth-engine

      - name: Golden tests (GNU date, GNU sed)
        run: sh tests/run.sh

      - name: Upload failure diffs
        if: failure()
        uses: actions/upload-artifact@v4
        with:
          name: ubuntu-test-diffs
          path: tests/.work/**/diff.txt
          if-no-files-found: ignore

  posix-floor:
    name: ubuntu + dash (the real POSIX floor)
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4

      - name: Install dash
        run: sudo apt-get update && sudo apt-get install -y dash

      - name: Parse every founder-path script with dash
        run: |
          set -e
          FILES=$(find plugins/growth-engine/bin plugins/growth-engine/scripts tests \
                    -type f \( -name '*.sh' -o -name 'ge' \) 2>/dev/null || true)
          for f in $FILES; do
            echo "dash -n $f"
            dash -n "$f"
          done

      - name: Golden tests under dash
        run: dash tests/run.sh

      - name: Upload failure diffs
        if: failure()
        uses: actions/upload-artifact@v4
        with:
          name: dash-test-diffs
          path: tests/.work/**/diff.txt
          if-no-files-found: ignore

  macos:
    name: macos (the BSD date leg)
    runs-on: macos-latest
    steps:
      - uses: actions/checkout@v4

      - name: Confirm this really is BSD date
        run: |
          if date --version >/dev/null 2>&1; then
            echo "GNU date found on the macOS runner. The BSD leg is not testing what it claims."
            echo "  -> run: remove any coreutils from PATH in this job"
            exit 1
          fi
          echo "BSD date confirmed"

      - name: Golden tests (BSD date, BSD sed, /private/tmp)
        run: sh tests/run.sh

      - name: Upload failure diffs
        if: failure()
        uses: actions/upload-artifact@v4
        with:
          name: macos-test-diffs
          path: tests/.work/**/diff.txt
          if-no-files-found: ignore

  windows:
    name: windows (Git Bash, the founder runtime floor)
    runs-on: windows-latest
    defaults:
      run:
        shell: bash
    steps:
      # Turn off autocrlf BEFORE checkout. The Windows runner image ships with
      # core.autocrlf=true, which rewrites LF to CRLF on checkout for any file
      # git considers text and that .gitattributes has not pinned. Without this
      # step the CRLF check below can pass or fail depending on runner image
      # changes rather than on the contents of the repo.
      # fetch-depth has nothing to do with line endings; do not use it here.
      - name: Disable autocrlf before checkout
        run: git config --global core.autocrlf false
        shell: pwsh

      - uses: actions/checkout@v4

      - name: Refuse CRLF in any shell script
        run: |
          BAD=$(find plugins/growth-engine/bin plugins/growth-engine/scripts tests \
                  -type f \( -name '*.sh' -o -name 'ge' \) -exec grep -lU $'\r' {} + 2>/dev/null || true)
          if [ -n "$BAD" ]; then
            echo "CRLF line endings in a shell script. Git Bash will report 'bad interpreter'."
            echo "$BAD"
            echo "  -> run: add '*.sh text eol=lf' and 'bin/ge text eol=lf' to .gitattributes, then git add --renormalize ."
            exit 1
          fi
          echo "no CRLF in shell scripts"

      - name: Confirm the founder floor really is bare
        run: |
          for tool in jq realpath; do
            if command -v "$tool" >/dev/null 2>&1; then
              echo "note: $tool is present on this runner but must never be used by founder-path code"
            fi
          done
          echo "shell: $(bash --version | head -1)"

      - name: Golden tests under Git Bash
        run: sh tests/run.sh

      - name: Prove a space in the path does not break anything
        run: |
          mkdir -p "/tmp/Founder Folder/work"
          cp -R tests "/tmp/Founder Folder/work/tests"
          cp -R plugins "/tmp/Founder Folder/work/plugins"
          cd "/tmp/Founder Folder/work" && sh tests/run.sh

      - name: Upload failure diffs
        if: failure()
        uses: actions/upload-artifact@v4
        with:
          name: windows-test-diffs
          path: tests/.work/**/diff.txt
          if-no-files-found: ignore
```

Two supporting changes go with that YAML.

`.gitattributes` gains explicit LF pinning, because `* text=auto` alone is not enough for files Git does not confidently detect as text:

```
* text=auto
*.sh text eol=lf
plugins/growth-engine/bin/ge text eol=lf
tests/run.sh text eol=lf
*.csv text eol=lf
```

After adding those lines, run `git add --renormalize .` once and commit the result.

The Claude Code version in the ubuntu job is pinned deliberately.
An unpinned `@latest` means the plugin validator's behaviour changes under you, which turns CI into a source of unexplained red on days when nothing in the repo changed.
Record the pinned version in `CHANGELOG.md` when you bump it, and bump it deliberately, at most once before the 3 September freeze.

### 3.3 Proving the Windows leg genuinely catches something

Do not accept the leg on faith.
Each of the following is a five minute experiment on a throwaway branch, and each should be run once so the leg's value is known rather than assumed.

**Experiment 1: the CRLF shebang.**
On a branch, remove the `*.sh text eol=lf` lines from `.gitattributes`, then commit a script whose lines end `\r\n` (create it with `printf '#!/bin/sh\r\nexit 0\r\n' > plugins/growth-engine/scripts/lib/probe.sh`).
Push.
Expected: ubuntu, dash and macOS all pass, because they tolerate the `\r`.
Windows fails, either at the CRLF step or at `sh tests/run.sh` with `bad interpreter: /bin/sh^M`.
That divergence is the leg earning its place.
Restore `.gitattributes` and delete the probe.

**Experiment 2: the path with a space.**
Add `cp $HOME/growth-engine/founder-brain.md ./x` unquoted to a floor script that a test exercises.
Push.
Expected: the "space in the path" step on Windows fails; the plain test step may still pass.
This is the check that mirrors `C:\Users\First Last\Documents`.

**Experiment 3: the case insensitive filesystem.**
Rename `tests/fixtures/03-snapshot/in/growth-engine/founder-brain.md` to `Founder-Brain.md` in git but leave the test referring to the lowercase name.
Push.
Expected: ubuntu and dash fail (file not found); Windows and macOS pass, because both filesystems are case insensitive by default.
This one runs in the opposite direction, and it is worth doing precisely because it shows which leg protects which property.

**Experiment 4: the bashism, and the honest result.**
Add `local x=1` to a function in a founder-floor script, for example `plugins/growth-engine/scripts/lib/paths.sh` (path relative to `/Users/pmudh/Documents/GitHub/Atlanta`).
Commit on a throwaway branch and push.
Expected: `posix-floor` fails at `dash -n`.
ubuntu fails at `shellcheck -s sh`.
Windows passes.
macOS passes.
Record that result in `/Users/pmudh/Documents/GitHub/Atlanta/planning/spike-findings.md` so nobody re-litigates it, and correct the CI-02 acceptance line in `/Users/pmudh/Documents/GitHub/Atlanta/planning/PRD-growth-engine-v1.md` to read: a planted bashism fails the ubuntu shellcheck step and the dash leg; the Windows leg proves CRLF handling, paths containing spaces, and the bare toolchain instead.

---

## 4. The end to end rehearsal

This does not exist today in any form.
Nothing in this project has ever been executed from start to finish, which means every claim about what a founder experiences is currently a claim about what the markdown says, not about what happens.

**Trigger.** Three fixed triggers, plus one conditional.
Before every version tag (1.0.0 on 3 September, 1.1.0 on 19 September).
After any skill rewrite lands, for the routes that skill touches.
Once on a genuinely clean machine per platform, before 3 September.
Conditionally: any time a founder reports something the toolkit says should not happen, the reproducing arc is rehearsed before the fix is written.

**Owner.** Philip drives the founder side (he is the one who can tell whether the output is any good).
The executor drives the machine side and writes the receipt.
Neither role can be done alone, because the person who wrote the skill cannot see where it is confusing.

**Artifact.** One receipt file per run at `planning/rehearsals/<YYYY-MM-DD>-<route>-<surface>.md`, plus the complete `growth-engine/` output folder committed to `plugins/growth-engine/assets/examples/<founder>/` when the run is a reference run.

**On failure.** Two outcomes only, and this is the rule that makes the rehearsal worth doing.
Every friction becomes either a documentation fix (with the file and line named) or a task (with an id, an owner and a date).
It never becomes a note, an observation, or a "we should probably".
A receipt containing an unresolved observation is an incomplete receipt and the tag does not happen.

### 4.1 The coverage grid

Three routes by two platforms is six cells.
Six full arcs is roughly two days of human time, which the calendar does not have before 3 September.
So the grid is graded, and the grading is stated rather than left implicit.

| Cell | Founder | Surface | Depth | Why this depth |
|---|---|---|---|---|
| b2b, macOS | Sam Okoye (Northfield) | macOS Cowork | FULL ARC | The reference B2B run. Produces the committed example folder |
| b2b, Windows | Sam Okoye | Windows Home, Code tab | SHORT ARC | Setup through content and CSV. The install and folder path are the Windows risk, not the copy |
| b2c-service, macOS | Priya Raman (Lumen) | macOS Code tab | FULL ARC | The reference B2C service run. Produces the committed example folder |
| b2c-service, Windows | Priya Raman | Windows Pro, Cowork | SHORT ARC | Proves Cowork on Windows, which is a different surface from macOS Cowork |
| b2c-ecom, macOS | Maya (new, ecom) | macOS Cowork | FULL ARC | The newest route, least exercised copy, needs the deepest look |
| b2c-ecom, Windows | Maya | Windows Home, Code tab | FULL ARC | The hardest cell in the product: no Hyper-V, no Cowork, Git for Windows required, newest route |

FULL ARC means every command in order, end to end, including the ones that touch external systems on the test accounts.
SHORT ARC means PRE-WORK through `content` and the CSV export, stopping before engine 2.
Four full arcs plus two short arcs is the minimum that covers all six cells with the depth weighted toward the risk.

Maya does not exist yet.
Confirmed on 21 August 2026: `ls /Users/pmudh/Documents/GitHub/Atlanta/plugins/growth-engine/assets/examples` returns `README.md`, `b2b-northfield` and `b2c-lumen` and nothing else.
`b2b-northfield` is Sam Okoye, construction operations.
`b2c-lumen` is Priya Raman, skincare.
Each folder currently contains a single file, `founder-brain.md`, and no downstream output at all.

The third example is PRD task FB-02 at `/Users/pmudh/Documents/GitHub/Atlanta/planning/PRD-growth-engine-v1.md`, but its folder name there is wrong and section 04 of this delivery plan supersedes it.
Build `plugins/growth-engine/assets/examples/b2c-service-brighthound/founder-brain.md`, not `b2c-ecom-<name>`.
Priya Raman at `b2c-lumen` already is the ecommerce example, so the route with no example is b2c-service.
FB-02 requires it to be generated by running the founder-brain skill as a fictional ecommerce founder, never hand-written, same rule as the existing two.
It is a hard prerequisite for two of the six cells in the grid above.
Flag it in the rehearsal plan rather than discovering it on the day.

### 4.2 What a clean machine means

"Clean" is the word that quietly gets skipped, so define it operationally.

- A fresh macOS user account (System Settings, Users and Groups, add a new Standard user), or a fresh Windows user account.
  Not a fresh terminal.
  Not a fresh folder.
  A user account, because that is what resets PATH, shell profile, keychain, and every app's per user state.
- Claude installed but no plugins, no marketplaces, no MCP servers configured.
- No Git for Windows on the Windows Home cell until the PRE-WORK document tells the tester to install it.
  That step is the single highest risk moment in the entire founder journey and it must be walked, not assumed.
- No `growth-engine/` folder anywhere on disk.
  Check with `find ~ -name 'founder-brain.md' 2>/dev/null` before starting.
- The tester follows `docs/PRE-WORK.md` literally, and is not allowed to use knowledge they have from building the thing.
  If the document does not say it, they do not do it.
  When they get stuck, that is the finding.

### 4.3 The exact command sequence, FULL ARC

Run in this order.
Every line here is typed by the tester.

```
Step 0.  Follow docs/PRE-WORK.md from the first word. Do not skip. Time it.
Step 1.  /plugin marketplace add Philm-moxywolf/Atlanta
Step 2.  /plugin install growth-engine@launchhouse
Step 3.  (restart or /reload-plugins if commands do not appear)
Step 4.  /growth-engine:setup
Step 5.  /growth-engine:connect
Step 6.  /growth-engine:brain
Step 7.  /growth-engine:content
Step 8.  /growth-engine:publish
Step 9.  /growth-engine:engine2
Step 10. /growth-engine:ops
Step 11. /growth-engine:plan
Step 12. /growth-engine:status
Step 13. /growth-engine:gate
Step 14. /growth-engine:undo
Step 15. /growth-engine:doctor
Step 16. /growth-engine:update
Step 17. Plain-language repeat: close the session, reopen, and say
         "where am I up to" and "build my content engine" without any slash command.
```

Notes on specific steps.

**Step 4** must produce `growth-engine/.state/receipt.md` with real evidence, not an assertion.
Record the actual receipt contents in the rehearsal file.

**Step 5** involves a credential.
The token is typed into a masked prompt or into a local file the tester edits in their own editor.
It is never pasted into the conversation.
The rehearsal explicitly checks this: after the run, `grep -rI 'pit-' ~/` over the founder folder must return only the fallback env file, if that path was used at all.

**Step 8** publishes to the test GoHighLevel location, not to anything real.
Three text posts, scheduled, read back by post id, verified visible in the Social Planner UI at the correct local time.
Then a deliberate failure: run it again with a bad accountId and confirm the ledger row lands as `failed` with a recovery line, per the fail-loud posture.

**Step 10** runs `ghl-workflows`, which is the back-end ops system.
It must produce `ops-workflow.md` containing the copy for the comment-to-DM capture workflow and the DM qualify-and-book workflow, with every message written as a namespaced GoHighLevel custom value.
Both of those are IN scope, and both run as GoHighLevel workflows.
The rehearsal check is specific: import the selected snapshot into the test GoHighLevel location, paste the generated custom values in, trigger the comment-to-DM workflow by commenting the trigger word on the test post from a second Instagram account, and confirm the DM arrives from GoHighLevel.
Then confirm, by reading the transcript of the rehearsal session, that Claude never opened the inbox and never offered to reply.
Claude wrote the copy.
GoHighLevel sent the message.
The founder reads and replies in the GoHighLevel app.
If any part of the toolkit offered to read or send, that is a scope breach and a blocker, not a friction.

**Step 9** on a B2B route enrols into an Apollo sequence and must land PAUSED.
The tester confirms paused in the Apollo UI with a screenshot, then deletes the test artifacts.
On a B2C route it produces 25 DM openers and the tester confirms that nothing in the output offers to send them.

**Step 11** runs `growth-plan`, which is IN scope.
This is the Sunday deliverable and the rehearsal is the only place before Atlanta where anyone sees whether it produces a plan with real numbers or an improvised one.

**Step 14** is the undo drill and it is the most skipped step in any rehearsal.
Mutate `founder-brain.md` by hand, run undo, `cmp` against a copy taken before the mutation.
Byte identical or it is a finding.

**Step 16** is the update drill.
It requires two versions to exist, so on the pre-freeze rehearsal it is run against 0.2.0 installed and 0.2.1 published.

**`playbook` is deliberately not in the sequence.**
`skills/playbook-export` is DEFERRED under the locked scope.
It stays in the repo and stays covered by validate's structural checks, but it is not rehearsed, not regenerated, and not in the release checklist's regeneration item.
If the reader decides to bring it back in, insert it between steps 11 and 12 and add it to the regeneration map in section 6.

### 4.4 The SHORT ARC sequence

Steps 0 through 7, plus the CSV export, plus step 17.
Stop before `connect` if the cell has no test credentials available, and say so in the receipt rather than silently omitting it.

### 4.5 What to record at each step

The receipt template lives at `planning/rehearsals/TEMPLATE.md` and is copied for each run.

```markdown
# Rehearsal: <route> on <surface>

Date: <YYYY-MM-DD>
Tester: <name>            Observer: <name>
Machine: <OS version, chip, RAM>       Surface: <Cowork | Code tab>
Toolkit version installed: <x.y.z>     Commit: <sha>
Founder persona: <Sam Okoye | Priya Raman | Maya>

## Step log

| Step | Command | Wall time | Exit / outcome | Files created or changed | Frictions |
|---|---|---|---|---|---|
| 0 | PRE-WORK |  |  |  |  |
| 1 | marketplace add |  |  |  |  |
| ... |  |  |  |  |  |

## Evidence

- receipt.md contents, pasted verbatim
- `find growth-engine -type f | sort` after the final step, pasted verbatim
- `wc -l growth-engine/*.md`, pasted verbatim
- GHL post ids returned by publish, and the read-back result for each
- Apollo sequence id and a note confirming it was observed PAUSED
- ledger.md, pasted verbatim
- ops-log.md, pasted verbatim

## Quality read (Philip)

- Does the content sound like this founder, or like Claude? One sentence.
- Would you send the 25 first lines as they stand? Which would you cut?
- Does the 90-day plan carry a real number and a real stop point?
- Anything a founder would be embarrassed to publish.

## Frictions, every one resolved

| # | What happened | Where (file:line) | Resolution | Id |
|---|---|---|---|---|
| 1 |  |  | DOC-FIX or TASK |  |

## Verdict

<PASS: every friction resolved, receipt complete>
<FAIL: N frictions unresolved, tag blocked>
```

The two things most likely to be skipped are wall time and the verbatim pastes.
Wall time matters because Session 2 has a fixed length and a command that takes 14 minutes changes the session plan.
Verbatim pastes matter because a summary written from memory an hour later is not evidence.

### 4.6 The friction rule, stated hard

Every friction gets exactly one of two resolutions, recorded in the table above, before the receipt is marked complete.

**DOC-FIX.** The behaviour is correct, the document did not prepare the founder for it.
The resolution names the file and the line, and the fix lands in the same working session as the rehearsal, not later.
Example: "PRE-WORK does not say the Plugins button is behind the plus icon" resolves to `docs/PRE-WORK.md:31, add the sentence`.

**TASK.** The behaviour is wrong.
The resolution gets an id, an owner, and a date, in the same working session.

Ids come from the PRD's own task numbering at `/Users/pmudh/Documents/GitHub/Atlanta/planning/PRD-growth-engine-v1.md`, which uses prefixes such as `B-` for the brain, `C-` for content, `D-` for distribution, `CI-` for continuous integration, `SS-` for setup and support, `FB-` for founder brain and `G-` for governance.
A friction that maps onto an existing PRD task takes that task's id.
A friction that does not takes the next free number under the nearest prefix, and the new task is written into the PRD in the same session, in the same shape as the tasks around it.

Do not put task ids in the private working folder alone.
The PRD is inside the public repo, the private tracking list at `/Users/pmudh/Downloads/Atlanta/launchhouse-atlanta/planning/TASKS.md` is not, and a reader on another machine only has the repo.
Anything the executor needs in order to work must be in the repo.
Example: "publish wrote a post id of `-` when the MCP call timed out" resolves to `C-03 follow-up, executor, 22 August 2026`, written into the PRD next to C-03.

Not permitted: "noted", "we should look at", "minor", "cosmetic", "I will remember".
A rehearsal that produces observations rather than fixes has cost two people a day and changed nothing.
If a friction is genuinely not worth fixing, that is still a decision, and it is recorded as `TASK: wontfix, <one sentence why>` with a name against it.

### 4.7 Where receipts land, and what they are for later

`planning/rehearsals/` is inside the public repo.
Two consequences.

First, receipts must not carry credentials, real customer data, or the test location id if that id is sensitive.
Scrub before committing, and let V-07 catch what you miss.

Second, the receipts are the evidence base for the release checklist item "rehearsal receipts present".
A tag with no receipt for a route is a tag shipping an unexercised route to roughly 43 founders.

---

## 5. The release checklist

**Trigger.** Immediately before `git tag`, for every version without exception, including patch versions during the event week.

**Owner.** Philip.
The executor may do the work; Philip ticks the boxes, because the person who wrote the code is the worst person to certify it.

**Artifact.** `planning/releases/<version>.md`, a copy of the template below with every box ticked and evidence pasted where evidence is asked for.

**On failure.** The tag does not happen.
There is no partial release and no verbal sign off.
If a box cannot be ticked before a hard date, the release moves or the scope moves, and whichever it is gets said out loud to Juan.

### 5.1 The list

Copy `planning/releases/TEMPLATE.md` to `planning/releases/<version>.md` and work down it.

```markdown
# Release <version>

Date: <YYYY-MM-DD>       Ticked by: <name>       Commit: <sha>

## Gate 1: the automated checks

- [ ] `bash scripts/validate.sh --full` exits 0 on the release commit.
      Paste the final count line: ______________________
- [ ] Warning count is understood. Every remaining WARN has a one-line
      justification below, or it is fixed.
      Warnings: ______________________
- [ ] `sh tests/run.sh` green locally.
- [ ] CI green on all four jobs for the release commit: ubuntu, posix-floor,
      macos, windows. Paste the run URL: ______________________
- [ ] `claude plugin validate ./plugins/growth-engine` passed in the ubuntu job.

## Gate 2: versions and history

- [ ] `plugins/growth-engine/.claude-plugin/plugin.json` version = <version>
- [ ] `.claude-plugin/marketplace.json` version = <version>
- [ ] `dist/Launchhouse/VERSION` = <version> after the rebuild
- [ ] `CHANGELOG.md` has a dated entry for <version>, in Keep a Changelog
      format, naming every user-visible change and nothing else.
- [ ] The CHANGELOG entry is readable by a founder. No task ids, no commit
      shas, no internal shorthand.
- [ ] The pinned Claude Code version in the CI workflow is recorded in the
      CHANGELOG if it changed.

## Gate 3: regeneration

- [ ] List every skill file changed since the previous tag:
      `git diff --name-only <prev-tag>..HEAD -- plugins/growth-engine/skills/`
      Paste: ______________________
- [ ] For each changed skill, the affected worked examples have been
      regenerated, not patched. See section 6 for the map.
- [ ] Every `assets/examples/*/.generated-with` stamp matches the current
      skill hashes. `bash scripts/validate.sh` check V-21 confirms this.
- [ ] The three example folders are complete, not Brain-only:
      `find plugins/growth-engine/assets/examples -type f | wc -l` = ____
- [ ] growth-plan output is present in every full-arc example folder.
      (playbook-export output is NOT expected: it is DEFERRED.)

## Gate 4: the build artifact

- [ ] `bash scripts/build-folder.sh` run on this commit.
- [ ] `dist/Launchhouse.zip` contains no `.claude/skills` and no
      `.claude/commands`. Validate check V-09 confirms.
- [ ] The zip contains READ-ME-FIRST.md, CLAUDE.md, VERSION and a seeded
      growth-engine/ folder.
- [ ] The zip is under 2 MB. Actual: ______
- [ ] The zip has been unzipped once on a machine that did not build it,
      and opened. It opens without a security warning being the first thing
      the founder sees.

## Gate 5: rehearsal evidence

- [ ] A rehearsal receipt exists in `planning/rehearsals/` dated within 7 days
      of this tag, for each route: b2b ____, b2c-service ____, b2c-ecom ____
- [ ] At least one receipt per platform: macOS ____, Windows ____
- [ ] Every friction table in those receipts is fully resolved. No row reads
      "noted" or is blank.
- [ ] The undo drill passed in at least one full arc (byte-exact restore).
- [ ] The publish read-back passed, and the forced-failure case produced a
      `failed` ledger row with a recovery line.
- [ ] For a B2B route: Apollo enrolment observed PAUSED, evidenced.

## Gate 6: nothing unfinished ships

- [ ] `grep -rn TODO plugins/growth-engine/` returns nothing at >= 1.0.0 for
      `assets/forms/`, and nothing at >= 1.1.0 for `assets/ghl/`.
      Actual: ______________________
- [ ] `grep -rn 'FIXME\|XXX\|PLACEHOLDER\|TBC\|coming soon' plugins/ docs/ README.md`
      returns nothing.
- [ ] No file references cut scope: dm-inbox, dmgate, commands/inbox.md,
      the three conversations PIT scopes. Validate V-13 and V-14 confirm.
- [ ] The in-scope half is still present: ghl-workflows describes comment-to-DM
      capture and DM qualify-and-book, both as GoHighLevel workflows carrying
      Claude-written copy. Validate V-13's positive half confirms. Comment-to-DM
      is IN, not cut. Only reading and sending from our code is cut.
- [ ] The PIT scope list in every document is exactly the seven strings in
      `assets/ghl/pit-scopes.txt`.
- [ ] No secret-shaped string in the tree. Validate V-07 confirms.

## Gate 7: the human read

- [ ] Philip has read README.md end to end, out loud, as a founder would.
- [ ] Philip has read docs/PRE-WORK.md end to end and can name the first
      thing a Windows Home founder does.
- [ ] One person who did not build this has run the 30-minute review
      (section 7) against this commit, and their file is in
      `planning/review/`. Path: ______________________

## Tag

- [ ] `git tag -a v<version> -m "<version>: <one line>"`
- [ ] `git push --tags`
- [ ] GitHub release created, `dist/Launchhouse.zip` attached as an asset.
- [ ] Marketplace install tested from the tag on a machine that has never
      had it installed.
```

### 5.2 The three versions this list is actually for

**0.2.x, during development.** Gates 1, 2 and 4 in full.
Gate 3 applies from the first skill rewrite.
Gate 5 applies from the first rehearsal.
Gate 6's TODO items are warn only below 1.0.0, by design.

**1.0.0, the 3 September freeze.** Every gate, no exceptions.
This is the version 130 people install on 4 September, and the fix window afterwards is one day on 24 September.

**1.1.0, ready 19 September.** Every gate, plus the re-verification sweep: re-download the GoHighLevel CSV template and `cmp` against the fixture, re-probe the MCP catalog for renamed tools, re-run one publish rehearsal and one Apollo rehearsal.
External systems change without telling you, and the gap between the freeze and the event is long enough for that to matter.

---

## 6. The regression rule

**Trigger.** Every commit that changes a file under `plugins/growth-engine/skills/`.

**Owner.** The executor, at the moment of the change, not later.

**Artifact.** Regenerated example output plus an updated `.generated-with` stamp in each affected example folder.

**On failure.** Validate goes red on a stale stamp and the commit does not land.

### 6.1 The discipline, stated

Every skill change invalidates whatever that skill generated before it.
The output is regenerated, never patched.
Patching output hides the fact that the skill still produces the old thing, which means 130 founders get the old thing while the committed example shows the new thing.
That gap is invisible until Atlanta, and in Atlanta it is unfixable.

This is already the rule in `CLAUDE.md`.
What follows makes it detectable rather than remembered.

### 6.2 The map: which change invalidates what

| Skill changed | Files that are now stale | Example folders to regenerate |
|---|---|---|
| `founder-brain` | `founder-brain.md`, and transitively everything below it | All three, completely. A Brain change is a full rebuild |
| `content-engine` | `content-30.md`, `content-30.csv`, `ledger.md` C rows, `playbook-insert.md` | All three |
| `outreach-b2b` | `outreach-sequence.md`, `outreach-firstlines.csv`, `ledger.md` O rows | b2b-northfield only |
| `audience-b2c` | `dm-openers.md`, `hook-bank.md`, `inbound-scripts.md`, `ledger.md` D rows | b2c-lumen and b2c-ecom |
| `ghl-workflows` | `ops-workflow.md`, and the snapshot selection recorded in the Brain | All three |
| `ghl-publish` | `ledger.md` C row statuses and post ids, `.state/ghl-accounts.md` | All three, publish steps only |
| `connect` | `.state/receipt.md`, `.state/ghl-accounts.md` | All three, setup steps only |
| `growth-plan` | `90-day-plan.md` | All three |
| `setup` | `.state/receipt.md` | All three, setup steps only |
| `status` | Nothing on disk. It reads, it does not write | None |
| `playbook-export` | `playbook-insert.md` | None. DEFERRED, not regenerated |
| `schemas/*.md` | Nothing directly, but `ge lint` behaviour may change | Re-run `ge lint` over all three, expect clean |
| `bin/ge` or `scripts/**` | `.state/index.md`, `ops-log.md` formatting, snapshot names | Re-run `ge index` in all three, commit the diff |

Read the table top down.
A `founder-brain` change is the expensive one, and that is correct: the Brain is the root of the tree and everything downstream quotes it.

### 6.3 How to tell whether an example is stale

Do not rely on memory or on the commit log.
Stamp it.

Each example folder carries `.generated-with`:

```
founder-brain    3f1a9c2e
content-engine   a77b0d41
outreach-b2b     c02e5f88
ghl-workflows    91de4a03
growth-plan      7b6c1120
generated-at     2026-08-28T14:05:00Z
toolkit-version  0.2.4
```

Each hash is the first 8 characters of a content hash of that skill's `SKILL.md`, computed with whatever is available:

```sh
# scripts/lib/skillhash.sh: one hash function, used by both the generator and validate.
skill_hash() {
  if command -v shasum >/dev/null 2>&1; then
    shasum -a 256 "$1" | cut -c1-8
  else
    cksum "$1" | awk '{printf "%08x\n", $1}'
  fi
}
```

`cksum` is the fallback because it is in POSIX and exists everywhere, including Git Bash.
It is a weak checksum, and that is acceptable: this is drift detection, not tamper detection.

Then check V-21 in `validate.sh`:

```bash
head_ "Example freshness"

. "$REPO/scripts/lib/skillhash.sh"
STALE=""
for ex in "$PLUGIN"/assets/examples/*/; do
  [ -d "$ex" ] || continue
  stamp="$ex/.generated-with"
  [ -f "$stamp" ] || { STALE="$STALE $(basename "$ex"):no-stamp"; continue; }
  while read -r skill recorded; do
    case "$skill" in generated-at|toolkit-version|"") continue ;; esac
    sk="$PLUGIN/skills/$skill/SKILL.md"
    [ -f "$sk" ] || { STALE="$STALE $(basename "$ex"):$skill-gone"; continue; }
    now=$(skill_hash "$sk")
    [ "$now" = "$recorded" ] || STALE="$STALE $(basename "$ex"):$skill"
  done < "$stamp"
done

if [ -n "$STALE" ]; then
  err "worked examples were generated by a skill that has since changed. Regenerate, do not patch:$STALE"
  show "→ run: see planning/delivery/03-review-process.md section 6.2 for the invalidation map"
else
  ok "every worked example matches the skills that produced it"
fi
```

**Prove it.**
Change one word in `skills/content-engine/SKILL.md`.
Run validate.
Expect `FAIL  worked examples were generated by a skill that has since changed: b2b-northfield:content-engine b2c-lumen:content-engine`.
Regenerate those folders by re-running the arc, update the stamps, green.

### 6.4 The escape hatch, and its price

There will be a moment, probably around 2 September, when a one word typo fix in a skill would trigger a full regeneration of three example folders and nobody has four hours.

The escape hatch is explicit and leaves a trace:

```
# .generated-with
content-engine   a77b0d41   # ACCEPTED-STALE 2026-09-02: typo fix only, no output change. Philip.
```

Validate accepts a stamp line with an `ACCEPTED-STALE` comment, counts it as a WARN rather than a FAIL, and lists every accepted-stale entry in the summary.
The release checklist's Gate 3 requires each one to be named and justified.
That is the price: it is allowed, it is visible, and it appears on the release document with a name against it.
A silent escape hatch is the same as no rule.

---

## 7. Who reviews what

**Trigger.** Weekly, Friday morning, timeboxed to 30 minutes.
Plus one mandatory run before the 3 September freeze.
Plus one before the 19 September 1.1.0 lane.

**Owner.** A reviewer who is not the executor.
The rotation is named below and requires nobody to be hired.

**Artifact.** `planning/review/<YYYY-MM-DD>-<reviewer>.md`, produced from the template in 7.4.

**On failure.** Findings become tasks with ids, owners and dates, in the same session.
A finding is never closed by argument in a conversation.
If the reviewer is wrong, the response is a one line note in the review file explaining why, which is itself a record.

### 7.1 The problem, named honestly

Bus factor is one.
One person holds the design intent, the code, the client relationship and the calendar.
Nobody else can currently answer "is this right" about any file in this repo.
That is a real risk on 25 September and it is a fatal risk if that person is ill on 20 September.

Hiring a second engineer is not on the table, and it would not help in the time available anyway: onboarding cost exceeds the remaining calendar.

So the process has to work with reviewers who are not engineers, cannot read shell, and have 30 minutes.
That constraint shapes everything below.
The reviewer is not asked to judge code quality.
The reviewer is asked to check that the repo's own claims agree with each other, which is a task that needs care and no expertise.

### 7.2 The rotation

Four people, none of whom needs to be paid extra or newly recruited, each with a different natural angle.

| Reviewer | Natural angle | Best used for |
|---|---|---|
| Philip, 24 hours after writing | Fresh eyes on his own work | The weekly Friday slot, most weeks |
| Juan (client) | Does this match what was sold | The pre-freeze run, and any scope change |
| Eric (B2B mentor) | Does the B2B output stand up | The b2b route before 1 September |
| Helen (B2C mentor) | Does the B2C output stand up | The b2c routes before 1 September |

Philip reviewing his own work 24 hours later is a weaker check than a second person, and it is honest to say so.
It still catches a surprising amount, provided the review is done against the checklist and not by browsing.
The checklist is what converts a re-read into a review.

The mentors are already booked for 90 minutes each on 1 September to review a finished folder.
That booking becomes the mentor review slot, and the checklist below is the first 30 minutes of it.
This costs no new time and no new money.

### 7.3 The 30 minute review, in order

The order is deliberate.
Cheap and mechanical first, expensive and judgemental last, so a reviewer who runs out of time has still done the part that catches the most.

**Minutes 0 to 3: the machine's own verdict.**

```sh
cd /Users/pmudh/Documents/GitHub/Atlanta
bash scripts/validate.sh --full ; echo "validate exit=$?"
sh tests/run.sh ; echo "tests exit=$?"
```

If `tests/run.sh` does not exist yet, that command prints `sh: tests/run.sh: No such file or directory` and exits 127.
Record 127 and the words "not built yet" rather than leaving the box blank.
As of 21 August 2026 there is no `tests/` directory in the repo, so 127 is the expected answer until PRD task B-01 and the test suite in section 2 land.

Record both exit codes and both count lines.
If either is non zero, stop and write the finding.
Everything after this assumes green.

**Minutes 3 to 6: what changed since last time.**

```sh
cd /Users/pmudh/Documents/GitHub/Atlanta
git log --oneline --since="7 days ago"
git diff --stat "@{7.days.ago}..HEAD"
```

The second command uses a date-based revision rather than a commit count, so nobody has to work out how many commits ago last Friday was.
If the branch has no reflog entry that old, git says so; fall back to `git diff --stat "$(git log --since='7 days ago' --format=%H | tail -1)^..HEAD"`.

The reviewer is looking for exactly three things.
A commit whose summary does not match its diff.
A commit touching more than one task.
A skill change with no example regeneration in the same or an adjacent commit.

**Minutes 6 to 12: the facts table.**

Open `README.md` and `docs/PRE-WORK.md`.
Check these against the locked facts, by eye, one at a time.

- Event dates: Friday 25 to Sunday 27 September 2026.
- Clinic: Wednesday 23 September.
- Install command: `/plugin marketplace add Philm-moxywolf/Atlanta` then `/plugin install growth-engine@launchhouse`.
- Every command written as `/growth-engine:<name>`, never bare.
- Gate forms are Google Forms, never Typeform.
- Marketplace name is `launchhouse`.

Validate already pins most of these, which is the point: the reviewer is checking that the checks still cover what they think they cover, and reading the surrounding sentences that no check can read.

**Minutes 12 to 18: one founder file, read as a founder.**

Pick one skill at random.
Read it start to finish, out loud if alone.
Three questions only.

- Does it name the reader's doubt before answering it?
- Does it end on an action?
- Is there a sentence a nervous non technical founder would read twice?

Mark the line numbers.
Do not fix them, mark them.

**Minutes 18 to 25: one worked example, read as a mentor.**

Open `plugins/growth-engine/assets/examples/<one folder>/`.
Read `content-30.md` and, if present, `90-day-plan.md`.

- Does this sound like the founder in `founder-brain.md`, or like Claude?
- Is there a number in here that nobody could have known? (Rule 5, never invent proof.)
- Would you publish piece 7 under your own name?

**Minutes 25 to 30: the cut list and the open frictions.**

```sh
cd /Users/pmudh/Documents/GitHub/Atlanta
grep -rn "dm-inbox\|dmgate\|conversations\.readonly\|conversations/message" \
  plugins/ docs/ README.md || echo "cut list clean"
grep -rin "comment-to-dm" plugins/growth-engine/skills/ghl-workflows/SKILL.md \
  || echo "WARNING: comment-to-DM is missing and it is IN scope"
ls planning/rehearsals/
grep -rn "DOC-FIX\|TASK" planning/rehearsals/*.md 2>/dev/null | grep -v "| *$"
```

Confirm the first returns `cut list clean`.
Confirm the second returns a line rather than the warning: comment-to-DM capture is IN scope, it runs as a GoHighLevel workflow with Claude-written copy, and its absence is as much a defect as the presence of the cut material.
Confirm every friction row in every rehearsal receipt has a resolution.
Write the review file.

### 7.4 The review file template

`planning/review/TEMPLATE.md`:

```markdown
# Review <YYYY-MM-DD> by <reviewer>

Commit reviewed: <sha>
Time spent: <minutes>

## Machine verdict
validate.sh: exit ____   ____ errors, ____ warnings
tests/run.sh: exit ____  ____ passed, ____ failed

## Commits since last review
Anything where the summary and the diff disagree: ____
Anything touching more than one task: ____
Any skill change with no regeneration: ____

## Facts spot-check
Event dates ☐  Clinic date ☐  Install command ☐  Namespaced commands ☐
Google Forms ☐  Marketplace name ☐

## Founder file read: <path>
Names the doubt first: ☐    Ends on an action: ☐
Lines a nervous founder would read twice: ____

## Worked example read: <path>
Sounds like the founder, not like Claude: ☐
No invented numbers: ☐
Would publish under my own name: ☐

## Cut list, both directions
Cut material absent (dm-inbox, dmgate, commands/inbox.md, the three
conversations scopes): ☐
In-scope material present (ghl-workflows still describes comment-to-DM
capture and DM qualify-and-book as GoHighLevel workflows): ☐

## Findings

| # | Finding | Severity | Becomes | Id | Owner | Date |
|---|---|---|---|---|---|---|
| 1 |  | blocker/high/med/low | TASK or DOC-FIX or wontfix |  |  |  |

## One sentence

<The single most important thing the reviewer noticed.>
```

The last section is not filler.
A 30 minute review that produces 11 low severity findings and no headline is usually a review that missed the thing that matters.
Forcing one sentence forces a judgement.

### 7.5 Making the review packet cheap to produce

The reviewer should not have to remember the commands in 7.3.
Add `scripts/review-pack.sh` (developer tooling, bash is fine):

```bash
#!/usr/bin/env bash
# review-pack.sh: produce everything the 30-minute review needs, in one file.
#
# WHY IT EXISTS: bus factor is one. A reviewer with 30 minutes and no context
#                must not spend 10 of them working out what to run.
# CALLED BY:     humans, weekly
# READS:         the repo        WRITES: planning/review/<date>-pack.md
# POSTURE:       fail-open, a missing optional input is reported, not fatal.
# PORTABILITY:   developer tooling. bash and python3 permitted here, never in plugins/.
# EVERY ERROR MESSAGE ENDS WITH A RECOVERY LINE ("→ run: ...").
set -u

REPO="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
OUT="$REPO/planning/review/$(date -u +%Y-%m-%d)-pack.md"
mkdir -p "$REPO/planning/review"

{
  echo "# Review pack $(date -u +%Y-%m-%d)"
  echo
  echo "Commit: $(cd "$REPO" && git rev-parse --short HEAD)"
  echo
  echo '## validate.sh'
  echo '```'
  (cd "$REPO" && bash scripts/validate.sh --full 2>&1 | tail -40)
  echo '```'
  echo
  echo '## tests/run.sh'
  echo '```'
  (cd "$REPO" && sh tests/run.sh 2>&1 | tail -30) || echo "tests not present yet"
  echo '```'
  echo
  echo '## Commits, last 7 days'
  echo '```'
  (cd "$REPO" && git log --oneline --since="7 days ago")
  echo '```'
  echo
  echo '## Skill changes with no example regeneration'
  echo '```'
  (cd "$REPO" && git log --since="7 days ago" --name-only --pretty=format:'%h %s' \
     -- plugins/growth-engine/skills/ | head -40)
  echo '```'
  echo
  echo '## Cut-list grep (must be empty)'
  echo '```'
  (cd "$REPO" && grep -rn "dm-inbox\|dmgate\|conversations\.readonly\|conversations/message" \
     plugins/ docs/ README.md || echo "clean")
  echo '```'
  echo
  echo '## In-scope grep (must NOT be empty: comment-to-DM is IN, as a GHL workflow)'
  echo '```'
  (cd "$REPO" && grep -rin "comment-to-dm" plugins/growth-engine/skills/ghl-workflows/SKILL.md \
     || echo "MISSING: comment-to-DM is in scope and is not described anywhere")
  echo '```'
  echo
  echo '## Unresolved rehearsal frictions'
  echo '```'
  (cd "$REPO" && grep -rn "DOC-FIX\|TASK" planning/rehearsals/*.md 2>/dev/null || echo "no rehearsals yet")
  echo '```'
} > "$OUT"

printf 'wrote %s\n' "$OUT"
```

The reviewer opens one file, spends their 30 minutes on judgement rather than on tooling, and fills in the template.

### 7.6 What the reviewer is explicitly not asked to do

Say this in `planning/review/README.md`, because an unbounded review job gets declined.

The reviewer does not read shell code.
The reviewer does not judge architecture.
The reviewer does not verify that GoHighLevel or Apollo behave as described.
The reviewer does not need to install anything.
The reviewer does not need to be right; they need to be curious out loud, in writing, on the record.

Thirty minutes, one file in, one file out.
That is the whole job, and it is the only thing standing between one person's blind spot and 130 founders in a room in Atlanta.

---

## 8. Which recorded gaps this section closes, and which it does not

The gap register at `/Users/pmudh/Downloads/Atlanta/launchhouse-atlanta/planning/PRD-GAPS.md` carries 75 verified gaps against the PRD, of which 4 are blockers.
That file is in the private working folder and is not in the public repo.
A reader who has only the repo cannot open it, so every gap this section closes is restated below in full rather than referenced by line number.

Seven of those gaps belong to review process and are closed by the seven processes above.
Three more are adjacent, and are named here with what remains open, because a gap silently assumed closed is worse than one left on the list.

### 8.1 Closed here

**Gap: no task anywhere runs a fictional founder through the whole arc.**
Recorded severity BLOCKER.
The register's evidence is that PRD task R-01 is the only clean-machine rehearsal and its text ends at CSV export, that no task re-runs the arc against version 1.1.0, and that `find plugins/growth-engine/assets/examples -type f` returns only `README.md` and two `founder-brain.md` files, so the folders built to hold the finished runs contain nothing downstream.
Closed by process 4, the end to end rehearsal: a graded six-cell grid, four full arcs and two short arcs, a 17-step command sequence, a receipt template, and a friction rule that permits exactly two resolutions.

**Gap: no PRD task produces a finished worked example folder, yet the PRD rewrites every skill that made those folders.**
Recorded severity HIGH.
Closed jointly by process 4, which specifies that a full-arc run's complete `growth-engine/` output is committed to `plugins/growth-engine/assets/examples/<founder>/`, and by process 6, whose `.generated-with` stamp and check V-21 make a stale example detectable rather than remembered.

**Gap: the CI TODO gate is scoped to one asset README and only bites at version 1.1.0, so the four gate-form placeholders in `assets/forms/README.md` are never checked and 1.0.0 can ship with TODOs inside the plugin.**
Recorded severity LOW, twice, from two directions.
Closed by check V-20, which keeps the broad warn at every version, requires `assets/forms/README.md` to be TODO-free from 1.0.0 because Gate 1 opens on 7 September before the 1.1 lane exists, and requires `assets/ghl/README.md` to be TODO-free from 1.1.0 because that is when the three snapshot share links must be live.

**Gap: `validate.sh` hard-fails on em dashes for every `.md` under `plugins/growth-engine`, the PRD's own sample state artifacts contain em dashes, and no task reconciles the two.**
Recorded severity LOW.
Partly closed by check V-17, which fixes the dash check itself: the current implementation degrades into a raw byte match when `LANG` is unset and then reports false dashes on arrows and box-drawing characters, which would have made the reconciliation impossible to reason about.
The remaining half is a decision, not a check, and it is stated here so it is not lost: **`plugins/growth-engine/schemas/*.md` counts as founder prose and the dash rule applies to it.**
The reason is that the ledger header string documented in `schemas/ledger.md` is written verbatim into the founder's own `growth-engine/ledger.md`, so a founder reads it.
Rewrite the PRD's ledger header without the em dash rather than exempting the directory.

**Gap: `D-01` specifies a 12-command README table for a 15-command product, and `CI-01` does not update `validate.sh`'s hardcoded skill and command counts.**
Recorded severity LOW.
Closed by check V-18, which replaces the hardcoded 9 and 10 with a declared `plugins/growth-engine/MANIFEST.txt` compared against disk, and by check V-10, which fails when the README's plain-language trigger column promises a phrase the routed skill's description does not carry.

**Gap: three ACCEPT blocks contain literal placeholders instead of runnable commands.**
Recorded severity LOW.
The register names them: `G-03`'s `json.load(open(...))` with a literal ellipsis, `SS-03`'s `grep -rn "fail" skills/ | <filter>` with a placeholder filter, and `CI-02`'s `npm i -g @anthropic-ai/claude-code@<pinned>` with no version pinned.
Closed here for the CI-02 case: the workflow in section 3.2 pins `@anthropic-ai/claude-code@2.0.14` as a literal.
Closed for the G-03 case by check V-06, which parses every manifest with a complete command rather than an ellipsis.
Closed for the SS-03 case by check V-04, which replaces grepping for the word "fail" with a structural rule that every stderr write either goes through `die()` or carries its own recovery line.

**Gap: three shipped skills that write founder files (`audience-b2c`, `growth-plan`, `playbook-export`) have no owning task, so the snapshot-first rule and the "ge owns every state write" claim are unbacked for them and nothing in CI catches it.**
Recorded severity HIGH.
Closed by check V-12, which reads a declared writer map at `plugins/growth-engine/schemas/writers.md` and fails when a skill that owns a founder file does not carry a `ge snapshot <file>` instruction, or when two skills claim the same file.
Note the map in section 1.2 marks `playbook-export` as DEFERRED, which exempts it from the snapshot requirement precisely because it is not being rehearsed or regenerated.
If the reader brings `playbook-export` back into scope, change that row from `DEFERRED` to `ge snapshot` and the check starts enforcing it with no other edit.

### 8.2 Adjacent, and honestly still open

**The PRD never references `FUNCTIONAL-REVIEW.md` and no task triages its 95 verified findings.**
Recorded severity BLOCKER.
That file is at `/Users/pmudh/Downloads/Atlanta/launchhouse-atlanta/planning/FUNCTIONAL-REVIEW.md`, roughly 147 KB, in the private folder.
No check in this section can close it, because it is a one-time triage rather than standing machinery.
What this section can do, and does: process 7's weekly review is the mechanism through which the triage output stays alive once it exists.
The triage itself needs adding as a task before any spike work starts.
Its shape: one line per finding into a triage file inside the repo, each line resolving to exactly one of `fixed-by-task <id>`, `superseded-by-decision <PRD section>`, `backlog`, or `wontfix: <reason>`.
Acceptance is 95 lines, with every blocker and every high resolved to a task id or an explicit named decision.
Half a day.
Put the triage file in the repo at `/Users/pmudh/Documents/GitHub/Atlanta/planning/review-triage.md`, not in the private folder, so the executor can read it on any machine.
The findings themselves may quote the private file; strip anything commercial before committing, and let check V-07 catch a credential you miss.

**No document reconciles the PRD's build with the event calendar.**
Recorded severity BLOCKER.
Out of scope for review process.
Process 5 touches its edge only: the release checklist fixes the tag dates at 3 September for 1.0.0 and 19 September for 1.1.0, and states that if a gate cannot be ticked before a hard date then either the release moves or the scope moves, and whichever it is gets said to Juan in writing.
That converts a calendar collision into a visible decision, which is not the same as resolving it.

**No task defines the draft-to-approved transition, so the publish precondition has no producer.**
Recorded severity BLOCKER.
Out of scope for review process, and it belongs to the content engine section of this delivery plan.
Flagged here because process 4's step 8 depends on it: the rehearsal cannot publish unless the ledger has rows in the `approved` state, so if the transition is still undefined on rehearsal day, step 8 blocks and the tag blocks with it.
That is the correct behaviour, and it is worth knowing in advance rather than discovering at 9pm on 2 September.

### 8.3 What none of this covers

No check in this section reads GoHighLevel or Apollo.
Every one of them reads files in this repository.
That boundary is deliberate: a check that depends on a live external account is a check that goes red on a Tuesday when someone else's API changes, and a red check that nobody trusts is worse than no check.
External behaviour is proven by the spike, recorded in `/Users/pmudh/Documents/GitHub/Atlanta/planning/spike-findings.md`, re-verified by the sweep named in section 5.2 for version 1.1.0, and rehearsed by process 4.
Not by the validator.
