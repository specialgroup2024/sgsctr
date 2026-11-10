# Before writing code_2.md — part 2

<!-- Archived from Before writing code_2.md; original lines 164-326. -->

- Responsive mobile interfaces.
- Reusable components.
- Consistent design system.
- Centralized API client.
- Authentication management.
- Protected navigation.
- Loading states.
- Error handling.
- Form validation.
- Pagination.
- Search and filtering.
- Push notifications when required.
- Offline capabilities when required.

Use TypeScript throughout the frontend.

Avoid unnecessary duplication of API communication logic.

## D. Additional Recommended Technologies

Use additional technologies according to actual requirements.

Caching:

- Redis.

Background processing:

- Hangfire.

Real-time communication:

- SignalR.

File storage:

- S3-compatible object storage or Azure Blob Storage.

Image processing:

- Appropriate image-processing libraries.

Notifications:

- Firebase Cloud Messaging.

API documentation:

- Swagger / OpenAPI.

Testing:

- xUnit.
- FluentAssertions.
- WebApplicationFactory.
- Jest.
- React Native Testing Library.

Development tools:

- Visual Studio.
- Visual Studio Code.
- Rider.
- Docker.
- Docker Compose.
- Git.
- GitHub.
- Postman.

CI/CD:

- GitHub Actions.

Monitoring:

- Serilog.
- OpenTelemetry.
- Application performance monitoring where required.

Do not introduce unnecessary technologies without a clear business or technical justification.

---

# 3\. MULTI-BRANCH BUSINESS ARCHITECTURE

This is a critical requirement.

The application must be designed around a centralized organization with multiple branches.

Recommended hierarchy:

Organization | |--- Head Office | |--- Branch 1 | |--- Employees | |--- Departments | |--- Transactions | |--- Inventory | |--- Reports | |--- Branch 2 | |--- Employees | |--- Departments | |--- Transactions | |--- Inventory | |--- Reports | |--- Branch 3 |--- Employees |--- Departments |--- Transactions |--- Inventory |--- Reports

## Multi-Branch Requirements

The system must support:

1. Creating and managing organizations.
2. Creating unlimited branches according to subscription or business limits.
3. Assigning employees to specific branches.
4. Assigning employees to multiple branches when authorized.
5. Assigning different permissions to different branches.
6. Switching between authorized branches.
7. Viewing consolidated organization-wide reports.
8. Viewing branch-specific reports.
9. Managing branch-specific configurations.
10. Tracking activities across branches.
11. Managing centralized users.
12. Supporting branch transfers where applicable.

## Data Isolation

Every branch-related business record must be associated with the correct organization and branch.

Examples:

- Products.
- Inventory.
- Sales.
- Purchases.
- Expenses.
- Employees.
- Customers.
- Suppliers.
- Transactions.
- Reports.

Implement server-side organization and branch authorization.

Never rely on a branch ID supplied by the mobile application as proof of authorization.

The backend must verify that the authenticated user is authorized to access the requested organization and branch.

Prevent unauthorized cross-branch data access.

For a multi-organization SaaS application, implement organization-level tenant isolation in addition to branch-level access control.

---

# 4\. USER ROLES AND PERMISSIONS

Design a flexible authorization system.

Suggested roles:

## System Administrator

- Manage the entire application.
- Manage organizations.
- Manage subscriptions.
- Manage system configurations.
- Monitor application activity.

## Organization Owner

- Manage organization information.
- Create and manage branches.
- Manage organization-wide users.
- Access consolidated reports.
- Configure organization-wide settings.

## General Manager
