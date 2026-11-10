# Before writing code.md — part 4

<!-- Archived from Before writing code.md; original lines 493-590. -->

After approval where business-critical decisions require it, begin implementation and continue through testing and delivery.

Act as a responsible autonomous senior software development agent throughout the entire process.

## 2. How this transforms the original tutorial into an AI development methodology

The original tutorial uses a Personal Finance / Expense Tracking application to demonstrate ASP.NET Core MVC.

The important thing is that the AI agent should learn the development methodology, not just reproduce the expense application.

Original tutorial development sequence

1. Project creation
   ASP.NET Core MVC project.
2. Data modeling
   Expense model, properties and validation.
3. Database integration
   EF Core, DbContext, SQL Server and migrations.
4. MVC implementation
   Controllers, actions and Razor Views.
5. CRUD operations
   Create and display expenses.
6. Production-oriented architecture
   Async methods, service interfaces and dependency injection.
7. External integration
   Chart.js, JavaScript Fetch API and JSON.
8. Final functionality
   Dynamic financial reports and expense visualization.

Enhanced AI agent methodology

1. Requirements analysis and business understanding.
2. Architecture and database design.
3. Secure implementation and maintainable code.
4. Frontend/backend integration.
5. Automated testing and debugging.
6. Deployment and documentation.

## 3. Important improvements over the original tutorial

The original tutorial is a useful learning reference, but an AI agent should improve several implementation decisions:

| Original approach | Recommended AI agent approach |
| --- | --- |
| `double` for expenses | `decimal` for monetary values |
| Direct entity binding | Dedicated ViewModels and explicit mapping |
| Database access through controller | Service layer and appropriate abstractions |
| Basic validation | Server-side and client-side validation |
| Basic CRUD | Complete CRUD with authorization |
| Basic connection string | Secure configuration and secrets |
| Simple error handling | Structured logging and exception handling |
| Static chart examples | Dynamic database-driven charts |
| Manual verification | Automated unit and integration tests |
| Tutorial-focused design | Maintainable, production-oriented architecture |

## 4. Recommended development standards and learning references

These are important official resources that the AI agent should use as technical references.

- ASP.NET Core — [Official Microsoft documentation](<https://learn.microsoft.com/en-us/aspnet/core/?utm_source=chatgpt.com>).
- Entity Framework Core — [EF Core documentation](<https://learn.microsoft.com/en-us/ef/core/?utm_source=chatgpt.com>).
- C# — [C# documentation](<https://learn.microsoft.com/en-us/dotnet/csharp/?utm_source=chatgpt.com>).
- Chart.js — [Official Chart.js documentation](<https://www.chartjs.org/docs/latest/?utm_source=chatgpt.com>).
- OWASP — [Web application security risks](<https://owasp.org/www-project-top-ten/?utm_source=chatgpt.com>).

## 5. One important recommendation: Make the AI agent autonomous

If you are using an AI coding agent such as GitHub Copilot Agent, Cursor, Claude Code, or another agent with access to your project files and terminal, add this instruction:

Writing

AUTONOMOUS DEVELOPMENT MODE:

You are authorized to inspect the project, create and modify source files, install appropriate dependencies, execute terminal commands, generate database migrations, build the application, run tests, inspect errors, and correct implementation issues.

Do not simply tell me what code to write. Perform the actual development work using your available tools.

Before modifying existing files, inspect their contents and understand their dependencies.

After each major implementation step:

1. Save the changes.
2. Build the application.
3. Check for compilation errors.
4. Test the implemented functionality.
5. Correct any issues found.
6. Report the actual result.

Never report a successful build, database migration, test, or deployment unless it was actually executed and verified.

If an operation requires credentials, external permissions, unavailable infrastructure, or human approval, explain the limitation and request the necessary input.

Continue working toward a complete, functional application rather than stopping after generating code snippets.

My recommendation: Use the first master prompt as your permanent development instruction and the second as the execution-mode instruction for your coding agent. Then provide the actual application requirements as a separate project-specific request.

This gives you a reusable AI development framework that can build not only a Personal Finance application, but also ERP, HR, CRM, Inventory Management, School Management, Hospital Management, and other ASP.NET Core MVC business applications.
