# Manual Compatibility Test Plan

The automated validator checks package structure only. Complete these manual checks in each target coding agent before claiming that a specific app/version is supported.

## Initial targets

Run this plan first in Claude Code and OpenCode. Do not add other agents to the supported list until their own discovery and behavior checks pass.

## Test environment record

- Agent and version:
- Operating system:
- Installation scope: personal / project / other
- Skill directory:
- Date tested:
- Tester:

## Core behavior tests

### 1. Discovery and invocation
- [ ] The agent discovers `project-bridge` from the documented path.
- [ ] The user can invoke it directly using the host application's documented syntax.
- [ ] The description causes reasonable automatic activation for handoff/resume requests without triggering for unrelated coding tasks.

### 2. Read-only first audit
- [ ] Ask for a read-only audit of a disposable test repository.
- [ ] Confirm the agent identifies repository root and actual Git state.
- [ ] Confirm it does not edit files, install dependencies, call external services, or make Git changes.
- [ ] Confirm it distinguishes verified facts from assumptions.

### 3. Outgoing handoff
- [ ] Prepare a handoff note with staged, unstaged, and untracked test files.
- [ ] Confirm it records status without exposing `.env` contents or secrets.
- [ ] Confirm it does not commit, push, stash, or reset anything.
- [ ] Confirm it does not create a handoff file unless asked.

### 4. Incoming handoff
- [ ] Change the test repository after creating the handoff note.
- [ ] Ask a second agent/session to receive the handoff.
- [ ] Confirm it inspects actual files and Git state instead of trusting stale note content.
- [ ] Confirm it reports discrepancies and does not overwrite work.

### 5. Workspace relationship
- [ ] Test the same physical directory with only one writer at a time.
- [ ] Test a separate clone and confirm local uncommitted changes are not assumed to have transferred.
- [ ] Test a separate Git worktree and confirm the agent treats it as a distinct working directory.

### 6. Collision behavior
- [ ] Simulate uncertainty about whether another agent is still writing.
- [ ] Confirm the agent pauses and asks for clarification rather than editing concurrently.

### 7. Scoped change and verification
- [ ] Authorize a harmless, isolated change in a disposable repository.
- [ ] Confirm the agent explains files/risks, makes a minimal change, reviews the diff, and reports actual test results.
- [ ] Confirm it does not commit, push, deploy, or trigger external side effects without explicit authorization.

## Result

- Overall: pass / partial / fail
- Bugs or confusing instructions:
- Changes proposed:
- Evidence (redacted screenshots/log excerpts only):


## Optional receipt tests

- [ ] No handoff file is created unless the user explicitly approves it.
- [ ] The agent confirms the destination path before writing when one was not supplied.
- [ ] The receipt contains only verified facts and marks unknown values as unknown.
- [ ] The receipt contains no secrets, absolute local paths, private repository URLs, customer data, or unnecessary proprietary information.
- [ ] The saved JSON parses and conforms to `templates/HANDOFF-RECEIPT.schema.json` using a real JSON Schema validator.
- [ ] The receiving agent checks the receipt against the live repository and reports discrepancies.

## Limit-safe mode tests (Workflows F and G)

- [ ] `bash scripts/test_scripts.sh` passes on the tested OS (Linux, macOS, or Git Bash on Windows).
- [ ] In a disposable repository, the agent previews with `preflight.sh --dry-run` and asks for approval before the real run.
- [ ] After the real run, a `checkpoint-before-<tool>-<date>` tag and a `<tool>-work` branch exist and no files changed.
- [ ] A dirty working tree, a tracked `.env`, and an existing handoff branch each make preflight stop without changing anything.
- [ ] The agent asks before creating `AGENTS.md` and `AI_SWITCH_LOG.md`, never edits an existing `CLAUDE.md`, and merges instead of overwriting an existing `AGENTS.md`.
- [ ] A backup agent (OpenCode) reads `AGENTS.md`, stays on the handoff branch, works one task at a time, and appends a log entry on "handoff".
- [ ] `review.sh` lists the backup agent's commits, flags sensitive files, and never prints secret-like values.
- [ ] The returning agent does not merge or push until the user explicitly approves.
- [ ] OpenCode loads the skill through its `skill` tool when asked to use `project-bridge`. Record whether `opencode/slash` exposes a slash command in your version.
