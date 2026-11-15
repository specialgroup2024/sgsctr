---
name: pharmacy-inventory
description: Discover, design or implement approved pharmacy catalogue and inventory capabilities while preserving safety and professional approval gates.
---

# Workflow
1. Read the Egypt monitoring policy, source register, requirements/evidence registers, pharmacy-domain profile and approval register.
2. Identify whether the task concerns catalogue, supplier, purchasing, receiving, batch/expiry, storage, stock, transfer, recall or costing.
3. Check the exact approved phase. INV-01 is generic Draft-only product identity, units/conversions and pharmacy-location reference metadata. INV-OWN-001 separately authorizes INV-B draft supplier identity/evidence references and pending review requests only; Q51 qualification and purchasing authority remain pending. Transactional stock workflows stay gated.
4. For regulated attributes, retrieve current original Egyptian evidence and record source class, publication/effective date, applicability and coverage gaps.
5. Separate owner-provided facts, verified evidence, provisional proposals and qualified professional decisions.
6. Define tests for authorization, auditability, duplicate handling, unit conversions, concurrency and integrity within authorized scope.
7. Keep product activation, stock mutation, dispensing, recall disposition and valuation disabled until their gates are approved.

# Guardrails
- Never make clinical decisions or invent storage/handling requirements.
- Do not infer product taxonomy, EPTTS applicability or site licensing from examples.
- A proposed field or AI evidence assessment is not pharmacist/regulatory approval.

# References
See roles/pharmacy-domain.md, pharmacy inventory requirements and approval pack, and governance/egypt-requirements-register.md.
