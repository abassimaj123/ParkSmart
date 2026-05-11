# Data Safety & Privacy Forms — Play Store Submission

This document contains completed data safety declarations for all Wave 1–4 apps, ready for submission to Google Play Console.

---

## Wave 1: MortgageUS, AutoLoan, StudentLoan

### Data Safety Form — Template & Completed Declarations

**Google Play Console Requirement:** Each app must complete a data safety questionnaire declaring:
1. What user data is collected
2. How data is stored and transmitted
3. Whether data is shared with 3rd parties
4. Whether users can request data deletion

All Wave 1 apps follow this **standard freemium pattern:**
- Analytics collection (Firebase Analytics)
- Crash reporting (Firebase Crashlytics)
- Ad serving (Google Mobile Ads)
- IAP processing (Google Play Billing)
- **No personal data collection** (no names, emails, phone numbers, location, etc.)

---

### 1. MortgageUS Data Safety Declaration

**App Name:** MortgageUS  
**Package:** com.calcwise.mortgageus (or similar per flavor: .mortgageus.ca, .mortgageus.uk)  
**Version:** 1.0.1+2

#### DATA COLLECTION

**✅ Collected Data:**
- Analytics Events: App opens, calculator usage, feature interactions, screen views
- Crash Reports: Stack traces, device OS version, app version (Firebase Crashlytics)
- Advertising Data: Ad impressions, clicks (Google Mobile Ads)
- In-App Purchase Data: Transaction history (Google Play Billing)

**❌ NOT Collected:**
- Personal identifiers (name, email, phone, SSN)
- Financial account numbers or credentials
- Location data
- Contacts or call history
- Camera, microphone, or photos
- Health or biometric data
- User-entered calculation inputs (NOT stored on external servers)

#### DATA TRANSMISSION & SECURITY

**Encryption:**
- ✅ All network traffic: HTTPS/TLS 1.2+ (no unencrypted HTTP)
- ✅ Local storage: SQLite database with at-rest encryption (via sqflite)
- ✅ Analytics: Firebase Analytics enforces encryption in transit

**Servers:**
- Analytics: Google Firebase (USA data centers, GDPR/CCPA compliant)
- Crash logs: Google Firebase Crashlytics (USA, encrypted)
- Ads: Google Mobile Ads Network (USA, subject to Google Privacy Policy)
- IAP: Google Play Billing (USA, PCI DSS compliant — Google handles all payment processing)

**No Third-Party Data Sharing:**
- ✅ Analytics data NOT shared with 3rd parties (Firebase internal only)
- ✅ Crash reports NOT shared with 3rd parties (Firebase internal only)
- ✅ Ad network does NOT receive personal data (only anonymous ad IDs)
- ✅ IAP data handled by Google Play (no shared with app backend)

#### USER DELETION RIGHTS

Users can delete all app data by:
1. **In-App:** Settings → "Clear All Data" → deletes local history, preferences, cached calculations
2. **OS Level:** Settings → Apps → MortgageUS → Storage → "Clear Cache" and "Clear Data"
3. **Account Level:** Delete Google account (deletes all associated Firebase data)

**Data Retention:**
- Local history: Kept until user explicitly deletes (FIFO eviction after 5 free + unlimited premium)
- Analytics: Automatically deleted after 14 months (Firebase default)
- Crash reports: Automatically deleted after 90 days (Firebase default)
- Ads: Google Mobile Ads retention per Google Privacy Policy (typically 12–24 months)

---

### 2. AutoLoan Data Safety Declaration

**App Name:** AutoLoan  
**Package:** com.calcwise.autoloan (with regional flavors: .autoloan.ca, .autoloan.uk, .autoloan.us)  
**Version:** 1.0.1+2

#### DATA COLLECTION

**✅ Collected:**
- Analytics: App usage, regional preference, calculator features used, screen transitions
- Crashes: Stack traces, app version, device info (Firebase Crashlytics)
- Ads: Impression tracking, click events (Google Mobile Ads)
- IAP: Premium purchase history (Google Play Billing)

**❌ NOT Collected:**
- Personal data (name, email, contact info)
- Financial data (loan amounts entered, rates, payment amounts — NOT sent to servers)
- Vehicle details (VIN, registration)
- Location (GPS or approximate location)
- Device contacts, photos, or media
- Biometric data

#### DATA TRANSMISSION & SECURITY

**Encryption:**
- ✅ HTTPS/TLS 1.2+ for all network communication
- ✅ Local SQLite with encryption at rest
- ✅ Firebase endpoints encrypted by default

**Service Providers:**
- Firebase Analytics (Google, USA)
- Firebase Crashlytics (Google, USA)
- Google Mobile Ads Network (Google, USA)
- Google Play Billing (Google, USA)

**No Sharing Outside Google Services:**
- ✅ App backend: None (all server communication is Firebase)
- ✅ 3rd parties: No sharing of analytics or crash data
- ✅ Ad network: Receives only ad network ID, not user data

#### USER DELETION RIGHTS

Users control their data:
1. **In-App Deletion:** Settings → "Clear App Data" → removes local calculation history
2. **OS-Level:** Settings → Apps → AutoLoan → Storage → "Clear Cache"/"Clear Data"
3. **Google Account:** Delete Google account to remove all linked Firebase data

**Retention Policy:**
- Local app data: Until manually deleted
- Analytics: 14 months (Firebase automatic deletion)
- Crashes: 90 days (Firebase automatic deletion)
- Ad data: Per Google Ad Privacy Policy

---

### 3. StudentLoan Data Safety Declaration

**App Name:** StudentLoan  
**Package:** com.calcwise.studentloan  
**Version:** 1.0.1+2

#### DATA COLLECTION

**✅ Collected:**
- App Analytics: Feature usage, screen views, repayment plan selections, chart interactions
- Crash Reports: Stack traces, app/device info (Firebase Crashlytics)
- Advertising: Ad performance metrics (Google Mobile Ads)
- Purchase Data: Premium upgrade history (Google Play Billing)

**❌ NOT Collected:**
- Personal identity (name, SSN, email)
- Loan details (actual loan amounts, interest rates, school names)
- Financial accounts or credentials
- Location data
- Device identifiers (except for ad network and crash reporting)
- Biometric or health data

#### DATA TRANSMISSION & SECURITY

**Network Security:**
- ✅ Enforced HTTPS/TLS 1.2+ (no cleartext HTTP)
- ✅ SQLite local storage encrypted at rest
- ✅ Firebase services handle encryption transparently

**Backend & Servers:**
- Analytics: Firebase Analytics (Google, USA, GDPR/CCPA compliant)
- Crashes: Firebase Crashlytics (Google, USA)
- Ads: Google Mobile Ads (Google, USA)
- Payments: Google Play Billing (Google, USA, PCI DSS certified)

**Data Sharing:**
- ✅ Internal only (Firebase projects within Google ecosystem)
- ✅ No external APIs or 3rd-party integrations
- ✅ Ad network doesn't receive user data (only ad impressions)

#### USER DELETION RIGHTS

Users can delete all data:
1. **In-App:** Settings → "Delete All Saved Calculations" → clears local history
2. **System Settings:** Apps → StudentLoan → Storage → "Clear Cache"/"Clear Data"
3. **Google Account Deletion:** Removes all linked Firebase and ad data

**Data Retention:**
- App history: Until user deletes (capped at 5 free, unlimited premium)
- Analytics: Automatic deletion after 14 months
- Crashes: Automatic deletion after 90 days
- Ads: Per Google's retention policy (12–24 months typical)

---

## Standard Attestations (All Wave 1–4 Apps)

Each app submission must include these attestations in Google Play Console:

### ✅ Attestations Completed

**Data Security & Privacy:**
- [x] I confirm that I have appropriate legal authorization to collect and process user data
- [x] I have reviewed and comply with Google Play's Data Safety requirements
- [x] I have implemented reasonable security standards (HTTPS, encryption)
- [x] Users can request deletion of their data in accordance with applicable laws
- [x] The app does not sell user data to 3rd parties
- [x] The app does not share personal data with external parties without consent

**Compliance:**
- [x] App complies with COPPA (Children's Online Privacy Protection) — no children-targeted content
- [x] App complies with GDPR (General Data Protection Regulation) — EU users have data rights
- [x] App complies with CCPA (California Consumer Privacy Act) — applicable users have deletion rights
- [x] App complies with LGPD (Brazil) — where applicable

---

## Privacy Policy Template

**Location:** `https://abassimaj.github.io/privacy`  
**Must Include:**
1. What data is collected (list above)
2. How data is used (analytics, crash reporting, ad serving)
3. How data is protected (encryption, HTTPS)
4. Third-party services (Firebase, Google Ads)
5. User rights (deletion, opt-out options)
6. Contact: abassimaj@gmail.com

**Sample Privacy Policy Text:**

```
# Privacy Policy — Calcwise Apps

Last Updated: May 2026

## Data We Collect

### Analytics
We collect aggregated, anonymized analytics to understand app usage patterns and improve features. This includes:
- Screen views and feature interactions
- Calculation feature usage (not calculation inputs)
- App crashes and performance metrics
- Device OS version and app version

### Crash Reporting
We use Firebase Crashlytics to automatically report app crashes and errors, including:
- Stack traces
- Device information (OS, app version)
- Timing of crashes

This helps us identify and fix bugs quickly.

### Advertising
We serve ads via Google Mobile Ads. Ad networks may track:
- Ad impressions and clicks
- Advertising ID (non-personal identifier)
- Device type and general location (country/language)

Users can opt out of personalized ads in device settings.

### In-App Purchases
Google Play Billing processes all premium purchases. We do NOT store payment or credit card information — Google handles all payment processing securely.

## Data We Do NOT Collect

We explicitly do NOT collect:
- Names, emails, phone numbers, or other personal identifiers
- Financial account numbers or credentials
- Calculation inputs (loans, rates, payments)
- Location data (GPS or approximate)
- Contacts, photos, or device media
- Biometric or health data

## Data Security

- All network traffic is encrypted via HTTPS/TLS 1.2+
- Local app data is encrypted at rest
- We do not store sensitive data on external servers
- Firebase services are GDPR/CCPA compliant

## Third-Party Services

Our app uses these services:
- **Firebase Analytics** (Google) — analytics and crash reporting
- **Google Mobile Ads** (Google) — ad serving
- **Google Play Billing** (Google) — in-app purchases

Each service has its own privacy policy: https://policies.google.com/privacy

## User Rights & Data Deletion

You can delete all app data by:
1. In-app: Settings → "Clear All Data"
2. Device Settings: Apps → [App Name] → Storage → "Clear Cache"/"Clear Data"
3. Google Account: Delete your Google account to remove all linked Firebase data

You can also:
- Opt out of personalized ads (device settings)
- Request data deletion by emailing abassimaj@gmail.com

## Retention Policy

- Local app data: Kept until you delete
- Analytics: Automatically deleted after 14 months
- Crash reports: Automatically deleted after 90 days
- Ad data: Per Google's privacy policy (typically 12–24 months)

## Contact Us

Questions about privacy? Contact: abassimaj@gmail.com

## Changes to This Policy

We may update this policy. Changes take effect when posted.
```

---

## Submission Checklist (Per App)

- [ ] Privacy policy URL accessible and current
- [ ] Data safety questionnaire completed in Google Play Console
- [ ] All attestations checked (data security, compliance)
- [ ] Content rating form submitted (select "Everyone")
- [ ] Support email configured: abassimaj@gmail.com
- [ ] AdMob IDs verified (production, not test)
- [ ] Firebase project linked and enabled (Analytics + Crashlytics)
- [ ] IAP product ID verified in Google Play Console (`premium_upgrade`)

---

## Wave 2–4 Data Safety Declarations

For apps beyond Wave 1, use the **same template above** with minimal customization:
- App name and package ID
- Analytics category (e.g., "mortgage comparisons", "auto financing")
- Any regional data handling notes (e.g., UK GDPR Data Protection Act 2018)
- Same Firebase, Google Ads, Google Play Billing pattern (no variations)

All apps follow the **standard freemium model** — no exceptions.

---

## Notes for Compliance

1. **GDPR (EU/EEA Users):**
   - Users can request data export (via email to abassimaj@gmail.com)
   - Users have right to deletion (in-app + system settings)
   - Analytics can optionally be disabled via Settings

2. **CCPA (California Users):**
   - "Do Not Sell My Personal Information" link (none to provide — we don't sell data)
   - Right to deletion (in-app + system settings)
   - Disclosure in privacy policy

3. **COPPA (Under 13 Users):**
   - App is NOT directed at children
   - No collection of data from users under 13
   - No 3rd-party analytics on children (would require parental consent)

4. **LGPD (Brazil Users):**
   - User consent for analytics (implicit via app usage)
   - Right to deletion and data portability (in-app settings)

---

*Last updated: 2026-05-11*
