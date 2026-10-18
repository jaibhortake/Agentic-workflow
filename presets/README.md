# Presets

Starting points `/setup-project` uses so it doesn't rediscover common facts. It always confirms against the actual repo. Add your own: one file per stack, under ~25 lines.

| Preset | Detect by |
|---|---|
| [node.md](node.md) | package.json |
| [python.md](python.md) | pyproject.toml, requirements*.txt |
| [java.md](java.md) | pom.xml, build.gradle(.kts) |
| [go.md](go.md) | go.mod |
| [dotnet.md](dotnet.md) | *.csproj, *.sln |
