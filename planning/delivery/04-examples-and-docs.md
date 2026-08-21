## Example content, and the documentation set

This section owns two things that are currently almost entirely absent from the repository at `/Users/pmudh/Documents/GitHub/Atlanta`.
The first is the set of worked example folders that founders read to calibrate before they build, and that mentors mark gate submissions against.
The second is every document a founder, a mentor, a teaching assistant or a future contributor reads.

Both are late-stage deliverables in the sense that they describe finished behaviour.
Both are early-stage deliverables in the sense that if nobody writes them, the four systems ship without a way for a founder to learn them, and the mentor reviews booked for 1 September 2026 have nothing to review.

Task identifiers in this section use two prefixes.
`EX-nn` covers the example folders and their generation harness, and the prefix is new.
`D-nn` covers documentation, and it extends the Phase 9 series already present in `/Users/pmudh/Documents/GitHub/Atlanta/planning/PRD-growth-engine-v1.md`.
`D-01` to `D-04` keep the meaning the PRD gives them.
`D-05` upward are new here, and two of them absorb PRD tasks that were filed under other phases: `D-05` absorbs the PRD's `G2-03` (`docs/CONNECTIONS.md`), `D-08` absorbs `G-02` (`CHANGELOG.md`), `D-09` absorbs `G-01` (root `CLAUDE.md`) and `D-12` absorbs `O-02` (the snapshot copy maps).
Where another section of this delivery plan renumbers, the mapping table in this section governs the files this section names.

**Path conventions used throughout this section.**
Any path written without a leading slash, for example `scripts/validate.sh` or `plugins/growth-engine/assets/examples/`, is relative to the repository root `/Users/pmudh/Documents/GitHub/Atlanta`.
Two review documents referenced repeatedly live outside the repository, in the private working folder, and are always given in full: `/Users/pmudh/Downloads/Atlanta/launchhouse-atlanta/planning/PRD-GAPS.md` and `/Users/pmudh/Downloads/Atlanta/launchhouse-atlanta/planning/FUNCTIONAL-REVIEW.md`.
Neither of those two is inside the repository, and neither may be copied into it.
Run folders and fixtures also live in the private folder, at `/Users/pmudh/Downloads/Atlanta/launchhouse-atlanta/runs/` and `/Users/pmudh/Downloads/Atlanta/launchhouse-atlanta/fixtures/`.

---

## Part A. Example content

### A.1 What exists on disk today, verified 21 August 2026

Run this to see it for yourself.

```sh
find /Users/pmudh/Documents/GitHub/Atlanta/plugins/growth-engine/assets/examples -type f | sort
wc -l -c /Users/pmudh/Documents/GitHub/Atlanta/plugins/growth-engine/assets/examples/README.md \
         /Users/pmudh/Documents/GitHub/Atlanta/plugins/growth-engine/assets/examples/b2b-northfield/founder-brain.md \
         /Users/pmudh/Documents/GitHub/Atlanta/plugins/growth-engine/assets/examples/b2c-lumen/founder-brain.md
```

`wc` prints lines first and bytes second regardless of the order of its flags, so the table below is in that same order.

Three files exist. Values verified on 21 August 2026.

| Path | Lines | Bytes |
|---|---|---|
| `plugins/growth-engine/assets/examples/README.md` | 24 | 1264 |
| `plugins/growth-engine/assets/examples/b2b-northfield/founder-brain.md` | 80 | 4916 |
| `plugins/growth-engine/assets/examples/b2c-lumen/founder-brain.md` | 84 | 5447 |

That is the whole example set.
There is no example `content-30.md`, no `content-30.csv`, no sequence, no DM openers, no hook bank, no ops copy, no 90-day plan, no ledger, no ops log and no playbook insert.

The examples README is honest about it.
Line 5 of that file reads that each folder currently holds the Founder Brain only, and that the rest arrives once the plugin has been run end to end as each founder.
That run has never happened.
`/Users/pmudh/Downloads/Atlanta/launchhouse-atlanta/planning/PRD-GAPS.md` records this twice as a HIGH gap, once in its promise-coverage section and once in its outside-the-prd section, and records it a third time in its risk-and-assumption section as a BLOCKER reading that no task anywhere runs a fictional founder through the whole arc.

**The doubt to name first.** Someone will ask whether the examples are worth the days they cost when the four systems are not finished.
The answer is that the examples are the only end-to-end test the project has.
The four systems are markdown instructions plus a POSIX shell CLI, and there is no unit test that can tell you a skill produces a good post.
Generating the examples is how you find out that content-engine ignores the voice section, that the CSV was written before the edit pass, or that the ops copy has no custom value keys.
Building the examples is not documentation work that follows the build. It is the build's acceptance test, and it happens to leave three teaching artefacts behind.

### A.2 The three routes, and the folder names

Three example folders, one per route, matching the three routes locked in section 00 of this plan.

| Route | Folder | Founder | Business | Status |
|---|---|---|---|---|
| `b2b` | `b2b-northfield` | Sam Okoye | Northfield Ops, fractional operations for construction SMEs | Brain exists, everything else missing |
| `b2c-ecom` | `b2c-ecom-lumen` | Priya Raman | Lumen Skin, a three-product sensitive-skin range sold direct | Brain exists under the old folder name `b2c-lumen`, everything else missing |
| `b2c-service` | `b2c-service-brighthound` | Cara Whitfield | Bright Hound, dog behaviour and training in Bristol | Does not exist at all |

**Rename `b2c-lumen` to `b2c-ecom-lumen`.**
Today the folder name encodes the track but not the model, and the model is what selects the GHL snapshot and forks half the content engine.
Three folders named `b2b-`, `b2c-ecom-` and `b2c-service-` mean a founder can tell at a glance which one is theirs, and a mentor marking a b2c-service submission does not open the skincare example by mistake.

The rename touches three references. Find them with:

```sh
grep -rn 'b2c-lumen' /Users/pmudh/Documents/GitHub/Atlanta --exclude-dir=.git
grep -rn 'b2c-lumen' /Users/pmudh/Downloads/Atlanta/launchhouse-atlanta --exclude-dir=.git
```

Run on 21 August 2026 those two greps returned five distinct places, and the fix list is three of them.
Inside the repository: `plugins/growth-engine/assets/examples/README.md` line 10, and `planning/PRD-growth-engine-v1.md` line 111.
In the private folder: `/Users/pmudh/Downloads/Atlanta/launchhouse-atlanta/scripts/new-run.sh` line 26 and line 113.
Those three files are the fix list.
The other hits are the sibling sections of this delivery plan, at `/Users/pmudh/Documents/GitHub/Atlanta/planning/delivery/01-state.md`, `02-build-steps.md`, `03-review-process.md` and this file, and they are prose describing the current state rather than references that break on rename.
Update them for accuracy when the rename lands, but nothing fails if you do not.
`README.md` at the repository root links to the examples directory but not to the individual folder, so it is unaffected.

**Correct the PRD while you are there.**
`/Users/pmudh/Documents/GitHub/Atlanta/planning/PRD-growth-engine-v1.md` task `FB-02` at line 331 says to generate `plugins/growth-engine/assets/examples/b2c-ecom-<name>/founder-brain.md` as the third example.
That is wrong. Lumen is already the ecommerce example.
The example that does not exist is b2c-service.
Whoever executes `FB-02` should read it as b2c-service, and this section supersedes it.

### A.3 The new example: Cara Whitfield, Bright Hound

This founder is invented for this project.
She is not based on a real Oneday founder, a real client, or a real business.
Every fact below is fiction, chosen to exercise the parts of the product that Sam and Priya do not reach.

**Why she exists, in product terms.**
Sam is B2B, so he exercises Apollo, the sequence, the first lines and the paused enrolment.
Priya is B2C ecommerce, so she exercises the bundle economics, the review request workflow and product-led content.
Neither of them books appointments, so neither of them exercises the `b2c-service-core` snapshot, the comment-to-DM capture that ends in a booking, or the DM qualify-and-book workflow.
Cara does. She is the only example that makes the service branch visible.

**The brief the generation run works from.**

- Founder: Cara Whitfield.
- Business: Bright Hound.
- Route: `b2c`, model `service`.
- Location: Bristol, working across Bristol and Bath.
- Stage: roughly 2,600 GBP a month, fourteen months in, still doing two shifts a week at a veterinary practice to cover the gap.
- Offer: a six-week group course for lead-reactive dogs at 240 GBP, one to one home visits at 65 GBP, and a puppy foundation course at 180 GBP.
- Problem in customer language: "I have stopped walking him in daylight because I cannot face another lunge at somebody's spaniel."
- Why Cara: six years as a veterinary nurse before she qualified as a behaviourist, and she owns a reactive rescue lurcher, so she is describing her own Tuesday rather than a case study.
- Audience: dog owners aged 30 to 55 within about forty minutes of Bristol, whose dog barks or lunges on lead, who are embarrassed rather than uninterested, and who have already tried one trainer who shouted at them.
- Proof: about 60 owners through the reactive course, 22 Google reviews averaging 4.9, two video case studies with written consent, and a waiting list she keeps in her phone notes.
- Goal, next 90 days: fill both monthly cohorts to eight owners and reach 5,000 GBP a month so she can drop the veterinary shifts.
- Channels: Instagram 3,400 followers posting twice a week without a plan, three local Facebook dog groups where she answers questions, a Google Business Profile that produces most enquiries, no email list at all, and enquiries arriving as Instagram DMs and Google messages that she answers at 10pm.
- Destinations: brighthound.example website with a courses page and no booking link, so every enquiry becomes a conversation about dates.
- Voice: practical and kind, refuses to shame owners, short sentences, explains dog behaviour in terms of fear rather than dominance, uses "your dog is not naughty, he is frightened" and "we are not fixing him this week, we are making Tuesday easier".
- Flags: no email list, booking is entirely manual, delivery capacity is capped by her own diary so the 90-day plan must respect capacity rather than pushing volume, behaviour outcomes must never be promised, and there is no paid budget.

**The capacity flag matters.**
Bright Hound is the only one of the three examples where selling more is not automatically good, because two cohorts of eight is a hard ceiling set by one person's calendar.
A 90-day plan that projects past that ceiling is wrong, and the example is the place that shows the plan noticing.

**The claims flag matters too.**
Animal behaviour work has the same shape of risk as Priya's skin conditions.
The example must show the content engine writing from observation and method rather than promising that a dog will stop reacting.
`/Users/pmudh/Downloads/Atlanta/launchhouse-atlanta/planning/FUNCTIONAL-REVIEW.md` already carries this as a finding against the Lumen example, at low severity, at line 191, and Bright Hound doubles the exposure.

**Names must be cleared before they are committed.**
See A.7, under the heading "Clearance of invented names", which is task `EX-05`.
This applies to Bright Hound and retrospectively to the two existing examples.

### A.4 What each finished example folder contains

Three tables follow, one per route.
Sizes are the expected order of magnitude for a finished file, not a target to hit.
A file that comes out at a third of the stated size is evidence that a skill is producing thin output, which is exactly the signal the example run exists to produce.

Every file in every table is generated by running the plugin, with three exceptions marked "harness", which are written by the import step described in A.5.

#### A.4.1 Common to all three routes

| File | Produced by | Approx size | What good looks like |
|---|---|---|---|
| `founder-brain.md` | `founder-brain` skill | 5 to 7 KB, 85 to 110 lines | Every section filled including the Baselines block and the Model field. Voice section carries four to six verbatim phrases in the founder's own words. Flags name real weaknesses, not reassurances. The existing two files are the standard for depth and are still the best writing in the repository |
| `content-30.md` | `content-engine` | 16 to 24 KB | Thirty numbered pieces grouped under three to five pillars. Each piece has a title, the pillar, the format, the hook and the body. No piece repeats a verbatim phrase from the Brain more than once across the whole thirty. Reads as the founder, not as a category. At least four pieces are uncomfortable enough that a generic tool would not have written them |
| `content-30.csv` | `content-engine` | 6 to 10 KB, 31 lines | Header row byte-identical to the header fixture at `plugins/growth-engine/assets/ghl/social-planner-template.csv`. Thirty data rows whose first 40 characters match the corresponding piece in `content-30.md` after the edit pass, not before it. Correct quoting for embedded commas and newlines |
| `rss-feeds.md` | `content-engine` | 1.5 to 3 KB | The curated topic sources from the Brain turned into feeds with a one-line reason each. Explicitly marked topics only, never voice, with the competitor entries carrying that warning inline |
| `ops-workflow.md` | `ghl-workflows` | 8 to 14 KB | The chosen snapshot named in one line with the reason. Every message written out in full, each one carrying its namespaced custom value key in the `lh_*` form. Timing, business hours and timezone stated for every wait. A test-contact run described. No message contains a placeholder |
| `90-day-plan.md` | `growth-plan` | 6 to 9 KB | One primary metric with a real starting number taken from the Brain's Baselines block. Days 1 to 30, 31 to 60 and 61 to 90 with weekly actions. A kill criterion with a number and a date. A standing monthly refill action dated inside the Days 1 to 30 block. Respects stated capacity |
| `ledger.md` | `ge ledger` | 2 to 4 KB | Thirty content rows plus the route's outreach or DM rows. Statuses reflect the run that actually happened, so `approved` where nothing was published and `scheduled` with a post id where it was. Header line names `ge ledger` as the only writer |
| `ops-log.md` | `ge log` | 1 to 3 KB | Twelve to twenty five entries across the run, day headers deduplicated, types drawn from `decision`, `result`, `blocker` and `note`. Reads like a memory of the run, including at least one blocker that was hit and resolved |
| `.state/index.md` | `ge index` | 1 to 2 KB | The derived file and gate table, matching what is actually on disk in the folder |
| `README.md` | harness, hand-written once per folder | 1 to 2 KB | Who this founder is, which route, which files to read first and in what order, and one line on what a founder should notice. Not an example of output, so it may be hand-written |
| `MANIFEST.md` | harness, written by `import-example.sh` | 1 to 2 KB | The provenance record described in A.6. Plugin version, UTC timestamp, the exact command sequence, and the git blob hash of every source file that contributed |
| `inputs/answers.md` | harness, hand-written once per folder | 4 to 7 KB | The fixed script of answers this founder gives to every intake question, so the run is a replay rather than an improvisation. See A.5 step 2 |

**The CSV header fixture does not exist yet, and it blocks the `content-30.csv` acceptance above.**
Verified on 21 August 2026: `find /Users/pmudh/Documents/GitHub/Atlanta -name 'social-planner*'` returns nothing, and `/Users/pmudh/Documents/GitHub/Atlanta/plugins/growth-engine/assets/ghl/` contains a single `README.md`.
The fixture is produced by PRD spike task `S-03` at line 216 of `/Users/pmudh/Documents/GitHub/Atlanta/planning/PRD-growth-engine-v1.md`, which says to download the in-app GoHighLevel Social Planner CSV template and commit it verbatim to that path.
Until `S-03` lands there is nothing to compare a generated CSV against, so `EX-07` to `EX-09` cannot assert the header row.
Treat `S-03` as a hard prerequisite of the three generation runs and say so in the run log if it is still missing when a run starts.

`playbook-insert.md` and `playbook-insert.pdf` are **not** in this list, because `skills/playbook-export` is DEFERRED in the locked scope.
See A.9 for what to do if that decision is reversed.

#### A.4.2 Additional files, `b2b-northfield` only

The authoritative naming for outbound engine outputs belongs to the outbound engine section of this delivery plan.
The list below is this section's working assumption.
If the outbound section names these files differently, the outbound section wins and `MANIFEST.md` plus the example README are updated to match.

| File | Produced by | Approx size | What good looks like |
|---|---|---|---|
| `icp.md` | outbound engine, B2B branch | 2 to 3 KB | The ICP written as Apollo search parameters, not as prose. Firmographics, geography, headcount, titles, and at least two trigger-event proxies, because Sam's real triggers (a contract larger than usual, a lost office manager) are not filter fields and something must stand in for them. `/Users/pmudh/Downloads/Atlanta/launchhouse-atlanta/planning/FUNCTIONAL-REVIEW.md` line 481 records the dropped-trigger problem as a verified MEDIUM finding, quoting Sam's three real triggers from line 26 of his Brain |
| `prospects-35.csv` | outbound engine, B2B branch | 5 to 8 KB, 36 lines | The 35 built from the live search, before the cut. Company, domain, contact, title, and the reason each one matched |
| `prospects-25.csv` | outbound engine, B2B branch | 4 to 7 KB, 26 lines | The 25 that survived the cut, enriched, each row carrying an `email_status` value. Ten rows fewer than the file above, and the ten removals visible in `ops-log.md` with a reason |
| `outreach-sequence.md` | outbound engine, B2B branch | 5 to 8 KB | The full sequence. Every touch has an opt-out line. The signature carries the business name and a postal address. The `{{first_line}}` merge token appears in touch one and nowhere else. States plainly that enrolment is PAUSED and that activation is the founder's own act |
| `outreach-firstlines.csv` | outbound engine, B2B branch | 3 to 5 KB, 26 lines | One first line per prospect, each referencing something specific and checkable about that company. No line that would read the same against any of the other 24 |
| `manual-route.md` | outbound engine, B2B branch | 2 to 4 KB | The Microsoft 365 path, written as a first-class route rather than a fallback. Twenty five messages, a suggested five a day, the same opt-out rule, and how to record sends in the ledger by hand |

Generate `manual-route.md` in the Northfield example even though Sam's Brain says his domain is on Google Workspace.
Roughly a third of B2B founders will be on Microsoft 365, and if the manual route never appears in any example, it reads as the consolation prize the locked scope says it is not.
The example README states in one line that both routes are shown deliberately.

#### A.4.3 Additional files, both B2C routes

| File | Produced by | Approx size | What good looks like |
|---|---|---|---|
| `dm-openers.md` | audience engine, B2C branch | 5 to 8 KB | Twenty five openers, each tied to a named target account or a described type of account, with the reason it is a fit. Every one sendable by hand in under thirty seconds. A block at the top stating that these are sent by hand, one at a time, and why nothing here is automated |
| `hook-bank.md` | audience engine, B2C branch | 3 to 5 KB | Thirty hooks, grouped, each one usable as the first line of a video or the first line of a caption. No hook that promises an outcome |
| `inbound-scripts.md` | audience engine, B2C branch | 3 to 5 KB | The replies the founder sends when somebody responds. Written for the founder to send from GHL, not for Claude to send. Includes the qualify questions and the point at which a booking link goes out |
| `offer-tests.md` | audience engine, B2C branch | 2 to 3 KB | Two or three offer variants with what each one tests and how the founder will know which won, expressed as a number and a date |

#### A.4.4 Route-specific emphasis inside the shared files

These are not extra files. They are what makes the three folders visibly different rather than three variations of the same output.

| Route | `ops-workflow.md` shows | `content-30.md` skews toward | `90-day-plan.md` primary metric |
|---|---|---|---|
| `b2b` | `b2b-core`: lead follow-up, discovery booking, proposal chase. Email-led, business hours, a booking link that does not exist yet and is the first thing the workflow fixes | Written pieces for LinkedIn. Operational detail from fifteen years on site. Two named cases used sparingly because the Brain flags proof as thin on volume | Retainers signed, starting from zero, against a stated goal of three |
| `b2c-ecom` | `b2c-ecom-core`: comment-to-DM capture, DM qualify and send to product, review request after delivery | Video scripts and carousels. Ingredient and condition explainers. The founder's own story, which the Brain flags as her strongest and least used proof | Monthly revenue, starting from roughly 4,000 GBP, against a stated goal of 8,000 |
| `b2c-service` | `b2c-service-core`: comment-to-DM capture, DM qualify and book, then the pre-appointment reminder chain | Video scripts and carousels. Walk-along footage, one behaviour idea per piece, local Bristol and Bath signals so the geography does the qualifying | Course places filled per month, starting from a stated current number, against a ceiling of sixteen |

The three snapshot names above must match exactly the three snapshots named in the back-end ops section: `b2b-core`, `b2c-service-core`, `b2c-ecom-core`.

### A.5 How the examples are generated

They are generated by running the plugin as that founder.
They are never hand-written, and never hand-corrected after generation.

**Why the rule is absolute.**
A hand-written example is a claim about what the tool produces, made by somebody who knows what the tool ought to produce.
Founders calibrate against it and then meet the real output, which is worse, and they conclude the tool is broken.
Mentors mark 130 gate submissions against a standard the tool cannot reach.
The moment you improve an example by editing it, you have converted your best diagnostic into your most convincing lie.
If an output is not good enough to commit, the fix goes in the skill, and then the example is regenerated.

**Where runs happen.**
Never inside `/Users/pmudh/Documents/GitHub/Atlanta`.
Founder-shaped output generated inside the repository gets committed by accident, and `growth-engine/` is git-ignored at the repository root only, which will not save you if you generate two levels down.
Runs happen under `/Users/pmudh/Downloads/Atlanta/launchhouse-atlanta/runs/`, which is outside the repository and never public.

**The harness that already exists.**
`/Users/pmudh/Downloads/Atlanta/launchhouse-atlanta/scripts/new-run.sh` already does most of step 1.
It creates a run folder, seeds that founder's Brain so intake is not repeated, and writes a `RUN-LOG.md` with the command order and a per-track list of what to watch for.
It is a bash script with `set -euo pipefail`, and that is correct and must not be "fixed" to POSIX sh: it runs on the operator's machine only, never on a founder path, so the POSIX floor does not apply to it.

Three things are missing from it and are the work of `EX-01`.

1. It knows two routes. It needs three, and the two B2C cases must differ by model, not just by track.
2. Its finishing instruction tells you to copy the contents of `growth-engine/` into the example folder with no scrubbing step. Once `ge init` exists, `growth-engine/.state/HOME` will contain the absolute path of the machine that generated it, and that instruction publishes it. See A.7.
3. It writes no manifest, so nothing records which version of which skills produced the folder, and staleness cannot be detected.

#### The procedure, step by step

Do these in order, once per route, three times.

**Step 0. Pin the version.** Note the value of `version` in `/Users/pmudh/Documents/GitHub/Atlanta/plugins/growth-engine/.claude-plugin/plugin.json` and the current commit:

```sh
sed -n 's/.*"version" *: *"\([^"]*\)".*/\1/p' /Users/pmudh/Documents/GitHub/Atlanta/plugins/growth-engine/.claude-plugin/plugin.json
git -C /Users/pmudh/Documents/GitHub/Atlanta rev-parse --short HEAD
```

Both go into the manifest at step 8.
If the working tree is dirty, stop and commit first.
An example generated from uncommitted skills cannot be reproduced.

**Step 1. Create the run folder.**

```sh
/Users/pmudh/Downloads/Atlanta/launchhouse-atlanta/scripts/new-run.sh b2b
/Users/pmudh/Downloads/Atlanta/launchhouse-atlanta/scripts/new-run.sh b2c-ecom
/Users/pmudh/Downloads/Atlanta/launchhouse-atlanta/scripts/new-run.sh b2c-service
```

Only the first of those three runs today.
As committed, `/Users/pmudh/Downloads/Atlanta/launchhouse-atlanta/scripts/new-run.sh` accepts `b2b` or `b2c` and nothing else, per its usage line at the top of the file, and its `b2c` case seeds Priya's Brain from `b2c-lumen`.
The two B2C route arguments above require `EX-01`, which is also what renames the seed path to `b2c-ecom-lumen`.
Each invocation prints the absolute path of the folder it made.

**Step 2. Load the answer script.**
`inputs/answers.md` is the fixed set of answers this founder gives.
For Sam and Priya it is reconstructed from their existing Brains and committed once.
For Cara it is written once from the brief in A.3.
It is hand-written and that is allowed, because it is the *input* to the tool, not an example of the tool's output.
Every question the intake asks has an answer in it, in the founder's voice, including the awkward ones.
When the skill asks something the answer script does not cover, that is a finding: either the skill has drifted or the answer script is stale. Record it in the run log and resolve it before continuing.

**Step 3. Open Claude in the run folder with the plugin installed at the pinned version.**
Not the development checkout.
Install from the marketplace exactly as a founder would, so that what you are testing is what they get:

```
/plugin marketplace add Philm-moxywolf/Atlanta
/plugin install growth-engine@launchhouse
```

If the marketplace has not been pushed yet, install the local checkout, and record in the manifest that the run used a local install.
A local install is acceptable for iteration, and unacceptable for the final pre-freeze regeneration.

**Step 4. Run the commands in order, answering from the answer script.**

```
/growth-engine:setup
/growth-engine:brain
/growth-engine:content
/growth-engine:engine2
/growth-engine:ops
/growth-engine:plan
/growth-engine:status
/growth-engine:gate
```

Use the namespaced form. A command typed without the `growth-engine:` prefix never resolves, and typing the short form in a rehearsal teaches you a habit that fails in front of 130 people.

Two things happen at the content step that are easy to skip and must not be.
First, do the edit pass. The example must contain content that has been edited for voice, not the first draft, because that is what a founder submits at gate 2.
Second, regenerate the CSV *after* the edit pass. Writing the CSV before the edit is the known BLOCKER recorded at line 213 of `/Users/pmudh/Downloads/Atlanta/launchhouse-atlanta/planning/FUNCTIONAL-REVIEW.md`, and if the example folder ships with a CSV that predates its own markdown, the example teaches the bug.

**Step 5. Decide the publishing depth before you run the publish step.**
There are two defensible choices and you must pick one per example and record it.

- *Approved only.* Stop at approved. `ledger.md` shows content rows at status `approved` with no post id. The example does not demonstrate the GHL read-back. Simplest, and nothing touches a live account.
- *Scheduled against a sandbox location.* Publish into a throwaway GHL location that exists for this purpose and nothing else. `ledger.md` shows `scheduled` with a real post id, which is what proves read-back verification actually happened.

The recommendation is scheduled for one example and approved for the other two, so that at least one folder shows the whole path without three live locations to keep clean.
Make it the b2b one, because B2B founders are the ones most likely to doubt that the publishing half applies to them.
Whichever you choose, the example README says which, in one line, so nobody reads a missing post id as a failure.

**Step 6. Record what broke.**
`RUN-LOG.md` in the run folder has a table for this.
Every skill fix invalidates everything generated before it.
When you change a skill mid-run, do not carry on: note the fix, finish or abandon the run, then start the run again from step 1 after committing the fix.
A folder that is half pre-fix and half post-fix is worse than no folder, because it is internally inconsistent and nobody can tell which half is current.

**Step 7. Scrub.** See A.7. This is a separate step because it is the step people skip.

**Step 8. Import.**

`import-example.sh` does not exist yet. It is new work under `EX-02`, and until `EX-02` lands the block below is a specification rather than a command you can run.
Once it exists, the call takes the absolute path of the run folder that step 1 printed, and the example slug, which is one of `b2b-northfield`, `b2c-ecom-lumen` or `b2c-service-brighthound`.
Written out in full, for the Bright Hound run made on 2 September 2026:

```sh
/Users/pmudh/Downloads/Atlanta/launchhouse-atlanta/scripts/import-example.sh \
  /Users/pmudh/Downloads/Atlanta/launchhouse-atlanta/runs/2026-09-02-b2c-service \
  b2c-service-brighthound
```

It:

1. refuses to run if the target example folder has uncommitted changes;
2. refuses to run if any file in the run folder matches the scrub patterns in A.7, and prints the offending file and line;
3. copies the founder-facing files into `/Users/pmudh/Documents/GitHub/Atlanta/plugins/growth-engine/assets/examples/<slug>/`;
4. writes `MANIFEST.md`;
5. runs `bash /Users/pmudh/Documents/GitHub/Atlanta/scripts/validate.sh` and exits non-zero if it fails.

Point 5 is not optional and it will bite. Everything under `plugins/` is founder-facing to `validate.sh`. Read `scripts/validate.sh` lines 26 and 27: the founder-file set is `README.md` plus every `*.md` under `docs/` and under `plugins/`. So a generated post containing an em dash, or any word from the banned marketing list at line 209, hard-fails CI on a file that Claude wrote.
The fix is never to edit the example. The fix is to put the dash rule and the banned-word list into the content engine's generation rules, and regenerate.
Note the asymmetry: `content-30.csv` is not a `.md` file, so it is not scanned. If the CSV is ever produced by a path other than the markdown, style violations can enter through it unseen. That is a second reason to derive the CSV from the edited markdown and to check that the rows match.

**Step 9. Commit.** One example, one commit:

```
EX-04: generate the b2c-service worked example end to end

All 15 files produced by a clean run at plugin 0.4.0, commit 1a2b3c4.
validate.sh green. Publishing depth: approved only.
```

### A.6 Staleness: how you know an example no longer reflects the product

The rule from `/Users/pmudh/Downloads/Atlanta/launchhouse-atlanta/CLAUDE.md` is that every skill fix invalidates whatever was generated before it, and that you regenerate rather than patch.
That rule is unenforceable by memory across three folders, roughly fifteen files each, the nine skills in the plugin today plus whatever the four systems add, and six weeks.
It needs a machine check.

**`MANIFEST.md`, written by the import step.** Shape:

```
# Manifest: b2c-service-brighthound

route:            b2c-service
plugin version:   0.4.0
repo commit:      1a2b3c4
generated (UTC):  2026-09-02T14:07Z
install:          marketplace
publish depth:    approved only
operator:         Philip

## Commands run, in order

/growth-engine:setup
/growth-engine:brain
/growth-engine:content
/growth-engine:engine2
/growth-engine:ops
/growth-engine:plan
/growth-engine:status
/growth-engine:gate

## Sources this folder was generated from

plugins/growth-engine/skills/founder-brain/SKILL.md    a3f91c2e8b7d4f60a1c95e2d8b0f7a34c6d1e9b2
plugins/growth-engine/skills/content-engine/SKILL.md   7b2e4d90c1a83f56b9d0e7c2a4f81b6d3e5c9a70
plugins/growth-engine/skills/audience-b2c/SKILL.md     ...
plugins/growth-engine/skills/ghl-workflows/SKILL.md    ...
plugins/growth-engine/skills/growth-plan/SKILL.md      ...
scripts/ge.sh                                          ...
```

The hashes are git blob hashes.
Obtain one like this, with the path relative to the repository root and `-C` naming the repository so the command works from any working directory:

```sh
git -C /Users/pmudh/Documents/GitHub/Atlanta hash-object plugins/growth-engine/skills/content-engine/SKILL.md
```
Use `git hash-object` rather than a checksum tool because git is present on every machine that can build this project, including Git Bash on Windows, whereas `sha256sum` is absent on macOS and `shasum` is absent on some Linux images.
No compatibility shim needed.

**`scripts/check-examples.sh`, `EX-03`.** Lives in the repository at `/Users/pmudh/Documents/GitHub/Atlanta/scripts/check-examples.sh`, POSIX sh, standard header, warn-only posture.
For each example folder it re-hashes every source listed in the manifest and compares.
Output:

```
b2b-northfield           FRESH
b2c-ecom-lumen           STALE  plugins/growth-engine/skills/content-engine/SKILL.md changed
b2c-service-brighthound  MISSING MANIFEST
```

Exit codes: 0 fresh, 1 stale, 2 manifest missing or malformed.

**Wire it into `scripts/validate.sh`, `EX-03`.**
Warn while the version is below 1.0.0, so that staleness during the build does not block every commit.
Error at 1.0.0 and above, so the 3 September freeze cannot ship a stale example.
This mirrors the version-threshold pattern the PRD already uses for the TODO gate.

**The dependency map, so you know what a change stales.**
This is the human-readable version of the manifest hashes, and it belongs in the examples README so that somebody editing a skill can see the blast radius before they edit.

| If you change | These example files are stale |
|---|---|
| `plugins/growth-engine/skills/founder-brain/SKILL.md` or the brain template | `founder-brain.md`, and therefore everything else, because everything reads the Brain |
| `plugins/growth-engine/skills/content-engine/SKILL.md` | `content-30.md`, `content-30.csv`, `rss-feeds.md`, the content rows of `ledger.md`, and `90-day-plan.md` if it cites content volume |
| the outbound engine skill, B2B branch | `icp.md`, `prospects-35.csv`, `prospects-25.csv`, `outreach-sequence.md`, `outreach-firstlines.csv`, `manual-route.md`, the outreach rows of `ledger.md` |
| the audience engine skill, B2C branch | `dm-openers.md`, `hook-bank.md`, `inbound-scripts.md`, `offer-tests.md` |
| `plugins/growth-engine/skills/ghl-workflows/SKILL.md` or any snapshot copy map | `ops-workflow.md` |
| `plugins/growth-engine/skills/growth-plan/SKILL.md` | `90-day-plan.md` |
| `scripts/ge.sh` ledger, log or index behaviour | `ledger.md`, `ops-log.md`, `.state/index.md` |
| the CSV header fixture `plugins/growth-engine/assets/ghl/social-planner-template.csv` | `content-30.csv` in all three folders |

**Regeneration cadence.**
Regenerate on any change in the table above.
Regenerate all three in full immediately before the mentor review deadline of 1 September 2026, and again immediately before the v1.0.0 freeze on 3 September 2026.
The second one is the one that will feel unnecessary and is not: between 1 and 3 September the mentors will have produced findings, the findings become skill fixes, and the fixes stale the folders the mentors just read.

**Partial regeneration is allowed and must be recorded.**
If only `growth-plan` changed, rerunning the whole arc for three founders is wasteful.
Rerun from the affected step forward in the same run folder, and have `import-example.sh` update only the affected files and the corresponding manifest hashes.
What is not allowed is updating a file without updating its hash, because that makes the manifest lie and the check useless.

### A.7 What must be fictional, and what must never appear

**Everything in these folders is fiction.**
Three invented founders, three invented businesses, invented customers, invented numbers, invented prospects.
No real Oneday founder appears in any form, including a disguised form.

**Never commit, under any circumstances.**

| Never in an example folder | Why | How it gets in |
|---|---|---|
| A real customer or client name | It identifies somebody who did not consent to appear in a public repository | Copied from a real proposal or a real conversation while writing the answer script |
| Real prospect data of any kind: names, companies, job titles, email addresses, phone numbers | These are real people's contact details, published to a public repository by a tool that promised their data stays on the founder's machine | Straight out of a live Apollo search during the B2B run. This is the single highest risk in Part A |
| Any real revenue, follower count, conversion rate or result from an actual founder | Rule 4. Also, it is somebody's private business data | Borrowed to make an example feel credible |
| A GoHighLevel Private Integration Token, an Apollo key, or any other secret | It is a live credential in a public repository | `.state/` or a receipt file copied wholesale |
| A GHL location id | It points at a real account and is a foothold | Publish read-back writes it into the ledger or the receipt |
| `growth-engine/.state/HOME` | It contains the absolute filesystem path of the machine that generated the example | Copying the whole `growth-engine/` folder, which is exactly what today's `RUN-LOG.md` finishing instruction tells you to do |
| Any absolute path from the operator's machine, anywhere in any file | Same reason, and it also confuses founders who see a path that is not theirs | Setup receipts, doctor output pasted into the ops log |
| A real telephone number | It rings somebody | Written into the ops workflow signature or the email signature |
| A real registered domain that the project does not own | The example points founders at a business that has nothing to do with this | Invented domains that turn out to exist |

**Handling the B2B prospect problem.**
The B2B example must show 35 built, 25 cut, and 25 enriched, and it must not contain 25 real people.
Do it in two passes.

*Pass one, the live pass.* Run the real Apollo search from the real ICP. This proves the pipeline works and captures the shape of the output. It stays in the run folder and is never imported. It gets deleted when the run folder is cleaned.

*Pass two, the committed pass.* Rerun the same code path against a fixture list of 35 invented UK construction firms, held at `/Users/pmudh/Downloads/Atlanta/launchhouse-atlanta/fixtures/prospects-northfield.csv`, with invented company names, invented contact names, and email addresses on domains reserved by RFC 2606 and RFC 6761 (`example.com`, `example.org`, or a `.invalid` suffix).
The committed files are then machine-produced from a fictional input, which is the only arrangement that satisfies both rules at once: the file is genuinely what the tool produces, and nobody real is in it.
State this in the example README in one sentence, because a founder who notices the `example.com` addresses should understand why rather than think the tool is broken.

The same fixture approach covers Cara's DM targets. Her 25 openers must not name 25 real Instagram accounts.

**Scrub patterns for `import-example.sh`.**
The import step refuses to proceed and prints file and line if any of these match. Grep patterns, extended regex:

```
/Users/                                  operator absolute paths
/home/|C:\\\\Users\\\\                   the same on the other two platforms
pit-[A-Za-z0-9]{8,}                      GHL private integration token shapes
[A-Za-z0-9]{20,}\.[A-Za-z0-9_-]{20,}     bearer-token shapes generally
locationId|location_id                   any location identifier
07[0-9]{9}                               UK mobile numbers outside the reserved range
```

The UK number check has a documented exception: numbers in Ofcom's reserved drama range, `07700 900000` to `07700 900999`, are permitted and are what the examples must use.
The existing Northfield Brain already uses `07700 900412`, which is inside that range and is correct.
Keep it, and use the same range for Bright Hound and Lumen.

Landline equivalents, if any example needs one, come from the reserved `01632 960000` to `01632 960999` range.

**Clearance of invented names, `EX-05`.**
Before the examples are committed to a public repository, check that no invented business name is a real trading company and no invented domain is registered.
This is thirty minutes of work and it removes a real risk of pointing 130 founders and a public repository at somebody's actual business.

Check every one of these:

- Northfield Ops, and `northfieldops.co.uk`
- Halewood Building Services, Trentham Mechanical, Castlefield Contracts (the three named best-fit accounts in Sam's Brain)
- Lumen Skin, and `lumenskin.co.uk`
- Bright Hound, and `brighthound.example`
- Every company name in `fixtures/prospects-northfield.csv`
- Every account name in Cara's and Priya's DM opener targets

Method: Companies House name search at `find-and-update.company-information.service.gov.uk`, plus a WHOIS lookup on each domain, plus a plain web search on the trading name.
If a name matches a real trading entity, change it. If a domain is registered to somebody else, move it to a reserved suffix.
Record the date the check was run in the examples README, because it is a point-in-time check and somebody may register the name next month.

Recommendation: move all three example domains to reserved suffixes (`northfieldops.example`, `lumenskin.example`, `brighthound.example`) rather than clearing three real `.co.uk` domains that could be registered by a third party at any point between now and the event.
Real-looking domains buy a small amount of realism and carry an open-ended risk.

### A.8 Where the examples live, and the install-size question

`plugins/growth-engine/assets/examples/` sits inside the plugin, so every founder downloads all three folders at install, roughly 250 to 350 KB for the finished set.

Keep them there. Two reasons.

First, the room. The event is on 25 to 27 September 2026 with 130 people, and event venue networks fail. An example a founder can open with no network is worth more than one behind a link.
Second, Claude can read them. A skill that wants to show a founder what good looks like can point at a path inside the plugin.

The cost is that `validate.sh` scans them for house style, which A.5 step 8 already covers, and that they must be regenerated on every skill change, which A.6 already covers.

### A.9 The two skills that are not among the four systems

**`skills/growth-plan` is IN**, per the locked scope.
Therefore `90-day-plan.md` appears in all three example folders, and the file table in A.4.1 includes it.
It is the Sunday deliverable, it reads the Brain, and it is cheap.
Two things it needs from this section: a real starting number in the Baselines block of the Brain, which is where `/Users/pmudh/Downloads/Atlanta/launchhouse-atlanta/planning/PRD-GAPS.md` records a HIGH gap at line 64 of that file, and a dated standing monthly refill action inside its Days 1 to 30 block, which is where the refill gap is closed.

**`skills/playbook-export` is DEFERRED**, per the locked scope, and this section chooses nothing on its behalf.

If it stays deferred:

- `playbook-insert.md` and `playbook-insert.pdf` are absent from all three example folders.
- The examples README says in one line that the playbook insert is not part of version 1.0.
- `README.md` at the repository root drops the `playbook-export` row from the skill table and the `/growth-engine:playbook` row from the command table.
- `docs/USING-IT.md` does not mention it.
- `plugins/growth-engine/commands/playbook.md` and `plugins/growth-engine/skills/playbook-export/SKILL.md` are either deleted or left in place and undocumented. Deleting is better: an undocumented command that a founder discovers and runs produces output nobody supports.
- `CHANGELOG.md` records the removal explicitly under 1.0.0, so that anybody who saw it in 0.1.0 can find out where it went.

If the decision is reversed and it comes back in:

- Add `playbook-insert.md` at 8 to 12 KB to A.4.1, generated last, after `90-day-plan.md` exists.
- Note in the example manifest that the insert was generated twice: once pre-event covering the early sections, and once on the Sunday evening after the plan exists. `/Users/pmudh/Downloads/Atlanta/launchhouse-atlanta/planning/FUNCTIONAL-REVIEW.md` line 599 records the contradiction where the insert is generated before the plan it is supposed to summarise, and the example is where that gets fixed or exposed.
- Add the PDF only if a PDF is genuinely produced. If the skill produces markdown and a founder prints it, say that, and do not put a `.pdf` in the example folder that a script made rather than the skill.

**Decide this by 26 August 2026.** After that date the README, the command table, the docs, the printed playbook brief and the mentor briefs all encode the answer, and reversing it means correcting six documents rather than one line.

### A.10 Part A task list

| Task | What it does | Effort | Depends on |
|---|---|---|---|
| `EX-01` | Extend `new-run.sh` to three routes, add the model dimension to the two B2C cases, replace the unscrubbed finishing instruction in `RUN-LOG.md` with a pointer to `import-example.sh` | 0.25d | none |
| `EX-02` | Write `import-example.sh`: scrub gate, copy, write `MANIFEST.md`, run `validate.sh` | 0.5d | `EX-01` |
| `EX-03` | Write `scripts/check-examples.sh` and wire it into `validate.sh` as warn below 1.0.0 and error at 1.0.0 | 0.5d | `EX-02` |
| `EX-04` | Write the three `inputs/answers.md` answer scripts, and the Bright Hound brief from A.3 | 0.5d | none |
| `EX-05` | Name and domain clearance for every invented entity across all three examples, plus the prospect fixture | 0.25d | `EX-04` |
| `EX-06` | Rename `b2c-lumen` to `b2c-ecom-lumen` and fix the three references | 0.1d | none |
| `EX-07` | Generate `b2b-northfield` end to end and import it | 0.75d | all four systems built, `EX-01` to `EX-06` |
| `EX-08` | Generate `b2c-ecom-lumen` end to end and import it | 0.75d | all four systems built, `EX-01` to `EX-06` |
| `EX-09` | Generate `b2c-service-brighthound` end to end and import it | 0.75d | all four systems built, `EX-01` to `EX-06` |
| `EX-10` | Rewrite `plugins/growth-engine/assets/examples/README.md`: drop the "not finished yet" paragraph, add the three-route table, the dependency map from A.6, the fiction rule, the clearance date, and the publishing-depth note | 0.25d | `EX-07` to `EX-09` |
| `EX-11` | Full regeneration sweep before the mentor deadline (1 September) and again before the freeze (3 September) | 0.5d | `EX-10` |

Total 5.1 days, of which 2.25 days is the three generation runs and cannot start until all four systems work.
`EX-01` to `EX-06` are 2.1 days and can start immediately, which matters, because if the harness is not ready when the systems are, the runs slip into the mentor window.

**Run one of the three on Windows Home.**
The runtime floor exists because Windows Home has no Hyper-V, so no Cowork, so the Code tab, so Git Bash.
If all three examples are generated on macOS, nothing has proven the floor holds.
Generate `b2c-service-brighthound` on a clean Windows Home machine and record the surface in its manifest.
This is the cheapest possible cross-platform test and it costs nothing extra, because the run has to happen anyway.

---

## Part B. The documentation set

### B.1 The map

| Document | Path (relative to `/Users/pmudh/Documents/GitHub/Atlanta`) | Audience | Exists today | Task |
|---|---|---|---|---|
| Repository landing page | `README.md` | Anyone who opens the repository. Founders before install. Juan and the TAs | Yes, 4,203 bytes, verified 21 August 2026. Describes a nine-skill 0.1.0 product with two tracks and no mention of the four systems, Windows, connections, or paid plans | `D-01` |
| Onboarding | `docs/PRE-WORK.md` | The 130 founders, sent 4 September 2026 | Yes, 4,897 bytes, verified 21 August 2026. Well written. Structured around two tracks rather than four surfaces. No Windows path. Costs table names free tiers | `D-02` |
| Distribution folder readme | `dist/Launchhouse/READ-ME-FIRST.md` | The fallback `.plugin` path only | Yes, generated by `scripts/build-folder.sh` | `D-03` |
| What connects and what is stored | `docs/CONNECTIONS.md` | Founders, and anybody asking where their data goes | **No** | `D-05` |
| The day-to-day manual | `docs/USING-IT.md` | Founders, during the three sessions and for the ninety days after | **No** | `D-06` |
| Failure catalogue | `docs/TROUBLESHOOTING.md` | Founders, TAs, mentors, the clinic on 23 September | **No** | `D-07` |
| Version history | `CHANGELOG.md` | Founders taking an update, and contributors | **No** | `D-08` |
| Contributor working agreements | `CLAUDE.md` (repository root) | Anybody with commit access, and Claude sessions working in the repository | **No** at the repository root. A different `CLAUDE.md` exists in the private folder and in `dist/` | `D-09` |
| Setup screenshots | `docs/img/*.png` | Founders following the connect walk | **No**. No image file exists anywhere in the repository | `D-10` |
| Snapshot copy maps, three files | `plugins/growth-engine/assets/ghl/snapshots/{b2b-core,b2c-service-core,b2c-ecom-core}.md` | The person building the snapshots, the clinic, and the ops skill | **No**. `plugins/growth-engine/assets/ghl/` contains only a README | `D-12` |
| GHL asset readme | `plugins/growth-engine/assets/ghl/README.md` | Internal, plus founders looking for share links | Yes, 6 TODOs, and it lists six snapshots where the locked scope has three | `D-11` |
| Gate forms readme | `plugins/growth-engine/assets/forms/README.md` | Internal, plus mentors | Yes, 4 TODOs, and its gate 3 row names pods, which appear nowhere else in the product | `D-11` |
| Examples readme | `plugins/growth-engine/assets/examples/README.md` | Founders and mentors | Yes, and correctly describes an unfinished state | `EX-10` |

Everything under `docs/` and everything under `plugins/` is scanned by `scripts/validate.sh` for em dashes, en dashes and the banned marketing word list.
Read `scripts/validate.sh` lines 26, 27, 203 and 209 to see the exact scope and the exact list before writing a word of any of these.
`CHANGELOG.md` and the root `CLAUDE.md` sit outside that scope today, and `D-04` should widen the scan to include them, because a contributor reading house-style rules written in violation of house style is not going to follow them.

### B.2 `README.md`, task `D-01`

**Exists.** Yes.
**What is wrong with it.** It is accurate for version 0.1.0 and wrong for the product being built.
It describes nine skills and ten commands where the finished product has more.
It frames the product as "two tracks" where the locked scope is three routes and two platforms.
It says nothing about Windows, nothing about what connects to what, nothing about the paid plans that are now required, and its "what finished looks like" section points at example folders that hold one file each.
The pre-release banner is correct and stays until 1.0.0.

**Audience.** Somebody who has just been given the repository link and has decided nothing yet.
They want to know what it is, whether it will work on their machine, what it will cost them, and what to type first.

**Outline.**

1. **Title and one-line description.** What it is, who it is for, and the event date, 25 to 27 September 2026.
2. **Pre-release banner.** Retained verbatim until `R-02` at 1.0.0, then removed in the same commit as the version bump.
3. **What it builds.** Four rows, one per system, each row saying what lands on disk at the end. Content engine: 30 pieces on voice, tracked, exportable, scheduled into GHL. Outbound engine: 25 messages, by the route your business actually uses. Back-end ops: three workflows configured with your own copy. The brain: your business in one file that everything else reads.
4. **Who this is for and who it is not for.** Name the doubt. This is for a founder who will actually send twenty five messages and post thirty times. It is not a way to avoid doing that.
5. **What it will never do.** Six lines, flat, no hedging. No automated Instagram or Facebook DMs. No cold email through GoHighLevel. Sequences enrol paused, and only you turn them on. Never invents a customer, a number or a result. Never posts without you approving the batch. Never reads your inbox or writes a reply on your behalf. This block earns more trust than any feature list and it costs six lines.
6. **Before you install.** Prerequisites per surface, in a table: macOS with Cowork, macOS with the Code tab, Windows Pro or Enterprise with Cowork, Windows Home with the Code tab. The Windows Home cell says plainly that there is no terminal to learn, that Git for Windows installs in two clicks, and that the Code tab needs it. Windows is a first-class row in this table and not a footnote.
7. **What you will pay for.** Table with three rows: Claude paid plan, GoHighLevel paid with API access, Apollo paid seat for B2B founders. Each row states when it is needed and why. No free tiers are named, because naming a free tier that will not carry the work is worse than naming a price.
8. **Install.** Both surfaces. The two-store truth, stated once and plainly: you install where you will work, and if you use both Cowork and the Code tab you install twice. Exact commands: `/plugin marketplace add Philm-moxywolf/Atlanta` then `/plugin install growth-engine@launchhouse`.
9. **Check it worked.** `/growth-engine:setup`. What a pass looks like. What to do if the command does not appear, which is `/reload-plugins` or a restart.
10. **The command table.** One row per command in `plugins/growth-engine/commands/`, with three columns: the namespaced command, the plain-language phrase, and what it does. Always namespaced, because a command typed without the `growth-engine:` prefix never resolves, and the README is where founders learn the habit. The plain-language column is load-bearing for Cowork users who never type a slash.
11. **The three routes.** You choose once, in the Brain. Everything after that adapts. If you genuinely do both, pick the one that makes more money today.
12. **Where your work lives.** `./growth-engine/` in whatever folder you opened. Pick one folder and always open it. Updating or reinstalling never touches it.
13. **What finished looks like.** Link to the three example folders, one line each naming the founder and the route.
14. **The rest of the documents.** Four links with one line each: `docs/PRE-WORK.md` to get set up, `docs/USING-IT.md` for the day to day, `docs/CONNECTIONS.md` for what connects and what is stored, `docs/TROUBLESHOOTING.md` when something breaks.
15. **Support.** Slack channel, drop-in clinics, and the setup clinic date of 23 September 2026.
16. **Licence and version.**

**Acceptance.** `validate.sh` green. The command table row count equals the file count in `plugins/growth-engine/commands/`, checked by the new CI rule in B.12. Every plain-language phrase in the table appears in the owning skill's description triggers. No free plan is named anywhere.

### B.3 `docs/PRE-WORK.md`, task `D-02`

**Exists.** Yes, and it is the best-written document in the repository. Do not rewrite the voice, restructure the spine.

**What is wrong with it.**
It is organised around the two tracks, and the thing that actually determines what a founder types is their surface, not their track.
It has no Windows path at all, so a Windows Home founder reaches step 3 and finds no route that matches their machine.
Its costs table names Apollo as free and describes GoHighLevel Starter at 97 USD per month, and the locked scope now requires paid tiers of both.
It says the plugin installs per account, which is true, but does not state that it also installs per surface, so a founder who installs in Cowork and then opens the Code tab finds nothing.
It refers to a setup clinic on 23 September for GHL, while the connect walk that needs screenshots has none.

**Audience.** All 130 founders, most of them non-technical, reading it once, on 4 September 2026, on their own, with nobody to ask until Slack answers.

**Outline.**

1. **What this is and when it is due.** Everything here before Session 1 in the week of 7 September. Two items are time-critical and cannot wait.
2. **Which of these are you.** Four surfaces, described in plain terms so a founder can self-identify without knowing what a hypervisor is. macOS with Cowork. macOS with the Code tab. Windows Pro or Enterprise with Cowork. Windows Home with the Code tab. One sentence saying that Windows Home does not run Cowork and that the Code tab is the route, and that this is normal rather than a downgrade.
3. **Your path, per surface.** Four numbered sequences. The Windows Home sequence is: install Git for Windows, install Claude desktop, sign in on the account you will bring to Atlanta, open the Code tab, install the plugin, run `/growth-engine:setup`. Each step has a screenshot slot that is filled, not empty, and each step has an "if this fails" line.
4. **Get Claude.** Paid plan required. State it as a real cost.
5. **One account, chosen now.** Work or personal, pick one, stay on it. The plugin installs per account and per surface.
6. **Install the toolkit.** Both routes, exact commands, the same strings as the README.
7. **Check it worked.** `/growth-engine:setup`, what a pass looks like, and the instruction to stop there. We build the rest together in Session 1.
8. **Time-critical, B2B founders: your sending domain.** Kept close to word-for-word from today's file, which is good. SPF, DKIM, DMARC. Ten to twenty real messages a day. Three weeks minimum for a fresh domain, and the fallback of an older domain with real history if buying after roughly 8 September.
9. **Time-critical, B2C founders: your Instagram.** Business or Creator account, linked to a Facebook Page. Two minutes. Nothing publishes or captures inbound without it.
10. **Accounts to create, and what not to do alone.** GoHighLevel paid with API access, and one location. Then, in bold, that we create the private integration token together at Session 2 and they should not create it alone. This one line saves an hour of Session 2. Apollo paid seat for B2B founders, created on the work email. A note that model training is off, stated in the same place they are asked to connect things.
11. **Costs, so nothing surprises you.** Updated table with real prices and no free tiers. Each row states when the money is needed.
12. **Where the work lives.** One folder, always the same one. This is the single most common real failure and it deserves the space it already gets.
13. **Updates.** How to take an update, per surface. That updates are not automatic. That we announce in Slack when one is worth taking.
14. **Stuck.** Slack, and the escape hatch repeated at the end of every section rather than only here.

**Acceptance.** A cold read-through by somebody who has not built it, timed, on each of the four surfaces. Every screenshot slot filled. Every step has an "if this fails" line. `/Users/pmudh/Downloads/Atlanta/launchhouse-atlanta/planning/PRD-GAPS.md` line 284 records that an empty screenshot slot satisfies the PRD's stated acceptance and helps nobody, so the acceptance wording is "every screenshot slot is filled".

### B.4 `docs/CONNECTIONS.md`, task `D-05`

**Exists.** No. Nothing in the repository answers any question in this document.

**Why it exists.** A founder is about to paste a token into a tool and connect their CRM. They are entitled to a straight answer about what leaves their machine, when, and what they can do about it later. Nobody will read this document if they trust the product, and everybody will read it the moment they do not.

**Audience.** Founders, at the point of connecting. Also whoever answers the question in Slack, so they can send a link instead of writing it out.

**Outline.**

1. **The short version.** Four sentences at the top for the person who will not read the rest. Two services connect: GoHighLevel and Apollo. Your business files stay on your computer. What leaves is the specific thing you approve, at the moment you approve it. Nothing runs on a schedule.
2. **What connects.**
   - GoHighLevel, through the official GoHighLevel MCP endpoint, authenticated with a Private Integration Token you create in your own account.
   - Apollo, for B2B founders on Gmail or Google Workspace, through the Apollo MCP with its own sign-in.
   - Nothing else. There is no Oneday server. There is no account with us.
3. **What does not connect, and why.**
   - Instagram and Facebook are not connected by this toolkit. Publishing goes through GoHighLevel's Social Planner, which holds those connections in your own GoHighLevel account.
   - Your direct message inbox is not connected. Claude never reads it and never writes a reply. The messages live in GoHighLevel, and you read and reply there yourself. State this flatly and without apology, because it is a deliberate design choice and the reason is worth one sentence: automated cold direct messages get accounts restricted, and we are not putting your account at risk.
   - Your email inbox is not connected. On the B2B route Apollo sends from your own mailbox, which you authorise inside Apollo.
4. **The GoHighLevel token, and exactly what it can do.** The seven scope strings, listed exactly, each with one line saying what it allows and why it is needed:
   - `socialplanner/post.readonly` reads back a post after scheduling, so we can prove it landed.
   - `socialplanner/post.write` schedules a post.
   - `socialplanner/account.readonly` lists which channels you have connected.
   - `socialplanner/statistics.readonly` reads post performance.
   - `contacts.readonly` reads contacts.
   - `contacts.write` creates and updates contacts.
   - `locations.readonly` confirms which location the token belongs to.
   Then, explicitly: message and conversation scopes are not requested, and that is why nothing in this toolkit can read or send a direct message.
5. **Where the token is stored.** In the plugin's own configuration on your machine, entered through a masked prompt. Not in the repository. Not in any file inside `growth-engine/`. Never typed into a chat message, and never echoed back to you. If you have already pasted a token into a conversation, treat it as compromised and rotate it. See section 9.
6. **What is stored on your machine, and where.** A table of every file, its path relative to `./growth-engine/`, what it holds, and whether it ever leaves. Everything under `growth-engine/` is local. `.state/` holds machine state and snapshots, also local.
7. **What leaves your machine, and when.** A table with three columns: what, to where, triggered by what.
   - The text and scheduled time of a post, to GoHighLevel, when you approve that batch for publishing.
   - Contact rows, to GoHighLevel, when you create contacts.
   - Search criteria and the resulting contact rows, to Apollo, when you run the list build.
   - Sequence copy and the paused enrolment, to Apollo, when you build the sequence.
   - Nothing else. Nothing on a timer. Nothing without a step you took.
8. **What Claude reads.** Your files in the folder you opened, during the session you opened it. It reads them to write your content. It does not upload them.
9. **How to disconnect, and how to rotate.** Click paths, per service. GoHighLevel: Settings, Private Integrations, delete the integration. Apollo: revoke the connection. Then clear the value from the plugin configuration. Then verify with `/growth-engine:doctor`, which should now report not connected. Rotating is the same as disconnecting followed by connecting, and the order is create the new token first, verify, then delete the old, so you are never locked out mid-session.
10. **What happens to your work when you disconnect.** Nothing. It is on your computer. Disconnecting stops the toolkit reaching GoHighLevel, and changes nothing else.
11. **If you think a token has leaked.** Rotate first, then ask. The order matters.

**Acceptance.** The seven scope strings in this document are byte-identical to the seven in the connect skill, checked by CI. Every click path is verified against the live GoHighLevel and Apollo interfaces on the day the document is written, with the date recorded in the document, because these interfaces change.

### B.5 `docs/USING-IT.md`, task `D-06`

**Exists.** No. This is the document the client specifically asked for and the one with no precedent in the repository.

**Why it exists.** A founder leaves Atlanta on Sunday 27 September 2026 with a folder of work and ninety days of plan. Everything they do after that is unsupervised. This is the document they read on 14 October when they want to swap out a post and are afraid of breaking something.

**Audience.** A founder who has finished the three sessions. Competent, non-technical, working alone, mildly afraid of the tool.

**Tone.** Every section names the fear first. "You want to change a post and you are worried that editing the file will break the export." Then answers it.

**Outline. This is the fullest outline in this section, deliberately.**

**1. Before anything: the one folder rule.**
Your work is in `./growth-engine/` inside one folder on your computer.
Always open that folder.
How to check you are in the right one: run `/growth-engine:status`, which names the folder it found.
What "anchor mismatch" means when you see it, and the one command that fixes it.

**2. The map: what every file is, and who is allowed to write it.**
A table, and it is the most referenced thing in the document.
Columns: file, what it is, who writes it, may you hand-edit it, what happens if you do.

| File | Who writes it | Hand-edit? |
|---|---|---|
| `founder-brain.md` | you and Claude together | Yes, and see section 8 for what goes stale when you do |
| `content-30.md` | content engine, then you | **Yes. This is the file you are meant to edit** |
| `content-30.csv` | content engine, derived from the markdown | No. It is regenerated, and your edit is overwritten |
| `dm-openers.md`, `hook-bank.md`, `inbound-scripts.md`, `offer-tests.md` | audience engine, then you | Yes |
| `outreach-sequence.md`, `outreach-firstlines.csv` | outbound engine, then you | Yes for the sequence. The first-lines CSV is regenerated, so edit the sequence and rerun |
| `ops-workflow.md` | ops engine, then you | Yes. This is copy you paste into GoHighLevel |
| `90-day-plan.md` | plan skill, then you | Yes |
| `ledger.md` | `ge ledger` only | **No** |
| `ops-log.md` | `ge log` only, append-only | **No** |
| `.state/index.md` | `ge index` only, derived | **No**, and it is rebuildable, so a mistake here is recoverable |
| `.state/HOME` | `ge init` only | **No** |
| `.state/snapshots/` | `ge snapshot` only | **No** |

**3. The order things happen in.**
Brain, then content, then your engine, then ops, then plan.
Why the order matters: each one reads the ones before it.
What happens if you run them out of order, which is that the skill tells you what is missing and stops rather than guessing.

**4. Running each engine.**
Five short subsections, one per system plus the plan, each following the same shape: what you type, what it asks you, roughly how long it takes, what lands on disk, what to check before you move on.

- 4.1 The brain. `/growth-engine:brain`. Twenty to forty minutes. It asks about your offer, audience, proof, voice and numbers. Check: the voice section contains phrases you actually say.
- 4.2 The content engine. `/growth-engine:content`. Pillars first, then thirty pieces in batches of ten with a check between batches. Then the edit pass, which is the part that matters and the part people skip. Then the CSV. Check: read five at random and ask whether you would post them.
- 4.3 Your outbound or audience engine. `/growth-engine:engine2`. Routes automatically from your Brain. B2B: the list, the cut, the sequence, and enrolment that stays paused until you turn it on. B2C: twenty five openers you send by hand, the hook bank, the offer tests.
- 4.4 Back-end ops. `/growth-engine:ops`. Picks your snapshot from your route and model, and writes every message. What you do with it in GoHighLevel.
- 4.5 The plan. `/growth-engine:plan`. Reads everything above. Produces the ninety days with a kill criterion and a number.

**5. Replacing and regenerating content. The longest section, and the one the client asked for.**

- **5.1 You want to change a few words.** Open `content-30.md` and edit it. That is the whole answer. Then say "regenerate my CSV" so the export matches. Nothing else needs doing.
- **5.2 You want one piece replaced entirely.** Say "replace piece 14", or `/growth-engine:content` and tell it which. It rewrites that one piece against your Brain and your pillars, leaves the other twenty nine alone, and updates the ledger row for 14 only. Takes about a minute.
- **5.3 You want a whole pillar replaced.** Say "replace the pieces in pillar 2". Same behaviour, a batch at a time, with a check before it writes.
- **5.4 You want all thirty regenerated.** Say "regenerate all my content". It snapshots the current file first, so the old thirty are recoverable. It takes about twenty minutes. Say that plainly, because most people assume regenerating means starting over from the intake, and it does not: your Brain is unchanged and it is the only input.
- **5.5 What happens to the CSV when you edit the markdown.** The CSV is derived from the markdown. It does not update itself. Once the markdown changes, the CSV is stale, and `/growth-engine:status` and `/growth-engine:doctor` both say so, by comparing the row count and the opening of each row against the markdown. Do not import a stale CSV into GoHighLevel: you would be publishing the version you already decided against. The fix is one sentence: "regenerate my CSV". The publishing route reads your approved content directly rather than the CSV, so the CSV matters only if you are importing by hand.
- **5.6 What the ledger does through all of this.** Every piece has a row and a status. Draft, approved, scheduled, published, failed. Editing a piece that was already scheduled does not change what is scheduled in GoHighLevel: you have to reschedule it, and the tool will tell you which pieces are in that state. This is the trap and it deserves its own paragraph.
- **5.7 A piece you no longer want at all.** Mark it dropped rather than deleting the lines. The ledger keeps the row, the count stays honest, and the refill knows not to write that angle again.

**6. The monthly refill.**
What it is: thirty pieces is roughly a month, and the refill writes the next batch without repeating the angles you have already used.
When to run it: your ninety-day plan has it as a dated standing action in the first thirty days, and it is worth putting in your calendar the day you get home.
What you type: "refill my content".
What it reads first: your existing `content-30.md`, so it does not repeat itself, plus the running list of new proof at the bottom of that file.
Add to that running list as things happen: a result, a customer story, a question you were asked twice. That list is the entire difference between month two sounding like month one and month two sounding better.
What happens to the old batch: archived as `content-30-<month>.md`, and a fresh `content-30.md` is written.
How you will be reminded: at the start of a session, if your newest content is more than thirty days old, the toolkit says so in one line. It is a note when you happen to open it, not a scheduler, and nothing runs while you are away.

**7. Editing your voice after generation.**
The symptom: the posts are fine but they do not sound like you.
The cause, nine times out of ten: the voice section of your Brain is thin, and generic output is the evidence.
The fix is in the Brain, not in the posts. Add three or four things you actually say, word for word, including the ones that feel too plain to write down. Those are the ones that work.
Then regenerate rather than editing thirty pieces by hand.
What goes stale when the Brain changes, listed explicitly: content, your engine's copy, the ops copy and the plan. The toolkit names which files are now older than your Brain and offers to regenerate each one. It does not do it silently.

**8. Undoing something.**
Every skill takes a snapshot before it overwrites a file. If it cannot take a snapshot, it refuses to write, and that is deliberate.
To undo the last change: `/growth-engine:undo`, or say "undo that".
To see what can be undone: it lists the last ten snapshots per file with times.
To restore something older: name the file and the time.
What undo does not cover: anything already sent or scheduled outside your machine. A post scheduled in GoHighLevel is unscheduled in GoHighLevel. An email Apollo has sent is sent. Say this in the same breath as the undo instructions, because the moment somebody needs undo is the moment they most need to know its edge.

**9. Archiving.**
When a batch is done, archive rather than delete: it keeps your history and it feeds the refill.
Where archives go and how they are named.
What to keep forever: your Brain and your ops log. The Brain is the input to everything, and the log is the only record of what you decided and why.

**10. What not to hand-edit, and why.**
`ledger.md`, `ops-log.md` and everything under `.state/`.
The reason, in plain terms: one thing writes each of those files, and there is no merge. Your edit is either overwritten on the next write or it breaks the line format, and then the status view and the gate summary go wrong in ways that are hard to spot.
The ops log is append-only on purpose, because a log you can rewrite is not a record.
If you already edited one: run `/growth-engine:doctor`. It checks the formats, rebuilds the index if it can, and offers a snapshot restore if it cannot. Nothing here is unrecoverable, and it is easier not to.

**11. Where your work lives, moving it, backing it up.**
The absolute path, how to find it, that it is yours and not inside the plugin.
Moving the folder: move it, then run `/growth-engine:setup` so the anchor updates. The toolkit will otherwise notice the mismatch and stop, which is the correct behaviour rather than a bug.
Backing it up: it is plain text, so any backup works. Do not sync `.state/snapshots/` across two machines editing at once.
Sharing it with a mentor: send the specific file, not the folder, because the folder contains your prospect list.

**12. Updating the toolkit.**
How to update, per surface. What an update does not touch, which is your folder. How to see which version you have. What to do if an update makes things worse, which is to say what happened in Slack, and the fact that your work is unaffected either way.

**13. Disconnecting, and what survives.**
One paragraph and a link to `docs/CONNECTIONS.md`, so the answer exists in both places for somebody who came in through this door.

**Length.** 14 to 20 KB. It is a manual and it is fine for it to be long, as long as every section is findable from the table of contents.

**Acceptance.** Somebody who did not build it performs five tasks using only this document: replace one piece, regenerate the whole batch, run a refill, undo a change, and find where their work lives. Each without asking a question. `validate.sh` green.

### B.6 `docs/TROUBLESHOOTING.md`, task `D-07`

**Exists.** No.

**Should it be a document or should it live in the doctor?** Both, and they share a source.
The doctor is where a founder in trouble actually goes, and it can inspect the machine, which a document cannot.
The document is where a TA looks while helping somebody, where a mentor looks at a clinic, and where somebody whose plugin will not install at all looks, because at that moment the doctor is not available to them.
Write the entries once, in this document. The doctor's own text quotes the same recovery lines, and a CI check asserts that every `→ run:` line in the doctor appears in this document.

**Audience.** Founders when something has gone wrong, TAs during the sessions, and whoever staffs the clinic on 23 September 2026.

**Structure.** One table of contents by symptom in the founder's own words, then one entry per failure. Every entry has the same four parts: what you see, what it means, the exact fix, and how to confirm it worked. Every fix ends with a runnable line, matching the code standard that every error message ends with a recovery line.

**The entries, at minimum.**

*Install and commands*
1. The command does not exist, or nothing happens when I type it.
2. I typed the short form of a command and got nothing. (Commands are namespaced. The full form is `/growth-engine:brain`.)
3. I installed it in Cowork and it is not in the Code tab. (Per surface. Install again.)
4. I installed it on my other Claude account.
5. Windows: the Code tab says something about a shell. (Git for Windows.)
6. Windows Home: I cannot find Cowork. (There is none. Use the Code tab. This is expected.)

*Folders and state*
7. My work is not where I left it.
8. Anchor mismatch: it says my work is in one folder and I am in another.
9. I moved the folder.
10. It says the Brain is missing and I know it exists. (Parent folder and home directory are searched. Where it actually looked.)
11. `ge` is not on the path.

*Content*
12. The posts do not sound like me.
13. It gave me LinkedIn posts and I sell to consumers. (The track field. And the full track-switch procedure: correct the field, move the other route's files out of the folder rather than leaving them, then regenerate in order. Leaving them is how the wrong route's files end up in a gate submission.)
14. My CSV does not match my edited posts.
15. The import into GoHighLevel failed or produced the wrong number of rows.
16. I edited a piece that was already scheduled.

*Connections*
17. GoHighLevel says unauthorised, or a 401.
18. The token works but a step says permission denied. (A missing scope. The seven, and how to add one.)
19. My Instagram is not in the channel list.
20. The post said it scheduled but I cannot see it in GoHighLevel. (Read-back failed. The row is marked failed. What to do.)
21. Apollo will not connect, or I am on Microsoft 365. (Not a failure. The manual route, and where to find it.)

*Ops and workflows*
22. The workflow did not fire on my test contact.
23. A message went out at three in the morning. (Timezone and business hours on waits.)
24. The custom values are empty in GoHighLevel.

*State and recovery*
25. I edited the ledger by hand.
26. A skill refused to write and said it could not take a snapshot. (Fail-closed, and why that is the correct behaviour.)
27. I want the previous version of a file back.

*Updates*
28. I updated and something is worse.
29. The update did not appear.

**Length.** 10 to 14 KB.

**Acceptance.** Every `→ run:` recovery line in the shell code and in the doctor skill appears in this document, checked by CI. Every entry has all four parts.

### B.7 `CHANGELOG.md`, task `D-08`

**Exists.** No.

**Why it exists.** Founders take updates mid-programme, during a live event, and they are told in Slack that an update is worth taking. The changelog is where "why" lives, and it is where somebody who used a command that has since been removed finds out where it went.

**Audience.** Founders taking an update. Contributors. Whoever writes the Slack announcement, who should be able to copy from it.

**Format.** Keep a Changelog, reverse chronological, with Added, Changed, Removed and Fixed.

**Rules specific to this project.**
- Every entry is written for a founder, not for a contributor. "The CSV now rebuilds after you edit your posts" rather than "moved CSV write after edit pass".
- Any removed command or skill gets an explicit Removed line saying where the capability went, or that it is gone. The deferred playbook export is the immediate case.
- Every version that founders receive gets an entry, including the interim ones during the build, because the update drill in Session 3 has founders reading it live.
- The freeze at 1.0.0 on 3 September 2026 gets an entry recording that it is the frozen version and that later entries are fixes only.

**Seed entries.** `0.2.0` internal development, `1.0.0` the freeze, then the 1.1 lane.

### B.8 `CLAUDE.md` at the repository root, task `D-09`

**Exists.** Not at `/Users/pmudh/Documents/GitHub/Atlanta/CLAUDE.md`.
Two other files with that name exist and neither is this one: `/Users/pmudh/Downloads/Atlanta/launchhouse-atlanta/CLAUDE.md` holds the private working rules including rates and folder boundaries and must never be copied into the repository, and `dist/Launchhouse/CLAUDE.md` is a founder-facing file inside the distribution zip.

**Audience.** Anybody with commit access, and any Claude session opened in the repository.

**Contents.**

1. What this repository is, in three sentences, and that it is public.
2. The folder boundary. The private planning folder is at a different path, is never public, and nothing is copied from it into this repository without being read first. Name the path, name the rule, and note that `validate.sh` fails if the boundary is crossed.
3. The four systems, named, plus the explicit list of what was cut and must not be re-added by a well-meaning session: no direct message inbox skill, no DM gate, no `commands/inbox.md`, no conversation scopes.
4. The runtime floor and why. POSIX sh. No bash-isms, no python, no node, no jq on any founder path. Line-oriented state, never JSON. One sentence explaining that this exists because Windows Home founders are on Git Bash.
5. The shell script header shape, quoted in full, and the rule that every error message ends with a recovery line.
6. Failure postures, stated per script, with the four that are already decided: snapshot before rewrite is fail-closed, `SessionStart` context is fail-open, lint is warn-only, publish read-back is fail-loud.
7. The one-writer rule: which process owns which file, and that nothing else writes it.
8. House style for founder-facing text, and what `validate.sh` enforces. Point at `scripts/validate.sh` lines 26, 27, 203 and 209 rather than restating the banned list, so the list has one home.
9. One sentence per physical line for long markdown, and why.
10. Commit format: `<task-id>: <imperative summary>`, body stating what changed and the acceptance evidence in one line. One task, one commit.
11. `bash scripts/validate.sh` passes before every commit. It is the only automated check and there is no pushing past it.
12. Examples are generated, never hand-written, and regenerated when a skill changes. Point at this section of the delivery plan.
13. Facts that must stay consistent: the event dates, the install command, the marketplace name `launchhouse`, the namespaced command form, and the cohort size. Getting one wrong in a founder-facing file means correcting 130 people.

**Note.** This file is not currently scanned by `validate.sh`, because the scan covers `README.md`, `docs/` and `plugins/`. `D-04` widens the scan to include the repository root markdown files.

### B.9 `docs/img/`, task `D-10`, human

**Exists.** No. There is no image file anywhere in the repository.
Confirm with `find /Users/pmudh/Documents/GitHub/Atlanta -name '*.png' -not -path '*/.git/*'`, which returns nothing.

**Why it matters.** The GoHighLevel private integration walk is the hardest thing a non-technical founder does in this programme, and it is seven scopes deep in a settings interface. A skill that says "see the screenshots in PRE-WORK" when there are none references nothing, and 130 people get hand-held through it instead.

**The four screenshots, at minimum.**

| File | Shows |
|---|---|
| `docs/img/ghl-private-integrations.png` | GoHighLevel Settings with Private Integrations located in the menu |
| `docs/img/ghl-scopes.png` | The scope selection screen with the seven required scopes visibly ticked |
| `docs/img/ghl-token-created.png` | The token created screen, with the token itself redacted in the image |
| `docs/img/ghl-location-id.png` | Where the location id is found |

Add for Windows Home:

| File | Shows |
|---|---|
| `docs/img/win-git-install.png` | The Git for Windows installer at the one screen where a founder might hesitate |
| `docs/img/win-code-tab.png` | The Code tab in the Claude desktop app on Windows |

**Who and when.** Philip, during the same sitting in which he creates the private integration token for the spike. He is already in that screen, and capturing four images costs minutes there and hours later.

**Rules.** Redact the token, the location id and the account name in every image. Do not screenshot a real founder's account. Record the capture date in `docs/CONNECTIONS.md`, because these interfaces change and a screenshot of a menu that has moved is worse than no screenshot.

**Acceptance.** Change the wording from "every step has a screenshot slot" to "every screenshot slot is filled", and add a CI check that no founder-facing document contains an image reference pointing at a file that does not exist.

### B.10 The three snapshot copy maps, task `D-12`

**Exist.** No. `plugins/growth-engine/assets/ghl/` contains a single `README.md` and nothing else.

**Paths.**
- `plugins/growth-engine/assets/ghl/snapshots/b2b-core.md`
- `plugins/growth-engine/assets/ghl/snapshots/b2c-service-core.md`
- `plugins/growth-engine/assets/ghl/snapshots/b2c-ecom-core.md`

Three, not six. `plugins/growth-engine/assets/ghl/README.md` currently lists six snapshots in a two-track table, and the locked scope is three, selected automatically by route and model. `D-11` corrects that table.

**Audience.** Three, and the document has to serve all three.
The person building the snapshot in the GoHighLevel interface needs to know every message slot that exists.
The ops skill needs to know every custom value key it must produce copy for.
The clinic on 23 September 2026 needs a checklist to work through with each founder.

**Purpose.** It is the contract between the workflow that exists in GoHighLevel and the copy the toolkit writes. Every message in the workflow is a namespaced custom value, so the workflow structure is fixed and only the words change per founder. Without this document the ops skill is guessing at key names, and a key that does not exist means an empty message going to a real customer.

**Outline, identical shape for all three files.**

1. **What this snapshot is.** One paragraph. Which route and model select it, stated as the exact condition the ops skill evaluates.
2. **What it contains.** The workflows in it, named, in the order they fire. For `b2b-core`: lead follow-up, discovery booking, proposal chase. For `b2c-service-core`: comment-to-DM capture, DM qualify and book, pre-appointment reminders. For `b2c-ecom-core`: comment-to-DM capture, DM qualify and send to product, review request after delivery.
3. **Install.** The share link, once it exists. The load procedure. How to confirm it loaded into the right location.
4. **The custom value map. The core of the document.** One table per workflow.

   | Key | Workflow and step | Channel | Length limit | What it says | Filled by |
   |---|---|---|---|---|---|
   | `lh_b2b_lead_followup_1` | Lead follow-up, step 1 | Email | none | First reply after an enquiry | ops skill |
   | `lh_b2b_lead_followup_1_subj` | Lead follow-up, step 1 | Email subject | 60 chars | | ops skill |
   | `lh_b2b_disco_reminder_sms` | Discovery booking, reminder | SMS | 160 chars | | ops skill |

   Every key namespaced with the `lh_` prefix. Channel stated because SMS has a length limit that email does not and the ops skill must respect it. Length limit stated as a number, not as a note. Where a value is a link rather than copy, say so, and say where the founder gets that link.
5. **Timing.** Every wait, with its duration, and whether it respects business hours and which timezone. A workflow with an unqualified wait sends at three in the morning, and there is no way to know that from the copy alone.
6. **Sending identity.** Which from-name and which from-address or number each channel uses, and where that is configured.
7. **Prerequisites.** What must be true before this snapshot works. A connected channel. A booking calendar for the two that book. A phone number for anything with SMS, and the note that SMS requires registration that takes time and is not instant.
8. **The test-contact run.** The exact steps to fire the whole workflow against a test contact and confirm each step, with what to look for at each one. This is the checklist the clinic works through.
9. **What to change per founder and what never changes.** The copy changes. The structure does not. If a founder needs a structural change, that is a v1.2 conversation, not a clinic conversation.
10. **Version and change history.** If the snapshot is rebuilt, the share link changes, and everybody who loaded the old one has the old one.

**Acceptance.** A CI check, already anticipated in the PRD as the copy-map key lint, asserting that every `lh_*` key referenced by the ops skill appears in exactly one copy map, and that every key in a copy map is referenced by the ops skill. Neither direction alone is enough: an orphan key means a message with no copy, and an unmapped reference means the skill writing to a key that does not exist.

### B.11 The three asset readmes, task `D-11`

**`plugins/growth-engine/assets/examples/README.md`.** Handled by `EX-10`.

**`plugins/growth-engine/assets/ghl/README.md`.** Exists, 6 TODOs, and structurally wrong: it lists six snapshots across two tracks, where the locked scope is three across three routes. Rewrite the table to three rows with route, model, snapshot name and share link. Keep the closing rule that a changed snapshot means an updated link and a Slack announcement, and add that the version history in the copy map is updated at the same time.

**`plugins/growth-engine/assets/forms/README.md`.** Exists, 4 TODOs: three gate form links and the tracking sheet link. Two content problems beyond the placeholders.
Its gate 3 row requires "pods confirmed", and pods appear nowhere else in the product, in any skill, in any command, or in the PRD. Either pods are a real part of the programme, in which case something has to produce them, or the row is stale and comes out.
Its gate 2 row says "30 pieces edited", which is the right requirement and is currently unverifiable, because nothing on disk distinguishes thirty generated pieces from thirty edited ones. The ledger status field is what makes it verifiable, and this README should say which status the gate is checking for.

**The TODO gate.** `scripts/validate.sh` line 191 already greps all of `plugins/growth-engine/assets` for the string `TODO`, and it warns rather than errors.
That is wider than the PRD assumed, which is good, and weaker than it needs to be, which is not.
Change it to error when the version is 1.0.0 or above, so the 3 September freeze cannot ship with `Link: TODO` where a gate form URL belongs. Gate 1 fires in the week of 7 September on version 1.0.0, so a warning that everybody has learned to scroll past is not enough.

### B.12 Documentation checks to add to `scripts/validate.sh`

These belong to `D-04` and to the CI task in whichever section owns `validate.sh`. Listed here because this section is what makes them checkable.

1. **Command table completeness.** The row count of the README command table equals the file count in `plugins/growth-engine/commands/`. Error, not warn. The existing hard-coded expectations at lines 133 and 156 ("expected 9 skills", "expected 10 commands") must be updated in the same change and made errors, because a warning that is wrong for six weeks trains everybody to ignore the only automated check the project has.
2. **Trigger synchronisation.** Every plain-language phrase in the README's "Or just say" column appears in the description triggers of the skill that command routes to.
3. **No bare commands.** No founder-facing file contains a command in the bare form. Regex for the ten to fifteen known command names preceded by a slash and not preceded by `growth-engine:`. Both validators are supposed to fail on this and one check should own it.
4. **Relative links resolve.** Every relative link in `README.md` and in `docs/*.md` points at a file that exists.
5. **Image references resolve.** Every image reference points at a file that exists, and no image reference has an empty source.
6. **Scope string parity.** The seven private integration scope strings in `docs/CONNECTIONS.md` are byte-identical to the seven in the connect skill. This is a single sorted-diff comparison and it prevents the most expensive possible documentation error, which is a founder creating a token with the wrong scopes at Session 2 and discovering it at the clinic on 23 September.
7. **Recovery line parity.** Every `→ run:` line in the shell code and in the doctor skill appears in `docs/TROUBLESHOOTING.md`.
8. **Asset TODO gate.** Error rather than warn at version 1.0.0 and above, across all of `plugins/growth-engine/assets/`.
9. **Example freshness.** `scripts/check-examples.sh`, warn below 1.0.0, error at 1.0.0 and above.
10. **House style scope widened** to include the repository root `CLAUDE.md` and `CHANGELOG.md`.
11. **Fix the dash check before `docs/TROUBLESHOOTING.md` is written.** This one is a live bug and it will block `D-07`.
    Line 201 of `/Users/pmudh/Documents/GitHub/Atlanta/scripts/validate.sh` builds its dash test as a `grep -rn` over the founder files with a two-character bracket expression holding a literal em dash and a literal en dash.
    In a C or POSIX locale, which is what a GitHub Actions runner gives you unless something sets otherwise, `grep` matches that bracket expression byte by byte rather than character by character.
    The em dash is the bytes `E2 80 94` and the en dash is `E2 80 93`, so the class collapses to the byte set `E2`, `80`, `94`, `93`, and every multibyte character whose first byte is `E2` matches. The right arrow, `→`, is `E2 86 92`, so it matches.
    Reproduce it, using octal escapes so the `printf` calls are portable:

    ```sh
    printf 'x \342\206\222 run: foo\n' > /tmp/arrowtest.md
    DASHCLASS=$(printf '[\342\200\224\342\200\223]')
    LC_ALL=C grep -n "$DASHCLASS" /tmp/arrowtest.md            # matches the arrow, wrongly
    LC_ALL=en_US.UTF-8 grep -n "$DASHCLASS" /tmp/arrowtest.md   # no match, correctly
    ```

    The code standard requires every error message to end with a recovery line written as `→ run: ...`, and B.6 requires every one of those lines to appear in `docs/TROUBLESHOOTING.md`, which sits under `docs/` and is therefore scanned.
    So the first correct troubleshooting document hard-fails CI on a false positive.
    Fix it in `validate.sh` by matching the exact byte sequences rather than a character class, for example by building the two patterns with `EM=$(printf '\342\200\224')` and `EN=$(printf '\342\200\223')` and then running `grep -rn -e "$EM" -e "$EN"`, or by exporting `LC_ALL=en_US.UTF-8` at the top of the script and accepting that the locale must exist on the runner. The byte-sequence form is the safer of the two because it does not depend on an installed locale.
    Whichever is chosen, add a red-then-green test: a file containing `→ run: x` must pass, and a file containing a real em dash must fail.

### B.13 Part B task list

| Task | Document | Exists | Effort |
|---|---|---|---|
| `D-01` | `README.md` v2 | Yes, wrong version of the product | 0.5d |
| `D-02` | `docs/PRE-WORK.md` v2, per surface, Windows first-class | Yes, no Windows path | 0.75d |
| `D-03` | Distribution folder and `READ-ME-FIRST.md` | Yes, generated | 0.5d, owned by the packaging section |
| `D-04` | One sentence per line reflow, plus the ten CI checks in B.12 | Partial | 0.5d |
| `D-05` | `docs/CONNECTIONS.md` | **No** | 0.5d |
| `D-06` | `docs/USING-IT.md` | **No** | 1.0d |
| `D-07` | `docs/TROUBLESHOOTING.md` | **No** | 0.75d |
| `D-08` | `CHANGELOG.md` | **No** | 0.25d |
| `D-09` | `CLAUDE.md` at the repository root | **No** | 0.25d |
| `D-10` | `docs/img/`, six screenshots, human | **No** | 0.25d, Philip |
| `D-11` | The `ghl` and `forms` asset readmes, and the TODO gate | Yes, 10 TODOs between them | 0.25d |
| `D-12` | The three snapshot copy maps | **No** | 0.5d |

Total 6.0 days, of which 0.5 days sits with the packaging section and 0.25 days is human work by Philip.

**Sequencing.**
`D-08`, `D-09`, `D-10` and `D-11` can be done at any point and should be done early, because they are cheap and they unblock other people.
`D-05` needs the seven scope strings settled and the connect flow built.
`D-06` and `D-07` need the four systems to actually work, because writing a manual for behaviour that does not exist produces a manual that is wrong.
`D-01` and `D-02` are last among the founder-facing set, because they summarise everything else, and both must be finished before the onboarding email goes out on 4 September 2026.
`D-04` is genuinely last, because it reflows and checks what the others wrote.

**The hard deadline.** `docs/PRE-WORK.md` goes to 130 people on 4 September 2026 and cannot be corrected afterwards without a second email that says the first one was wrong. Treat 3 September as the real deadline for `D-01`, `D-02`, `D-05` and `D-10`, and treat `D-06` and `D-07` as due before Session 1 in the week of 7 September rather than before the email.

---

### Open questions this section could not resolve

1. **Is `skills/playbook-export` in or out?** The locked scope says deferred and says to flag rather than silently choose. A.9 sets out both consequences in full. It changes the README command table, the skill table, `docs/USING-IT.md`, the example file set and the printed playbook brief. Decide by 26 August 2026.
2. **Is there a sandbox GoHighLevel location available for the example runs before 1 September?** A.5 step 5 needs one to demonstrate publish read-back in at least one example. If not, all three examples stop at approved, and nothing in the repository ever shows a real post id.
3. **Do the invented business names and domains clear?** `EX-05` covers the check. Northfield Ops, Lumen Skin, and the three named best-fit accounts in Sam's Brain (Halewood Building Services, Trentham Mechanical, Castlefield Contracts) have never been checked against Companies House or WHOIS, and they are about to be published.
4. **Who has a clean Windows Home machine, and when?** A.10 puts one example generation on Windows Home, because it is the only cheap proof the POSIX floor holds. Nobody owns this.
5. **Are pods real?** `plugins/growth-engine/assets/forms/README.md` requires "pods confirmed" for gate 3, and pods appear nowhere else in the product or the PRD. Either something produces them or the row comes out.
6. **What are the authoritative outbound engine file names?** A.4.2 lists this section's working assumption. The outbound engine section of this plan owns the answer, and if it differs, it wins and the example manifests are updated.
7. **Who commits the Social Planner CSV header fixture, and when?** `plugins/growth-engine/assets/ghl/social-planner-template.csv` does not exist, and PRD spike task `S-03` at line 216 of `/Users/pmudh/Documents/GitHub/Atlanta/planning/PRD-growth-engine-v1.md` is the only thing that produces it. Without it the `content-30.csv` acceptance in A.4.1 cannot be asserted in any of the three runs. It needs a date before `EX-07`.
8. **Who owns the `validate.sh` dash-check locale bug in B.12 item 11?** It is a five-line fix and it blocks `D-07`, but `scripts/validate.sh` belongs to whichever section of this plan owns CI, not to this one.
9. **What exactly is the ledger status that gate 2 checks?** `plugins/growth-engine/assets/forms/README.md` requires "30 pieces edited" and nothing on disk currently distinguishes generated from edited. The brain section of this plan owns the ledger status enum, and `D-11` cannot finish until that enum is fixed.
