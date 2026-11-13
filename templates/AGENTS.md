# AGENTS.md: shared rulebook for every AI agent in this repository

This project works and is in active use. **Claude Code** is the primary agent. **OpenCode** is the backup used when the primary hits its usage limit. Whoever is working, **the project must stay working.**

(Using different tools? Replace the two names above and the branch name `opencode-work` below.)

## Read first
1. `CLAUDE.md` if it exists. Its rules apply to you too, even if you are not Claude.
2. `README*`, any `HANDOFF*`, `CONTRIBUTING*`, and overview files in `docs/`.
3. `AI_SWITCH_LOG.md`: the last three entries show what the previous agent did and what is pending.

Large files: read the headings and the newest section only.

## Locked: never do without explicit approval from the user
- Never read, print, copy or edit `.env` or any secret, token or credential file. Variable names are fine, values are not.
- Never touch virtual environments, `node_modules`, build output, `.git` internals, or login/credential files. Never log in or out of any service.
- No dependency install, upgrade or removal. No edits to lockfiles or dependency manifests.
- No live actions: do not run workers or servers that talk to external services, deploy, publish, post, send email, or call paid APIs. If a test needs a live service or internet, STOP and ask.
- No `git push`, `git reset --hard`, `git clean`, `git rebase`, or any force operation.
- No refactoring or "improving" code that already works. Smallest possible change only.

## Working rules
- Work only on the handoff branch `opencode-work`. Never commit on the default branch. Commit on the handoff branch only when the user asks you to.
- One task at a time. Before editing, list the files you will change and wait for "yes".
- After a change, run the project's existing tests (command is in README or CLAUDE.md) and report the real result. Never claim it works without running them.
- If anything is unclear or risky, STOP and ask.
- At the end of a session, or when the user says "handoff", append an entry to `AI_SWITCH_LOG.md` in the format defined there.
