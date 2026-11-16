# Architecture decision record conventions

## Purpose and authority

ADRs preserve material technical decisions and proposals. They do not replace `AGENT.md`, `AGENTS.md`, the approval register, business requirements or qualified professional reviews.

## Location and naming

- Store repository-wide architecture decisions in `.ai/architecture/`.
- Use `ADR-NNNN-short-kebab-case-title.md`, with a four-digit, zero-padded sequence.
- The sequence is repository-wide, unique and monotonically increasing; never reuse an identifier, even if an ADR is superseded or withdrawn.
- Before allocating an ID, inspect all ADR filenames and references across the repository. Do not infer the next ID from the largest visible number alone.
- Keep the identifier stable if a file is moved or its title changes; update links and preserve a redirect/note where compatibility requires it.
- Do not create empty ADR placeholders merely to fill sequence gaps.

## Required record fields

Every ADR must state:
- Identifier and concise title.
- Status: Proposed, Accepted, Rejected, Superseded or Withdrawn.
- Date created and date last reviewed.
- Decision authority and evidence for any owner approval.
- Scope, context and constraints.
- Decision or proposal, with alternatives and consequences.
- Security, data, migration, operational and rollback implications where relevant.
- Validation evidence and unresolved questions.
- Explicit approval boundary and links to the central approval register.

A proposed ADR is not an approved decision. An Accepted technical ADR does not imply business, legal, regulatory, accounting, pharmacy, security-risk or release approval.

## Existing sequence gap

The repository currently contains ADR-0001, ADR-0002, ADR-0004 and ADR-0005. ADR-0003 is absent from the inspected tree. Its subject and history are unknown; do not invent or backfill it. Keep the gap reserved unless repository history or an owner-supplied source establishes its intended record. New ADR allocation must inspect history and avoid assuming ADR-0006 is available until confirmed.

## Review and lifecycle

- Use Proposed while options are under evaluation.
- Use Accepted only for a recorded technical decision by the authorized technical decision-maker; link any required owner approval.
- Supersede rather than silently rewrite a material decision. Preserve the original and link its successor.
- Record rejected/withdrawn rationale and date.
- Update affected task profiles, current-state and open questions only when evidence changes.
