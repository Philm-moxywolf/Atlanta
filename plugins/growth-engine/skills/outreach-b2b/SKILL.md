---
name: outreach-b2b
description: Build the B2B outreach engine. Turns the ICP into Apollo search criteria, writes a four to five touch sequence in the founder's voice, and generates personalised first lines for a pasted lead list. B2B track only. Trigger on "build my outreach", "write my sequence", "apollo filters", "cold email", "first lines", or Session 3 homework for B2B founders.
---

# Outreach Engine, B2B

Produces the sequence and the 25 personalised messages sent live on Saturday.

## Prerequisites

Read `./growth-engine/founder-brain.md`.

If it does not exist, check the parent folder and the home directory before concluding it is missing. Founders commonly open Claude Code in a different folder from the one they built in.

If it genuinely does not exist, stop. Tell the founder to run `/brain` first and do not proceed. Do not ask them to describe their business again from scratch, and do not guess at their offer, audience or voice. Everything this skill produces is only as good as the Brain behind it.

If `track` is not `b2b`, stop and route the founder to the audience-b2c skill instead. Do not run a B2B sequence for a B2C founder.

## Step 1: list criteria

Convert the ICP into filters a founder can type into Apollo.

Output the criteria as a plain list they can copy: industry, headcount band, revenue band, geography, job titles, seniority, and any technology or keyword filters that indicate the trigger event.

Give three variants: tight, medium, broad. Tight is the best-fit list and may be small. Broad is the fallback if tight returns under 100 results.

Tell them to build the list as homework and to verify emails before sending. An unverified list destroys domain reputation faster than bad copy.

## Step 2: sequence

Four to five touches over two to three weeks.

- Touch 1: the opener. Specific to them, one clear reason for the message, one low-friction ask.
- Touch 2: proof. A result or case relevant to their situation.
- Touch 3: a different angle on the same problem.
- Touch 4: a short, direct close.
- Touch 5, optional: the break-up.

Rules that are not negotiable:
- Under 120 words per touch. Shorter converts.
- One ask per message.
- Merge variables written as {{first_name}}, {{company}}, {{custom_1}}, matching GHL and Apollo conventions.
- No fake familiarity, no invented compliments, no "I noticed you..." unless it is genuinely specific.
- Written in the founder's captured voice, not in generic sales English.

Never write claims the Brain does not support.

## Step 3: first lines

The founder pastes in leads. For each, generate one opening line specific to that company or person.

Ask for whatever they have: company name, website copy, a recent post, a job ad, a news item. Generate from the actual detail. If there is nothing specific, say so and write a line based on the segment rather than fabricating a detail. **A generic honest line beats an invented specific one.**

Work in batches of 5 to 10 so the founder can check quality as it goes.

## Step 4: deliverability brief

Cover this even though it is not copy, because it decides whether any of it works.

- 25 messages is low volume. At this scale, authentication matters more than warmup duration.
- SPF, DKIM and DMARC must all be configured. Without them, mail gets filtered no matter how old the domain is.
- An existing domain with real sending history is still better than a fresh one. Use it if they have it.
- On a fresh domain, sending ten to twenty normal messages a day in the weeks beforehand is sufficient at this volume.
- Verify every email before sending. An unverified list does more damage than a cold domain.
- Never promise replies. Replies depend on list quality, timing and offer, none of which are guaranteed.

## Step 5: export

Write `./growth-engine/outreach-sequence.md` with the full sequence and variables.

Write `./growth-engine/outreach-firstlines.csv` with columns `email`, `first_name`, `company`, `custom_1`, where `custom_1` holds the generated first line.

Confirm the GHL import column headers at build time.

## Gate

Sequence approved, list criteria defined, list built in Apollo, first lines generated for the first 25.
