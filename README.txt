ULM QB Conflict Defender v7.1

NEW TIMING DISPLAY
- 3-second formation study period.
- Large center-screen LOOK countdown: 3 -> 2 -> 1 -> 0.
- Tapping is locked during the LOOK period.
- At 0, the answer window opens immediately.
- First 1.5 seconds of the answer window = full points.
- Next 6.0 seconds decay continuously to zero.
- Total answer window = 7.5 seconds.
- LOOK time is not included in Avg Time.

EDIT PLAYS
- Edit question/play name.
- Edit opponent/team.
- Edit Practice / Live / Both usage.
- Edit Draft / Ready / Published status.
- Edit Stored / Live state.
- Clear and re-tag both conflict defenders.
- Optionally replace the screenshot while editing.
- Edits update the same Supabase row instead of creating a duplicate.

STORED + LIVE CLOUD LIBRARY
- One Supabase question library, two states: STORED and LIVE.
- Practice and Host Game only use LIVE + Published questions.
- Question Bank can filter by opponent and Stored/Live state.
- "Make Selected Opponent LIVE" moves all other opponents to STORED and activates every play for the selected opponent.
- "Store All" creates an empty live bank for offseason/transition periods.
- Any stored opponent can be activated later for a bye-week or offseason session.
- Existing questions remain LIVE when you run the upgrade, so nothing disappears unexpectedly.

SETUP
1. Run UPGRADE_v7_1.sql once in Supabase SQL Editor.
2. Deploy index.html.
3. In Coach Setup, choose the current opponent in the library filter.
4. Click Make Selected Opponent LIVE.
5. Practice/Host Game will now expose only that opponent.

RESET
- RESET_SCORES_NOW.sql is included separately if you still want a one-time full score reset.
- The in-app Reset All Scores button remains available.
