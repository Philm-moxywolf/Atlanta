# Prior art: how Glitch models a person, and what ports to POSIX shell at 25 people

Working note for the spec author. Not founder-facing. Not part of the delivery plan yet.

Sources read:

- `/Users/pmudh/Documents/GitHub/glitch/glitch-mem/_starter/people/_TEMPLATE.md` (in full)
- `/Users/pmudh/Documents/GitHub/glitch/.claude/scripts/people.py` (module docstring, key layer, slug rules)
- `/Users/pmudh/Documents/GitHub/glitch/.claude/scripts/entity_resolve.py` (contract and laws)
- Supporting, for the vocabularies and the rules that sit behind them: `people_vocab.py`, `people_resolve.py`, `people_norm.py`, `people_lint.py`, `entity_match.py`, `.claude/skills/person/SKILL.md`, `.claude/skills/capture-person/SKILL.md`

Quoting convention in this note: Glitch's own comments use em dashes, which are banned here.
Where I quote a line that contains one, I cut the quote at the dash and mark the cut with `...`.
Nothing inside a quotation mark has been reworded.

---

## 0. The short version

Glitch's person model is a personal CRM for a life.
Ours is a worksheet for 25 people the founder chose on purpose, over a 90 day window.
About a third of the template earns its place. The identity machinery almost entirely does not.

The one thing worth taking wholesale is not a field. It is the two layer split: the note is the source of truth, the typed rows are projected from it by a deterministic rebuildable projector, and a malformed note is flagged and skipped rather than allowed to corrupt the derived store.
That is the lead proposal in the task brief, already running in production against a real estate of notes.

---

## 1. Which fields earn their place

Glitch marks eight fields required and everything else optional, and says so plainly at the top of the template:

> `# Required: id · slug · name · category · tier · source · confidence · created. Everything else is optional.`

The template also tells the reader to keep notes thin: "Most fields are OPTIONAL ... keep a note slim, add fields as you learn."
That instinct ports. The field list mostly does not.

### 1a. The required eight

| Glitch field | Verdict | Why |
|---|---|---|
| `id: prs_xxxxxxxx` | **Drop** | A minted opaque id (`prs_` plus 8 base32) exists so rows can point at a person across five tables. We have no tables. Worse, minting a stable random id in POSIX sh means either `$$` plus date (unstable, not content derived) or a hash tool that is not guaranteed present. The identifier IS the key here: an email for b2b, a platform plus handle for b2c. Both routes have one by construction. |
| `slug: sam-rivers` | **Keep, as the filename only** | Needed because a filename must be safe. Derive it from the key, not the name, so it cannot drift when a name is corrected. `tr` and `sed` are enough. |
| `name: Sam Rivers` | **Keep, required** | |
| `category: work` | **Drop** | `family / friend / work / acquaintance / community` is a life taxonomy. Everyone in our file is a prospect or a target. The route already lives in the Brain. |
| `tier: 2` | **Keep as optional `priority`, 1 to 3** | Glitch's tier is closeness and it "Drives default cadence". Ours would be ordering: who gets messaged first out of 25. Genuinely useful for sequencing a Monday morning. Optional, never required, never inferred by `ge`. |
| `source: manual` | **Keep, required, retargeted** | Glitch's values are `manual / gmail / meeting / calendar / enrichment`. Ours: `manual / apollo / import / form`. This is the anti-invention anchor. A person with no source is a person nobody can account for. |
| `confidence: low` | **Drop as a record level scalar. Replace with per line origin** | A whole record graded `medium` tells you nothing about which of nine facts was verified. At 25 people a founder will never maintain it. The rule it protects still matters, so carry the origin on the line instead: any free text line the founder did not type themselves ends with its source. |
| `created` | **Keep, required** | One `date -u` call. Cheap, and it orders the directory. |

### 1b. Optional fields that earn their place

| Glitch field | Verdict | Notes for the spec |
|---|---|---|
| `emails:` / `handles:` as repeated `{ value, type, primary, active }` blocks | **Keep the values, flatten the shape** | One identifier per line, never a nested block: nesting is unparseable without `jq`. Keep the `active` idea. A bounced address goes inactive, it does not get deleted, because deletion loses the fact that it was ever tried. Drop `primary` beyond first line wins. Drop `type: home / work / other`. |
| `phones:` | **Drop entirely** | Neither route has a phone motion. The field invites a founder to go looking for data they have no reason to hold. |
| `website:` and `sameAs:` | **Keep, collapsed to one `link` list** | Glitch splits their own site from canonical profile links. That distinction pays off in a graph. Here it is one list of things the founder opens before writing an opener. |
| `org: [{ name, title, role, current }]` | **Keep `name` and `title` only, flat** | This is Apollo's payload, and it is the raw material of a first line. Drop `role` and `current`. Career history is not our business. |
| `goals: "What they're trying to do / what they care about..."` | **Keep, this is the highest value field in the template** | It is the single field that stops an opener reading generic. Rename to something a founder recognises, for example `why_them`. Constraint: the content must be observed or supplied, never inferred. |
| `how_we_met: "Where/how you first connected."` | **Keep, reshaped into provenance** | For b2b this becomes the Apollo search that produced them. For b2c it becomes the hashtag, account or post where the founder found them. Together with `source` this is what makes "never invent proof" auditable rather than aspirational. |
| `interests:` (controlled vocabulary: `tech / ai / business / ...`) | **Drop the vocabulary, keep free text** | The controlled list is useless for an opener. "Posts about warehouse staffing three times a week" is useful. That belongs in a note line, not an enum. |
| `last_contacted` / `last_direction` / `last_topic` | **Keep the meaning, derive all three** | Glitch already says `last_contacted` is "code updates this from logged interactions". Same principle, harder: derive from the touch log lines in the body. Do not let a founder hand set them, because then two facts disagree. |
| `attention: none / watch / owe_reply / awaiting_them / overdue_followup / sensitive` | **The sleeper. See the warning below** | `owe_reply` and `awaiting_them` are exactly the two states a founder confuses at 25 prospects. But this is a second status axis on the same person, and our O and D rows already carry one. Two status axes is how a founder ends up with contradictory truth on one card. Recommendation: fold the useful two into the existing status vocabulary, do not add a parallel field. |
| `aka:` (nicknames) | **Drop for b2b, optional for b2c** | Only useful when resolution is by name. Ours is by identifier. |
| `cadence:` plus derived `next_due` | **Drop** | Apollo owns b2b cadence. The 25 b2c openers are sent by hand once. A single optional `follow_up_on: <date>` covers everything a founder needs, without the calendar arithmetic that `people_norm.py` exists to do. |
| `preferred_channel` | **Drop** | The route decides the channel. |
| `met_date` | **Drop** | It is the date of the first line in the touch log. |
| `tags: vip / prospect / customer / supplier / press / ...` | **Drop** | See section 3. In Glitch these exist precisely because `category` could not hold them. Our status enum already does. |

### 1c. The body sections

The three body headings port almost unchanged, and are the best part of the template.

`## About`, `## Interactions`, `## Notes`.

The Interactions shape is the piece to steal. Its two example bullets read, with the separator dash cut per the convention above:

> `- 2026-01-15 ... email (they_reached_out): short note on what it was about`

> `- 2026-01-10 ... transcript (mutual): Meeting title (→ meetings/2026-01-10-meeting-title.md) [mtg:mtg_xxxxxxxx]`

The cut mark sits where Glitch writes a separator between the date and the channel.

Three things are happening on one line that a founder can read: a date, a channel, a direction, a one line summary, and a pointer to where the detail lives.
The note points, it does not hold.

Ported to our house style, with the em dash removed and made `awk` sliceable on whitespace:

```
- 2026-09-14 email out: opener sent, apollo sequence still paused
- 2026-09-18 email in: asked for pricing (detail → outreach/replies.md)
```

`$2` is the date, `$3` the channel, `$4` the direction with the colon stripped.
That is one `awk` line, and it is the entire derivation of `last_contacted`, `last_direction` and the O row status.

### 1d. Personal assistant concerns that do not apply

Dropped outright, all for the same reason: they model a relationship, and we are modelling a sales motion.

`category`, `subtype` and its per category scoping, `cadence`, `next_due`, `tier` as closeness, `preferred_channel`, `tags`, `interests` as an enum, `aka`, `phones`, `met_date`, the whole `RELATIONSHIP_TYPE` graph with its inverse map, and `IMPORTANT_DATE_TYPE` with `birthday`.

Birthday tracking on a cold prospect is the clearest tell that a field has been ported without thinking.

---

## 2. Same person, different names or addresses

### What Glitch actually does

Three layers, cleanly separated.

**Normalisation, one pipeline, once.** `entity_match.py` runs a fixed order: NFKD, casefold, strip combining marks, tokenise.
`casefold` rather than `lower` is deliberate so that the German sharp s folds to "ss".
Accents are folded by one shared function so that `José Ramírez` and `Jose Ramirez` compare equal, and `people.py` reuses the same fold when it builds a filename.
The display form keeps its accents. Only the comparison form is folded.

**Deterministic inbound resolution**, `people_resolve.py`, five steps in fixed order:

1. normalise the identifier and the name
2. a strong identifier (email, phone, handle) matching exactly one non shared person auto links. This is the happy path, described in the docstring as "what routes the 'three Sam Carters' each to the right row"
3. an unknown identifier plus a known name proposes `add_identifier`, phrased to the user as "is this the same person?"
4. unknown identifier and unknown name proposes `new_stub`. Explicitly "NO auto-create"
5. a name with no identifier runs a duplicate check and proposes `name_dup`, or returns unresolved

Nothing auto merges and nothing auto creates. Every uncertain outcome becomes a proposal a human taps.

**Fuzzy resolution above that**, `entity_resolve.py`, for when a member types a phrase rather than an address.
It returns exactly one of three answers, never a bare id: `resolve`, `offer`, `unresolved`.
Two structural laws are worth naming because they are good design regardless of scale:

- a partial or fuzzy match is **capped below the bind threshold**, so graded evidence "structurally cannot bind silently". The resolver has no option but to ask.
- **tier before score at the bind**: a literal containment beats a fuzzy hit whatever the numbers say, "because 'the words you actually typed appear in this name' is stronger evidence than 'these letters are nearly those letters'".

On top sits a discourse frame: when the answer is a question, the question is stored with its candidates, so the member's next word ("the second one") resolves against it, and a confirmed pick teaches an alias that is born tentative and promoted by repetition.

### The honest judgement: almost none of this is needed

At 25 hand picked people, two facts kill the problem before it starts.

**Both routes have a strong identifier by construction.**
Apollo hands over an email. The 25 b2c targets are chosen by handle, by hand, by the founder looking at the account.
There is no name only ingest path anywhere in either route.
So steps 3, 4 and 5 never fire, and the entire fuzzy tier above them never fires either.
Glitch needs all of it because it ingests names from meeting transcripts and inboxes where nobody is present to answer. Our founder is present, always, by design.

**The cost of a duplicate is trivial.**
Twenty five rows. The founder reads the list, sees the same company twice, deletes a line.
Building scoring, banding, alias tables and a pending resolution state machine to prevent a five second manual fix is the definition of over engineering for scale that will not occur.

### The three things to take anyway, each roughly one line of shell

1. **Key on the identifier, never the name.** This is a design decision, not code, and it removes the whole problem. Adopt it explicitly in the spec so nobody later adds a name keyed lookup.
2. **Normalise the identifier once, at write, and store the normalised form.** Lowercase the email. Strip a leading `@` from a handle, then lowercase it. Two `tr` calls. This alone stops `Sam@Acme.com` and `sam@acme.com` becoming two files, which is the only collision this audience will actually hit.
3. **Keep the posture, drop the machinery.** Never auto merge, never silently create a second person for an existing key. A collision is a refusal, with a recovery line starting `→`, naming both files.

### One caveat worth putting in the spec

Apollo lists do produce genuine near duplicates that an exact key will not catch: `sam@acme.com` against `sam.j@acme.com`, or plus addressing.
Do nothing about this at write time. Adding matching to the write path is how the fuzzy tier gets in.
Instead have `ge person list` or the lint pass print one advisory line where two people share a normalised surname and an email domain.
That is a single `awk` pass over 25 lines, no scoring, no thresholds, and the founder makes the call.

---

## 3. Controlled vocabularies

### The discipline, which ports even though the mechanism does not

`people_vocab.py` is the single source for every allowed value list, and it explains why in its own docstring: the data dictionary "is enforced in TWO places" (the linter and the SQL `CHECK` clauses), and "A rule living in only one place is a bug", so every list is declared once and both consumers are rendered from it.

We have no DDL, but we do have two consumers: the writer (`ge person`) and the validator (`ge person lint`, and whatever `ge index` does when it reads a file it did not just write).
Same rule applies. One `case` statement, one file, both read it.
Two spellings of "what is allowed" is how the next drift bug happens.

Two more rules from the same file are worth lifting verbatim into our spec:

- every closed list ends in a controlled `other`, and an `other` value **requires a real label**, because "`other` needs a real subtype_label ... never a catch-all"
- **a tag is never a subtype.** The comment is explicit: `prospect`, `customer`, `supplier`, `press`, `vip` "say how you're relating to someone now, not what they are to you"

That second rule is the same rule as our O row question, stated about a different pair of fields.
Glitch had two overlapping classification axes on one person and had to write a paragraph in three separate files to stop people confusing them.
That is real evidence for keeping exactly one status axis per person.

### The lists, with a verdict on each

| Vocabulary | Values | Copy? |
|---|---|---|
| `DIRECTION` | `they_reached_out / i_reached_out / mutual` | **Yes**, reduced to `in / out`. This is the vocabulary that stops a founder reading their own sent message as a reply. Drop `mutual`, it is a meeting concept. |
| `IDENTIFIER_KIND` | `email / phone / handle` | **Yes**, reduced to `email / handle`. |
| `HANDLE_PLATFORM` | `whatsapp / linkedin / x / instagram / telegram / signal / github / other` | **Yes**, reduced. **See the conflict flagged below.** |
| `PERSON_SOURCE` | `manual / gmail / meeting / calendar / enrichment` | **Yes**, retargeted to `manual / apollo / import / form`. |
| `INTERACTION_SOURCE` | `meeting / transcript / email / conversation / manual` | **Yes**, retargeted to `email / dm / call / form / manual` for the channel slot on a touch line. |
| `DO_NOT` | `email / call / text / dm / auto_draft / contact` | **Probably not, and check first.** A person who asked to stop must be unmessageable. But the O row already has `stopped` and the D row has `no_reply`. If status covers it, a second field is the duplication trap. Resolve this in the spec, do not ship both. |
| `ATTENTION` | `none / watch / owe_reply / awaiting_them / overdue_followup / sensitive` | **Only by folding into status.** `owe_reply` and `awaiting_them` are real and useful. As a separate field they are a second status axis. |
| `FLAG_SEVERITY` | `info / warn / error` | **Yes, for the linter only**, together with the rule attached to it: only `error` blocks, `warn` and `info` surface without blocking. |
| `TIER` | `1 / 2 / 3` | Optional, as priority. |
| `CONFIDENCE` | `low / medium / high` | No, see 1a. |
| `CATEGORY`, `SUBTYPE_BY_CATEGORY`, `TAGS`, `INTERESTS`, `CADENCE`, `PREFERRED_CHANNEL`, `IMPORTANT_DATE_TYPE` | | **No.** Life taxonomy. |
| `RELATIONSHIP_TYPE` plus `RELATIONSHIP_INVERSE` | 15 types plus a mirror map | **No.** A person to person graph is exactly the personal assistant concern that does not apply. |
| `PROPOSAL_KIND` (14 values), `PROPOSAL_STATUS`, `DECIDE_STATE`, `MATCH_ROUTE` | | **No.** All exist to serve the proposal queue. See section 5. |

### The platform conflict the spec author must resolve

The existing D row is:

```
D|<handle>|<platform ig|fb|other>|<status ...>|<sent_at ISO|->
```

Three platform values. Glitch has eight.
If a person file is allowed to carry `linkedin` and the derived D row only allows `ig / fb / other`, then either `ge index` silently downgrades it to `other`, which loses a fact, or it refuses, which means a valid person file cannot be indexed.

Both are bad. Pick one deliberately:

- widen the D row's platform list to match the person file exactly, and accept that section 05's route definitions need a matching edit, or
- constrain the person file's platform vocabulary to `ig / fb / other` and document that b2c is an Instagram and Facebook motion, which it currently is

My read: constrain it. The 25 hand picked accounts are Instagram and Facebook by policy, LinkedIn is the b2b route's territory, and widening a vocabulary to hold values no route produces is speculative.
But it must be a decision written down, not an accident discovered by the first founder who pastes a LinkedIn handle.

---

## 4. What Glitch deliberately keeps OUT of a person note

Six exclusions, five of which port directly.

**Derived values.** The template's last frontmatter line is the rule, stated as a comment:

> `# next_due is DERIVED (from last_contacted + cadence) ... never hand-set`

Nothing a projector computes is ever written by hand into the note.
This is the single strongest piece of prior art for the lead proposal, because it is the same shape: the note holds inputs, the derived store holds outputs, and the outputs are rebuildable from the inputs at any time.
Ported: a person file must not carry a copy of anything `ge index` computes. No `last_contacted:` field if it is derived from the touch lines. No status field duplicated onto the file if the O row is derived. Pick one home per fact.

**The content of an interaction.** The template's own example shows a meeting touch carrying a title, a relative path and an id, not the transcript.
The person note points at the detail, it does not hold it.
Ported: the opener text lives in the outreach file, the person file carries a dated line saying it went.
This matters more here than there, because a person file a founder can read in ten seconds is one they will keep current.

**Anything unsourced.** The About section says it directly:

> `Never fabricate; an unknown stays unknown.`

And the capture skill makes it operational: "No source → don't write it", with the fetched URL and fetch date written inline into the prose so the read side can surface it truthfully.
This is our rule 5 already. What is new is the mechanism: the attribution goes **in the line**, not in a separate provenance field, so it cannot be separated from the claim it supports.

**Outbound action.** The person skill's boundary is unambiguous:

> `Sending anything outward stays advisor ... This directory keeps the CRM current; it never acts on the user's behalf to other people.`

That is our no automated DM policy arriving at the same conclusion from a different direction.
Worth stating in our spec in the same place: the person layer records, it never sends.

**Auto created people.** An unknown email sender does not become a person. It becomes a proposal, and only once there is two way correspondence.
Ported in spirit, not mechanism: `ge person` creates a person when the founder says so, and never as a side effect of importing or logging.

**Unrecognised keys.** The capture path refuses a key outside the typed list rather than dropping it, and gives the reason:

> `a typo'd `note:` is a fact that silently never lands`

Ported: `ge person set` must **refuse** an unknown field name with a `→` recovery line naming the valid fields. It must not write the line through and it must not drop it silently. Both alternatives lose the founder's work without telling them.

The sixth, which does not port because we have no fetch path in the person layer, is the sanitisation of external prose so that a fetched page cannot reshape a note or smuggle an instruction into it.
Worth remembering if an Apollo company description ever gets written into a person file, because that is exactly the same shape of risk.

### One validation lesson worth carrying over

`people_lint.py` documents a corruption it actually shipped: a sentence handed to a door that expected a list gets iterated, so every character becomes an item, one bullet per letter and one database row per letter.
The comment notes "The shape carries no error of its own, which is why it ran for months", and the fix was a positive detector for that specific corruption, threshold set from measurements against a real estate of 71 notes.

The shell analogue is unquoted expansion and `IFS` splitting, which fails in exactly the same silent way.
Recommendation: `ge person lint` should carry positive detectors for our own known corruption shapes, not just field validation. A body bullet that is a single character. A line whose pipe field count is wrong. A file with a key and no value.

Separately, `people_lint.py` strips a trailing carriage return before parsing because it "is a line TERMINATOR fragment and never content".
That is independent corroboration of the CR rule already in our plan. Keep it.

---

## 5. The one to steal, and the one to avoid

### Steal: note is truth, rows are projected, malformed notes are skipped and flagged

The person skill states the architecture in one sentence:

> `It is **two layers** ... the markdown vault (...) is the source of truth; a deterministic projector lints + projects each note into typed rows in memory.db.`

And `people_lint.py` states the enforcement that makes it survivable:

> `it validates a person note against people_vocab BEFORE projection, so a malformed file is flagged and SKIPPED rather than corrupting the DB`

plus, in the same docstring, that the linter "NEVER raises into the projector".

Three parts, and all three port to shell without difficulty:

1. **The file is authoritative, the rows are derived.** This is the lead proposal in the task brief. It is running in production against a real estate of notes. Accept it.
2. **Lint before project, never after.** `ge index` validates a person file before it emits an O or D row from it.
3. **Skip, do not abort.** One broken person file must not stop the other 24 rebuilding. It is reported with a `→` line and its rows are omitted from the ledger for that pass. This is the detail that makes a rebuildable derived store actually usable, and it is easy to get wrong by writing `set -e` and exiting on the first bad file.

Add one shell specific requirement Glitch gets for free from a database transaction: `ge index` must write the whole ledger to a temp file and move it into place, so a failure halfway through never leaves a half rebuilt ledger. Snapshot first, per the existing rule.

### Avoid: the proposal queue

It is the most attractive thing in the repo and it is the wrong size by an order of magnitude.

`PROPOSAL_KIND` carries 14 values. There is a `PROPOSAL_STATUS`, a `DECIDE_STATE` for the answer a member types onto a pending card, verbs for `list / accept / apply / dismiss / replace`, a per apply byte for byte backup, a returned `undo_command`, a conflict path that refuses a bare accept when a one slot value would be overwritten, and a keeper pass that actions stored answers later.

All of that exists to solve one problem we do not have: **the founder is not there when the fact arrives.**
Glitch reads an inbox at 4am and must park its findings somewhere a human will see them.
Every `ge person` write happens with the founder in the session, reading the output.
At 25 people the founder **is** the queue. Every proposal collapses to "ask them now, in the conversation, before writing".

Second place, for completeness, is the fuzzy resolver: the tiers, the bands, the alias table and the stored discourse frame.
Same reason, argued in section 2. It is elegant, it is well justified where it lives, and here it would be several hundred lines of shell defending against a collision that 25 hand picked identifiers structurally cannot produce.

---

## 6. Two things the spec author should resolve, flagged here rather than decided

**One.** Section 08's own porting table currently has this row:

> `| A people directory with typed notes and a projector | **No** | The ledger's O| rows already carry prospects. A second entity store is not earned |`

The client's option 2 decision reverses that row. It needs an edit when the person layer spec lands, along with the sentence that justifies it, or the plan contradicts itself in writing.
I have not touched the file.

**Two.** The platform vocabulary conflict between the person file and the D row, set out at the end of section 3. It has to be decided before either format is written, because it determines whether `ge index` can be total over valid person files.
