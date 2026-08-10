QB Conflict Defender - Supabase Connected (Correct ULM v4 Base)

This build uses the uploaded index-5.html as the base.

CONNECTED NOW:
- Coach sign-in through existing Supabase Auth.
- Film screenshots upload to Storage bucket: qb-conflict-images.
- Question name, opponent, Practice/Live/Both setting, status, two defender coordinates and target radii save to public.qb_questions.
- Question bank reloads from Supabase, so the same bank is available on every device.
- Take-Home Practice only uses Published questions marked Practice or Both.
- Host Game only uses Published questions marked Live or Both.
- 6-second scoring remains unchanged: full credit through 1.5 seconds, then continuous decline to zero at 6.0 seconds.
- Existing ULM player-card design is preserved.

STILL LOCAL IN THIS MILESTONE:
- QB cumulative profile stats/results.
- Completed-game leaderboard.
- Host/Join synchronization is still same-device BroadcastChannel/localStorage.

Those are the next Supabase milestones after confirming that one saved question appears on another device.
