QB Conflict Defender Premium ULM v4.2 SAFE

This build was rebuilt from the last known-working premium v3 file rather than patching the broken v4.1 file.

FIXED
- All top navigation handlers preserved and JavaScript syntax checked with Node.
- Only ONE practice navigation button: TAKE-HOME PRACTICE.
- Take-Home Practice explicitly refreshes the Supabase question bank when opened.
- Larger mobile football image preserved.
- Mobile image uses nearly full phone width in 16:9.
- Current Game panel is compressed on mobile.
- Existing Supabase question-bank fix, ULM branding, profiles, coach setup, Host Game, Join Game, scoring and recovery are preserved.

VALIDATION
- node --check passed on the inline application JavaScript.
- Coach / Host / Join / QB Profiles / Take-Home Practice IDs and handlers verified.

DEPLOY
Replace the current Vercel index.html with this index.html and redeploy.
