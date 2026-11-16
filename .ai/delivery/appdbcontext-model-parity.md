# AppDbContext model/snapshot parity diagnostic

Status: diagnostic procedure; the reported `PendingModelChangesWarning` is not yet corrected because the exact runtime-model delta has not been obtained.

## Dynamically selected perspectives

- Architect — EF Core model lifecycle and migration architecture: compare the runtime design-time model to the committed snapshot.
- Devil's Advocate — database reliability / SRE: reject warning suppression, destructive schema edits and guessed migrations.
- Clueless Client — local developer/operator: require a single reproducible command that preserves the working database and repository snapshot.
- SME — EF Core 10 / Npgsql migration specialist: inspect generated property, relationship, index, constraint and annotation changes, including provider-specific metadata.
- Maestro — senior .NET platform engineer: choose the smallest evidence-supported correction; this is an analytical perspective, not independent human approval.

## Evidence so far

- Owner's API log reports `PendingModelChangesWarning` for `AppDbContext` during startup migration validation.
- The database migration history reported by the owner contains 12 applied migrations through `20261115160000_PharmacySupplierOnboardingIntake`.
- Source inspection found 25 entity types in both `AppDbContext` and `AppDbContextModelSnapshot`. Matching entity names do not prove matching properties, indexes, relationships, constraints, annotations or provider metadata.
- Existing GitHub Actions run did not yield accessible job logs or a diagnostic artifact through the connected GitHub interface. No exact model delta is claimed.
- The earlier CI probe job failed, and its artifact list was empty. This is a tooling/evidence gap, not proof that the model is correct or incorrect.

## Reproduce locally (no database access)

From the repository root:

```bash
bash scripts/diagnose-appdbcontext-model-parity.sh
```

The script restores/builds the API project, installs EF CLI 10.0.4 if absent, scaffolds a temporary migration from runtime `AppDbContext`, prints the generated migration and snapshot delta, and saves a report under `${TMPDIR:-/tmp}`. It restores the committed snapshot and removes temporary probe source files on exit. It does not start the API, connect to PostgreSQL, apply migrations or edit `__EFMigrationsHistory`.

Review the generated migration carefully. An empty `Up`/ `Down` plus a snapshot delta may indicate annotation/model metadata drift; a populated migration identifies candidate model differences. A scaffold failure is diagnostic output too and must be resolved before interpreting parity.

## Correction decision

1. Obtain the full generated migration and snapshot diff.
2. Classify each change: property/type/nullability/default, relationship/delete behavior, index/unique/filter, constraint, table/schema mapping, provider annotation, or model-level configuration.
3. Trace the change to the owning entity configuration, conventions, provider version or design-time context construction.
4. If the source model is wrong, correct the source and add a regression test. If the source model is intended and the committed snapshot is stale, generate and review a real forward migration; do not hand-edit the snapshot to silence EF.
5. Run:
   ```bash
   dotnet ef migrations has-pending-model-changes --context AppDbContext --project src/Sgsctr.Api --startup-project src/Sgsctr.Api --configuration Release
   dotnet test Sgsctr.slnx --configuration Release
   ```
6. Verify API startup and readiness against the owner's existing database only after reviewing the migration and taking a backup where schema changes are involved.

## Safety and approval

- Never suppress `PendingModelChangesWarning`.
- Never drop database objects, delete volumes, or edit `__EFMigrationsHistory` to force startup.
- Do not apply a generated migration to the owner's database until its `Up`/`Down` operations and data-preservation impact are reviewed.
- Source correction and CI validation do not constitute business, regulatory, security or production approval.
- The owner must run the local diagnostic because this assistant has no access to the owner's Linux VM or Docker runtime.
