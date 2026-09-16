# After the engines

Sent before the clinic. This is what happens once your Brain, your content, your second engine and your workflow copy are written, and it ends with a real email arriving in your own inbox.

Read it once now. It takes about half an hour on the day.

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

### Load your snapshot

A snapshot is a pack of ready-built workflows, the one you chose in your ops engine. It arrives as a set of workflows, not as a single one.

We give you the share link on the day.

**Add yourself as a user first, before you load anything.** Go to `Switch to Agency View`, then `Settings`, then `Team`. Open your own user, go to `Roles & Permissions`, and add your business sub-account. Do this first: users never travel in a snapshot, and the alerts inside yours go to the users of the account, so if you are not one you get none of them.

Then open the share link, choose your sub-account, and wait for it to finish processing. It takes a few minutes.

**What arrives:** every workflow, every tag, your pipelines, your forms, and the name of every message slot.

**What does not arrive: your words.** Custom value contents never travel in a snapshot, and neither do users. Every email arrives built, with empty slots where your words go, and an empty slot sends as a blank space to a real person.

### Fill the words

A custom value is a named slot in your account. Your workflows are built to drop your words into those slots, so one welcome email is written once and used everywhere. The snapshot brings you the empty slots, and this is where the words go in.

Say **"fill my custom values"**, or type `/growth-engine:values`.

Claude reads your Brain and your engine files, asks you the few things nothing else answers, writes every message in your voice, and saves them to `ghl-values.md` in your folder.

Both lists come out of the one snapshot you loaded, because every snapshot carries **Essentials** inside it. So you fill **Essentials**, which is 11 values, and the list for the snapshot you chose. Nothing else. Between 11 and 22 in total. Nine of the eleven Essentials values are needed before you publish; the two that welcome a new client or customer are only needed if you switch that pair of workflows on.

If you loaded **Review request**, it has no custom values at all. Its two emails live in your review templates, at `Reputation`, the `Settings` tab, then the email request settings, then `Set Email Templates`. Both templates arrive holding the word PLACEHOLDER and send exactly as they are, so rewrite both before you publish: `Review Ask Email` goes in the `Live` slot and `Review Reminder Email` in the `Retry` slot.

### Put them into your account

**By hand, which is how most people do it.** Switch back to your sub-account first if you are still in Agency View. Open `Settings`, then `Custom Values`. Every name is already there. Open each one, paste the words, save. Around fifteen minutes.

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

A load can leave a choice inside a workflow step empty, most often a pipeline stage. Open each workflow, look for a picker showing nothing, and choose the right one. Claude cannot see inside your account, so this one is done by eye. Your `ops-workflow.md` names the pipeline your snapshot uses, so ask Claude which stage a step should point at if you are unsure.

### Publish, then test

Open `Automation`, then `Workflows`. Your workflows sit in folders and are numbered, `Essentials 1`, `Essentials 2`, and so on. Publish the Essentials folder first, in number order, then your snapshot's folder in number order, by opening each one and moving the switch at the top right from `Draft` to `Publish`. Leave the welcome workflows as drafts unless you filled the two welcome values: that is `Essentials 13`, and on B2B `Essentials 14` as well.

**Drafts never run**, so a test before publishing proves nothing, and a published workflow with empty values sends blanks to real people. That is the reason filling comes first.

Then fire it yourself, the way a real person would. Your `ops-workflow.md` names your trigger. For most people it is their own `Enquiry form`: open it, fill it in using a second email address you can read, and send it. On the two Instagram snapshots the trigger is a comment on one of your posts, or a DM, so use a second Instagram account or ask a friend. Then read what arrives, in full, subject line included.

- A blank where words should be: that value is still empty.
- Curly brackets in the email: a value was renamed after it was made.
- Nothing at all: the workflow is still a draft.

If something is wrong, put it back to draft, fix it, and test again.

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
