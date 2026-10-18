# Handoff — Password reset — 2026-10-12
Intent: Users reset a forgotten password via one-time email link.
Plan: docs/plans/active/password-reset.md — at Phase 2 (step 2)
Branch: feat/password-reset  Last commit: a1b2c3d "reset-request endpoint"
Done:
- Phase 1 token model + migration, tests green
- POST /auth/reset-request with rate limit (IP + email)
In progress:
- src/routes/auth.ts:resetPassword — validates token, not yet invalidating sessions
Next steps:
1. Call invalidateSessions(userId) after password update
2. Write AC3 integration test, then reset.html template
3. /review
Decisions made (not yet in plan): none
Gotchas found:
- Test SMTP sink must be started in beforeAll, else emails silently drop
Verify with: npm test -- auth.reset
