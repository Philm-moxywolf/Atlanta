# Delivery plan: Oneday Growth Engine

Written 20 August 2026 against repo commit `e566f4e`.

This is the entry point.
It replaces Part Three of `planning/PRD-growth-engine-v1.md` and overrides that document wherever the two disagree.
Everything else in the PRD still stands.

**Read this page, then read the sections in order.**
They are separate files because the whole plan runs to about 10,813 lines, and one file that long is worse to work in than nine that are each about one thing.

## The sections

| # | File | What it answers |
|---|---|---|
| 00 | [delivery/00-scope.md](delivery/00-scope.md) | What is being built and what was cut on 20 August. The four systems, the seven token scopes, the three routes, the four surfaces, the eight rules |
| 01 | [delivery/01-state.md](delivery/01-state.md) | Exactly where this starts from, every fact re-checked against the tree with the command to re-verify it |
| 02 | [delivery/02-build-steps.md](delivery/02-build-steps.md) | The build. 40 tasks across eleven phases, each with dependencies, numbered instructions, a runnable acceptance block and a commit line |
| 03 | [delivery/03-review-process.md](delivery/03-review-process.md) | The standing review machinery. Pre-commit gate, golden tests, three-OS CI, the end-to-end rehearsal, the release checklist, the regression rule, the 30-minute reviewer pass |
| 04 | [delivery/04-examples-and-docs.md](delivery/04-examples-and-docs.md) | The complete example set for all three routes, how examples are generated rather than written, and every document the product needs including the day-to-day manual |
| 05 | [delivery/05-routes-and-platforms.md](delivery/05-routes-and-platforms.md) | The coverage matrix, the operator path from clone to release, four founder walkthroughs, three route journeys, and a verifiable go-live checklist per route |
| 06 | [delivery/06-code-standards.md](delivery/06-code-standards.md) | What "all the code is commented" means in enforceable terms. Header template, comment rules, the POSIX ban list with the portable idiom for each, error format, and how the validator checks it |
| 07 | [delivery/07-quality-and-simplicity.md](delivery/07-quality-and-simplicity.md) | Simplifications worth taking, the risk register the PRD dropped, specified fallbacks, ranked day-of failures, the cut order, and the definition of done |
| 08 | [delivery/08-persistent-memory.md](delivery/08-persistent-memory.md) | The persistent local memory each founder gets, ported from the Glitch vault model. The curated layer, managed blocks, the hold rule, CRLF handling, and task B-10 |

## The three numbers that matter

**44.95 dev-days**, against 31.0 in the PRD as written.

That is 39.2 for the original build in section 02, plus 1.0 for the persistent memory layer in section 08, plus 4.75 merged in from section 04's own registry on 21 August.

The difference is not scope creep. Cutting the DM inbox saved 2.25 days. Of the rest, 1.0 is the memory layer added on 20 August after reviewing the Glitch brain, and 10.45 are work the PRD already assumed had happened: the schema files it points at, the `ge` subcommands two of its own state files need, the four command routers it declares twice and never builds, the approve step its publish precondition depends on, the two orphan skills that write founder files with no snapshot, and one end-to-end run of a twelve-skill chain that until now was first exercised by 130 founders on the day.

**The cut order in section 02 is a record, not a plan.** Decision 1 was to build it all, so the **8.45 days are recoverable** on paper but are not being taken. It stays written so that if the date moves the options are already sized.

**About 3.5 days of that is not the executor's**, it is account setup, vendor UI work and clean-machine time. It runs alongside rather than adding.

## What changed on 20 August

The inbound DM reader is cut. The DM inbox lives in the GoHighLevel app, where the founder reads and replies. Claude writes the copy that goes inside the GHL workflow and never touches the inbox.

Removed: the `dm-inbox` skill, `ge dmgate` and all 24-hour window code, `commands/inbox.md`, spike section S-04, task G2-02, and three token scopes.

Comment-to-DM is unaffected and still ships, as a GoHighLevel workflow with Claude-written copy.

That leaves the Private Integration Token needing exactly these seven scopes:
`socialplanner/post.readonly`, `socialplanner/post.write`, `socialplanner/account.readonly`, `socialplanner/statistics.readonly`, `contacts.readonly`, `contacts.write`, `locations.readonly`.

## Start here

1. Push. Eleven commits and the tag `v0.1.0` exist only on this laptop, and every task below assumes the remote is current.
2. Run task `T-00` in section 02: triage the 95 verified findings in `/Users/pmudh/Downloads/Atlanta/launchhouse-atlanta/planning/FUNCTIONAL-REVIEW.md`. Half a day, and it stops the rest being rediscovered one at a time.
3. Do the spike, `S-01` through `S-07` minus the cut `S-04`. It is almost all Philip's, and nothing downstream may invent an API field, header, tool name or CSV column that is not in `planning/spike-findings.md` with pasted evidence.

## Decisions, as taken on 21 August 2026

| # | Decision | Answer |
|---|---|---|
| 1 | Scope under the lane pressure | **Build it all. No cutting scope.** The cut order in section 02 stays written as a record of what would go first, but it is not to be used |
| 2 | Merge section 04's registry into section 02's | **Done.** 4.75 days of genuinely new work moved into section 02, the rest recorded as absorbed |
| 3 | Which GoHighLevel tier founders buy | **The 97 dollar Starter tier.** Named in the founder docs and the cost table |
| 5 | `playbook-export` | **Not built in v1.0, rebuilt once the architecture is settled end to end.** The skill and its command stay in the repository untouched at 0.1.0, so no count, table or check moves |
| 7 | Push | **After the remaining repairs**, not before |

### Consequence of decision 1 that is not yet resolved

Building it all removes the cut lever, and the arithmetic does not close on its own.
Lane 1.0 carries 28.60 dev-days into roughly 10 working days before the 3 September freeze, with one executor.
Two levers remain and both are Philip's: **move the freeze date**, or **add a second pair of hands**.
Nothing in this plan can be executed to a fixed date until one of them is pulled.

### Consequence of decision 3 that the spike must confirm

The 97 dollar Starter tier is the answer, and spike `S-01` has to prove two things hold at that tier before anything is built on it.
One: that Private Integration Tokens are available at all, since the whole credential design depends on them.
Two: that the comment-to-DM trigger and inbound Instagram capture work there, because that is the B2C operations track for roughly 65 founders.
If either sits above Starter, the tier decision or the B2C ops design has to move, and that is better known in August than in September.

## Still open

| # | Decision | Why it cannot wait indefinitely |
|---|---|---|
| 1 | **The Session 2 token question.** Either `G2-01` moves into lane 1.0, pulling 1.5 days forward, or token creation moves to the 23 September clinic | `docs/PRE-WORK.md` cannot be finished without it, and that text freezes when the onboarding email goes out |
| 4 | **`docs/CONNECTIONS.md` in the README.** `D-01` links it in lane 1.0; `G2-03` writes it in lane 1.1. Either move the link or ship a stub | 130 founders receive that README, and a dead link is a founder-visible defect |
| 6 | **When the TODO gate turns hard.** Promoting it to a failure before task `O-01` lands the three share links will fail the build immediately | It is the check that stops placeholder links reaching founders |

## Two numbering schemes, and what each governs

The plan uses more than one id series. They are not interchangeable, and mistaking one for another is how work gets skipped.

| Prefix | Meaning | Defined in | Counted in the 44.95? |
|---|---|---|---|
| `T-`, `S-`, `G-`, `B-`, `FB-`, `C-`, `GP-`, `AB-`, `PB-`, `SS-`, `CMD-`, `D-01..04`, `CI-`, `X-`, `R-`, `G2-`, `A-`, `O-` | Build tasks | Section 02, and `B-10` in section 08 | **Yes** |
| `EX-01..05`, `EX-11` | Example-harness tasks, merged into section 02 on 21 August | Section 04 Part A, stubbed in section 02 before `X-01` | **Yes** |
| `EX-06..10` | Absorbed or closed: `EX-06` already applied, `EX-07..09` are the procedure for `X-01`, `EX-10` folds into `FB-02` | Section 04 Part A | Absorbed, not counted twice |
| `D-06`, `D-07`, `D-10`, `D-11` | Documentation tasks, merged into section 02 Phase 7 on 21 August | Section 04 Part B, stubbed in section 02 | **Yes** |
| `D-05`, `D-08`, `D-09`, `D-12` | Duplicates of `G2-03`, `G-02`, `G-01` and `O-02` | Section 04 Part B | Absorbed, not counted twice |
| `CK-01..31` | Validator checks that exist today | Section 03, local reference only | Not tasks |
| `V-01` upward | Validator checks this plan adds | Section 03, local reference only | Not tasks |

**Section 04's registry has been merged, as of 21 August 2026.**
Part A totalled 5.10 days and Part B 6.00 days. Of that 11.10, six tasks were duplicates of work section 02 already counted, three were the detailed procedure for `X-01` rather than separate work, one had already been applied by hand, and one folded into `FB-02`.
What was genuinely new is 4.75 days and it is now stubbed inside section 02, in Phase 7 for the documents and immediately before `X-01` for the examples harness.
That includes `D-06`, the day-to-day manual at `docs/USING-IT.md`, which is client requirement 3 and previously had no task anywhere in the build.

## The rules that govern the work

One task, one commit, in order.
`bash scripts/validate.sh` must pass with zero failures before every commit.
Acceptance is evidence you run and show, never assertion.
Commit format is `<task-id>: <imperative summary>`, with the acceptance evidence in the body.
POSIX sh only on anything a founder's machine runs, because Windows Home lands on Git Bash and that sets the floor.
Long markdown is one sentence per physical line.
Stop and ask when an acceptance fails twice, when a step needs an account or a vendor UI, or when external behaviour contradicts the spike findings.
