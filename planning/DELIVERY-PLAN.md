# Delivery plan: Oneday Growth Engine

Written 20 August 2026 against repo commit `e566f4e`.

This is the entry point.
It replaces Part Three of `planning/PRD-growth-engine-v1.md` and overrides that document wherever the two disagree.
Everything else in the PRD still stands.

**Read this page, then read the sections in order.**
They are separate files because the whole plan runs to about 10,500 lines, and one file that long is worse to work in than eight that are each about one thing.

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

## The three numbers that matter

**39.2 dev-days**, against 31.0 in the PRD as written.

The difference is not scope creep. Cutting the DM inbox saved 2.25 days. The other 10.45 are work the PRD already assumed had happened: the schema files it points at, the `ge` subcommands two of its own state files need, the four command routers it declares twice and never builds, the approve step its publish precondition depends on, the two orphan skills that write founder files with no snapshot, and one end-to-end run of a twelve-skill chain that until now was first exercised by 130 founders on the day.

**7.45 days are recoverable** through the cut order in section 02, which names what goes first and why each is safe.

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

## Six decisions this plan needs and cannot make for you

Each is flagged in place. None blocks starting.

| # | Decision | Why it cannot wait indefinitely |
|---|---|---|
| 1 | **The Session 2 token question.** Either `G2-01` moves into lane 1.0, pulling 1.5 days forward, or token creation moves to the 23 September clinic | `docs/PRE-WORK.md` cannot be finished without it, and that text freezes when the onboarding email goes out |
| 2 | **Which GoHighLevel tier founders buy.** No source document names one, and comment-to-DM may need a higher tier than the test account | Two documents consume the tier name and price, and founders are told to pay for it |
| 3 | **`X-01`, the full-arc run.** It sits in lane 1.0 but depends on lane 1.1 skills. Section 02 splits it into `X-01a` and `X-01b` at the same total | It changes when the finished example folders exist for the mentors |
| 4 | **`docs/CONNECTIONS.md` in the README.** `D-01` links it in lane 1.0; `G2-03` writes it in lane 1.1. Either move the link or ship a stub | 130 founders receive that README, and a dead link is a founder-visible defect |
| 5 | **`playbook-export`.** Deferred by section 00, with a full task body written in case it is taken | It compiles from files that are still changing shape |
| 6 | **When the TODO gate turns hard.** Promoting it to a failure before task `O-01` lands the three share links will fail the build immediately | It is the check that stops placeholder links reaching founders |

## The rules that govern the work

One task, one commit, in order.
`bash scripts/validate.sh` must pass with zero failures before every commit.
Acceptance is evidence you run and show, never assertion.
Commit format is `<task-id>: <imperative summary>`, with the acceptance evidence in the body.
POSIX sh only on anything a founder's machine runs, because Windows Home lands on Git Bash and that sets the floor.
Long markdown is one sentence per physical line.
Stop and ask when an acceptance fails twice, when a step needs an account or a vendor UI, or when external behaviour contradicts the spike findings.
