## Where this starts from

Every fact below was checked against the working tree on 20 August 2026, not recalled.
Re-check any of it with the command given in brackets.

### The repository

Location on this machine: `/Users/pmudh/Documents/GitHub/Atlanta`
Remote: `https://github.com/Philm-moxywolf/Atlanta`
Marketplace name: `launchhouse`
Version in both manifests: **0.1.0**

Founders install with:

```
/plugin marketplace add Philm-moxywolf/Atlanta
/plugin install growth-engine@launchhouse
```

Commands are namespaced. A founder types `/growth-engine:setup`, never `/setup`.
Bare command names do not resolve and never will, because that is how installed plugins work.

**10 commits and the tag `v0.1.0` exist only on this laptop.** [`git log --oneline origin/main..HEAD`]
Nothing is on GitHub beyond the initial commit. That is the first thing to fix, because everything else assumes the remote is current.

### What exists in the plugin today

Nine skills: audience-b2c content-engine founder-brain ghl-workflows growth-plan outreach-b2b playbook-export setup status 
Ten commands: brain content doctor engine2 gate ops plan playbook setup status 

Two worked examples, each containing a founder-brain.md and nothing else:
`plugins/growth-engine/assets/examples/b2b-northfield/` (Sam Okoye, fractional operations for construction firms)
`plugins/growth-engine/assets/examples/b2c-lumen/` (Priya Raman, sensitive-skin skincare)

`scripts/validate.sh` (312 lines) runs and passes with 0 errors. [`bash scripts/validate.sh`]
`scripts/build-folder.sh` builds a working-folder zip into `dist/`.
A GitHub Action at `.github/workflows/validate.yml` runs the validator on push.

### What does not exist yet

None of the following are present. [`ls plugins/growth-engine`]

`bin/ge` · `.mcp.json` · `hooks/hooks.json` · `schemas/` · `tests/` · `CHANGELOG.md` · `CLAUDE.md` · `docs/CONNECTIONS.md`

10 placeholder links remain in shipped assets: six GoHighLevel snapshot share links and three gate form links plus a tracking sheet. [`grep -rc TODO plugins/growth-engine/assets`]

`planning/spike-findings.md` exists with seven sections, all marked PENDING. No external fact has been verified yet.
A throwaway probe plugin for the two decision gates sits at `planning/spike/gate-ab-plugin/`.

### The single most important fact

**Nothing has ever been executed end to end.** No skill has been run once, on any track, by anyone.

Every quality claim about this toolkit today is structural: the files parse, the frontmatter is valid, the commands route to skills that exist, the house style holds. None of it is behavioural. Nobody has watched a founder brain get built, or content get generated, or a sequence get written.

That is why section 03 puts an end-to-end rehearsal at the centre of the review process rather than at the end of the build.

### Two prior reviews worth reading before starting

`/Users/pmudh/Downloads/Atlanta/launchhouse-atlanta/planning/FUNCTIONAL-REVIEW.md`
95 findings against the current toolkit, each adversarially verified. 4 blockers, 23 high. The build plan in section 02 opens with a task that triages every one of them, because nothing in the PRD currently routes a single finding.

`/Users/pmudh/Downloads/Atlanta/launchhouse-atlanta/planning/PRD-GAPS.md`
75 gaps in the PRD itself, verified the same way. Section 02 folds the fixes in.

Both live outside the repository, in the private working folder, along with the commercial proposal and the mentor briefs. That folder must never be committed here.
