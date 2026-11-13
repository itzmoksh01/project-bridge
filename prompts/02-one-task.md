# Prompt 2: One task at a time

**Where:** the backup agent, in Build / edit mode.
**When:** for every new piece of work. Put exactly one task in `TASK`.

```
TASK: [describe exactly one task]

Follow AGENTS.md. Do ONLY this task and touch nothing else.
1. First tell me which files you will change and exactly what you will change. Wait for my "yes".
2. Make the smallest possible change. No new dependencies, no refactor.
3. Run the project's existing tests and show the real result. If a test needs a live service or internet, STOP and ask me.
4. If anything is unclear or risky, STOP and ask me.
After each step report: [done] | [files changed] | [test result]. Reply in [REPLY_LANGUAGE].
```
