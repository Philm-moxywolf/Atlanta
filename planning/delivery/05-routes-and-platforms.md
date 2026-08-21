## All three routes, both platforms, end to end

This section is the walkthrough the client asked for and the one that does not exist anywhere today.
A grep of `/Users/pmudh/Documents/GitHub/Atlanta/planning/PRD-growth-engine-v1.md` for "clone", "walkthrough", "step-by-step" and "vertical" returns nothing.
The PRD has a runtime floor table and a one-paragraph founder story, and that is all.

Read this as five parts.
Part A is the coverage matrix, so you know how many things actually need testing.
Part B is the operator path, from a bare machine to a pushed tag.
Part C is four founder walkthroughs, one per surface, from opening a laptop to a working install.
Part D is three route journeys, one per vertical, from the first command to a running system.
Part E is the go-live checklist per route, where every line is checkable by someone who was not there.

Four things are assumed throughout and stated here once, so that nothing below depends on having read anything else.

**One: where the repository is, and how paths in this section resolve.**
The repository is `/Users/pmudh/Documents/GitHub/Atlanta`, remote `https://github.com/Philm-moxywolf/Atlanta`, marketplace name `launchhouse`.
Any path in this section that begins `plugins/`, `docs/`, `scripts/`, `planning/`, `.github/`, `.claude-plugin/`, `dist/` or `tests/` is relative to that repository root.
So `scripts/validate.sh` means `/Users/pmudh/Documents/GitHub/Atlanta/scripts/validate.sh`.
Any path that begins `growth-engine/` is relative to the individual founder's own working folder on their own machine, never to the repository.
So `growth-engine/.state/receipt.md` inside a founder folder at `/Users/jane/Launchhouse` means `/Users/jane/Launchhouse/growth-engine/.state/receipt.md`.
The private working folder, which is never public and never committed, is `/Users/pmudh/Downloads/Atlanta/launchhouse-atlanta/`, and paths to it are always written in full.

**Two: how founders install.**
Founders install with `/plugin marketplace add Philm-moxywolf/Atlanta` then `/plugin install growth-engine@launchhouse`, and every command is namespaced as `/growth-engine:<name>`.
A bare `/brain` resolves to nothing and always will.

**Three: what is in scope, and what was cut on 20 August 2026.**
Four systems are being delivered: the content engine, the outbound engine, back-end ops, and the brain (`bin/ge`).
Comment-to-DM capture and DM qualify-and-book are **IN**. They run as GoHighLevel workflows, and Claude writes the copy that goes inside them.
Cut, and not to be described anywhere as coming later: the `dm-inbox` skill, the `ge dmgate` command and its 24-hour-window code, `commands/inbox.md`, PRD spike section S-04 (conversations), and PRD task G2-02.
Claude never reads a founder inbox and nothing in this product's code sends a DM.
The three conversations scopes (`conversations.readonly`, `conversations/message.readonly`, `conversations/message.write`) are no longer requested from GoHighLevel.

**Four: the GoHighLevel Private Integration Token scope list, stated in full here so no later step has to point elsewhere.**
Where this section says "the token scopes", it means exactly these strings, and nothing else:

```
socialplanner/post.readonly
socialplanner/post.write
socialplanner/account.readonly
socialplanner/statistics.readonly
contacts.readonly
contacts.write
locations.readonly
```

That is seven strings. Every founder ticks all seven and none of the three conversations scopes.

Where a step depends on behaviour nobody has observed yet, it is marked **UNVERIFIED** and carries the exact thing to record when it is first run.
Nothing here invents an external fact, an API field, a header, a tool name or a CSV column.
That rule is stated in Part Zero of `planning/PRD-growth-engine-v1.md`, which says that if a piece of external behaviour is not in `planning/spike-findings.md` or in the PRD's verbatim blocks then it does not exist yet, and that the right move is to add a spike question rather than guess.
It holds in this document too.

---

## PART A: the coverage matrix

### A.1 The two axes, and what each one decides

There are two axes and they are almost independent.
Understanding that is the difference between twelve test runs and eight.

**The surface axis** decides how software gets onto the machine and how the founder's files are reached.
It decides nothing about what gets built.

| What the surface decides | Why it matters |
|---|---|
| How the plugin is installed | Plugins screen in the desktop app, or a slash command in the Code tab |
| Whether Git for Windows is a prerequisite | Only Windows Home. Its Code tab needs Git Bash to have a POSIX shell at all |
| Which shell `bin/ge` runs under | Cowork VM `sh`, macOS `/bin/sh`, or Git Bash `sh` |
| How the working folder is chosen | Cowork: the founder picks a folder and Claude sees only that. Code tab: whatever folder is open |
| Whether a stray `growth-engine/` folder elsewhere on the disk can be found | Code tab: yes, `find` works. Cowork: no, the model sees only the mounted folder |
| The path string written into `.state/HOME` and the receipt | `/Users/name/...` on macOS, `/c/Users/name/...` under Git Bash, and the founder sees `C:\Users\name\...` in File Explorer |
| Where the masked credential prompt appears | Decision Gate A, which is section `S-05` of `planning/spike-findings.md`. That section is marked PENDING and its answer form covers macOS Cowork only, so the other three surfaces have no field to record into yet |
| Whether the `SessionStart` hook fires | Decision Gate B, which is section `S-06` of `planning/spike-findings.md`. Marked PENDING, with answer blocks for three surfaces: macOS Cowork, macOS desktop Code tab, and Windows Home desktop Code tab under Git Bash |
| How the Apollo OAuth door is opened | Connector sign in inside Cowork, `/mcp` inside the Code tab |

**The route axis** decides what gets built and what "live" means.
It decides nothing about installation.

| What the route decides | b2b | b2c-service | b2c-ecom |
|---|---|---|---|
| Which engine 2 skill runs | `outreach-b2b` | `audience-b2c` | `audience-b2c` |
| Which GHL snapshot is imported | `b2b-core` | `b2c-service-core` | `b2c-ecom-core` |
| Whether Apollo is used at all | Yes, unless the founder is on Microsoft 365 | No | No |
| The time-critical pre-work item | Sending domain with SPF, DKIM and DMARC | Instagram converted to Business or Creator and linked to a Facebook Page | Same as b2c-service |
| Content pillar shape | Authority and problem framing, mostly text lane | Transformation and proof, mixed lane | Product-led outcome and social proof, mostly media lane |
| What ships on Saturday | 25 cold emails, or an Apollo sequence activated | 25 Instagram DMs sent by hand | 25 Instagram DMs sent by hand |

### A.2 The twelve cells

The baseline is **b2b on macOS Cowork**. Every other cell is that plus a surface delta plus a route delta.
Read the two delta columns together. There is exactly one place where they interact, and it is marked.

| Cell | Route | Surface | Surface delta from baseline | Route delta from baseline |
|---|---|---|---|---|
| 1 | b2b | macOS Cowork | Baseline | Baseline |
| 2 | b2b | macOS Code tab | Install by slash command, not the Plugins screen. Folder is the open folder. Whole-disk search for a stray folder is possible. Apollo OAuth is opened with `/mcp` | None |
| 3 | b2b | Windows Pro or Enterprise Cowork | **Nothing differs from cell 1** inside the session. Outside it: the founder picks the folder in File Explorer, and the folder path they read back is `C:\Users\...`. Hyper-V must be on for Cowork to exist at all | None |
| 4 | b2b | Windows Home Code tab | Git for Windows must be installed first. Shell is Git Bash. Paths inside the shell read `/c/Users/...`. **This is where the Apollo OAuth door and Git Bash meet, the one cross term in the matrix** | None |
| 5 | b2c-service | macOS Cowork | None | `audience-b2c` instead of `outreach-b2b`. `b2c-service-core` snapshot. No Apollo, no domain. Instagram and Facebook prerequisites instead |
| 6 | b2c-service | macOS Code tab | Same as cell 2 | Same as cell 5 |
| 7 | b2c-service | Windows Pro or Enterprise Cowork | Same as cell 3 | Same as cell 5 |
| 8 | b2c-service | Windows Home Code tab | Same as cell 4, minus the Apollo cross term, because this route never touches Apollo | Same as cell 5 |
| 9 | b2c-ecom | macOS Cowork | None | As cell 5, plus: `b2c-ecom-core` snapshot, an abandoned-checkout workflow that needs store data in GoHighLevel, product page URLs in the DM flow, and the largest media-lane share of the 30 pieces |
| 10 | b2c-ecom | macOS Code tab | Same as cell 2 | Same as cell 9 |
| 11 | b2c-ecom | Windows Pro or Enterprise Cowork | Same as cell 3 | Same as cell 9 |
| 12 | b2c-ecom | Windows Home Code tab | Same as cell 4, minus the Apollo cross term | Same as cell 9 |

### A.3 The honest count

Twelve cells. Seven things to test.

**Three surface behaviours, not four.**
Windows Pro or Enterprise Cowork is the same product as macOS Cowork once the session is open, because Cowork runs the same Linux virtual machine either way.
What differs is outside the session: enabling Hyper-V, picking a folder in File Explorer rather than Finder, and the Windows-shaped path the founder reads back to you when something goes wrong.
So test it once for the install and the folder-picking, and do not repeat the route work there.

**Three route behaviours, and they are genuinely three.**
b2b and b2c are different products. b2c-service and b2c-ecom are the same skill with a different snapshot, different pillar flavour, a different media-lane split and one extra prerequisite that nothing currently states, which is where the abandoned-checkout data comes from.
Do not collapse b2c-service and b2c-ecom. The snapshot copy maps are different files and the ecom one has a dependency the other does not.

**One cross term.**
The Apollo OAuth door is the only thing that behaves differently because of the route *and* the surface at once.
It is opened by a connector sign in inside Cowork and by `/mcp` inside the Code tab, and only the b2b route opens it.
A Microsoft 365 b2b founder never opens it at all, which is why the manual route in Part D is a first-class path rather than a footnote.

Everything else is additive. That is why eight runs cover twelve cells.

### A.4 The minimum run set

Eight runs. Each one is a receipt in `/Users/pmudh/Documents/GitHub/Atlanta/planning/rehearsals/`, named as shown.
That directory already exists in the repository. If it is empty, that is correct: no run has happened yet.

| Run | Cell | What it covers | Stop at | Receipt file |
|---|---|---|---|---|
| R-A | 2 | Full b2b arc on macOS Code tab, as Sam Okoye | Go-live checklist B complete | `arc-b2b-macos-code.md` |
| R-B | 6 | Full b2c-service arc on macOS Code tab, as Priya Raman | Go-live checklist C complete | `arc-b2c-service-macos-code.md` |
| R-C | 10 | Full b2c-ecom arc on macOS Code tab, as a third fictional founder | Go-live checklist D complete | `arc-b2c-ecom-macos-code.md` |
| R-D | 1 or 5 or 9 | macOS Cowork: install, folder pick, `/growth-engine:setup` receipt, brain, content, stop | Content generated | `surface-macos-cowork.md` |
| R-E | 3 or 7 or 11 | Windows Pro Cowork: same as R-D | Content generated | `surface-windows-pro-cowork.md` |
| R-F | 12 | Windows Home Code tab: Git for Windows install, plugin install, full b2c-ecom arc under Git Bash | Go-live checklist D complete | `arc-b2c-ecom-windows-home.md` |
| R-G | 4 | Windows Home Code tab: b2b only as far as the Apollo OAuth door and one paused enrollment | Sequence enrolled paused | `apollo-door-windows-home.md` |
| R-H | 1 | macOS Cowork: Apollo OAuth door only, b2b | Sequence enrolled paused | `apollo-door-macos-cowork.md` |

R-A, R-B and R-C are the three full arcs. R-C also produces the third worked example folder, which does not exist today.
R-F is the run that matters most, because Windows Home Git Bash is the runtime floor and every `ge` call in the product has to survive it.
R-D and R-E are short on purpose. Repeating the route work on Cowork buys nothing once R-A to R-C have passed.

Record a screen recording for R-D, R-E and R-F rather than a transcript.
The same footage is the onboarding video and the Atlanta backup, so one sitting closes three jobs.

Every run answers Decision Gate A and Decision Gate B for its surface.
As of 21 August 2026, `planning/spike-findings.md` section `S-05` (Gate A) has one answer form and it is written for macOS Cowork only, and section `S-06` (Gate B) has three per-surface answer blocks with no Gate A fields in them.
Before the first run, add these three lines to each per-surface block in `S-06`, so that one pass over a machine answers both gates:

```
  masked prompt appeared?      yes / no
  value hidden while typing?   yes / no
  header substituted (401)?    yes / no
```

The 401 is the success case, not a failure. A 401 from GoHighLevel proves the token value was substituted into the header and sent. A missing server, or an error about a malformed header, is the failure case.
The probe plugin that produces these answers is at `planning/spike/gate-ab-plugin/` and is run with `/gate-ab-probe:spike-check`.
Type `pit-DUMMY-not-real` when it asks for a token. Never type a live token into a probe, and never paste a token into a conversation on any surface.

---

## PART B: the operator path

This is for whoever builds and ships the plugin, on their own machine.
It is not a founder path, so bash and python3 are allowed here and only here.
Nothing in this part runs on a founder machine.

### B.0 What the tree looks like today, 21 August 2026

Check it rather than trusting this paragraph.

```
cd /Users/pmudh/Documents/GitHub/Atlanta && git log --oneline | wc -l && git rev-list --left-right --count origin/main...main && git tag
```

Expect `11` for the total commit count, then a line reading `0	10`, which means zero commits behind `origin/main` and ten ahead of it, then `v0.1.0`.
Ten ahead of one means `origin/main` is still sitting on the initial commit alone.
The tag `v0.1.0` exists locally and has never been pushed.

Confirm what does not exist yet:

```
ls -d /Users/pmudh/Documents/GitHub/Atlanta/plugins/growth-engine/bin \
      /Users/pmudh/Documents/GitHub/Atlanta/.mcp.json \
      /Users/pmudh/Documents/GitHub/Atlanta/hooks \
      /Users/pmudh/Documents/GitHub/Atlanta/schemas \
      /Users/pmudh/Documents/GitHub/Atlanta/tests 2>&1
```

Expect five `No such file or directory` lines. `bin/ge`, `.mcp.json`, `hooks/hooks.json`, `schemas/` and `tests/` all still have to be built.

Confirm what does exist:

```
ls /Users/pmudh/Documents/GitHub/Atlanta/plugins/growth-engine/skills
ls /Users/pmudh/Documents/GitHub/Atlanta/plugins/growth-engine/commands
ls /Users/pmudh/Documents/GitHub/Atlanta/plugins/growth-engine/assets/examples
```

Expect nine skills (`audience-b2c`, `content-engine`, `founder-brain`, `ghl-workflows`, `growth-plan`, `outreach-b2b`, `playbook-export`, `setup`, `status`), ten commands (`brain.md`, `content.md`, `doctor.md`, `engine2.md`, `gate.md`, `ops.md`, `plan.md`, `playbook.md`, `setup.md`, `status.md`), and two worked-example folders plus a README (`b2b-northfield`, `b2c-lumen`, `README.md`).

### B.1 Clone, or confirm the existing checkout

On a fresh machine:

```
mkdir -p ~/Documents/GitHub
cd ~/Documents/GitHub
git clone https://github.com/Philm-moxywolf/Atlanta.git
cd ~/Documents/GitHub/Atlanta
git log --oneline -3
```

That puts the checkout at `~/Documents/GitHub/Atlanta`, which is the path every other command in this section assumes.

On the machine this document was written on the checkout already exists at `/Users/pmudh/Documents/GitHub/Atlanta`.
Do not clone a second copy. Two checkouts is how two people push conflicting versions of `plugin.json`.

**If the clone fails with a permission error**, the repository is not public yet.
Check at `https://github.com/Philm-moxywolf/Atlanta` while signed out.
Until the first real push lands, the remote holds only the initial commit, so a clone gives you an almost empty tree even when it succeeds.
Work from the local checkout until B.8 has been done once.

### B.2 Prerequisites, macOS

Run all five checks in one go:

```
git --version; bash --version | head -1; python3 --version; command -v zip; command -v shellcheck
```

| Tool | Why it is needed | If it is missing |
|---|---|---|
| `git` | Everything | `xcode-select --install` |
| `bash` | `scripts/validate.sh` uses `${BASH_SOURCE[0]}` and `set -uo pipefail` | Built into macOS. Version 3.2 is fine |
| `python3` | `validate.sh` and `build-folder.sh` both parse JSON with it | `xcode-select --install`, or install Python from python.org |
| `zip` | `build-folder.sh` produces `dist/Launchhouse.zip` | Built into macOS |
| `shellcheck` | Optional locally, required in CI by PRD task CI-01 | `brew install shellcheck` |

Note the split deliberately.
`validate.sh` and `build-folder.sh` are operator scripts and may use bash and python3.
Anything under `plugins/growth-engine/bin/` or `plugins/growth-engine/scripts/` is a founder path and is POSIX `sh` only, no bash, no python, no node, no jq.
That line is the whole reason the Windows Home row exists in Part A.

### B.3 Prerequisites, Windows operator

Only relevant if the person building the plugin is on Windows. Founders do not do this.

1. Install Git for Windows from `https://git-scm.com/download/win`. This gives you Git Bash.
2. Install Python 3 from `https://www.python.org/downloads/windows/`, and tick **Add python.exe to PATH** on the first installer screen.
3. Open Git Bash and check:

```
git --version; bash --version | head -1; python --version; command -v zip
```

**`command -v zip` returns nothing on a default Git for Windows install.**
That is a real limitation, not a mistake in your setup. `scripts/build-folder.sh` calls `zip` at line 87, and the script will stop there with `zip: command not found`.
The exact line is:

```
( cd "$OUT" && rm -f Launchhouse.zip && zip -qr Launchhouse.zip Launchhouse -x '*.DS_Store' )
```

Two ways out, in order of preference:
- Build the release zip on macOS or on the Linux CI runner, and never on Windows.
- Or run everything up to that line, then produce the archive with PowerShell from outside Git Bash, in the repository root:

```
Compress-Archive -Path dist\Launchhouse -DestinationPath dist\Launchhouse.zip -Force
```

Record whichever you use in the commit body so the next person does not rediscover it.

### B.4 Run the validator

This is the only automated check the project has today. It runs on every push through `.github/workflows/validate.yml`.

```
bash /Users/pmudh/Documents/GitHub/Atlanta/scripts/validate.sh
```

**What you should see.** Section headers for Manifests, Skills, Commands, Command namespacing, Placeholders, House style, Design rules, Locked facts and Hygiene, then a final block:

```
----------------------------------------
0 error(s), 2 warning(s)
PASS
```

Both warnings are expected today, and neither is a defect.

The first is `asset placeholders still open`, naming the six GoHighLevel share links, the three gate form links and the tracking sheet. It clears when those assets exist.

The second is `DM automation mentioned. Confirm each line refuses it, never offers it`, and it lists four lines: three in `plugins/growth-engine/skills/audience-b2c/SKILL.md` and one in `plugins/growth-engine/skills/setup/SKILL.md`.
Read those four lines every time this warning appears. Each one must refuse automated cold DMs or describe inbound comment-to-DM capture, which is allowed and is in scope.
The warning exists so that nobody quietly adds a fifth line that offers automation. It is a prompt to check, not an error to silence.
If you ever see a count higher than four, read the new line before doing anything else.

**If it prints `FAIL`.** Every failing line names the file and shows the offending text, truncated to 150 characters.
Fix the file, not the check.
The only time you edit `scripts/validate.sh` is when the product legitimately changed what the check should be looking for, and then the same commit changes both. Never two commits.

**Common failures and what they mean.**

| Line you see | What actually happened | Fix |
|---|---|---|
| `manifest versions disagree` | You bumped one of `.claude-plugin/marketplace.json` or `plugins/growth-engine/.claude-plugin/plugin.json` and not the other | Bump both to the same string |
| `install suffix does not match marketplace name` | A doc says `growth-engine@something-else` | Correct the doc. The marketplace name `launchhouse` is fixed, because it is inside the install command 130 people will be sent |
| `bare command reference` | A founder-facing file contains `/brain` or `/setup` rather than `/growth-engine:brain` | Namespace it, or rewrite it as plain language |
| `em dash or en dash in a founder-facing file` | A dash slipped into `README.md`, `docs/` or anything under `plugins/` | Replace with a comma, a colon, brackets, or split the sentence |
| `banned marketing word` | One of the eight banned words or three banned phrases appears | Rewrite the sentence |
| `internal material is tracked in the public-bound repo` | A file from the private working folder got committed | `git rm --cached <file>`, add it to `.gitignore`, and check nothing else came with it |
| `git tracks N skills and M commands, but X and Y exist on disk` | `.gitignore` is swallowing plugin files. This happened once already, with an unanchored `growth-engine/` pattern | Anchor the pattern with a leading slash |

**If `python3` is not found**, every manifest check silently degrades to an error rather than a parse.
Install python3 before assuming the JSON is broken.

### B.5 Run the tests

```
sh /Users/pmudh/Documents/GitHub/Atlanta/tests/run.sh
```

**This file does not exist yet.** PRD task B-01 creates it, and PRD task CI-02 runs it on ubuntu, macOS and Windows runners.
Until it exists, the substitute check is a parse pass over every shell file in the product:

```
find /Users/pmudh/Documents/GitHub/Atlanta/scripts \
     /Users/pmudh/Documents/GitHub/Atlanta/plugins/growth-engine/bin \
     /Users/pmudh/Documents/GitHub/Atlanta/plugins/growth-engine/scripts \
     -type f \( -name '*.sh' -o -name 'ge' \) 2>/dev/null \
| while read -r f; do sh -n "$f" && echo "ok   $f" || echo "FAIL $f"; done
```

**What you should see.** One `ok` line per file, and today that is two lines, for `validate.sh` and `build-folder.sh`.
Both are bash scripts, so `sh -n` on them proves only that they parse, not that they are POSIX. That is fine, because they are operator scripts.

**If a file under `plugins/growth-engine/` fails `sh -n`**, you have a bash-ism on a founder path.
The constructs that cause this, in rough order of how often they appear, are `[[ ]]`, arrays, `local` outside a function, `${BASH_SOURCE}`, `echo -e`, and `$'...'`.
Rewrite it. Do not add a bash shebang, because Windows Home founders get Git Bash's `sh` and the CI Windows runner will catch it anyway once CI-02 lands.

**Once `tests/run.sh` exists**, run it under three shells before you trust it:

```
sh  /Users/pmudh/Documents/GitHub/Atlanta/tests/run.sh
dash /Users/pmudh/Documents/GitHub/Atlanta/tests/run.sh   # if dash is installed, it is the strictest
bash /Users/pmudh/Documents/GitHub/Atlanta/tests/run.sh
```

If it passes under `bash` and fails under `sh` or `dash`, that failure is real and it is exactly the failure Windows Home founders would have hit.

### B.6 Build the working-folder zip

```
bash /Users/pmudh/Documents/GitHub/Atlanta/scripts/build-folder.sh
```

**What you should see.**

```
built dist/Launchhouse.zip  (toolkit 0.1.0)
  9 skills, 10 commands
```

**What this is for.** The zip is the fallback distribution and the pre-seeded working folder. It is never the primary install path.
The marketplace is the primary path on every surface.

**Note the pending change.** PRD task D-03 stops the zip from carrying `.claude/skills` and `.claude/commands` at all, because the plugin should be the only carrier of skills and shipping a second copy creates version skew.
After D-03 lands the expected output changes and `validate.sh` gains a check that fails if the zip stages a skills folder.
If you are reading this after D-03, the two counted lines above will be gone.

**If it fails with `zip: command not found`**, see B.3.
**If it fails on the `python3 -c` line**, python3 is missing. See B.2.
**If `dist/` does not appear in `git status`**, that is correct. `/dist/` is in `.gitignore` and the zip ships as a release asset, not in the tree.

### B.7 Install your build locally, to test it

You cannot test the founder experience by reading the files. You have to install the plugin the way a founder does.

**Route 1, local path marketplace. UNVERIFIED.**

In Claude Code, from any folder:

```
/plugin marketplace add /Users/pmudh/Documents/GitHub/Atlanta
/plugin install growth-engine@launchhouse
```

The idea is that a directory containing `.claude-plugin/marketplace.json` can be added as a marketplace by absolute path, which would give you a dev install that points at your working tree.
Nobody has run this. Run it once, and write what happened into a new section of `planning/spike-findings.md` called `S-08 local marketplace install`, with the exact output pasted.
`S-08` is free: that file currently ends at `S-07 Apollo paid`, followed by an `Open spike questions` block.
While you are in that file, strike `S-04 conversations`. It was cut on 20 August 2026 along with the `dm-inbox` skill, and leaving it PENDING makes it look like outstanding work.

**If the path form is rejected**, fall back to Route 2.

**Route 2, a scratch remote.** Push the branch you are testing to a second GitHub repository you own, add that as a marketplace, install from it, and delete it afterwards.
Slower, but it exercises the same code path founders use and it always works.

**Never test by editing files inside an installed plugin's directory.** You will fix something that does not exist in the repo and lose the change.

**Picking up an edit after a local install:**

```
/plugin marketplace update launchhouse
```

then quit and reopen the app.
Whether `/plugin marketplace update` re-reads a local path marketplace is part of the same UNVERIFIED question. Record it in the same S-08 block.

**Before you call a dev install working**, run `/growth-engine:setup` in a scratch folder and confirm the receipt names the version you just built. If it names an older version you are testing the wrong copy.

### B.8 The first push, and the public-repo check

This is the step that has never been done and it is the one with a one-way door in it.
Ten commits and one tag are sitting on one laptop, and the repository is going public.

**Check what you are about to publish, before you publish it.**

```
cd /Users/pmudh/Documents/GitHub/Atlanta
git ls-files | grep -inE 'proposal|brief|mentor|rate|MASTERPLAN|TASKS|RUNBOOK|AUDIT|EXECUTE|STATE'
```

**What you should see.** No output at all.
`validate.sh` already checks a narrower version of this in its Hygiene section, but the grep above is wider and takes two seconds.

**Then decide, deliberately, whether `planning/` ships.**

```
git ls-files planning/
```

Today that lists the PRD, the superseded plan, the spike findings, the probe plugin and this delivery document.
None of it is founder material and all of it becomes public the moment you push.
Nothing in it is commercially sensitive in the way the private folder at `/Users/pmudh/Downloads/Atlanta/launchhouse-atlanta/` is, but it is internal build reasoning with named individuals in it.
Make the call once and record it. The two options are: push it as is, or move `planning/` into the private folder and keep only `docs/` and the plugin public.

**Then push.**

```
cd /Users/pmudh/Documents/GitHub/Atlanta
bash scripts/validate.sh
git status --short
git log --oneline origin/main..HEAD
git push origin main
```

**What you should see.** `validate.sh` prints `PASS`. `git status --short` is empty or shows only files you meant to leave uncommitted. The log lists the ten commits. The push reports the new head.

**If the push is rejected as non-fast-forward**, somebody else pushed. Do not force.
Run `git fetch origin && git log --oneline main..origin/main` to see what landed, then rebase or merge, then run `validate.sh` again before retrying.

**If the push succeeds but `/plugin marketplace add Philm-moxywolf/Atlanta` still fails for a founder**, the most likely cause is that `.claude-plugin/marketplace.json` is not at the repository root on the default branch.
Confirm with `git ls-tree origin/main --name-only .claude-plugin/`.

### B.9 Tag and release

Tags are cheap and the freeze date is a locked fact. Version 1.0.0 is due Thursday 3 September 2026, and the repository, onboarding email and printed playbook follow on Friday 4 September.

**Bump both manifests together.** `validate.sh` fails if they disagree.

```
cd /Users/pmudh/Documents/GitHub/Atlanta
grep -n '"version"' .claude-plugin/marketplace.json plugins/growth-engine/.claude-plugin/plugin.json
```

Edit both to the same string, add the `CHANGELOG.md` entry, then:

```
cd /Users/pmudh/Documents/GitHub/Atlanta
bash scripts/validate.sh
git add -A
git commit -m "R-02: freeze v1.0.0

Both manifests at 1.0.0, CHANGELOG entry added. validate.sh PASS, 0 errors."
git tag -a v1.0.0 -m "v1.0.0: toolkit freeze for Launchhouse Atlanta"
git push origin main
git push origin v1.0.0
```

**Decide what to do with `v0.1.0`.** It exists locally and has never been pushed.
Push it. It is the honest history and it costs nothing.

```
cd /Users/pmudh/Documents/GitHub/Atlanta
git push origin v0.1.0
```

**Attach the zip to the release**, so the fallback path has somewhere to point:

```
cd /Users/pmudh/Documents/GitHub/Atlanta
bash scripts/build-folder.sh
gh release create v1.0.0 dist/Launchhouse.zip --title "v1.0.0" --notes "See CHANGELOG.md"
```

`CHANGELOG.md` does not exist in the repository as of 21 August 2026. Create it in the same commit that bumps the two manifests, or change the `--notes` text to the release summary itself.

**If `gh` is not installed**, use the GitHub web interface: Releases, Draft a new release, choose the existing tag `v1.0.0`, drag in `dist/Launchhouse.zip`.

**If a founder reports they got an old version after the tag**, remember that the marketplace serves the default branch, not the tag.
Tags are for you. The founder's `/plugin marketplace update launchhouse` reads `main`.
That means a fix pushed to `main` reaches founders whether or not it is tagged, which is why the freeze is a discipline rather than a mechanism.

### B.10 The operator loop, in one block

Once the above is set up, the daily cycle is:

```
cd /Users/pmudh/Documents/GitHub/Atlanta
# 1. make one task's change
bash scripts/validate.sh                  # must print PASS
sh tests/run.sh                           # once it exists
git add -A
git commit -m "<task-id>: <imperative summary>"
git push origin main
```

One task, one commit. The commit body states what changed and the acceptance evidence in one line.
Never commit past a failing validator.

---

## PART C: the founder path, one walkthrough per surface

Four walkthroughs. Each starts with a closed laptop and ends with a proven install and a named working folder.
None of them build anything yet. Building is Part D.

Three things are true in all four and are worth reading before you pick one.

**The account-scoping trap.** The plugin installs per Claude account, not per machine.
A founder who installs on their work account and turns up in Atlanta signed in on their personal account has no plugin and no files.
This is the single most expensive avoidable failure in the programme, because it is discovered in the room.
Pick the account in step 2 and never change it.

**The reload step is not proven.** `README.md` line 20, `docs/PRE-WORK.md` line 46, `plugins/growth-engine/skills/setup/SKILL.md` line 71 and `scripts/build-folder.sh` line 59 all tell founders to run `/reload-plugins`.
Nobody has confirmed that command exists. It is recorded as unverified in `/Users/pmudh/Downloads/Atlanta/launchhouse-atlanta/planning/FUNCTIONAL-REVIEW.md`.
Until it is confirmed, the walkthroughs below put quit-and-reopen first, because that is certain, and offer `/reload-plugins` as the faster thing to try.
Confirm it on all four surfaces during the Part A runs and then correct or remove those four lines.

**The Cowork plugins entry point is not pinned.** `README.md` and `docs/PRE-WORK.md` say the plus button next to the message box, then Plugins.
`planning/spike-findings.md` section S-05 says Cowork, then Customize, then Plugins.
Both are written from belief. Pin the real path during run R-D and correct whichever document is wrong.

### C.1 Walkthrough one: macOS, Cowork

This is the default recommendation for anyone who does not already work with files.

1. **Open the Claude desktop app.** If it is not installed, download it from `https://claude.ai/download`, open the `.dmg`, drag Claude into Applications, and open it from Applications.
   *You should see* a sign-in screen or a chat window.
   *If macOS blocks it* with "cannot be opened because it is from an unidentified developer", open System Settings, Privacy and Security, scroll to the bottom, and click Open Anyway.

2. **Sign in on the account you will bring to Atlanta.** If you have a work account and a personal account, choose now.
   *You should see* your own name or email in the app, usually bottom left.
   *If you are not sure which account you are on*, sign out and sign back in deliberately. Write the email address on a sticky note. You will need the same one in September.

3. **Confirm you are on a paid plan.** Plugins require one.
   *You should see* a paid plan named in your account settings.
   *If you are on the free plan*, upgrade now. Nothing below works without it, and this is a stated cost of the programme.

4. **Open the Plugins screen.** Try the plus button next to the message box first, then Plugins. If that menu has no Plugins entry, look for Customize, then Plugins.
   *You should see* a screen listing marketplaces and installed plugins, with a way to add a marketplace.
   *If neither route shows a Plugins screen*, your app is out of date. Quit the app fully with Command Q, reopen it, and let it update. If it still is not there, post in the Slack channel rather than hunting.

5. **Add the marketplace.** Enter `Philm-moxywolf/Atlanta`.
   *You should see* a marketplace called `launchhouse` appear, offering one plugin called `growth-engine`.
   *If it says not found*, check for a typo, especially the capital P and the capital A. If the spelling is right and it still fails, the repository may not be public yet. Post in Slack.

6. **Install `growth-engine`.**
   *You should see* it listed as installed, with a version number.
   *If you added the marketplace but never pressed install*, nothing will work and there is no error message anywhere. This is the most common first-hour failure. Go back and check the plugin itself says installed, not just the marketplace.

7. **Quit the app fully and reopen it.** Command Q, not the red close button.
   *You should see* the app start fresh.
   *If you want to skip this*, try `/reload-plugins` in a new conversation first. If that command is not recognised, quit and reopen.

8. **Start a new Cowork session and pick your working folder.** Create a folder first if you do not have one: in Finder, go to your home folder, make a new folder called `Launchhouse`, so the full path is `/Users/<yourname>/Launchhouse`.
   *You should see* Cowork confirm the folder it is working in.
   *If you pick a different folder every time*, your work scatters and none of the later steps find it. Pick this folder once and open it every single time.

9. **Type `/growth-engine:setup`.** You can also just say "check my setup". Both work.
   *You should see* Claude report that the plugin is loaded, name a version, and tell you the full path of the folder your work will live in.
   *If the command does not appear as you type it*, work through these in order: you typed it without the `/growth-engine:` prefix; you added the marketplace but never installed the plugin (step 6); you have not quit and reopened since installing (step 7); you are signed in on a different account from the one you installed on (step 2).

10. **Write down the folder path it gives you.** Put it somewhere you will find it in September.
    *You should see* something like `/Users/yourname/Launchhouse/growth-engine`.
    *If the path surprises you*, it is because Cowork can only see the folder you picked. Go back to step 8 and pick the folder you meant.

11. **Stop.** Setup should tell you that you are set up and have not started yet. That is the correct place to stop before Session 1.
    *If it tells you something is wrong*, run `/growth-engine:doctor`, or say "something is broken", and follow what it says. Two attempts, then Slack.

**What Cowork cannot do, stated once.** Claude sees only the folder you picked.
If you built work in a different folder last week, Claude cannot go and find it.
You have to find it yourself with Finder search for a folder named `growth-engine`, then pick that folder in a new session.

### C.2 Walkthrough two: macOS, desktop Code tab

For founders who want to see and edit the files. Nothing in this programme requires it.

1. **Open the Claude desktop app and sign in on the account you will bring to Atlanta.** Same as C.1 steps 1 to 3, including the paid plan check.

2. **Create your working folder** in Finder before you start: `/Users/<yourname>/Launchhouse`.
   *You should see* an empty folder.
   *If you put it inside iCloud Drive*, files can be evicted to the cloud and appear missing. Keep it directly in your home folder.

3. **Open the Code tab and open that folder.**
   *You should see* the folder name shown somewhere in the interface, and a prompt waiting for input.
   *If there is no Code tab*, your app is out of date. Quit with Command Q and reopen so it updates.

4. **Type the first install line and press return:**

   ```
   /plugin marketplace add Philm-moxywolf/Atlanta
   ```

   *You should see* confirmation that a marketplace called `launchhouse` was added.
   *If it says not found*, check the spelling including capitals. If it is right, the repository may not be public yet. Post in Slack.

5. **Type the second install line and press return:**

   ```
   /plugin install growth-engine@launchhouse
   ```

   *You should see* confirmation that `growth-engine` is installed, with a version.
   *If you stop after step 4*, nothing works and nothing tells you why. Both lines are required.

6. **Quit the app fully with Command Q and reopen it**, then reopen the same folder.
   *You should see* the Code tab back on `/Users/<yourname>/Launchhouse`.
   *If you would rather not restart*, try `/reload-plugins` first and only restart if that is not recognised.

7. **Type `/growth-engine:setup`.**
   *You should see* the plugin version, the working folder path, and a confirmation that a test file was written and read back.
   *If the command is not recognised*, work through the same four causes as C.1 step 9, in the same order.

8. **Confirm the folder path it names is the one you created.**
   *You should see* `/Users/<yourname>/Launchhouse/growth-engine`.
   *If it names somewhere else*, you opened a different folder. Close it, open `/Users/<yourname>/Launchhouse`, and run setup again.

9. **Stop.** Setup will tell you that you are set up and have not started yet.

**What the Code tab can do that Cowork cannot.** It can search your whole disk.
If you think you built work somewhere and cannot find it, ask Claude to run:

```
find ~ -maxdepth 5 -type d -name growth-engine -not -path '*/Library/*' 2>/dev/null
```

That prints every candidate folder. Pick the right one and work there from now on.

### C.3 Walkthrough three: Windows Pro or Enterprise, Cowork

Identical to C.1 once the session is open. The differences are all before that point.

1. **Check which Windows edition you have.** Press the Windows key, type `winver`, press return.
   *You should see* a box naming Windows 11 Pro, Enterprise, Education, or Home.
   *If it says Home*, stop. Cowork is not available to you. Go to walkthrough C.4 instead. This is not a downgrade, it is a different door to the same product.

2. **Install the Claude desktop app** from `https://claude.ai/download` and run the installer.
   *You should see* Claude in your Start menu.
   *If SmartScreen blocks it*, click More info, then Run anyway.

3. **Sign in on the account you will bring to Atlanta.** Same trap as C.1 step 2, same consequence.

4. **Confirm you are on a paid plan.** Same as C.1 step 3.

5. **If Cowork does not start**, the most common cause is that the machine virtualisation feature is turned off.
   *You should see* Cowork open a session and confirm a folder.
   *If it does not*, open Windows Features (press the Windows key, type "Turn Windows features on or off"), enable Virtual Machine Platform and Hyper-V, restart the machine, and try again.
   *If your workplace has locked those settings*, you cannot enable them. Use walkthrough C.4 instead, which needs none of this.

6. **Open the Plugins screen.** Plus button next to the message box, then Plugins. If there is no Plugins entry there, look for Customize, then Plugins.

7. **Add the marketplace** `Philm-moxywolf/Atlanta`, then **install `growth-engine`**. Both steps, same as C.1 steps 5 and 6.

8. **Quit the app completely and reopen it.** Closing the window is not enough on Windows. Right-click Claude in the taskbar and choose Close window, or quit it from the system tray near the clock.

9. **Create your working folder in File Explorer** before starting a session: `C:\Users\<yourname>\Launchhouse`.
   *If your Documents folder is redirected to OneDrive*, do not put it there. Files that are online-only will look missing.
   Put it directly under `C:\Users\<yourname>\`, as shown.

10. **Start a Cowork session and pick that folder.**
    *You should see* Cowork confirm the folder.

11. **Type `/growth-engine:setup`.**
    *You should see* the same report as C.1 step 9.
    *If the command does not appear*, same four causes in the same order.

12. **Write down the folder path.** Claude may show it in a Linux-shaped form. What you type into File Explorer is `C:\Users\<yourname>\Launchhouse`.
    *If the two forms look different*, that is expected and not a problem. They are the same folder.

13. **Stop.** Setup will tell you that you are set up and have not started yet.

### C.4 Walkthrough four: Windows Home, desktop Code tab

This is the hardest configuration and the one that sets the technical floor for the whole product.
No Hyper-V means no Cowork, which means the Code tab, which needs Git for Windows so there is a POSIX shell on the machine at all.

It is still twelve steps and none of them are hard. There is no terminal work in it.

1. **Confirm you are on Windows Home.** Press the Windows key, type `winver`, press return.
   *You should see* Windows 11 Home or Windows 10 Home.
   *If it says Pro or Enterprise*, use walkthrough C.3 instead. It is fewer steps.

2. **Install Git for Windows.** Go to `https://git-scm.com/download/win` and the download starts on its own.
   *You should see* a file named something like `Git-2.x.x-64-bit.exe` in your Downloads.
   *If nothing downloads*, click the "64-bit Git for Windows Setup" link on that page directly.

3. **Run the installer and click Next through every screen, with one exception.**

   The exception is the screen headed **Adjusting your PATH environment**.
   *You should see* three options, with the middle one already selected: **Git from the command line and also from 3rd-party software**.
   Leave it on that middle option. Do not choose "Use Git from Git Bash only", because that hides Git from Claude and you will get an unhelpful error later that has nothing obviously to do with this screen.

   Every other screen can stay on its default, including the editor choice, the branch name, the line-ending conversion, and the terminal emulator.

   *If you are not sure you got the PATH screen right*, run the installer again. It is safe to reinstall over the top and it will remember your other answers.

   **UNVERIFIED.** These installer screen titles are from the current Git for Windows setup and have not been re-checked on a clean machine for this programme.
   Confirm them during run R-F in Part A and correct this step and `docs/PRE-WORK.md` from what you actually see.

4. **Confirm Git Bash exists.** Press the Windows key and type `Git Bash`.
   *You should see* it in the results.
   *If it is not there*, the install did not finish. Run the installer again.

   You never have to open Git Bash. Claude uses it behind the scenes. You just need it present.

5. **Install the Claude desktop app** from `https://claude.ai/download`.
   *If SmartScreen blocks it*, click More info, then Run anyway.

6. **Sign in on the account you will bring to Atlanta**, and confirm you are on a paid plan.
   Same trap, same consequence: the plugin installs per account, and switching accounts later means installing again and hunting for your files.

7. **Create your working folder in File Explorer:** `C:\Users\<yourname>\Launchhouse`.
   *Do not put it inside a OneDrive-backed Documents folder.* Online-only files look missing to Claude and the failure is confusing.
   *If you are not sure*, right-click the folder, and if you see OneDrive options such as "Always keep on this device", it is inside OneDrive. Move it to `C:\Users\<yourname>\`.

8. **Open the Code tab in Claude and open that folder.**
   *You should see* the folder name in the interface.
   *If there is no Code tab*, quit Claude completely from the system tray and reopen it so it updates.

9. **Type the two install lines, one at a time:**

   ```
   /plugin marketplace add Philm-moxywolf/Atlanta
   ```

   ```
   /plugin install growth-engine@launchhouse
   ```

   *You should see* a marketplace called `launchhouse`, then a plugin called `growth-engine` reported as installed with a version.
   *If you stop after the first line*, nothing works and there is no error. Both lines are required.

10. **Quit Claude completely and reopen it**, then reopen `C:\Users\<yourname>\Launchhouse`.
    On Windows, closing the window is not quitting. Use the system tray near the clock, or right-click the taskbar icon and close it from there.
    *If you would rather not restart*, try `/reload-plugins` first and restart only if it is not recognised.

11. **Type `/growth-engine:setup`.**
    *You should see* the plugin version, a confirmation that a test file was written and read back, and the full path of your working folder.
    *If the path it shows starts with `/c/Users/`* rather than `C:\Users\`, that is normal and correct. It is the same folder written the way the shell sees it.
    *If the command does not appear*, work through: missing `/growth-engine:` prefix, marketplace added but plugin never installed, not restarted since installing, wrong account.
    *If setup reports it cannot write a file*, the folder is inside OneDrive or in a protected location. Go back to step 7.

12. **Stop.** Setup will tell you that you are set up and have not started yet.

**What to record from this walkthrough during run R-F**, because it is the floor:
whether the `SessionStart` hook fired without you typing anything, whether `ge` is invokable directly or only as `sh "${CLAUDE_PLUGIN_ROOT}/scripts/ge.sh"`, whether the masked credential prompt appeared, and the exact path string written into `.state/HOME`.
Those four answers are Decision Gate A and Decision Gate B for this surface, and every skill in the product depends on them.

---

## PART D: the three route journeys

Each route is the same spine with a different fork in the middle and a different definition of live.
The spine is common. Say so to founders rather than making three of them think they are on a bespoke path.

### D.0 The command spine, and what exists today

| Order | Command | Plain language | Exists today | Produces |
|---|---|---|---|---|
| 1 | `/growth-engine:setup` | "check my setup" | Yes | The receipt at `growth-engine/.state/receipt.md` |
| 2 | `/growth-engine:brain` | "build my founder brain" | Yes | `growth-engine/founder-brain.md` |
| 3 | `/growth-engine:content` | "build my content engine" | Yes | `content-30.md`, `content-30.csv`, `rss-feeds.md`, 30 ledger rows |
| 4 | `/growth-engine:connect` | "connect my accounts" | **No.** PRD task G2-01 | The connect section of the receipt, `.state/ghl-accounts.md` |
| 5 | `/growth-engine:engine2` | "build my outreach engine" or "build my audience engine" | Yes | Forks on `track`. See D.1, D.2, D.3 |
| 6 | `/growth-engine:ops` | "find my bottleneck" | Yes | `ops-workflow.md` |
| 7 | `/growth-engine:publish` | "publish my content" | **No.** PRD task C-03 | Scheduled posts in GHL Social Planner, ledger rows updated with post ids |
| 8 | `/growth-engine:plan` | "build my 90 day plan" | Yes | `90-day-plan.md` |
| 9 | `/growth-engine:status` | "where am I up to" | Yes | A progress report. Run any time |
| 10 | `/growth-engine:gate` | "build my gate submission" | Yes | A block to paste into the gate Google Form |
| 11 | `/growth-engine:doctor` | "something is broken" | Yes | Diagnosis with evidence |
| 12 | `/growth-engine:update` | "update the toolkit" | **No.** PRD task SS-02 | Version check and the per-surface update steps |
| 13 | `/growth-engine:undo` | "undo that" | **No.** PRD task B-03 | Restores the last snapshot of a file |
| 14 | `/growth-engine:playbook` | "generate my playbook insert" | Yes, but **DEFERRED** | See D.5 |

**Two scope notes, stated here rather than left implicit.**

`skills/growth-plan` is **IN**. It is the Sunday deliverable, it is small, and it reads the brain that is being built anyway.
It currently never reads the `track` field, so both tracks get an identical plan. That is a defect to fix, not a reason to cut it.

`skills/playbook-export` is **DEFERRED** unless the reader decides otherwise.
It compiles a personalised insert from files that are all changing shape in this build. Compiling from a moving target wastes the work.
If it is reinstated, it slots in at position 14, after `plan`, and it needs the same regeneration discipline as everything else.

### D.0.1 The calendar this maps onto

| When | What the founder does | Which command |
|---|---|---|
| From Fri 4 September | Install and prove it | 1 |
| Session 1, Mon 7 or Tue 8 September | Build the Brain. Gate 1 | 2, then 10 |
| Session 2, Mon 14 or Tue 15 September | Build the content engine. Connect GoHighLevel with the mentors. Gate 2 | 3, 4, then 10 |
| Session 3, Mon 21 or Tue 22 September | Update drill. Build engine 2 and the ops copy. Schedule the content. Gate 3 | 12, 5, 6, 7, then 10 |
| Clinic, Wed 23 September | Import the snapshot in GoHighLevel, paste the copy, wire the links | None. This is browser work |
| Fix window, Thu 24 September | Whatever broke | 11 |
| Fri 25 to Sun 27 September | Send, meet people, plan | 8 on Sunday |

**OPEN, and it blocks nothing but needs deciding this week.**
`docs/PRE-WORK.md` tells founders to pay for GoHighLevel at the clinic on 23 September, so that a trial does not expire during the weekend.
The PRD puts the guided token creation and the `connect` step at Session 2, in the week of 14 September.
Those two cannot both be true, because a token needs an account.

Three ways out, in order of preference:

1. **Move the GoHighLevel purchase to the start of Session 2 week.** Costs each founder one extra month, roughly 97 USD, and is the only ordering where connect at Session 2 and publish at Session 3 both work as designed.
2. **Move `connect` to Session 3 and publishing to the clinic.** Costs nothing, but it puts a credential walk and a publish rehearsal into the same afternoon as 130 snapshot imports.
3. **Connect against a mentor-provided test location at Session 2, and reconnect against the founder's own at the clinic.** Two credential walks per founder. Do not do this.

Recommend option 1. Flag it for Philip and Juan, and correct `docs/PRE-WORK.md` and the costs table in the same commit as whichever is chosen.

Related and still open: `docs/PRE-WORK.md` line 101 names GoHighLevel Starter at 97 USD a month plus usage as the tier founders buy.
What no document states is whether Starter is sufficient for comment-to-DM capture, or whether that needs a higher tier.
That question belongs to whoever builds the three snapshots, and it has to be answered against a live GoHighLevel account rather than from the pricing page.
Both b2c routes depend on the answer, and so does the 97 USD figure in the costs table, which will be wrong if a higher tier turns out to be required.

### D.1 Route b2b

**Who this is.** Sells to other businesses. Roughly 65 of the 130 founders. The worked example is Sam Okoye, fractional operations for construction firms, at `plugins/growth-engine/assets/examples/b2b-northfield/`. That folder contains one file, `founder-brain.md`. Nothing downstream of the Brain has ever been produced for this route either, so run R-A in Part A produces the rest of it.

**Ordered sequence**

| Step | Command or action | Produces | Outside Claude, before or after |
|---|---|---|---|
| 1 | `/growth-engine:setup` | Receipt, working folder | Install per Part C |
| 2 | `/growth-engine:brain` | `founder-brain.md` with `Track: b2b` | Nothing |
| 3 | `/growth-engine:content` | `content-30.md`, `content-30.csv`, 30 ledger rows | Nothing |
| 4 | `/growth-engine:connect`, GoHighLevel branch | Receipt connect section, `.state/ghl-accounts.md` | Buy GoHighLevel. Create the GoHighLevel Private Integration Token with exactly the seven scopes listed in the preamble to this section: `socialplanner/post.readonly`, `socialplanner/post.write`, `socialplanner/account.readonly`, `socialplanner/statistics.readonly`, `contacts.readonly`, `contacts.write`, `locations.readonly`. Do not tick any `conversations` scope. Connect LinkedIn and any other publishing accounts in Social Planner |
| 5 | `/growth-engine:connect`, Apollo branch | Connected mailbox recorded in the Brain's Channels block | Buy the Apollo paid seat with a work email. Connect the sending mailbox to Apollo. **Skip this whole step if the mailbox is Microsoft 365** |
| 6 | `/growth-engine:engine2` | `outreach-sequence.md`, `outreach-firstlines.csv`, 25 `O` rows in the ledger, an Apollo sequence enrolled paused | Buy the domain if there is not one. Configure SPF, DKIM and DMARC. Send 10 to 20 normal emails a day from it |
| 7 | `/growth-engine:ops` | `ops-workflow.md` with the `b2b-core` key to copy table | Nothing yet |
| 8 | `/growth-engine:publish` | Text-lane posts scheduled in Social Planner, read back, ledger updated | Nothing |
| 9 | Clinic, 23 September | Nothing in Claude | Import the `b2b-core` snapshot from its share link. Paste every `lh_*` value. Set the booking link and sending identity. Run one test contact through the whole workflow |
| 10 | Saturday 26 September | Nothing in Claude | Press activate on the Apollo sequence, or send the first two touches by hand on the Microsoft 365 route |
| 11 | `/growth-engine:plan` | `90-day-plan.md` | Nothing |

**Where b2b diverges from the other two routes.** Steps 5, 6, 9 and 10 only.
Steps 1, 2, 3, 4, 7, 8 and 11 are identical across all three routes, and step 7 differs only in which snapshot's copy map gets filled.

**The Microsoft 365 manual route, in full.**

This is a first-class path. It is not a fallback, it is not a consolation, and it must not be written as one anywhere a founder can read it.
At 25 messages it meets the promise completely, costs nothing beyond the domain, needs no new account, and replies land in the mailbox the founder already reads.

The fork happens once, at the first question `outreach-b2b` asks: is the work email on Google, on Microsoft 365, or on something else.
The answer is recorded in `outreach-sequence.md` and nobody chooses twice.

What changes on the manual route:

| Thing | Apollo route | Microsoft 365 manual route |
|---|---|---|
| The Apollo seat | Paid, required | Not needed. Do not tell them to buy one |
| Step 5 of the sequence above | Apollo OAuth door | Skipped entirely |
| List building | Live people search through the Apollo MCP, 35 built and cut to 25 | The founder builds the 25 by hand, from LinkedIn, industry lists, or their own records |
| The 25 messages | A sequence with `{{first_line}}` per contact | 25 finished messages, written out in full, with the name and the detail already in the text. No merge variables at all, because there is nothing to substitute and nothing to render wrong in front of a prospect |
| `outreach-firstlines.csv` | An import file | A checklist. Who, the opening line, and a column to tick when sent |
| Follow-up touches | Sequence handles the waits | Outlook scheduled send, **two touches at a time, never all four**. If someone replies there are only two things to cancel, and cancelling is the job people forget |
| Stop on reply | On by default in Apollo. Confirm rather than assume | The founder's own job, every time. This is the single thing most likely to be forgotten three weeks after the event |
| Opt-out line | In every touch | In every touch. Identical requirement |

The manual route needs one thing the Apollo route does not: a named reminder mechanism.
Put a line in the founder's `90-day-plan.md` under Monday morning that says when to check for replies and cancel scheduled sends. Without it, the cancellation step has no home.

**Cold email never goes through GoHighLevel on either route.** GoHighLevel is the CRM, the publisher and the inbound machine.
Apollo, or the founder's own mailbox, is the cold sender. Pushing an Apollo-sourced cold list through GoHighLevel's email tool risks the same sub-account that runs their one live workflow.

**Go-live definition for b2b.** See Part E, checklist B.

### D.2 Route b2c-service

**Who this is.** Sells a service to consumers. Coaches, salons, gyms, clinics, trainers, therapists, local trades selling to households.
The worked example closest to this is Priya Raman at `plugins/growth-engine/assets/examples/b2c-lumen/`, although Lumen is a product business and therefore closer to D.3. A service example does not exist yet and one should be produced.

**Ordered sequence**

| Step | Command or action | Produces | Outside Claude, before or after |
|---|---|---|---|
| 1 | `/growth-engine:setup` | Receipt, working folder | Install per Part C |
| 2 | `/growth-engine:brain` | `founder-brain.md` with `Track: b2c` and `Model: service` | Nothing |
| 3 | `/growth-engine:content` | `content-30.md`, `content-30.csv`, 30 ledger rows split text lane and media lane | Nothing |
| 4 | `/growth-engine:connect`, GoHighLevel branch | Receipt connect section, `.state/ghl-accounts.md` | Buy GoHighLevel. Create the GoHighLevel Private Integration Token with exactly the seven scopes listed in the preamble to this section: `socialplanner/post.readonly`, `socialplanner/post.write`, `socialplanner/account.readonly`, `socialplanner/statistics.readonly`, `contacts.readonly`, `contacts.write`, `locations.readonly`. Do not tick any `conversations` scope. **Convert Instagram to Business or Creator and link a Facebook Page.** Connect both to Social Planner |
| 5 | Apollo | Nothing. This route never touches Apollo | Nothing |
| 6 | `/growth-engine:engine2` | `dm-openers.md` with 25 openers, `hook-bank.md` with 30 hooks and 3 offer tests, `inbound-scripts.md` | Build the list of 25 real target accounts. About an hour of homework. Record any video the media-lane pieces call for |
| 7 | `/growth-engine:ops` | `ops-workflow.md` with the `b2c-service-core` key to copy table | Nothing yet |
| 8 | `/growth-engine:publish` | Text-lane posts scheduled, read back, ledger updated. Media-lane pieces listed with what each needs | Upload any media to the GoHighLevel Media Library and take the public URL, or keep those pieces for the CSV route |
| 9 | Clinic, 23 September | Nothing in Claude | Import `b2c-service-core`. Paste every `lh_*` value. Set the comment keyword, the booking calendar and the link in bio. Send one test comment from a second account and confirm the DM arrives |
| 10 | Saturday 26 September | Nothing in Claude | Send the 25 DMs by hand, spread across the afternoon with gaps, from an account used normally in the weeks before |
| 11 | `/growth-engine:plan` | `90-day-plan.md` | Nothing |

**The rule that cannot bend.** No automated cold Instagram or Facebook DMs, ever.
Automated cold DMs get accounts restricted. The Instagram API only permits messaging after the other person contacts you first.
The 25 openers are sent by hand from the founder's own app. Automation lives entirely on the inbound side, where it is fully supported.

**The pacing warning belongs in `dm-openers.md`, not only in the session.**
Twenty-five DMs fired in a burst can trigger an action block, especially on a younger or low-activity account.
The file must also say what a block looks like, that it is temporary, that the founder should stop rather than retry, and how to finish the remaining openers the next day.
Without that, a blocked founder reads it as the toolkit having damaged their account.

**Where the inbox lives.** In the GoHighLevel app. Claude never reads it and never drafts replies to it.
Claude writes the copy that goes inside the GoHighLevel workflow, and the founder reads and replies in GoHighLevel.
That is deliberate. It was decided on 20 August 2026, and it removes every piece of Meta messaging policy from our code, because our code never sends a DM and never touches a 24-hour messaging window.

Specifically cut, and none of it may be described as coming later: the `dm-inbox` skill, the `ge dmgate` command and the 24-hour-window code behind it, `commands/inbox.md`, PRD spike section `S-04`, and PRD task `G2-02`.
The three GoHighLevel `conversations` scopes are no longer requested, which is why the token scope list in the preamble to this section is seven strings and contains none of them.

What is **not** cut, and must not be written as if it were: comment-to-DM capture, and DM qualify-and-book.
Both are in scope. Both run as GoHighLevel workflows inside the founder's own location, triggered by GoHighLevel, sent by GoHighLevel.
Claude's job is to write the copy that sits inside those workflows, and that copy lands in `inbound-scripts.md` and in the `lh_*` keys of `ops-workflow.md`.
Checklist item C10 in Part E proves the comment-to-DM workflow by actual test, and it is the item that proves this route.

**Go-live definition for b2c-service.** See Part E, checklist C.

### D.3 Route b2c-ecom

**Who this is.** Sells a physical or digital product to consumers, through a store. Skincare, food, apparel, supplements, homeware.
The closest worked example is Priya Raman at `plugins/growth-engine/assets/examples/b2c-lumen/`, and it is a Brain only. Everything downstream of the Brain has never been produced for this route.

**Ordered sequence.** Identical to D.2 with four differences, marked in bold.

| Step | Command or action | Produces | Outside Claude, before or after |
|---|---|---|---|
| 1 | `/growth-engine:setup` | Receipt, working folder | Install per Part C |
| 2 | `/growth-engine:brain` | `founder-brain.md` with `Track: b2c` and **`Model: ecommerce`**, plus the three ecommerce intake additions: platform, average order value band, repeat-purchase share | Nothing |
| 3 | `/growth-engine:content` | 30 pieces with an **ecommerce pillar flavour**: product-led outcome rather than transformation, and a heavier social-proof lean. Expect the largest media-lane share of the three routes | Nothing |
| 4 | `/growth-engine:connect`, GoHighLevel branch | Receipt connect section, `.state/ghl-accounts.md` | Same as D.2, plus **connect the store to GoHighLevel** if the abandoned-checkout workflow is going to fire |
| 5 | Apollo | Nothing. This route never touches Apollo | Nothing |
| 6 | `/growth-engine:engine2` | Same three files as D.2 | Same as D.2. **Product page URLs are needed for the DM flow destination** |
| 7 | `/growth-engine:ops` | `ops-workflow.md` with the **`b2c-ecom-core`** key to copy table: comment-to-DM capture, abandoned-checkout chase, post-purchase review | Nothing yet |
| 8 | `/growth-engine:publish` | Same as D.2, with more media-lane rows listed and fewer scheduled | Upload media, take public URLs |
| 9 | Clinic, 23 September | Nothing in Claude | Import `b2c-ecom-core`. Paste every `lh_*` value. **Confirm the abandoned-checkout trigger has a data source.** Run one test order through post-purchase review |
| 10 | Saturday 26 September | Nothing in Claude | Send the 25 DMs by hand, same pacing rules as D.2 |
| 11 | `/growth-engine:plan` | `90-day-plan.md` | Nothing |

**The dependency nothing currently states.**
`b2c-ecom-core` contains an abandoned-checkout chase. That workflow needs checkout events to reach GoHighLevel.
For a Shopify store that means connecting Shopify to GoHighLevel. For anything else it means a bridge, which is the n8n escape hatch.
No document in this repository states how many founders will need a bridge, and no count has been measured. Do not quote a proportion to anyone. Find out per founder at Session 3 by asking which store platform they are on, and record the answers, so that by the clinic on 23 September you have a real list rather than an estimate.

Decide before the clinic which of these applies to each ecommerce founder:
- Store connects natively. The workflow fires. Nothing extra needed.
- Store needs a bridge. Flag it at Session 3 for one-to-one support, and do not let it be discovered at the clinic.
- Store cannot be connected in time. Import the snapshot with the abandoned-checkout branch left off, and say so plainly in `ops-workflow.md` rather than leaving a workflow that looks live and is not.

**The media-lane problem is largest here.**
In the worked example inside `planning/PRD-growth-engine-v1.md` at line 456, the ecommerce founder's 30 pieces split 23 media lane to 7 text lane.
That means the majority of an ecommerce founder's content cannot be scheduled by `/growth-engine:publish` at all until a public media URL exists.
Two roads, both acceptable, and the founder chooses:
- Upload to the GoHighLevel Media Library, take the public URL, and the piece schedules like any other.
- Keep the piece for the CSV route and schedule it by hand later.

What must not happen is a founder believing 30 pieces are scheduled when 7 are.
The publish summary has to state both numbers.

**The inbox rule applies here unchanged.**
Claude never reads the founder's Instagram or GoHighLevel inbox and never drafts a reply into it, on this route or any other.
Comment-to-DM capture and DM qualify-and-book are in scope on this route too, as GoHighLevel workflows with Claude-written copy, and they arrive inside the `b2c-ecom-core` snapshot alongside abandoned checkout and post-purchase review.

**Go-live definition for b2c-ecom.** See Part E, checklist D.

### D.4 Where the three routes are identical

Say this to founders. It reduces the feeling that everyone else got a better version.

| Step | Identical across b2b, b2c-service and b2c-ecom |
|---|---|
| Install and setup | Completely identical. The route is not known yet |
| The Founder Brain | Same skill, same intake structure. Group 3 branches on track and Group 2 asks the model question on the B2C side only |
| Content generation | Same skill, same 30 pieces, same batches of ten, same voice capture, same never-invent rule. Only the pillar flavour and the lane split differ |
| Connect, GoHighLevel half | Completely identical. Same seven token scopes (`socialplanner/post.readonly`, `socialplanner/post.write`, `socialplanner/account.readonly`, `socialplanner/statistics.readonly`, `contacts.readonly`, `contacts.write`, `locations.readonly`), same two verification reads, same receipt |
| Publish | Completely identical mechanism. Only the ratio of text lane to media lane differs |
| Ops engine | Same skill, same bottleneck diagnostic. The snapshot is chosen automatically from track plus model, so the founder never picks |
| The 90-day plan | Same skill today. It should branch on track and does not, which is a defect to fix |
| Status, gate, doctor, update, undo | Completely identical |

### D.5 The two skills outside the four systems

**`growth-plan` is IN.**
It is the Sunday deliverable, it reads the brain, and it is cheap.
Two known defects go with it: it never reads the `track` field, so a B2B and a B2C founder get the same plan; and it asks for numbers the Founder Brain intake never collects.
Both are fixable in the same pass. Neither is a reason to cut it.

**`playbook-export` is DEFERRED.**
It reads every file the four systems are currently changing, and compiling from a moving target wastes the work.
The README promises it as a PDF and the skill has no route to producing one on either operating system, so it also carries an unsolved conversion problem.

State which of these applies wherever it comes up. Do not silently drop either one.
If the reader decides to reinstate `playbook-export`, it needs: a task, a settled input shape, and a named PDF route on macOS and Windows, or a self-contained HTML file the founder opens and prints.

---

## PART E: go-live definition

Four checklists. A is common and every founder has to pass it. Then one of B, C or D by route.

Every item names how it is verified. Nothing here is satisfied by a founder saying it is done.
`/growth-engine:gate` is instructed to check the file rather than take the founder's word, and these checklists are written to the same standard.

### Checklist A: common to all three routes

| # | Must be true | How you verify it |
|---|---|---|
| A1 | The plugin is installed on the Claude account the founder will bring to Atlanta | `/growth-engine:setup` runs and names a version. Ask them to read out the account email and compare it to what they wrote down |
| A2 | The working folder is anchored and reachable | The setup receipt at `growth-engine/.state/receipt.md` shows the folder line as PASS with a full absolute path |
| A3 | Claude can write to that folder | The receipt shows the write probe as PASS: canary created, read back, deleted |
| A4 | There is exactly one `growth-engine` folder on the machine | On a Code tab, `find ~ -maxdepth 5 -type d -name growth-engine -not -path '*/Library/*' 2>/dev/null` returns one line. In Cowork, the founder searches in Finder or File Explorer and reports one result |
| A5 | Closing and reopening lands in the same place | Quit the app, reopen, open the same folder, run `/growth-engine:status`. It finds the Brain without being told where it is |
| A6 | `founder-brain.md` exists and is locked | The file exists, has a `Track:` line reading `b2b` or `b2c`, has a `Model:` line if the track is `b2c`, has a thesis sentence, and has a Locked date |
| A7 | The Brain's Flags section has no unresolved item that blocks the weekend | Read the Flags section. The two that block are the sending domain on b2b and the Instagram account type on b2c |
| A8 | 30 content pieces exist and are in the ledger | `content-30.md` contains 30 numbered pieces. `ledger.md` contains 30 rows beginning `C|` |
| A9 | The 30 pieces have been edited for voice, not just generated | The founder can point at three pieces and say what they changed. A file that is byte-identical to the generated draft has not been edited |
| A10 | `content-30.csv` matches the real GoHighLevel template header | The first line of the CSV is identical to the first line of `plugins/growth-engine/assets/ghl/social-planner-template.csv`. `ge lint` checks this. **That template file does not exist yet.** As of 21 August 2026 `plugins/growth-engine/assets/ghl/` contains only `README.md`. The header row has to be taken from a real Social Planner CSV export and committed before this item can be verified by anyone. Until then A10 is unverifiable, not passed |
| A11 | GoHighLevel is connected and proven by a read, not by a hope | The receipt shows the connect line as PASS, names the location, and gives a count of connected social accounts. The token itself appears nowhere in any file |
| A12 | At least one batch of content is scheduled in Social Planner and read back | The publish summary shows N scheduled and N verified by read-back. The ledger rows for those pieces carry a GoHighLevel post id. The posts are visible in the Social Planner interface at the intended local time |
| A13 | The founder knows the difference between their scheduled count and their total | The publish summary states both numbers. A founder who thinks 30 are scheduled when 7 are has not passed this item |
| A14 | `ops-workflow.md` exists with every copy key filled | Grep the file for the `lh_` prefix. Every key in the matching copy map appears with real copy against it, and none is left as a placeholder. The copy map lives at `plugins/growth-engine/assets/ghl/snapshots/<slug>.md`, where `<slug>` is `b2b-core`, `b2c-service-core` or `b2c-ecom-core`. **Neither that directory nor those three files exist yet.** As of 21 August 2026 `plugins/growth-engine/assets/ghl/README.md` lists six workflows, all marked TODO: B2B lead follow-up, B2B discovery booking, B2B proposal chase, B2C comment-to-DM capture, B2C DM qualify and book, B2C review request. Building the three copy maps is a precondition for A14 being checkable at all |
| A15 | The snapshot is imported into the founder's own GoHighLevel location | Open the founder's location. The workflows from the snapshot are listed |
| A16 | One workflow has been run end to end with a test contact and the message arrived | Add a test contact, trigger the workflow, and receive the message on the real channel. A workflow that has never fired is not live |
| A17 | `90-day-plan.md` exists with one number, Monday's first three actions, and kill criteria | The file has all three sections. The kill criteria contain an actual number, not a feeling |
| A18 | `/growth-engine:doctor` reports no FAIL lines | Run it. Every line reads PASS with the evidence beside it |

### Checklist B: b2b only

| # | Must be true | How you verify it |
|---|---|---|
| B1 | The sending route is recorded and the founder can say which one they are on | `outreach-sequence.md` names Apollo or the manual Microsoft 365 route in its first section |
| B2 | The sending domain authenticates | SPF, DKIM and DMARC all pass on a public checker. Record the result, not the intention |
| B3 | The domain has real sending history | The founder can show sent mail from that domain across at least the previous three weeks, at 10 to 20 a day. If the domain was bought after roughly 8 September this item fails and they must use an older domain instead |
| B4 | A sequence exists with 4 to 5 touches, all under 120 words | Open `outreach-sequence.md` and count. Word count per touch is checkable |
| B5 | Every touch carries an opt-out line in the body | Read all four or five. Not one of them may be missing it. A tool's unsubscribe link does not satisfy this |
| B6 | Every touch has a stated wait interval | Read them. Three to four working days is the normal spacing |
| B7 | 25 contacts exist with a personalised first line each | `outreach-firstlines.csv` has 25 data rows and no empty `first_line` cell |
| B8 | No first line contains an invented detail | Spot-check five against their source. A generic honest line is a pass. A specific claim with no source is a fail |
| B9 | On the Apollo route: the sequence is enrolled and paused | Open Apollo. The sequence shows 25 contacts and its state is paused, not active |
| B10 | On the Apollo route: stop on reply is on | Open the sequence settings and confirm it, rather than assuming the default |
| B11 | On the Apollo route: the founder knows exactly where to press activate | Ask them to point at it without help |
| B12 | On the manual route: 25 finished messages exist, with no merge variables | Read three at random. If any contains `{{` it fails |
| B13 | On the manual route: the first two touches are scheduled in Outlook, and only the first two | Open the Outlook outbox and count |
| B14 | On the manual route: a named reminder exists to check replies and cancel scheduled sends | It appears in `90-day-plan.md` under Monday morning with a day and a time |
| B15 | Nothing cold is going through GoHighLevel | Ask directly. The cold list is in Apollo or in the founder's own mailbox, never in the GoHighLevel email tool |

### Checklist C: b2c-service only

| # | Must be true | How you verify it |
|---|---|---|
| C1 | Instagram is a Business or Creator account | Open the account settings and read the account type |
| C2 | A Facebook Page is linked to it | Open the linked accounts screen and read the page name |
| C3 | Both are connected to GoHighLevel Social Planner | The connect receipt reports a social account count of at least 2, and the accounts are named |
| C4 | `dm-openers.md` contains 25 openers against 25 real handles | Count them. Every one has a handle beside it and no handle is a placeholder |
| C5 | Every opener is two sentences or fewer, with no pitch | Read five at random |
| C6 | No opener contains an invented detail | Spot-check five against the target account. If there was nothing specific to say, the opener should be written from the shared situation, and that is a pass |
| C7 | The pacing warning is inside `dm-openers.md`, not only in a session | Grep the file. It must also say what an action block looks like and to stop rather than retry |
| C8 | `hook-bank.md` contains 30 hooks in six categories and 3 offer tests | Count them. Each offer test names what it is testing |
| C9 | `inbound-scripts.md` contains the comment keyword, the auto-DM, the follow-up, and the qualify-and-book flow | Read it. The qualify flow is three or four steps, not an interrogation |
| C10 | The comment-to-DM workflow fires | Comment the keyword from a second Instagram account and receive the DM. This is the item people skip and it is the one that proves the route |
| C11 | The DM flow has a real destination | The booking calendar or product page URL is live and opens. A placeholder URL fails this |
| C12 | The link in bio points at that destination | Open the profile on a phone and tap it |
| C13 | At least one of the 25 DMs has been sent by hand and the founder knows the pacing plan | Ask them how many they are sending per hour and from which account |

### Checklist D: b2c-ecom only

Everything in Checklist C applies, with C9 to C11 read against the ecommerce snapshot, plus the following.

| # | Must be true | How you verify it |
|---|---|---|
| D1 | The Brain records the platform, the average order value band and the repeat-purchase share | Read `founder-brain.md`. All three fields present |
| D2 | The snapshot imported is `b2c-ecom-core`, not `b2c-service-core` | Open the workflows in their location and read the names. Abandoned checkout and post-purchase review should be there |
| D3 | The abandoned-checkout workflow has a data source, or is explicitly switched off with the reason recorded | Either the store is connected and a test checkout fires the workflow, or `ops-workflow.md` states in plain words that this branch is off and who is picking it up |
| D4 | The post-purchase review workflow has been run with a test order | Place a test order. The review request arrives |
| D5 | The DM flow destination is a product page that loads and can be bought from | Open it on a phone and go as far as the cart |
| D6 | The media plan is real | For every media-lane piece, the founder can say which of the two roads it is on: uploaded with a public URL, or held for the CSV. A piece on neither road is not going to be published |
| D7 | The founder knows their scheduled count | Ask them. If the answer is 30 and the publish summary said 7, go back to A13 |

### E.1 What "live" means, in one sentence per route

**b2b is live** when 25 authenticated, personalised, opt-out-carrying messages are either enrolled in a paused Apollo sequence the founder can activate on their own, or written out in full with the first two touches scheduled from their own mailbox, and one GoHighLevel workflow has fired for a real test contact.

**b2c-service is live** when the Instagram account is Business or Creator and linked to a Facebook Page, both are publishing through GoHighLevel with at least one batch scheduled and read back, the comment-to-DM workflow has been proven by an actual comment from a second account, and 25 openers exist against 25 real handles with a pacing plan the founder can describe.

**b2c-ecom is live** when everything in the b2c-service definition is true against the `b2c-ecom-core` snapshot, the post-purchase review workflow has fired for a test order, and the abandoned-checkout branch either fires from real store data or is switched off with the reason written down and an owner named.

None of these definitions mention replies, sales or followers, and none of them may.
Replies depend on list quality, offer and timing, and nothing in this product controls any of the three.
Live means the machine runs. It does not mean the machine works, and the difference is worth stating out loud to a founder before they leave.
