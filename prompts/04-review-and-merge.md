# Prompt 4: Review and merge (primary agent returns)

**Where:** the primary agent, in the project folder, after its limit resets.
**When:** before any new work. Replace `opencode-work` if you used another branch name.

```
My limit has reset. While you were unavailable I continued this project with a backup agent on git branch `opencode-work`. Review and safely take over.

RULES: Do not merge or push until I say "merge". Do not touch .env or any logins. Do not change configuration flags that guard live actions.

1. Read AGENTS.md, CLAUDE.md (if present) and AI_SWITCH_LOG.md.
2. Run: git status, git log <default-branch>..opencode-work --oneline, git diff <default-branch>...opencode-work --stat. Also tell me if the default branch has new commits that opencode-work does not have.
3. Review every changed file. Backup agents can produce bugs. Look for deleted logic, edits to protected areas (secrets, config, safety flags), new dependencies, hard-coded secrets, and log claims the code does not support.
4. Run the full test suite on opencode-work.
5. Report: what is good, what is wrong, what is risky, and your merge recommendation.

After I say "merge": fix the issues, run `git merge --no-ff opencode-work` into the default branch, re-run the tests, update CLAUDE.md or other docs only if the architecture changed, and add a closing entry to AI_SWITCH_LOG.md. Never push without my approval.
```

Tip: run `bash scripts/review.sh opencode-work` first. It gives the agent a deterministic summary to start from.
