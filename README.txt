ULM QB Conflict Defender v7.8 — Player access repair

- Qualifies expires_at in qb_player_login and qb_validate_player_session.
- FIX_PLAYER_AUTH.sql replaces only those functions; it does not reset PINs,
  reseed players, alter policies, or modify saved statistics.
- Login opens with an empty PIN field, a descriptive placeholder, numeric
  keyboard hint, normal text selection, and an explicit Clear PIN action.
- Remembered sessions restore when the app starts. Players who still need
  to change their initial PIN return to the required PIN change screen.
- Staff cards open public biography dialogs. Staff profile selection for
  Practice/Live Game remains available only to authenticated coaches.
- Existing staff play, host, admin, and server result-write checks remain.

Verification performed 2026-10-16:
- Live SQL: Aidan initial login, session validation, malformed PIN rejection,
  invalid token rejection and expired token rejection; test writes rolled back.
- Credential and result checksums unchanged after the function repair.
- Full local app against live Supabase: wrong PIN rejected, correct PIN
  reaches required new-PIN screen, session restore reopens that requirement.
- Chrome desktop and 390x844 viewport checks; actual iPhone Safari untested.
- No player PIN was changed and no test game results were saved.
