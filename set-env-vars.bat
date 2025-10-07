@echo off
echo Setting Firebase Functions environment variables...
echo.

REM Note: These commands will run but may not show output due to Firebase CLI issues
REM Check Firebase Console to verify they were set: https://console.firebase.google.com/project/flightcompensation-d059a/functions

firebase functions:config:set openai.api_key="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" --project flightcompensation-d059a

firebase functions:config:set resend.api_key="re_hYv2sbeN_FFbnkBzVgS1hTETUgiAeBA8P" --project flightcompensation-d059a

echo.
echo Environment variables set!
echo.
echo NOTE: You need to redeploy functions for changes to take effect:
echo   firebase deploy --only functions
echo.
echo OR wait for next GitHub Actions deployment
echo.
pause
