## Scope: what is being built, and what is not

Decided 20 August 2026.
This section overrides `planning/PRD-growth-engine-v1.md` wherever the two differ.
Everything else in that PRD still stands.

### The four systems, and nothing else

| # | System | What the founder ends up with |
|---|---|---|
| 1 | **Content engine** | 30 pieces in their own voice, tracked in a ledger, exported as CSV, and scheduled into GoHighLevel Social Planner through the official GHL MCP with read-back verification |
| 2 | **Outbound engine** | B2B: a live Apollo search, 35 prospects built and cut to 25, enriched, made into contacts, and a sequence with a per-contact opening line enrolled **paused** for the founder to activate. B2C: 25 DM openers sent by hand, a hook bank, and offer tests. Every one of those people gets a file in `growth-engine/people/`: 35 for B2B with 10 at `status: cut`, 25 for B2C. See section 09 |
| 3 | **Back-end ops** | One of three GoHighLevel snapshots, chosen automatically by track and model, with every message written as a namespaced custom value. This includes comment-to-DM capture and DM qualify-and-book |
| 4 | **The brain** | `bin/ge`: schema'd state, one writer per file, snapshot before every overwrite with undo, an append-only ops log, a **curated memory that persists across sessions** (`growth-engine/memory.md`, written by `ge remember`), a **per-person entity layer** (one file per person under `growth-engine/people/`, written by `ge person`), a derived index, and a doctor that prints evidence rather than assertions. The memory layer is specified in section 08, the people layer in section 09 |

### Cut on 20 August. Do not build. Do not reference as coming later

The inbound DM reader is out. The DM inbox lives in the GoHighLevel app, where the founder reads and replies.
Claude writes the copy that goes inside the GHL workflow and never touches the inbox.

Removed from the build:

| Item | PRD reference |
|---|---|
| The `dm-inbox` skill | task G2-02 |
| `ge dmgate` and all 24-hour window code | task B-07 |
| `commands/inbox.md` | section 2.1 |
| The conversations spike | section S-04 |

Three token scopes are no longer requested, which shrinks what the founder's token can reach:
`conversations.readonly`, `conversations/message.readonly`, `conversations/message.write`.

**The Private Integration Token now needs exactly seven scopes:**
`socialplanner/post.readonly`, `socialplanner/post.write`, `socialplanner/account.readonly`, `socialplanner/statistics.readonly`, `contacts.readonly`, `contacts.write`, `locations.readonly`.

### Why this cut is the right one

It saves 2.25 dev-days: 0.25 for the spike section, 0.5 for the window code, 1.5 for the skill.

It removes every piece of Meta messaging policy from our code.
Nothing we ship can send a direct message, so the 24-hour user-initiated window becomes GoHighLevel's problem to enforce rather than ours to get right.
The failure mode we were most exposed to, sending outside the window because a timestamp parsed oddly on one founder's machine, no longer exists.

It also removes the only component that needed a real inbound message to test, which was the hardest thing to rehearse.

Comment-to-DM is unaffected. It runs as a GoHighLevel workflow, triggered by a comment keyword, with copy Claude writes into the snapshot's custom values. That is back-end ops, not an inbox reader.

### Two skills that sit outside the four systems

Both exist in the repo today and both were sold. Neither is one of the four.

**`skills/growth-plan` is IN.** The 90-day plan is the Sunday deliverable, the skill is small, and it reads the brain that is being built anyway. It currently has no task in the PRD and never reads the `track` field, so both tracks receive an identical plan. Section 02 adds a task for it.

**`skills/playbook-export` is NOT BUILT in v1.0.** Decided 21 August 2026: it is rebuilt once the architecture is settled end to end. The skill and the `/growth-engine:playbook` command stay in the repository untouched at 0.1.0, so the skill count, the command count, the README table and the validator are all unaffected. No task rewires it. It compiles a personalised insert from files that are all changing shape. Compiling from a moving target before the target settles wastes the work. Revisit once the four systems are stable.

Say which of these applies wherever it matters. Do not silently drop either.

### The three routes and the two platforms

Every part of this build covers all of them.

**Routes:** `b2b` · `b2c-service` · `b2c-ecom`.
The B2C split is by business model and it decides which snapshot the founder gets and how their content is shaped.

**Platforms:** macOS and Windows, across four surfaces.

| Surface | Available to | Shell | Notes |
|---|---|---|---|
| macOS Cowork | any Mac | VM sh | The default recommendation |
| macOS desktop Code tab | any Mac | `/bin/sh` | For founders who want to see files |
| Windows Pro or Enterprise Cowork | Windows with Hyper-V | VM sh | Same as macOS Cowork |
| **Windows Home desktop Code tab** | Windows Home | **Git Bash sh** | No Hyper-V means no Cowork. Requires Git for Windows |

That last row sets the runtime floor for the entire product.

**POSIX sh only.** No bash-isms, no python, no node, no jq on any founder path.
State files are line-oriented, never JSON, because there is no `jq` to read them.
All API calls are made by the Claude client over HTTPS, so nothing depends on what the founder's machine can reach.

### The rules that constrain every decision below

1. No automated cold Instagram or Facebook DMs, ever. The 25 B2C openers are sent by hand.
2. Cold email never goes through GoHighLevel. GHL is CRM, publisher and inbound. Apollo or the founder's own mailbox is the cold sender.
3. Apollo sequences enroll paused. Activation is the founder's own act.
4. Never invent proof, numbers, customers or outcomes. Thin proof is named in Flags and written around.
5. Every publish batch needs a human yes. There is no autonomous posting loop.
6. An opt-out line in every cold-email touch.
7. Secrets never enter chat. A token is typed into a masked prompt or a local file, never pasted into a conversation.
8. Everything a founder generates writes to `./growth-engine/` in their own working folder.
