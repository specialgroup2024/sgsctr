# Repository policy gaps and safe handling

This record distinguishes defects that can be fixed technically from choices that require the repository owner or a qualified reviewer. It is not an approval record.

## Root legal and security scaffolding

- `LICENSE` is absent. Do not select MIT, Apache-2.0, GPL, proprietary terms or another licence on the owner's behalf. A licence changes rights and obligations; create the file only after the owner confirms the intended rights holder, grant and distribution model with appropriate advice.
- `SECURITY.md` is absent. Do not invent a security contact, response-time commitment, disclosure policy, safe-harbour statement or incident-handling authority. The owner must designate a monitored reporting channel and approve the disclosure/response policy before publishing one.
- Until those decisions exist, do not describe the repository as open-source licensed or publish a fabricated vulnerability-reporting contact. This is a documented owner decision gap, not a CI failure.

## Root historical filenames

- `Before writing code.md` and `Before writing code_2.md` are retained as historical navigation/reference material.
- They are not canonical agent policy; root `AGENT.md`, `AGENTS.md` and `.ai/` remain authoritative.
- Do not rename, delete or move them as a cosmetic cleanup. First inspect inbound links and preserve compatibility if the owner later authorizes archival relocation.

## Markdown link checker

- The checker supports documented repository-relative Markdown link forms and local heading fragments; it is not a complete CommonMark/GFM parser.
- No reproducible false-positive example was established in the current audit. Do not weaken or rewrite the checker based on an unverified claim.
- When a real false positive is found, add a minimal fixture reproducing it, state the Markdown syntax involved, and correct parser behavior without suppressing genuine broken-link failures.

## Approval-state machine readability

- The Markdown approval register already uses structured tables and a defined status vocabulary; it remains the authoritative human-readable record.
- It is not yet a formally versioned machine-readable approval contract. Do not introduce a second status store or infer approval from application test records.
- A future schema/API projection must preserve authority, scope, evidence, conditions, approver role/identity verification and the distinction between owner, professional, security and release gates. It requires technical/security review and owner authorization before becoming authoritative.
