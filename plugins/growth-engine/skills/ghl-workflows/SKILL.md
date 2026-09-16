---
name: ghl-workflows
description: Build the operations engine. Runs a bottleneck diagnostic, picks one GoHighLevel snapshot from the library of six, and writes all the copy that goes inside it. Both tracks. Trigger on "build my ops engine", "which workflow should I automate", "my bottleneck", "pick a snapshot", "operations engine", or Session 2 homework.
---

# Operations Engine

Delivers the page promise: one workflow running on the founder's live business before they leave Atlanta.

The workflow itself is a pre-built GoHighLevel snapshot. It is loaded into the founder's own account at the clinic, and every message inside it arrives empty. This skill does the two things that actually need thinking: choosing the right one, and writing the words inside it.

**Founders do not build workflows.** If a founder starts describing a bespoke automation, bring them back to the library. Bespoke is what fails at 130.

## Prerequisites

Read `./growth-engine/founder-brain.md`.

If it does not exist, check the parent folder and the home directory before concluding it is missing. Founders commonly open Claude Code in a different folder from the one they built in.

If it genuinely does not exist, stop. Tell the founder to run `/growth-engine:brain` first (or to say "build my founder brain") and do not proceed. Do not ask them to describe their business again from scratch, and do not guess at their offer, audience or voice. Everything this skill produces is only as good as the Brain behind it.

Use it for track, stage, offer and goal.

## Step 1: bottleneck diagnostic

Find the one repetitive task that costs the most time or leaks the most revenue. Ask:

1. What do you do every week that you resent doing?
2. Where do people go quiet on you, and what happens next?
3. What do you forget to do, and what does it cost when you forget?
4. If one repetitive job disappeared on Monday, which one?

Then name the bottleneck in one sentence, in their words. Confirm it with them before moving on. Getting this wrong means automating the wrong thing.

## Step 2: pick the snapshot

One only. Two half-finished workflows are worse than one running.

### B2B library

| Snapshot | Runs on | Use when |
|---|---|---|
| Lead follow-up | Email | Inbound leads are not chased consistently |
| Discovery booking | Email | Booking a call takes too many messages |
| Proposal chase | Email | Proposals go quiet and nobody follows up |

### B2C library

| Snapshot | Runs on | Use when |
|---|---|---|
| Comment to DM | Instagram | Content gets engagement but no conversation |
| DM qualify and book | Instagram | DMs arrive but conversion is manual and slow |
| Review request | Email | Reviews are never asked for |

The library is deliberately small. If the founder's bottleneck falls outside these six, for example onboarding, reactivation, abandoned checkout or win-back, pick the nearest snapshot and adapt the message copy to it, and note the gap in the output file so a mentor can help individually. Do not invent a snapshot that does not exist and do not attempt a bespoke build.

**Name the platform from the table, never from memory.** A B2C snapshot runs on Instagram. Saying one runs on LinkedIn puts the other track's platform in front of a founder who is not on it, and it sends them to the wrong place on the day.

Recommend one and explain why against their stated bottleneck. Let them override.

## Step 3: write the copy

The snapshot is the plumbing. The copy is the founder's.

For the chosen snapshot, write every message it sends: emails with subject lines, DM replies, public comment replies and the words on any buttons. Written in the captured voice, matched to track.

Two rules that make the copy usable later. **No greeting inside a message body:** the workflow step writes the greeting and the first name above it. **Nothing in square or curly brackets:** the words in a slot are the same for everyone who receives that message, and anything about one person is merged by the step.

Also specify: the trigger, the wait intervals between steps, the exit condition, and which tags get applied.

Keep waits realistic. Chasing someone four times in two days annoys them.

**On the two DM snapshots, check the trigger before you write a word.** Both start with something the other person did: a comment on a post, or a message they sent in. Write the copy as the answer to that. If you find yourself writing to somebody who has done neither, the trigger is wrong, and no amount of rewriting the copy fixes it.

**No message claims a result the Brain does not record.** A review request that says join our 200 happy customers is an invented number, sent to a real customer who can count. If the Brain has no number, ask for the review on the work the founder actually did for that person, and name the work.

## Step 4: n8n escape hatch

Only if the data lives outside GoHighLevel. Stripe to a spreadsheet, Shopify to Airtable, a legacy system, multi-API orchestration.

Roughly one founder in six needs this. If the founder does not clearly need it, do not raise it. If they do, note the requirement in the output file and flag it for one-to-one support rather than trying to solve it here.

## Step 5: export

Write `./growth-engine/ops-workflow.md` containing the named bottleneck, the chosen snapshot, all message copy, the trigger, the timings, the exit condition, and the tags.

The founder takes this to the setup clinic on 23 September and loads the snapshot. Loading brings every workflow and the empty name of every message slot, and none of the words.

The words go in next, with `/growth-engine:values`, or by saying "fill my custom values". That step fills the Essentials slots every founder gets as well as the snapshot's own, so the copy written here is part of the list rather than all of it. Publishing and the first live test come after that, because a published workflow with empty slots sends blank emails to real people.

## Gate

Bottleneck named in one sentence, snapshot chosen, all copy written.
