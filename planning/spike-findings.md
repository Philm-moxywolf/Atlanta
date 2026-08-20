# Spike findings

The source of truth for external behaviour, per PRD Part Zero rule 5.
No API field, header, tool name, or CSV column may be used anywhere in this repo unless it appears below with pasted evidence.
If something is not here, it does not exist yet: add a spike question rather than guessing.

**Status: not started.** Every section below is a container awaiting evidence.
Sections marked ⚑HUMAN need an account, a token, a vendor UI, or a physical machine, so they are Philip's to run.
The executor fills in nothing here from reasoning. Only pasted output counts.

How to fill a section: replace the `_finding:_` line with one sentence stating what is true, then paste the raw evidence in the block beneath it.
Delete the `PENDING` marker when a section is complete.

---

## S-01 ⚑HUMAN — accounts

PENDING

_finding:_

Required before this is complete:

- GHL paid account with API access, and one test location.
- A Private Integration Token created at Settings → Private Integrations with **exactly** these nine scopes:
  `socialplanner/post.readonly`, `socialplanner/post.write`, `socialplanner/account.readonly`, `socialplanner/statistics.readonly`, `conversations.readonly`, `conversations/message.readonly`, `conversations/message.write`, `contacts.readonly`, `contacts.write`, `locations.readonly`.
- The locationId recorded.
- A paid Apollo seat.
- A test Facebook Page, and an Instagram Business account if one is available, connected to the test location's Social Planner.

**The token itself never goes in this file, and never into chat.** Record only its creation date.

```
PIT created (date):
Scopes granted (paste the list shown in the GHL UI):
locationId:
Apollo seat (plan name + date):
Social accounts connected to the test location:
```

ACCEPT: this section lists the PIT creation date, the scope list, and the locationId.

---

## S-02 ⚑HUMAN — GHL MCP catalog

PENDING

_finding:_

Run in a terminal, substituting your own values. The token stays in your shell, never in this repo.

```
claude mcp add --transport http ghl-test https://services.leadconnectorhq.com/mcp/ \
  --header "Authorization: Bearer <pit>" \
  --header "locationId: <id>"
```

Then list the tools, and separately probe `https://services.leadconnectorhq.com/mcp/anthropic/v2`.
Whichever endpoint yields **named** tools is the one the plugin ships with.

```
Endpoint tested:
Tool count:
Named tools (paste the full list):

socialmediaposting_create-post present?      yes / no
conversations_send-a-new-message present?    yes / no

Second endpoint (/mcp/anthropic/v2) result:

CHOSEN ENDPOINT:
```

ACCEPT: the actual tool names are listed, and the chosen endpoint is stated.

---

## S-03 ⚑HUMAN — social write, timezone and limits

PENDING

_finding:_

Through the MCP, in order: `get-account`, then `create-post` as a draft, then `create-post` scheduled for a known local time tomorrow, then check what the GHL UI displays, then `edit-post`, then `get-post` read-back, then delete or archive.
Then fire fifteen rapid `get-posts` calls and capture any 429.

The timezone question is the one that matters most: if `scheduleDate` is interpreted as UTC but the founder means 09:30 local, every scheduled post lands at the wrong hour for 130 people.

```
get-account response shape (this becomes the ghl-accounts.md cache format):


create-post draft — request and response:


create-post scheduled — request sent (note the exact scheduleDate string):

  ...and what the GHL UI displayed:

TIMEZONE RULE (one sentence, unambiguous):


get-post read-back response:


429 body, if one appeared:

Rate observed before throttling:
```

Also required: download the in-app Social Planner CSV template and commit it verbatim as
`plugins/growth-engine/assets/ghl/social-planner-template.csv`.

ACCEPT: the timezone rule and the 429 shape are stated, and the CSV fixture file is committed.

---

## S-04 ⚑HUMAN — conversations

PENDING

_finding:_

From the test Instagram or Facebook account, or SMS as a proxy: send an inbound message, then `search-conversation`, then `get-messages`, then `send-a-new-message` as a reply inside the window.

The `dateAdded` format is load-bearing: `ge dmgate` parses it to decide whether a send is legal, and it fails closed on anything it cannot read.

```
search-conversation response:


get-messages response (paste one full message object):


EXACT dateAdded FORMAT STRING:

Example value:


send-a-new-message request and response:

Message type value used for IG:
Message type value used for FB:
```

ACCEPT: a real message-shape block is pasted, and the dateAdded format string is stated.

---

## S-05 ⚑HUMAN — DECISION GATE A: userConfig in Cowork

PENDING

_finding:_

The probe plugin is built and waiting at `planning/spike/gate-ab-plugin/`.
Install it through **Cowork → Customize → Plugins**.
When prompted for the spike token, type `pit-DUMMY-not-real`. Never type a live token into a probe.

Then run `/gate-ab-probe:spike-check` and paste what it reports.

A 401 from GoHighLevel is the **success** case for the header question: it proves the value was substituted and sent. A missing server, or an error about a malformed header, is the failure case.

```
Did a masked prompt appear at install?        yes / no
Was the value hidden as you typed?            yes / no
Did the header substitute (401 observed)?     yes / no
Screenshot path:

spike-check output:

```

**DECISION GATE A**

- **yes** → credentials go through `userConfig`, which is PRD §2.4 primary. Task G-03 ships the verbatim userConfig block, and G2-01 uses the masked-prompt walk.
- **no** → the `headersHelper` fallback becomes primary. G2-01 branches to the `${CLAUDE_PLUGIN_DATA}/ghl.env` route, where the founder edits the file in their own text editor and the token never enters chat.

```
GATE A VERDICT:
```

ACCEPT: the observed Cowork UI is recorded, with a screenshot path.

---

## S-06 ⚑HUMAN — DECISION GATE B: hooks and the bin floor

PENDING

_finding:_

Same probe plugin. Install and run `/gate-ab-probe:spike-check` on all three surfaces.
The Windows Home row is the one that sets the floor for the entire brain, so it cannot be skipped or inferred from the other two.

Look for two things each time: a `GATE-B-MARKER mode=hook` line appearing at session start before you type anything, and whether `ge-test manual` runs at all.

```
macOS, Cowork
  hook fired?              yes / no
  ge-test on PATH?         yes / no
  marker line:

macOS, desktop Code tab
  hook fired?              yes / no
  ge-test on PATH?         yes / no
  marker line:

Windows Home, desktop Code tab, Git Bash
  Git for Windows installed?   yes / no
  hook fired?              yes / no
  ge-test on PATH?         yes / no
  marker line:
```

**DECISION GATE B**

- Hooks fire everywhere → keep the SessionStart belt as designed.
- Hooks do not fire somewhere → hooks still ship, but the design's stated primary, skills calling `ge` directly, becomes the only guarantee. Docs must then never promise hook behaviour.

```
GATE B VERDICT:
```

ACCEPT: three receipts are recorded above, one per surface.

---

## S-07 ⚑HUMAN — Apollo paid

PENDING

_finding:_

OAuth-connect Apollo in Cowork and in Code, then on the paid seat: people-search returning one result, create a contact, create or confirm a `first_line` custom field (textarea, contact modality), create a test sequence with one `auto_email` touch using `{{first_line}}` and an opt-out line, add the test contact with `send_email_from_email_account_id` set to your own mailbox, confirm it lands **paused**, and confirm stop-on-reply is visible and on.

Delete every test artifact afterwards.

The paused-state proof is the important one. PRD policy wall 4 says sequences enroll paused and activation is the founder's act, and that has to be a fact about the tool, not a hope.

```
OAuth in Code — how it was triggered, and did it work:
OAuth in Cowork — how it was triggered, and did it work:

Action names enumerated (paste the list):


people-search — action name used and result count:

create contact — action name and response:

first_line custom field — created or pre-existing, and its id:

sequence created — action name and response:

contact added with send_email_from_email_account_id — response:

PAUSED STATE PROOF (paste it):

Stop-on-reply visible and on?    yes / no

Test artifacts deleted?          yes / no
```

ACCEPT: the action names used are recorded, and the paused state is proven.

---

## Open spike questions

Things discovered mid-build that need an answer before something can be written.
Add here rather than guessing, per Part Zero rule 5.

- (none yet)
