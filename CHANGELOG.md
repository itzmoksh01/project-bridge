# Changelog

All notable changes to Project Bridge are documented here.

## [0.3.1] - 2026-11-13

### Improved
- Corrected the checkpoint-tag explanation: a tag records a commit reference; it does not back up uncommitted files or perform an automatic rollback.
- Clarified OpenCode Plan-agent behavior and separated edit permissions from shell-command permissions.
- Added maintainer support guidance, a structured feature-request form, and a repeatable release checklist.
- Added a live GitHub Actions status badge to the README and extended package validation to require the new community/release files.

## [0.3.0] - 2026-11-13

### Added
- Limit-safe mode: Workflow F (prepare a switch before or when a usage limit is hit) and Workflow G (review and merge a backup agent's branch).
- `scripts/preflight.sh` (checkpoint tag, handoff branch, `.env` and clean-tree checks), `scripts/review.sh` (read-only review summary), and `scripts/test_scripts.sh` (self-test).
- `templates/AGENTS.md` shared safety rulebook and `templates/AI_SWITCH_LOG.md` handoff log.
- Four copy-paste prompts in `prompts/`.
- `docs/OPENCODE-DESKTOP.md` and `docs/GUIDE-HINGLISH.md`.
- CI now runs shellcheck, the script self-test and a tracked-`.env` check.
- `.gitattributes` forces LF line endings for shell scripts.

### Changed
- Skill description now triggers on usage limit, rate limit, quota and limit-reset situations.
- OpenCode invocation corrected: skills are loaded by the agent's native `skill` tool, not with an `@` mention.
- Validator now checks referenced files, version consistency and the issue form, and no longer fails CI on forks with a different repository name.

### Fixed
- Issue form used `about:`, which is not valid for issue forms. It now uses `description:`.
- Removed a leftover sentence asking readers to replace the repository owner name in install commands.
- Corrected a garbled rename line in the 0.2.0 changelog entry.

## [0.2.0] - 2026-11-13

### Changed
- Renamed the skill and repository package to Project Bridge.
- Focused the initial documented compatibility scope on Claude Code and OpenCode.
- Updated installation guidance to reflect current official skill discovery paths, including OpenCode's Claude-compatible global skill source.
- Clarified that runtime compatibility remains pending until hands-on tests are recorded.

### Added
- Optional, approval-gated Portable Handoff Receipt in JSON.
- JSON Schema, synthetic example, privacy guidance, and manual receipt tests.
- Stronger instructions not to create, stage, commit, or push a handoff artifact without user approval.
