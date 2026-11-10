# Product vision

Build a secure business application for:

1. A specialist contracting business.
2. A pharmacy group selling medicines, chemotherapy medicines,
   general medicines, medical supplies, and cosmetics.

The system supports business operations and accounting records.
It does not make clinical decisions.

# Initial technology direction

- API and backend: ASP.NET Core.
- Database: PostgreSQL.
- Mobile client: React Native.
- Deployment and exact framework versions: record in
  .ai/architecture/system-context.md after confirming current support.

# Important product boundary

Keep the two business domains operationally and permission-wise separated, with sector-specific workflows, controls and management reporting. The statutory accounting model depends on verified legal identity and qualified accountant approval; do not assume either separate statutory ledgers or a shared statutory framework before that decision is confirmed. Shared infrastructure does not mean shared business rules or unrestricted cross-sector access.

# Users

Initial user roles and permissions are not yet approved.
Document roles and get business-owner approval before production access.
