# Firebase Console Quick Navigation Guide

## 🔗 Direct Links (Day 10 Testing)

### Main Console
👉 https://console.firebase.google.com/project/flightcompensation-d059a

---

## 📊 Key Locations

### 1. Functions Logs (MOST IMPORTANT for testing)
👉 https://console.firebase.google.com/project/flightcompensation-d059a/functions/logs

**What to look for:**
- `📧 Email ingestion started`
- `🤖 GPT-4 parsed data`
- `✅ Updated claim FC-2025-XXX`
- `🔔 Push notification sent successfully`

**Filter by:**
- Function: `ingestEmail`
- Time: Last 30 minutes

---

### 2. Firestore Database
👉 https://console.firebase.google.com/project/flightcompensation-d059a/firestore

#### **Collection: users**
**Path:** `users/{userId}`

**What to verify:**
```javascript
{
  fcmToken: "eXaMpLe..."  // ← Should exist after app launch
  lastTokenUpdate: Timestamp
  email: "p.styla@gmail.com"
  displayName: "Piotr Styła"
  updatedAt: Timestamp
}
```

**How to find your userId:**
- Open Firestore
- Click "users" collection
- Look for document with your email
- Document ID is your userId

#### **Collection: claims**
**Path:** `claims/{docId}`

**What to verify:**
```javascript
{
  claimId: "FC-2025-001"  // ← Human-readable ID
  userId: "your-user-id"
  status: "approved"      // ← Should update after email
  flightNumber: "LH1234"
  compensationAmount: 600
  lastUpdated: Timestamp  // ← Should change after email
  airlineResponse: {      // ← Added after email processed
    receivedAt: Timestamp
    from: "p.styla@gmail.com"
    subject: "Claim FC-2025-001 - APPROVED"
    parsedData: {
      claim_id: "FC-2025-001"
      status: "approved"
      airline: "Lufthansa"
      compensation_amount: "€600"
      ...
    }
  }
}
```

**How to find your claim:**
1. Open "claims" collection
2. Look for your claimId (e.g., FC-2025-001)
3. Click document to see details

#### **Collection: unmatched_emails**
**Path:** `unmatched_emails/{docId}`

**What to verify (Test 7):**
```javascript
{
  from: "p.styla@gmail.com"
  subject: "General Inquiry..."
  receivedAt: Timestamp
  parsedData: {
    claim_id: null,
    ...
  }
  reason: "No claim_id found"
}
```

**This collection should:**
- Be empty initially
- Get a document after Test 7 (email without claim ID)

---

### 3. Cloud Functions List
👉 https://console.firebase.google.com/project/flightcompensation-d059a/functions/list

**Deployed functions:**
- ✅ `ingestEmail` - Email processing
- ✅ `healthCheck` - Health monitoring

**Status:** Should show green "Active"

---

### 4. Authentication Users
👉 https://console.firebase.google.com/project/flightcompensation-d059a/authentication/users

**What to verify:**
- Your account listed (p.styla@gmail.com)
- UID matches userId in Firestore users collection
- Last sign-in time updated

---

## 🔍 HOW TO CHECK EACH TEST

### ✅ TEST 1: Approved Claim

**1. Open Functions Logs:**
```
Functions → Logs → Filter: ingestEmail
```

**2. Send email with claim ID**

**3. Watch logs (refresh every 5 seconds):**
- Should see: `📧 Email ingestion started`
- Then: `🤖 GPT-4 parsed data: {"claim_id":"FC-2025-001",...}`
- Then: `✅ Updated claim FC-2025-001`
- Finally: `🔔 Push notification sent successfully`

**4. Check Firestore:**
```
Firestore → claims → [find your claim] → Check:
- status: "approved" (changed)
- lastUpdated: [just now]
- airlineResponse: [new object]
```

**5. Check device:**
- Notification appeared? ✅
- Title: "✅ Great news!" ✅
- Body mentions claim ID? ✅

---

### ✅ TEST 5: Spam Email

**1. Open Functions Logs**

**2. Send spam email**

**3. Watch logs:**
- Should see: `❌ Email validation failed: ['Email appears to be spam']`
- Should NOT see: "Updated claim"
- Should NOT see: "Push notification sent"

**4. Check Firestore:**
- claims collection: No change ✅
- unmatched_emails: No new document ✅

**5. Check device:**
- No notification ✅

---

### ✅ TEST 7: No Claim ID

**1. Open Functions Logs**

**2. Send email without claim ID**

**3. Watch logs:**
- Should see: `📧 Email ingestion started`
- Then: `🤖 GPT-4 parsed data: {"claim_id":null,...}`
- Then: `⚠️ No claim_id found in email`
- Finally: `📝 Logged unmatched email for manual review`

**4. Check Firestore:**
```
Firestore → unmatched_emails → [new document]:
- from: "p.styla@gmail.com"
- reason: "No claim_id found"
- parsedData: {...}
```

**5. Check device:**
- No notification (expected) ✅

---

## 🚀 QUICK TESTING WORKFLOW

### Step-by-Step:

**1. Preparation (1 min):**
- [ ] Open Firebase Console in browser
- [ ] Navigate to Functions Logs
- [ ] Navigate to Firestore in new tab
- [ ] Keep both tabs open

**2. Get Claim ID (2 min):**
- [ ] Open app on emulator
- [ ] Sign in with Google
- [ ] Find/create claim
- [ ] Note claim ID (e.g., FC-2025-001)

**3. Verify FCM Token (1 min):**
- [ ] Go to Firestore tab
- [ ] Click "users" collection
- [ ] Find your document
- [ ] Verify fcmToken field exists

**4. Send Test Email (2 min):**
- [ ] Copy Test 1 template
- [ ] Replace [YOUR_CLAIM_ID] with actual ID
- [ ] Send from p.styla@gmail.com
- [ ] To: claims@unshaken-strategy.eu

**5. Watch Logs (30 sec):**
- [ ] Switch to Functions Logs tab
- [ ] Refresh every 5 seconds
- [ ] Wait for log entries
- [ ] Verify all 4 log messages appear

**6. Check Firestore (30 sec):**
- [ ] Switch to Firestore tab
- [ ] Navigate to claims collection
- [ ] Find your claim
- [ ] Verify status updated
- [ ] Verify airlineResponse added

**7. Check Notification (30 sec):**
- [ ] Look at emulator
- [ ] Notification should appear
- [ ] Read title and body
- [ ] Tap notification
- [ ] Verify app opens correctly

**Total Time:** ~7 minutes for complete test

---

## 📱 MONITORING TIPS

### Logs Refresh
- Auto-refresh: Off (manual control better for testing)
- Refresh button: Top right
- Refresh every 5-10 seconds while testing

### Firestore Real-time
- Firestore updates in real-time
- No need to refresh
- Watch for timestamp changes

### Time Expectations
- Email → Function trigger: 5-15 seconds
- Function → GPT-4 parse: 2-5 seconds
- Parse → Firestore update: 1 second
- Update → Notification: 1-3 seconds
- **Total:** 10-30 seconds

---

## 🐛 COMMON ISSUES

### Issue: "No logs appearing"

**Check:**
1. Correct function selected (ingestEmail)
2. Time range set to "Last hour"
3. No filters blocking logs
4. Refresh the page

**Try:**
- Clear filters
- Expand time range
- Switch to "All functions"

### Issue: "Can't find my user in users collection"

**Check:**
1. Signed in with correct account
2. App initialized FCM token
3. UserService registered in ServiceInitializer

**Try:**
- Restart app
- Sign out and sign in again
- Wait 30 seconds after app launch

### Issue: "Claim not updating in Firestore"

**Check:**
1. Claim ID in email matches Firestore
2. Function logs show "Updated claim"
3. No errors in logs

**Debug:**
- Copy claim ID from Firestore
- Paste exactly in email
- Check for typos (FC-2025-001 not FC-2025-1)

---

## 🎯 SUCCESS INDICATORS

**GREEN FLAGS (Everything Working):**
- ✅ All 4 log messages appear in order
- ✅ FCM token in users collection
- ✅ Claim status updates immediately
- ✅ airlineResponse object appears
- ✅ Notification received within 30 seconds
- ✅ No error messages in logs

**RED FLAGS (Something Wrong):**
- ❌ Function not triggering (no logs)
- ❌ Validation errors (spam, too short)
- ❌ GPT-4 parsing errors
- ❌ Claim not found errors
- ❌ Push notification failed errors
- ❌ No FCM token in Firestore

---

## 📊 TESTING DASHBOARD LAYOUT

**Recommended browser layout:**

```
┌─────────────────────────────────────┐
│  Tab 1: Functions Logs              │
│  (Auto-refresh every 5-10 sec)      │
├─────────────────────────────────────┤
│  Tab 2: Firestore Database          │
│  (Real-time updates)                │
├─────────────────────────────────────┤
│  Tab 3: Gmail Compose               │
│  (Send test emails)                 │
└─────────────────────────────────────┘
```

**On second monitor (if available):**
- Android Emulator
- Email test templates doc

---

## 🔐 SECURITY NOTE

**Your Firebase project:** flightcompensation-d059a  
**Access:** Owner (full permissions)  
**Sensitive data:** FCM tokens, user emails (handle with care)

**Don't share:**
- Firebase service account keys
- FCM tokens
- User IDs
- API keys

---

**Quick Links Summary:**
1. 📊 Logs: https://console.firebase.google.com/project/flightcompensation-d059a/functions/logs
2. 💾 Firestore: https://console.firebase.google.com/project/flightcompensation-d059a/firestore
3. ⚙️ Functions: https://console.firebase.google.com/project/flightcompensation-d059a/functions/list
4. 👤 Auth: https://console.firebase.google.com/project/flightcompensation-d059a/authentication/users
5. 🏠 Home: https://console.firebase.google.com/project/flightcompensation-d059a

**Ready to test!** 🚀
