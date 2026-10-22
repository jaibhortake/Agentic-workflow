# Preset: .NET

- Test: `dotnet test`; single: `dotnet test --filter FullyQualifiedName~Name`.
- Build: `dotnet build -warnaserror` if the repo treats warnings as errors.
- Format: `dotnet format --verify-no-changes`.
- Audit: `dotnet list package --vulnerable`.
- Ignore: bin, obj.
- Watch for: EF Core migrations (`dotnet ef migrations add`), appsettings.*.json per environment, user secrets (never commit).
- Test rungs (see `test-scope`): T2 `dotnet test --filter` on tests for touched projects; T3 full test project(s) of the changed solution folder + `dotnet build`.
