ULM QB Conflict Defender v6.6 — TRUE CLOUD RESULTS

IMPORTANT
Run SUPABASE_SETUP.sql once in Supabase SQL Editor before deploying this index.html.

Changes:
- QB profile stats now read/write qb_conflict_results in Supabase.
- Practice leaderboard no longer writes to localStorage.
- Practice leaderboard is rebuilt from Supabase results.
- Every practice/live snap shows a visible Cloud Saved or Cloud Error status.
- question_id is stored as text so this results table does not depend on the data type used by qb_questions.
- Cross-device Perfect % and Avg Time are calculated from the cloud table.
- Staff/demo profiles remain supported.
- Live Realtime and landscape gameplay remain supported.

TEST
1. Run SUPABASE_SETUP.sql.
2. Deploy index.html.
3. Complete one snap on phone A.
4. Confirm the app says Saved to cloud.
5. Open/refresh phone B or laptop.
6. The same QB's Perfect % / Avg Time should update.
