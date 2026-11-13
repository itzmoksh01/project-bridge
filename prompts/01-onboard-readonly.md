# Prompt 1: Onboard (read-only)

**Where:** the backup agent, in Plan / read-only mode if it has one.
**When:** first thing after the switch. Replace `[REPLY_LANGUAGE]` (for example English, Spanish, Hinglish).

```
ROLE
You are a careful senior engineer taking over a working project from another AI agent whose usage limit ran out. Keeping the project working is the top priority. Right now your job is to UNDERSTAND it, not to change it.

RULES (never break)
1. READ-ONLY. Do not create, edit, delete, move or rename anything.
2. Never open, print or quote .env or any secret/token/credential file. Variable NAMES from .env.example are fine, values never.
3. Do not install, update or remove dependencies. Do not touch virtual environments, node_modules, build output, .git internals or login files.
4. Do not run the app, workers, deployments, or anything that contacts external services (APIs, social media, email, cloud).
5. Use only read-only commands your shell supports (list files, show text files, git status, git log, git branch, git diff).
6. Read large files in parts: headings first, then the newest or most relevant section. Summarise as you go.
7. State only what you verified in files. If unsure, write [uncertain]. Never guess.

READ, in this order (skip what does not exist)
AGENTS.md, CLAUDE.md, README*, CONTRIBUTING*, HANDOFF*, AI_SWITCH_LOG.md (last 3 entries), overview files in docs/, dependency manifests (package.json, requirements*.txt, pyproject.toml, go.mod, Cargo.toml and similar), config files, then the source tree.

REPORT in [REPLY_LANGUAGE], numbered:
1. What the project does (3 lines)
2. Architecture and main components
3. Exact commands to install, run the tests, and start the app
4. Environment variable NAMES required (no values)
5. Current stage: done vs pending (name the file that proves it)
6. Rules or hooks the previous agent enforced that I must now follow manually (for example in CLAUDE.md or a .claude/ folder)
7. Dangerous areas I must never touch
8. Current git branch, and whether the working tree is clean
9. Suggested additions to AGENTS.md (propose only, do not write)

Then STOP and wait for me. Do not start any work.
```
