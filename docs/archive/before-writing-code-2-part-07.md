# Before writing code_2.md — part 7

<!-- Archived from Before writing code_2.md; original lines 942-1055. -->

| Layer | Recommended technology |
| --- | --- |
| Backend | ASP.NET Core Web API |
| Programming language | C# |
| Framework | .NET 10 LTS |
| Architecture | Clean Architecture + Modular Monolith |
| Database | PostgreSQL |
| ORM | Entity Framework Core |
| PostgreSQL provider | Npgsql |
| Authentication | ASP.NET Core Identity + JWT |
| Authorization | RBAC + Permission-Based Authorization |
| Mobile application | React Native |
| Mobile framework | Expo |
| Frontend language | TypeScript |
| Navigation | Expo Router |
| Server state | TanStack Query |
| Client state | Zustand |
| Forms | React Hook Form |
| Validation | FluentValidation + Zod |
| API communication | REST API + Axios |
| UI components | React Native Paper |
| Real-time communication | SignalR |
| Caching | Redis |
| Background jobs | Hangfire |
| File storage | S3-compatible storage |
| Push notifications | Firebase Cloud Messaging |
| Backend testing | xUnit |
| Frontend testing | Jest + React Native Testing Library |
| API documentation | Swagger / OpenAPI |
| Containerization | Docker |
| CI/CD | GitHub Actions |
| Logging | Serilog |
| Monitoring | OpenTelemetry |

## 3\. Important architectural recommendations for multi-branch applications

There are five particularly important things I recommend adding to your architecture.

### 1\. Organization and branch isolation

Don't simply add `BranchId` to every table and assume the system is secure.

Design authorization and data-access rules that enforce:

- Organization-level isolation.
- Branch-level isolation.
- User-to-branch assignments.
- Permission-based access.
- Centralized reporting.

### 2\. Centralized dashboard

The organization owner should be able to see all branches from one dashboard.

For example:

| Indicator | Branch A | Branch B | Branch C | Total |
| --- | --- | --- | --- | --- |
| Employees | 15 | 12 | 20 | 47 |
| Sales | 50,000 | 35,000 | 65,000 | 150,000 |
| Expenses | 12,000 | 8,000 | 15,000 | 35,000 |

The dashboard should retrieve actual information from PostgreSQL through secured APIs.

### 3\. Branch switching

A user assigned to multiple branches should be able to switch branches without logging out.

The backend must validate the user's access whenever the active branch changes.

### 4\. Audit logging

For management applications, track important activities:

- Who created a record?
- Who modified it?
- Which branch was affected?
- When did the operation happen?
- What information changed?

This is particularly important for financial and inventory operations.

### 5\. Centralized and branch-specific permissions

For example:

- Organization owner: Access to all branches.
- General manager: Access to assigned branches.
- Branch manager: Access to their branch.
- Accountant: Access to authorized financial information.
- Employee: Access to assigned operational functions.

---

## 4\. One additional recommendation: Consider a web administration dashboard

Although React Native is excellent for mobile applications, I recommend considering an additional web administration interface if the system will be used for extensive management operations.

My preferred architecture would be:

| Application | Technology | Purpose |
| --- | --- | --- |
| Backend | ASP.NET Core Web API | Central business logic |
| Database | PostgreSQL | Central data storage |
| Mobile app | React Native | Managers and employees |
| Web dashboard | React + TypeScript | Organization owners and administrators |
| API | RESTful API | Shared communication layer |

Both applications communicate with the same backend and database.

This avoids duplicating business logic and makes the system easier to maintain.

**My final recommendation:** Standardize on ASP.NET Core Web API + PostgreSQL + React Native + React Web Dashboard + Clean Architecture. This is a strong foundation for building ERP, inventory, restaurant, retail, HR, school, and other multi-branch management systems.
