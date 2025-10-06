# 🎯 Firebase Console Dashboard Setup - Action Guide

**Project:** flightcompensation-d059a  
**Console:** https://console.firebase.google.com/u/0/project/flightcompensation-d059a/analytics  
**Date:** 2025-01-06  
**Status:** Ready to Execute

---

## 🚀 QUICK START (30 MINUTES)

Follow these steps **in order** to set up complete analytics tracking.

---

## STEP 1: ACCESS ANALYTICS DASHBOARD (2 min)

1. Open: https://console.firebase.google.com/u/0/project/flightcompensation-d059a/analytics
2. Click **Dashboard** in left sidebar
3. You should see default charts (active users, events, etc.)

---

## STEP 2: ENABLE GOOGLE ANALYTICS (if not enabled)

1. If you see "Enable Google Analytics":
   - Click **Enable Google Analytics**
   - Select existing GA4 property OR create new
   - Click **Enable**
   - Wait ~30 seconds for activation

2. If already enabled:
   - ✅ Skip to Step 3

---

## STEP 3: CREATE CUSTOM DASHBOARDS (20 min)

### Dashboard 1: USER ENGAGEMENT (8 min)

**3.1. Create Dashboard:**
1. Click **Dashboards** (left sidebar under Analytics)
2. Click **Create Dashboard** (top right)
3. Name: `User Engagement`
4. Click **Create**

**3.2. Add Widget 1 - Daily Active Users:**
1. Click **Add Chart** → **Line chart**
2. Configure:
   - **Metric:** Active users
   - **Dimension:** Date
   - **Date range:** Last 30 days
3. Click **Add Chart**

**3.3. Add Widget 2 - Claims Submitted:**
1. Click **Add Chart** → **Number card**
2. Configure:
   - **Event:** claim_submitted (if available in dropdown)
   - **Metric:** Event count
   - **Date range:** Last 7 days
3. Click **Add Chart**
4. **Note:** If `claim_submitted` doesn't appear yet, that's OK! It will appear after first event is logged.

**3.4. Add Widget 3 - User Retention:**
1. Click **Add Chart** → **Retention**
2. Configure:
   - **Cohort size:** Daily
   - **Return criteria:** Any event
   - **Date range:** Last 30 days
3. Click **Add Chart**

**3.5. Save Dashboard:**
1. Click **Save** (top right)
2. Name confirmation: `User Engagement`
3. Click **Save**

---

### Dashboard 2: PREMIUM CONVERSION (6 min)

**3.6. Create Second Dashboard:**
1. Click **Dashboards** → **Create Dashboard**
2. Name: `Premium Conversion`
3. Click **Create**

**3.7. Add Widget 1 - Premium Funnel:**
1. Click **Add Chart** → **Funnel analysis**
2. Configure:
   - **Step 1:** premium_viewed
   - **Step 2:** premium_purchased
   - **Date range:** Last 30 days
3. Click **Add Chart**
4. **Note:** Steps won't appear until events are logged

**3.8. Add Widget 2 - Premium Revenue:**
1. Click **Add Chart** → **Number card**
2. Configure:
   - **Event:** premium_purchased
   - **Metric:** Event count (we'll track revenue later)
   - **Date range:** Last 30 days
3. Click **Add Chart**

**3.9. Save Dashboard:**
1. Click **Save**

---

### Dashboard 3: FEATURE ADOPTION (6 min)

**3.10. Create Third Dashboard:**
1. Click **Dashboards** → **Create Dashboard**
2. Name: `Feature Adoption`
3. Click **Create**

**3.11. Add Widget 1 - Flight Tracking:**
1. Click **Add Chart** → **Line chart**
2. Configure:
   - **Event:** flight_tracking_setup
   - **Metric:** Event count
   - **Dimension:** Date
   - **Date range:** Last 30 days
3. Click **Add Chart**

**3.12. Add Widget 2 - Email Tracking:**
1. Click **Add Chart** → **Line chart**
2. Configure:
   - **Event:** email_tracking_setup
   - **Metric:** Event count
   - **Dimension:** Date
   - **Date range:** Last 30 days
3. Click **Add Chart**

**3.13. Add Widget 3 - Top Events:**
1. Click **Add Chart** → **Table**
2. Configure:
   - **Event:** All events
   - **Metric:** Event count
   - **Sort by:** Event count (descending)
   - **Rows:** 10
3. Click **Add Chart**

**3.14. Save Dashboard:**
1. Click **Save**

---

## STEP 4: MARK CONVERSION EVENTS (3 min)

1. Go to **Analytics** → **Events** (left sidebar)
2. Wait for page to load (shows all events)
3. Find these events and click **Mark as conversion** for each:
   - ✅ `claim_submitted`
   - ✅ `premium_purchased`
   - ✅ `flight_tracking_setup`
   - ✅ `email_tracking_setup`

**Note:** If events don't appear yet, they'll appear after first user logs them.

---

## STEP 5: CREATE AUDIENCES (5 min)

**5.1. Navigate to Audiences:**
1. Click **Analytics** → **Audiences** (left sidebar)
2. Click **Create Audience** (or **New Audience**)

**5.2. Audience 1 - Active Claimants:**
1. Click **Create a custom audience**
2. Name: `Active Claimants`
3. Description: `Users who submitted claims in last 7 days`
4. Add condition:
   - **Event:** claim_submitted
   - **Within:** Last 7 days
   - **Count:** >= 1
5. Click **Save**

**5.3. Audience 2 - Premium Users:**
1. Click **Create Audience** → **Create a custom audience**
2. Name: `Premium Subscribers`
3. Description: `Users who purchased premium`
4. Add condition:
   - **Event:** premium_purchased
   - **Within:** Last 365 days
   - **Count:** >= 1
5. Click **Save**

**5.4. Audience 3 - Engaged Non-Premium:**
1. Click **Create Audience** → **Create a custom audience**
2. Name: `Engaged Non-Premium`
3. Description: `Active users who haven't purchased premium`
4. Add conditions:
   - **Event:** claim_submitted
   - **Within:** Last 30 days
   - **Count:** >= 2
   - **AND**
   - **Event:** premium_purchased
   - **All time**
   - **Count:** = 0
5. Click **Save**

**5.5. Audience 4 - At-Risk Users:**
1. Click **Create Audience** → **Create a custom audience**
2. Name: `At-Risk Users`
3. Description: `Users who were active but haven't returned`
4. Add conditions:
   - **Event:** claim_submitted
   - **Within:** 30-60 days ago
   - **Count:** >= 1
   - **AND**
   - **Event:** Any event
   - **Within:** Last 14 days
   - **Count:** = 0
5. Click **Save**

---

## STEP 6: SET UP ALERTS (3 min)

**6.1. Navigate to Alerts:**
1. Go to **Analytics** → **Alerts** (in left sidebar, may be under "More")
2. If not visible, go to **Analytics** → **Custom Insights** → **Alerts**

**6.2. Alert 1 - DAU Drop:**
1. Click **Create Alert** (or **New Alert**)
2. Configure:
   - **Name:** DAU Drop Alert
   - **Metric:** Active users
   - **Condition:** Decreases by 20%
   - **Compared to:** Previous 7 days
   - **Frequency:** Daily
   - **Recipients:** Your email
3. Click **Save**

**6.3. Alert 2 - Claim Spike:**
1. Click **Create Alert**
2. Configure:
   - **Name:** Claim Spike Alert
   - **Event:** claim_submitted
   - **Condition:** Increases by 50%
   - **Compared to:** Previous day
   - **Frequency:** Daily
   - **Recipients:** Your email
3. Click **Save**

**6.4. Alert 3 - Premium Purchase:**
1. Click **Create Alert**
2. Configure:
   - **Name:** Premium Purchase Alert
   - **Event:** premium_purchased
   - **Condition:** Count >= 1
   - **Frequency:** Immediately
   - **Recipients:** Your email
3. Click **Save**

---

## STEP 7: ENABLE DEBUG VIEW (2 min)

**For Real-Time Event Testing:**

1. Go to **Analytics** → **DebugView**
2. Keep this tab open
3. In your app (development mode):
   - Run the app
   - Trigger events (submit claim, sign in, etc.)
4. Watch events appear in DebugView in real-time! 🎉

**Enable Debug Mode (if needed):**

**Android:**
```bash
adb shell setprop debug.firebase.analytics.app f35_flight_compensation
```

**iOS:**
```bash
# Add to Xcode scheme: -FIRDebugEnabled
```

**Web:**
Debug mode is automatic in development

---

## ✅ SETUP COMPLETE CHECKLIST

After completing all steps, you should have:

**Dashboards:**
- [x] User Engagement dashboard (3 widgets)
- [x] Premium Conversion dashboard (2 widgets)
- [x] Feature Adoption dashboard (3 widgets)

**Conversion Events:**
- [x] claim_submitted marked
- [x] premium_purchased marked
- [x] flight_tracking_setup marked
- [x] email_tracking_setup marked

**Audiences:**
- [x] Active Claimants
- [x] Premium Subscribers
- [x] Engaged Non-Premium
- [x] At-Risk Users

**Alerts:**
- [x] DAU Drop Alert
- [x] Claim Spike Alert
- [x] Premium Purchase Alert

**Debug View:**
- [x] Enabled and tested

---

## 🎯 WHAT HAPPENS NEXT?

**Immediately:**
- Dashboards are live (may show "No data yet")
- Alerts are active
- Audiences will populate as users meet criteria

**Within 24 hours:**
- First data points appear
- Retention charts populate
- Conversion funnels activate

**Within 7 days:**
- Full weekly trends visible
- Audience sizes stabilize
- You can start making data-driven decisions!

---

## 📊 HOW TO VIEW YOUR DASHBOARDS

**Quick Links:**
1. **Main Dashboard:** https://console.firebase.google.com/u/0/project/flightcompensation-d059a/analytics/app/android:com.example.f35_flight_compensation/dashboard
2. **Events:** https://console.firebase.google.com/u/0/project/flightcompensation-d059a/analytics/app/android:com.example.f35_flight_compensation/events
3. **Audiences:** https://console.firebase.google.com/u/0/project/flightcompensation-d059a/analytics/app/android:com.example.f35_flight_compensation/audiences
4. **DebugView:** https://console.firebase.google.com/u/0/project/flightcompensation-d059a/analytics/app/android:com.example.f35_flight_compensation/debugview

---

## 🐛 TROUBLESHOOTING

**Problem: "No events showing"**
- ✅ Wait 24-48 hours for first data
- ✅ Check DebugView for real-time events
- ✅ Verify app is logging events (check console logs)
- ✅ Ensure Firebase Analytics is enabled in app

**Problem: "Can't create funnel"**
- ✅ Events must have been logged at least once
- ✅ Use DebugView to trigger test events first

**Problem: "Audience is empty"**
- ✅ Audiences populate retroactively after 24-48 hours
- ✅ Check conditions match actual user behavior
- ✅ Verify events are being logged correctly

**Problem: "Alerts not sending"**
- ✅ Check email spam folder
- ✅ Verify email address in Firebase settings
- ✅ Conditions must be met to trigger alert

---

## 📱 TESTING YOUR SETUP

**Test Sequence (10 min):**

1. **Open your app** (development mode)
2. **Sign in** with Google → Check DebugView for `login` event
3. **Submit a test claim** → Check for `claim_submitted` event
4. **Wait 5 minutes** → Check Events page for new events
5. **Go to Dashboards** → See if data appears

**If events appear in DebugView but not in dashboard:**
- ✅ Normal! Dashboard data updates every 24 hours
- ✅ DebugView shows real-time, dashboard shows aggregated

---

## 🚀 NEXT STEPS

**After Setup (Day 4+):**
1. Monitor dashboards daily
2. Check which features get most usage
3. Identify drop-off points in funnels
4. Send targeted notifications to audiences
5. A/B test based on data insights

**Week 2:**
- Export to BigQuery (optional, for advanced SQL)
- Create custom reports
- Set up Firebase Remote Config for A/B tests
- Link to Google Ads for campaign tracking

---

## 📚 RESOURCES

- [Firebase Analytics Dashboard Guide](https://support.google.com/analytics/answer/9143382)
- [Creating Audiences](https://support.google.com/analytics/answer/9267572)
- [Conversion Events](https://support.google.com/analytics/answer/9267735)
- [DebugView](https://firebase.google.com/docs/analytics/debugview)

---

**Setup Time:** ~30-40 minutes  
**Status:** ✅ Ready to execute  
**Last Updated:** 2025-01-06

---

**LET'S DO THIS! 🚀**

Open the Firebase Console and follow this guide step-by-step. You got this! 💪
