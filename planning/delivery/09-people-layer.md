## The people layer, per founder

Written 24 August 2026, after the client compared three shapes for the local brain and chose option 2.

This section is additive to sections 00 to 08 in the same way section 08 was, with one exception that is stated up front and argued in part 2: it **withdraws** the `O|` and `D|` row grammars from `ledger.md`.
That is the only thing anywhere in sections 00 to 08 that this section takes away.

Read section 08 first for the managed-block mechanism, and section 02 for the task format this feeds into.

Two working notes sit behind this section and are not part of the plan:
`/Users/pmudh/Documents/GitHub/Atlanta/planning/delivery/09a-prior-art-glitch-people.md`, which reads Glitch's person model field by field,
and `/Users/pmudh/Documents/GitHub/Atlanta/planning/delivery/09b-people-dependency-map.md`, which surveys every place a person is represented in this plan.
Both are cited below where a decision rests on them. Delete both once this section is accepted.

---

## 1. What this is, and why

The growth engine already remembers the founder: their voice, their decisions, their thirty content pieces.
It remembers nothing at all about the twenty five people they are about to sell to, beyond a status letter in a machine file.
This section gives every prospect and every direct message target one file, keyed on their identifier, holding what the founder was told or shown about them and nothing else.
Afterwards a founder can ask "who is Sofia, why did I pick her, what have I sent her, and what did she say back" and get an answer from one file, which today needs two files, two commands and a memory of a Saturday five weeks ago.
It is also the last cheap moment to do it: line-oriented person files are the exact input a future projector would read into typed rows, so this is the first half of option 3 rather than something option 3 would have to delete.

---

## 2. Authoritative versus derived: the decision

### The decision

**The person file is the only home for a fact about a person. Nothing about a person is derived onto disk anywhere else.**

`growth-engine/people/<slug>.md`, one file per person, sole writer `ge person`.

The `O|` and `D|` row grammars are **retired** from `ledger.md`.
They are not duplicated there and they are not rebuilt into it.
`ledger.md` becomes content only, keeps its single writer `ge ledger`, and keeps the `C|` grammar unchanged.

### The lead proposal is rejected

The proposal put to me was that the person file becomes authoritative and the `O|` and `D|` rows become derived, rebuilt by `ge index` in the way `.state/index.md` is already derived and rebuildable.

Reject it. Four reasons, worst first. The first two are structural and the plan cannot absorb either.

**One. It puts two writers on `ledger.md`, and one writer per file is the rule that carries the rest of the design.**
`ge ledger` is the sole writer today.
Under the proposal `ge index` writes it too, because it rebuilds rows into it.
Section 03's check V-12 reads a declared map at `plugins/growth-engine/schemas/writers.md`, one row per founder file, and prints `TWOWRITERS` when two owners claim one file.
`ledger.md` would need two declared owners, which turns that check from a gate into a comment.
Section 07's state model at line 282 draws `ledger.md   one writer: ge ledger` in a diagram whose entire point is that each line has exactly one owner.

**Two. `ge index` is the wrong owner, twice.**
Section 02 line 141 puts `ge index` at the end of the standard write chain, so it runs after every skill on every founder machine many times a session.
Every one of those runs would mutate `ledger.md`, so every one of them must snapshot it first.
The snapshot ring is 10 per file, from task `B-03`.
Ten index rebuilds evict every real mutation snapshot, and `ge undo` on the ledger stops meaning anything.
Separately, section 07's simplification `S-08c` is marked ADOPT and makes `ge index` print to stdout by default, writing a file only on `ge index --write`.
A stdout-only index cannot rebuild persisted rows. The proposal and `S-08c` cannot both be true.

**Three. Derivation gives the fact two homes anyway, and the second home is the one every check reads.**
Nine consumers grep `^O|` or `^D|` out of `ledger.md`: the acceptance blocks of `A-01`, `AB-01` and `A-02`, gate items B7, C4 and C13, the `status` skill, the `gate` command, and `ge lint`'s row checks.
If the rebuild has not run since the last person write, all nine read the previous state and report it as fact.
Nothing anywhere prints "these rows are derived and may be stale".
A founder who marks a prospect `stopped` and then submits a gate has a gate that says `enrolled`, with no failure, no warning and no arrow.
That is the failure class that produced the 47 regressions, industrialised.

**Four. It is a worse stepping stone, not a better one.**
Option 3's projector reads line-oriented person files into typed rows.
A derived pipe-delimited roster inside `ledger.md` is a second grammar the projector would have to learn and then delete.

### What about the prior art, which endorses exactly this shape

Glitch does run the shape the proposal describes, in production, against a real estate of notes: the markdown note is truth, a deterministic projector lints and projects each note into typed rows, and a malformed note is flagged and skipped rather than allowed to corrupt the derived store.

The projection is worth its cost there because the derived store is a database that answers questions grep cannot: joins across five tables, full text search, ranked entity resolution.
Here the derived store would be twenty five pipe-delimited lines inside a file that already has an owner.
One `sed` pass over the header of each person file, sorted and counted, is the complete reporting engine at this scale, and it reads the truth rather than a copy of it.
Part 4 gives the exact loop, including the two lines that make it safe on a folder with no people in it yet.
So the projection buys nothing and costs a second writer, a staleness class and a snapshot ring.

What does port from the prior art, and is adopted in full below, is the discipline that sits around the projector rather than the projector itself:

1. Lint before use, never after. Anything that reads a person file validates it before acting on it.
2. A malformed file is reported and named, never silently absent from a count.
3. One broken file never stops the other twenty four working.
4. Nothing a reader can compute is ever hand-written into the file.

### What else was rejected

**The middle path: notes in the person file, status stays in the ledger.**
No fact is duplicated, and it costs about 12 plan edits instead of about 40.
Rejected because it does not close the gap it was asked to close.
"Tell me about Sofia" still needs two files and two commands, and the person key and the ledger key can drift with only a lint to catch it.

**Keeping `O|` and `D|` alongside the person files, un-derived, as they are today.**
Rejected outright. That is two writers for one fact with no reconciliation at all, which is how a founder ends up with two contradictory statuses for one prospect.

**Unifying the two status enums.**
Rejected. `candidate|cut|contacted_ok|enrolled|replied|stopped` and `target|opener_written|sent|replied|booked|no_reply` are consumed in six places between them and read by nine gate items.
Unifying them looks tidy and silently changes the meaning of all of it. Two enums selected by one `kind:` field is the smaller change and the honest one.

### Why retirement rather than quiet coexistence

Every un-migrated consumer fails loudly on the day the change lands, in the executor's own terminal.
`grep -c '^O|' growth-engine/ledger.md` returns 0 where the acceptance block says it must return 25.
A derived roster returns 25 and keeps returning 25 long after the underlying facts have moved.

There is no installed base to migrate.
Section 01 records the single most important fact about this repository: nothing has ever been executed end to end, by anyone, on any track.
No founder has an `O|` row. The only files carrying them are test run folders, which are regenerated rather than migrated.
So retirement costs one sweep of the plan and no migration code at all.

---

## 3. The file

### Path and naming

```
growth-engine/
├── .gitignore         written by ge init, excludes people/ and .state/
├── ledger.md          one writer: ge ledger, C| rows only
├── ops-log.md         one writer: ge log, append only
├── memory.md          one writer: ge remember
├── people/            one writer: ge person
│   ├── README.md
│   ├── sofia-mendes-brightops-co-uk.md
│   ├── ig-carla-b-pt.md
│   └── ig-nadia-restores.md
└── .state/            derived, rebuildable
```

`people/` is seeded by `ge init` with a `README.md` inside it, and nothing else.
The seed file is not decoration: `B-02`'s acceptance fixture is `find growth-engine -type f | sort`, which does not list directories, so without a file inside it the seeding step is untested by its own acceptance.

**The seed file is `README.md`, not `.gitkeep`.**
A `.gitkeep` is a git-flavoured marker whose only meaning is "commit this empty directory", placed in the one folder in the whole toolkit that must never be committed anywhere.
It also does not show up in `ls`, which breaks any count written against the folder.
`README.md` carries two sentences a founder can read:

```
This folder holds real people's names, companies, titles and contact details.
It is not for sharing, not for syncing and not for committing.
```

### The folder holds real people, so it stays on the founder's machine

This is the exposure the layer creates, and it is on the founder's own machine rather than in the public repository.
Twenty five to thirty five files of real names, companies, job titles and email addresses, well formed and machine readable, sitting in whatever folder the founder opened Claude Code in.

On current Windows, `Documents` and `Desktop` are OneDrive-backed by default.
A founder who works there has every person file replicating to a consumer cloud account without ever choosing that.
iCloud Drive, Dropbox and Google Drive do the same on the folders they cover.
Many founders will also have their working folder inside a git repository of their own.

Three things follow, and all three are built rather than advised:

1. `ge init` writes `growth-engine/.gitignore` containing `people/` and `.state/`, with a comment line saying why. A founder whose working folder is already a git repository does not commit people by accident.
2. The first time `ge person add` creates a file in a `people/` folder that held only the seed file, it prints one extra line: this folder now holds real people's details, keep it out of shared drives and out of git. Once only, on the first person, so it is read rather than skipped.
3. `docs/USING-IT.md` names OneDrive, iCloud Drive, Dropbox and Google Drive by name and says to move the working folder if it sits inside one.

The `.gitignore` covers the founder's own repository. It does nothing about a cloud-synced folder, which is why the printed line and the document paragraph exist as well.

**No person identifier ever reaches `ops-log.md`.**
The standard write chain at `02:141` runs `ge log` after a write, and `ops-log.md` is append only, so anything written there survives every deletion path this layer has.
So `ge person` writes the slug and the verb into it and nothing else. Never a name, never a company, never a job title, never an address, never a handle, never a note.
Say plainly what that does and does not buy. The slug is derived from the identifier, so a log line still points at a person. It carries none of the twelve other facts the person file holds, and that is the difference between a line of history and a copy of the record.
`ge person purge` destroys the person file and its snapshots. The slug in `ops-log.md` is the one thing it leaves, and that is stated where the founder can read it rather than discovered later.
`V-16` gains this as a leg in part 11, so it is enforced rather than intended.

### The key, and why the key is not the name

**The key is the identifier, never the name.**
Both routes have a strong identifier by construction. Apollo hands over an email. The twenty five B2C targets are chosen by handle, by hand, by a founder looking at the account.
There is no name-only ingest path anywhere in either route, which is why none of the entity resolution machinery in part 8 is needed.

| kind | key form | example |
|---|---|---|
| `prospect` | the email address, lowercased | `sofia.mendes@brightops.co.uk` |
| `target` | `<platform>:<handle>`, both lowercased, any leading `@` stripped | `ig:carla.b.pt` |

Normalisation happens once, at write, and the normalised form is what gets stored.
Lowercase the whole email. Strip a leading `@` from a handle, then lowercase it.
Two `tr` calls, and it is the only collision this audience will actually hit: without it, `Sofia@BrightOps.co.uk` and `sofia@brightops.co.uk` become two people.

### The slug, and the filename

The filename is `<slug>.md` where the slug is derived from the key by one deterministic rule:

1. lowercase
2. replace every character outside `a-z0-9` with `-`
3. squeeze runs of `-` to one
4. strip a leading or trailing `-`
5. truncate to 60 characters, then strip a trailing `-` again

So `sofia.mendes@brightops.co.uk` becomes `sofia-mendes-brightops-co-uk`, and `ig:carla.b.pt` becomes `ig-carla-b-pt`.

Three properties this buys, and each is the reason for a rule elsewhere:

- The slug is derived from the key by that rule alone, so any code that has the key can find the file by deriving and probing, with no lookup table anywhere. The probe is spelled out under slug collisions below.
- Two people with the same name never collide, because the name is not in the key. Two Sam Carters at two companies are two emails and two files.
- The same person cannot be added twice, because the second `ge person add` finds the file already there.

**Every verb that takes `<slug>` also takes the key.**
`ge person set sofia.mendes@brightops.co.uk status contacted_ok` and `ge person set sofia-mendes-brightops-co-uk status contacted_ok` are the same command.
An argument containing `@` or `:` is treated as a key, normalised, and resolved by the derive-and-probe rule below. Anything else is treated as a slug and used as the filename directly.
That is one derivation and at most nine `test -f` calls, with no lookup table and no index, and it is what lets the founder-facing documents stop saying the word slug.
Founders copy an email address out of a CSV or a handle off a screen. Nobody types a 28 character slug twenty five times.

**The key is immutable once written.**
If the email turns out to be wrong, `ge person set <slug> email <new>` changes the address that gets used and leaves `key:` and the filename alone.
That is why `key:` and `email:` are two fields rather than one: `key:` is the identifier this person was created under, `email:` is the address the founder sends to today.
They usually hold the same string and they are not the same fact.
Renaming files on a corrected address would break every pointer the founder has written down, for no gain at twenty five people.

**Slug collisions, resolved one way.**

There is no `--slug` flag. There never was one that worked.
A founder-chosen filename is by definition not the derived slug, so every file created that way is malformed forever under `BADNAME`, `ge person export` refuses while it exists, and no code holding the key can find it. That escape was a trap and it is removed from the specification, from `ge person add` and from the refusal text.

The rule instead:

1. `ge person add` derives the slug from the normalised key.
2. If `<slug>.md` does not exist, that is the file.
3. If `<slug>.md` exists and its `key:` is the same string, this person is already there. `add` refuses, exit 1, with the path.
4. If `<slug>.md` exists and its `key:` is a different string, `ge` moves to `<slug>-2.md`, then `<slug>-3.md`, and so on to `<slug>-9.md`, taking the first name that either does not exist or holds this exact key.
5. If all nine are taken by other keys, `add` refuses, exit 1, naming every key it found and asking the founder to look, because ten different identifiers deriving one slug is not a data problem the toolkit should paper over.

A disambiguated file is announced, never silent:

```
added people/sofia-mendes-brightops-co-uk-2.md  prospect  candidate  sofia-mendes@brightops.co.uk
  note: sofia-mendes-brightops-co-uk.md is already held by sofia.mendes@brightops.co.uk
```

**Finding a file from a key is the same rule read backwards.**
Derive the slug, then read `key:` from `<slug>.md`, `<slug>-2.md` and so on to `<slug>-9.md`, stopping at the first file whose key matches. No match in nine is "no such person", exit 2.
This is the derive-and-probe rule the properties above refer to. It is deterministic, it needs no lookup table, and it survives the collision case rather than breaking on it.

`BADNAME` is defined against exactly this rule in part 4: a filename that is neither `<derived>.md` nor `<derived>-N.md` for an integer `N` from 2 to 9.
A key collision is still a refusal, never a merge. A slug collision between two different keys is disambiguated deterministically and printed, because refusing there would leave a legitimate second person with nowhere to live.

### The header

Everything above the first line beginning `## ` is the header.
A header line is a field if it matches `^[a-z][a-z0-9_]*: ` exactly, that is a lower case name, a colon, one space.
Any other header line must be blank, or begin `#`, or begin `<!--`. Anything else is malformed. See part 4.

**REQUIRED, every person**

| field | value | notes |
|---|---|---|
| `key` | the normalised identifier | immutable, the filename is derived from it |
| `kind` | `prospect` or `target` | selects which `status` enum applies |
| `name` | free text, one line | display name as the founder or Apollo gave it |
| `status` | see the enums below | validated against the enum for this `kind` |
| `source` | `manual`, `apollo`, `import`, `form` | where this person came from. A person with no source is a person nobody can account for |
| `created` | `YYYY-MM-DD` | one `date -u` call at add time |

**REQUIRED when `kind: prospect`**

| field | value |
|---|---|
| `email` | the address in use, lowercased |

**REQUIRED when `kind: target`**

| field | value |
|---|---|
| `platform` | `ig`, `fb`, `other` |
| `handle` | lowercased, no leading `@` |
| `platform_label` | required **only** when `platform: other`. Free text, one line, naming the real platform |

**The platform vocabulary is decided here, and it is three values.**
`09a-prior-art-glitch-people.md` flags the conflict: the retired `D|` row allowed `ig|fb|other`, and the prior art carries eight platforms including `linkedin`, `x` and `whatsapp`.
Taking the eight would make `ge index` either downgrade a real platform to `other` and lose a fact, or refuse a valid person file and make it unindexable.

Settled: **the person file carries `ig`, `fb` or `other`, and B2C is documented as an Instagram and Facebook motion, which is what it already is.**
`platform: other` plus `platform_label` is the escape, and it keeps the fact rather than losing it: `platform: other` with `platform_label: LinkedIn` is one enum value and one readable label, not a ninth enum value that six consumers have to learn.
The `D|` row is retired by this section, so it is not a second vocabulary to reconcile.
The remaining consumers are `ge person list --platform`, `ge index`'s directory row, which carries no platform at all, and section 05's route definitions, which already say Instagram and Facebook.
No amendment to section 05's platform vocabulary is needed, and none is made.

**OPTIONAL, any person**

| field | value | notes |
|---|---|---|
| `first_name` | free text, one line | the merge value. When absent, an export derives one from `name` by the fallback rule below and reports the count on stdout |
| `company` | free text, one line | |
| `title` | free text, one line | job title as Apollo returned it |
| `email_status` | `unverified`, `valid`, `risky`, `bounced` | **UNVERIFIED MAPPING.** Our own four values. Which Apollo field they are read from is unknown until spike `S-07` lands, and must not be invented before then. Until `S-07`, `ge person set <slug> email_status` **refuses** anything but `unverified`, in the code and not only in the plan, and the refusal names `S-07` as the reason |
| `found_via` | free text, one line | the Apollo search that produced them, or the hashtag, account or post where the founder found them |
| `why_them` | free text, one line | the one specific observed reason. Supplied or observed, never inferred |
| `link` | a URL | may repeat, zero or more times. The only repeatable field |
| `priority` | `1`, `2`, `3` | the founder's own ordering for who gets messaged first. Never set by `ge`. A person with no `priority` sorts as if `priority: 3`, after every explicitly ranked person |
| `follow_up_on` | `YYYY-MM-DD` | one date, no cadence arithmetic |
| `ghl_contact_id` | the id GoHighLevel returned | written only when an API returned it |
| `apollo_contact_id` | the id Apollo returned | written only when an API returned it |

The two id fields exist for one reason, and it is a hard constraint rather than a convenience.
A person file never claims that a local record and a remote record are the same person unless something returned an id that says so.
Without these fields a skill eventually reconciles a GoHighLevel contact with a person file by inference, which is a fact about a person that nobody supplied, and it will look like helpfulness rather than like a breach.

### `priority` is the one ported field on probation

`09a-prior-art-glitch-people.md` recommends keeping Glitch's `tier` as an optional `priority` of 1 to 3, for ordering who gets messaged first.
It is also the one field on that keep list a founder could plausibly leave empty on all twenty five rows, which would make it dead weight.

Settled: **`priority` ships, optional, 1 to 3, never set by `ge`, and it is measured in the two demo-founder runs before v1.0.0 freezes.**
Two things make it cheap enough to keep even if founders ignore it.
It has a defined meaning when absent, so nothing branches on its presence: an unset `priority` sorts as 3 and the export is still deterministic.
And it is the sort key for `ge person export openers`, which is the printed sheet a B2C founder works down on the Saturday, so an empty field costs nothing and a filled one buys the running order.

The test is in `PPL-05`'s two dry runs. If both demo founders leave it empty on all twenty five, it goes in the v1.1 cut list, not in v1.0.

### The `first_name` fallback

When `first_name` is absent, an export derives one from `name`:

1. take the first whitespace-separated token
2. strip a trailing comma
3. strip a trailing period

`Sofia Mendes` gives `Sofia`. `O'Brien-Smith, Siobhan` gives `O'Brien-Smith` rather than `O'Brien-Smith,`, which would have produced `Hi O'Brien-Smith,,` in a cold email.

Two shapes the fallback still cannot fix, because guessing at them would be worse.
`Dr Ravi Menon` gives `Dr`. `MENDES Sofia` gives `MENDES`.
So the fallback is made visible rather than trusted: `ge lint` warns, warn-only, for every person with no `first_name` whose derived fallback is not a plain alphabetic word of two or more characters, with the recovery `ge person set <key> first_name "<name>"`.
The founder fixes six of twenty five in a minute, and the other nineteen were right.

The count of rows that fell back is printed to stdout by the export. It is never written into the CSV, because a comment line in the header breaks the Apollo import.

### Person-shaped data in documentation and examples

Every person example in `schemas/person.md`, in `docs/USING-IT.md`, in `docs/TROUBLESHOOTING.md` and in any other file under `plugins/` uses a reserved documentation domain: `example.com`, `example.org` or `example.net`, and an obviously invented handle.

The three worked examples below are the shape, not the text.
This planning section is not under `plugins/` and is not scanned, but its examples are what an executor will copy, so the substitution is written out once here rather than left to be remembered:

| in this section | in the repository |
|---|---|
| `sofia.mendes@brightops.co.uk` | `sofia.mendes@example.com` |
| `https://brightops.co.uk/about` | `https://example.com/about` |
| `ig:carla.b.pt`, `https://instagram.com/carla.b.pt` | `ig:carla.example`, `https://example.com/carla.example` |
| `ig:nadia.restores`, `https://instagram.com/nadia.restores` | `ig:nadia.example`, `https://example.com/nadia.example` |

Company names, job titles, observed reasons and opener text carry across unchanged. They are invented already and no check looks at them.
Slugs derive from the substituted keys, so `sofia-mendes-example-com` is the filename in the repository copy.

That is not a style preference. It is what makes check `V-25` in part 11 implementable: the check can permit a documented person file and still fail a real one, because a real one carries a real domain.
A file list exclusion cannot do that, because the two founder-facing documents most likely to be copy-pasted from are exactly the two that need a worked header.

### The two status enums, unchanged

```
kind: prospect   status: candidate | cut | contacted_ok | enrolled | replied | stopped
kind: target     status: target | opener_written | sent | replied | booked | no_reply
```

Both are lifted verbatim from `schemas/ledger.md`, including the justification paragraph for why the second exists, which moves into `schemas/person.md` because it is the record of why there are two.

**`booked` covers any positive commitment, including an order.**
The target enum was written for a service motion, where the outcome is a booked call.
The b2c-ecom route's outcome is a visit, a code used or an order, and read narrowly the enum would strand every ecom founder's twenty five targets at `replied`.

A seventh value, `converted`, was considered and rejected.
Cluster C-3 keeps both enums moving to `schemas/person.md` unchanged, because they are consumed in six places and read by nine gate items, and adding a value means editing five consumers to gain a synonym.
So the enum does not change and the meaning is written down instead: `schemas/person.md` says in one sentence that `booked` means any positive commitment the target made, a booked call for a service founder and an order or a used code for an ecom founder.
An ecom founder then knows where to land, and gate item C4 counts the same thing on both routes.

`stopped` is deliberately absent from the target enum.
A B2B prospect who asks to stop must come out of a running Apollo sequence, so there is something to stop.
A B2C target gets one message, sent by hand, with no follow-up, so there is nothing to stop and a second field naming it would be a second status axis on the same person.

There is no `attention` field and no `do_not_contact` field, for the same reason.
The two states a founder actually confuses at twenty five prospects are "they replied and I owe them" and "I replied and I am waiting".
Both are `status: replied` plus the direction on the newest line of the touch log, which is derived, free, and cannot disagree with itself.

**A separate do-not-contact flag is decided against, and here is the whole path it would have covered.**
The question is fair: a person who asks not to be contacted is the one case where a second axis looks justified.

Settled: **no second field. `status` carries it, and the three cases are named so nobody has to guess.**

| what happened | where it lands | why |
|---|---|---|
| a prospect asks to stop | `status: stopped`, plus a note carrying what they said | The value already exists. A B2B prospect is inside a running Apollo sequence, so there is something to stop, and `stopped` is the instruction to stop it |
| a target asks not to be messaged again | `status: no_reply`, plus a note carrying what they said | A target gets one message, by hand, with no follow-up. There is nothing running to stop. `no_reply` is already the terminal state that means do not send again |
| a person asks to be deleted | `ge person purge`, in part 5 | A flag is not deletion. A person who asks to be removed gets removed, file and snapshots |

A second field would be the exact duplication trap the brief warns about: two axes on one person, no reconciliation, and a founder who reads one while a gate reads the other.
The three cases above cover every request a founder will actually receive, and each one is a status the enums already carry.

### The body

Three managed blocks, using the mechanism section 08 specifies and `lib/blocks.sh` from task `B-10`.
`ge` writes only between the markers. Everything outside every marker pair belongs to the founder.
A start marker with no end marker means the file is refused, not guessed at.

**Markers are matched byte-exactly after one trailing carriage return is stripped.**
Section 08 at line 120 says byte-exact and stops there. That is right for `memory.md` and wrong for person files, which are the files a founder is most likely to open in Notepad.
A founder who saves a person file in a Windows editor turns every marker line into a non-match, every block write into a `HALFMARKED` refusal, and every person into a file `ge` will not touch.
So the carriage-return rule in part 4 applies to marker lines exactly as it applies to field lines: strip one trailing `\r`, then compare byte for byte.
Nothing else is tolerated. A marker with a leading space, a changed comment or a different case is still a non-match, because guessing at a marker is how a block write lands in the wrong place.

| heading | block | written by | line format |
|---|---|---|---|
| `## Touch log` | `GE:TOUCH` | `ge person touch` | `- YYYY-MM-DD <channel> <direction>: <text>` |
| `## Opener` | `GE:OPENER` | `ge person opener` | free text. One line for a prospect, any number of lines for a target |
| `## Notes` | `GE:NOTES` | `ge person note` | `- YYYY-MM-DD <text> (source: <where>)` |

`channel` is `email`, `dm`, `call`, `form` or `other`. `direction` is `in` or `out`.
Two words on a whitespace-sliceable line, and they are the whole derivation of last contacted, last direction, and whether the founder owes a reply.

The `## Yours` heading sits below the last block and carries one sentence: anything below it is the founder's and `ge` never writes there.
`ge` never writes there **and never parses there**. That is the rule stated in full in part 4, and it is what makes the sentence true rather than aspirational.
A founder's own paragraph under `## Yours`, with colons in it, bullets in it and blank lines in it, leaves the file valid and every verb working.

**Nothing derived is ever written into the file.**
No `last_contacted:`, no `last_direction:`, no `has_opener:`, no touch count.
Each of those is one `awk` pass over the touch block, and a field holding a copy of it is a fact with two homes and no reconciliation.

**The file points, it does not hold.**
The opener block holds the message because the message is a fact about that person.
The reply thread, the sequence body and the search results live in their own files, and a note line points at them.
A person file a founder can read in ten seconds is one they will keep current.

### Worked example one: a B2B prospect from Apollo

`growth-engine/people/sofia-mendes-brightops-co-uk.md`

```markdown
<!-- Written by ge person. The fields and the marked blocks are ge's. Everything under ## Yours is yours. -->
key: sofia.mendes@brightops.co.uk
kind: prospect
name: Sofia Mendes
status: enrolled
source: apollo
created: 2026-09-14
email: sofia.mendes@brightops.co.uk
email_status: unverified
first_name: Sofia
company: BrightOps Facilities
title: Operations Director
found_via: apollo search 2, facilities management, 20 to 50 staff, South West
why_them: the site lists three depots and no operations manager
link: https://brightops.co.uk/about
priority: 2
apollo_contact_id: 6612f0a9c4

## Touch log
<!-- GE:TOUCH:START -->
- 2026-09-16 email out: sequence touch 1, enrolled paused then activated by hand
<!-- GE:TOUCH:END -->

## Opener
<!-- GE:OPENER:START -->
Three depots and no ops manager listed is usually a sign one person is holding all of it.
<!-- GE:OPENER:END -->

## Notes
<!-- GE:NOTES:START -->
- 2026-09-14 Site lists three depots and no operations manager (source: brightops.co.uk/about, read 2026-09-14)
- 2026-09-14 Kept in the 25 because the depot count matches the ICP exactly (source: founder, during the cut)
<!-- GE:NOTES:END -->

## Yours
Anything below this heading is yours. ge never writes here.
```

### Worked example two: a B2C service target

`growth-engine/people/ig-carla-b-pt.md`

```markdown
<!-- Written by ge person. The fields and the marked blocks are ge's. Everything under ## Yours is yours. -->
key: ig:carla.b.pt
kind: target
name: Carla Bruno
status: sent
source: manual
created: 2026-09-19
platform: ig
handle: carla.b.pt
found_via: hashtag bristolpt, her post of 2026-09-17
why_them: posts most weeks about clients cancelling on Mondays
link: https://instagram.com/carla.b.pt
priority: 1

## Touch log
<!-- GE:TOUCH:START -->
- 2026-09-26 dm out: opener sent by hand, 11:20, fourth of the day
<!-- GE:TOUCH:END -->

## Opener
<!-- GE:OPENER:START -->
Saw your Monday cancellations post. I run the same problem for three studios here.
The thing that moved it for them was not a reminder, it was moving the payment.
Happy to send you what they changed if it is useful.
<!-- GE:OPENER:END -->

## Notes
<!-- GE:NOTES:START -->
- 2026-09-19 Three posts about Monday cancellations in five weeks (source: her feed, read 2026-09-19)
<!-- GE:NOTES:END -->

## Yours
Anything below this heading is yours. ge never writes here.
```

Note the key. `ig:carla.b.pt` contains a colon and parses correctly, because only the first `: ` on a line splits the field from its value. That is the delimiter rule in part 4, demonstrated.

### Worked example three: a B2C ecommerce target

`growth-engine/people/ig-nadia-restores.md`

```markdown
<!-- Written by ge person. The fields and the marked blocks are ge's. Everything under ## Yours is yours. -->
key: ig:nadia.restores
kind: target
name: Nadia
status: opener_written
source: manual
created: 2026-09-19
platform: ig
handle: nadia.restores
found_via: commented twice on the vintage-hardware maker we do not imitate
why_them: restores mid-century sideboards and photographs the hinges she replaces
link: https://instagram.com/nadia.restores
priority: 2
follow_up_on: 2026-10-05

## Touch log
<!-- GE:TOUCH:START -->
<!-- GE:TOUCH:END -->

## Opener
<!-- GE:OPENER:START -->
The hinge shots are the reason I follow you. Most people photograph the finished top.
We make the brass ones in the third photo of your Tuesday post.
No pitch, I just wanted to say the close-ups are doing something the rest of the category is not.
<!-- GE:OPENER:END -->

## Notes
<!-- GE:NOTES:START -->
- 2026-09-19 Found through a competitor's comment section, and the competitor's voice is not the model for this opener (source: founder, during targeting)
<!-- GE:NOTES:END -->

## Yours
Anything below this heading is yours. ge never writes here.
```

---

## 4. The parsing rules

There is no `jq`, no `python` and no `node` on any founder path, so every rule below has to hold with `sed`, `awk`, `grep`, `tr` and shell built-ins under Git Bash on Windows Home.

### Where parsing stops, stated once and relied on everywhere

**Every parse of a person file stops at the first line matching `^## `.**

Everything above that line is the header, and it is the only region any validation looks at.
Everything from that line down is body: three managed blocks, whose contents `ge` reads only between their own markers, and the `## Yours` region, which `ge` never reads for any purpose at all.

Concretely, and this is the rule the rest of the section depends on:

- `BADLINE`, `MISSING`, `UNKNOWN`, `DUPFIELD`, `EMPTY`, `BADENUM` and `BADKIND` are evaluated **only** over lines above the first `^## ` line. No line at or below it can produce any of them.
- Field reads are the same. `sed -n 's/^status: //p'` over a whole file is wrong, because a founder can type `status: still thinking` under `## Yours` and a target opener can contain a line that looks like a field. Every field read stops at the first `^## ` line. The pattern is in **Reading, in practice** below.
- `BADTOUCH`, `SHREDDED`, `BADBLOCKLINE` and `HALFMARKED` are body conditions, and each is evaluated only inside the marker pair it names. None of them looks below the `## Yours` heading either.
- Nothing under `## Yours` is ever a field, a fault, a count or a row. A founder's own two paragraphs of thinking, with colons, bullets and blank lines in them, leave the file valid and every verb working.

This is the promise printed at the top of every person file and it has to be true in the parser, not only in the sentence.
A founder who types their own note under `## Yours` and then cannot run `ge person export openers`, with the refusal naming their note as the fault, is the single most likely event-day breakage this layer could ship.

### The locale

**Every `sort` and every `uniq` inside `ge` runs under `LC_ALL=C`.** It is set once, at the top of `ge.sh`, and inherited by everything.

Without it, sort order depends on the founder's locale, and the golden expectations in part 11 are byte-exact.
An expectation committed from the executor's macOS would not match a founder's Git Bash under a different locale, and Git Bash on Windows Home is the platform this plan says sets the floor.
`LC_ALL=C` also makes `[a-z]` mean what the slug rule assumes it means.

### The delimiter

A header field is `<name>: <value>`, split on the **first** occurrence of `: ` in the line and no other.

```sh
# name and value, POSIX, no arrays and no bashisms
name=${line%%:*}
value=${line#*: }
```

**A value may contain the delimiter.** `key: ig:carla.b.pt` gives name `key` and value `ig:carla.b.pt`.
`found_via: apollo search 2: south west` gives value `apollo search 2: south west`.
No escaping, no quoting, and nothing for a founder to get wrong, because the split point is fixed at the first separator rather than at every one.

**A value may not contain a newline.** Header values are one line. Anything that needs more than one line is a note line or the opener block.

**A value may not be empty.** `company: ` with nothing after it is malformed, not an empty company. A field the founder does not have is a field that is not in the file.

**Field names are lower case, `a-z0-9_`, starting with a letter.** `ge person set` refuses any name outside the declared list. It never writes an unknown field through and never drops it silently, because a typo'd field name is a fact that quietly never lands.

**Every field appears at most once, except `link`.** A second `status:` line is malformed. It is never resolved as last wins, because last wins is how a founder ends up looking at one status while `ge` reads another.

### Carriage returns

Every `ge` subcommand strips one trailing carriage return before parsing any line of any founder file, per section 08.

```sh
CR=$(printf '\r')
line=${line%"$CR"}
```

Not `${line%$'\r'}`, which is a bashism and fails on the founder floor.
A carriage return in a person file must never turn `status: sent` into an unknown enum, and it must never hide a block marker.
A Windows editor will eventually save one, and person files are the files a founder is most likely to open in Notepad.

Writing is always LF, on every platform.

### Multi-line content

Only inside `GE:OPENER`, and only for `kind: target`.

For `kind: prospect` the opener becomes a merge-field cell in `outreach-firstlines.csv`, so `ge person opener` refuses more than one line on a prospect, names the line count it found, and exits 1.
That refusal happens at write time rather than at export time, because the export is the wrong place to discover it.

Nothing anywhere reads a wrapped or continued header line. There is no continuation syntax and none is coming.

### Enumerating the folder, the one sanctioned pattern

**Never `growth-engine/people/*.md` bare.**

On a fresh install the folder holds the seed `README.md` and no person files, so the glob matches nothing, the shell passes the literal string `growth-engine/people/*.md` through, and the founder sees `No such file or directory`.
That is the state of every one of the 130 machines from install day until they run engine 2, which is most of the three weeks before the event.

The pattern, used by `ge person list`, `ge person export`, `ge lint`, `ge check`, `ge index` and every recipe in this section:

```sh
for f in growth-engine/people/*.md; do
  [ -e "$f" ] || break                              # the glob did not expand: no people yet
  case ${f##*/} in README.md) continue ;; esac      # the seed file is not a person
  # ... work on "$f" ...
done
```

Two lines, and they are not optional.
`[ -e "$f" ] || break` is what makes an empty folder a zero count rather than an error.
The `README.md` skip is what stops the seed file being reported as a malformed person, and it is the only file in `people/` that is not a person.

`ge person list`, `ge check`'s person leg and `ge index`'s directory row on an empty `people/` all print a zero count and **exit 0**.
An empty folder is the normal first state, not a fault.

### Reading, in practice

Every read stops at the first `^## ` line, per the rule at the top of this part.

```sh
# one field, header only
status=$(sed -n '/^## /q; s/^status: //p' "$f" | tr -d '\r' | head -1)

# every person with a status, counted, header only, empty folder safe
for f in growth-engine/people/*.md; do
  [ -e "$f" ] || break
  case ${f##*/} in README.md) continue ;; esac
  sed -n '/^## /q; /^status: /p' "$f" | tr -d '\r'
done | LC_ALL=C sort | LC_ALL=C uniq -c

# newest touch line, and its direction
last=$(sed -n '/GE:TOUCH:START/,/GE:TOUCH:END/p' "$f" | grep '^- ' | tr -d '\r' | tail -1)
dir=$(printf '%s' "$last" | awk '{print $4}' | tr -d ':')
```

The `sed -n '/^## /q; ...'` prefix is the whole of the header-only rule in practice, and it is why a founder's `status: still thinking` under `## Yours` is prose rather than a second status.
A plain `grep -h '^status: ' growth-engine/people/*.md` reads the whole file and breaks on both counts, the empty folder and the founder's own text. It does not appear anywhere in this plan.

That is the whole reporting engine. At twenty five files it is instant, and it reads the truth rather than a copy of it.

### Writing

1. `ge snapshot people/<slug>.md`. If the snapshot fails, the write does not happen.
2. Write the new content to a temporary file **in `people/`**, not in `/tmp`, so the move is on one filesystem.
3. `mv` it into place, which is atomic enough that a failure halfway through never leaves a half-written person file.
4. Print what changed, one line, naming the file.

**Snapshotting a target that does not exist is a success and a no-op.**

`ge snapshot <file>` on a path with no file there prints nothing, copies nothing and exits 0.
Without that sentence the fail-closed rule at step 1 makes the first run of two commands fail on every founder machine, for a problem that is not a problem:

- `ge person export firstlines` snapshots `growth-engine/outreach-firstlines.csv`, which does not exist until the first export writes it. Step 8 of `outreach-b2b` would fail on all 65 B2B machines, with a recovery line telling the founder to fix a snapshot they never had.
- `ge person opener` on a freshly added person is the same shape wherever a write target is created rather than replaced.

`B-03` at `02:707` defines `ge snapshot` as a byte copy that exits 1 with a recovery when the copy cannot be made, and a missing source reads as exactly that case.
**It needs a one-line amendment**, made in `PPL-03`'s instruction list in the same way `PPL-02` instruction 9 already amends `B-03` for paths under `people/`: test for the source file first, and return 0 with no output when it is not there.
A failed copy of a file that does exist still exits 1 and still stops the write. Nothing else about the fail-closed posture moves.

**No value is ever interpolated into a `sed` script or an `awk -v` assignment.**

This is a write-safety rule, not a style preference, and the section's own worked examples break both obvious implementations:

- `sed "s/^link: .*/link: $value/"` breaks on the `/` in `https://brightops.co.uk/about`. Change the delimiter and it still breaks, because a bare `&` in the replacement expands to the whole matched line, and `why_them` and `found_via` carry ampersands as a matter of course.
- `awk -v v="$value"` processes backslash escapes in the assignment before the program runs, so a value containing `\n`, or a Windows path a founder pasted, arrives as something other than what was typed.

Both corruptions are silent, and they land in a file the founder will not re-read. Every prospect in a B2B run gets a `link:` line, so this is the common case rather than an edge.

The one sanctioned pattern, used by `person_set_field` and by every other value write:

```sh
# rebuild the header line by line in the shell, emitting the value as an argument
# never as a format string, and never inside a script another tool will parse
person_set_field() {                # <file> <name> <value>
  _f=$1; _n=$2; _v=$3
  : > "$_f.tmp"
  _done=0
  while IFS= read -r _line || [ -n "$_line" ]; do
    _line=${_line%"$CR"}
    case $_line in
      "## "*) _done=1 ;;            # header is over, copy the rest untouched
    esac
    if [ "$_done" -eq 0 ] && [ "${_line%%: *}" = "$_n" ]; then
      printf '%s: %s\n' "$_n" "$_v" >> "$_f.tmp"
    else
      printf '%s\n' "$_line" >> "$_f.tmp"
    fi
  done < "$_f"
  mv "$_f.tmp" "$_f"
}
```

Three rules fall out of it and each is checkable by reading the code:

1. The value reaches the file as an **argument to `printf`**, never as part of a format string and never inside a script another tool parses. `printf '%s: %s\n' "$name" "$value"`, always.
2. Where a value genuinely has to reach `awk`, it goes in through a temporary file read with `getline`, never through `-v`.
3. The rebuild stops replacing at the first `^## ` line, so a body line that happens to start with the field name is copied through untouched.

**The snapshot ring for `people/` is 20, not 10.**

`B-03`'s ring is 10 per file everywhere else and stays 10 everywhere else.
The build itself fills most of a person's ring: on the B2B route a kept prospect takes four or five snapshotted writes during step 4 to step 10, before the founder has done anything they might want to undo.
A ring of 10 would mean the argument for having no `--amend` on `ge person opener`, that the previous one is in the ring, is true only until the build fills it.
Twenty costs a few kilobytes per person and makes that argument hold. It is a one-line change inside `B-03`, made in `PPL-02` instruction 10 alongside the path fix, with the reason in the commit body.

`ge person` writes **at most one person file per invocation**. There is no bulk verb and none is coming.
That is what keeps `ge undo` usable: `ge undo` asks which file when more than one was snapshotted in the last hour, so a bulk write over twenty five targets would hand the founder twenty five candidates and no way to undo the operation.
One file per invocation means `ge undo` always has at most one person candidate for the thing that just happened, and twenty five people cannot evict each other from the ring.

One invocation may set several fields on that one file, and `ge person add` does exactly that. Folding three writes to one person into one call is not a bulk verb: it is still one file, still one snapshot, still one undo candidate.

### CSV cells, quoting and escaping

`growth-engine/outreach-firstlines.csv` is the only CSV `ge person` writes, and three of its five columns routinely contain commas.
`first_line` is a sentence of English prose, so a comma is close to certain. `company` carries values like `Arden FM, Ltd`. `name` carries them too.

An unquoted comma shifts every later column right.
Apollo then imports the company into the first-line merge field, nothing fails, nothing warns, and the founder finds out when twenty five emails have gone out.

**The rule, and it has no exceptions:**

1. Every cell is written wrapped in double quotes. The header row too, so the shape is uniform and nothing has to decide per cell.
2. Every double quote inside a value is doubled. `he said "no"` is written `"he said ""no"""`.
3. A newline inside a cell is impossible, because `ge person set`, `note`, `touch` and `opener` all refuse a value containing one, and a prospect opener is refused above one line at write time.

So the reader never needs a full RFC4180 parser, which is the hardest thing this section could have asked for in POSIX sh with no `jq`.
It needs only: strip one leading and one trailing double quote, and turn every doubled double quote into one.

**The divergence check reads it the same way.**
`ge lint` compares the **first 40 characters** of the person's opener line against the **first 40 characters of the cell after unquoting**, which is the shape the existing `content-30.csv` divergence check already uses at `02:848`.
Forty characters is enough to catch a corrected opener and short enough that no comparison ever depends on a parser this toolkit does not have.
A second comparison shape was considered and rejected: two divergence checks that differ in the details is how one of them quietly stops firing.

### Malformed files

**Malformed never means silently skipped.** This is the rule the whole part exists for.

A file is malformed when any of these is true:

| condition | region evaluated | reported as |
|---|---|---|
| a header line that is not a field, not blank, does not begin `#`, does not begin `<!--` | header | `BADLINE` |
| a required field missing for its `kind` | header | `MISSING` |
| a field name outside the declared list | header | `UNKNOWN` |
| a single-valued field appearing twice | header | `DUPFIELD` |
| a field with an empty value | header | `EMPTY` |
| `status` not in the enum for this `kind` | header | `BADENUM` |
| `kind` not `prospect` or `target` | header | `BADKIND` |
| the filename is neither `<derived>.md` nor `<derived>-N.md` for an integer `N` from 2 to 9, where `<derived>` is the slug derived from `key` | filename | `BADNAME` |
| a `key` value that appears in another file too | header | `DUPKEY` |
| a start marker with no matching end marker | body | `HALFMARKED` |
| a touch line whose channel or direction is outside its list | inside `GE:TOUCH` | `BADTOUCH` |
| a line inside `GE:TOUCH` or `GE:NOTES` that does not begin `- ` | inside those two blocks | `BADBLOCKLINE` |
| a block bullet that is a single character | inside a block | `SHREDDED` |

The **region** column is the rule from the top of this part, applied row by row.
Header conditions are evaluated only over lines above the first `^## ` line. Body conditions are evaluated only inside the marker pair they name.
Nothing below the `## Yours` heading is evaluated by any row, ever.

`BADNAME` is written against the derive-and-probe rule in part 3 rather than against a bare equality, because the `-2` and `-3` names are how two different keys that derive one slug both get a home.
A file named anything else cannot be found from its key, which is why it is a fault rather than a preference.

`BADBLOCKLINE` is the fault a pasted note creates.
Text copied from a web page carries newlines, the second line lands inside `GE:NOTES` with no `- ` in front of it, and without this row the file stays valid while `--long` reads the wrong line as the newest touch and the openers export emits a stray line into `dm-openers.md`.
The write side refuses the newline in the first place, per `ge person note`. This row catches the file a founder edited by hand.

The last one is a positive detector for a specific known corruption rather than a field check.
Glitch shipped exactly that shape for months: a sentence handed to something that expected a list gets iterated, and every character becomes an item, one bullet per letter.
The shell version of it is an unquoted expansion or an `IFS` split, and it fails in the same silent way, because the shape carries no error of its own.

Two postures, and which applies is decided by who is reading:

- **`ge person add`, `set`, `note`, `touch`, `opener`, `remove`, `purge` and `export` are strict.** A malformed file is refused. They write nothing and exit 1, with the file, the line number, the reason, and a recovery line.
- **`ge person list`, `ge person get` and `ge lint` surface.** They never hide the person. `list` prints the row with `MALFORMED` in the status column and the reason, so the person is counted as present and broken rather than as absent. `ge lint` warns, per `B-06`'s warn-only posture, with a `→` recovery per warning.

**A `MALFORMED` row ignores every filter.**
`ge person list --kind prospect` prints every malformed file as well, because the fields a filter reads are the fields that cannot be trusted in a file that failed to parse.
Silently dropping a broken person under a filter is the exact behaviour this part exists to prevent, and it is also why `list` still exits 0: it is a report, and it reported.

**`ge lint --strict` exists, and it is for the harness, not the founder.**

Warn-only lint that always exits 0 is right for a founder and wrong for a build check.
`V-11`'s example harness at `03:955` maps a zero exit from `ge lint` to `pass`, so with every person fault warn-only the **invalid** example in `schemas/person.md` passes lint, the harness prints `BADINVALID`, and `validate.sh` fails on a clean tree. `PPL-06`'s acceptance asks for `validate exit=0`, which is then unachievable.
That conflict predates this section: `B-06` at `02:833` fixes lint as warn-only and asserts `lint exit=0` against a fixture with five seeded faults.

Resolution, one flag: `ge lint --strict` exits 1 when any warning was emitted and is otherwise identical.
`V-11`'s harness line becomes `"$GE" lint --strict --root ...`.
The founder-facing default is unchanged, warn-only, exit 0, so `D-8`'s posture holds exactly as written. Without the flag the person schema cannot carry an invalid example at all.

One broken file never stops the other twenty four.
Every reader enumerates `people/` with the sanctioned pattern above, without `set -e`, and collects what it could not parse, then reports the collection at the end.

`ge person export` is the one reader that refuses while any person file is malformed, and it says which.
An export that silently omits one person is worse than no export, because the founder counts twenty four rows and does not know which one is missing.

---

## 5. `ge person`

One noun, eleven verbs, no aliases and no abbreviations, per section 06's naming rules.
`person` joins the dispatcher list at `06:903`.

**Every verb below takes either a slug or a key** wherever it is written `<slug>`, per the rule in part 3.
An argument containing `@` or `:` is a key. Anything else is a filename slug.
The founder-facing documents use the key form throughout and do not use the word slug.

**`ge person` does not get a command file.** It is reached through the skills and through `/growth-engine:status`.
That keeps the skill count, the command count, the README table, `V-18`'s manifest, `CK-14`, `CK-17` and `CI-01` item 11 exactly where they are, which is seven count sites that would otherwise all have to move together.

### The verbs

| verb | snapshots first | writes |
|---|---|---|
| `add` | no, it refuses if the file exists with this key | creates one person file, with as many of its fields as the flags carry |
| `set` | yes | one header field |
| `note` | yes | one line into `GE:NOTES` |
| `touch` | yes | one line into `GE:TOUCH`, and on one narrow case one header field |
| `opener` | yes | replaces `GE:OPENER` |
| `remove` | yes | deletes one person file, recoverable |
| `purge` | no, it deletes the snapshots too | destroys one person file and every snapshot of it |
| `get` | no | nothing |
| `list` | no | nothing |
| `export` | yes, on the export target | one export file |
| `help` | no | nothing |

`add` does not snapshot because it creates a file that did not exist, and it refuses rather than overwrite when one does.
`purge` does not snapshot because the snapshot is the thing it is there to destroy.
Everything else that writes snapshots first, fail-closed, the same posture as `B-03`: no snapshot means no write, with the one stated exception that a snapshot of a target that does not exist yet succeeds and does nothing, per part 4.

### `ge person add`

```
ge person add prospect <email> "<name>" [--company X] [--title X] [--source apollo|manual|import|form]
                                        [--found-via "X"] [--why-them "X"] [--priority 1|2|3]
                                        [--note "X"] [--note-source "X"]
ge person add target <platform> <handle> "<name>" [--platform-label "X"] [--source manual|import|form]
                                        [--found-via "X"] [--why-them "X"] [--priority 1|2|3]
                                        [--note "X"] [--note-source "X"]
```

Normalises the identifier, derives the slug, creates the file with the required fields, all three blocks present and empty, and the `## Yours` heading.
`status` starts at `candidate` for a prospect and `target` for a target.
`created` is today, UTC, from `lib/date_compat.sh`.
`source` defaults to `manual`.

**`--why-them`, `--priority` and `--note` land a complete person in one call.**
They are the three things both skills write immediately after every add, and writing them here removes two invocations per person.
`--note` writes one line into `GE:NOTES`, and `--note-source` is its attribution clause.
The flag is `--note-source` and not `--source`, because `--source` on `add` already sets the `source:` field, and two flags one letter apart with different meanings is how a skill author writes the wrong one.
This is not a bulk verb: it is one file, one write, one snapshot-free creation and one undo candidate. The invocation arithmetic is in part 7.

There is **no `--slug` flag**. Part 3 says why, and the collision rule that replaces it is stated there in full.

**Output on success**, one line:

```
added people/sofia-mendes-brightops-co-uk.md  prospect  candidate  sofia.mendes@brightops.co.uk
```

Plus, on the first person created in a `people/` folder that held only the seed file, one extra line:

```
  this folder now holds real people's details. Keep it out of shared drives and out of git
```

**Refusals**, exit 1, each with a `→` line:

- a file already holds this exact `key`: `already there`, with the path
- nine derived names are already taken by nine other keys: `too many collisions`, naming every key found
- `platform` outside `ig|fb|other`
- `platform: other` with no `--platform-label`
- an email with no `@`
- an empty name
- a newline in any flag value

A slug collision against a different key is **not** a refusal. It is resolved to `-2`, printed, and explained on the same line, per part 3.

`add` never creates a person as a side effect of anything.
A person exists because the founder said so, in the session, with the founder reading the output.

### `ge person set`

```
ge person set <slug> <field> <value>
```

Validates strictly. Refuses an unknown field name and prints the full list of valid fields.
Refuses a value outside the controlled list for that field, printing the allowed values, matching the enum-error style `B-05` sets.
Refuses `key`, `kind` and `created` outright, because those three are immutable, and says which command to use instead.
Refuses a value containing a newline, with the same message and recovery `note` and `touch` use.
Refuses any `email_status` value but `unverified`, naming spike `S-07` as the reason and saying the restriction lifts when it lands.
That last one is in the code rather than only in the plan, because a skill author reading part 7 sees the command and not the paragraph.

**Output on success**, one line, showing both sides so the founder can see what moved:

```
set people/ig-carla-b-pt.md  status  opener_written -> sent
```

### `ge person get`

```
ge person get <slug>            prints the whole file to stdout
ge person get <slug> <field>    prints one value, bare, no label, no newline padding
```

Exit 0 when found, exit 2 when there is no such person, exit 1 when the file is malformed.
The separate exit 2 exists so a skill can branch on "not there yet" without parsing text, which is the difference between a skill that adds a missing person and one that reports a broken toolkit.

### `ge person list`

```
ge person list [--kind prospect|target] [--status X] [--platform ig|fb|other]
               [--source X] [--priority 1|2|3] [--needs opener|followup|touch]
               [--long]
```

Filters combine with AND. No filters means everyone.

**Stdout is exactly one line per person and nothing else.**
No headers, no totals, no advisory, no blank lines.
That is what makes `ge person list --kind prospect --status cut | wc -l` a count the acceptance blocks in part 9 and the gate can rely on.
Everything that is not a person row goes to stderr.

A `MALFORMED` row is always printed, whatever filters were given, per part 4. It is a person row, so it is on stdout and it counts.

Default output, one line per person, fixed columns, sorted under `LC_ALL=C` by `kind` then `status` then slug:

```
prospect  enrolled        sofia-mendes-brightops-co-uk   Sofia Mendes      BrightOps Facilities
prospect  cut             tom-hale-arden-fm-co-uk        Tom Hale          Arden FM
target    sent            ig-carla-b-pt                  Carla Bruno       ig
target    opener_written  ig-nadia-restores              Nadia             ig
MALFORMED BADENUM:line 4  ig-sam-w                       ig-sam-w          people/ig-sam-w.md
```

`--long` adds the newest touch date, its direction, and whether the opener block has content.
All three are derived at read time and none of them is stored.

`--needs opener` is every person whose `GE:OPENER` block is empty.
`--needs followup` is every person whose `follow_up_on` is today or earlier.
`--needs touch` is every person with no touch line at all.

**The near-duplicate advisory, on stderr.** After the rows, `list` writes at most one advisory block **to stderr**, naming any two people who share a normalised surname and an email domain.

```
possible duplicates, decide yourself:
  sam@acme.com and sam.j@acme.com
  → run: ge person get sam.j@acme.com   to look before you decide
```

Two things about that block are deliberate and both were wrong in the first draft.

**It is on stderr** because it is three or more lines and a 35-prospect Apollo list produces near duplicates as the normal case. On stdout it would break every `| wc -l` in this plan, and the likeliest repair would be suppressing the advisory under filters, which removes it without anyone noticing.

**The recovery is `get`, not `remove`.** The heading says decide yourself, and pairing a guess with the one verb that destroys a file is how a real second prospect disappears. `get` prints the file and the founder looks.

The same-handle-on-two-platforms rule is **dropped**. The platform is part of the key, so `ig:carla` and `fb:carla` are two legitimate records and flagging them is a false positive by construction.

One `awk` pass over twenty five lines. No scoring, no thresholds, no bands, and no automatic action.
Apollo lists do produce near duplicates that an exact key cannot catch, and this is the whole response to that: show the founder, let the founder decide.
Nothing is ever matched at write time, because matching on the write path is how a fuzzy resolver gets in.

Exit 0 always, even with malformed rows present, because `list` is a report.

### `ge person note`

```
ge person note <slug> "<text>" [--source "<where>"]
```

Appends `- YYYY-MM-DD <text> (source: <where>)` to `GE:NOTES`.
When `--source` is absent the clause is omitted and the source is understood to be the founder, in session.

The attribution goes **in the line**, not in a separate field, so it cannot be separated from the claim it supports.
A note that came from a page carries the page and the date it was read. A note that came from the founder carries neither and does not need to.
No source and no founder present means the note is not written.

**Refuses a value containing a newline**, in the text and in `--source`, with the same message and the same recovery `set` uses.
A note pasted from a web page carries newlines routinely, and without this the second line lands inside `GE:NOTES` with no `- ` in front of it. Part 4 catches that as `BADBLOCKLINE` on read. This stops it being written in the first place.

### `ge person touch`

```
ge person touch <slug> <email|dm|call|form|other> <in|out> "<text>"
```

Appends `- YYYY-MM-DD <channel> <direction>: <text>` to `GE:TOUCH`.

**Refuses a value containing a newline**, same message, same recovery.

**One narrow status advance, and only one.**
`ge person touch <key> dm out "..."` on a person with `kind: target` whose `status` is `target` or `opener_written` also sets `status: sent`, and prints both changes on the one line:

```
touched people/ig-carla-b-pt.md  dm out    status  opener_written -> sent
```

It fires on nothing else. Not on `dm in`, not on any other channel, not on a prospect, and never on a status at or past `sent`, so it can only ever move forward and only from the two states where the meaning is unambiguous.
Recording an outbound DM to a target **is** the send, so writing it twice is bookkeeping the founder pays for on the busiest afternoon of the event.
It halves the commands a B2C founder types after each of twenty five hand-sent messages, from two to one, and it is what makes gate item C13 gradeable on evidence rather than on returning to the terminal.

**This records. It never sends.**
Nothing in `ge person` sends a message, offers to send one, schedules one, or holds a queue of them.
There is no field named `queue`, `scheduled_send` or `send_at`, and check V-16 is extended in part 11 to keep it that way.
`touch` is written after the founder did something, describing what they did.

### `ge person opener`

```
ge person opener <slug> --file <path>
ge person opener <slug> -           reads the text from stdin
```

Replaces the contents of `GE:OPENER` byte-exactly between the markers.
Refuses more than one line when `kind: prospect`.
Refuses empty input.
Refuses a file whose `GE:OPENER` block is half-marked, per section 08, writing nothing and exiting 1.

There is no `--amend`. To change an opener, write the new one.
The previous one is in the snapshot ring, which is what the ring is for.
That argument only holds because the ring for `people/` is 20 rather than 10, per part 4. At 10 the build itself would fill half of it before the founder rewrote anything.

### `ge person remove`

```
ge person remove <slug>
```

Snapshots, then deletes.
Prints the snapshot stamp and the restore command.

```
removed people/ig-sam-w.md
  → run: ge restore people/ig-sam-w.md 20260919T104412Z   to put it back
```

It exists so that correcting a mistake does not send a founder to `rm`, which has no snapshot and no undo.
A prospect who is not worth contacting is `status: cut`, not a removal. Cutting keeps the reason, and the reason is what stops the same company being rebuilt into the list next month.

`remove` is the wrong verb for a deletion request, and saying so here matters: it keeps the file in `.state/snapshots/` and prints the command that brings it back. That is correct for a mistake and the opposite of what someone asking to be deleted is owed. `purge` is the verb for that.

### `ge person purge`

```
ge person purge <slug>
```

Destroys one person. The file, and every snapshot of it. No restore command is printed, because there is nothing to restore.

**It refuses unless `status` is `stopped` or `cut`.**
Those are the two states that mean the founder has already decided this person is out, and requiring one of them first means the destructive verb cannot be the first thing anybody reaches for.
The refusal names the two values and the command that sets them.

```
purged people/ig-sam-w.md
  destroyed 1 person file and 4 snapshots. This cannot be undone
  → run: ge person list --kind target   to see who is left
```

Printing the counts is the whole receipt. There is no log line to go and check afterwards, by design.

**A person asked to be removed must be able to be removed.**
A prospect in the UK or the EU who replies asking for their details to be deleted cannot be honoured by `remove`: the file goes and ten snapshots of it stay.
This is the one obligation the rest of the layer is otherwise scrupulous about and it needs a verb, not a paragraph.

**`ge person` never writes a name, an email address or a handle into `ops-log.md`.**
It writes the slug and the verb, and nothing else. `ops-log.md` is append only, so anything written there survives a purge and cannot be taken back out.
That is stated in part 3, in `schemas/person.md`, and enforced as a leg of `V-16` in part 11 rather than left as an intention.
`TROUBLESHOOTING.md` gains the founder-facing version: someone asked me to delete their details.

### `ge person export`

```
ge person export firstlines
ge person export openers
```

`firstlines` writes `growth-engine/outreach-firstlines.csv`, whole file, sole writer.
One row per person with `kind: prospect` and `status` not `cut`, sorted under `LC_ALL=C` by slug.

**Five columns, header row fixed:**

```
"email","first_name","company","first_line","status"
```

Every cell is wrapped in double quotes and every embedded double quote is doubled, per the rule in part 4. The header row is quoted too.

`first_line` is the single line from `GE:OPENER`. A prospect with an empty opener block gets a row with an empty cell.
`first_name` falls back by the rule in part 3 when the field is absent.
The counts of empty openers and fallback first names are printed **to stdout**, never into the file, because a comment line in a CSV header breaks the Apollo import.

**The fifth column, `status`, is why the manual route still has a checklist.**
`05:884` describes this file on the manual route as who, the opening line, and a column to tick when sent.
The file is now an export, so ticking it records nothing, and without a status column a third of B2B founders lose a printed sheet and gain twenty five typed commands.
With the column the printed sheet is still a checklist, and the founder who wants it recorded copies the address out of column one:

```
ge person set sofia.mendes@brightops.co.uk status contacted_ok
```

Apollo ignores a column nobody maps, so the extra field costs the automated route nothing.

`openers` writes only the `GE:TARGETS` block inside `growth-engine/dm-openers.md`, using `lib/blocks.sh`.
Everything outside that block belongs to the `audience-b2c` skill and the founder: the pacing warning, the targeting narrative, the offer framing.
One entry per person with `kind: target`, sorted under `LC_ALL=C` by `priority` then slug, each carrying handle, name, the reason, and the opener text.
A person with no `priority` sorts as if `priority: 3`, so the order is total and the output is byte-identical run to run.

Both refuse while any person file is malformed, exit 1, and name every file they could not parse.
Both snapshot the export target first, and on the first run there is nothing there to snapshot, which succeeds and does nothing, per part 4.
Both print a count and the path.

This is the answer to the staleness question that would otherwise be the most likely real-world failure in the whole change: the founder corrects an opener in the person file, the CSV still holds the old one, the gate reads the CSV, passes, and twenty five emails go out with the old line.
The export is generated, never hand-edited, and `ge lint` gains a divergence check in part 11 that compares the two.

### Exit codes, complete

| code | meaning | used by |
|---|---|---|
| 0 | did what was asked | every verb |
| 1 | refused: bad input, bad enum, unknown field, nine taken names, malformed file, half-marked block, failed snapshot, a status `purge` will not act on | every verb |
| 2 | no such person | `get`, `set`, `note`, `touch`, `opener`, `remove`, `purge` |

Every non-zero exit prints one message to stderr whose last line begins `  → run: ` and contains exactly one runnable command, per section 06.

---

## 6. The ledger rows: retirement, not derivation

The task brief asks for the rebuild procedure. There is no rebuild procedure, because there is nothing to rebuild.
This part gives the retirement instead, and then the reporting that replaces what the rows were being read for.

### What is removed

| where | what goes |
|---|---|
| `schemas/ledger.md` | the `O|` and `D|` row grammars, and the "all three of them" wording. One grammar remains |
| `ge ledger` | `add-outreach`, `set-outreach`, `add-dm`, `set-dm` |
| `ge ledger list` | the `O` and `D` selectors |
| `ge lint` | the `O|` and `D|` field-count and enum legs |

`schemas/ledger.md` gains one pointer line naming `schemas/person.md` as where people live now.
The paragraph explaining why the `D|` row existed at all moves into `schemas/person.md` verbatim, because it is the record of why there are two status enums.

### A removed verb must not return success

`ge ledger list O` and `ge ledger list D` exit 1 with a recovery line, rather than printing nothing and exiting 0.

```
ge ledger list O: the ledger holds content rows only. People moved to growth-engine/people/
  → run: ge person list --kind prospect
```

A removed verb that returns success is the quietest possible break.
Every doc, skill text and habit that still says `ge ledger list D` would read as working while reporting zero people forever.

### What replaces the derivation

Reporting, run at the moment it is asked for, against the files themselves.

```sh
# content by status, unchanged
sh "$GE" ledger list C --status approved | wc -l

# people by status, both kinds
sh "$GE" person list --kind prospect --status enrolled | wc -l
sh "$GE" person list --kind target --status sent | wc -l

# the same thing with no ge at all, which is the point
for f in growth-engine/people/*.md; do
  [ -e "$f" ] || break
  case ${f##*/} in README.md) continue ;; esac
  sed -n '/^## /q; /^status: /p' "$f" | tr -d '\r'
done | LC_ALL=C sort | LC_ALL=C uniq -c
```

That is the sanctioned enumeration from part 4, not a shorter one written for the page.
The short form, `grep -h '^status: ' growth-engine/people/*.md`, is wrong twice: it prints `No such file or directory` on every machine that has not run engine 2 yet, and it counts a founder's own `status:` line under `## Yours` as a person.

Two sources, two commands, no derived middle, and no freshness concept to explain to a founder.
The `status` skill reads both. The `gate` command reads both. Neither reads a copy.

### When it runs

Never on a schedule, and never inside the standard write chain.
`ge index` stays exactly as section 02 line 141 has it, and stays out of `ledger.md`.

### If a person file and a ledger row disagree

After retirement they cannot, because the ledger holds no person rows.

During the build window, between `PPL-04` landing and the skills being rewired, a test run folder can still carry old rows.
`ge lint` gains one warning for exactly that window:

```
WARN growth-engine/ledger.md line 31: an O| row survives, and people live in growth-engine/people/ now
  → run: rm -rf runs/<name> && bash scripts/new-run.sh <route> <name>   and regenerate
```

Warn-only, per `B-06`'s posture. The row is never rewritten and never migrated.
There is no installed base: section 01 records that nothing has ever been executed end to end, so the only files carrying these rows are run folders that are cheaper to regenerate than to convert.

### The one derived thing, named so it is not a surprise

`ge index` gains **one** row in `.state/index.md` for the directory, not one per person:

```
| people/ | gate B or C | ok | 25 files | 2026-09-19 14:22 |
```

A count and a newest-modified stamp, nothing else, in a file that is already declared derived and rebuildable and that nothing gates on.
It is there so `ge check`'s index freshness leg does not report a fresh index against a folder whose person half it never looked at.
No per-person fact is ever copied into the index, and no platform value, which is one reason the three-value platform vocabulary in part 3 never has to be reconciled with anything.

On a `people/` folder holding only the seed file the row reads `0 files` and `ge index` exits 0.
It is written with the sanctioned enumeration from part 4, so it does not fail on the fresh install that every one of the 130 machines starts from.

---

## 7. Which skills write people, and where

Every call below is written into the skill as literal instruction text, in this order, with section 02's snapshot posture: a non-zero exit from `ge snapshot` stops the skill there, before the write.

### `outreach-b2b`, task `A-01`

| step | what happens | the `ge` calls, in order |
|---|---|---|
| 4, build 35 | one file per prospect as the row is accepted, complete in one call | `ge person add prospect <email> "<name>" --company "<c>" --title "<t>" --source apollo --found-via "<search>" --why-them "<one line>" --note "<what was seen>" --note-source "<url>, read <date>"` |
| 5, cut to 25 | the 10 cut keep their files | `ge person set <email> status cut` then `ge person note <email> "<the reason>" --source founder` |
| 6, enrich | deliverability. Until `S-07` lands the only accepted value is `unverified`, and `set` refuses the others | `ge person set <email> email_status unverified` |
| 7, contacts | only when an id came back | `ge person set <email> apollo_contact_id <id>` |
| 8, first lines | one line each, against the real enriched row | `ge person opener <email> -` then, once all 25 exist, `ge person export firstlines` |
| 8, still | the Apollo write-back, unchanged | write the same line into the `first_line` custom field |
| 10, enrol paused | after the enrolment is confirmed paused | `ge person set <email> status enrolled` |
| 13, export | unchanged | the sequence file, plus the generated CSV |

**The invocation count, stated so the skill author can see it.**

The first draft of this table cost about 226 `ge person` calls in one `outreach-b2b` session: 35 adds, 35 `set why_them`, 35 notes, 10 cut sets and 10 cut notes, 25 `email_status`, 25 `apollo_contact_id`, 25 openers, 25 status sets and one export.
About 190 of those snapshot. All of it runs in one session on Git Bash, where process spawn is the slowest thing the toolkit does, and 226 tool calls with 226 outputs is a real context and wall-clock load on the one skill that has to finish on the day.

Folding `--why-them` and `--note` into `add` removes 70 calls. The table above is about **156**, of which about 121 snapshot.
That is the number `PPL-01`'s effort estimate is written against, and if a later edit pushes it back up, this paragraph is where it shows.

No bulk verb was added to get there, and none is coming. One invocation still writes one file, so `ge undo` still has one candidate.
The other half of the arithmetic is the ring: a kept prospect takes four or five snapshotted writes during this build, which is why part 4 sets the `people/` ring to 20.

Step 8 is the concrete win on the B2B side and it should be said in the skill text in one sentence: the twenty five first lines exist locally whatever Apollo does.
If gate D says custom-field writes are unavailable, the founder still has all twenty five.

**All 35 get a file.** The 10 cut carry `status: cut`.
The `cut` value already exists in the enum, which is evidence the plan always intended a record for them, and the cut reason is the thing that stops the same company being rebuilt into the list next month.
The cost is that every B2B acceptance becomes a two-part count rather than one, and part 9 writes both greps out so nobody guesses.

### `audience-b2c`, task `AB-01`

| step | what happens | the `ge` calls, in order |
|---|---|---|
| 3, targeting | one file per target as the founder picks the account, complete in one call | `ge person add target <platform> <handle> "<name>" --source manual --found-via "<hashtag, account or post>" --why-them "<one line>" --priority <1\|2\|3> --note "<what was seen>" --note-source "<their feed>, read <date>"` |
| openers | the message, in full, per target | `ge person opener <platform>:<handle> -` then `ge person set <platform>:<handle> status opener_written` |
| openers, after all 25 | render the readable page | `ge person export openers` |
| after the founder sends, by hand | one call per message actually sent, and it carries the status with it | `ge person touch <platform>:<handle> dm out "opener sent by hand"` |

The `AB-01` count comes down the same way `A-01`'s does: from about 126 calls to about **76**.
Three writes per target fold into the add, and the send is one call rather than two because `touch <target> dm out` advances `opener_written` to `sent` on its own, per part 5.

The skill states, once and plainly, at the top of the openers step: these are sent by hand, spread out, from the founder's own account, and nothing in this toolkit sends them.
The person layer does not soften that. `touch` records what the founder did, after the fact, and there is no verb that could do anything else.
The status advance does not soften it either: it is a record of a send that already happened, written by the founder, after the fact.

De-duplication gets stronger and should be said: a second session cannot re-target the same handle, because `ge person add` finds the file and refuses.

**`audience-b2c` must never truncate `dm-openers.md`.**

Today `04:197` and `02:1284` have the skill producing `dm-openers.md` as one of three whole-file rewrites with snapshot first.
`ge person export openers` writes a `GE:TARGETS` block inside that same file. Left as it is, the file has two automated writers with no reconciliation, and re-running the skill destroys twenty five exported openers with only a snapshot to recover them.
That is reason one for rejecting the lead proposal, "it puts two writers on `ledger.md`", turned on this section itself. The `memory.md` precedent does not cover it, because there the second writer is a human rather than another `ge`-instructed skill.

So the write model for that one file changes, and the amendment rows in part 10 change with it:

- `audience-b2c` writes `dm-openers.md` through `block_ensure` plus a preserve-everything-outside-markers write, never a whole-file rewrite. The pacing warning, the targeting narrative and the offer framing are its blocks. `GE:TARGETS` is not, and the skill leaves whatever is inside it exactly as it found it.
- The skill's other two files keep whole-file rewrite. Nothing else about `04:197` moves.
- `08:125` widens to name `dm-openers.md` as well as `memory.md` and `growth-engine/people/*.md`, and `08:127`'s sentence that nothing else adopts markers in version 1.0 is the line that has to change to say so.
- `schemas/writers.md` records the split ownership rather than one owner, per part 10, or `V-12` reports a false `TWOWRITERS` on the first run after `PPL-03`.

Part 11 adds the golden case: run the export, re-run the skill's write of `dm-openers.md`, and assert the `GE:TARGETS` block is byte-identical afterwards.

**Gate item C13 stays file-backed, and it gets a fallback rather than a trap.**

`05:1088` today is "ask them how many they are sending per hour". It becomes at least one person file at `status: sent`, which is better evidence and `D-3` is right to want it.
But the evidence only exists if the founder came back to the terminal. A founder who genuinely sent all twenty five from their phone and never reopened Claude Code fails a gate that says they did nothing, and that failure is indistinguishable from a founder who sent none. On the busiest afternoon of the event that is a support queue.

So `schemas/gates.md` and `commands/gate.md` both say: when no person file is at `status: sent`, the gate **asks**, records the answer, and passes on the answer, while printing the one command that turns it into evidence.

```
no person file is at status: sent yet. How many did you send?
  → run: ge person touch ig:carla.b.pt dm out "opener sent by hand"   to record one
```

The marking change `D-3` requires still lands, in the same commit, and the gate stops being a test of whether the founder ran two bookkeeping commands.
The `touch` status advance above is the other half of this: it makes recording a send one command instead of two, so most founders will have the evidence without being told.

### `status`, task `A-02`

Reads only. `ge index`, then `ge ledger list C` for content, then `ge person list` for people.
Two sources, two commands.

### `growth-plan`, task `GP-01`

Reads only, and only counts: how many prospects, how many at each status, how many targets sent.
It never reads a person's name, note or opener into the plan, because the plan is a document a founder shares.

### Everything else

`founder-brain`, `content-engine`, `ghl-workflows`, `setup` and `playbook-export` do not touch `people/` at all.
`playbook-export` is deferred in v1.0 and its exclusion list gains `people/` anyway, in case the deferral is ever reversed, because it compiles a document that goes to a printer.

---

## 8. What this deliberately does not do

| not built | why |
|---|---|
| Entity resolution, fuzzy matching, scoring, bands, alias tables | Both routes have a strong identifier by construction, so the name-only ingest path that needs all of it does not exist here. Glitch needs it because it ingests names from transcripts and inboxes with nobody present to answer. Our founder is present, always, by design |
| A proposal queue: pending cards, accept, apply, dismiss, replace, undo tokens | It exists to solve one problem we do not have, which is that the founder is not there when the fact arrives. Every `ge person` write happens with the founder in the session reading the output. At twenty five people the founder is the queue |
| Auto-merge, auto-create, auto-link | A collision is a refusal with a recovery line naming both files. A person exists because the founder said so |
| A minted opaque id per person | Ids exist so rows can point at a person across tables. There are no tables. Minting a stable id in POSIX sh needs either an unstable `$$` and date, or a hash tool that is not guaranteed present |
| A per-record `confidence` field | A whole record graded `medium` says nothing about which of a dozen facts was checked, and nobody maintains it at twenty five people. The per-line source clause replaces it and cannot be separated from the claim |
| A second status axis: `attention`, `do_not_contact`, `tags` | Two classification axes on one person is how a founder gets two contradictory answers. `replied` plus the direction on the newest touch line already separates "I owe them" from "I am waiting" |
| Cadence, `next_due`, follow-up arithmetic | Apollo owns B2B cadence. The twenty five B2C openers are sent by hand, once. One optional `follow_up_on` date covers what is left |
| Phones, birthdays, relationship graphs, `how we met`, interests as an enum | They model a relationship. This models a sales motion. Birthday tracking on a cold prospect is the clearest sign a field was ported without thinking |
| Search, ranking, an index over the notes | `grep` over twenty five short files is faster than anything that would need building, and it reads the truth |
| Any sync with GoHighLevel or Apollo | Person files never leave the machine over an API. A local record and a remote record are never claimed to be the same person unless an API returned an id that says so. The other way off the machine, a cloud-synced or git-tracked working folder, is guarded in part 3 rather than here, because it is the one that actually happens |
| A restore path for `ge person purge` | It is deletion, asked for by the person whose details they are. A restore command would make the verb a lie |
| Sending anything, queuing anything, scheduling anything | Design rule 1. The layer records, it never acts on the founder's behalf towards other people |
| A `/growth-engine:person` command | Seven count sites would move together for no founder-visible gain. Reached through the skills and `/growth-engine:status` |
| A `ge context` line for people | The fifteen-line ceiling is already contested by the anchor verdict, unresolved Flags and section 08's memory lines. A line that may or may not appear depending on how many Flags are open looks like a bug and is not. At twenty five people, none |
| Bulk verbs | One file per invocation is what keeps `ge undo` usable at this scale |
| Scale beyond about 35 people per founder | Every rule above is chosen for twenty five. None of it is built to survive two thousand, and pretending otherwise would cost more than the whole layer |

### What option 3 would add, if it is ever built

A real SQLite database, a projector that reads these files into typed rows, entity resolution with normalisation, deterministic identifier matching and a capped fuzzy tier above it, an alias table that learns from confirmed picks, a discourse frame so "the second one" resolves against the last question asked, a proposal queue with per-apply backups and undo commands, full text search across notes, and joins from a person to meetings, messages and projects.

None of it is needed at twenty five people and all of it is buildable on top of what this section specifies, without changing a single person file.
That is the stepping-stone test, and it is the reason the file is `key: value` lines and dated bullets rather than anything cleverer.

---

## 9. The tasks

Seven new tasks, ids `PPL-01` to `PPL-07`, placed in section 02 Phase 2 immediately after `B-10`, numbered so that no existing id moves.

Throughout: `REPO` is `/Users/pmudh/Documents/GitHub/Atlanta`, `GE` is `/Users/pmudh/Documents/GitHub/Atlanta/plugins/growth-engine/scripts/ge.sh`, and run folders live under `/Users/pmudh/Downloads/Atlanta/launchhouse-atlanta/runs/`.

---

### PPL-01, the person file, its schema, and `ge person add | set | get | list`

**Status: NEW.** The core of the layer. Everything else in this section depends on it.

**Effort: 1.0d.**

**Depends on:** `B-00` for `schemas/person.md`, `B-02` for `ge init`, `B-03` for the snapshot ring, `B-01` for `lib/date_compat.sh` and the table helpers.

**Blocks:** `PPL-02` through `PPL-07`, and the amended `AB-01`, `A-01`, `A-02`.

**SNAPSHOT CHAIN.** `set` runs `ge snapshot people/<slug>.md` first and stops on non-zero. `add` does not snapshot and refuses when the file exists. `get` and `list` never write.

**What to do**

0. **Settle open question 5 before writing a line of this task.** It decides whether `schemas/person.md` exists as a file at all, and nine other sites move with it. The decision is recorded in part 10: `B-00`'s per-file set stands and `S-09` is not taken in version 1.0.
1. Supply `B-00` with the content of `/Users/pmudh/Documents/GitHub/Atlanta/plugins/growth-engine/schemas/person.md`, in the same five-section shape as the other schema files: what the file is for, that `ge person` is the single writer, the exact line format, a valid example block, an invalid example block with one sentence saying what is wrong.
   The content is parts 3 and 4 of this section: the key rules, the slug and collision rule, the required and optional fields, both status enums with the `D|` justification paragraph moved in verbatim, the sentence that `booked` covers any positive commitment including an order, the block list, the sentence that a person file never claims a local record and a remote record are the same person unless an id says so, and the sentence that `ge person` writes only a slug into `ops-log.md`.
   **Both example blocks use `example.com` addresses and invented handles**, per part 3's substitution table. `V-25` depends on it.
   If `B-00` has already run when this task starts, add the file here and move that task's acceptance from eight named files to nine in the same commit.
2. Create `/Users/pmudh/Documents/GitHub/Atlanta/plugins/growth-engine/scripts/lib/person.sh`, carrying the section 06 header template.
   `READS: growth-engine/people/*.md   WRITES: growth-engine/people/ (sole writer)`.
   It holds: `person_slug <key>`, `person_norm_email`, `person_norm_handle`, `person_file_for_key <key>` implementing the derive-and-probe rule from part 3, `person_field <file> <name>`, `person_set_field <file> <name> <value>`, `person_each` implementing the sanctioned enumeration from part 4, `person_csv_cell <value>` implementing the quoting rule from part 4, `person_validate <file>` returning the malformed-code list from part 4, and `person_strip_cr`.
   Every read strips one trailing carriage return using `CR=$(printf '\r'); line=${line%"$CR"}`, never the bashism.
   Every read stops at the first `^## ` line. Every value write goes through `printf '%s'` with the value as an argument, and **no value is ever interpolated into a `sed` script or an `awk -v` assignment**, per part 4. `person_set_field` is written exactly as part 4 gives it.
   `LC_ALL=C` is set once at the top of `ge.sh` and every `sort` and `uniq` inherits it.
3. Add `person` to the dispatcher at `/Users/pmudh/Documents/GitHub/Atlanta/plugins/growth-engine/scripts/ge.sh`, and to the subcommand list at `06:903`.
4. Implement `ge person add`, exactly as part 5 specifies: the folded `--why-them`, `--priority`, `--note` and `--note-source` flags, the key-collision refusal, the deterministic `-2` to `-9` slug disambiguation with its printed note, and the refusal when all nine are taken. **There is no `--slug` flag.**
5. Implement `ge person set`, strict: unknown field refused with the valid list printed, bad enum refused with the allowed values printed, `key`, `kind` and `created` refused as immutable, newline in a value refused, `email_status` refused above `unverified` with `S-07` named.
6. Implement `ge person get`, with exit 2 for no such person and exit 1 for malformed. Accept a key as well as a slug, per part 3, in this verb and in every other verb that takes `<slug>`.
7. Implement `ge person list` with every filter in part 5, the `MALFORMED` row form which ignores every filter, one line per person on stdout and nothing else, and the near-duplicate advisory **on stderr** with a `ge person get` recovery.
8. Teach `ge init` in `B-02` to create `growth-engine/people/` with a `README.md` inside it carrying the two sentences from part 3, and to write `growth-engine/.gitignore` containing `people/` and `.state/` with a comment saying why. Regenerate `/Users/pmudh/Documents/GitHub/Atlanta/tests/fixtures/init-tree.txt` for both new files. Show the fixture diff in the commit body.
   The seed file is `README.md` and not `.gitkeep`: it is visible to `ls`, it is founder-readable, and it does not put a "commit this directory" marker in the one folder that must never be committed.
9. Print the one-time privacy line the first time `ge person add` creates a file in a `people/` folder that held only `README.md`.
10. Add `people/|ge person|internal` to `/Users/pmudh/Documents/GitHub/Atlanta/plugins/growth-engine/schemas/writers.md`, and widen `V-12`'s row grep from `^[a-z0-9.-]+\|` to `^[a-z0-9./-]+\|` so the row is not silently filtered out. Read `PPL-06` instruction 3 before writing the guard: `V-12` gives the person layer no behavioural coverage and the guard is a presence check, not a claim that it does.

**ACCEPT**

```sh
cd /Users/pmudh/Downloads/Atlanta/launchhouse-atlanta
rm -rf runs/ppl01 && mkdir -p runs/ppl01 && cd runs/ppl01
GE=/Users/pmudh/Documents/GitHub/Atlanta/plugins/growth-engine/scripts/ge.sh

sh "$GE" init
ls growth-engine/people/README.md                                   # must exist
grep -c 'people/' growth-engine/.gitignore                          # must print 1 or more
grep -c '.state/' growth-engine/.gitignore                          # must print 1 or more

# the empty folder is a zero count, not an error, which is the state of every machine on install day
sh "$GE" person list; echo "exit=$?"                                 # must print nothing and exit=0

sh "$GE" person add prospect Sofia.Mendes@BrightOps.co.uk "Sofia Mendes" \
  --company "BrightOps Facilities" --title "Operations Director" --source apollo \
  --why-them "the site lists three depots and no operations manager" \
  --note "Site lists three depots and no operations manager" --note-source "brightops.co.uk/about, read 2026-09-14"
ls growth-engine/people/                                            # must show sofia-mendes-brightops-co-uk.md
sh "$GE" person get sofia-mendes-brightops-co-uk key                 # must print the lowercased address
sh "$GE" person get sofia-mendes-brightops-co-uk why_them            # must print the one line, from the add
grep -c 'brightops.co.uk/about, read 2026-09-14' growth-engine/people/sofia-mendes-brightops-co-uk.md   # must print 1

sh "$GE" person add target ig @Carla.B.PT "Carla Bruno"
sh "$GE" person get ig-carla-b-pt key                                # must print ig:carla.b.pt

# a key resolves as well as a slug, everywhere
sh "$GE" person get sofia.mendes@brightops.co.uk company             # must print BrightOps Facilities
sh "$GE" person get ig:carla.b.pt name                               # must print Carla Bruno

# the same person twice is refused, and nothing is written
sh "$GE" person add prospect sofia.mendes@brightops.co.uk "Sofia M"; echo "exit=$?"
ls -A growth-engine/people/ | wc -l                                  # must print 3, two people plus README.md

# a different key deriving the same slug is disambiguated, not refused and not a --slug trap
sh "$GE" person add prospect sofia-mendes@brightops.co.uk "Sofia Mendes"; echo "exit=$?"
ls growth-engine/people/sofia-mendes-brightops-co-uk-2.md            # must exist
sh "$GE" person get sofia-mendes@brightops.co.uk key                 # must print sofia-mendes@brightops.co.uk
sh "$GE" person list | grep -c 'MALFORMED'                           # must print 0, the -2 file is a valid name
rm growth-engine/people/sofia-mendes-brightops-co-uk-2.md

# an enum from the wrong kind is refused, and the allowed values are printed
sh "$GE" person set ig-carla-b-pt status enrolled; echo "exit=$?"
sh "$GE" person set sofia-mendes-brightops-co-uk status opener_written; echo "exit=$?"

# an unknown field is refused, never written through and never dropped
sh "$GE" person set ig-carla-b-pt notes "hello"; echo "exit=$?"
grep -c '^notes: ' growth-engine/people/ig-carla-b-pt.md             # must print 0

# the key is immutable
sh "$GE" person set sofia-mendes-brightops-co-uk key other@x.com; echo "exit=$?"

# a value carrying the delimiter round-trips
sh "$GE" person set ig-carla-b-pt found_via "hashtag: bristolpt"
sh "$GE" person get ig-carla-b-pt found_via                          # must print hashtag: bristolpt

# a value carrying sed and awk metacharacters round-trips byte for byte
sh "$GE" person set ig-carla-b-pt link 'https://example.com/a?b=1&c=2'
sh "$GE" person get ig-carla-b-pt link                               # must print it exactly, & intact
sh "$GE" person set ig-carla-b-pt why_them 'runs C:\studio & books \n by hand'
sh "$GE" person get ig-carla-b-pt why_them                           # must print it exactly, backslashes intact

# email_status is closed until S-07 lands
sh "$GE" person set ig-carla-b-pt email_status valid; echo "exit=$?"  # must print exit=1 and name S-07
sh "$GE" person set ig-carla-b-pt email_status unverified; echo "exit=$?"

# no such person is exit 2, not exit 1
sh "$GE" person get nobody-at-all; echo "exit=$?"

# the founder's own prose under ## Yours is never parsed, so the file stays valid
printf 'Thinking out loud:\n\n- she runs two studios\n- status: still deciding\n' >> growth-engine/people/ig-carla-b-pt.md
sh "$GE" person list | grep -c 'MALFORMED'                           # must print 0
sh "$GE" person get ig-carla-b-pt status                             # must print the real status, once
sh "$GE" person set ig-carla-b-pt priority 1; echo "exit=$?"         # must print exit=0

# a malformed HEADER is surfaced, never skipped
sed -i.bak '/^created: /a\
this is not a field' growth-engine/people/ig-carla-b-pt.md
sh "$GE" person list | grep -c 'MALFORMED'                           # must print 1
sh "$GE" person list | wc -l                                         # must print 2, one line per person, advisory on stderr
sh "$GE" person list --kind prospect | grep -c 'MALFORMED'           # must print 1, filters never hide it
sh "$GE" person set ig-carla-b-pt priority 2; echo "exit=$?"         # must print exit=1
mv growth-engine/people/ig-carla-b-pt.md.bak growth-engine/people/ig-carla-b-pt.md

# CRLF cannot hide a field, and the line goes in the HEADER, where fields live
sed -i.bak "/^created: /a\\
priority: 2$(printf '\r')" growth-engine/people/sofia-mendes-brightops-co-uk.md
rm growth-engine/people/sofia-mendes-brightops-co-uk.md.bak
sh "$GE" person get sofia-mendes-brightops-co-uk priority            # must print 2, with no stray character

# every mutation snapshotted
ls growth-engine/.state/snapshots/ | grep -c 'people'
```

`ls people/README.md` must succeed, and both `.gitignore` greps must return 1 or more.
`ge person list` on the freshly seeded folder must print nothing and exit 0.
The lowercased key and the `ig:carla.b.pt` key must both print exactly.
Both key-form lookups must resolve to the same files the slug forms do.
The `--why-them` and `--note` values must be in the file after one `add`, with the attribution on the note line.
The duplicate add must print `exit=1` and the file count must stay at 3.
The colliding different key must print `exit=0`, must land at `-2`, and must not produce a `MALFORMED` row.
Both wrong-enum runs must print `exit=1` and must list the six values for the right kind.
The unknown field run must print `exit=1` and the `notes:` count must be 0.
The immutable key run must print `exit=1`.
`found_via` must print `hashtag: bristolpt`, proving the first-separator split.
The `link` and `why_them` round-trips must print byte for byte what was set, `&`, `?` and backslashes included. This is the write-safety rule in part 4 and it is the one an obvious `sed` implementation fails silently.
`email_status valid` must print `exit=1` and name `S-07`. `unverified` must print `exit=0`.
The missing person must print `exit=2`.
**The founder's prose under `## Yours` must produce no `MALFORMED` row and must not stop `set`.** A bullet, a blank line and a colon in their own text are theirs.
The malformed **header** line must appear in `list` as a `MALFORMED` row, must still appear under `--kind prospect`, and the strict `set` against it must print `exit=1`.
The CRLF field must print `2` and nothing else.
The person snapshot count must be 1 or more.

**COMMIT:** `PPL-01: the person file, its schema, and ge person add, set, get and list`

---

### PPL-02, the body blocks: `note`, `touch`, `opener`, `remove`, `purge`

**Status: NEW.** The half of a person file that a founder actually reads.

**Effort: 0.5d.**

**Depends on:** `PPL-01`, and `B-10` for `plugins/growth-engine/scripts/lib/blocks.sh`.

**Blocks:** `PPL-03`, `AB-01`, `A-01`.

**SNAPSHOT CHAIN.** `note`, `touch`, `opener` and `remove` run `ge snapshot people/<slug>.md` first and stop on non-zero. `purge` does not snapshot, because the snapshots are what it destroys.

**What to do**

1. Teach `ge person add` in `/Users/pmudh/Documents/GitHub/Atlanta/plugins/growth-engine/scripts/ge.sh` to seed all three blocks present and empty, plus the `## Yours` heading, so no verb ever has to create a block in a file a founder has been editing.
2. Implement `ge person note <slug> "<text>" [--source "<where>"]` against `block_write` from `lib/blocks.sh`. Entry format `- YYYY-MM-DD <text> (source: <where>)`, the clause omitted when there is no source. **Refuse a newline in the text or in `--source`**, same message and recovery as `set`.
3. Implement `ge person touch <slug> <channel> <direction> "<text>"`. Validate both vocabularies. Entry format `- YYYY-MM-DD <channel> <direction>: <text>`. **Refuse a newline.** Implement the one narrow status advance from part 5: `dm out` on a `kind: target` at `target` or `opener_written` also sets `status: sent` and prints both changes. Nothing else advances anything.
4. Implement `ge person opener <slug> --file <path>` and `ge person opener <slug> -`. Replace the block contents byte-exactly. Refuse more than one line when `kind: prospect`, naming the line count found. Refuse empty input.
5. Implement `ge person remove <slug>`: snapshot, delete, print the restore command with the stamp.
6. Implement `ge person purge <slug>` exactly as part 5 specifies: refuse unless `status` is `stopped` or `cut`, naming both values and the command that sets them; delete the person file and every snapshot of it; print the two counts and the line saying it cannot be undone; print no restore command.
7. Add `BADBLOCKLINE` to `person_validate`: a line inside `GE:TOUCH` or `GE:NOTES` that does not begin `- `. It is evaluated only inside those two marker pairs, per part 4.
8. Teach `ge person list --long` to derive the newest touch date, its direction, and whether the opener block has content. Derived at read time. Nothing is written back into the file.
9. Confirm `ge snapshot` and `ge restore` from `B-03` accept a path under `people/`, and that the snapshot name flattens the separator so `.state/snapshots/` stays a flat directory. If they do not, that is a one-line fix inside `B-03`, made here, with the reason in the commit body.
10. In the same one-line-fix spirit, raise `B-03`'s ring to **20 for paths under `people/`** and leave it at 10 everywhere else. Part 4 gives the reason: a kept prospect takes four or five snapshotted writes during the `A-01` build, and the argument for having no `--amend` on `ge person opener` depends on the previous opener still being in the ring afterwards.

**ACCEPT**

```sh
cd /Users/pmudh/Downloads/Atlanta/launchhouse-atlanta
rm -rf runs/ppl02 && mkdir -p runs/ppl02 && cd runs/ppl02
GE=/Users/pmudh/Documents/GitHub/Atlanta/plugins/growth-engine/scripts/ge.sh

sh "$GE" init
sh "$GE" person add target ig @nadia.restores "Nadia"
sh "$GE" person add prospect sofia@brightops.co.uk "Sofia Mendes"
grep -c 'GE:.*:START' growth-engine/people/ig-nadia-restores.md      # must print 3

sh "$GE" person note ig-nadia-restores "photographs the hinges" --source "her feed, read 2026-09-19"
sh "$GE" person touch ig-nadia-restores dm out "opener sent by hand"
grep -c '(source: her feed' growth-engine/people/ig-nadia-restores.md   # must print 1

# a multi-line opener is fine on a target
printf 'line one\nline two\n' | sh "$GE" person opener ig-nadia-restores -
sed -n '/GE:OPENER:START/,/GE:OPENER:END/p' growth-engine/people/ig-nadia-restores.md | grep -c 'line'

# and refused on a prospect, because it becomes a CSV cell
printf 'line one\nline two\n' | sh "$GE" person opener sofia-brightops-co-uk -; echo "exit=$?"
printf 'one line only\n' | sh "$GE" person opener sofia-brightops-co-uk -; echo "exit=$?"

# the founder's own text outside the markers survives a write
printf '\nmy own note about Nadia\n' >> growth-engine/people/ig-nadia-restores.md
sh "$GE" person note ig-nadia-restores "second note"
grep -c 'my own note about Nadia' growth-engine/people/ig-nadia-restores.md   # must print 1

# a half-marked file is refused, not guessed at
sed -i.bak '/GE:NOTES:END/d' growth-engine/people/ig-nadia-restores.md
sh "$GE" person note ig-nadia-restores "should not land"; echo "exit=$?"
grep -c 'should not land' growth-engine/people/ig-nadia-restores.md   # must print 0

# an invalid channel or direction is refused
sh "$GE" person touch sofia-brightops-co-uk pigeon out "hello"; echo "exit=$?"
sh "$GE" person touch sofia-brightops-co-uk email sideways "hello"; echo "exit=$?"

# a pasted newline is refused before it can shred a block
sh "$GE" person note sofia-brightops-co-uk "line one
line two"; echo "exit=$?"
grep -c 'line two' growth-engine/people/sofia-brightops-co-uk.md      # must print 0

# an outbound dm on a target carries the status with it, once, and only forwards
sh "$GE" person add target ig @sam.w "Sam W"
printf 'one line\n' | sh "$GE" person opener ig-sam-w -
sh "$GE" person set ig-sam-w status opener_written
sh "$GE" person touch ig-sam-w dm out "opener sent by hand"
sh "$GE" person get ig-sam-w status                                   # must print sent
sh "$GE" person touch ig-sam-w dm in "she replied"
sh "$GE" person get ig-sam-w status                                   # must still print sent

# remove snapshots first and names the way back
sh "$GE" person remove sofia-brightops-co-uk
ls growth-engine/.state/snapshots/ | grep -c 'sofia'

# purge refuses on a live status, and destroys everything on a settled one
sh "$GE" person add prospect gone@example.com "Gone Person"
sh "$GE" person note gone@example.com "asked to be removed" --source founder
sh "$GE" person purge gone@example.com; echo "exit=$?"                # must print exit=1, naming stopped and cut
sh "$GE" person set gone@example.com status stopped
sh "$GE" person purge gone@example.com > purge.out 2>&1; echo "exit=$?"   # must print exit=0
grep -c 'cannot be undone' purge.out                                  # must print 1
grep -c 'ge restore' purge.out                                        # must print 0, no restore is offered
ls growth-engine/people/gone-example-com.md; echo "exit=$?"           # must be non-zero, the file is gone
ls growth-engine/.state/snapshots/ | grep -c 'gone-example-com'       # must print 0
```

The block count on a fresh person must be 3.
The sourced note must appear once, with its attribution on the same line.
The target opener must show 2 lines. The prospect multi-line run must print `exit=1` and the single-line run `exit=0`.
The founder's own text must survive at count 1.
The half-marked run must print `exit=1` and must not write.
Both invalid vocabulary runs must print `exit=1` and list the allowed values.
The pasted newline must print `exit=1` and `line two` must not reach the file.
The `dm out` touch must move `opener_written` to `sent`. The `dm in` touch must leave it at `sent`.
The removal snapshot count must be 1 or more.
`purge` on a live status must print `exit=1` and name `stopped` and `cut`. `purge` on a `stopped` person must print `exit=0`, must leave no file and no snapshot, must say it cannot be undone, and must offer no restore.

**COMMIT:** `PPL-02: person notes, touch log, opener block, removal and purge`

---

### PPL-03, the exports, and the divergence check that keeps them honest

**Status: NEW.** Closes the one failure this change would otherwise introduce: a corrected opener in a person file, an uncorrected copy in the file the gate reads.

**Effort: 0.5d.**

**Depends on:** `PPL-02`, `B-06` for `ge lint`.

**Blocks:** `AB-01`, `A-01`, and gate items B7 and C4.

**SNAPSHOT CHAIN.** `export` runs `ge snapshot <export file>` first and stops on non-zero.

**What to do**

1. Implement `ge person export firstlines`, writing `growth-engine/outreach-firstlines.csv` whole, sole writer, header row `"email","first_name","company","first_line","status"`.
   One row per `kind: prospect` with `status` not `cut`, sorted under `LC_ALL=C` by slug.
   **Every cell is wrapped in double quotes and every embedded double quote is doubled**, per part 4, header row included. `person_csv_cell` from `PPL-01` does it and nothing writes a cell any other way.
   `first_name` falls back by part 3's rule, first whitespace token with a trailing comma and a trailing period stripped. The counts of fallbacks and of empty openers print to stdout, never into the file, because a comment line in the header breaks the Apollo import.
2. Implement `ge person export openers`, writing only the `GE:TARGETS` block inside `growth-engine/dm-openers.md` through `lib/blocks.sh`, sorted by `priority` then slug with an absent `priority` sorting as 3. The pacing warning, the targeting narrative and everything else in that file belong to `audience-b2c` and the founder, and are never touched.
3. Both refuse while any person file is malformed, exit 1, and name every file they could not parse.
4. **Amend `B-03` in one line: `ge snapshot` on a target that does not exist is a success and a no-op**, printing nothing and exiting 0. Made here, in this commit, with the reason in the commit body, in the same way `PPL-02` instruction 9 amends `B-03` for paths under `people/`.
   Without it the first `ge person export firstlines` on every founder machine fails, because the export snapshots a CSV that the export itself is about to create for the first time, and the writing rule is fail-closed. That is 65 B2B machines failing step 8 with a recovery line about a snapshot problem that does not exist.
   A failed copy of a file that **is** there still exits 1 and still stops the write.
5. Add to `ge lint` in `B-06`, warn-only, one warning each:
   - a `kind: prospect` row in `outreach-firstlines.csv` whose `first_line` cell differs from the first line of that person's opener block, compared as **the first 40 characters of each after unquoting the cell**, which is the shape the existing `content-30.csv` divergence check already uses at `02:848`
   - a person with `kind: target` and `status` at or beyond `opener_written` who has no entry inside `GE:TARGETS` in `dm-openers.md`
   - an `O|` or `D|` row surviving in `ledger.md`, per part 6
   - a person with no `first_name` whose derived fallback is not a plain alphabetic word of two or more characters, with the recovery `ge person set <key> first_name "<name>"`
   - each with a `→` recovery naming `ge person export` or `ge person set`
6. Add `--strict` to `ge lint`: identical output, exit 1 when any warning was emitted. The founder-facing default stays warn-only and exit 0. `PPL-06` changes `V-11`'s harness line to use it. Without the flag `schemas/person.md` cannot carry an invalid example block, because `V-11` reads a zero exit as valid.
7. Change `audience-b2c`'s write model for `dm-openers.md` from whole-file rewrite to `block_ensure` plus a preserve-everything-outside-markers write, per part 7. Its other two files are unchanged. Amend `02:1284`, `08:125` and `08:127` in the same commit, per part 10.
8. Retire `prospects-25.csv`. It is exactly "the person files where status is not cut" and keeping it creates the second copy this task exists to prevent. `prospects-35.csv` stays, relabelled in `A-01` and in section 04 as the raw search output on a stated date, written once and never updated.

**ACCEPT**

```sh
cd /Users/pmudh/Downloads/Atlanta/launchhouse-atlanta
rm -rf runs/ppl03 && mkdir -p runs/ppl03 && cd runs/ppl03
GE=/Users/pmudh/Documents/GitHub/Atlanta/plugins/growth-engine/scripts/ge.sh

sh "$GE" init
sh "$GE" person add prospect sofia@brightops.co.uk "Sofia Mendes" --company BrightOps
sh "$GE" person add prospect tom@ardenfm.co.uk "Tom Hale" --company "Arden FM, Ltd"
sh "$GE" person set tom-ardenfm-co-uk status cut
printf 'Three depots and no ops manager listed.\n' | sh "$GE" person opener sofia-brightops-co-uk -

# the very first export has nothing to snapshot, and that is a success, not a failure
ls growth-engine/outreach-firstlines.csv; echo "exit=$?"  # must be non-zero, it does not exist yet
sh "$GE" person export firstlines; echo "exit=$?"         # must print exit=0
wc -l < growth-engine/outreach-firstlines.csv            # must print 2, header plus Sofia, never Tom
head -1 growth-engine/outreach-firstlines.csv            # must print "email","first_name","company","first_line","status"

# a comma in a company and a comma and a quote in an opener survive the round trip
sh "$GE" person set tom-ardenfm-co-uk status candidate
printf 'She said "three depots", which is the whole problem.\n' | sh "$GE" person opener tom-ardenfm-co-uk -
sh "$GE" person export firstlines
wc -l < growth-engine/outreach-firstlines.csv            # must print 3, header plus two
grep -c '"Arden FM, Ltd"' growth-engine/outreach-firstlines.csv     # must print 1
grep -c '""three depots""' growth-engine/outreach-firstlines.csv    # must print 1
awk -F'","' 'NR>1 {print NF}' growth-engine/outreach-firstlines.csv | sort -u   # must print 5 only
sh "$GE" lint | grep -c 'outreach-firstlines.csv'        # must print 0, the divergence check unquotes correctly

# export twice with no change is byte identical
cp growth-engine/outreach-firstlines.csv first.csv
sh "$GE" person export firstlines
cmp first.csv growth-engine/outreach-firstlines.csv; echo "exit=$?"  # must print exit=0
sh "$GE" person set tom-ardenfm-co-uk status cut

# the divergence check fires when the export goes stale
printf 'A different opening line entirely.\n' | sh "$GE" person opener sofia-brightops-co-uk -
sh "$GE" lint | grep -c 'outreach-firstlines.csv'        # must print 1 or more
sh "$GE" lint | grep -c '→'                              # every warning carries its recovery
sh "$GE" person export firstlines
sh "$GE" lint | grep -c 'outreach-firstlines.csv'        # must print 0

# the openers export writes only inside its block
sh "$GE" person add target ig @carla.b.pt "Carla Bruno"
printf 'Saw your Monday post.\n' | sh "$GE" person opener ig-carla-b-pt -
sh "$GE" person set ig-carla-b-pt status opener_written
printf '# DM openers\n\nSend these by hand, spread out.\n' > growth-engine/dm-openers.md
sh "$GE" person export openers
grep -c 'Send these by hand' growth-engine/dm-openers.md  # must print 1
grep -c 'carla.b.pt' growth-engine/dm-openers.md          # must print 1 or more

# the skill's own re-write of dm-openers.md must not destroy the exported block.
# audience-b2c now writes everything outside the markers and never truncates the file,
# so its re-run looks like this and the block must come through untouched.
sed -n '/GE:TARGETS:START/,/GE:TARGETS:END/p' growth-engine/dm-openers.md > block-before.txt
printf 'Send these by hand, spread out. No more than two an hour.\n' >> growth-engine/dm-openers.md
sed -n '/GE:TARGETS:START/,/GE:TARGETS:END/p' growth-engine/dm-openers.md > block-after.txt
cmp block-before.txt block-after.txt; echo "exit=$?"      # must print exit=0, byte identical

# a malformed header line stops the export rather than shrinking it
sed -i.bak '/^created: /a\
garbage line' growth-engine/people/ig-carla-b-pt.md
sh "$GE" person export openers; echo "exit=$?"
mv growth-engine/people/ig-carla-b-pt.md.bak growth-engine/people/ig-carla-b-pt.md

# and the founder's own prose under ## Yours does not
printf 'My own thinking:\n\n- she posts on Tuesdays\n- status: maybe\n' >> growth-engine/people/ig-carla-b-pt.md
sh "$GE" person export openers; echo "exit=$?"            # must print exit=0
```

The first export must print `exit=0` against a CSV that does not exist yet. That is the snapshot no-op, and without it this line fails on every founder machine.
The CSV must have 2 lines and must not contain Tom, because Tom is `cut`.
The header must be the five quoted column names, in that order.
The comma in `Arden FM, Ltd` and the doubled quotes in the opener must both appear, and every data row must have exactly five fields when split on `","`. An unquoted comma shows up here as a 6.
The divergence check must stay quiet against a correctly quoted CSV, which proves it unquotes rather than compares raw.
Two consecutive exports with nothing changed must be byte identical.
The stale export must produce a divergence warning, and re-exporting must clear it.
The arrow count must equal the warning count.
The founder's own line in `dm-openers.md` must survive at count 1, and the target must appear inside the block.
The `GE:TARGETS` block must be byte identical before and after a write to the rest of that file.
The malformed **header** run must print `exit=1` and name the file.
The founder's prose under `## Yours` must print `exit=0`. It is their text, it is never parsed, and it can never stop an export.

**COMMIT:** `PPL-03: person exports, and the divergence check that keeps them honest`

---

### PPL-04, retire `O|` and `D|` from the ledger

**Status: NEW.** The point of no return. After this, people live in one place.

**Effort: 0.25d.**

**Depends on:** `PPL-01`. Do not run it before `PPL-01` is green, because between the two there is nowhere for a person to live.

**Blocks:** `A-02`, and the `status` and `gate` rewires.

**What to do**

1. Edit `/Users/pmudh/Documents/GitHub/Atlanta/plugins/growth-engine/schemas/ledger.md`: delete the `O|` and `D|` grammars, change "all three of them" to one, and add a pointer line to `schemas/person.md`. Move the paragraph explaining why the `D|` row existed into `schemas/person.md` verbatim.
2. Edit `/Users/pmudh/Documents/GitHub/Atlanta/plugins/growth-engine/scripts/ge.sh`: remove `add-outreach`, `set-outreach`, `add-dm` and `set-dm` **if `B-05` has already executed and built them**. If the `B-05` amendment in instruction 6 landed before `B-05` ran, they were never built and there is nothing to delete. Check first, then do one or the other. The two cases cannot both be true and the acceptance grep passes either way.
3. Make `ge ledger list O` and `ge ledger list D` exit 1 with a `→` line naming `ge person list --kind prospect` and `--kind target`. A removed verb must not return success.
4. Narrow `ge lint`'s ledger legs to `C|` only, and add the surviving-row warning from part 6.
5. Update `/Users/pmudh/Documents/GitHub/Atlanta/plugins/growth-engine/schemas/writers.md` so `ledger.md` reads content only.
6. Amend `B-05` in section 02 in the same commit: heading, status note, verb list, acceptance lines and commit line, and move 0.25d of its effort into this section's total.
   **The 0.25d is a saving only if this amendment lands before `B-05` executes.** If `B-05` has already built the four verbs, the quarter day was spent and `PPL-04` is deleting work rather than avoiding it. The effort table in part 12 says so in the same words, because a saved day and a wasted day look identical in a total.

**ACCEPT**

```sh
cd /Users/pmudh/Documents/GitHub/Atlanta
grep -c '^O|' plugins/growth-engine/schemas/ledger.md      # must print 0
grep -c '^D|' plugins/growth-engine/schemas/ledger.md      # must print 0
grep -c 'schemas/person.md' plugins/growth-engine/schemas/ledger.md   # must print 1 or more
grep -c 'add-outreach\|set-outreach\|add-dm\|set-dm' plugins/growth-engine/scripts/ge.sh   # must print 0

cd /Users/pmudh/Downloads/Atlanta/launchhouse-atlanta
rm -rf runs/ppl04 && mkdir -p runs/ppl04 && cd runs/ppl04
GE=/Users/pmudh/Documents/GitHub/Atlanta/plugins/growth-engine/scripts/ge.sh
sh "$GE" init
sh "$GE" ledger add-content 1 1 short-post text
sh "$GE" ledger list C | wc -l                             # must print 1
sh "$GE" ledger list O; echo "exit=$?"                     # must print exit=1
sh "$GE" ledger list D; echo "exit=$?"                     # must print exit=1
sh "$GE" ledger list O 2>&1 | grep -c 'ge person list'     # must print 1
sh "$GE" ledger add-outreach a@b.com A B; echo "exit=$?"   # must print exit=1

# a stale row is warned about, never rewritten
printf 'O|old@x.com|Old|OldCo|enrolled|y\n' >> growth-engine/ledger.md
sh "$GE" lint | grep -c 'O|'                               # must print 1 or more
sh "$GE" lint; echo "lint exit=$?"                         # must print lint exit=0, warn-only
```

Both schema counts must be 0 and the pointer must be present.
The removed verbs must not appear in `ge.sh`.
`list C` must still work. `list O` and `list D` must print `exit=1` and name `ge person list`.
The stale row must produce a warning, and lint must still exit 0 because it is warn-only.

**COMMIT:** `PPL-04: retire the O and D ledger rows, people live in growth-engine/people`

---

### PPL-05, rewire the three skills that write people

**Status: NEW.** Amends `AB-01`, `A-01` and `A-02` rather than replacing them.

**Effort: 0.5d.**

**Depends on:** `PPL-03`, `PPL-04`.

**Blocks:** `X-01`, `R-01`, gate items B7, C4 and C13.

**What to do**

1. Edit `/Users/pmudh/Documents/GitHub/Atlanta/plugins/growth-engine/skills/outreach-b2b/SKILL.md` to the call sequence in part 7, including the sentence that the twenty five first lines exist locally whatever Apollo does, and the decision that all 35 get a file with the 10 cut carrying `status: cut`.
2. Edit `/Users/pmudh/Documents/GitHub/Atlanta/plugins/growth-engine/skills/audience-b2c/SKILL.md` to the call sequence in part 7. Keep every existing sentence about sending by hand word for word. Add nothing that reads as a queue.
3. Edit `/Users/pmudh/Documents/GitHub/Atlanta/plugins/growth-engine/skills/status/SKILL.md` so it reads content from `ge ledger list C` and people from `ge person list`. Two sources, named as two.
4. Edit `/Users/pmudh/Documents/GitHub/Atlanta/plugins/growth-engine/commands/gate.md` so the B2C gate counts person files. Section 02's open question about whether the gate counts rows or falls back to file presence is now settled by construction: the count and file presence are the same fact.
   Write the C13 fallback into this file as well as into `schemas/gates.md`: when no person file is at `status: sent`, the gate asks, records the answer, passes on the answer, and prints the one `ge person touch` command that turns it into evidence.
5. Edit `/Users/pmudh/Documents/GitHub/Atlanta/plugins/growth-engine/schemas/gates.md`: item C13 changes from `self-reported` to `file-backed`, verified as at least one target at `status: sent`, **with the asked-and-recorded fallback stated in the same row**. Item B7 and item C4 change their evidence path to the person files.
   The fallback is not a softening. Without it a founder who sent all twenty five from their phone and did not reopen the terminal fails a gate that says they did nothing, and that reads the same as a founder who sent none. Part 7 has the reasoning and the printed form.
6. Edit `/Users/pmudh/Documents/GitHub/Atlanta/plugins/growth-engine/skills/growth-plan/SKILL.md` to read counts only, never a name, note or opener.
7. Edit `/Users/pmudh/Documents/GitHub/Atlanta/plugins/growth-engine/docs/manual-route.md`, per the amendment row for `04:187`: recording a send by hand is `ge person set <email> status contacted_ok`, taking the address from column one of the printed CSV, and the CSV's fifth column is the tick column. The words "in the ledger" come out.
8. Every founder-facing string these six files gain uses the **key** form, never a slug. `ge person set sofia.mendes@brightops.co.uk status contacted_ok`, not a 28 character filename nobody can guess.

**ACCEPT**

```sh
cd /Users/pmudh/Documents/GitHub/Atlanta
B=plugins/growth-engine/skills/outreach-b2b/SKILL.md
C=plugins/growth-engine/skills/audience-b2c/SKILL.md
grep -c 'ge person add prospect' $B          # must print 1 or more
grep -c 'ge person export firstlines' $B     # must print 1 or more
grep -c 'ge ledger add-outreach' $B          # must print 0
grep -c 'ge person add target' $C            # must print 1 or more
grep -c 'ge person export openers' $C        # must print 1 or more
grep -c 'ge ledger add-dm' $C                # must print 0
grep -ci 'by hand' $C                        # must print 1 or more
grep -c 'ge person list' plugins/growth-engine/skills/status/SKILL.md
grep -c 'ge ledger list C' plugins/growth-engine/skills/status/SKILL.md
grep -ci 'file-backed' plugins/growth-engine/schemas/gates.md
bash scripts/validate.sh
```

Then the two dry runs, as `AB-01` and `A-01` already specify:

```sh
GE=/Users/pmudh/Documents/GitHub/Atlanta/plugins/growth-engine/scripts/ge.sh
cd /Users/pmudh/Downloads/Atlanta/launchhouse-atlanta/runs/b2c-ecom-ab01
ls growth-engine/people/*.md | grep -vc '/README\.md$'                  # must print 25
grep -l '^kind: target' growth-engine/people/*.md | wc -l               # must print 25
sh "$GE" person list --kind target | wc -l                              # must print 25
sh "$GE" lint | grep -c 'WARN'                                          # must print 0

cd /Users/pmudh/Downloads/Atlanta/launchhouse-atlanta/runs/b2b-arc
ls growth-engine/people/*.md | grep -vc '/README\.md$'                  # must print 35
grep -l '^status: cut' growth-engine/people/*.md | wc -l                # must print 10
sh "$GE" person list --kind prospect --status cut | wc -l               # must print 10
sh "$GE" person list --kind prospect | wc -l                            # must print 35
wc -l < growth-engine/outreach-firstlines.csv                           # must print 26
```

Every positive grep must return 1 or more, every retired grep must return 0.
The B2C run must leave exactly 25 target files and 0 lint warnings.
The B2B run must leave exactly 35 person files, 10 of them `cut`, and a CSV of 26 lines.

The `README.md` exclusion in the two `ls` lines is the seed file from `PPL-01`. It is the one `.md` in `people/` that is not a person, and every count in this plan excludes it the same way.

The two `ge person list | wc -l` lines count stdout only, which is exactly one line per person, per part 5.
The near-duplicate advisory is on stderr by construction, so a 35-prospect Apollo list with `sam@acme.com` and `sam.j@acme.com` in it does not move these numbers. That is the whole reason the advisory is not on stdout.

validate.sh must report 0 FAILs.

**COMMIT:** `PPL-05: outreach-b2b, audience-b2c, status and gate write and read people`

---

### PPL-06, the checks and the golden case

**Status: NEW.** Without this the layer rots quietly, which is the failure mode the dependency map was written to prevent.

**Effort: 0.5d**, including the 0.1d the golden suite gains under the precedent at `03:1785`.

**Depends on:** `PPL-04`.

**Blocks:** `CI-01`, `R-02`.

**What to do**

1. Add checks `V-22` to `V-25` to `/Users/pmudh/Documents/GitHub/Atlanta/scripts/validate.sh`, exactly as part 11 specifies. `V-25` is a content rule, not a file list. Read part 11 before writing it.
2. Amend `V-11`'s fixture builder: add `mkdir -p "$(dirname "$box/growth-engine/$target")"` before the `awk` redirect. Without it `schemas/person.md`, whose target is two levels deep, reports `BADVALID` and `BADINVALID` and a reader edits a schema that is fine.
   Change the harness's lint line to `"$GE" lint --strict --root "$box/growth-engine"`, using the flag `PPL-03` adds. Without it the invalid person example passes, because every person fault is warn-only and warn-only lint always exits 0. That conflict predates this section and is named in the amendment table at `03:940 to 945`.
3. Amend `V-12`: the widened row grep from `PPL-01`, plus a guard that the loop actually ran over the map.
   **Say what this does and does not buy, in the check's own comment.** `V-12` skips every row whose mode is `internal`, `append-only` or `DEFERRED` before any leg runs, so `people/|ge person|internal` is skipped exactly as `ledger.md` is skipped, and `NOSNAP` and `TWOWRITERS` never evaluate for the person layer. Widening the grep lets the row enter the loop and then be discarded.
   So the guard is a presence check and is written as one: `schemas/writers.md` contains a row whose file field is `people/`, and the number of rows the loop saw equals the number of non-blank non-comment lines in the map.
   **Implement the count against a file, never a shell variable.** The `while` loop is the right-hand side of a pipe, so it runs in a subshell and a counter incremented inside it is lost in the parent. Write each row seen to `"$TMP/writers.rows"` and compare `wc -l < "$TMP/writers.rows"`.
   Do not record `D-5` as answered by behavioural coverage. The person layer's snapshot-first guarantee is proved by the golden suite, and part 11 says so.
4. Amend `V-16`, two legs:
   - refuse any field name in `schemas/person.md` matching `queue`, `scheduled_send` or `send_at`, and any skill line that pairs `ge person` with a scheduling word
   - refuse any line in `lib/person.sh` or in `ge.sh`'s person dispatch that writes a `name`, `email`, `handle`, `company` or `title` value into `ops-log.md`. Only a slug and a verb go there, per part 3, and `ops-log.md` is append only so nothing written there can be taken back out
5. Renumber the golden case `09-remember` to `11-remember.sh`, resolving the live collision with the existing `09-date-compat.sh`, and update `03:1785`.
6. Add `/Users/pmudh/Documents/GitHub/Atlanta/tests/cases/12-person.sh` with fixtures under `/Users/pmudh/Documents/GitHub/Atlanta/tests/fixtures/12-person/`, covering every case in part 11.
   Commit the expectations with `LC_ALL=C` set, per part 4, or they encode the executor's locale and fail on Git Bash.
7. Narrow `/Users/pmudh/Documents/GitHub/Atlanta/tests/cases/05-ledger.sh` to `C|` rows, and add the two refusal cases for `list O` and `list D`.
8. Add person faults to `/Users/pmudh/Documents/GitHub/Atlanta/tests/fixtures/lint-seeded` and move `B-06`'s seeded WARN count to match, stating the new number in that task. The faults seeded are one of each: `BADLINE` in the header, `BADENUM`, `DUPFIELD`, `BADNAME`, `BADBLOCKLINE` and a `first_name` fallback that is not a plain word.

**ACCEPT**

```sh
cd /Users/pmudh/Documents/GitHub/Atlanta
bash scripts/validate.sh; echo "validate exit=$?"
sh tests/run.sh; echo "tests exit=$?"
ls tests/cases/ | grep -c '09-remember'      # must print 0
ls tests/cases/11-remember.sh
ls tests/cases/12-person.sh

# each new check fails when the thing it guards is broken, then passes again
sed -i.bak 's/^people\/|ge person|internal$//' plugins/growth-engine/schemas/writers.md
bash scripts/validate.sh | grep -c 'writers'; mv plugins/growth-engine/schemas/writers.md.bak plugins/growth-engine/schemas/writers.md

printf 'key: real@person.com\nkind: prospect\n' > plugins/growth-engine/assets/examples/b2b-northfield/leak.md
bash scripts/validate.sh; echo "leak exit=$?"      # must be non-zero
rm plugins/growth-engine/assets/examples/b2b-northfield/leak.md
bash scripts/validate.sh; echo "validate exit=$?"  # must be 0 again

# and the documented person header in the two founder-facing docs must NOT fail
grep -c '^kind: prospect$' plugins/growth-engine/docs/USING-IT.md          # must print 1 or more
grep -c '^kind: prospect$' plugins/growth-engine/docs/TROUBLESHOOTING.md   # must print 1 or more
grep -rc 'example.com' plugins/growth-engine/schemas/person.md             # must print 1 or more
bash scripts/validate.sh; echo "docs exit=$?"      # must be 0, V-25 permits reserved domains
```

`validate exit=0` and `tests exit=0` on a clean tree.
The old golden case name must be gone and both new ones present.
Each deliberate break must be caught and each restore must go green.
The two founder-facing documents must carry a worked person header and must still pass, which is the whole reason `V-25` is a content rule rather than a file list.

**COMMIT:** `PPL-06: validator checks, golden case 12-person, and the schema example path fix`

---

### PPL-07, the documents, and the privacy exclusions

**Status: NEW.** The person layer creates twenty five well-formed, machine-readable files of names, companies, titles and email addresses per founder. Everything in this task exists so none of them reaches a public repository or a printer.

**Effort: 0.5d.**

**Depends on:** `PPL-05`.

**Blocks:** `X-01`, `D-03`, `EX-02`, `EX-05`, `EX-11`, `R-02`.

**What to do**

1. Add `growth-engine/people/` to `X-01`'s example exclusion list at `02:1832`, alongside `.state/`, `ledger.md` and `ops-log.md`, with the sentence saying it is a privacy line rather than a tidiness line. As written today the list reads as machine files only, so a careful executor copies `people/`.
2. Exclude `people/` from `scripts/import-example.sh` entirely, and say why: no scrub pattern in that gate matches a name, a company, a job title or an email address, and no naive pattern should be added because a name pattern false-positives on everything. Exclusion, not detection.
3. Decide once and record: **no example folder ever contains a `people/` directory.** So the example file count at `03:2697` does not move. The only person-shaped data anywhere in the public repository is the valid and invalid example blocks inside `schemas/person.md`, both invented.
4. Add `growth-engine/people/` to the playbook exclusion list at `07:89`, even though `PB-01` is deferred, because that skill compiles a document headed for a print run.
5. Add one line to `docs/CONNECTIONS.md` through `G2-03`: person files never leave the machine. Nothing syncs them to GoHighLevel, to Apollo, or anywhere else. The file looks like a CRM and founders will assume it syncs.
6. Add a person section to `docs/USING-IT.md` through `D-06`: what is in a person file, that the header fields and the marked blocks are `ge`'s, that everything under `## Yours` is theirs and is never read by `ge` for any purpose, how to correct a fact, how to cut someone without losing why, and that the folder never leaves their machine. Add the `people/` row to the hand-edit file map, with the nuanced answer stated rather than implied.
   The worked header in this section uses an `example.com` address, per part 3, so `V-25` permits it.
   Every command in this section is written in the key form: `ge person set sofia.mendes@example.com status contacted_ok`. The word slug does not appear in any founder-facing document.
7. Add a paragraph to that same section naming **OneDrive, iCloud Drive, Dropbox and Google Drive**, by name, and saying to move the working folder if it sits inside one.
   On current Windows, `Documents` and `Desktop` are OneDrive-backed by default, so a founder who opens Claude Code there has twenty five to thirty five files of real names, companies, titles and email addresses replicating to a consumer cloud account without ever choosing that.
   The paragraph says the two things a founder can act on: where to check, and that moving the folder is the fix. It does not lecture.
   `ge init` writes `growth-engine/.gitignore` covering `people/` and `.state/`, per `PPL-01` instruction 8, which handles the git half. Nothing in software handles the sync half, which is why this is a paragraph and not a check.
8. Add three entries to `docs/TROUBLESHOOTING.md` through `D-07`: "I edited a person file by hand", "the same person is in there twice", and "someone asked me to delete their details".
   The third one is `ge person purge`. It says the status has to be `stopped` or `cut` first, that the file and every snapshot go, that there is no way back, and that a slug stays in `ops-log.md`.
9. Update `04:824`'s sharing warning: the folder now contains a file per person, so send the specific file, never the folder.
10. Add `people/` with its `README.md` to the seeded `growth-engine/` folder inside the `D-03` zip, add `.gitignore` beside it, and regenerate the zip fixture.
11. Add one row to section 07's risk table: the founder's working folder is cloud-synced or git-tracked, likelihood high on Windows, impact 25 to 35 real people's details in a consumer cloud account, mitigation the `.gitignore`, the printed line and the USING-IT paragraph. It is the only risk row in the plan about the founder's own machine rather than a vendor.

**ACCEPT**

```sh
cd /Users/pmudh/Documents/GitHub/Atlanta
grep -c 'people/' scripts/import-example.sh                            # must print 1 or more
grep -rc 'people' plugins/growth-engine/docs/CONNECTIONS.md
grep -c 'people/' plugins/growth-engine/docs/USING-IT.md
grep -ci 'OneDrive' plugins/growth-engine/docs/USING-IT.md             # must print 1 or more
grep -ci 'iCloud\|Dropbox\|Google Drive' plugins/growth-engine/docs/USING-IT.md   # must print 1 or more
grep -ci 'person file' plugins/growth-engine/docs/TROUBLESHOOTING.md
grep -ci 'delete their details' plugins/growth-engine/docs/TROUBLESHOOTING.md     # must print 1 or more
grep -rc 'slug' plugins/growth-engine/docs/USING-IT.md                 # must print 0
find plugins/growth-engine/assets/examples -type d -name people | wc -l   # must print 0
find plugins/growth-engine/assets/examples -type f | wc -l                # must match 03:2697 unchanged
bash scripts/build-folder.sh && unzip -l dist/*.zip | grep -c 'people/README.md'   # must print 1
bash scripts/build-folder.sh && unzip -l dist/*.zip | grep -c '.gitignore'         # must print 1 or more

# the privacy guard fires if an executor copies a person folder into an example
mkdir -p plugins/growth-engine/assets/examples/b2b-northfield/growth-engine/people
printf 'key: a@b.com\nkind: prospect\nname: A\n' > plugins/growth-engine/assets/examples/b2b-northfield/growth-engine/people/a-b-com.md
bash scripts/validate.sh; echo "exit=$?"     # must be non-zero, naming the file
rm -rf plugins/growth-engine/assets/examples/b2b-northfield/growth-engine
bash scripts/validate.sh; echo "exit=$?"     # must be 0
```

Every doc grep must return 1 or more, except the `slug` grep, which must return 0: the founder-facing documents use the key form throughout.
The four named cloud services must appear in USING-IT, and the deletion entry must appear in TROUBLESHOOTING.
The example person directory count must be 0 and the example file count must be unchanged.
The zip must carry `people/README.md` and `.gitignore`.
The deliberate leak must fail the build and name the file, and removing it must go green.

**COMMIT:** `PPL-07: person layer documents, and the exclusions that keep people off the internet`

---

### Placement, dependencies and the cut order

| task | phase | depends on | blocks |
|---|---|---|---|
| `PPL-01` | 2, after `B-10` | `B-00`, `B-01`, `B-02`, `B-03` | `PPL-02` to `PPL-07`, `AB-01`, `A-01`, `A-02` |
| `PPL-02` | 2 | `PPL-01`, `B-10` | `PPL-03`, `AB-01`, `A-01` |
| `PPL-03` | 2 | `PPL-02`, `B-06` | `AB-01`, `A-01`, gates B7 and C4 |
| `PPL-04` | 2 | `PPL-01` | `A-02`, `PPL-05` |
| `PPL-05` | 8, with the skills | `PPL-03`, `PPL-04` | `X-01`, `R-01`, gates B7, C4, C13 |
| `PPL-06` | 2 | `PPL-04` | `CI-01`, `R-02` |
| `PPL-07` | 7, with the documents | `PPL-05` | `X-01`, `D-03`, `EX-02`, `EX-05`, `EX-11`, `R-02` |

**Cut order: append as position 10.** Do not insert, because `08:279` records `B-10` as position 5 of 9 and inserting above it makes that line wrong immediately.

**The cut is only available before `PPL-04` lands.** `PPL-04` retires the ledger rows, and after that there is no other home for a person, so the layer stops being optional.
Say that in the cut order row, because a cut list entry that cannot be taken after a certain commit is worse than no entry at all.

---

## 10. The amendment table

Every row `09b-people-dependency-map.md` named is below. Nothing from it is dropped.
Where the resolution differs from what that note proposed, the difference is stated in the row.

**Eleven rows below are not in that note.** Ten are sites the map missed, found by reading the source files: `02:707 to 713`, `02:817` and `02:826`, `02:1324`, `02:1336`, `03:955 to 970`, `04:187`, `04:566`, `04:886`, `05:1045`, and `08:120 to 121`.
The eleventh is a correction: the five deleted `B-05` acceptance lines are `808, 809, 812, 813, 823`, not `811`. Line 811 is `sh $GE ledger list C --status approved`, and deleting it breaks the assertion at 822.
The table opens with a promise of completeness, so a miss ships as a regression. These are named rather than folded in quietly.

### `08-persistent-memory.md`

| Line | What changes |
|---|---|
| 26 | The porting table row reversed. `A people directory with typed notes and a projector` becomes **Yes, with the projector dropped**. The reason cell, today `A second entity store is not earned`, is replaced: at twenty five people the store is one file per person and the projector is what is not earned. The "what we do instead" cell names `growth-engine/people/`, `ge person`, section 09, and that `O|` and `D|` are retired rather than derived. This is the single most load-bearing contradiction in the plan, and the option 2 decision reverses it in writing rather than by implication |
| 120 to 121 | The byte-exact marker rule gains one sentence: **markers are matched byte-exactly after one trailing carriage return is stripped, and the stripping applies to marker lines as well as to field lines.** Without it a founder who saves a person file in Notepad turns every marker into a non-match and every block write into a `HALFMARKED` refusal, which is the precise Notepad scenario part 4 of section 09 says it is guarding against |
| 125 | `**Where blocks apply.** memory.md, in the six blocks above.` becomes `memory.md`, `growth-engine/people/*.md` and `growth-engine/dm-openers.md`. The next sentence, `Nothing else adopts markers in version 1.0.`, is deleted |
| 127 | **Changed, not unchanged.** It closes with `Nothing else adopts markers in version 1.0.`, which is now false three ways. It is rewritten to name the three file classes that do, and to say that `dm-openers.md` is block-shared between `audience-b2c` and `ge person export openers` while person files are `ge person`'s alone |
| 150 | The CRLF example gains person files. This is the enum that most needs it, because a founder will open a person file in Notepad |
| 184 | `B-10`'s dependency line unchanged. `PPL-02` depends on `B-10` for `lib/blocks.sh` |
| 192 | `blocks.sh` now has two consumers, so its `WRITES:` line and its scope comment change |
| 266 | The schema count moves again, from 8 to 9, for `schemas/person.md`. See cluster C-1 below, which settles the count for good |
| 270 | The definition-of-done precedent is followed again. See cluster C-9 |
| 280 | `B-10` stays cut position 5 of 9. The person layer appends as position 10 |

### `00-scope.md`

| Line | What changes |
|---|---|
| 12 | The outbound row gains one clause: every one of those people gets a file in `growth-engine/people/`. B2B is 35 files with 10 at `status: cut` |
| 14 | The brain's component list gains "a per-person entity layer", pointing at section 09 as it already points at section 08 |
| 76 to 78 | No change. It is the constraint the file format satisfies, and the reason the file is `key: value` lines rather than JSON |
| 82 | No change, and the person file must not gain a field that reads as a send queue. `touch` records what the founder tells it |
| 88 | No change. `people/` is inside `./growth-engine/` |

### `01-state.md`

| Line | What changes |
|---|---|
| 43 | No change, `schemas/` already covers it |
| 28 to 29 | **No change.** `ge person` ships with no command file, so the skill and command counts stay still. See cluster C-8 |

### `02-build-steps.md`

| Line | What changes |
|---|---|
| 96 to 105 | The effort table gains the `PPL-01` to `PPL-07` rows and the total moves from 44.95 to 48.70. The re-sum note below it is restated |
| 107 to 125 | The cut order gains one row at position 10, carrying the "only available before `PPL-04`" condition |
| 122 | Cut 9's cost line changes: the founder still has all 25 first lines locally even if the Apollo write-back dies |
| 141 | **No change.** `ge index` stays out of `ledger.md`. Under the rejected lead proposal this line became a ledger mutation and every skill needed a snapshot inserted, which is on its own a sufficient argument |
| 578 | `### B-00, write the eight schema files` becomes nine |
| 588 | The body count becomes nine, and a ninth numbered item is added for `schemas/person.md` |
| 591 | `the row formats, all three of them` becomes one |
| 592 | The `C|` grammar unchanged. It becomes the only grammar in the file |
| 593 | The `O|` grammar deleted. Its four facts become header fields in `schemas/person.md` and its status enum moves verbatim |
| 594 | The `D|` grammar deleted. Its justification paragraph moves into `schemas/person.md`, because it is the record of why two enums exist |
| 613 | `grep -c '^D|' schemas/ledger.md` inverted to assert 0 |
| 618 | The acceptance changes from a bare count to nine named files, tested one at a time, so a later added file cannot break it |
| 620 | The writer count becomes 9 |
| 620 | The `D|` assertion deleted |
| 622 | The commit line number moves |
| 681 | `ge init` seeds `people/` with a `README.md` carrying the two privacy sentences, and writes `growth-engine/.gitignore` covering `people/` and `.state/`. Not a `.gitkeep`: a "commit this directory" marker in the one folder that must never be committed signals the opposite of the intent, and it is invisible to `ls` |
| 686 | `tests/fixtures/init-tree.txt` regenerated for both new files. Every test comparing against it fails until it is, which is correct |
| 707 to 713 | **`B-03` gains one line: `ge snapshot` on a target that does not exist is a success and a no-op**, printing nothing and exiting 0. Made in `PPL-03` instruction 4. Without it the first `ge person export firstlines` fails on every founder machine, because the export snapshots a file it is about to create. A failed copy of a file that does exist still exits 1 |
| 707 to 713, again | `B-03` accepts a path under `people/` and flattens the separator in the snapshot name, per `PPL-02` instruction 9, and its ring becomes 20 for paths under `people/` and stays 10 everywhere else, per `PPL-02` instruction 10 |
| 786 | `### B-05, ge ledger, three row types and the approve transition` becomes one row type |
| 788 | The `D|` status note rewritten. The representable state now exists in the person file |
| 790 | Effort drops by 0.25d, which moves into this section's total |
| 794 | The surface becomes `add-content`, `set-content`, `list [--status X]`. Three verbs removed |
| 795 | `add-dm` and `set-dm` deleted from `B-05`, re-specified as `ge person add target` and `ge person set` |
| 808, 809, 812, 813, 823 | Those five acceptance lines and assertions deleted from `B-05` and replaced by `PPL-01`'s and `PPL-04`'s. **The row previously read 811. It is 812.** Line 811 is `sh $GE ledger list C --status approved`, and deleting it breaks the assertion at 822. `sh $GE ledger list D` is at 812. Verified in the source file |
| 817, 826 | `B-05`'s ledger snapshot count assertion, `must be 5 or more`, drops to 3 once four verbs go. Both sites move together |
| 848 | The `content-30.csv` divergence check is the precedent the person export divergence check copies: first 40 characters against first 40 characters. Unchanged, and named here so nobody invents a second comparison shape |
| 828 | The commit line rewritten |
| 847 | The lint leg splits. Ledger narrows to `C|`. A person leg is added: required fields present, `kind` valid, `status` valid for that `kind`, key matches filename, no duplicate key across files |
| 851 | No change in contract. Every new person warning carries a runnable `ge person` recovery |
| 858 | The seeded WARN count moves as person faults are added to `tests/fixtures/lint-seeded`. `PPL-06` states the new number |
| 921 | `ge check` gains a person leg in the `PASS or FAIL, evidence, fix` shape, following section 08's memory precedent |
| 993 to 1007 | `PPL-01` to `PPL-04` and `PPL-06` sit immediately after the `B-10` stub. `B-10` gains a blocks entry for `PPL-02` |
| 1126 | No change. `C-01` touches only `C|` rows |
| 1284 | `AB-01`'s snapshot chain rewritten to `ge person add target` then `ge person opener` then `ge person set <key> status opener_written`, and it gains the snapshot posture sentence, because a person write is a write. **`dm-openers.md` also changes write model here**, from whole-file rewrite to `block_ensure` plus a preserve-everything-outside-markers write, because `ge person export openers` owns the `GE:TARGETS` block inside it. Without this row a skill re-run destroys twenty five exported openers, which is the two-writers failure this section rejects the lead proposal for. The skill's other two whole-file rewrites are unchanged |
| 1324 | `AB-01`'s `sh $GE ledger list D | head -3` exits 1 after `PPL-04` and must go. It becomes `sh $GE person list --kind target | head -3` |
| 1336 | `AB-01`'s commit line ends `ledger-backed DMs`. It becomes person-backed |
| 1292 | Step 5 rewritten as person files. The de-duplication reason gets stronger: a file keyed on a slug cannot be added twice |
| 1308 | `grep -c 'ge ledger add-dm' $S` becomes `grep -c 'ge person add target' $S` |
| 1323 | `grep -c '^D|' growth-engine/ledger.md` becomes `ls growth-engine/people/*.md | wc -l` |
| 1333 | The assertion becomes 25 person files with `kind: target`. **First of the four loud failures if missed** |
| 1642 to 1676 | `D-03`'s seeded folder inside the zip gains `people/` with its `README.md`, and `.gitignore` beside it, and the zip fixture is regenerated |
| 1711 to 1756 | `CI-01`'s check list gains the person structural checks and the `people/` scan. Item 11's hard-coded counts do not move, because no command ships |
| 1832 | `X-01`'s exclusion list **must gain `people/`**, on privacy grounds. This is the worst outcome in the dependency map and the guard is one line |
| 1860 | No change, it was already scoped to `C`. A person count line is added beside it |
| 1866 | The arc completeness assertion gains `people/` with a per-route expected count: 35 for b2b, 25 for each b2c route |
| 2151 | `A-01`'s snapshot chain rewritten to `ge person add prospect` per contact |
| 2162 | Step 8 gains `ge person opener <slug>` before the Apollo write-back, so the founder keeps the 25 lines whatever Apollo does |
| 2166 | Step 12 rewritten. Every prospect lands as a person file |
| 2179 | `grep -c 'ge ledger add-outreach' $S` becomes `grep -c 'ge person add prospect' $S` |
| 2185 | `grep -c '^O|' .../runs/b2b-arc/growth-engine/ledger.md` becomes the two-part person count: 35 files, 10 `cut`, 25 not |
| 2191 | The assertion becomes 35 person files with 25 not `cut`. **Second of the four** |
| 2201 | `A-02`'s dependency line loses `AB-01 (the D| rows)` and gains `PPL-04` |
| 2205 | Step 1 becomes content from `ge ledger list C`, people from `ge person list`. Two sources, two commands, no derived middle |
| 2207 | Step 3's open choice is settled by construction: the gate counts person files, and file presence and the count are the same fact |
| 2219 | `grep -c 'D|' skills/status/SKILL.md` becomes `grep -c 'ge person list'`. **Left as is it returns 0 and fails, which is the correct loud failure. Third of the four** |

The fourth loud failure is `B-00`'s `grep -c '^D|' schemas/ledger.md` at line 613.

### `03-review-process.md`

| Line | What changes |
|---|---|
| 56, 1770 | No change. The golden trigger paths already cover a new subcommand |
| 1784 to 1789 | The precedent is followed for `ge person`. **The `09-remember` collision with the existing `09-date-compat.sh` is resolved rather than compounded**: `remember` becomes `11-remember.sh`, person becomes `12-person.sh` |
| 1812 to 1822 | `05-ledger.sh` narrows to `C|` and gains the two refusal cases. `12-person.sh` is added |
| 1843 | Still true. The person analogue is added: a header field that lost its colon |
| 940 to 945 | `schemas/person.md` gains valid and invalid example blocks. **A pre-existing conflict surfaces here and is resolved rather than inherited**: `V-11`'s harness maps a zero exit from `ge lint` to `pass`, `B-06` fixes lint as warn-only and always exit 0, and every person fault is warn-only, so the invalid example would pass and the harness would print `BADINVALID` on a clean tree. `PPL-03` adds `ge lint --strict`, exit 1 when any warning was emitted, and `PPL-06` changes the harness line to use it. The founder-facing default does not move |
| 955 to 970 | The harness lint line becomes `"$GE" lint --strict --root "$box/growth-engine"` |
| 962 | **The fixture builder gains `mkdir -p "$(dirname ...)"`.** A person example's target is two levels deep and the builder does not create the parent, so both blocks fail and a reader edits a schema that is fine |
| 999 to 1006 | The writers map gains three rows, not one. **The map grammar gains a directory form and a block-ownership form**, both decided here once rather than discovered by `V-12` at build time: `people/\|ge person\|internal` for the directory, `outreach-firstlines.csv\|ge person\|internal` because that file's owner moves from the `outreach-b2b` skill to `ge person export firstlines`, and `dm-openers.md\|audience-b2c\|blocks:GE:TARGETS=ge person` for the one file with two legitimate writers. Without the third form `V-12` prints a false `TWOWRITERS` on the first run after `PPL-03`, and the only quiet fix is weakening the check, which is the outcome this section calls unacceptable |
| 1017, 1024 | The row grep widens to `^[a-z0-9./-]+\|` and a presence guard is added. **State what it buys.** `V-12` hits `case "$mode" in internal\|append-only\|DEFERRED) continue ;;` before any leg runs, so an `internal` row is discarded and `NOSNAP` and `TWOWRITERS` never evaluate for the person layer, exactly as they never evaluate for `ledger.md`. Widening the grep lets the row enter the loop and then be discarded, so it delivers no behavioural coverage and must not be recorded as if it does. The guard is written as a presence check: a row whose file field is `people/` exists, and the rows the loop saw equal the non-blank non-comment lines in the map. **Counted against `wc -l < "$TMP/writers.rows"`, never a shell variable**, because the loop is the right-hand side of a pipe and runs in a subshell |
| 1036 | No change |
| 622 to 674 | One line added: `V-07` does not cover personal data. Person files are not secrets and the secret scan does not look for names or addresses. The guard is exclusion, in `PPL-07` |
| 1325 to 1372 | `V-16` extended: a person field named `queue`, `scheduled_send` or `send_at` fails the build |
| 2528 | The rehearsal's engine 2 step gains: and 25 person files exist afterwards, with the right kind and status |
| 2705 | Release gate 5 gains a person line: the arc left the right number of person files per route with valid statuses |
| 2697 | **Settled: the example file count does not move**, because no example folder contains `people/` |
| 2803 | The regeneration map row `ledger.md O rows` becomes `people/ prospect files` |
| 2804 | The row `ledger.md D rows` becomes `people/ target files` |
| 2813 | What a `ge` change stales gains person file formatting, and the remedy gains a person regeneration step |
| 2824 to 2832 | No new `.generated-with` row. `ge person` ships no template of its own |

### `04-examples-and-docs.md`

| Line | What changes |
|---|---|
| 158 | The example ledger loses "plus the route's outreach or DM rows" and its size band drops. No `people/` row is added, because examples carry none |
| 183 | `prospects-35.csv` **survives**, relabelled as the raw search output on a stated date, written once and never updated |
| 184 | `prospects-25.csv` is **retired**. It is exactly the person files where status is not `cut`, and keeping it is the second copy that creates staleness |
| 186 | `outreach-firstlines.csv` becomes an **export**, generated by `ge person export firstlines`, never hand-edited, with a divergence check behind it. It gains a fifth column, `status`, so the printed sheet is still a checklist on the manual route. Every cell is quoted, per part 4 |
| 187 | `manual-route.md` says today that it explains how to record sends **in the ledger** by hand. There is no ledger row to record into after `PPL-04`. It becomes: tick the printed sheet's `status` column as you go, and run `ge person set <email> status contacted_ok` when you are back at the machine, taking the address from column one |
| 197 | `dm-openers.md` keeps its narrative and pacing warning and gains a `GE:TARGETS` managed block that `ge person export openers` owns. **Its write model changes with it**: `audience-b2c` writes it through `block_ensure` plus a preserve-everything-outside-markers write, never a whole-file rewrite, or a skill re-run destroys the exported block. See the `02:1284` row and `08:125` and `08:127` |
| 344, 366 to 400, 416 | No change |
| 433 | The example staleness map row `the outreach rows of ledger.md` becomes `the prospect files under people/`, noting they are not exported to examples |
| 434 | The B2C half gains the target files under `people/`. It does not currently name the ledger at all, which was already a gap |
| 453 | The fiction rule gains two clauses: and invented person files, and **every person example in the repository uses `example.com`, `example.org` or `example.net` and an obviously invented handle**. That second clause is what makes `V-25` implementable as a content rule, so the two founder-facing documents can carry a worked person header and a real one still fails the build |
| 566 | `EX-11` is listed as blocked by `PPL-07` and needs a row of its own: its clearance walk gains `growth-engine/people/` as a directory it must confirm is absent from every example folder, and its evidence line names the count as 0 |
| 461 | The highest-risk row **must name `people/` as a second route in**. The person layer creates 25 well-structured files of exactly this data per founder |
| 470 to 478 | The two-pass fiction procedure applies to person files and must say so explicitly, because a reader will assume it covers only the CSVs it names |
| 479 | Gains: nor may 25 person files name 25 real Instagram accounts |
| 487 to 494 | **`people/` is excluded from `import-example.sh` entirely**, with the reason: no pattern there matches a name, a company, a title or an address, and a name pattern would false-positive on everything. Exclusion, not detection |
| 505 to 512 | `EX-05`'s clearance list gains every person file key and company field, which is trivially satisfied because there are none |
| 562 to 566 | `EX-02` and `EX-05` gain person scope. `EX-03` unaffected |
| 697 to 706 | `docs/CONNECTIONS.md` gains one line: person files never leave the machine |
| 748 to 760 | The USING-IT file map gains a `people/` row with the nuanced answer stated: the founder may edit outside the markers and under `## Yours`, and may not edit the header fields or inside the blocks |
| 753 | The first-lines CSV row changes: it is regenerated from person files, so correct the person file and re-export |
| 824 | The sharing warning updated: the folder contains a file per person |
| 860 to 900 | TROUBLESHOOTING gains "I edited a person file by hand", "the same person is in there twice" and "someone asked me to delete their details" |
| 886 | Item 25, "I edited the ledger by hand", **is rewritten rather than left beside two new entries**. It is the person analogue that founders will hit, because nobody hand-edits a `C|` row and everybody opens a person file. It keeps its ledger half in one sentence and gains the person half: what `ge` owns, what is theirs, and what a `MALFORMED` row means |
| 991 | No change |
| 1005 | One clarifying clause: a GoHighLevel test contact is not a person file |

### `05-routes-and-platforms.md`

| Line | What changes |
|---|---|
| 96 to 105 | The route axis table gains a row: what the person layer holds per route. b2b 35 prospect files, b2c 25 target files each |
| 793, 855, 908 | No change |
| 858 | `25 O rows in the ledger` becomes `35 prospect files under people/, 25 of them not cut` |
| 883 | No change to the row |
| 884 | **The manual route keeps its checklist.** The CSV is an export, so ticking it records nothing, but the export gains a fifth column, `status`, so the printed sheet is still who, the opening line, and a column to tick. When the founder is back at the machine they run `ge person set <email> status contacted_ok`, taking the address out of column one. **Not a slug.** Twenty five hand-typed 28 character filenames is a clear regression from a spreadsheet with a checkbox, and every verb takes a key, per part 3 |
| 911 | The b2c journey's engine 2 output gains 25 target files under `people/`. It did not mention the `D|` rows at all, which was already a gap |
| 919 to 925 | No change, and the person layer does not soften it. `touch` records what the founder did, after the fact |
| 1037 | No change. Item A8 was already `C|` scoped |
| 1059 | Gate item B7 verified against the person files, with the CSV named as the export. Left as is, a founder who corrects a first line passes B7 against a stale copy |
| 1061 | No change, item B9 is verified in Apollo |
| 1076 | Gate item C4 verified by counting person files with `kind: target`, with `dm-openers.md` as the readable form |
| 1079 | No change |
| 1045 | The `test contact` line gains the same clarifying clause as `04:1005`: a GoHighLevel test contact is not a person and gets no person file. Named in `D-15` alongside `04:1005` and missed by the first draft of this table |
| 1088 | **Item C13 becomes file-backed**: at least one person file at `status: sent`. `schemas/gates.md`'s marking changes in the same commit, or the gate keeps asking and keeps ignoring the file, and 65 founders are graded on an answer rather than on evidence. **With the fallback in the same row**: when no person file is at `sent`, the gate asks, records the answer, passes on the answer, and prints the one `ge person touch` command that turns it into evidence. Without the fallback a founder who sent all twenty five from their phone and did not reopen the terminal fails a gate that says they did nothing, on the busiest afternoon of the event, and that reads the same as a founder who sent none |
| 1103, 1105 | The promises do not change. The evidence path does |

### `06-code-standards.md`

| Line | What changes |
|---|---|
| 117 | No change to the template. `lib/person.sh` fills it in with a directory value |
| 230 to 237 | A person example is added showing the directory form, which is a shape the one-writer rule has never had to express |
| 897 | The code block becomes `ge ledger add-content | set-content | list` and gains `ge person add | set | get | list | note | touch | opener | remove | purge | export`. **This block is already stale: it omits `add-dm`, `set-dm`, `approve`, `receipt`, `accounts` and `remember`.** Fix all of it in the same commit |
| 903 | The dispatcher list gains `person` |
| 904 | The naming rule constrains the new verbs: `ge person add`, never `ge p`, and never both `add` and `create` |
| 906 | Sub-verbs follow the hyphenation rule. None of the eleven needs a hyphen |
| 1083 | No change to the check, but it must accept a directory value without complaint |

### `07-quality-and-simplicity.md`

| Line | What changes |
|---|---|
| 15 | The scope summary gains the person layer in one clause, matching `00:12` |
| 17 | The brain summary gains it. The managed-block exception sentence already generalises and needs only its file list widened |
| 72 | **`people/` joins the playbook privacy finding and makes it worse** |
| 87 | Reinforced with one sentence. This is now a stronger argument for the deferral holding |
| 89 | The exclusion list gains `growth-engine/people/` |
| 251 | The state model inventory gains `people/`. It is also still missing `memory.md`, which section 08 added and this line never caught up with |
| 249 | `S-08`'s heading count moves. A heading with arithmetic in it goes stale silently |
| 281 to 288 | The state tree gains `├── people/   one writer: ge person`, and `memory.md`, which is already missing |
| 290 | The number in "Five things" moves. **The second half of that sentence, "nothing derived sitting on disk pretending to be truth", is the argument against the lead proposal, stated by the plan itself before the question was asked** |
| 304 | `S-09`'s schema list names `C|` only and points at the person format. See cluster C-1 |
| 475 | The `R-03` Apollo risk row's impact column improves: a failed `first_line` write-back loses the automation, not the founder's 25 lines |
| 475, new row | **The risk table gains one row that is about the founder's own machine rather than a vendor.** The working folder is cloud-synced or git-tracked. Likelihood high, because `Documents` and `Desktop` are OneDrive-backed by default on current Windows. Impact 25 to 35 files of real names, companies, titles and email addresses replicating to a consumer cloud account. Mitigation: `ge init` writes `growth-engine/.gitignore` covering `people/` and `.state/`, `ge person add` prints one line the first time it creates a person, and `docs/USING-IT.md` names the four services and says to move the folder |
| 529 | The `B-05` surface quoted inside `F-03` is rewritten. It quotes `[C|O]` where section 02 says `[C|O|D]`, so it was already one version behind |
| 581 | `F-04`'s artifact list: the CSV is the export, the person files are the record |
| 585 | `F-04`'s state landing rewritten as person files, and the founder-typed command changes |
| 600 | `F-05`'s state landing rewritten. **The principle in its second clause survives verbatim: the record holds what the toolkit did or what the founder told it, never an inference.** That is hard constraint 5 in the plan's own words |
| 852 | Item 24 holds, and must say so: the person layer is written through `ge person`, not by a skill directly, so no reviewer reads it as uncovered |
| 892 | Item 26 no change |
| 909 | Item 32's check moves to a person file count |
| 911 | Item 33 gains 25 target files |
| 936 | Item 49 gains: nor an invented person presented as real, and no real person at all |
| 938 to 942 | Three person items added **after** the renumbering in cluster C-9, never before it |

### `DELIVERY-PLAN.md`

| What | Change |
|---|---|
| The sections table | Gains a row 09 pointing at `delivery/09-people-layer.md` |
| The effort figures | 44.95 becomes 48.70, in the intro and in the split table's first row |
| The id-series table | Gains `PPL-` as a build-task prefix counted in the total, defined in section 09 |
| The "what changed" note | Gains a dated paragraph recording the option 2 decision and the `O|` and `D|` retirement |

### The clusters that must move together

The `C-` ids below are local to this section. They name clusters of facts that must change together, and they are not build tasks.

Each is one fact stated in more than one place. Change one without the others and the plan disagrees with itself.

| # | Fact | Sites | Resolution |
|---|---|---|---|
| C-1 | The schema file count | 02:578, 02:588, 02:591 to 597, 02:618, 02:620, 02:622, 08:265, 07:296 to 311 | **Settled: nine files, named individually in the acceptance rather than counted.** `writers.md` is created by `V-12`'s work and is not in `B-00`'s set, so a bare `ls | wc -l` would break the moment it lands. Fix the three-way existing disagreement in the same commit |
| C-2 | The ledger row grammars | 02:591, 02:592 to 594, 03:940 to 945, 07:304, 04:158, 06:897, 07:529, 02:794 | One grammar, `C|`. 07:304, 07:529 and 06:897 were already stale and are corrected in the same pass |
| C-3 | The two status enums | 02:593, 02:594, 07:585, 07:600, 02:1284, 05:1088 | Both move to `schemas/person.md` **unchanged**. Every consumer keeps its meaning |
| C-4 | The number 25, per route | 02:1333, 02:2191, 05:858, 05:911, 05:1059, 05:1076, 05:1103, 05:1105, 07:15, 07:581, 07:909, 07:911, 00:12, 04:184, 04:186, 04:197 | The number does not change. What is counted changes, in all sixteen |
| C-5 | The number 35, and the 10 cut | 00:12, 04:183, 04:184, 04:476, 07:15 | **Settled: all 35 get a file, the 10 cut carry `status: cut`.** Every B2B acceptance becomes a two-part count, written out in `PPL-05` |
| C-6 | The `ge` subcommand list | 06:897, 06:903, 02:794 to 796, 07:529 | Gains `person`. 06:897 and 07:529 were already behind 06:903 and are corrected in the same commit |
| C-7 | The one-writer state model | 07:281 to 290, 07:251, 03:999 to 1006, 00:14, 07:17, 06:230 to 237 | Gains `people/`, and gains `memory.md`, which is already absent from four of the six |
| C-8 | The skill and command counts | 01:28 to 29, 03:144, 03:152, 03:1472 to 1573, 02:1481, 02:1740, 00:54 | **No movement. `ge person` gets no command file.** Seven sites stay still |
| C-9 | The definition-of-done item numbers | 07:822 to 960 | Items 50, 51 and 52 each appear twice already. **Renumber first, in its own commit, then add the three person items** |
| C-10 | The golden test case numbers | 03:1812 to 1822, 03:1789 | `09-remember` collides with the existing `09-date-compat.sh`. **Resolved: `11-remember.sh` and `12-person.sh`** |
| C-11 | The build total | DELIVERY-PLAN.md:30, 02:96 to 105, 08:276 to 273 | 44.95 becomes 48.70, one arithmetic chain |
| C-12 | The cut order positions | 02:107 to 125, 08:279, 00:54, 07:740 to 760 | **Append at position 10.** Inserting makes 08:279 wrong immediately |

### The silent-failure list, and where each is answered

The `D-` ids below are local to this section. They name ways this change could break something quietly, and they are not build tasks.

| # | What would break silently | Answered by |
|---|---|---|
| D-1 | Every `^O|` and `^D|` consumer reads a stale derived row and reports it as fact | Part 2. The class does not exist, because there is no derived copy |
| D-2 | The person exports become stale copies with no freshness check | `PPL-03`. The exports are generated by `ge person export` and `ge lint` compares them |
| D-3 | Gate C13 flips to file-backed and the marking in `schemas/gates.md` is not updated | `PPL-05` instruction 5, in the same commit as the gate rewrite |
| D-4 | `ge index` freshness stops covering the truth and the doctor keeps saying fresh | Part 6. One directory row in `.state/index.md`, count and newest-modified, no per-person fact |
| D-5 | `V-12`'s writers map skips the person layer entirely and prints ok | **Partly, and the rest is answered elsewhere.** `PPL-01` instruction 10 and `PPL-06` instruction 3 make the row present, visible and counted. They do not make `V-12` check the person layer's behaviour, because `V-12` discards every `internal` row before any leg runs, exactly as it does for `ledger.md`. The snapshot-first guarantee is proved by the golden suite in part 11 instead. Recording this row as fully answered would be the same silent pass the row is about |
| D-6 | `V-11`'s example harness cannot build a person fixture and fails misattributed | `PPL-06` instruction 2, one `mkdir -p` |
| D-7 | 25 person files make `ge undo` per-person and the operation un-undoable | Part 4. One file per invocation, no bulk verb, so `ge undo` always has one person candidate |
| D-8 | `ge lint` warns and a malformed person file is used anyway | Part 4. Writers and exports are strict and refuse. `ge lint` stays warn-only and surfaces |
| D-9 | Person files leak into the public repository through the example import | `PPL-07`, plus `V-24` and `V-25` in part 11. This is the worst outcome in the dependency map and it is now guarded three ways |
| D-10 | The CSV style blind spot widens to a second file class | `PPL-03`. `outreach-firstlines.csv` is generated from `.md` files that `validate.sh` does scan, so the text is style-checked at its source. Recorded at 04:352 |
| D-11 | The regeneration map stops naming the real artifact and staleness reports FRESH | The 03:2803 and 03:2804 rows above |
| D-12 | `ge context`'s fifteen-line ceiling silently drops the person layer | Part 8. The person layer takes no context line, so 02:912, 02:945 and 08:264 do not move |
| D-13 | `init-tree.txt` compares files only, so an empty `people/` passes untested | `PPL-01` instruction 8, the seeded `people/README.md`. It satisfies `find -type f` identically to a `.gitkeep`, it is visible to `ls` so counts written against the folder behave, and it tells the founder what the folder holds |
| D-14 | `ge ledger list O` and `list D` keep returning success after the rows are gone | `PPL-04` instruction 3, exit 1 with a recovery line |
| D-15 | The GoHighLevel contact and the person file are two records with no stated relationship | Part 3. `ghl_contact_id` and `apollo_contact_id`, written only when an API returned one, and the sentence in `schemas/person.md` |
| D-16 | The person folder sits in a cloud-synced or git-tracked working folder and 130 copies of real people's details leave the machine without anyone choosing it | Part 3, and `PPL-01` instruction 8 for the `.gitignore`, instruction 9 for the printed line, and `PPL-07` instruction 7 for the document. Not in the dependency map's original list, and the exposure it names is larger than several that were |
| D-17 | A prospect asks to be deleted and cannot be, because `remove` leaves the snapshots | Part 5, `ge person purge`, plus the rule that only a slug reaches `ops-log.md` and the `V-16` leg that enforces it |

### The open questions from the dependency map, answered

| # | Question | Answer |
|---|---|---|
| 1 | Do the 10 cut prospects get person files? | **Yes, with `status: cut`.** The enum already carries the value, and the cut reason is what stops the same company being rebuilt next month. Every B2B acceptance becomes a two-part count, written out in `PPL-05` |
| 2 | Do the CSVs and `dm-openers.md` survive as artifacts or become exports? | `prospects-35.csv` survives as the raw search output. `prospects-25.csv` is retired. `outreach-firstlines.csv` becomes an export. `dm-openers.md` survives with a managed block that the export owns |
| 3 | Does `ge person` get a command file? | **No.** It keeps cluster C-8's seven sites still, and `S-06` argues for shrinking the command surface rather than growing it |
| 4 | The `email_status` field from Apollo | Our own four values, `unverified|valid|risky|bounced`, marked UNVERIFIED MAPPING in `schemas/person.md`. Which Apollo field they read from is unknown until `S-07` and must not be invented. Until then only `unverified` is written |
| 5 | `S-09`'s two-file schema set against `B-00`'s per-file set | **Settled: `B-00`'s per-file set stands and `S-09` is not taken in version 1.0.** It cannot stay open, because cluster C-1 fixes the count at nine named files in six places and this question decides whether `schemas/person.md` is one of them. Left open, the two records contradict each other in writing, which is the cluster-drift pattern this section exists to prevent. The decision is taken **before `PPL-01` starts**, per that task's instruction 0. If `S-09` is ever revisited after v1.0.0, the person content becomes a section inside `schemas/state.md`, the count moves in all six sites together, and nothing else in section 09 changes |
| 6 | The golden test number and the definition-of-done number | Golden: resolved, `11-remember.sh` and `12-person.sh`. Definition of done: renumber first in its own commit, then add. Both are recorded in clusters C-9 and C-10 |

### The open questions from the prior-art reader, answered

Four questions came back from the field-by-field read of Glitch's person model in `09a-prior-art-glitch-people.md`.
None of them could be answered from the sources alone, and each is decided here rather than left for an executor to guess at.

| # | Question | Answer |
|---|---|---|
| 7 | The platform vocabulary conflict. The retired `D|` row allowed `ig\|fb\|other`. The prior art carries eight platforms | **Settled: three values, `ig`, `fb` and `other`, with `platform_label` carrying the real name when it is `other`.** Written out in part 3. B2C is documented as an Instagram and Facebook motion, which is what section 05 already says it is. Taking the eight would make `ge index` either downgrade a real platform to `other` and lose a fact, or refuse a valid person file and make it unindexable. The `D|` row is retired by this section, so there is no second vocabulary left to reconcile, and no amendment to section 05's platform list is needed |
| 8 | Whether a separate do-not-contact or stop flag is needed at all, given both status enums | **Settled: no second field.** The three cases are named in part 3 with the exact status each lands on: a prospect who asks to stop is `stopped`, a target who asks not to be messaged again is `no_reply`, and a person who asks to be deleted goes to `ge person purge`. A second axis on one person is the duplication trap the brief warns about, and it is how a founder ends up reading one answer while a gate reads another |
| 9 | Whether `tier` survives as an optional `priority` field, or is dead weight | **Settled: it ships as optional `priority`, 1 to 3, and it is measured before v1.0.0 freezes.** Part 3 gives the reasoning. It has a defined meaning when absent, so nothing branches on its presence, and it is the sort key for the printed sheet a B2C founder works down on the Saturday. The test is `PPL-05`'s two demo-founder runs. If both leave it empty on all twenty five rows it goes on the v1.1 cut list, not into v1.0 |
| 10 | Section 08's porting table says a people directory does **not** port, reason "A second entity store is not earned". The option 2 decision reverses that row | **Settled, and the edit is the `08:26` row in the amendment table above.** Both cells change: the verdict becomes yes with the projector dropped, and the reason cell is replaced, because at twenty five people it is the projector that is not earned rather than the store. Left as it is, the plan contradicts itself in writing on the single most load-bearing row it has, which is why that row is marked as such |

---

## 11. The new checks

### `scripts/validate.sh`

Four new checks, and three amendments to existing ones.

**V-22. No skill writes a person file directly.**
Catches a skill that tells Claude to write `growth-engine/people/<x>.md` itself, bypassing snapshot, validation and the slug rule.
Every line under `plugins/growth-engine/skills/` or `plugins/growth-engine/commands/` mentioning `growth-engine/people` must also mention `ge person`.
Prove it: add `write growth-engine/people/x.md` to any skill, confirm the failure, remove it, confirm green.

**V-23. The person exports are never hand-written.**
Catches the reintroduction of the stale-copy failure.
No skill may instruct writing `outreach-firstlines.csv` at all, and no skill may instruct writing inside the `GE:TARGETS` block of `dm-openers.md`. Both must name `ge person export`.
Prove it: replace `ge person export firstlines` in `outreach-b2b` with "write the CSV", confirm the failure.

**V-24. `people/` is on every exclusion list.**
A positive check, because this is the privacy guard and a missing line is invisible.
`people/` must appear in `X-01`'s exclusion text, in `scripts/import-example.sh`, and in the playbook exclusion list.
Prove it: delete the line from `import-example.sh`, confirm the failure.

**V-25. No real person's data anywhere in the repository.**

**It is a content rule, not a file list.** Scan every file under `plugins/` for a line matching `^key: .*@`, and fail when the domain on that line is not `example.com`, `example.org` or `example.net`. Fail on `^kind: (prospect|target)$` only in a file that also carries such a non-reserved `key:` line.
Any hit fails, naming the file and the line.

The first draft excluded `schemas/person.md` by name and nothing else, which fails the build on the two documents that most need a worked example: `PPL-07` puts a person header into `docs/USING-IT.md` and into `docs/TROUBLESHOOTING.md`, and both live under `plugins/`.
The likely repair would have been widening the exclusion to `docs/`, which removes the guard from the two founder-facing files most likely to be copy-pasted from. That is the wrong direction.
Part 3 requires every documented person to use a reserved domain, so the content rule permits every legitimate example and still catches a real one. The rule and the requirement land in the same commit or neither works.

This is the check that stands between a careless example copy and 25 real people in a public repository.
Prove it twice: drop a person file with a real domain into an example folder, confirm the failure and the named path, remove it, confirm green. Then confirm that the `example.com` header in `docs/USING-IT.md` passes.

**Amend V-11.** `mkdir -p "$(dirname "$box/growth-engine/$target")"` before the `awk` redirect, and change the lint line to `"$GE" lint --strict --root "$box/growth-engine"`.
The `--strict` flag comes from `PPL-03`. Without it every person fault is warn-only, warn-only lint always exits 0, the invalid example in `schemas/person.md` passes, the harness prints `BADINVALID`, and `validate.sh` fails on a clean tree. That conflict predates this section and is resolved rather than inherited.

**Amend V-12.** Widen the row grep to `^[a-z0-9./-]+\|` so the directory row enters the loop, and add a presence guard.

Say plainly what this buys, in the check's own comment and here: **`V-12` gives the person layer the same behavioural coverage it gives `ledger.md`, which is none.** Both are `ge`-written and both carry mode `internal`, and `V-12` runs `case "$mode" in internal|append-only|DEFERRED) continue ;;` before `NOSNAP` or `TWOWRITERS` evaluates. Widening the grep lets the row in and it is then discarded.
So the guard is a presence check, not a coverage claim: `schemas/writers.md` carries a row whose file field is `people/`, and the number of rows the loop saw equals the number of non-blank non-comment lines in the map.
**Count against a file, never a shell variable.** The `while` loop is the right-hand side of a pipe and runs in a subshell, so a counter incremented inside it is lost in the parent. Append each row seen to `"$TMP/writers.rows"` and compare `wc -l < "$TMP/writers.rows"`.
The person layer's snapshot-first guarantee is proved by the golden suite below instead, and the silent-failure row `D-5` says so rather than claiming a check that does not run.

**Amend V-16**, two legs.
Fail on a field name in `schemas/person.md` matching `queue`, `scheduled_send` or `send_at`, and on any skill line pairing `ge person` with a scheduling word. Design rule 1 is enforced in the vocabulary, not only in the prose.
Fail on any line in `lib/person.sh`, or in `ge.sh`'s person dispatch, that writes a `name`, `email`, `handle`, `company` or `title` value into `ops-log.md`. Only a slug and a verb go there. `ops-log.md` is append only, so a name written there survives `ge person purge` and cannot be taken back out, which would make the deletion path a half-truth.

### The golden suite

`tests/cases/12-person.sh`, fixtures under `tests/fixtures/12-person/`.
Every case below is byte-exact against a committed expectation, because the failure modes here are byte level.

| case | asserts |
|---|---|
| add both kinds | the file lands at the derived slug, the key is normalised, all three blocks are present and empty |
| add with `--why-them`, `--priority`, `--note` and `--note-source` | one invocation, one snapshot-free creation, all four values in the file, the attribution on the note line |
| add the same person twice | exit 1, nothing written, the file count unchanged |
| slug collision, different key | **exit 0**, the second person lands at `<slug>-2.md`, the printed line names the file already holding the other key, `ge person get <the second key>` finds it, and `ge lint` reports no `BADNAME` |
| ten different keys deriving one slug | the tenth exits 1, naming every key found, and writes nothing |
| set an unknown field | exit 1, the valid field list printed, the field absent from the file afterwards |
| set a status from the wrong kind's enum | exit 1, the right six values printed |
| set `key`, `kind` or `created` | exit 1, immutable |
| set `email_status` to anything but `unverified` | exit 1, `S-07` named in the message |
| a value containing `: ` | round-trips exactly through `get` |
| a `link` containing `/`, `?` and `&`, and a `why_them` containing `&` and a backslash | `set` then `get` returns them byte for byte. This is the case an obvious `sed` or `awk -v` implementation fails silently |
| a key used in place of a slug | every verb resolves it, and reaches the same file the slug form reaches |
| **founder prose under `## Yours` containing a colon, a bullet and a blank line** | **the file stays valid, no `MALFORMED` row, and every verb succeeds** |
| a duplicate single-valued field | reported `DUPFIELD`, never resolved as last wins |
| a line inside `GE:NOTES` that does not begin `- ` | reported `BADBLOCKLINE` |
| a newline passed to `set`, `note` or `touch` | exit 1, nothing written, same message and recovery in all three |
| a malformed file among four good ones | `list` shows all four people, one as `MALFORMED`, exit 0, and the other three are still usable |
| `list` under every filter with a malformed file present | the `MALFORMED` row appears under all of them, and stdout is exactly one line per person |
| the near-duplicate advisory | appears on stderr, never on stdout, and `list \| wc -l` is unchanged by it |
| a person file with CRLF throughout | every field parses, **every marker is found**, exit 0 |
| a half-marked block | every writing verb exits 1 and writes nothing |
| a multi-line opener on a prospect | exit 1, the line count named |
| founder text outside the markers | survives every block write, byte for byte |
| `list`, `check` and `index` on a `people/` folder holding only `README.md` | zero count, exit 0, no `No such file or directory` |
| `export firstlines` on a folder that has never been exported | the CSV is written and exit is 0. The snapshot of a target that does not exist is a success and a no-op |
| a company containing a comma, and an opener containing a comma and a double quote | both round-trip through `export firstlines` and through the divergence check, every data row splits into exactly five fields |
| `export` while a file is malformed | exit 1, the file named, no export written |
| `export` twice with no change | byte-identical output |
| the same fixture exported on two platforms | identical bytes. `LC_ALL=C` is set once at the top of `ge.sh` and a person with no `priority` sorts as 3 |
| `export openers`, then a write to the rest of `dm-openers.md` | the `GE:TARGETS` block is byte-identical afterwards |
| `purge` on a person at `candidate` | exit 1, naming `stopped` and `cut`, nothing deleted |
| `purge` on a person at `stopped` | exit 0, the file gone, every snapshot of it gone, no restore command printed |
| `ge ledger list O` and `list D` | exit 1, recovery names `ge person list` |
| a snapshot exists for every mutating verb | one per invocation, and never more than one person file per invocation |

`tests/cases/05-ledger.sh` narrows to `C|` rows and gains the last case above.
`tests/cases/09-remember.sh` becomes `tests/cases/11-remember.sh`, resolving the existing collision.

### `ge lint` and `ge check`

`ge lint` gains, warn-only, each with a `→` recovery:

- every malformed code from part 4, per file and per line, including `BADBLOCKLINE`
- a duplicate key across two files
- an export diverging from the person files, both directions, compared as the first 40 characters of each after unquoting the cell
- an `O|` or `D|` row surviving in `ledger.md`
- a person with `kind: target` at or beyond `opener_written` and an empty opener block
- a person with no `first_name` whose derived fallback is not a plain alphabetic word of two or more characters, with the recovery `ge person set <key> first_name "<name>"`
- a person count above 60, which at this scale means something imported that should not have

`ge lint --strict` is the same output with exit 1 when any warning was emitted. It exists for `V-11`'s harness, per part 11's `V-11` amendment. The founder-facing default is warn-only and exits 0, unchanged.

`ge check` gains one leg in the `PASS or FAIL, evidence, fix` shape every other doctor line uses:

```
people        PASS   35 files, 0 malformed, 0 duplicate keys, newest 2026-09-19 14:22
```

---

## 12. Effort

The same caveat the plan already carries applies here and matters more than the numbers.
**Day figures are relative weight, not calendar.** The unit is inherited from the PRD, which sized this work for a human writing the files by hand, and that is not what is happening.
Use these to say that `PPL-01` is twice `PPL-04`. Do not use them as a schedule.

| Task | Days | What dominates it |
|---|---|---|
| `PPL-01` | 1.00 | The schema content, `lib/person.sh`, and four verbs with strict validation and an honest malformed path. The folded `add` flags are inside this figure and they pay for themselves: they take about 70 invocations out of one `A-01` session |
| `PPL-02` | 0.50 | Five block verbs on top of `lib/blocks.sh`, which already exists. `purge` is small: a status check, two deletes and a receipt |
| `PPL-03` | 0.50 | Two exports, the CSV quoting rule, four divergence and quality checks, and the `--strict` flag. The checks are the half that matters |
| `PPL-04` | 0.25 | Deletion, plus making the removed verbs fail loudly |
| `PPL-05` | 0.50 | Three skills, two schema files, and the two dry runs that prove them |
| `PPL-06` | 0.50 | Four validator checks, three amendments, one golden case, including the 0.1d the suite gains under the precedent at `03:1785` |
| `PPL-07` | 0.50 | Documents and the three exclusion lists |
| **Total added** | **3.75** | |

`B-05` gives up 0.25d as the `D|` row leaves it, and that quarter day is already inside `PPL-04` above rather than added twice.

**That saving is conditional and the condition has to be stated.** It is a saving only if `PPL-04`'s instruction 6 amendment to `B-05` lands **before** `B-05` executes.
If `B-05` has already built `add-outreach`, `set-outreach`, `add-dm` and `set-dm`, the quarter day was spent and `PPL-04` is deleting work rather than avoiding it. The total does not move either way, but a saved day and a wasted day look identical inside one, and `PPL-04`'s instruction 2 branches on exactly this.

**The build total moves from 44.95 to 48.70 dev-days.**
That is the number in `DELIVERY-PLAN.md`, in section 02's effort table, and in section 08's arithmetic chain, and all three move together.

**None of it is on the critical path.**
The plan's own split says the constraint is the 4.45 nominal days of vendor and machine work: the paid GoHighLevel account, the seven-scope token, the paid Apollo seat, the connected Facebook Page, the three snapshots and three physical machines.
Every task in this section is file writing, which is the half that compresses.

**What is not in the 3.75 days** is the plan sweep itself: about 111 edits across 9 files, listed in part 10.
Those are edits to this plan rather than to the product, and they are done as part of accepting this section rather than as a task inside it.
They are also the reason part 10 exists in the shape it does.
The last cross-cutting change here was propagated by hand, reached some sections and not others, and produced 47 regressions.
