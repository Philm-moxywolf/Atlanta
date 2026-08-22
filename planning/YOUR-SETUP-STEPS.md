# Your setup steps

This is the list of things only you can do.
Everything else in the build is blocked behind them, so this is the whole critical path.

Roughly three hours of your time, spread across two sittings, plus a day of snapshot building later.

Write your answers into `planning/spike-findings.md`. That file already has a section waiting for each step, with a blank block to paste into. Delete the word `PENDING` at the top of a section once you have filled it in.

**One rule throughout: never paste a real token into a chat window.** Type it into a masked box, or into a file. If a token ever appears in a conversation, treat it as burned and make a new one.

---

## Sitting one: the probes (30 minutes, no accounts needed)

Do these first. They need no accounts and no payment, and they answer two questions that change how the rest gets built.

### Step 1. Install the test plugin on your Mac

There is a small throwaway plugin already built and waiting. It does nothing except report what your machine supports.

1. Open Claude on your Mac.
2. Install the plugin from this folder: `/Users/pmudh/Documents/GitHub/Atlanta/planning/spike/gate-ab-plugin`
3. It will ask you for two values. Type these exactly, and nothing else:
   - Spike token: `pit-DUMMY-not-real`
   - Spike location id: `loc-DUMMY`
4. Watch what happens when you type the token. **Does the box hide the characters as you type, the way a password field does?** Write down yes or no. That is the whole point of this step.
5. Start a new conversation and type `/gate-ab-probe:spike-check`
6. Copy everything it prints.

### Step 2. Do the same on the Cowork tab, then the Code tab

Same plugin, same two dummy values, same command. Once in each.

Before you type anything each time, look at the very first thing on screen. **Is there a line that says `GATE-B-MARKER mode=hook`?** Write down yes or no for each tab.

### Step 3. Do the same on a Windows machine

This one matters most and cannot be skipped or guessed.

If the machine is Windows Home, it has no Cowork, so use the Code tab. That needs Git for Windows installed first, which is a free download and a two-click install with all the default options.

Then the same plugin, the same dummy values, the same command.

**Paste all of it into `spike-findings.md`, sections S-05 and S-06.**

> **Why this matters.** If the password box appears, founders can type their token into a safe prompt. If it does not, we have to build a different, clunkier route where they edit a file by hand. And if the Windows machine cannot run the little test script, the entire memory and state layer needs a different design. Better to know now than in September.

---

## Sitting two: the accounts (90 minutes)

### Step 4. GoHighLevel

1. Buy the **97 dollar Starter plan**.
2. Create one sub-account to test in. Call it anything, "Launchhouse Test" is fine.
3. Find its **Location ID**: Settings, then Business Profile. Copy it.
4. **Check two things while you are in there, and write down what you find:**
   - Can you get to Settings, then Private Integrations? If that menu is missing, the 97 dollar plan does not include what we need, and that changes the design.
   - Search the automation triggers for anything about an Instagram or Facebook **comment**. Is comment-to-DM available on this plan? This is the B2C engine for about 65 founders.

### Step 5. Make the token

1. Settings, then Private Integrations, then create a new one.
2. Tick **exactly these seven boxes and no others**:

   - `socialplanner/post.readonly`
   - `socialplanner/post.write`
   - `socialplanner/account.readonly`
   - `socialplanner/statistics.readonly`
   - `contacts.readonly`
   - `contacts.write`
   - `locations.readonly`

3. Save it. It shows you the token once. Keep it somewhere safe on your machine.
4. **In `spike-findings.md` write down only the date you made it.** Never the token itself.

### Step 6. Connect a Facebook Page

1. In your test sub-account, go to Social Planner.
2. Connect a Facebook Page. Any page you control.
3. If you have an Instagram Business account linked to that page, connect that too.
4. Write down how many accounts ended up connected.

### Step 7. Apollo

1. Buy a **paid Apollo seat**. Sign up with your work email.
2. That is all for now. The tests come in step 10.

**Fill in section S-01 of `spike-findings.md` with the token date, the seven scopes as the screen showed them, the Location ID, the Apollo plan, and what you found about Private Integrations and comment-to-DM.**

---

## Sitting three: the tests (60 minutes, needs a terminal)

These use your real token, so run them yourself. The token stays in your own terminal and never reaches me.

### Step 8. Check what GoHighLevel offers

Open Terminal and run this, replacing the two bracketed bits with your real values:

```
claude mcp add --transport http ghl-test https://services.leadconnectorhq.com/mcp/ --header "Authorization: Bearer <your token>" --header "locationId: <your location id>"
```

Then ask Claude to list the tools that server offers, and copy the whole list.

**Look for two names in particular** and write down whether each is there:
- `socialmediaposting_create-post`
- Anything for creating or reading contacts

**Paste the list into section S-02.**

### Step 9. Post something, and watch the clock

This is the single most important test in the whole list.

1. Ask Claude to create a **draft** post through that server. Check it appears in the GoHighLevel Social Planner screen.
2. Ask it to create a **scheduled** post for a specific time tomorrow. Pick something memorable like 9:30 in the morning.
3. **Now open Social Planner and look at what time it says.** Does it say 9:30 your time, or some other hour?
4. Write down exactly what you asked for and exactly what the screen showed.

> **Why this matters more than anything else here.** If we get this backwards, every founder's posts go out at the wrong hour. That is 130 people publishing at three in the morning, and we would not find out until it happened.

5. While you are there, download the **CSV template** from the Social Planner bulk upload screen. Save the file exactly as it downloads, without opening or editing it, and tell me where you put it.

**Paste all of it into section S-03.**

### Step 10. Apollo tests

In Claude, connect Apollo (it will walk you through signing in), then:

1. Search for one person. Any search.
2. Save that person as a contact.
3. Create a custom field on contacts called `first_line`. Make it a long text field.
4. Create a test sequence with one email step. Put `{{first_line}}` in it and a line saying they can tell you to stop.
5. Add your test contact to that sequence, sending from your own mailbox.
6. **Check it is sitting there paused and has not sent anything.** Copy whatever proves that.
7. Check that "stop when they reply" is switched on.
8. Delete everything you just made.

**Paste it into section S-07.**

---

## Later: the snapshots (about a day, whenever you have it)

Not urgent this week, but nothing in the operations engine can be finished without it.

In your GoHighLevel agency account, build three workflow snapshots:

| Snapshot | What is in it |
|---|---|
| `b2b-core` | Lead follow-up, discovery booking, proposal chase |
| `b2c-service-core` | Comment to DM capture, DM qualify and book, pre-appointment reminders |
| `b2c-ecom-core` | Comment to DM capture, abandoned checkout chase, post-purchase review |

Every message inside them must be a **custom value**, not typed-in text, so that Claude can write each founder's own words into it. Name them in the pattern `lh_<snapshot>_<message>`.

Test each one by loading it into a clean sub-account, then save the three share links.

### And six screenshots

While you are in those screens, grab pictures of: creating a private integration, the scope list, where the Location ID lives, connecting a Facebook Page, the Social Planner bulk upload screen, and the Plugins install screen in Claude.

They go in the founder instructions, because that token walk is the hardest thing a non-technical person does in this whole programme.

---

## What happens when you are done

The moment sections S-01, S-02, S-03, S-05, S-06 and S-07 have real answers in them, every blocked task opens up and I can build continuously.

## If something does not work

Stop and tell me what you saw, rather than working around it. Several of these steps are questions rather than tasks, and a surprising answer changes the design. That is what they are for.

The three answers that would change things most:

1. **No Private Integrations menu on the 97 dollar plan.** The whole credential design assumes it.
2. **No comment-to-DM on the 97 dollar plan.** That is the B2C operations engine for about 65 founders.
3. **The password box does not appear.** Founders then have to hand-edit a file to enter their token, which is a much rougher path and needs different instructions.
