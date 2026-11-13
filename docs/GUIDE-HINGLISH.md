# Project Bridge: Hinglish step-by-step guide

Yeh guide un logon ke liye hai jo Claude Code ki limit hit hone par apna **same project** OpenCode se continue karna chahte hain, aur limit reset hone par wapas Claude Code mein aana chahte hain. Sab kuch simple steps mein.

Dhyan rakho: Windows par `.sh` scripts **Git Bash** se chalao (Git for Windows ke saath aata hai). OpenCode Desktop beta hai, buttons ke naam thode alag ho sakte hain.

## Pehle ye samajh lo

- Project = tumhara folder + git. Chat history ek agent se dusre agent ko **nahi** jaati. Files aur git jaate hain.
- Tumhare `.env`, logins, API keys aur installs switch se **nahi badalte**. Bas backup agent ko unhe chhoone se rokna hai. Yeh kaam `AGENTS.md` karta hai.
- Backup agent alag branch (`opencode-work`) par kaam karta hai, to tumhara main branch safe rehta hai.

## Part 1: Setup (ek baar)

1. Agar tumhara worker ya server background mein chal raha hai, to band kar do.
2. Apne **project folder** mein Git Bash kholo. Phir:
   ```bash
   bash ~/.claude/skills/project-bridge/scripts/preflight.sh opencode --dry-run
   ```
   Yeh sirf check karta hai, kuch badalta nahi. Output mein `[FAIL]` aaye to pehle use theek karo (jaise uncommitted changes commit karo, ya `.env` ko git se hatao).
3. Sab `[ OK ]` ho to asli run:
   ```bash
   bash ~/.claude/skills/project-bridge/scripts/preflight.sh opencode
   ```
   Isse ek **checkpoint tag** aur `opencode-work` **branch** ban jaati hai.
4. `templates/AGENTS.md` aur `templates/AI_SWITCH_LOG.md` ko apne project folder mein copy karo (project ki root mein). Tumhare `CLAUDE.md` ko mat chhedo.
5. OpenCode Desktop kholo, **exact project folder** open karo, aur model chuno.
6. **Plan** mode (read-only) lagao aur `prompts/01-onboard-readonly.md` paste karo. `[REPLY_LANGUAGE]` ki jagah `Hinglish` likho.
7. Uski report padho. Sahi lage to aage badho.

## Part 2: Roz ka kaam

1. Har kaam se pehle terminal mein `git branch --show-current` chalao. `opencode-work` aana chahiye.
2. **Build** mode mein `prompts/02-one-task.md` paste karo. `TASK:` mein **sirf ek kaam** likho.
3. Agent pehle batayega ki kaun si files badlega. Sahi lage to `yes` bolo.
4. Permission pop-up par: `git status/log/diff` aur tests **allow**. `install`, `push`, `reset`, `.env`, deploy, publish **deny**.
5. Model atak jaye to dusra model chuno aur wahi prompt dobara do.
6. Kaam khatam ho to `prompts/03-handoff-entry.md` paste karo. Phir `git status` chalao. `.env` kabhi nahi dikhna chahiye.

## Part 3: Claude Code wapas aaye

1. OpenCode band karo. Terminal mein:
   ```bash
   bash ~/.claude/skills/project-bridge/scripts/review.sh opencode-work
   ```
2. Claude Code mein `prompts/04-review-and-merge.md` paste karo. **Naya kaam isse pehle mat do.**
3. Report padho. Sab theek ho tabhi `merge` bolo.
4. Agli baar ke liye Part 1 dobara karo (naya `opencode-work` branch banega).

## Kuch bigad jaye to

- Main branch par jao: `git checkout main` (ya `master`). Woh untouched hai.
- Checkpoint tag dekhne ke liye: `git tag`.
- Branch tabhi delete karo jab pakka ho ki uska kaam nahi chahiye.

## Yaad rakhne wali baatein

- Free models tumhara code unke provider ko bhejte hain. Unki data policy ek baar padh lo.
- Free ya chhote models galti kar sakte hain. Isliye ek baar mein ek hi kaam, aur har kaam ke baad test.
- Yeh guide **development** ke liye hai. Agar tumhara app khud runtime par Claude use karta hai, to us fallback ke liye alag feature banana padega.
