ULM QB Conflict Defender v7.2 — PLAYER PIN ACCESS

QB FIRST-LOGIN PINS
Landon Graves #9: 999999
Aidan Armenta #10: 101010
Austin Carlisle #12: 121212
Bryson Kimbrough #14: 141414
Ty Purdy #16: 161616

FLOW
1. QB taps his profile.
2. App asks for his six-digit PIN.
3. First successful login forces him to create a different six-digit PIN.
4. Device remembers a 30-day player session.
5. That device is locked to his profile until he signs out.
6. Practice and Join Game automatically use the verified profile.
7. Supabase derives qb_profile_id from the server-side player session when saving results.
8. A player cannot forge a result under another QB by changing browser code.

STAFF / DEMO
Taylor Dupuis, Brayden Burkhardt and Tommy Denison stay behind the existing Supabase Coach sign-in.
No arbitrary staff PINs were created.

SETUP
Run PLAYER_PIN_SETUP_v7_2.sql once in Supabase SQL Editor, then deploy index.html.

SECURITY
The old anonymous direct-insert policy for qb_conflict_results is removed. QB results are written through the qb_save_player_result security-definer RPC. Signed-in coaches retain direct insert access for staff/demo profiles.
