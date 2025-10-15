@echo off
REM Example: Set secrets for local development (do NOT commit real keys)
REM Usage:
REM   1) Copy this file to set-env-vars.bat (kept ignored)
REM   2) Replace placeholders with your real keys
REM   3) Run this file locally once you are logged into Firebase CLI
REM   4) Deploy functions when ready: firebase deploy --only functions

REM Firebase Functions config (local only)
REM firebase functions:config:set openai.api_key="<YOUR_OPENAI_API_KEY>" --project flightcompensation-d059a
REM firebase functions:config:set resend.api_key="<YOUR_RESEND_API_KEY>" --project flightcompensation-d059a

REM Vercel project variables (set in Vercel UI, not here):
REM   OPENAI_API_KEY, RESEND_API_KEY

@echo This is an example file. Do not put real keys here. >NUL
