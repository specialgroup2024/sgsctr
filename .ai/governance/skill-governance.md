# Skill and reusable-method governance

## Purpose

Skills are reusable methods and checklists; SGSCTR project facts, requirements, specifications and approved ADRs remain the source of project truth. A skill must not silently create business rules or replace an approval.

## Selection

1. Start from the task profile in `.ai/agent-context.json` and specialist routing in `.ai/governance/role-skill-routing.json`.
2. Load the smallest set of skills that materially supports the task.
3. Reuse an existing skill or role reference where it covers the method. Create a new skill only for a recurring, demonstrable method gap; do not create one merely to mirror a specialist title.
4. Select competencies dynamically. The catalogue is open-ended and illustrative, not a permanent roster or exhaustive list.
5. If an essential skill, source or qualified reviewer is unavailable, disclose the gap and do not simulate professional authority.

## Skill structure and quality

A reusable skill should state its purpose, when to use it, required inputs/context, ordered method, expected outputs/evidence, relevant controls, failure/stop conditions and links to authoritative SGSCTR references. Keep the entry file concise (target under 200 lines); move deep references into linked files. Avoid duplicating root policy, business requirements or full ADRs.

Skills must be:
- scoped to a repeatable method rather than a one-off task;
- compatible with root governance, security rules and human approval gates;
- explicit about assumptions, evidence, limitations and prohibited actions;
- grounded in the actual SGSCTR stack and domain only where verified;
- reviewed for stale links and contradictions when dependencies or policy change.

## Change and validation

When adding or changing a skill, explain the recurring need, inspect overlapping skills, update routing only when discovery materially improves, and update the generated index/manifest through the documented generator. Validate referenced paths and governance integrity. A skill's presence does not prove an agent discovered or followed it; behavioral evaluations are required for material changes to routing, skills, safety or tool permissions.

Do not import SG_WAP skill identifiers, stack-specific instructions or domain rules as SGSCTR requirements. Adapt generic methods to SGSCTR's verified technology, scope and approval model.
