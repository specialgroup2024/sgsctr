#!/usr/bin/env python3
"""Validate SGSCTR agent context, specialist routing and security policy references."""
from __future__ import annotations

import json
import sys
from pathlib import Path
from typing import Any

ROOT = Path(__file__).resolve().parents[1]
AI = ROOT / ".ai"
CONTEXT = AI / "agent-context.json"
ROUTING = AI / "governance" / "role-skill-routing.json"
SECURITY = AI / "governance" / "security-rules.json"
EXPECTED_ROLES = {
    "architect",
    "devils_advocate",
    "clueless_client",
    "subject_matter_expert",
    "maestro",
}


class ValidationError(Exception):
    pass


def load_json(path: Path) -> dict[str, Any]:
    try:
        value = json.loads(path.read_text(encoding="utf-8"))
    except (OSError, json.JSONDecodeError) as exc:
        raise ValidationError(f"{path.relative_to(ROOT)}: cannot read valid JSON: {exc}") from exc
    if not isinstance(value, dict):
        raise ValidationError(f"{path.relative_to(ROOT)}: root must be an object")
    if value.get("schema_version") != 1:
        raise ValidationError(f"{path.relative_to(ROOT)}: unsupported or missing schema_version")
    return value


def require_string_list(value: Any, label: str) -> list[str]:
    if not isinstance(value, list) or not value or not all(
        isinstance(item, str) and item.strip() for item in value
    ):
        raise ValidationError(f"{label}: expected a non-empty array of strings")
    return value


def check_reference(reference: str, label: str) -> None:
    candidate = (AI / reference).resolve()
    try:
        candidate.relative_to(ROOT.resolve())
    except ValueError as exc:
        raise ValidationError(f"{label}: path escapes repository: {reference}") from exc
    if not candidate.is_file():
        raise ValidationError(f"{label}: referenced file does not exist: {reference}")


def check_context(context: dict[str, Any]) -> set[str]:
    authority = context.get("authority")
    if not isinstance(authority, dict) or not authority:
        raise ValidationError("agent-context.json: authority must be a non-empty object")
    for key, value in authority.items():
        if not isinstance(value, str) or not value.strip():
            raise ValidationError(f"agent-context.json authority.{key}: expected a path")
        check_reference(value, f"agent-context.json authority.{key}")

    baseline = require_string_list(context.get("mandatory_baseline"), "agent-context.json mandatory_baseline")
    for index, path in enumerate(baseline):
        check_reference(path, f"agent-context.json mandatory_baseline[{index}]")

    profiles = context.get("task_profiles")
    if not isinstance(profiles, dict) or not profiles:
        raise ValidationError("agent-context.json: task_profiles must be a non-empty object")
    for profile, paths in profiles.items():
        for index, path in enumerate(require_string_list(paths, f"task_profiles.{profile}")):
            check_reference(path, f"task_profiles.{profile}[{index}]")
    return set(profiles)


def check_routing(routing: dict[str, Any], profile_names: set[str]) -> None:
    rules = routing.get("selection_rules")
    if not isinstance(rules, dict):
        raise ValidationError("role-skill-routing.json: selection_rules must be an object")
    for index, path in enumerate(require_string_list(rules.get("always_load"), "selection_rules.always_load")):
        check_reference(path, f"selection_rules.always_load[{index}]")

    roles = routing.get("stable_roles")
    if not isinstance(roles, dict) or set(roles) != EXPECTED_ROLES:
        raise ValidationError(
            "role-skill-routing.json: stable_roles must contain exactly the five canonical roles"
        )
    for role, definition in roles.items():
        if not isinstance(definition, dict):
            raise ValidationError(f"stable_roles.{role}: expected an object")
        for index, path in enumerate(
            require_string_list(definition.get("reference_candidates"), f"stable_roles.{role}.reference_candidates")
        ):
            check_reference(path, f"stable_roles.{role}.reference_candidates[{index}]")

    specializations = routing.get("specializations")
    if not isinstance(specializations, dict) or not specializations:
        raise ValidationError("role-skill-routing.json: specializations must be a non-empty object")
    for name, definition in specializations.items():
        if not isinstance(definition, dict):
            raise ValidationError(f"specializations.{name}: expected an object")
        require_string_list(definition.get("when"), f"specializations.{name}.when")
        for index, path in enumerate(
            require_string_list(definition.get("references"), f"specializations.{name}.references")
        ):
            check_reference(path, f"specializations.{name}.references[{index}]")
        profiles = require_string_list(definition.get("profiles"), f"specializations.{name}.profiles")
        for profile in profiles:
            if profile not in profile_names:
                raise ValidationError(
                    f"specializations.{name}: task profile is not defined in agent-context.json: {profile}"
                )


def check_security_policy(policy: dict[str, Any]) -> None:
    authority = policy.get("authority")
    if not isinstance(authority, dict) or not authority:
        raise ValidationError("security-rules.json: authority must be a non-empty object")
    for key, value in authority.items():
        if not isinstance(value, str) or not value.strip():
            raise ValidationError(f"security-rules.json authority.{key}: expected a path")
        check_reference(value, f"security-rules.json authority.{key}")
    for section in ("data_boundaries", "secret_handling", "logging_and_artifacts", "agent_and_tool_boundaries"):
        if not isinstance(policy.get(section), dict):
            raise ValidationError(f"security-rules.json: missing object section {section}")
    if not isinstance(policy.get("approval_boundary"), str) or not policy["approval_boundary"].strip():
        raise ValidationError("security-rules.json: approval_boundary must be a non-empty string")


def main() -> int:
    try:
        context = load_json(CONTEXT)
        routing = load_json(ROUTING)
        security = load_json(SECURITY)
        profiles = check_context(context)
        check_routing(routing, profiles)
        check_security_policy(security)
    except ValidationError as exc:
        print(f"AI governance validation failed: {exc}", file=sys.stderr)
        return 1
    print("AI governance validation passed: JSON structure, five-role routing, task profiles and referenced paths are valid.")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
