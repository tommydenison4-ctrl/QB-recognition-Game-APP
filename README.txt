ULM QB Conflict Defender v7.9 — Staff Practice selection

- Qualifies expires_at in qb_player_login and qb_validate_player_session.
- FIX_PLAYER_AUTH.sql replaces only those functions; it does not reset PINs,
  reseed players, alter policies, or modify saved statistics.
- Login opens with an empty PIN field, a descriptive placeholder, numeric
  keyboard hint, normal text selection, and an explicit Clear PIN action.
- Remembered sessions restore when the app starts. Players who still need
  to change their initial PIN return to the required PIN change screen.
- Staff cards select their playing identity directly in Practice/Join.
- Signed-out staff are sent to coach sign-in; successful sign-in resumes
  the selected staff identity and mode automatically.
- Staff biographies removed at the user's request.
- Coach access bar shows the selected staff identity.
- Existing staff play, host, admin, and server result-write checks remain.

Verification performed 2026-10-16:
- Live SQL: Aidan initial login, session validation, malformed PIN rejection,
  invalid token rejection and expired token rejection; test writes rolled back.
- Credential and result checksums unchanged after the function repair.
- Full local app against live Supabase: wrong PIN rejected, correct PIN
  reaches required new-PIN screen, session restore reopens that requirement.
- Chrome desktop and 390x844 viewport checks; actual iPhone Safari untested.
- No player PIN was changed and no test game results were saved.

Verification performed 2026-10-19:
- Live v7.8 reproduction: Tommy card opened a biography without a play action
  when signed out.
- Local real app: Tommy card routes to coach sign-in with return instructions.
- Isolated full-app UI test (mock authentication/data, no live writes):
  sign-in returns to Practice with Tommy selected and first snap starts.
- Logic checks: staff card modes, signed-out guard, auth resumption, Join mode,
  player exclusion, no staff biographies; scripts and whitespace pass.
- Real coach account login and result saving require the user's session and
  were not verified with live credentials. No database changes were made.
