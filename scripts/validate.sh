#!/usr/bin/env bash
# validate.sh: the automated check for this repo. Run before every commit.
# CI runs it on every push via .github/workflows/validate.yml.
#
# Errors block a commit. Warnings are things with a deadline attached.
# Founder-facing means README.md, docs/, and everything under plugins/.

set -uo pipefail
export LC_ALL="en_US.UTF-8"

REPO="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
PLUGIN="$REPO/plugins/growth-engine"

ERRORS=0
WARNINGS=0

err()  { printf 'FAIL  %s\n' "$1"; ERRORS=$((ERRORS + 1)); }
warn() { printf 'WARN  %s\n' "$1"; WARNINGS=$((WARNINGS + 1)); }
ok()   { printf 'ok    %s\n' "$1"; }
head_() { printf '\n== %s\n' "$1"; }
rel() { sed "s|$REPO/||g"; }
show() { printf '        %s\n' "$(echo "$1" | rel | cut -c1-150)"; }

founder_files() {
  {
    [ -f "$REPO/README.md" ] && echo "$REPO/README.md"
    find "$REPO/docs" "$PLUGIN" -name '*.md' -type f 2>/dev/null
  } | sort
}

# ---------------------------------------------------------------- manifests

head_ "Manifests"

if [ -f "$REPO/.claude-plugin/marketplace.json" ]; then
  ok ".claude-plugin/marketplace.json is at the repo root"
else
  err "no .claude-plugin/marketplace.json at the repo root. /plugin marketplace add will fail"
fi

for f in "$REPO/.claude-plugin/marketplace.json" "$PLUGIN/.claude-plugin/plugin.json"; do
  if [ ! -f "$f" ]; then
    err "missing: $(echo "$f" | rel)"
  elif python3 -c "import json,sys; json.load(open(sys.argv[1]))" "$f" 2>/dev/null; then
    ok "$(echo "$f" | rel) parses"
  else
    err "$(echo "$f" | rel) is not valid JSON"
  fi
done

if [ -f "$REPO/.claude-plugin/marketplace.json" ]; then
  MKT_NAME=$(python3 -c "import json;print(json.load(open('$REPO/.claude-plugin/marketplace.json'))['name'])" 2>/dev/null || echo "")
  if [ -n "$MKT_NAME" ]; then
    BAD_SUFFIX=$(grep -rn 'plugin install growth-engine@' "$REPO/README.md" "$REPO/docs" 2>/dev/null \
      | grep -v "growth-engine@${MKT_NAME}" || true)
    if [ -n "$BAD_SUFFIX" ]; then
      err "install suffix does not match marketplace name '${MKT_NAME}':"
      show "$BAD_SUFFIX"
    else
      ok "install suffix matches marketplace name '${MKT_NAME}'"
    fi
  fi

  OWNER_URL=$(python3 -c "import json;print(json.load(open('$REPO/.claude-plugin/marketplace.json')).get('owner',{}).get('url',''))" 2>/dev/null || echo "")
  ADD_PATH=$(grep -rhom1 'plugin marketplace add [A-Za-z0-9._-]*/[A-Za-z0-9._-]*' "$REPO/README.md" "$REPO/docs" 2>/dev/null \
    | head -1 | sed 's|.*add ||')
  if [ -n "$ADD_PATH" ] && [ -n "$OWNER_URL" ]; then
    if [ "$OWNER_URL" = "https://github.com/$ADD_PATH" ]; then
      ok "owner.url matches the documented install path ($ADD_PATH)"
    else
      err "owner.url is '$OWNER_URL' but founders are told to add '$ADD_PATH'"
    fi
  fi

  # Versions in both manifests should agree, and stay 0.x until the freeze.
  V1=$(python3 -c "import json;print(json.load(open('$REPO/.claude-plugin/marketplace.json')).get('version',''))" 2>/dev/null || echo "")
  V2=$(python3 -c "import json;print(json.load(open('$PLUGIN/.claude-plugin/plugin.json')).get('version',''))" 2>/dev/null || echo "")
  if [ "$V1" = "$V2" ] && [ -n "$V1" ]; then
    ok "manifest versions agree ($V1)"
  else
    err "manifest versions disagree: marketplace '$V1' vs plugin '$V2'"
  fi
fi

# plugin.json declares a license file that must ship inside the plugin dir,
# because the marketplace installs only ./plugins/growth-engine.
if grep -q 'SEE LICENSE IN LICENSE' "$PLUGIN/.claude-plugin/plugin.json" 2>/dev/null; then
  [ -f "$PLUGIN/LICENSE" ] && ok "LICENSE present inside the plugin directory" \
    || err "plugin.json says SEE LICENSE IN LICENSE but plugins/growth-engine/LICENSE does not exist"
fi

# ------------------------------------------------------------------- skills

head_ "Skills"

SKILL_COUNT=0
SKILL_NAMES=""
for d in "$PLUGIN"/skills/*/; do
  [ -d "$d" ] || continue
  name=$(basename "$d")
  f="$d/SKILL.md"
  SKILL_COUNT=$((SKILL_COUNT + 1))
  SKILL_NAMES="$SKILL_NAMES $name"

  if [ ! -f "$f" ]; then
    err "skills/$name has no SKILL.md"
    continue
  fi

  if [ "$(sed -n '1p' "$f")" != "---" ]; then
    err "skills/$name/SKILL.md does not open with ---"
  elif [ -z "$(sed -n '2p' "$f" | tr -d '[:space:]')" ]; then
    err "skills/$name/SKILL.md has a blank line inside its frontmatter, line 2"
  fi

  declared=$(sed -n '1,12p' "$f" | grep -m1 '^name:' | sed 's/^name:[[:space:]]*//' | tr -d '[:space:]')
  if [ -z "$declared" ]; then
    err "skills/$name/SKILL.md has no name: field"
  elif [ "$declared" != "$name" ]; then
    err "skills/$name/SKILL.md declares name '$declared', directory says '$name'"
  fi

  if ! sed -n '1,12p' "$f" | grep -q '^description:'; then
    err "skills/$name/SKILL.md has no description: field"
  fi

  dupes=$(awk '/^```/{f=!f; next} !f && /^#{1,4} /' "$f" | sort | uniq -d)
  if [ -n "$dupes" ]; then
    warn "skills/$name/SKILL.md has repeated headings:"
    show "$dupes"
  fi
done
[ "$SKILL_COUNT" -eq 9 ] && ok "9 skills found" || warn "expected 9 skills, found $SKILL_COUNT"

# ----------------------------------------------------------------- commands

head_ "Commands"

CMD_COUNT=0
for f in "$PLUGIN"/commands/*.md; do
  [ -f "$f" ] || continue
  cmd=$(basename "$f" .md)
  CMD_COUNT=$((CMD_COUNT + 1))

  if [ "$(sed -n '1p' "$f")" != "---" ] || ! sed -n '1,6p' "$f" | grep -q '^description:'; then
    err "commands/$cmd.md needs frontmatter with a description:"
  fi

  for ref in $(grep -o '[a-z][a-z0-9-]* skill' "$f" | sed 's/ skill$//' | sort -u); do
    case " $SKILL_NAMES " in
      *" $ref "*) ;;
      *) err "commands/$cmd.md routes to skill '$ref', which does not exist" ;;
    esac
  done
done
[ "$CMD_COUNT" -eq 10 ] && ok "10 commands found" || warn "expected 10 commands, found $CMD_COUNT"

# ---------------------------------------------------- command namespacing

head_ "Command namespacing"

# Installed plugin commands only resolve as /growth-engine:<name>. A bare
# /brain in founder-facing text is an instruction that fails when typed.
# Allowed: the namespaced form, path-like uses (commands/gate.md), and bare
# forms inside a skill description's trigger list, which act as natural
# language safety nets.
CMDS='setup|doctor|brain|content|engine2|ops|plan|gate|playbook|status'
BARE=$(grep -rn "/" $(founder_files) 2>/dev/null \
  | grep -v ':description:' \
  | sed 's|/growth-engine:[a-z0-9]*||g' \
  | grep -E "(^|[^[:alnum:]_-])/($CMDS)([^a-z0-9/-]|$)" || true)
if [ -n "$BARE" ]; then
  err "bare command reference. Founders typing it get nothing. Use /growth-engine:<name> or plain language:"
  show "$BARE"
else
  ok "no bare command references. All are namespaced or plain language"
fi

# ------------------------------------------------------------- placeholders

head_ "Placeholders"

PH=$(grep -rn 'ONEDAY_ORG\|REPO_NAME' $(founder_files) 2>/dev/null || true)
if [ -n "$PH" ]; then
  err "unstamped install placeholder:"
  show "$PH"
else
  ok "no install placeholders in founder-facing files"
fi

TODOS=$(grep -rln 'TODO' "$PLUGIN/assets" 2>/dev/null || true)
if [ -n "$TODOS" ]; then
  warn "asset placeholders still open (six GHL share links, three form links, tracking sheet):"
  show "$TODOS"
fi

# -------------------------------------------------------------------- style

head_ "House style, founder-facing files only"

DASHES=$(grep -rn '[—–]' $(founder_files) 2>/dev/null || true)
if [ -n "$DASHES" ]; then
  err "em dash or en dash in a founder-facing file:"
  show "$DASHES"
else
  ok "no em or en dashes"
fi

BANNED='supercharge[a-z]*|unlock[a-z]*|revolutionary|seamless[a-z]*|leverage[a-z]*|effortless[a-z]*|synergy|turnkey'
BANNED_PHRASES='game[ -]changer|cutting[ -]edge|best[ -]in[ -]class'
BAD_WORDS=$( { grep -rniE "(^|[^-[:alnum:]])($BANNED)([^-[:alnum:]]|\$)" $(founder_files) 2>/dev/null
               grep -rniE "($BANNED_PHRASES)" $(founder_files) 2>/dev/null; } | sort -u || true)
if [ -n "$BAD_WORDS" ]; then
  err "banned marketing word:"
  show "$BAD_WORDS"
else
  ok "no banned marketing words"
fi

# ----------------------------------------------------------- design rules

head_ "Design rules"

PROMISE=$(grep -rniE 'guarantee[ds]? (a )?(reply|replies|response)|promise[ds]? (a )?(reply|replies)' $(founder_files) 2>/dev/null \
  | grep -viE 'never|not |cannot|no one|nobody|none of' || true)
if [ -n "$PROMISE" ]; then
  err "output promises replies, which rule 3 forbids:"
  show "$PROMISE"
else
  ok "nothing promises replies"
fi

DM=$(grep -rniE 'automat[a-z]* (cold )?dm|dm automation' $(founder_files) 2>/dev/null || true)
if [ -n "$DM" ]; then
  warn "DM automation mentioned. Confirm each line refuses it, never offers it:"
  show "$DM"
fi

if grep -rqi 'track' "$PLUGIN/commands/engine2.md"; then
  ok "engine2 routes on the track field"
else
  err "commands/engine2.md no longer reads the track field. The fork is broken"
fi

# ---------------------------------------------------------- locked facts

head_ "Locked facts"

CLINIC=$(grep -rn 'clinic' $(founder_files) 2>/dev/null | grep -E '[0-9]{1,2} Sep' | grep -v '23 Sep' || true)
if [ -n "$CLINIC" ]; then
  err "clinic date other than 23 September in a founder-facing file:"
  show "$CLINIC"
else
  ok "clinic date consistent at 23 September"
fi

TF=$(grep -rni 'typeform' $(founder_files) 2>/dev/null | grep -viE 'not typeform|never typeform|instead of typeform' || true)
if [ -n "$TF" ]; then
  err "Typeform named as the gate destination. Gates are Google Forms:"
  show "$TF"
else
  ok "gate forms named as Google Forms"
fi

DANGLING=$(grep -rnE '\b(TASKS|MASTERPLAN|RUNBOOK|AUDIT)\.md\b' $(founder_files) 2>/dev/null || true)
if [ -n "$DANGLING" ]; then
  err "founder-facing file points at a document that is not in this repo:"
  show "$DANGLING"
else
  ok "no references to documents outside the repo"
fi

# ------------------------------------------------------------------ hygiene

head_ "Hygiene"

if grep -q '^growth-engine/' "$REPO/.gitignore" 2>/dev/null; then
  err "unanchored 'growth-engine/' in .gitignore matches plugins/growth-engine/ too. Use '/growth-engine/'"
elif grep -q '^/growth-engine/' "$REPO/.gitignore" 2>/dev/null; then
  ok "/growth-engine/ is gitignored at the repo root"
else
  err "the founder's growth-engine/ output folder is not gitignored"
fi

if [ -d "$REPO/.git" ]; then
  TRACKED=$(cd "$REPO" && git ls-files | grep '^growth-engine/' || true)
  [ -n "$TRACKED" ] && err "founder output is tracked in git: $TRACKED" || ok "no founder output tracked"

  T_SKILLS=$(cd "$REPO" && git ls-files 'plugins/growth-engine/skills/*' | grep -c 'SKILL.md' || true)
  T_CMDS=$(cd "$REPO" && git ls-files 'plugins/growth-engine/commands/*' | wc -l | tr -d ' ')
  if [ "$T_SKILLS" -eq "$SKILL_COUNT" ] && [ "$T_CMDS" -eq "$CMD_COUNT" ]; then
    ok "all $SKILL_COUNT skills and $CMD_COUNT commands are tracked in git"
  else
    err "git tracks $T_SKILLS skills and $T_CMDS commands, but $SKILL_COUNT and $CMD_COUNT exist on disk. Check .gitignore"
  fi

  LEAKED=$(cd "$REPO" && git ls-files \
    | grep -iE '^(MASTERPLAN|TASKS|RUNBOOK|AUDIT|EXECUTE|STATE)\.md$|proposal|brief|sessions-and-mentor' || true)
  if [ -n "$LEAKED" ]; then
    err "internal material is tracked in the public-bound repo:"
    show "$LEAKED"
  else
    ok "no internal material tracked"
  fi
fi

# ------------------------------------------------------------------- result

printf '\n%s\n' "----------------------------------------"
printf '%d error(s), %d warning(s)\n' "$ERRORS" "$WARNINGS"
[ "$ERRORS" -eq 0 ] && printf 'PASS\n' || printf 'FAIL. Do not commit until these are clear.\n'
exit $([ "$ERRORS" -eq 0 ] && echo 0 || echo 1)
