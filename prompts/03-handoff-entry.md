# Prompt 3: Handoff entry

**Where:** the backup agent.
**When:** the session is ending, or you are about to run out of quota again.

```
handoff. Append an entry to AI_SWITCH_LOG.md following the format in that file: task, files changed, tests run with the real result, done / pending / known problems, commits. Then run git status and show it. Do not push.
```

Afterwards run `git status` yourself. Only the files you asked for should appear. A `.env` file must never appear.
