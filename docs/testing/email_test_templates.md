# Email Test Templates for Day 10 Testing

## 📋 Quick Reference

**Test Email Address:** claims@unshaken-strategy.eu  
**Your Email:** p.styla@gmail.com  
**Expected Response Time:** 10-30 seconds  
**Firebase Logs:** https://console.firebase.google.com/project/flightcompensation-d059a/functions/logs

---

## 🎯 TEST 1: SUCCESSFUL CLAIM UPDATE (APPROVED)

### Purpose
Test the complete happy path: email → GPT-4 parsing → Firestore update → push notification

### Prerequisites
- [ ] App running on emulator
- [ ] Signed in as p.styla@gmail.com
- [ ] Have a valid claim ID (e.g., FC-2025-001)

### Email Template

**IMPORTANT: Replace `[YOUR_CLAIM_ID]` with your actual claim ID from the app!**

```
From: p.styla@gmail.com
To: claims@unshaken-strategy.eu
Subject: Flight Compensation Claim [YOUR_CLAIM_ID] - APPROVED

Dear Piotr Styła,

We are pleased to inform you that your flight compensation claim [YOUR_CLAIM_ID] has been APPROVED.

Claim Details:
- Claim Reference: [YOUR_CLAIM_ID]
- Airline: Lufthansa
- Flight: LH1234
- Compensation Amount: €600
- Status: APPROVED
- Processing Date: October 8, 2025

Your compensation will be processed within 5-7 business days and transferred to your account.

Thank you for your patience.

Best regards,
Lufthansa Customer Service
Flight Compensation Department
```

### Expected Results

**1. Firebase Function Logs (within 10 seconds):**
```
📧 Email ingestion started
📬 Processing email from: p.styla@gmail.com
📝 Subject: Flight Compensation Claim [YOUR_CLAIM_ID] - APPROVED
🤖 GPT-4 parsed data: {
  "claim_id": "[YOUR_CLAIM_ID]",
  "status": "approved",
  "airline": "Lufthansa",
  "compensation_amount": "€600",
  ...
}
✅ Updated claim [YOUR_CLAIM_ID]
Update details: { oldStatus: "pending", newStatus: "approved" }
🔔 Push notification sent successfully
```

**2. Push Notification (within 30 seconds):**
- **Title:** `✅ Great news! Your claim has been approved`
- **Body:** `Claim [YOUR_CLAIM_ID]: €600 compensation`

**3. Tap Notification:**
- App opens
- Navigates to claim detail screen
- Shows updated status: "approved"

**4. Firestore Verification:**
```
claims/{docId}/
  claimId: "[YOUR_CLAIM_ID]"
  status: "approved"
  lastUpdated: Timestamp(now)
  airlineResponse: {
    receivedAt: Timestamp(now)
    from: "p.styla@gmail.com"
    subject: "Flight Compensation..."
    parsedData: {...}
  }
```

---

## 🎯 TEST 2: CLAIM REJECTED

### Purpose
Test notification copy for rejected claims

### Email Template

```
From: p.styla@gmail.com
To: claims@unshaken-strategy.eu
Subject: Claim [YOUR_CLAIM_ID] - Unfortunately Rejected

Dear Piotr Styła,

After careful review, we regret to inform you that your claim [YOUR_CLAIM_ID] has been REJECTED.

Claim Reference: [YOUR_CLAIM_ID]
Airline: Ryanair
Status: REJECTED
Reason: Flight delay was less than 3 hours (EU261 threshold not met)

You have the right to appeal this decision within 30 days.

Best regards,
Ryanair Claims Department
```

### Expected Notification
- **Title:** `❌ Your claim was rejected`
- **Body:** `Claim [YOUR_CLAIM_ID] status updated. Tap to view details.`

---

## 🎯 TEST 3: ACTION REQUIRED

### Purpose
Test "needs_info" status handling

### Email Template

```
From: p.styla@gmail.com
To: claims@unshaken-strategy.eu
Subject: Additional Information Needed - Claim [YOUR_CLAIM_ID]

Dear Piotr Styła,

We need additional information to process your claim [YOUR_CLAIM_ID].

Claim Reference: [YOUR_CLAIM_ID]
Status: NEEDS INFORMATION
Required Documents:
- Boarding pass copy
- Bank account details
- Proof of expenses

Please provide these documents within 14 days.

Best regards,
Airline Claims Team
```

### Expected Notification
- **Title:** `ℹ️ Action required: Additional information needed`
- **Body:** `Claim [YOUR_CLAIM_ID] status updated. Tap to view details.`

---

## 🎯 TEST 4: UNDER REVIEW

### Purpose
Test "pending" status handling

### Email Template

```
From: p.styla@gmail.com
To: claims@unshaken-strategy.eu
Subject: Your Claim [YOUR_CLAIM_ID] is Being Reviewed

Dear Piotr Styła,

Thank you for submitting claim [YOUR_CLAIM_ID].

Claim Reference: [YOUR_CLAIM_ID]
Status: PENDING REVIEW
Expected Resolution: 14-21 days

We are currently reviewing your claim and will contact you soon.

Best regards,
Claims Department
```

### Expected Notification
- **Title:** `⏳ Your claim is being reviewed`
- **Body:** `Claim [YOUR_CLAIM_ID] status updated. Tap to view details.`

---

## 🛡️ TEST 5: SPAM EMAIL (Should be REJECTED)

### Purpose
Test spam detection and validation

### Email Template

```
From: p.styla@gmail.com
To: claims@unshaken-strategy.eu
Subject: CONGRATULATIONS! You Won the VIAGRA LOTTERY!!!

Click here to claim your FREE VIAGRA from CASINO PRINCE inheritance!

WIN WIN WIN!!!
```

### Expected Results
- **Firebase Logs:**
```
📧 Email ingestion started
❌ Email validation failed: ['Email appears to be spam']
Returned 400: Invalid email: Email appears to be spam
```

- **Firestore:** No update
- **Notification:** None
- **Response:** HTTP 400 Bad Request

---

## 🛡️ TEST 6: SHORT EMAIL (Should be REJECTED)

### Purpose
Test minimum content length validation

### Email Template

```
From: p.styla@gmail.com
To: claims@unshaken-strategy.eu
Subject: Test

Hi
```

### Expected Results
- **Firebase Logs:**
```
❌ Email validation failed: ['Email content too short']
Returned 400: Invalid email: Email content too short
```

---

## 🛡️ TEST 7: NO CLAIM ID (Logged for Review)

### Purpose
Test unmatched email logging

### Email Template

```
From: p.styla@gmail.com
To: claims@unshaken-strategy.eu
Subject: General Inquiry About Compensation

Hello,

I had a delayed flight last week and I'm wondering about compensation.
The flight was from Warsaw to Berlin.

Can you help me?

Thanks
```

### Expected Results
- **Firebase Logs:**
```
📧 Email ingestion started
📬 Processing email from: p.styla@gmail.com
🤖 GPT-4 parsed data: { "claim_id": null, ... }
⚠️ No claim_id found in email
Email subject: General Inquiry About Compensation
From: p.styla@gmail.com
📝 Logged unmatched email for manual review
```

- **Firestore:** Document added to `unmatched_emails` collection:
```
unmatched_emails/{docId}/
  from: "p.styla@gmail.com"
  subject: "General Inquiry..."
  receivedAt: Timestamp(now)
  parsedData: { claim_id: null, ... }
  reason: "No claim_id found"
```

---

## 🎯 TEST 8: MULTIPLE UPDATES

### Purpose
Test claim update tracking and history

### Sequence
1. Send Test 4 (PENDING)
2. Wait 1 minute
3. Send Test 3 (NEEDS INFO)
4. Wait 1 minute
5. Send Test 1 (APPROVED)

### Expected Results
- Claim status updates each time
- Multiple `airlineResponse` entries logged
- Multiple notifications received
- `lastUpdated` timestamp changes

---

## 📊 TESTING CHECKLIST

Use this checklist while testing:

### Pre-Testing
- [ ] Emulator running
- [ ] App installed and launched
- [ ] Signed in as p.styla@gmail.com
- [ ] Have valid claim ID noted down
- [ ] Firebase Console open in browser
- [ ] Gmail compose window ready

### Test 1: Approved Claim
- [ ] Replaced `[YOUR_CLAIM_ID]` in template
- [ ] Email sent from p.styla@gmail.com
- [ ] Firebase logs show processing (within 10s)
- [ ] GPT-4 parsed correctly
- [ ] Claim updated in Firestore
- [ ] Notification received (within 30s)
- [ ] Notification title: "✅ Great news!"
- [ ] Notification body includes claim ID
- [ ] Tap notification opens app
- [ ] Claim detail shows "approved" status
- [ ] UI shows claim ID badge
- [ ] UI shows email instructions

### Test 5: Spam Detection
- [ ] Spam email sent
- [ ] Firebase logs show validation error
- [ ] Error message: "Email appears to be spam"
- [ ] No Firestore update
- [ ] No notification
- [ ] HTTP 400 response

### Test 7: No Claim ID
- [ ] Email without claim ID sent
- [ ] Firebase logs show warning
- [ ] Document in `unmatched_emails` collection
- [ ] Document has correct structure
- [ ] No notification sent
- [ ] HTTP 200 response

---

## 🔧 TROUBLESHOOTING

### Issue: No notification received

**Check:**
1. FCM token in Firestore (`users/{userId}/fcmToken`)
2. Firebase logs show "Push notification sent successfully"
3. Device notification settings enabled
4. App in foreground/background (test both)

**Solution:**
- Verify `users` collection has your userId
- Check `fcmToken` field is populated
- Try closing and reopening app
- Check Android notification permissions

### Issue: Email not processing

**Check:**
1. Firebase Function logs for errors
2. SendGrid webhook configured correctly
3. Email sent to correct address: claims@unshaken-strategy.eu

**Solution:**
- Wait up to 60 seconds (can be slow)
- Check spam folder
- Verify SendGrid MX records
- Try sending again

### Issue: Wrong claim ID extracted

**Check:**
1. Firebase logs for GPT-4 parsed data
2. Claim ID format in email (should be FC-YYYY-XXX)
3. Claim ID mentioned in subject AND body

**Solution:**
- Make claim ID more prominent in email
- Use exact format: FC-2025-001
- Mention "Claim Reference: FC-2025-001"

### Issue: Spam false positive

**Check:**
1. Firebase logs for validation errors
2. Email content for spam keywords

**Spam keywords:**
- viagra, casino, lottery, prince, inheritance

**Solution:**
- Avoid spam keywords in test emails
- Keep email professional and clear
- Use airline-like formatting

---

## 📱 QUICK COPY-PASTE TEMPLATES

### Template A: Quick Success Test
```
Subject: Claim [YOUR_ID] Approved
Body: Your claim [YOUR_ID] has been approved. Airline: Lufthansa. Amount: €600. Status: APPROVED.
```

### Template B: Quick Rejection Test
```
Subject: Claim [YOUR_ID] Rejected
Body: Your claim [YOUR_ID] has been rejected. Reason: Does not meet EU261 criteria. Status: REJECTED.
```

### Template C: Quick Spam Test
```
Subject: VIAGRA LOTTERY
Body: You won viagra lottery!!!
```

---

## 🎯 SUCCESS CRITERIA

**TEST PASSES IF:**
- ✅ Email validated correctly (spam rejected)
- ✅ GPT-4 extracts claim ID and status
- ✅ Firestore claim updated
- ✅ Push notification received
- ✅ Notification has user-friendly copy
- ✅ Tap opens correct screen
- ✅ UI shows all new features
- ✅ Unmatched emails logged

**COMPLETE SUCCESS:**
- 8/8 tests pass
- No errors in Firebase logs
- All notifications received
- UI displays correctly

---

## 📝 NOTES SECTION

**Your Claim ID:** ___________________

**Test Results:**
- Test 1 (Approved): ⬜ Pass / ⬜ Fail
- Test 5 (Spam): ⬜ Pass / ⬜ Fail
- Test 7 (No ID): ⬜ Pass / ⬜ Fail

**Issues Found:**
1. 
2. 
3. 

**Time Taken:** ___________ minutes

---

**Last Updated:** 2025-10-08  
**Tester:** Piotr Styła  
**Environment:** Android Emulator API 36
