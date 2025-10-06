# 🔥 Firebase Console Setup Guide

**Created:** 2025-01-06  
**Purpose:** Configure Firebase Analytics dashboard and monitoring  

---

## 📊 FIREBASE ANALYTICS DASHBOARD SETUP

### **Step 1: Access Firebase Console**

1. Go to: https://console.firebase.google.com/
2. Select project: **FlightCompensation** (or your project name)
3. Click **Analytics** in left sidebar
4. Click **Dashboard**

---

### **Step 2: Create Custom Dashboards**

#### **Dashboard 1: User Engagement**

1. Click **Dashboards** → **Create Dashboard**
2. Name: "User Engagement"
3. Add widgets:

**Widget 1: Daily Active Users (DAU)**
- Type: Line chart
- Metric: `Active users`
- Date range: Last 30 days
- Breakdown: None

**Widget 2: Claims Submitted**
- Type: Number card
- Event: `claim_submitted`
- Date range: Last 7 days
- Show: Event count

**Widget 3: Claims by Airline**
- Type: Bar chart
- Event: `claim_submitted`
- Parameter: `airline`
- Date range: Last 30 days
- Top 10

**Widget 4: User Retention**
- Type: Cohort chart
- Metric: User retention
- Cohort size: Day
- Return criteria: Any event

---

#### **Dashboard 2: Premium Conversion**

1. Create new dashboard: "Premium Conversion"
2. Add widgets:

**Widget 1: Premium Funnel**
- Type: Funnel
- Steps:
  1. `premium_viewed`
  2. `premium_purchased`
- Date range: Last 30 days
- Conversion rate displayed

**Widget 2: Premium Revenue**
- Type: Number card
- Event: `premium_purchased`
- Parameter: `price`
- Aggregation: Sum
- Date range: Last 30 days

**Widget 3: Premium by Plan**
- Type: Pie chart
- Event: `premium_purchased`
- Parameter: `plan`
- Date range: Last 30 days

**Widget 4: Premium Sources**
- Type: Bar chart
- Event: `premium_viewed`
- Parameter: `source`
- Date range: Last 30 days

---

#### **Dashboard 3: Feature Adoption**

1. Create dashboard: "Feature Adoption"
2. Add widgets:

**Widget 1: Email Tracking Setup Rate**
- Type: Number card
- Formula: `email_tracking_setup / claim_submitted * 100`
- Date range: Last 7 days
- Display as: Percentage

**Widget 2: Flight Tracking Users**
- Type: Line chart
- Event: `flight_tracking_setup`
- Date range: Last 30 days
- Cumulative: Yes

**Widget 3: Claim Sharing**
- Type: Bar chart
- Event: `claim_shared`
- Parameter: `platform`
- Date range: Last 30 days

**Widget 4: Top Features**
- Type: Table
- Events: All custom events
- Sort by: Event count
- Date range: Last 7 days

---

### **Step 3: Set Up Event Parameters**

1. Go to **Analytics** → **Events**
2. Click **Manage Custom Definitions**
3. Add custom parameters:

| Parameter Name | Event | Description |
|---------------|-------|-------------|
| `airline` | claim_submitted | Airline name |
| `compensation_amount` | claim_submitted | Amount in EUR |
| `flight_number` | claim_submitted | Flight number |
| `source` | premium_viewed | Where user came from |
| `plan` | premium_purchased | monthly/yearly |
| `platform` | claim_shared | Social platform |

4. Click **Create Parameter** for each

---

### **Step 4: Configure Audiences**

Create user segments for targeting:

**Audience 1: Active Claimants**
- Name: "Active Claimants"
- Conditions:
  - Event: `claim_submitted`
  - Within: Last 7 days
  - Count: >= 1

**Audience 2: Premium Users**
- Name: "Premium Subscribers"
- Conditions:
  - Event: `premium_purchased`
  - Within: Last 365 days
  - Count: >= 1

**Audience 3: Engaged Non-Premium**
- Name: "Engaged Non-Premium"
- Conditions:
  - Event: `claim_submitted` >= 2 (last 30 days)
  - Event: `premium_purchased` = 0 (all time)

**Audience 4: At-Risk Users**
- Name: "At-Risk Users"
- Conditions:
  - Event: `claim_submitted` >= 1 (last 60 days)
  - Event: Any event = 0 (last 14 days)

---

### **Step 5: Set Up Conversions**

Mark important events as conversions:

1. Go to **Analytics** → **Events**
2. Find these events and click **Mark as conversion**:
   - ✅ `claim_submitted`
   - ✅ `premium_purchased`
   - ✅ `flight_tracking_setup`
   - ✅ `email_tracking_setup`

---

### **Step 6: Configure Alerts**

Set up email alerts for key metrics:

1. Go to **Analytics** → **Alerts**
2. Create alerts:

**Alert 1: DAU Drop**
- Metric: Active users
- Condition: Decreases by 20%
- Compared to: Previous 7 days
- Email: your@email.com

**Alert 2: Claim Spike**
- Event: `claim_submitted`
- Condition: Increases by 50%
- Compared to: Previous day
- Email: your@email.com

**Alert 3: Premium Purchase**
- Event: `premium_purchased`
- Condition: Count >= 1
- Frequency: Immediately
- Email: your@email.com

---

## 🔍 BIGQUERY INTEGRATION (Optional)

For advanced analytics:

1. Go to **Project Settings** → **Integrations**
2. Click **BigQuery** → **Link**
3. Select dataset location: **EU** (for GDPR)
4. Enable:
   - ✅ Daily export
   - ✅ Streaming export (for real-time)
5. Click **Link**

**SQL Query Examples:**

```sql
-- Top airlines by claim volume
SELECT
  event_params.value.string_value AS airline,
  COUNT(*) as claim_count
FROM `project.analytics_dataset.events_*`
WHERE event_name = 'claim_submitted'
  AND _TABLE_SUFFIX BETWEEN '20250101' AND '20250131'
GROUP BY airline
ORDER BY claim_count DESC
LIMIT 10;

-- Premium conversion rate by source
SELECT
  viewed.source,
  COUNT(DISTINCT viewed.user_pseudo_id) as viewers,
  COUNT(DISTINCT purchased.user_pseudo_id) as purchasers,
  SAFE_DIVIDE(
    COUNT(DISTINCT purchased.user_pseudo_id),
    COUNT(DISTINCT viewed.user_pseudo_id)
  ) * 100 as conversion_rate
FROM (
  SELECT user_pseudo_id,
    (SELECT value.string_value FROM UNNEST(event_params) WHERE key = 'source') as source
  FROM `project.analytics_dataset.events_*`
  WHERE event_name = 'premium_viewed'
) viewed
LEFT JOIN (
  SELECT user_pseudo_id
  FROM `project.analytics_dataset.events_*`
  WHERE event_name = 'premium_purchased'
) purchased
ON viewed.user_pseudo_id = purchased.user_pseudo_id
GROUP BY source
ORDER BY conversion_rate DESC;
```

---

## 📱 DEBUG VIEW SETUP

For testing events during development:

1. Go to **Analytics** → **DebugView**
2. Enable debug mode in app:

**iOS:**
```bash
adb shell setprop debug.firebase.analytics.app f35_flight_compensation
```

**Android:**
```bash
adb shell setprop debug.firebase.analytics.app f35_flight_compensation
```

**Web:**
Already enabled in debug mode automatically

3. Trigger events in app
4. See real-time events in DebugView

---

## 🎯 KEY METRICS TO MONITOR DAILY

### **Growth Metrics:**
- DAU (Daily Active Users)
- MAU (Monthly Active Users)
- New users
- Retention rate (Day 1, Day 7, Day 30)

### **Engagement Metrics:**
- Claims submitted
- Claims per user (avg)
- Session duration
- Screens per session

### **Monetization Metrics:**
- Premium conversions
- Revenue (MRR)
- ARPU (Average Revenue Per User)
- LTV (Lifetime Value)

### **Feature Metrics:**
- Email tracking adoption
- Flight tracking adoption
- Sharing rate
- Success rate (claims won)

---

## 🔔 NOTIFICATION SETUP

Connect Firebase Analytics to FCM for personalized notifications:

1. Go to **Cloud Messaging**
2. Create notification campaigns based on:
   - Audience: "Active Claimants"
   - Trigger: User completes `claim_submitted`
   - Message: "Track your claim status in real-time!"

3. A/B test notifications:
   - Variant A: "Your claim is processing 🚀"
   - Variant B: "Check claim status now"
   - Measure: Click-through rate

---

## ✅ SETUP CHECKLIST

**Day 2 Tasks:**
- [ ] Access Firebase Console
- [ ] Create "User Engagement" dashboard
- [ ] Create "Premium Conversion" dashboard
- [ ] Create "Feature Adoption" dashboard
- [ ] Add custom event parameters
- [ ] Configure 4 audiences
- [ ] Mark conversions (4 events)
- [ ] Set up 3 alerts
- [ ] Enable DebugView
- [ ] Test events from app

**Optional (Week 2):**
- [ ] Link BigQuery
- [ ] Create SQL queries
- [ ] Set up FCM campaigns
- [ ] Configure A/B tests

---

## 📚 RESOURCES

- [Firebase Analytics Docs](https://firebase.google.com/docs/analytics)
- [BigQuery Export Schema](https://support.google.com/analytics/answer/7029846)
- [Analytics Dashboard Guide](https://support.google.com/analytics/answer/9143382)
- [Event Parameters Reference](https://support.google.com/analytics/answer/9267735)

---

**Last Updated:** 2025-01-06  
**Status:** ✅ Ready for implementation
