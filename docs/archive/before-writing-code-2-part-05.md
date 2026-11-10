# Before writing code_2.md — part 5

<!-- Archived from Before writing code_2.md; original lines 636-800. -->

1. Reusable components.
2. Consistent UI design.
3. Responsive layouts.
4. Centralized API services.
5. Secure authentication.
6. Protected routes.
7. Form validation.
8. Loading indicators.
9. Error handling.
10. Empty states.
11. Pagination.
12. Search and filtering.
13. Appropriate state management.

The interface must display data returned by the backend.

Do not use hardcoded demonstration data for actual business functionality.

Every visible button and form must perform its intended action.

## PHASE 8: Dashboard and Reporting

Implement dynamic dashboards.

Organization dashboard:

- Total branches.
- Total employees.
- Organization-wide operational statistics.
- Branch performance comparison.
- Consolidated financial indicators where applicable.
- Recent activities.
- Alerts and notifications.

Branch dashboard:

- Branch-specific statistics.
- Employee information.
- Operational performance.
- Branch transactions.
- Inventory information where applicable.
- Recent activities.

Reports must respect user permissions.

Users should only see data they are authorized to access.

Use appropriate charting libraries for React Native.

## PHASE 9: Security and Production Readiness

Implement:

- JWT authentication.
- Refresh token security.
- Role-based authorization.
- Permission-based authorization.
- Organization isolation.
- Branch-level data isolation.
- Input validation.
- Secure file uploads.
- HTTPS.
- CORS configuration.
- Rate limiting.
- Secure configuration.
- Structured logging.
- Audit trails.
- Database access protection.
- Exception handling.

Follow OWASP recommendations.

Security must be enforced on the backend.

Never depend exclusively on frontend restrictions.

## PHASE 10: Testing and Quality Assurance

Test the entire application.

Backend:

- API endpoints.
- Database connectivity.
- Entity relationships.
- Authentication.
- Authorization.
- CRUD operations.
- Validation.
- Business logic.
- Organization isolation.
- Branch isolation.
- Transactions.
- Error handling.

Frontend:

- Authentication.
- Navigation.
- Branch switching.
- Forms.
- API integration.
- State management.
- Error handling.
- Loading states.
- UI responsiveness.

Critical multi-branch tests:

1. Organization A cannot access Organization B data.
2. Branch 1 employees cannot access unauthorized Branch 2 data.
3. Organization owners can access authorized consolidated reports.
4. Branch managers can only manage assigned branches.
5. Unauthorized users cannot perform restricted operations.
6. Branch transfers preserve data integrity.
7. Branch switching updates the displayed operational context correctly.

Create automated unit and integration tests.

Run builds and tests whenever the environment supports them.

Fix discovered errors before declaring completion.

## PHASE 11: Deployment and Documentation

Prepare the application for deployment.

Backend deployment:

- ASP.NET Core hosting.
- PostgreSQL configuration.
- Database migrations.
- Environment variables.
- HTTPS.
- Logging.
- Monitoring.

Mobile deployment:

- Android builds.
- iOS builds.
- Environment-specific API configuration.
- Application signing.
- Production API integration.

Use Docker where appropriate.

Prepare Docker Compose for local development.

Provide:

1. Project overview.
2. Technology stack.
3. Architecture documentation.
4. Database schema.
5. API documentation.
6. Installation instructions.
7. Environment configuration.
8. Migration instructions.
9. Development execution instructions.
10. Testing instructions.
11. Deployment instructions.

---
