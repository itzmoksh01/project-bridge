# Release checklist

Use this checklist for every Project Bridge release. A green package-validation workflow is necessary, but it does not prove that the skill behaves correctly inside a coding agent.

## 1. Prepare the release

- [ ] Start from an up-to-date `main` branch and confirm the working tree is clean.
- [ ] Choose the version using Semantic Versioning:
  - **PATCH**: backward-compatible fixes and documentation corrections.
  - **MINOR**: backward-compatible capabilities or workflows.
  - **MAJOR**: incompatible skill behavior, receipt schema, or supported interface changes.
- [ ] Update the version in all three places: `SKILL.md` metadata, the README version badge, and the first heading in `CHANGELOG.md`.
- [ ] Add a changelog entry that describes user-visible changes, fixes, and known limitations.
- [ ] Review installation commands, links, badge URLs, issue forms, and support/security guidance.
- [ ] Inspect the staged diff for credentials, private paths, personal data, generated files, and unrelated changes.

## 2. Validate the candidate

Run from the repository root:

```bash
python scripts/validate_skill.py
bash scripts/test_scripts.sh
shellcheck scripts/*.sh
```

- [ ] All three local checks pass.
- [ ] GitHub Actions passes on the exact commit intended for release.
- [ ] Review the complete workflow log; do not rely only on a green badge.
- [ ] Complete the relevant sections of [MANUAL-TEST-PLAN.md](MANUAL-TEST-PLAN.md) for each platform/version being claimed as tested.
- [ ] Keep untested platform/version combinations explicitly marked **runtime test pending**.

## 3. Publish

After the candidate is merged to `main`:

```bash
git checkout main
git pull --ff-only
git tag -a vX.Y.Z -m "Project Bridge vX.Y.Z"
git push origin vX.Y.Z
```

Then create a GitHub Release for that tag. Include:

- A concise summary of the user problem addressed.
- Added, changed, and fixed behavior.
- Exact automated checks and manual platform tests performed.
- Known limitations and compatibility status.
- Upgrade notes for any changed installation or receipt behavior.

Do not claim a platform/version is supported based only on package validation. If runtime testing is still pending, mark the GitHub Release as a **pre-release** and say so plainly.

## 4. After publication

- [ ] Confirm the release points to the intended tag and commit.
- [ ] Confirm the release notes match the changelog.
- [ ] Verify the repository's latest release and README version agree.
- [ ] Monitor new issues for installation failures, incorrect assumptions, and security reports.

## Release integrity rules

- Never tag an unreviewed or dirty working tree.
- Never move or overwrite an existing published tag to hide a mistake; publish a corrective version instead.
- Never include project-specific handoff receipts, environment files, credentials, or user data in release assets.
- GitHub's automatically generated source archives are sufficient for this skill; attach extra binaries only when they add real value.
