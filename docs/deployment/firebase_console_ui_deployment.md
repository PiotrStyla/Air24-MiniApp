# 🖥️ Firebase Functions - Console UI Deployment Guide

**Use this guide when Firebase CLI doesn't work.**

---

## 📋 Prerequisites

- Firebase project: `flightcompensation-d059a`
- Functions code ready in `functions/` directory
- API keys available (OpenAI + Resend)

---

## 🚀 Option 1: Enable Functions API (If Not Already Enabled)

### **Step 1: Go to Functions Page**
https://console.firebase.google.com/project/flightcompensation-d059a/functions

### **Step 2: Click "Get Started"**
If you see a "Get Started" button, click it to enable Cloud Functions API.

---

## 💻 Option 2: Use Google Cloud Console (Direct Deployment)

Since Firebase Console UI doesn't allow direct code upload, we'll use Google Cloud Console:

### **Step 1: Open Google Cloud Console**
https://console.cloud.google.com/functions/list?project=flightcompensation-d059a

### **Step 2: Enable Cloud Functions API**
If prompted, click "Enable API"

### **Step 3: Create Function Manually**

#### **For `ingestEmail` function:**

1. Click **"CREATE FUNCTION"**
2. **Configuration:**
   - Environment: `2nd gen`
   - Function name: `ingestEmail`
   - Region: `us-central1`
   - Trigger type: `HTTPS`
   - Authentication: `Allow unauthenticated invocations`
   
3. **Click "NEXT"**

4. **Runtime settings:**
   - Runtime: `Node.js 18`
   - Entry point: `ingestEmail`
   - Memory: `256 MB`
   - Timeout: `60s`

5. **Copy code from:**
   - Open: `functions/index.js`
   - Copy the ENTIRE file content
   - Paste into Cloud Console editor

6. **Add package.json:**
   - Click "ADD FILE"
   - Filename: `package.json`
   - Copy content from `functions/package.json`
   - Paste into editor

7. **Set Environment Variables:**
   - Click "Runtime, build, connections and security settings"
   - Scroll to "Environment variables"
   - Add:
     - Name: `OPENAI_API_KEY`
     - Value: `sk-proj-BX8lpJc...` (your OpenAI key)
   - Add:
     - Name: `RESEND_API_KEY`
     - Value: `re_hYv2sbeN...` (your Resend key)

8. **Click "DEPLOY"**
   - Wait 2-3 minutes
   - Function will be created

9. **Get Function URL:**
   - After deployment completes
   - Click on function name
   - Copy the "Trigger URL"
   - Should look like: `https://us-central1-flightcompensation-d059a.cloudfunctions.net/ingestEmail`

#### **For `healthCheck` function:**

Repeat above steps but:
- Function name: `healthCheck`
- Entry point: `healthCheck`
- No environment variables needed (optional)

---

## 🔐 Option 3: Update Functions Code for Environment Variables

Since Cloud Functions uses different env var format, we need to update the code slightly:

**Edit `functions/index.js`:**

Replace:
```javascript
const openai = new OpenAI({
  apiKey: functions.config().openai.api_key,
});

sgMail.setApiKey(functions.config().resend.api_key);
```

With:
```javascript
const openai = new OpenAI({
  apiKey: process.env.OPENAI_API_KEY || functions.config().openai?.api_key,
});

sgMail.setApiKey(process.env.RESEND_API_KEY || functions.config().resend?.api_key);
```

This makes it work with both Cloud Console and Firebase CLI.

---

## ✅ Verification

### **Test Health Check:**
```bash
curl https://us-central1-flightcompensation-d059a.cloudfunctions.net/healthCheck
```

**Expected response:**
```json
{
  "status": "healthy",
  "timestamp": "2025-10-07T...",
  "service": "flight-compensation-functions"
}
```

### **Test Email Ingestion:**
```bash
curl -X POST https://us-central1-flightcompensation-d059a.cloudfunctions.net/ingestEmail \
  -H "Content-Type: application/json" \
  -d '{
    "from": "airline@test.com",
    "to": "claims@air24.app",
    "subject": "Test Claim Update",
    "text": "Your claim LX1097 has been approved for 400 EUR."
  }'
```

**Expected response:**
```
Email processed successfully
```

---

## 🐛 Troubleshooting

### **"Billing must be enabled"**
- Go to: https://console.cloud.google.com/billing
- Link a billing account to the project
- Free tier includes 2 million invocations/month

### **"Permission denied"**
- Ensure you're logged in with correct Google account
- Check IAM permissions (need Editor or Owner role)

### **"Build failed"**
- Check `package.json` is correct
- Verify all dependencies are listed
- Check for syntax errors in `index.js`

### **Function deployed but returns errors**
- Check Logs: https://console.cloud.google.com/logs/query?project=flightcompensation-d059a
- Verify environment variables are set correctly
- Test API keys are valid

---

## 📊 Monitoring

**View Logs:**
https://console.cloud.google.com/logs/query?project=flightcompensation-d059a

**Filter for function logs:**
```
resource.type="cloud_function"
resource.labels.function_name="ingestEmail"
```

**Look for:**
- `📧 Email ingestion started`
- `🤖 GPT-4 parsed data`
- `✅ Updated claim`
- `❌` for errors

---

## 🎯 Success Criteria

- [ ] Functions visible in Console
- [ ] Health check returns 200 OK
- [ ] Test email returns success
- [ ] Logs show processing
- [ ] No errors in logs

---

**Good luck with deployment!** 🚀
