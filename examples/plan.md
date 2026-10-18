# Plan: Password reset by email
Intent: Users who forgot their password can reset it via a one-time email link.
Size: M

## Acceptance criteria
- [x] AC1 Requesting a reset for a known email sends one email with a link; for an unknown email, same response, no email (no account enumeration).
- [x] AC2 Link token is single-use, expires after 30 min, stored hashed.
- [x] AC3 Setting a new password with a valid token updates the hash and invalidates all of that user's sessions.
- [x] AC4 Endpoint is rate-limited: 5 requests / 15 min per IP and per email.

## Phases
### Phase 1: Token model
- Files: `src/auth/resetToken.ts` (new), `migrations/0042_reset_tokens.sql` (new)
- Reuse: `hashSecret()` from `src/auth/crypto.ts`; migration pattern from 0041
- Tests first: `resetToken.test.ts` → create returns raw token once, DB holds hash only; expired/used token rejected
- Steps: 1. migration (id, user_id, token_hash, expires_at, used_at) 2. `createResetToken(userId)` 3. `consumeResetToken(raw)`
- Done when: `npm test -- resetToken` passes; AC2 covered

### Phase 2: Endpoints + email
- Files: `src/routes/auth.ts`, `src/email/templates/reset.html` (new)
- Reuse: `rateLimit()` middleware, `mailer.send()`, `invalidateSessions(userId)`
- Tests first: `auth.reset.int.test.ts` (real DB + fake SMTP sink, no mocks on token path) → AC1, AC3, AC4
- Steps: 1. `POST /auth/reset-request` 2. `POST /auth/reset` 3. email template
- Done when: integration tests pass; AC1, AC3, AC4 covered

## Removals
- None.

## Risks / rollback
- Email deliverability: uses existing mailer. Rollback: revert PR; migration is additive (drop table to undo).

## Amendment Log
| Date | Phase | Change | Why | Approved by |
|---|---|---|---|---|
| 2026-10-12 | 2 | Rate limit also keyed by email, not just IP | Plan gap found in build: IP-only allows distributed abuse of one account | Jai |
