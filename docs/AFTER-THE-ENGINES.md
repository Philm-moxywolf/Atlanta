# After the engines

Sent before Session 3. It covers two days, not one: the week after the session, when Claude writes all your GoHighLevel words, and the clinic itself, when you load your snapshot and paste them in. It ends with a real email arriving in your own inbox.

Read it once now. The writing takes about half an hour, in the week before. The clinic takes about half an hour, and fifteen minutes of that is pasting.

## 1. Update the plugin

**This is the plugin in Claude, not the app.** Updating the app is a separate thing, it follows the steps we post in Slack, and nothing here asks you to touch it.

Your copy of the plugin is whatever version you installed. Updates are not automatic, and the "fill my custom values" step in section 3 arrived in a later one.

- **Desktop app or Cowork:** press the **+** button next to the message box, open **Plugins**, find **growth-engine** and update it. If it still looks the same, quit the app and open it again.
- **Claude Code in the terminal:** run `/plugin marketplace update launchhouse`, then reinstall the plugin if you are asked to.

If you have not installed it at all, the two lines are in the README:

```
/plugin marketplace add Philm-moxywolf/Atlanta
/plugin install growth-engine@launchhouse
```

**Updating never touches your work.** Your Brain, your posts and your files live in your own folder on your computer, not inside the plugin.

**Check it worked.** Open your folder in Claude and say **"fill my custom values"**. If Claude knows what you mean, you are on the new version.

## 2. Check what you have

Say **"where am I up to"**. In your `growth-engine` folder you want:

- `founder-brain.md`, locked
- `content-30.md`, with your 30 approved
- your second engine: `outreach-sequence.md` for B2B, or `hook-bank.md`, `dm-openers.md` and `inbound-scripts.md` for B2C
- `ops-workflow.md`, which names the one snapshot you chose and holds its copy

If `ops-workflow.md` is missing, say **"build my ops engine"** first. Everything below reads it.

## 3. The week after Session 3: write your words

**This is the job.** About half an hour, at home, and it does not need your snapshot. Doing it now is the difference between a clinic that is a paste and a clinic that is an hour of writing.

A custom value is a named slot in your account. Your workflows are built to drop your words into those slots, so one welcome email is written once and used everywhere. Your snapshot brings the empty slots on the day. The words are written before that.

Say **"fill my custom values"**, or type `/growth-engine:values`.

Claude reads your Brain and your engine files, asks you the few things nothing else answers, writes every message in your voice, and saves them to `ghl-values.md` in your folder.

Both lists come out of the one snapshot you chose in `ops-workflow.md`, because every snapshot carries **Essentials** inside it. So you write **Essentials**, which is 11 values, and the list for the snapshot you chose. Nothing else. That is between 11 and 22 values in total. Nine of the eleven Essentials values are needed before you publish; the two that welcome a new client or customer are only needed if you switch that pair of workflows on.

**Read them back.** They are your words going to real people. Change anything that does not sound like you. Changing a word now costs nothing. Changing it at the clinic costs your place in the queue.

**One value waits for the day.** If you chose `Discovery booking`, `Call Booking Link` is a link copied out of your own account rather than words, so Claude leaves it blank and you paste it in at the clinic.

**If you chose Review request,** it has no custom values at all. Its two emails live in your review templates instead. Write both now with Claude, into the same file. They go in at `Reputation`, the `Settings` tab, then the email request settings, then `Set Email Templates`: `Review Ask Email` in the `Live` slot and `Review Reminder Email` in the `Retry` slot. Both arrive holding the word PLACEHOLDER and send exactly as they are, so they must be replaced before you publish.

## 4. Also worth doing before the day

Neither of these needs your snapshot, and together they take about ten minutes. Doing them now is what keeps the clinic to half an hour.

**Add yourself as a user of your sub-account.** Go to `Switch to Agency View`, then `Settings`, then `Team`. Open your own user, go to `Roles & Permissions`, and add your business sub-account. Users never travel in a snapshot, and the alerts inside yours go to the users of the account, so if you are not one you get none of them.

**Fill in your Business Profile and your wallet.** Business Profile: your business name, your `Business Physical Address`, and a `Business Email` on your own domain, never gmail, yahoo or outlook. Every email you send ends with these, and the unsubscribe box stays ticked. Wallet: in `Agency View`, `Settings`, `Billing`, then `Wallet & Transactions`, add a card and set auto recharge. Every email costs a little, your own alerts included, and sending stops when the wallet runs dry.

## 5. The clinic, Wednesday 23 September

About half an hour, and fifteen minutes of that is pasting. You arrive with `ghl-values.md` already written.

**The only part that has to happen here is the load**, because the share link is handed to you on the day. Everything else is checking and pasting.

Your snapshot page, the printed pack you are given at the clinic, carries the lists for your own snapshot. This is the spine that every founder follows.

### 1. Load the snapshot

A snapshot is a pack of ready-built workflows, the one you chose in your ops engine. It arrives as a set of workflows, not as a single one.

We give you the share link on the day. Open it, choose your sub-account, and wait. It takes a few minutes. If it asks about conflicts, leave every item unticked.

If you did not add yourself as a user in the week before, do that first, at `Switch to Agency View`, then `Settings`, then `Team`.

**What arrives:** every workflow, every tag, your pipelines, your forms, and the name of every message slot.

**What does not arrive: your words.** Custom value contents never travel in a snapshot, and neither do users. Every email arrives built, with empty slots where your words go, and an empty slot sends as a blank space to a real person.

### 2. Put everything back to draft

Nobody has documented what state workflows arrive in, so make it certain. Go to `Automation`, then `Workflows`. Show the published ones, select them, and set them to draft under `Bulk Actions`. Selecting only covers the page you can see, so check every page.

Nothing can fire at a real person while you work.

### 3. Paste the words in

Open `ghl-values.md` next to your browser. Switch back to your sub-account if you are still in Agency View, then open `Settings`, then `Custom Values`. Every name is already sitting there, because the snapshot brought it. Open each one, paste the words you wrote last week, and save. Around fifteen minutes.

**Change the words only, never the name.** When a value is first saved, GoHighLevel quietly makes a permanent label out of its name, and every workflow step points at that label rather than at the name you see. Rename it afterwards and the label stays behind, so every message that used it goes out blank, with nothing on screen to tell you.

**Claude can do this part for you over the API if you would rather.** Most people paste by hand, and that is the route we support on the day. The other way needs a Private Integration Token you make yourself, in your own sub-account, at `Settings`, then `Private Integrations`, ticking the custom values boxes and nothing else. That token is a password for your whole account and it keeps working for 90 days, so keep it out of your Launchhouse folder, never type it into the chat, put it in a plain text file somewhere else and tell Claude where it is, and delete it in GoHighLevel as soon as the values are in.

Your GoHighLevel connector cannot do this part. It reads your account and posts content, and it has no custom values tool, so do not go looking for one.

### 4. The two that are not words

**If you chose `Discovery booking`:** open your `Discovery call` calendar, click `Share`, then `Copy Link`, and paste that link into `Call Booking Link`. This is the value Claude left blank.

**If you chose `Review request`:** paste your two review emails into the templates at `Reputation`, the `Settings` tab, then the email request settings, then `Set Email Templates`.

### 5. Check four things

Tell Claude you have finished pasting. If you pasted by hand, Claude cannot see inside your account, so it reads your list back to you one at a time and you check each one on screen:

1. Every value on your two lists is there.
2. None is empty.
3. None still says PLACEHOLDER, and none has a square or curly bracket in it.
4. No name was changed, so the keys your workflows use still match.

If Claude filled them over the API, it reads all four back out of the account itself.

### 6. Re-pick anything blank

A load can leave a choice inside a step empty. Your snapshot page lists every step to open. Check the pipeline and stage on each card mover, the `Form Is` choice on each form trigger, and the tag under every tag trigger.

Claude cannot see inside your account, so this one is done by eye. Your `ops-workflow.md` names the pipeline your snapshot uses, so ask Claude which stage a step should point at if you are unsure.

### 7. Publish, in the order on your snapshot page

Publish every workflow that is not optional, in the order your snapshot page gives: **the card movers first, then the automations, then the event workflows, then the entry workflows.** Publish one group, check every workflow in it shows as published, then start the next.

Order matters here. A card mover that is still a draft when an automation starts leaves cards sitting in the wrong place.

**Leave `Essentials 13` and `Essentials 14` as drafts** unless you filled the two welcome values. They are optional on both tracks.

**Drafts never run**, so a test before publishing proves nothing, and a published workflow with empty values sends blanks to real people. That is why the words go in first.

### 8. Re-pick what points at another workflow, then test

These waited until now because a workflow that is still a draft may not appear in the list to pick from. Your snapshot page names each one. Open them, re-pick anything blank, and save.

Then fire your trigger yourself, the way a real person would. Your `ops-workflow.md` names it. For most people it is their own `Enquiry form`: open it, fill it in using a second email address you can read, and send it. Within about three minutes the welcome email arrives, opening with your greeting word and your first name, then your words, then your business name and address at the bottom. Read all of it.

On the two Instagram snapshots the trigger is a comment on one of your posts, or a DM, so use a second Instagram account or ask a friend.

- A blank where words should be: that value is still empty.
- Curly brackets in the email: a value was renamed after it was made.
- Nothing at all: the workflow is still a draft.

If something is wrong, put that workflow back to draft, fix it, and test again.

## 6. Before you travel

Short, and none of it is urgent on the day:

- **Turn duplicate contacts off**, at `Settings`, then `Business Profile`, under contact deduplication. Without it the same person filling your form twice becomes two contacts and gets two welcomes.
- **Allow more than one card per person**, at `Settings`, then `Objects`, then `Opportunities`. Tick `Allow Multiple Opportunities per Contact`, unless something else in your account already makes cards.
- **Make your QR code and copy your form embed codes last**, after your snapshot is loaded for the last time, so the links point at the forms you are actually using.
- **Put a privacy page on your site** and link it from your forms.
- **A sending domain of your own**, if you have one. Recommended, not required.

## What goes wrong, and what to do

| What you see | What it means |
|---|---|
| A blank email arrived | That value is empty. Fill it and test again |
| The word PLACEHOLDER arrived at a real person | The workflow was published before the value was filled. Put it back to draft, fix it, publish again |
| Curly brackets in an email | A value was renamed, so its key no longer matches the step. Tell Claude and it will find which one |
| Nothing arrived at all | The workflow is still a draft |
| Claude does not know "fill my custom values" | The plugin has not updated yet. Go back to section 1, and find this out in the week before rather than at the clinic |

## Stuck

Post in the Slack channel. Do not wait for the session.
