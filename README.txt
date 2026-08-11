QB Conflict Defender - Premium ULM Build v3

FIXED
- Published Supabase questions now load on unsigned-in QB devices.
- The phone no longer depends on a coach/auth session before querying qb_questions.
- Anonymous devices explicitly request Published rows and rely on Supabase RLS.
- Question bank refreshes when the app returns to the foreground.
- MS01 saved as availability=both + status=published will count as a Practice question.

PREMIUM UI
- ULM Football Intelligence branded header.
- ULM logo slot using the athletics site's logo URL with an embedded ULM fallback mark.
- Premium maroon/gold header, cards, shadows and controls.
- Mobile QB cards are now a compact horizontal carousel instead of giant one-card rows.
- Live cloud/question-bank status appears on Take-Home Practice.
- Game screen includes ULM conflict-recognition branding.
- Existing QB photos, 6-second scoring, 1.5-second full-credit protection, Coach Setup and password-recovery behavior are preserved.

DEPLOY
Replace the existing Vercel index.html with this index.html and redeploy.
Then refresh the phone page. MS01 should report as 1 published practice question ready.
