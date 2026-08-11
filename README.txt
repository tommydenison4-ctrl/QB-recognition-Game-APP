ULM QB Conflict Defender — Landscape v5.1

BASE
- Built directly from index(20260811-004333).html supplied by the user.

IMPORTANT FIX
- Corrected the malformed sign-in JavaScript that prevented the entire app script from parsing.
- Restored handlers for Coach Setup, Host Game, Join Game, QB Profiles, Practice, Take-Home Practice, Start Practice, and other existing controls.
- JavaScript syntax was validated before packaging.

LANDSCAPE GAME MODE
- Start Practice enters a dedicated game-mode.
- Fullscreen and landscape orientation are requested where the browser supports them.
- iPhone Safari fallback: a Rotate to Landscape screen appears until the device is sideways.
- Navigation disappears while a rep is active.
- Film uses the maximum possible 16:9 area.
- The clickable film container stays 16:9 to preserve defender-coordinate accuracy.
- Timer, snap name, ULM mark and Pick 2 Defenders become floating HUD elements.
- Current Game panel is hidden during the 6-second rep.
- Score and final screens remain available between snaps.

NO SUPABASE LOGIC WAS REPLACED.
