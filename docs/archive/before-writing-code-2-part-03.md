# Before writing code_2.md — part 3

<!-- Archived from Before writing code_2.md; original lines 327-481. -->

- Manage assigned branches.
- Monitor branch performance.
- View operational reports.
- Manage authorized employees.

## Branch Manager

- Manage assigned branch operations.
- Manage branch employees.
- Monitor branch transactions.
- Access branch reports.

## Accountant

- Manage financial records.
- Manage expenses.
- Manage invoices.
- Access authorized financial reports.

## Inventory Manager

- Manage products.
- Manage stock.
- Manage stock transfers.
- Monitor inventory movements.

## Employee

- Access assigned operational functions.
- Perform authorized transactions.
- View permitted information.

Important:

Do not implement permissions as hardcoded role checks everywhere.

Use a flexible permission-based authorization architecture.

Support permissions such as:

- Organization.View
- Organization.Manage
- Branch.View
- Branch.Create
- Branch.Update
- Branch.Delete
- Employee.View
- Employee.Create
- Employee.Update
- Inventory.View
- Inventory.Manage
- Reports.View
- Finance.View
- Finance.Manage

Users must only access functionality and data authorized by their permissions.

---

# 5\. DEVELOPMENT WORKFLOW

Follow these development phases in sequence.

## PHASE 1: Requirements Analysis

Before writing code:

1. Understand the business objective.
2. Identify the business type.
3. Identify application users.
4. Identify organization requirements.
5. Identify branch management requirements.
6. Identify operational modules.
7. Identify business rules.
8. Identify data entities.
9. Identify entity relationships.
10. Identify user roles.
11. Identify permissions.
12. Identify security requirements.
13. Identify reporting requirements.
14. Identify external integrations.

Produce:

- Project overview.
- Functional requirements.
- Non-functional requirements.
- Business workflows.
- Application modules.
- User roles.
- Permission matrix.
- Database entity list.
- Entity relationships.
- Proposed architecture.

Ask focused questions when critical business requirements are missing.

Do not invent important business rules.

## PHASE 2: Solution Architecture

Use Clean Architecture with modular separation of responsibilities.

Recommended solution structure:

MultiBranchManagement/ │ ├── src/ │ │ │ ├── MultiBranchManagement.Domain/ │ │ ├── Entities/ │ │ ├── Enums/ │ │ ├── ValueObjects/ │ │ ├── Interfaces/ │ │ └── Common/ │ │ │ ├── MultiBranchManagement.Application/ │ │ ├── Features/ │ │ ├── DTOs/ │ │ ├── Interfaces/ │ │ ├── Validators/ │ │ ├── Services/ │ │ └── Common/ │ │ │ ├── MultiBranchManagement.Infrastructure/ │ │ ├── Persistence/ │ │ ├── Configurations/ │ │ ├── Migrations/ │ │ ├── Repositories/ │ │ ├── Services/ │ │ └── Identity/ │ │ │ └── MultiBranchManagement.API/ │ ├── Controllers/ │ ├── Middleware/ │ ├── Extensions/ │ ├── Filters/ │ ├── Configuration/ │ ├── Program.cs │ └── appsettings.json │ ├── tests/ │ ├── UnitTests/ │ └── IntegrationTests/ │ ├── mobile/ │ └── MultiBranchManagement.Mobile/ │ ├── app/ │ ├── components/ │ ├── features/ │ ├── hooks/ │ ├── services/ │ ├── store/ │ ├── types/ │ ├── constants/ │ └── assets/ │ ├── docker/ ├── docs/ ├── docker-compose.yml └── README.md

Adjust the structure according to project complexity.

Use modular architecture to separate business modules.

Avoid placing all business logic inside API controllers.

## PHASE 3: Database Design

Design the PostgreSQL database carefully.

Potential core entities:

Organization Branch User Role Permission UserRole RolePermission UserBranch Department Employee AuditLog Notification Attachment ApplicationSetting

Additional entities depend on the business domain.

For every entity:

1. Define its primary key.
2. Define foreign keys.
3. Establish relationships.
4. Define appropriate data types.
5. Apply validation rules.
6. Define required and optional fields.
7. Configure indexes.
8. Define unique constraints.
9. Consider soft deletion.
10. Consider audit requirements.

Important database rules:

- Organization IDs must be correctly associated with their branches.
- Branch-specific records must be scoped to their organization and branch.
- Enforce data integrity through database constraints where appropriate.
- Use transactions for operations involving multiple related records.
- Avoid unnecessary database queries.
- Use pagination for large datasets.

Use EF Core Fluent API for complex relationships and database configurations.

Generate migrations and verify the resulting PostgreSQL schema.

## PHASE 4: Authentication and Authorization

Implement secure authentication.

Requirements:
