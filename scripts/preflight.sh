#!/usr/bin/env bash
# Project Bridge preflight: create a checkpoint tag and a dedicated handoff branch
# before another coding agent starts working on the same project.
#
# Run it from inside the PROJECT you want to hand off (not from the skill folder).
# Usage:  bash preflight.sh [tool-name] [--dry-run]     (default tool: opencode)
#
# It only reads git state and, unless --dry-run, creates ONE tag and ONE branch.
# It never commits, stashes, resets, cleans, pushes, or touches files.
set -euo pipefail

TOOL="opencode"
DRY=0
for arg in "$@"; do
  case "$arg" in
    --dry-run) DRY=1 ;;
    -h|--help) sed -n '2,9p' "$0"; exit 0 ;;
    -*) echo "Unknown option: $arg" >&2; exit 2 ;;
    *) TOOL="$arg" ;;
  esac
done
TOOL="$(printf '%s' "$TOOL" | tr '[:upper:]' '[:lower:]' | tr -c 'a-z0-9-' '-' | sed 's/^-*//; s/-*$//')"
[ -n "$TOOL" ] || TOOL="opencode"

FAIL=0
ok()   { printf '  [ OK ] %s\n' "$*"; }
warn() { printf '  [WARN] %s\n' "$*"; }
err()  { printf '  [FAIL] %s\n' "$*"; FAIL=1; }

echo "Project Bridge preflight (backup tool: $TOOL)"

if ! git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  echo "  [FAIL] This folder is not a git repository. Run 'git init', make a first commit, then retry."
  exit 1
fi
cd "$(git rev-parse --show-toplevel)"
if ! git rev-parse --verify HEAD >/dev/null 2>&1; then
  echo "  [FAIL] The repository has no commits yet. Make a first commit, then retry."
  exit 1
fi

BASE="$(git branch --show-current)"
BRANCH="${TOOL}-work"
if [ -z "$BASE" ]; then
  err "Detached HEAD. Check out a branch first."
elif [ "$BASE" = "$BRANCH" ]; then
  err "You are already on '$BRANCH'. Run this from your normal base branch (for example main or master)."
else
  ok "Base branch: $BASE"
fi

if [ -n "$(git status --porcelain)" ]; then
  err "There are uncommitted or untracked changes. Commit or stash them yourself first; this script never does it."
  git status --short | head -15 | sed 's/^/         /'
else
  ok "Working tree is clean"
fi

tracked_env="$(git ls-files | grep -E '(^|/)\.env($|\.)' | grep -Ev '\.(example|sample|template|dist)$' || true)"
if [ -n "$tracked_env" ]; then
  err "Secret-like file(s) are TRACKED by git. Remove them from git and rotate the keys:"
  printf '%s\n' "$tracked_env" | sed 's/^/         /'
else
  ok "No .env file is tracked by git"
fi
while IFS= read -r f; do
  [ -n "$f" ] || continue
  case "$f" in *.example|*.sample|*.template|*.dist) continue ;; esac
  if ! git check-ignore -q -- "$f"; then
    warn "$f exists but is not ignored by .gitignore"
  fi
done < <(find . -maxdepth 2 -name '.env*' -type f -not -path './.git/*' 2>/dev/null)

if git show-ref --verify --quiet "refs/heads/$BRANCH"; then
  err "Branch '$BRANCH' already exists. Review and merge it first (prompts/04-review-and-merge.md), or remove it yourself once you are sure."
fi

TAG="checkpoint-before-${TOOL}-$(date +%Y-%m-%d)"
if git show-ref --verify --quiet "refs/tags/$TAG"; then
  TAG="${TAG}-$(date +%H%M%S)"
fi

if [ "$FAIL" -ne 0 ]; then
  echo
  echo "Preflight FAILED. Nothing was changed."
  exit 1
fi

if [ "$DRY" -eq 1 ]; then
  echo
  echo "Dry run OK. Would create tag '$TAG' at $(git rev-parse --short HEAD) and branch '$BRANCH' from '$BASE'. Nothing was changed."
  exit 0
fi

git tag "$TAG"
git checkout -q -b "$BRANCH"
git config "projectbridge.${BRANCH}.base" "$BASE"

echo
echo "Done."
echo "  Checkpoint tag : $TAG"
echo "  Handoff branch : $BRANCH (you are on it now)"
echo "  Base branch    : $BASE (untouched)"
echo
echo "Next: open the backup agent in this same folder, use Plan / read-only mode,"
echo "and paste prompts/01-onboard-readonly.md."
echo "To undo before any work: git checkout $BASE && git branch -d $BRANCH && git tag -d $TAG"
