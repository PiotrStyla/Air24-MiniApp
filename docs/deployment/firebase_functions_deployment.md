# 🚀 Firebase Functions Deployment Guide - Day 5

## 📋 Prerequisites

- Firebase CLI installed (`npm install -g firebase-tools`)
- Logged into Firebase (`firebase login`)
- Project connected (`firebase use flightcompensation-d059a`)

---

## 🔐 Step 1: Set Environment Variables

Firebase Functions need API keys for OpenAI and SendGrid/Resend.

### **Set OpenAI API Key:**
```bash
firebase functions:config:set openai.api_key="sk-YOUR_OPENAI_KEY"
```

### **Set Resend/SendGrid API Key:**
```bash
firebase functions:config:set resend.api_key="YOUR_SENDGRID_KEY"
```

### **Verify Configuration:**
```bash
firebase functions:config:get
```

Should output:
```json
{
  "openai": {
    "api_key": "sk-..."
  },
  "resend": {
    "api_key": "..."
  }
}
```

---

## 📦 Step 2: Install Dependencies

Navigate to functions directory:
```bash
cd functions
npm install
```

Expected packages:
- ✅ firebase-admin
- ✅ firebase-functions
- ✅ openai
- ✅ @sendgrid/mail

---

## 🚀 Step 3: Deploy to Production

From project root:
```bash
firebase deploy --only functions
```

**Expected Output:**
```
✔  Deploy complete!

Functions:
  ingestEmail(us-central1): https://us-central1-flightcompensation-d059a.cloudfunctions.net/ingestEmail
  healthCheck(us-central1): https://us-central1-flightcompensation-d059a.cloudfunctions.net/healthCheck
```

**Save these URLs!** You'll need them for SendGrid configuration.

---

## 📧 Step 4: Configure SendGrid Inbound Parse

### **4.1: Log into SendGrid**
- Go to: https://app.sendgrid.com/
- Navigate to: **Settings** → **Inbound Parse**

### **4.2: Add Inbound Parse Webhook**

**Click "Add Host & URL"**

**Settings:**
- **Domain:** `air24.app` (or your custom domain)
- **Subdomain:** `claims` (so emails go to claims@air24.app)
- **Destination URL:** `https://us-central1-flightcompensation-d059a.cloudfunctions.net/ingestEmail`
- **Check spam:** No
- **POST raw email:** Yes

**Click "Add"**

### **4.3: Update DNS Records**

Add MX record to your domain DNS:
```
Type: MX
Host: claims.air24.app
Priority: 10
Value: mx.sendgrid.net
```

**Verification time:** 10-15 minutes for DNS propagation

---

## 🧪 Step 5: Test the Webhook

### **Option A: Test with cURL**

```bash
curl -X POST https://us-central1-flightcompensation-d059a.cloudfunctions.net/ingestEmail \
  -H "Content-Type: application/json" \
  -d '{
    "from": "airline@example.com",
    "to": "claims@air24.app",
    "subject": "Claim LX1097 Approved",
    "text": "Dear Customer, Your claim LX1097 has been approved for compensation of 400 EUR."
  }'
```

**Expected Response:**
```
Email processed successfully
```

### **Option B: Test Health Check**

```bash
curl https://us-central1-flightcompensation-d059a.cloudfunctions.net/healthCheck
```

**Expected Response:**
```json
{
  "status": "healthy",
  "timestamp": "2025-10-06T16:00:00.000Z",
  "service": "flight-compensation-functions"
}
```

### **Option C: Send Real Test Email**

Send an email to: `claims@air24.app`

**Test email content:**
```
Subject: Claim Update - Flight LX1097

Dear Passenger,

Your compensation claim LX1097 has been approved.

Compensation Amount: 400 EUR
Reason: Flight delay over 3 hours
Next Steps: Payment will be processed within 7-10 business days.

Best regards,
Swiss Airlines
```

---

## 📊 Step 6: Monitor Logs

### **Real-time logs:**
```bash
firebase functions:log --only ingestEmail
```

### **Or in Firebase Console:**
1. Go to: https://console.firebase.google.com/project/flightcompensation-d059a
2. Click: **Functions** (left sidebar)
3. Click: **Logs** tab

**Look for:**
- `📧 Email ingestion started`
- `🤖 GPT-4 parsed data`
- `✅ Updated claim`
- `🔔 Push notification sent`

---

## ✅ Verification Checklist

- [ ] Environment variables set (openai, resend)
- [ ] Dependencies installed (npm install)
- [ ] Functions deployed successfully
- [ ] SendGrid inbound parse configured
- [ ] DNS MX record added
- [ ] Test email sent and processed
- [ ] Logs show successful processing
- [ ] Claim status updated in Firestore
- [ ] Push notification received (if user has app)

---

## 🐛 Troubleshooting

### **Problem: "Missing required fields" error**

**Solution:** Check that SendGrid is POSTing the correct format:
```json
{
  "from": "sender@example.com",
  "to": "claims@air24.app",
  "subject": "Subject line",
  "text": "Email body",
  "html": "<html>..."
}
```

### **Problem: "OpenAI API key not found"**

**Solution:** 
```bash
firebase functions:config:get openai.api_key
```
If empty, set it again:
```bash
firebase functions:config:set openai.api_key="sk-..."
firebase deploy --only functions
```

### **Problem: Claims not updating in Firestore**

**Solution:** Check claim ID format in test email matches Firestore document.

### **Problem: Push notifications not sending**

**Solution:** 
1. Verify user has FCM token saved in Firestore
2. Check Firebase Messaging is enabled
3. Review logs for notification errors

---

## 🎯 Success Criteria

When everything works:

1. ✅ Email arrives at `claims@air24.app`
2. ✅ Webhook receives email
3. ✅ GPT-4 parses email content
4. ✅ Claim status updated in Firestore
5. ✅ User receives push notification
6. ✅ App shows updated claim status

---

## 🚀 Next Steps

After successful deployment:

1. Test with real airline emails
2. Monitor GPT-4 parsing accuracy
3. Adjust parsing prompts if needed
4. Add more airlines to watch list
5. Set up error alerts

---

**Good luck with deployment!** 🎉
