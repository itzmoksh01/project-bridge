# Security Policy

## Scope

This project contains instructions for AI coding agents. A skill is not a sandbox, permission system, or guarantee that an agent will behave safely. Users should review the skill, configure host-agent permissions, keep backups, and inspect proposed tool calls and diffs.

## Reporting a vulnerability

Please do not publish secrets, exploit details, private project files, or active vulnerabilities in a public issue.

Use GitHub's **Private vulnerability reporting** feature for this repository if it is enabled. If it is not enabled, contact the repository maintainer through the contact method listed on the GitHub profile and provide only the minimum information needed to start a private discussion.

## Secret exposure

If a real credential is accidentally committed:

1. Revoke or rotate the credential immediately with its provider.
2. Treat it as compromised even if the commit or file is later deleted.
3. Review repository access and relevant service logs.
4. Follow the provider's guidance for remediation.

Deleting a secret from the latest version does not remove it from Git history or copies already made by others.

## Supported versions

Security reports are welcome for the latest published version. Older versions may not receive fixes.
