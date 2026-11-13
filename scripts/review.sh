#!/usr/bin/env bash
# Project Bridge review: read-only summary of what a backup agent changed on its handoff branch.
#
# Run it from inside the PROJECT, after the primary agent is back.
# Usage:  bash review.sh [handoff-branch] [base-branch]
#   handoff-branch  default: the current branch if its name ends in -work
#   base-branch     default: remembered by preflight.sh, else main, else master
#
# It never changes anything. It never prints secret values, only file names and counts.
set -euo pipefail

if ! git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  echo "Not inside a git repository." >&2
  exit 1
fi
cd "$(git rev-parse --show-toplevel)"

BRANCH="${1:-}"
if [ -z "$BRANCH" ]; then
  cur="$(git branch --show-current)"
  case "$cur" in
    *-work) BRANCH="$cur" ;;
    *) echo "Usage: bash review.sh <handoff-branch> [base-branch]" >&2; exit 2 ;;
  esac
fi
git show-ref --verify --quiet "refs/heads/$BRANCH" || { echo "Branch '$BRANCH' not found." >&2; exit 1; }

BASE="${2:-$(git config --get "projectbridge.${BRANCH}.base" || true)}"
if [ -z "$BASE" ]; then
  for c in main master; do
    if git show-ref --verify --quiet "refs/heads/$c"; then BASE="$c"; break; fi
  done
fi
[ -n "$BASE" ] || { echo "Cannot determine the base branch. Pass it as the 2nd argument." >&2; exit 1; }
git show-ref --verify --quiet "refs/heads/$BASE" || { echo "Base branch '$BASE' not found." >&2; exit 1; }

echo "Project Bridge review: $BRANCH vs $BASE"
echo
echo "== Commits on $BRANCH that are not on $BASE"
if [ -n "$(git log --oneline "$BASE..$BRANCH")" ]; then git log --oneline "$BASE..$BRANCH"; else echo "  (none)"; fi

echo
echo "== Diff summary since the branch point"
if [ -n "$(git diff --name-only "$BASE...$BRANCH")" ]; then git diff --stat "$BASE...$BRANCH"; else echo "  (no file changes)"; fi

echo
echo "== Has $BASE moved since the handoff branch was created?"
moved="$(git rev-list --count "$BRANCH..$BASE")"
if [ "$moved" -gt 0 ]; then
  echo "  YES: $BASE has $moved new commit(s) that $BRANCH does not have. Expect to reconcile before merging."
else
  echo "  No."
fi

echo
echo "== Uncommitted changes in the working tree"
if [ -n "$(git status --porcelain)" ]; then
  git status --short | head -20 | sed 's/^/  /'
else
  echo "  (clean)"
fi

files="$(git diff --name-only "$BASE...$BRANCH")"

echo
echo "== Sensitive or high-impact files touched (review these first)"
sens='(^|/)\.env|\.pem$|\.key$|id_rsa|(^|/)(package(-lock)?\.json|yarn\.lock|pnpm-lock\.yaml|poetry\.lock|requirements[^/]*\.txt|pyproject\.toml|go\.(mod|sum)|Cargo\.(toml|lock)|Gemfile(\.lock)?)$|(^|/)\.github/workflows/|(^|/)(Dockerfile|docker-compose[^/]*\.ya?ml)$|(^|/)(CLAUDE|AGENTS)\.md$|(^|/)\.claude/'
hit="$(printf '%s\n' "$files" | grep -Ei "$sens" || true)"
if [ -n "$hit" ]; then printf '%s\n' "$hit" | sed 's/^/  /'; else echo "  (none)"; fi

echo
echo "== Added lines that look like secrets (file names and counts only)"
found=0
while IFS= read -r f; do
  [ -n "$f" ] || continue
  n="$(git diff -U0 "$BASE...$BRANCH" -- "$f" | grep '^+' | grep -v '^+++' | grep -Eic \
    -e 'AKIA[0-9A-Z]{16}' \
    -e 'gh[pousr]_[A-Za-z0-9]{30,}' \
    -e 'github_pat_[A-Za-z0-9_]{30,}' \
    -e 'sk-[A-Za-z0-9_-]{20,}' \
    -e 'xox[baprs]-[A-Za-z0-9-]{10,}' \
    -e 'BEGIN [A-Z ]*PRIVATE KEY' \
    -e "(api[_-]?key|secret|token|passw(or)?d)[[:space:]]*[:=][[:space:]]*[\"'][^\"']{8,}" || true)"
  if [ "${n:-0}" -gt 0 ]; then
    echo "  $f: $n added line(s) look like secrets (content not shown)"
    found=1
  fi
done <<< "$files"
[ "$found" -eq 1 ] || echo "  (none found; this is a heuristic, not a guarantee)"

echo
echo "Next: read prompts/04-review-and-merge.md, review every changed file, run the full tests,"
echo "and merge only after you explicitly approve."
