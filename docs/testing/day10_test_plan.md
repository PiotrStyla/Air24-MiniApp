# Day 10 Testing Plan

## Date: 2025-10-08

## Objective
Test and validate the complete email-to-notification system built on Day 9.

---

## Pre-Testing Checklist

- [ ] GitHub Actions deployment completed successfully
- [ ] Firebase Functions deployed (check GitHub Actions logs)
- [ ] App running on physical device or emulator
- [ ] Firebase Console accessible
- [ ] Test email account ready (p.styla@gmail.com)

---

## Test 1: Claim Creation & ID Generation

**Expected:** New claims get human-readable IDs (FC-2025-001)

### Steps:
1. Open app on device
2. Navigate to claim submission
3. Fill out claim form
4. Submit claim
5. Note the generated claim ID

### Verification:
- [ ] Claim ID displayed in format FC-YYYY-XXX
- [ ] Claim ID visible in claim detail screen
- [ ] Claim ID badge appears at top
- [ ] Firestore: Check `claims` collection for `claimId` field

### Results:
- **Claim ID Generated:** `____________________`
- **Status:** ⬜ Pass / ⬜ Fail
- **Notes:**

---

## Test 2: FCM Token Storage

**Expected:** FCM token automatically saved to Firestore

### Steps:
1. App should be open (token saved on init)
2. Go to Firebase Console
3. Navigate to Firestore Database
4. Check `users` collection
5. Find your user document

### Verification:
- [ ] `users/{userId}` document exists
- [ ] `fcmToken` field is populated
- [ ] `lastTokenUpdate` timestamp is recent
- [ ] `email` and `displayName` fields present

### Results:
- **User ID:** `____________________`
- **Token Found:** ⬜ Yes / ⬜ No
- **Status:** ⬜ Pass / ⬜ Fail
- **Notes:**

---

## Test 3: Email Ingestion & Parsing

**Expected:** Email forwarded to claims@ is parsed by GPT-4

### Test Email Content:
```
From: p.styla@gmail.com
To: claims@unshaken-strategy.eu
Subject: Test - Claim FC-2025-001 Update

Claim FC-2025-001 has been APPROVED!

Airline: Lufthansa
Amount: €600
Reason: Flight delay compensation

Payment will be processed in 5-7 business days.

Best regards,
Lufthansa Customer Service
```

### Steps:
1. Send email from p.styla@gmail.com to claims@unshaken-strategy.eu
2. Include your actual claim ID from Test 1
3. Wait 10-15 seconds
4. Check Firebase Functions logs

### Verification:
- [ ] Email received by SendGrid
- [ ] Cloud Function triggered
- [ ] Email validated (not spam)
- [ ] GPT-4 parsed successfully
- [ ] JSON extracted correctly
- [ ] Claim found in Firestore
- [ ] Claim status updated

### Log Checkpoints:
- [ ] `📧 Email ingestion started`
- [ ] `📦 Parsing multipart/form-data`
- [ ] `📬 Processing email from: p.styla@gmail.com`
- [ ] `🤖 GPT-4 parsed data: {...}`
- [ ] `✅ Updated claim FC-2025-XXX`
- [ ] `🔔 Push notification sent successfully`

### Results:
- **Email Sent Time:** `____________________`
- **Function Triggered:** ⬜ Yes / ⬜ No
- **Parsing Success:** ⬜ Yes / ⬜ No
- **Claim Updated:** ⬜ Yes / ⬜ No
- **Status:** ⬜ Pass / ⬜ Fail
- **Notes:**

---

## Test 4: Push Notification

**Expected:** User receives notification with user-friendly message

### Steps:
1. After sending email (Test 3)
2. Keep device unlocked
3. Wait for notification (should appear within 30 seconds)
4. Read notification message
5. Tap notification

### Verification:
- [ ] Notification appeared on device
- [ ] Title is user-friendly (e.g., "✅ Great news!")
- [ ] Body mentions claim ID
- [ ] Body mentions compensation amount (if present)
- [ ] Tapping opens app
- [ ] App navigates to claim detail screen
- [ ] Claim status is updated in UI

### Expected Notification:
- **Title:** "✅ Great news! Your claim has been approved"
- **Body:** "Claim FC-2025-001: €600 compensation"

### Results:
- **Notification Received:** ⬜ Yes / ⬜ No
- **Title:** `____________________`
- **Body:** `____________________`
- **Navigation Worked:** ⬜ Yes / ⬜ No
- **Status:** ⬜ Pass / ⬜ Fail
- **Notes:**

---

## Test 5: UI Display

**Expected:** Claim detail screen shows all new features

### Verification:
- [ ] Claim ID badge at top (blue background)
- [ ] Claim reference in flight details section
- [ ] "Status Information" card present
- [ ] Email forwarding instructions visible
- [ ] Email address: claims@unshaken-strategy.eu
- [ ] Copy button next to email address
- [ ] Instruction text about including claim ID
- [ ] Copy button works (shows snackbar)

### Results:
- **All UI Elements Present:** ⬜ Yes / ⬜ No
- **Copy Button Works:** ⬜ Yes / ⬜ No
- **Status:** ⬜ Pass / ⬜ Fail
- **Notes:**

---

## Test 6: Error Handling - Spam Email

**Expected:** Spam email rejected with 400 error

### Test Email:
```
From: test@example.com
To: claims@unshaken-strategy.eu
Subject: VIAGRA LOTTERY WINNER!!!

You won the lottery! Click here for viagra!
```

### Steps:
1. Send spam email
2. Check Cloud Function logs
3. Look for validation error

### Verification:
- [ ] Function triggered
- [ ] Validation failed
- [ ] Error message: "Email appears to be spam"
- [ ] Returned 400 status code
- [ ] Email NOT processed

### Results:
- **Spam Detected:** ⬜ Yes / ⬜ No
- **Status:** ⬜ Pass / ⬜ Fail
- **Notes:**

---

## Test 7: Error Handling - Missing Claim ID

**Expected:** Email without claim ID logged to unmatched_emails

### Test Email:
```
From: p.styla@gmail.com
To: claims@unshaken-strategy.eu
Subject: Random airline email

This is an email from an airline but it doesn't mention
any claim ID. Just some general information.
```

### Steps:
1. Send email without claim ID
2. Check Cloud Function logs
3. Check Firestore `unmatched_emails` collection

### Verification:
- [ ] Function processed email
- [ ] GPT-4 parsed (no claim_id found)
- [ ] Warning logged: "No claim_id found in email"
- [ ] Document added to `unmatched_emails` collection
- [ ] Document contains: from, subject, parsedData, reason

### Results:
- **Email Logged:** ⬜ Yes / ⬜ No
- **Status:** ⬜ Pass / ⬜ Fail
- **Notes:**

---

## Test 8: Retry Logic (Manual)

**Expected:** Function retries on GPT-4 failure

**Note:** This is hard to test without simulating failures.
Check logs for retry messages if they occur naturally.

### Log Messages to Look For:
- `⏳ Retry attempt 1/3 after 1000ms`
- `⏳ Retry attempt 2/3 after 2000ms`
- `⏳ Retry attempt 3/3 after 4000ms`

### Results:
- **Retry Observed:** ⬜ Yes / ⬜ No / ⬜ N/A
- **Status:** ⬜ Pass / ⬜ Fail / ⬜ Skip
- **Notes:**

---

## Summary

### Test Results

| Test | Status | Notes |
|------|--------|-------|
| 1. Claim ID Generation | ⬜ | |
| 2. FCM Token Storage | ⬜ | |
| 3. Email Ingestion | ⬜ | |
| 4. Push Notification | ⬜ | |
| 5. UI Display | ⬜ | |
| 6. Spam Rejection | ⬜ | |
| 7. Unmatched Email Logging | ⬜ | |
| 8. Retry Logic | ⬜ | |

### Overall Status: ⬜ Pass / ⬜ Fail

### Pass Rate: ___ / 8 tests

---

## Issues Found

### Critical Issues
1. 
2. 
3. 

### Minor Issues
1. 
2. 
3. 

### Nice to Have
1. 
2. 
3. 

---

## Next Steps

### Immediate Fixes Needed:
- [ ] 
- [ ] 
- [ ] 

### Polish/Improvements:
- [ ] 
- [ ] 
- [ ] 

### Future Enhancements:
- [ ] 
- [ ] 
- [ ] 

---

## Firebase Console Links

**Functions:**
- https://console.firebase.google.com/project/flightcompensation-d059a/functions

**Firestore:**
- https://console.firebase.google.com/project/flightcompensation-d059a/firestore

**Logs:**
- https://console.firebase.google.com/project/flightcompensation-d059a/functions/logs

**GitHub Actions:**
- https://github.com/PiotrStyla/FlightCompensation/actions

---

## Completion

**Tester:** `____________________`
**Date:** 2025-10-08
**Time Started:** `____________________`
**Time Completed:** `____________________`
**Total Duration:** `____________________`

**Sign-off:** ⬜ All tests passed, system ready for production
