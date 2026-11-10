# Before writing code.md — part 2

<!-- Archived from Before writing code.md; original lines 163-327. -->

- \[Required\]
- \[StringLength\]
- \[MaxLength\]
- \[Range\]
- \[EmailAddress\]
- \[Phone\]
- \[DataType\]
- \[Display\]

Use decimal rather than double for financial amounts.

Avoid exposing database entities directly to views or accepting unrestricted entity binding from users. Use ViewModels and explicit mapping where appropriate.

## PHASE 4: Database Integration

Configure Entity Framework Core.

Tasks:

1. Install compatible NuGet packages.
2. Create the DbContext class.
3. Configure DbSet properties.
4. Configure the SQL Server connection.
5. Register the DbContext in Program.cs.
6. Configure entity relationships.
7. Configure database constraints.
8. Create initial migrations.
9. Apply migrations.
10. Verify database tables and relationships.

Use configuration and secret management appropriately.

Never hardcode production database passwords or sensitive credentials in source code.

Do not disable database encryption or certificate validation as a production workaround.

## PHASE 5: Service Layer and Dependency Injection

Implement business operations through services.

For each service:

1. Define an interface.
2. Implement the interface.
3. Inject required dependencies.
4. Move appropriate business logic out of controllers.
5. Implement asynchronous database operations.
6. Handle exceptions appropriately.
7. Register services in the dependency injection container.

Choose the appropriate service lifetime:

- Transient
- Scoped
- Singleton

Use Scoped services for typical request-oriented services that depend on Entity Framework Core DbContext.

Keep controllers focused on HTTP requests, responses, routing, and coordination.

## PHASE 6: Controllers and Application Logic

Create controllers for each major application module.

Implement appropriate actions:

- Index
- Details
- Create
- Edit
- Delete
- Search
- Filter
- Reporting
- Dashboard
- API or JSON endpoints when required

Apply:

- Correct HTTP methods.
- Model validation.
- Authorization.
- Anti-forgery protection.
- Appropriate HTTP status codes.
- Proper exception handling.
- Asynchronous programming.

Use asynchronous Entity Framework Core methods such as:

- ToListAsync()
- FirstOrDefaultAsync()
- FindAsync()
- AnyAsync()
- SaveChangesAsync()

Use pagination for large datasets.

## PHASE 7: Frontend and Razor Views

Create functional and responsive Razor Views.

Each page must:

1. Display the correct information.
2. Use appropriate ViewModels.
3. Provide clear navigation.
4. Include validation messages.
5. Provide user-friendly forms.
6. Display success and error notifications.
7. Support responsive layouts.
8. Follow consistent UI design.

Use Bootstrap components where appropriate.

Do not create decorative interfaces with nonfunctional buttons or forms.

Every user-facing action must have a corresponding working implementation.

## PHASE 8: JavaScript and External Libraries

When additional frontend functionality is required:

1. Identify the appropriate library.
2. Review its official documentation.
3. Select a compatible version.
4. Install or reference the library correctly.
5. Implement the required functionality.
6. Connect it to backend data when necessary.
7. Handle loading and error states.
8. Verify that it works with actual application data.

Examples:

- Chart.js for dashboards and reports.
- DataTables for interactive tables.
- Select2 for enhanced dropdowns.
- Bootstrap components for interactive interfaces.

Use Fetch API or another appropriate HTTP mechanism to retrieve JSON data.

Never rely on hardcoded demonstration data when the feature is supposed to display live application data.

## PHASE 9: Security and Production Readiness

Security must be considered throughout development.

Implement appropriate protections:

- Authentication when required.
- Role-based authorization.
- Claims-based authorization when appropriate.
- Secure password handling through ASP.NET Core Identity.
- CSRF protection.
- Input validation.
- Output encoding.
- Protection against SQL injection through parameterized ORM operations.
- Secure file uploads where applicable.
- Safe configuration management.
- Appropriate logging.
- Exception handling.
- HTTPS.
- Database access restrictions.

Never assume that client-side validation is sufficient.
