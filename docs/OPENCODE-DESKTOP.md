# Using Project Bridge with OpenCode Desktop

This page covers the OpenCode side of a limit-safe switch (Workflow F in `SKILL.md`). The Desktop app is a beta, so button names may differ from this page. If something looks different, trust what you see on screen and check the [OpenCode docs](https://opencode.ai/docs).

## 1. Install

The terminal version (`opencode`) and the Desktop app are separate installs. Download only from the official site: **opencode.ai/download**. Many unofficial forks exist.

## 2. Install the skill (optional)

OpenCode looks for skills in `~/.config/opencode/skills` and, for compatibility, in `~/.claude/skills`. If you already installed Project Bridge for Claude Code, OpenCode can find it too. Skills are loaded by the agent through its native `skill` tool, so you ask: *"Use the project-bridge skill to ..."*. Check that your agent's `skill` permission is not set to `deny`.

You do not need the skill to use the switch. The files in `templates/` and `prompts/` work on their own.

## 3. Prepare the project (outside the app)

From the project folder, in a terminal (Git Bash on Windows):

```bash
bash <path-to-project-bridge>/scripts/preflight.sh opencode --dry-run
bash <path-to-project-bridge>/scripts/preflight.sh opencode
```

Then copy `templates/AGENTS.md` and `templates/AI_SWITCH_LOG.md` into the project root.

## 4. Open the project in the app

1. Open **OpenCode Desktop** and use the *Open project* / *Add project* option.
2. Choose the **exact project folder**, not its parent.
3. If the app offers a worktree, a new workspace or a copy of the project, decline. You want the real folder on the `opencode-work` branch.
4. Confirm the branch from a terminal: `git branch --show-current` must print `opencode-work`.

## 5. Pick a model and a mode

- Click the model name near the message box and choose a model.
- Start in the **Plan** agent for the initial audit. With OpenCode’s shipped defaults, Plan denies file edits except within its plan-file area; shell-command permissions are controlled separately by the active configuration and may allow, ask, or deny a command. Do not treat Plan as a complete security sandbox. Review the active permissions before starting. See the [OpenCode permissions documentation](https://opencode.ai/docs/permissions/). Switch agents with the selector or the Tab key.
- Paste [`prompts/01-onboard-readonly.md`](../prompts/01-onboard-readonly.md).
- After you have read its report, switch to **Build** and use [`prompts/02-one-task.md`](../prompts/02-one-task.md) for each task.

If a model gets stuck or rate-limited, pick another model in the same session and repeat the prompt. The state lives in your files, not in the model.

## 6. Permission pop-ups

Permission behavior is configurable and can differ between OpenCode versions, agents, and project/global settings. A Plan agent denying edits does **not** mean every shell command will trigger an approval prompt. Check the active rules and inspect each requested command before approving it.

| Allow | Deny |
| --- | --- |
| `git status`, `git log`, `git branch`, `git diff` | anything with `install`, `push`, `reset`, `clean` |
| Reading project files | anything that opens `.env` |
| Running the project's own tests, when you asked for it | anything that deploys, publishes, posts or sends email |

## 7. House rules

- **One writer at a time.** Do not use the terminal agent and the Desktop app on the same folder together.
- Never open `.env` in the app's file viewer.
- Free or small models can be wrong. Keep tasks small and run the tests.
- Free models send your code to their provider. Read the provider's data policy first.

## 8. When your main agent is back

Close the app, open your main agent in the same folder, and use [`prompts/04-review-and-merge.md`](../prompts/04-review-and-merge.md). Run `scripts/review.sh opencode-work` first.
