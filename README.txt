QB Conflict Defender - Supabase Password Recovery Build

ADDED:
- Forgot password button in Coach Setup.
- Supabase recovery email uses the URL of the hosted QB app.
- Recovery link automatically opens Set New Password.
- New password + confirm password.
- Supabase auth.updateUser() saves the replacement password.
- After update, user returns signed in to Coach Setup.

IMPORTANT:
Password recovery must be initiated from the deployed HTTPS/Vercel version, not by opening index.html as a local file.

NEXT DEPLOYMENT STEP:
Deploy this index.html to Vercel, then add that exact Vercel URL to Supabase Authentication -> URL Configuration -> Redirect URLs.
You can then make that URL the Site URL if this QB app becomes the primary auth destination for this Supabase project.
