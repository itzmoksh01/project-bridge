# Portable Handoff Receipt

Project Bridge can optionally create a machine-readable JSON receipt for a handoff. It is **opt-in**: the agent must not create it unless the user explicitly requests or approves it.

## Why it exists

A Markdown handoff is easy for people to read. A JSON receipt makes key facts easier for tools and future agents to parse consistently. Neither replaces inspection of the actual working directory.

## Files

- `templates/HANDOFF-RECEIPT.schema.json` — JSON Schema (Draft 2020-12).
- `templates/HANDOFF-RECEIPT.example.json` — illustrative, synthetic example.
- `templates/HANDOFF.md` — human-readable handoff structure.

## Privacy and integrity rules

1. Ask before creating the receipt. Also confirm the destination path if the user has not supplied one.
2. Do not silently save it in a project root, stage it, commit it, or push it.
3. Never include secret values, tokens, passwords, private keys, connection strings, customer data, or private source-code excerpts.
4. Avoid absolute paths, personal usernames, private repository URLs, and machine-specific details. Use repository-relative file paths only when useful.
5. Record only facts verified during this handoff. Use `unknown` for unavailable state; do not infer branch, remote synchronization, tests, or agent shutdown.
6. The receiving agent must compare the receipt with the real workspace and report discrepancies before editing.
7. Consider whether the note itself should be excluded from version control. A handoff can contain sensitive business context even when it contains no credentials.

## Suggested workflow

1. Complete the normal outgoing handoff inspection.
2. Show the user the proposed fields and any potentially sensitive metadata.
3. Obtain approval to create the JSON receipt and confirm its path.
4. Generate JSON using the schema and example.
5. Validate JSON syntax and schema conformance with a JSON Schema validator when available. If no validator is available, say so; do not claim schema validation occurred.
6. Re-open the saved receipt, check that it contains no secrets or unnecessary local identifiers, and report its path.
7. The incoming agent reads it as context, then independently inspects the Git state and project files.

## Versioning

`schema_version` identifies the receipt structure, independently of the Project Bridge skill release. A future incompatible format change should increment the major schema version and preserve a migration note. Unknown or newly added fields must not be silently guessed by older readers.
