# 🎯 ACTION PLAN - MONTH 1 (30 DAYS)

**Created:** 2025-01-06  
**Status:** 🟢 In Progress

---

## 🎯 GŁÓWNY CEL

**Uruchomić 3 Quick Win features + zbudować fundamenty monetyzacji**

**Success Criteria:**
- ✅ Email tracking LIVE
- ✅ Flight monitoring LIVE  
- ✅ Success predictor LIVE
- ✅ Premium subscription launched
- 🎯 50+ paying subscribers
- 🎯 €150+ MRR

---

## 📅 TYDZIEŃ 1: FUNDAMENT (Dni 1-7)

### Day 1-2: Analytics Setup ⚡
- [ ] Firebase Analytics: `firebase_analytics: ^10.8.0`
- [ ] Events: claim_submitted, premium_viewed, claim_shared
- [ ] Dashboard w Firebase Console (DAU, Claims, Success rate)
- [ ] Mixpanel/Amplitude setup + funnels

### Day 3-4: Email Tracking Backend 📧
- [ ] Firebase Functions + OpenAI GPT-4 integration
- [ ] SendGrid Inbound Parse (claims@air24.app)
- [ ] Email parsing function (status, reason, amount)
- [ ] Firestore updates + push notifications
- [ ] Deploy: `firebase deploy --only functions`

### Day 5-7: Email Tracking UI 📱
- [ ] ClaimStatusScreen (status, timeline, response)
- [ ] ClaimTimeline widget
- [ ] Email setup onboarding flow (unique email per claim)
- [ ] Gmail/Outlook instructions
- [ ] End-to-end testing + deploy

**Week 1 Target:** 30% claims setup email tracking

---

## 📅 TYDZIEŃ 2: FLIGHT MONITORING (Dni 8-14)

### Day 8-9: "My Flights" Feature ✈️
- [ ] Firestore collection: tracked_flights
- [ ] FlightTrackerService (add, watch, update)
- [ ] AddTrackedFlightScreen (form + autocomplete)
- [ ] "My Flights" tab on HomeScreen
- [ ] FlightCard widget

### Day 10-11: Real-time Monitoring 🔄
- [ ] Cloud Function: monitorFlights (every 15 min)
- [ ] AviationStack API integration
- [ ] Delay detection (≥180 min)
- [ ] Push notifications
- [ ] Pre-filled claim drafts

### Day 12-14: UI & Testing 📊
- [ ] FlightDetailsScreen (status, alerts, claim CTA)
- [ ] Push notification handling
- [ ] Alert settings per flight
- [ ] Test with 5 flights + simulate delays
- [ ] Deploy to production

**Week 2 Target:** 20% users add ≥1 flight

---

## 📅 TYDZIEŃ 3: SUCCESS PREDICTOR + PREMIUM (Dni 15-21)

### Day 15-16: ML Model 🤖
- [ ] Export claims: `firebase firestore:export`
- [ ] prepare_data.py (features, target)
- [ ] train_model.py (RandomForest, 100 trees)
- [ ] Deploy to Cloud Functions (Python)
- [ ] Test API endpoint

### Day 17-18: Calculator UI 📈
- [ ] SuccessCalculatorScreen (%, stars, stats)
- [ ] predict_success callable function
- [ ] Community stats widget
- [ ] Share functionality
- [ ] Add to claim submission flow

### Day 19-21: PREMIUM LAUNCH 💎
- [ ] Stripe setup + products (€2.99/mo, €29.99/yr)
- [ ] flutter_stripe package
- [ ] PremiumScreen (features, pricing, CTAs)
- [ ] Upgrade CTAs throughout app
- [ ] Test purchase flow
- [ ] **Deploy + get 10 subscribers!** 🎯

**Week 3 Target:** 50 premium subscribers

---

## 📅 TYDZIEŃ 4: GROWTH & OPTIMIZATION (Dni 22-30)

### Day 22-24: Content Marketing 📝
- [ ] Blog setup (Jekyll/Hugo)
- [ ] 3 SEO articles (Ryanair guide, EU261, Top airlines)
- [ ] Social accounts (Twitter, Instagram, TikTok, LinkedIn)
- [ ] 10 initial posts + engagement strategy

### Day 25-27: Referral Program 🎁
- [ ] Firebase Dynamic Links (air24.app/r/ABC123)
- [ ] Firestore referrals collection
- [ ] ReferralScreen UI + share sheet
- [ ] €10 reward when referee wins
- [ ] Leaderboard

### Day 28-30: Optimization 📊
- [ ] Analytics review (funnels, drop-offs)
- [ ] Bug fixes (top 5 from Crashlytics)
- [ ] A/B test ideas
- [ ] Month 1 review + Month 2 planning

**Week 4 Target:** Viral coefficient > 0.3

---

## 📊 SUCCESS METRICS (30 Days)

| Metric | Baseline | Target | Stretch |
|--------|----------|--------|---------|
| MAU | 10k | 15k | 20k |
| Claims/month | 200 | 500 | 750 |
| Email tracking | 0% | 30% | 50% |
| Flight tracking | 0% | 20% | 35% |
| Premium subs | 0 | 50 | 100 |
| MRR | €0 | €150 | €300 |
| Success rate | 10% | 35% | 50% |
| NPS | 30 | 40+ | 50+ |

---

## 🎯 DAILY ROUTINE

**Morning (30 min):**
- Check Firebase Analytics
- Review crash reports
- Post social media update

**Evening (30 min):**
- Review metrics vs targets
- Plan tomorrow's top 3 tasks
- Update daily log

**Friday (2h):**
- Weekly review
- Plan next week
- Write weekly update

---

## 🚨 RISK MITIGATION

| Risk | Solution |
|------|----------|
| OpenAI API expensive | Use GPT-3.5, cache queries |
| Firebase costs spike | Optimize indexes, set alerts |
| No time to code | Hire Upwork contractor €25/h |
| Premium <10% | A/B test, extend trial |
| Bugs/crashes | Crashlytics, beta testing |

---

## 📝 TRACKING

**Daily Log:** `docs/process/daily_log.md`

**Weekly Reviews:** `docs/process/weekly_reviews.md`

**Key Files:**
- Analytics events: `docs/technical/analytics_events.md`
- API specs: `docs/technical/api_endpoints.md`
- Feature flags: `lib/core/config/feature_flags.dart`

---

## ✅ WEEK-BY-WEEK CHECKLIST

### Week 1: ☐ Foundation
- [ ] Analytics dashboard live
- [ ] Email tracking working
- [ ] 30% adoption rate

### Week 2: ☐ Monitoring
- [ ] Flight tracking launched
- [ ] Real-time alerts working
- [ ] 20% users tracking flights

### Week 3: ☐ Monetization
- [ ] ML predictor live
- [ ] Premium launched
- [ ] 50 paying subscribers

### Week 4: ☐ Growth
- [ ] Blog + social active
- [ ] Referral program live
- [ ] Month 2 roadmap ready

---

**Let's ship! 🚀**

---

*Progress tracking: Update this file daily, check off completed tasks, adjust targets as needed.*
