# After the engines

Sent before the clinic. This is what happens once your Brain, your content, your second engine and your workflow copy are written, and it ends with a real email arriving in your own inbox.

Read it once now. It takes about an hour on the day, and fifteen minutes of that is pasting.

## 1. Update the plugin

**This is the plugin in Claude, not the app.** Updating the app is a separate thing, it follows the steps we post in Slack, and nothing here asks you to touch it.

Your copy of the plugin is whatever version you installed. Updates are not automatic, and the "Fill the words" step in section 3 arrived in a later one.

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

## 3. The clinic, Wednesday 23 September

Ten steps, and the order is the whole point. Your snapshot page, the printed pack you are given at the clinic, carries the lists for your own snapshot. This is the spine that every founder follows.

### Load the snapshot

**Add yourself as a user first, before you load anything.** Go to `Switch to Agency View`, then `Settings`, then `Team`. Open your own user, go to `Roles & Permissions`, and add your business sub-account. Users never travel in a snapshot, and the alerts inside yours go to the users of the account, so if you are not one you get none of them.

Then open the share link we give you on the day, choose your sub-account, and wait. It takes a few minutes. If it asks about conflicts, leave every item unticked.

**What arrives:** every workflow, every tag, your pipelines, your forms, and the name of every message slot.

**What does not arrive: your words.** Custom value contents never travel in a snapshot, and neither do users. Every email arrives built, with empty slots where your words go, and an empty slot sends as a blank space to a real person.

### Put everything back to draft

Nobody has documented what state workflows arrive in, so make it certain. Go to `Automation`, then `Workflows`. Show the published ones, select them, and set them to draft under `Bulk Actions`. Selecting only covers the page you can see, so check every page.

Nothing can fire at a real person while you work.

### Business profile and wallet

Two settings, and email does not work properly without either.

**Business Profile:** your business name, your `Business Physical Address`, and a `Business Email` on your own domain, never gmail, yahoo or outlook. Every email you send ends with these. Leave the unsubscribe box ticked.

**Wallet:** in `Agency View`, `Settings`, `Billing`, then `Wallet & Transactions`, add a card and set auto recharge. Every email costs a little, your own alerts included, and sending stops when the wallet runs dry.

### Fill the values

A custom value is a named slot in your account. Your workflows are built to drop your words into those slots, so one welcome email is written once and used everywhere. The snapshot brings you the empty slots, and this is where the words go in.

Say **"fill my custom values"**, or type `/growth-engine:values`.

Claude reads your Brain and your engine files, asks you the few things nothing else answers, writes every message in your voice, and saves them to `ghl-values.md` in your folder.

Both lists come out of the one snapshot you loaded, because every snapshot carries **Essentials** inside it. So you fill **Essentials**, which is 11 values, and the list for the snapshot you chose. Nothing else. That is between 11 and 22 values in total. Nine of the eleven Essentials values are needed before you publish; the two that welcome a new client or customer are only needed if you switch that pair of workflows on.

If you loaded **Review request**, it has no custom values at all. Its two emails live in your review templates, at `Reputation`, the `Settings` tab, then the email request settings, then `Set Email Templates`. Both arrive holding the word PLACEHOLDER and send exactly as they are, so rewrite both before you publish: `Review Ask Email` goes in the `Live` slot and `Review Reminder Email` in the `Retry` slot.

### Put them into your account

**By hand, which is how most people do it.** Switch back to your sub-account first if you are still in Agency View. Open `Settings`, then `Custom Values`. Every name is already sitting there. Open each one, paste the words, save. Around fifteen minutes.

**Change the words only, never the name.** When a value is first saved, GoHighLevel quietly makes a permanent label out of its name, and every workflow step points at that label rather than at the name you see. Rename it afterwards and the label stays behind, so every message that used it goes out blank, with nothing on screen to tell you.

**Over the API, only if you would rather.** Most people do it by hand, and that is the route we support on the day. This one is for founders who are comfortable with it. You make a Private Integration Token yourself, in your own sub-account, at `Settings`, then `Private Integrations`, ticking the custom values boxes and nothing else.

That token is a password for your whole account, and it keeps working for 90 days. So: keep it out of your Launchhouse folder, never type it into the chat, put it in a plain text file somewhere else and tell Claude where it is, and delete it in GoHighLevel as soon as the values are in. Claude shows you the whole list and waits for your yes before it writes anything.

Your GoHighLevel connector cannot do this part. It reads your account and posts content, and it has no custom values tool, so do not go looking for one.

### Check four things

When the words are in, tell Claude you have finished pasting. If you filled them by hand, Claude cannot see inside your account, so it reads your list back to you one at a time and you check each one on screen:

1. Every value on your two lists is there.
2. None is empty.
3. None still says PLACEHOLDER, and none has a square or curly bracket in it.
4. No name was changed, so the keys your workflows use still match.

If you used the API route, Claude reads all four back out of the account itself.

### Re-pick anything blank

A load can leave a choice inside a step empty. Your snapshot page lists every step to open. Check the pipeline and stage on each card mover, the `Form Is` choice on each form trigger, and the tag under every tag trigger.

Claude cannot see inside your account, so this one is done by eye. Your `ops-workflow.md` names the pipeline your snapshot uses, so ask Claude which stage a step should point at if you are unsure.

### Publish, in the order on your snapshot page

Publish every workflow that is not optional, in the order your snapshot page gives: **the card movers first, then the automations, then the event workflows, then the entry workflows.** Publish one group, check every workflow in it shows as published, then start the next.

Order matters here. A card mover that is still a draft when an automation starts leaves cards sitting in the wrong place.

**Leave `Essentials 13` and `Essentials 14` as drafts** unless you filled the two welcome values. They are optional on both tracks.

**Drafts never run**, so a test before publishing proves nothing, and a published workflow with empty values sends blanks to real people. That is why filling comes first.

### Re-pick what points at another workflow

These wait until now, because a workflow that is still a draft may not appear in the list to pick from. Your snapshot page names each one. Open them, re-pick anything blank, and save.

### One live test

From a second email address of your own, not the one your account sends from. Open your `Enquiry form` link, fill it in with just your first name and that address, and send it.

Within about three minutes the welcome email arrives, opening with your greeting word and your first name, then your words, then your business name and address at the bottom. Read all of it.

On the two Instagram snapshots the trigger is a comment on one of your posts, or a DM, so use a second Instagram account or ask a friend.

- A blank where words should be: that value is still empty.
- Curly brackets in the email: a value was renamed after it was made.
- Nothing at all: the workflow is still a draft.

If something is wrong, put that workflow back to draft, fix it, and test again. Then run the live tests on your own snapshot page: they carry on from this one.

## 4. Before you travel

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
| Claude does not know "fill my custom values" | The plugin has not updated yet. Go back to section 1 |

## Stuck

Post in the Slack channel. Do not wait for the session.
