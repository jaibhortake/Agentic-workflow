# Preset: Node / TypeScript

- Package manager: lockfile decides — pnpm-lock.yaml → pnpm, yarn.lock → yarn, bun.lockb → bun, else npm.
- Commands: use `package.json` scripts (`test`, `lint`, `build`, `typecheck`, `dev`). Single test: vitest `npx vitest run <file>`, jest `npx jest <file>`, node `node --test <file>`.
- Type-check: `npx tsc --noEmit` if tsconfig.json exists and no script.
- Audit: `npm audit --omit=dev` (or pnpm/yarn equivalent).
- Ignore: node_modules, dist, build, .next, coverage.
- Watch for: ESM vs CJS (`"type"` field), env vars via `.env` (never commit), monorepo workspaces (`workspaces`, pnpm-workspace.yaml, turbo.json, nx.json).
