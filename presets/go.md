# Preset: Go

- Test: `go test ./...`; single: `go test ./pkg/x -run TestName`.
- Lint: `golangci-lint run` if configured, else `go vet ./...`. Format: `gofmt -l .`.
- Build: `go build ./...`.
- Audit: `govulncheck ./...`.
- Ignore: vendor (unless vendored deliberately), bin.
- Watch for: race conditions — run `go test -race` on concurrency changes; generated code (`//go:generate`, *.pb.go) — don't hand-edit.
- Test rungs (see `test-scope`): T2 `go test` on changed packages and their dependents (`go list -deps`/`go test ./pkg/...`); T3 `go test ./...` for the changed module + `go vet`.
