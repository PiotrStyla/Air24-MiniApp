# Analytics Events Documentation

**Created:** 2025-01-06  
**Service:** `AnalyticsService` (Firebase Analytics)

---

## 📊 Tracked Events

### **1. claim_submitted**
Tracks when user submits a compensation claim.

**Parameters:**
- `airline` (string): Airline code (e.g., "Ryanair", "Lufthansa")
- `compensation_amount` (int): Expected compensation in EUR
- `flight_number` (string, optional): Flight number
- `delay_minutes` (int, optional): Delay duration
- `timestamp` (string): ISO 8601 timestamp

**Usage:**
```dart
await ServiceInitializer.get<AnalyticsService>().logClaimSubmitted(
  airline: 'Ryanair',
  compensationAmount: 400,
  flightNumber: 'FR1234',
  delayMinutes: 240,
);
```

---

### **2. claim_status_checked**
Tracks when user checks status of their claim.

**Parameters:**
- `claim_id` (string): Unique claim identifier
- `status` (string): Current status (e.g., "pending", "accepted", "rejected")
- `timestamp` (string): ISO 8601 timestamp

**Usage:**
```dart
await ServiceInitializer.get<AnalyticsService>().logClaimStatusChecked(
  claimId: 'ABC123',
  status: 'pending',
);
```

---

### **3. premium_viewed**
Tracks when user views premium/paywall screen.

**Parameters:**
- `source` (string, optional): Where user came from (e.g., "flight_limit", "settings", "calculator")
- `timestamp` (string): ISO 8601 timestamp

**Usage:**
```dart
await ServiceInitializer.get<AnalyticsService>().logPremiumViewed(
  source: 'flight_limit',
);
```

---

### **4. premium_purchased**
Tracks successful premium subscription purchase.

**Parameters:**
- `plan` (string): "monthly" or "yearly"
- `price` (double): Price paid
- `currency` (string, optional): Currency code (default: "EUR")
- `timestamp` (string): ISO 8601 timestamp

**Usage:**
```dart
await ServiceInitializer.get<AnalyticsService>().logPremiumPurchased(
  plan: 'monthly',
  price: 2.99,
  currency: 'EUR',
);
```

---

### **5. claim_shared**
Tracks when user shares claim or success story.

**Parameters:**
- `platform` (string): Social platform (e.g., "twitter", "facebook", "whatsapp")
- `claim_id` (string, optional): Claim being shared
- `timestamp` (string): ISO 8601 timestamp

**Usage:**
```dart
await ServiceInitializer.get<AnalyticsService>().logClaimShared(
  platform: 'twitter',
  claimId: 'ABC123',
);
```

---

### **6. flight_tracking_setup**
Tracks when user adds flight to tracking list.

**Parameters:**
- `flight_number` (string): Flight number
- `airline` (string): Airline name
- `timestamp` (string): ISO 8601 timestamp

**Usage:**
```dart
await ServiceInitializer.get<AnalyticsService>().logFlightTrackingSetup(
  flightNumber: 'FR1234',
  airline: 'Ryanair',
);
```

---

### **7. email_tracking_setup**
Tracks when user sets up email forwarding for claim tracking.

**Parameters:**
- `claim_id` (string): Claim ID for tracking
- `timestamp` (string): ISO 8601 timestamp

**Usage:**
```dart
await ServiceInitializer.get<AnalyticsService>().logEmailTrackingSetup(
  claimId: 'ABC123',
);
```

---

## 🎯 Standard Firebase Events

### **login**
Tracks user sign-in (uses Firebase standard event).

**Parameters:**
- `login_method` (string): "google", "email", etc.

**Usage:**
```dart
await ServiceInitializer.get<AnalyticsService>().logSignIn(
  method: 'google',
);
```

---

### **sign_up**
Tracks new user registration.

**Parameters:**
- `sign_up_method` (string): Registration method

**Usage:**
```dart
await ServiceInitializer.get<AnalyticsService>().logSignUp(
  method: 'google',
);
```

---

### **screen_view**
Tracks screen navigation (also automatic via FirebaseAnalyticsObserver).

**Parameters:**
- `screen_name` (string): Screen identifier
- `screen_class` (string, optional): Screen widget class

**Usage:**
```dart
await ServiceInitializer.get<AnalyticsService>().logScreenView(
  screenName: 'claim_status',
  screenClass: 'ClaimStatusScreen',
);
```

---

## 👤 User Properties

Set custom user properties for segmentation.

**Available Properties:**
- `premium_user` (bool): Is user premium subscriber?
- `total_claims` (int): Total claims submitted

**Usage:**
```dart
await ServiceInitializer.get<AnalyticsService>().setUserProperties(
  userId: user.uid,
  isPremium: true,
  totalClaims: 3,
);
```

---

## 🔧 Custom Events

For future flexibility, log custom events.

**Usage:**
```dart
await ServiceInitializer.get<AnalyticsService>().logCustomEvent(
  eventName: 'referral_shared',
  parameters: {
    'referral_code': 'ABC123',
    'platform': 'whatsapp',
  },
);
```

---

## 📈 Funnels to Track

### **Onboarding Funnel:**
1. `sign_up` (method: google)
2. `screen_view` (home_screen)
3. `claim_submitted` (first claim)
4. `claim_status_checked`

### **Premium Conversion Funnel:**
1. `premium_viewed` (source: X)
2. `premium_purchased` (plan: monthly/yearly)

### **Feature Adoption:**
- **Email Tracking:** `email_tracking_setup` / `claim_submitted` ratio
- **Flight Monitoring:** `flight_tracking_setup` / `active_users` ratio

---

## 🎯 Key Metrics to Monitor

### **Firebase Analytics Dashboard:**
1. **Daily Active Users (DAU)**
2. **Monthly Active Users (MAU)**
3. **Claims per user** (avg)
4. **Premium conversion rate** (`premium_purchased` / `premium_viewed`)
5. **Feature adoption rates**

### **Custom Dashboards:**
- Claims submitted by airline
- Success rate by claim type
- Revenue by subscription plan
- Viral coefficient (shares per user)

---

## 🛠️ Implementation Checklist

**Week 1:**
- [x] Firebase Analytics package added
- [x] AnalyticsService created
- [x] Service registered in DI
- [ ] Events added to claim submission
- [ ] Events added to premium flow
- [ ] Firebase Console dashboard created

**Future:**
- [ ] Mixpanel integration (advanced funnels)
- [ ] A/B testing setup
- [ ] Custom event parameters
- [ ] Revenue tracking (purchases)

---

## 📝 Notes

- All events are logged asynchronously (non-blocking)
- Events include automatic timestamp
- Debug logging with emoji markers (📊) for easy tracking
- Errors are caught and logged, won't crash app
- GDPR compliant (no PII in event names)

---

**Last Updated:** 2025-01-06
