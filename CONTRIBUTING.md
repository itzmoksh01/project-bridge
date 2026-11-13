# Contributing

Thanks for helping make Project Bridge safer and more useful.

## What we welcome

- Reproducible bugs or unsafe behaviors.
- Platform compatibility improvements backed by official documentation or hands-on testing.
- Better handoff templates and examples.
- Improvements to clarity, accessibility, translations, and documentation.
- Tests that catch regressions in the skill package.

## Before you start

1. Search existing issues and pull requests to avoid duplicates.
2. For large changes, open an issue first and describe the problem and proposed approach.
3. Never include private source code, real credentials, customer data, proprietary logs, or personal information.
4. Do not claim support for an agent or version unless you tested it or clearly label it as unverified.

## Local checks

Run:

```bash
python scripts/validate_skill.py
```

Review the complete diff before submitting:

```bash
git status --short
git diff --check
git diff
```

Do not use destructive Git commands to make a working tree look clean.

## Pull request checklist

- [ ] The change solves a clear, repeatable problem.
- [ ] `SKILL.md` remains focused and follows the Agent Skills format.
- [ ] Safety rules and user approval boundaries are preserved.
- [ ] No secrets, private paths, customer data, or proprietary code are included.
- [ ] Documentation and examples match actual behavior.
- [ ] Validation passes.
- [ ] New platform compatibility claims include tested versions or are marked unverified.

## Review philosophy

Prefer small, testable changes. Explain trade-offs. Preserve backwards compatibility where practical. Do not add automatic destructive behavior, hidden network calls, telemetry, or dependency installation to this skill.

By submitting a contribution, you agree that your contribution is provided under the repository's MIT license, unless a different license is explicitly stated for that contribution.
