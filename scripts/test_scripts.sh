#!/usr/bin/env bash
# Self-test for preflight.sh and review.sh using a throw-away git repository.
# Usage: bash scripts/test_scripts.sh
set -euo pipefail

HERE="$(cd "$(dirname "$0")" && pwd)"
TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT
export GIT_AUTHOR_NAME=t GIT_AUTHOR_EMAIL=t@example.com GIT_COMMITTER_NAME=t GIT_COMMITTER_EMAIL=t@example.com
PASS=0
check() { # check "name" command...
  local name="$1"; shift
  if "$@" >/dev/null 2>&1; then PASS=$((PASS+1)); printf 'PASS  %s\n' "$name"; else printf 'FAIL  %s\n' "$name"; exit 1; fi
}
fails() { ! "$@"; }

cd "$TMP"
git init -q
git symbolic-ref HEAD refs/heads/main
printf '.env\n' > .gitignore
printf 'print("hello")\n' > app.py
printf 'KEY=placeholder\n' > .env
git add .gitignore app.py
git commit -q -m "init"

# 1 dry run changes nothing
check "dry run succeeds"            bash "$HERE/preflight.sh" opencode --dry-run
check "dry run created no branch"   fails git show-ref --verify --quiet refs/heads/opencode-work

# 2 dirty tree is refused
echo "x" >> app.py
check "dirty tree refused"          fails bash "$HERE/preflight.sh" opencode
git checkout -q -- app.py

# 3 tracked .env is refused
git add -f .env && git commit -q -m "oops tracked env"
check "tracked .env refused"        fails bash "$HERE/preflight.sh" opencode
git rm -q --cached .env && git commit -q -m "untrack env"

# 4 real run creates tag + branch and records base
check "preflight succeeds"          bash "$HERE/preflight.sh" opencode
check "on handoff branch"           test "$(git branch --show-current)" = "opencode-work"
check "checkpoint tag exists"       bash -c 'git tag | grep -q "^checkpoint-before-opencode-"'
check "base recorded"               test "$(git config --get projectbridge.opencode-work.base)" = "main"

# 5 second run refused (branch exists)
git checkout -q main
check "existing branch refused"     fails bash "$HERE/preflight.sh" opencode
git checkout -q opencode-work

# 6 review reports changes and flags sensitive files + secret-like lines, without printing them
printf 'print("changed")\n' > app.py
printf '{}\n' > package.json
FAKE="AKIA$(printf 'ABCDEFGH')IJKLMNOP"
printf 'aws = "%s"\n' "$FAKE" > leak.py
git add -A && git commit -q -m "agent work"
OUT="$(bash "$HERE/review.sh" opencode-work)"
check "review lists the commit"     bash -c "printf '%s' \"\$1\" | grep -q 'agent work'" _ "$OUT"
check "review flags package.json"   bash -c "printf '%s' \"\$1\" | grep -q 'package.json'" _ "$OUT"
check "review flags secret-like"    bash -c "printf '%s' \"\$1\" | grep -q 'leak.py: 1 added line'" _ "$OUT"
check "review never prints secret"  fails bash -c "printf '%s' \"\$1\" | grep -q \"\$2\"" _ "$OUT" "$FAKE"

printf '\nAll %d checks passed.\n' "$PASS"
