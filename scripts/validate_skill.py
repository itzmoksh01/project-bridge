#!/usr/bin/env python3
"""Dependency-free sanity checks for the Project Bridge skill package."""
from __future__ import annotations
import json
import re
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
SKILL_FILE = ROOT / "SKILL.md"
README_FILE = ROOT / "README.md"
TEMPLATE_FILE = ROOT / "templates" / "HANDOFF.md"
SCHEMA_FILE = ROOT / "templates" / "HANDOFF-RECEIPT.schema.json"
EXAMPLE_FILE = ROOT / "templates" / "HANDOFF-RECEIPT.example.json"


def fail(message: str) -> None:
    print(f"FAIL: {message}")
    raise SystemExit(1)


def main() -> int:
    required = [SKILL_FILE, README_FILE, TEMPLATE_FILE, ROOT / "LICENSE", SCHEMA_FILE, EXAMPLE_FILE]
    for path in required:
        if not path.is_file():
            fail(f"Required file is missing: {path.relative_to(ROOT)}")

    content = SKILL_FILE.read_text(encoding="utf-8")
    if not content.startswith("---\n"):
        fail("SKILL.md must begin with YAML frontmatter.")
    end = content.find("\n---\n", 4)
    if end == -1:
        fail("Could not find the closing YAML frontmatter delimiter.")
    frontmatter = content[4:end]
    name_match = re.search(r"(?m)^name:\s*([a-z0-9]+(?:-[a-z0-9]+)*)\s*$", frontmatter)
    description_match = re.search(r"(?m)^description:\s*(.+)$", frontmatter)
    if not name_match:
        fail("Frontmatter must contain a lowercase kebab-case name.")
    if not description_match:
        fail("Frontmatter must contain a description.")
    skill_name = name_match.group(1)
    if skill_name != ROOT.name:
        fail(f"Skill name ({skill_name}) must match its folder name ({ROOT.name}).")
    if len(skill_name) > 64:
        fail("Skill name must be 64 characters or fewer.")
    description = description_match.group(1).strip().strip("'\"")
    if not description or len(description) > 1024:
        fail("Description must be between 1 and 1024 characters.")
    required_sections = (
        "## Mission", "## Non-negotiable safety rules", "## Choose the correct workflow",
        "## Understand what is and is not shared", "## Final response format",
        "## Initial platform focus", "## Handoff note and optional portable receipt",
    )
    missing = [section for section in required_sections if section not in content]
    if missing:
        fail("Missing required skill sections: " + ", ".join(missing))
    if "templates/HANDOFF.md" not in content or "templates/HANDOFF-RECEIPT.schema.json" not in content:
        fail("SKILL.md must reference both human and machine-readable templates.")

    try:
        schema = json.loads(SCHEMA_FILE.read_text(encoding="utf-8"))
        example = json.loads(EXAMPLE_FILE.read_text(encoding="utf-8"))
    except json.JSONDecodeError as exc:
        fail(f"Receipt schema/example contains invalid JSON: {exc}")
    if schema.get("$schema") != "https://json-schema.org/draft/2020-12/schema":
        fail("Receipt schema must declare JSON Schema Draft 2020-12.")
    if example.get("schema_version") != "1.0":
        fail("Receipt example must declare schema_version 1.0.")
    expected = set(schema.get("required", []))
    missing_keys = expected - set(example)
    if missing_keys:
        fail("Receipt example is missing required top-level keys: " + ", ".join(sorted(missing_keys)))
    if any(key.lower() in {"password", "token", "secret", "api_key", "private_key"} for key in example):
        fail("Receipt example must not include credential-like keys.")

    print("PASS: required Project Bridge package files exist")
    print(f"PASS: skill ID matches package folder ({skill_name})")
    print(f"PASS: skill description length is {len(description)} characters")
    print("PASS: required workflows and opt-in receipt guidance are present")
    print("PASS: receipt schema and example are valid JSON with required top-level fields")
    print("NOTE: this dependency-free check does not perform full JSON Schema validation or runtime agent tests.")
    print("\nProject Bridge package sanity checks passed.")
    return 0


if __name__ == "__main__":
    sys.exit(main())
