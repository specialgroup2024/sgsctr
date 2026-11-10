# Before writing code_2.md — part 4

<!-- Archived from Before writing code_2.md; original lines 482-635. -->

- User login.
- User logout.
- Secure password hashing.
- JWT access tokens.
- Refresh token rotation.
- Token expiration.
- Secure token storage on mobile.
- Password reset.
- Account activation.
- Account locking when appropriate.
- Role management.
- Permission management.
- Branch-level authorization.

Use ASP.NET Core Identity where appropriate.

Implement server-side authorization policies.

Never trust user IDs, organization IDs, branch IDs, or permissions received from the frontend without validating them.

## PHASE 5: Backend API Development

Create RESTful APIs for every application module.

Follow consistent API conventions.

Examples:

Authentication:

POST /api/v1/auth/login

POST /api/v1/auth/refresh

POST /api/v1/auth/logout

Organization:

GET /api/v1/organizations

POST /api/v1/organizations

GET /api/v1/organizations/{id}

Branches:

GET /api/v1/branches

POST /api/v1/branches

GET /api/v1/branches/{id}

PUT /api/v1/branches/{id}

DELETE /api/v1/branches/{id}

Employees:

GET /api/v1/employees

POST /api/v1/employees

GET /api/v1/employees/{id}

PUT /api/v1/employees/{id}

DELETE /api/v1/employees/{id}

Dashboard:

GET /api/v1/dashboard/overview

GET /api/v1/dashboard/branches

Reports:

GET /api/v1/reports/organization

GET /api/v1/reports/branch/{branchId}

These are examples. Adapt endpoints to actual requirements.

Backend standards:

- DTOs.
- Validation.
- Dependency Injection.
- Async/await.
- Proper HTTP status codes.
- Pagination.
- Filtering.
- Sorting.
- Search.
- Global exception handling.
- Structured logging.
- Authorization.
- API versioning.

Use cancellation tokens for appropriate asynchronous operations.

## PHASE 6: Business Modules

Identify and implement the modules required by the business.

Potential modules include:

1. Organization Management.
2. Branch Management.
3. Employee Management.
4. User Management.
5. Role and Permission Management.
6. Department Management.
7. Inventory Management.
8. Product Management.
9. Customer Management.
10. Supplier Management.
11. Sales Management.
12. Purchase Management.
13. Expense Management.
14. Financial Management.
15. Branch Transfer Management.
16. Reporting and Analytics.
17. Notifications.
18. Audit Logs.
19. System Settings.

Do not assume that every business needs every module.

Analyze the actual business requirements and prioritize accordingly.

Every module must have a complete backend implementation and appropriate frontend integration.

## PHASE 7: React Native Mobile Application

Build a professional mobile application using React Native and TypeScript.

Use Expo Router for navigation when appropriate.

Implement:

- Authentication screens.
- Main dashboard.
- Organization selection when applicable.
- Branch selection.
- Branch switching.
- User profile.
- Employee management.
- Operational modules.
- Reports.
- Notifications.
- Settings.

Mobile application requirements:
