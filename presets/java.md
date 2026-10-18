# Preset: Java / Kotlin (JVM)

- Build tool: `./mvnw` if present else `mvn`; `./gradlew` if present else `gradle`.
- Test: `./mvnw -q test` / `./gradlew test`; single: `-Dtest=ClassName#method` / `--tests 'pkg.ClassName.method'`.
- Lint/format: spotless, checkstyle, ktlint if configured.
- Audit: OWASP dependency-check plugin if configured.
- Ignore: target, build, .gradle, .idea.
- Watch for: Spring profiles (application-*.yml), Flyway/Liquibase migrations, multi-module builds (run tests for touched module only during build phases).
