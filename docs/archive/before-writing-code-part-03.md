# Before writing code.md — part 3

<!-- Archived from Before writing code.md; original lines 328-492. -->

Verify authorization on the server side.

## PHASE 10: Testing and Quality Assurance

Do not consider the project complete merely because the code has been generated.

Perform systematic testing.

Test:

- Application startup.
- Database connectivity.
- Database migrations.
- CRUD operations.
- Model validation.
- Service layer operations.
- Controller responses.
- Authentication and authorization.
- Form submissions.
- JavaScript functionality.
- External library integration.
- Error handling.
- Responsive UI.
- Data integrity.

Create automated unit and integration tests where appropriate.

Run the build and tests whenever the environment supports them.

Fix discovered errors before declaring the project complete.

## PHASE 11: Final Documentation and Delivery

Provide:

1. Project overview.
2. Technology stack.
3. Architecture explanation.
4. Project folder structure.
5. Database schema.
6. Entity relationships.
7. Installation instructions.
8. Configuration instructions.
9. Migration commands.
10. Application execution instructions.
11. Testing instructions.
12. Deployment instructions.
13. Known limitations, if any.

Provide a clear list of completed features and any remaining work.

---

# 4\. AI AGENT WORKING RULES

Follow these rules throughout development.

RULE 1 — Understand Before Coding

Analyze the requirements and architecture before generating implementation code.

RULE 2 — Build Incrementally

Develop the application module by module. Do not generate a huge amount of disconnected code without validation.

RULE 3 — Maintain Context

Keep track of generated files, classes, interfaces, database entities, dependencies, and implementation decisions.

RULE 4 — Verify Every Implementation

After implementing a feature, verify that it works before moving to dependent features.

RULE 5 — Avoid Fake Implementations

Never claim that a feature is complete when it is only a visual placeholder or sample implementation.

RULE 6 — Use Current Best Practices

Follow current Microsoft documentation and established .NET engineering practices. Identify outdated patterns and replace them with suitable modern alternatives.

RULE 7 — Explain Important Decisions

Explain why a particular technology, design pattern, or implementation approach is being used.

RULE 8 — Handle Errors

When encountering an error:

- Identify the root cause.
- Explain the issue.
- Propose a correction.
- Apply the correction when tool access permits.
- Rebuild and retest.

RULE 9 — Protect Existing Work

Inspect existing files before modifying them. Preserve working functionality and avoid unnecessary destructive changes.

RULE 10 — Report Honestly

Distinguish between implemented, tested, partially implemented, and unverified features.

---

# 5\. REQUIRED AI AGENT EXECUTION PROCESS

Work through the following sequence:

1. Analyze the user's requirements.
2. Inspect the existing development environment and project files.
3. Prepare the architecture.
4. Define the database schema.
5. Establish the project structure.
6. Implement the data layer.
7. Implement the service layer.
8. Implement controllers.
9. Implement Razor Views.
10. Implement frontend functionality.
11. Integrate external libraries.
12. Implement security.
13. Run builds and tests.
14. Resolve errors.
15. Verify complete application workflows.
16. Prepare documentation.
17. Deliver the working application.

At the end of each major phase, provide a concise progress report containing:

- Completed tasks.
- Files created or modified.
- Important implementation decisions.
- Tests performed.
- Errors encountered and their resolution.
- Remaining tasks.

Do not stop after producing the architecture or sample code. Continue implementation until the application is functional or a genuine environment limitation prevents further progress.

# 6\. FINAL SUCCESS CRITERIA

The project is considered successfully delivered only when:

- The application builds successfully.
- The application starts successfully.
- Database connectivity works.
- Required database migrations are applied.
- Core application workflows work.
- CRUD operations work where required.
- Validation works.
- Backend and frontend communicate correctly.
- External libraries function with real data.
- Security requirements are implemented.
- Important workflows are tested.
- Setup and usage documentation is available.

Your ultimate objective is to deliver a real, usable, maintainable ASP.NET Core MVC application—not merely a tutorial, code sample, prototype, or collection of disconnected files.

# START INSTRUCTION

Now analyze the application requirements provided by the user.

First, inspect the available project environment and determine the existing implementation status.

Then prepare the architecture and development plan.
