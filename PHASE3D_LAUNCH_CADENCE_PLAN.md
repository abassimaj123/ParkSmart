# Phase 3D — Launch Cadence & Release Strategy

**Date:** 2026-05-11  
**Scope:** Prioritization, scheduling, and staggered Play Store launches for 22-app portfolio  
**Status:** ✅ **COMPLETE** — Ready for execution

---

## Executive Summary

**16 apps are production-ready (73%)** and will launch in **4 staggered waves over 3 weeks**, maximizing quality review time and enabling parallel development on remaining 6 apps.

| Wave | Apps | Count | Launch Window | Target Go-Live |
|------|------|-------|----------------|-----------------|
| **Wave 1** | Tier-A Reference | 3 | May 20–22 (approx.) | May 23–25 |
| **Wave 2** | Tier-B High-Confidence | 5 | May 27–29 | June 2–4 |
| **Wave 3** | Tier-C Monetization-Verified | 5 | June 3–5 | June 9–11 |
| **Wave 4** | Tier-D Final Verified | 5 | June 10–12 | June 16–18 |
| **Reserve** | INCOMPLETE + Kotlin TBD | 6 | Post-July | TBD |

---

## Wave 1: Tier-A Reference Apps (Week 1)

**Apps:** MortgageUS, AutoLoan, StudentLoan  
**Reason:** Highest quality, reference model, broadest appeal  
**Timeline:**

| Date | Activity | Owner |
|------|----------|-------|
| **May 17–18** | Final code review + QA | Engineer |
| **May 19** | Build AAB + upload to Play Console | CI/CD |
| **May 20** | Monitoring + initial review feedback | PM |
| **May 21–22** | Review period (24–48h) | Google |
| **May 23–25** | Go live (if approved) | ops |
| **May 26+** | Monitor ratings, respond to reviews | Support |

**Pre-Launch Checklist:**

- [ ] MortgageUS
  - [ ] version bumped (pubspec.yaml)
  - [ ] Prod AdMob IDs configured
  - [ ] AAB builds successfully
  - [ ] Screenshots finalized (8 per app)
  - [ ] Store listing copy reviewed
  - [ ] Data safety form completed
  - [ ] Privacy policy URL ready

- [ ] AutoLoan
  - [ ] version bumped (pubspec.yaml)
  - [ ] Prod AdMob IDs configured
  - [ ] AAB builds successfully
  - [ ] UI/UX verified (from Phase 2)
  - [ ] All assets prepared

- [ ] StudentLoan
  - [ ] version bumped (pubspec.yaml)
  - [ ] Prod AdMob IDs configured
  - [ ] AAB builds successfully
  - [ ] Full feature set verified
  - [ ] Marketing copy approved

**Success Criteria:**
- ✅ All 3 apps approved within 48h
- ✅ Combined install base: 50k+ in first week (target)
- ✅ Average rating: ≥4.2 stars
- ✅ Crash rate: <0.2%

**Contingency:**
- If rejected: Fix issues + resubmit within 24h
- If delayed: Continue monitoring + proceed to Wave 2 on schedule

---

## Wave 2: Tier-B High-Confidence (Week 1-2)

**Apps:** MortgageCA, HELOCApp, CreditCardAPR, LoanPayoffUS, MortgageUK  
**Reason:** Complete feature parity, verified paywalls, i18n support  
**Timeline:**

| Date | Activity |
|------|----------|
| **May 20** | Begin Wave 2 prep (parallel to Wave 1 monitoring) |
| **May 26–27** | Final QA + AAB builds |
| **May 28** | Upload all 5 apps to Play Console |
| **May 29–30** | Review period |
| **June 2–4** | Go live (staggered by 12h to manage load) |

**Wave 2 Staggered Rollout (By Hours):**
- **Day 1 (June 2):** MortgageCA + HELOCApp launch
- **Day 2 (June 3):** CreditCardAPR + LoanPayoffUS launch  
- **Day 3 (June 4):** MortgageUK launch

**Rationale:** Stagger to manage server load, monitor crashes, and allow marketing push per app.

**Regional Targeting:**
- **MortgageCA:** Canada (FR + EN)
- **MortgageUK:** United Kingdom (EN)
- **Others (US):** USA, Canada, UK, Australia

---

## Wave 3: Tier-C Monetization-Verified (Week 2)

**Apps:** JobOfferUS, ParkSmart, RentalExpenses, PropertyROISuite, RentBuyUS  
**Reason:** Monetization fully audited (Phase 2), UI/UX verified (Phase 3A)  
**Timeline:**

| Date | Activity |
|------|----------|
| **June 2–3** | Final testing on devices (graph rendering, paywall UX) |
| **June 4** | AAB builds + upload |
| **June 5–6** | Review period |
| **June 9–11** | Go live (staggered) |

**Wave 3 Staggered Rollout:**
- **Day 1 (June 9):** JobOfferUS + ParkSmart (highest criticality from Phase 2)
- **Day 2 (June 10):** RentalExpenses + PropertyROISuite
- **Day 3 (June 11):** RentBuyUS

---

## Wave 4: Tier-D Final Verified (Week 3)

**Apps:** TaxUS, TaxeCA, TaxeUK, SalaryApp, rideprofit  
**Reason:** Kotlin apps verified, remaining Flutter checked  
**Timeline:**

| Date | Activity |
|------|----------|
| **June 9–10** | Final verification + builds |
| **June 11** | Upload to Play Console |
| **June 12–13** | Review period |
| **June 16–18** | Go live (staggered) |

**Wave 4 Staggered Rollout:**
- **Day 1 (June 16):** TaxUS + TaxeCA (tax apps likely high-demand)
- **Day 2 (June 17):** TaxeUK + SalaryApp
- **Day 3 (June 18):** rideprofit

---

## Parallel Development (Waves 1-4)

While waves launch, teams work on **6 remaining apps:**

### INCOMPLETE Apps (UI/UX Testing)
- **PropertyROISuite** — already in Wave 3, but can get final polish
- **RentBuyUS** — already in Wave 3
- **SalaryApp** — in Wave 4

### Deferred to Phase 4 (Post-Launch)
- **icon_gen** → Utility tool, no Play Store needed
- **_ARCHIVE folder** → Old versions, no action
- **Remaining Flutter** → If any incomplete features identified

---

## Marketing & Launch Strategy

### Pre-Launch (Week of May 19)

**Preparation:**
- Create app store listing pages (local staging)
- Draft press release (optional, if targeting media)
- Prepare social media launch announcement
- Internal demo to stakeholders

**Content:**
- Feature blog post (Tier-A apps): "Smart Financial Tools for Homebuyers"
- Social media assets (screenshots + GIFs)
- Email list notification (existing user base, if any)

### Launch Day (Waves 1-4)

**Wave 1 (May 23-25):**
- Post on ProductHunt (optional, if eligible)
- Social media announcement
- Monitor Play Console dashboard

**Wave 2 (June 2-4):**
- Regional marketing (if budgeted)
- Follow-up social posts

**Wave 3 & 4 (June 9-18):**
- Monitor aggregate metrics
- Celebrate milestones (100k installs, avg 4.5★, etc.)

### Post-Launch (Ongoing)

**Week 1 Post-Launch:**
- Daily monitoring of ratings/reviews
- Response SLAs: 1-star reviews within 24h
- Crash analysis + hotfix planning

**Week 2-4:**
- Weekly performance review (installs, rating trends)
- Feature request aggregation
- Planning Phase 2 updates

**Month 2+:**
- Monthly feature releases (bug fixes + small enhancements)
- A/B testing on store listings
- User acquisition optimization

---

## Success Metrics (Per Wave)

### Wave 1 (Priority)
- **Target installs (Day 3):** 5,000+
- **Target rating:** ≥4.5 stars
- **Crash rate:** <0.1%
- **Paywall conversion:** ≥2% of users → premium

### Wave 2 (Confidence)
- **Target installs (Day 3):** 3,000+ per app
- **Target rating:** ≥4.2 stars
- **Crash rate:** <0.2%
- **i18n engagement:** ≥30% non-English users for CA/UK apps

### Wave 3 & 4 (Verification)
- **Target installs (Day 3):** 2,000+ per app
- **Target rating:** ≥4.0 stars
- **Crash rate:** <0.3%
- **User retention (Day 7):** ≥30%

### Portfolio (All 16 Apps)
- **30-day cumulative installs:** 100,000+
- **Average rating:** ≥4.3 stars across all apps
- **Total revenue (IAP + ads):** $5,000+ in first month (conservative)

---

## Risk Mitigation

### Risk: Google Play Review Rejection

**Scenario:** App rejected for policy violations (ads, IAP, privacy, etc.)  
**Mitigation:**
- Pre-submission audit against [Google Play policies](https://play.google.com/about/developer-content-policy/)
- Ensure privacy policy addresses: analytics, ads, IAP, data retention
- Test IAP flow end-to-end (not just UI)

**Response (If Rejected):**
1. Read rejection reason carefully
2. Fix specific issue within 24h
3. Resubmit without waiting for next wave
4. Escalate if rejection seems incorrect

### Risk: Server Overload (Post-Launch)

**Scenario:** Many users install → Firebase/Analytics overwhelmed  
**Mitigation:**
- Firebase quotas already cover modest scale
- Staggered rollout reduces peak load
- Monitor Firebase dashboard during launches

### Risk: Paywall Not Triggering

**Scenario:** Users exceed free calculation limit but paywall doesn't show  
**Mitigation:**
- Test paywall in Phase 3A (already done)
- Telemetry logs when paywall triggers (in AnalyticsService)
- Day 1 post-launch: Check Firebase events for "paywall_shown" count

### Risk: Negative Reviews (Low Rating)

**Scenario:** Users rate app 1-2 stars for UX/feature reasons  
**Mitigation:**
- Respond within 24h with empathy + solution
- Example: "Thanks for feedback! Paywall appears after 5 free uses. This monetization helps us maintain the app. Feel free to email us if you have questions."
- Plan quick fix for legitimate bugs

### Risk: Competitor Apps Launch Simultaneously

**Scenario:** Similar calc app hits Play Store same day  
**Mitigation:**
- Monitor competitors weekly (post-launch)
- Differentiate via unique features (amortization depth, UI polish, i18n)
- Respond quickly to feature requests users see in competitors

---

## Communication Plan

### Stakeholders & Notifications

**Internal Team:**
- **Engineer:** Receives build schedule + QA checklist
- **PM:** Monitors ratings + analytics
- **Support:** Handles user reviews + email inquiries
- **Finance:** Tracks revenue + IAP metrics

**External:**
- **Users (if existing base):** Email: "New app on Play Store, download today"
- **Marketing:** Social media launch announcements (Wave 1 priority)
- **Press (optional):** Press release if targeting media coverage

### Messaging Template (Per Wave)

```
Subject: [Wave 1 Ready] MortgageUS, AutoLoan, StudentLoan Go Live

Team,

Three flagship apps are now live on Google Play:
✓ MortgageUS (Mortgage Calculator) - https://play.google.com/store/apps/details?id=com.mortgageus.calculator
✓ AutoLoan (Auto Loan Calculator) - https://play.google.com/store/apps/details?id=com.autoloan.us
✓ StudentLoan (Student Loan Calculator) - https://play.google.com/store/apps/details?id=com.studentloan.calc

Monitoring Dashboard: [Firebase Console Link]
Support Email: support@calcwise.app
Review Response SLA: 24h for 1-star reviews

Next wave launches June 2.
```

---

## Monitoring Dashboard

**Daily Checks (During Launches):**
- Google Play Console: Installs, ratings, crash rate
- Firebase Analytics: Active users, top events, paywall conversion
- Firebase Crashlytics: New crashes, error rate trends

**Weekly Reviews (Post-Launch):**
- Install trend (linear growth or plateau?)
- Average rating trend
- Top user complaints (from reviews)
- Paywall → IAP conversion funnel

**Monthly Planning:**
- Feature release priorities (based on reviews)
- Regional expansion (if demand >threshold)
- Next batch of apps to launch

---

## Timeline Summary

```
Phase 3 Completion: May 11, 2026

Wave 1 Go-Live: May 23–25
  └─ 3 apps (MortgageUS, AutoLoan, StudentLoan)

Wave 2 Go-Live: June 2–4
  └─ 5 apps (MortgageCA, HELOCApp, CreditCardAPR, LoanPayoffUS, MortgageUK)

Wave 3 Go-Live: June 9–11
  └─ 5 apps (JobOfferUS, ParkSmart, RentalExpenses, PropertyROISuite, RentBuyUS)

Wave 4 Go-Live: June 16–18
  └─ 5 apps (TaxUS, TaxeCA, TaxeUK, SalaryApp, rideprofit)

16 Apps Live by June 18 (38 days from Phase 3 completion)
Portfolio Coverage: 73% (16/22 production apps)

Remaining 6 Apps: Phase 4+ (non-blocking, parallel track)
```

---

## Approval & Execution

### Go/No-Go Checklist (Per Wave)

**Go:** All items ✓
- [ ] AAB builds successfully
- [ ] No new lint errors
- [ ] Tests pass
- [ ] Screenshots ready
- [ ] Store listing approved by PM
- [ ] Data safety form complete
- [ ] Privacy policy updated
- [ ] Crash rate acceptable (<1% in pre-launch testing)

**No-Go:** Any item ✗ (delay to next wave, fix issue)

### Sign-Off Required

- **Engineer:** "Code ready for release"
- **PM:** "Store listing approved"
- **Ops (if applicable):** "Infrastructure ready"

---

## Success = Go-Live Timeline

✅ **Phase 3 complete:** May 11  
✅ **Wave 1 live:** May 23–25 (3 apps)  
✅ **Wave 2 live:** June 2–4 (5 apps)  
✅ **Wave 3 live:** June 9–11 (5 apps)  
✅ **Wave 4 live:** June 16–18 (5 apps)  
✅ **Parallel work:** Remaining 6 apps → Phase 4 (July+)  

**Portfolio at Go-Live: 16/22 apps (73%)**  
**Estimated Monthly Revenue (conservative): $5,000–$15,000 (IAP + ads)**  
**User Base Target (Month 1): 100,000+ installs**

---

## Next Action

**Execute Phase 3D:**
1. Confirm Wave 1 apps ready (MortgageUS, AutoLoan, StudentLoan)
2. Build AABs + upload to Play Console (May 19)
3. Monitor reviews (May 20+)
4. Go live (May 23–25)
5. Begin Wave 2 prep (parallel)

🚀 **Ready to launch!**
