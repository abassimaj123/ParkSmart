# Master Play Store Submission Checklist — CalqWise Portfolio (27 Apps)

> Keystore: `D:/mob/keystore/release.jks` | Alias: `taxeca`
> Developer: CalqWise | Privacy: https://calqwise.com/privacy | Support: support@calqwise.com
> Last updated: 2026-04-28

---

## HOW TO USE THIS CHECKLIST

1. Copy the **Per-App Checklist** section below for each app.
2. Fill in the app name and package ID at the top.
3. Tick every item before clicking "Submit for review" in Play Console.
4. Reference the **IAP Prices**, **Screenshot Spec**, and **Build Commands** sections as needed.

---

## PER-APP CHECKLIST

### App: _____________________ | Package: _____________________ | Date: _____

---

### A. Build & Signing

- [ ] `flutter build appbundle --release --flavor [us|ca|uk]` (Flutter) OR `./gradlew bundleRelease` (Kotlin/Gradle) — exit code 0
- [ ] AAB signed with release keystore (`D:/mob/keystore/release.jks`, alias: `taxeca`)
- [ ] `versionCode` incremented from previous release (starts at 1 for first release)
- [ ] `versionName` set correctly (e.g. `1.0.0`)
- [ ] `kReleaseMode` = true — real AdMob IDs are active (not test IDs)
- [ ] No `debugUnlockPremium()` or `kDebugMode` override left in release paths
- [ ] `flutter analyze` → 0 errors (Flutter apps)
- [ ] AAB file size reasonable (< 50 MB preferred for Finance calculators)

### B. AdMob IDs

- [ ] App registered in AdMob console (admob.google.com)
- [ ] **App ID** updated in `AndroidManifest.xml` — no `XXXXXXXXXX` remaining
- [ ] **Banner** Ad Unit ID updated in `lib/config/ad_config.dart` (Flutter) or `strings.xml` / `AdConfig.kt` (Kotlin)
- [ ] **Interstitial** Ad Unit ID updated
- [ ] **Rewarded** Ad Unit ID updated
- [ ] Test run confirmed: banner renders, interstitial fires, rewarded plays

### C. Firebase

- [ ] `google-services.json` in `android/app/` (correct app, not test file)
- [ ] Firebase Analytics: events visible in DebugView after one test session
- [ ] Firebase Crashlytics: no crash on cold start

### D. IAP / Premium

- [ ] Product `premium_upgrade` created in Play Console → Monetize → In-app products
- [ ] IAP price set to correct amount (see **IAP Prices** table below)
- [ ] "Get Premium" button visible in Settings screen
- [ ] "Restore Purchase" button visible in Settings screen
- [ ] Purchase tested with Google Play test account (not a real charge)
- [ ] Premium unlocks: ads disabled, history unlimited, PDF export unrestricted
- [ ] Rewarded ad → 60-min ad-free timer confirmed working

### E. Functional Testing (Real Device — Not Emulator)

- [ ] App launches without crash on cold start
- [ ] Main calculation produces correct result (spot-check 2–3 values manually)
- [ ] Banner ad renders at screen bottom without layout overflow
- [ ] Interstitial fires after 5 calculations (per-session counter)
- [ ] 5-minute cooldown between interstitials verified
- [ ] Rewarded video loads, plays to completion, callback activates 60-min access
- [ ] History: free users limited to 3 entries; premium users unlimited
- [ ] PDF export generates a valid file and share sheet opens
- [ ] Language toggle works (EN/ES or EN/FR where applicable)
- [ ] Splash screen displays then dismisses correctly

### F. Store Listing (Play Console — Main Store Listing)

- [ ] **Title** entered (max 30 chars, main keyword included)
- [ ] **Short description** entered (max 80 chars)
- [ ] **Long description** entered (max 4000 chars) — copied from `STORE_LISTING.md`
- [ ] Release notes / "What's new" added (EN + secondary language if bilingual app)
- [ ] **Category:** Finance
- [ ] **Content rating questionnaire** completed → result: Everyone (Finance, no violence/mature)
- [ ] **Privacy policy URL:** `https://calqwise.com/privacy`
- [ ] **Price:** Free (with in-app purchases)

### G. Graphics & Assets

- [ ] **Hi-res icon** uploaded: 512×512 PNG, no rounded corners (Play Console applies mask)
- [ ] **Feature graphic** uploaded: 1024×500 JPG or PNG
- [ ] **5 screenshots** uploaded: 1080×1920 px portrait (or 1242×2208 accepted)
  - [ ] Screen 1 — main calculator with a result visible
  - [ ] Screen 2 — history screen
  - [ ] Screen 3 — premium/paywall screen
  - [ ] Screen 4 — settings screen
  - [ ] Screen 5 — feature highlight (PDF export, dashboard, or unique feature)
- [ ] No placeholder / lorem ipsum text visible in any screenshot
- [ ] No device frame required (Play Console shows its own frame)

### H. Data Safety Form (Play Console)

For all CalqWise Finance apps the answers are identical:

| Question | Answer |
|---|---|
| Does your app collect or share any of the required user data types? | Yes |
| Location data | No |
| Personal info (name, email, etc.) | No |
| Financial info | No |
| Health & fitness | No |
| Messages | No |
| Photos/videos | No |
| Audio | No |
| Files | No |
| Calendar | No |
| Contacts | No |
| App activity (analytics) | Yes — Analytics info: app interactions |
| Web browsing | No |
| App info (crash logs) | Yes — Diagnostics: crash logs |
| Device identifiers | Yes — for advertising (AdMob) |
| Is data encrypted in transit? | Yes |
| Can users request data deletion? | No — no account, no server-side data |
| Third-party libraries sharing data | Google AdMob, Google Firebase |

### I. Play Console Final Checks

- [ ] AAB uploaded to the correct track (Internal Testing → Closed Testing → Production)
- [ ] Release created and reviewed in Play Console — no blocking warnings
- [ ] Data safety form submitted (not just saved)
- [ ] App content declaration completed
- [ ] Target audience: 18+ (Finance apps, no under-13 audience)
- [ ] Ads declaration: "Contains ads" checked
- [ ] No COVID-19 contact tracing flag (N/A)

### J. Post-Launch Monitoring (Day +1 to +3)

- [ ] AdMob dashboard: first impressions visible within 24h
- [ ] Firebase Crashlytics: no critical crashes (< 1 % crash rate target)
- [ ] Play Console: pre-launch report reviewed (ANR rate, crash rate)
- [ ] Play Console: rating/reviews tab bookmarked
- [ ] AdMob eCPM check after 48h (targets: US/CA > $1.50, UK > $1.00, others > $0.75)

---

## IAP PRICES PER APP

> Product ID for all apps: `premium_upgrade` (one-time purchase, non-consumable)
> Set prices in Play Console → Monetize → In-app products → Create product

| # | App | Package ID | Market | IAP Price | Currency |
|---|-----|-----------|--------|-----------|----------|
| 1 | Salary Calculator US | com.salary.us.calculator | US | $2.99 | USD |
| 2 | Salary Calculator Canada | com.salary.ca.calculator | CA | $3.99 | CAD |
| 3 | Salary Calculator UK | com.salary.uk.calculator | UK | £1.99 | GBP |
| 4 | RideProfit | com.rideprofit.app | US | $2.99 | USD |
| 5 | TaxeCA | com.taxeca.calculator | CA | $3.99 | CAD |
| 6 | TaxUS | com.taxus.calculator | US | $2.99 | USD |
| 7 | TaxeUK | com.taxeuk.calculator | UK | £1.99 | GBP |
| 8 | MortgageUS | com.mortgageus.calculator | US | $2.99 | USD |
| 9 | MortgageCA | com.mortgageca.calculator | CA | $3.99 | CAD |
| 10 | MortgageUK | com.mortgageuk.calculator | UK | £1.99 | GBP |
| 11 | AffordabilityUS | com.affordability.us.calculator | US | $2.99 | USD |
| 12 | AutoLoan | com.autoloan.ca.calculator | Multi | $2.99 / CA$3.99 / £1.99 | varies |
| 13 | HELOCApp | com.heloc.us.calculator | US | $2.99 | USD |
| 14 | LoanPayoffUS | com.loanpayoff.us.calculator | US | $2.99 | USD |
| 15 | RentBuyUS | com.rentbuy.us.calculator | US | $2.99 | USD |
| 16 | RefinanceApp | com.refinance.us.calculator | US | $2.99 | USD |
| 17 | CreditCardAPR | com.creditcard.us.calculator | US | $1.99 | USD |
| 18 | StudentLoan | com.studentloan.us.calculator | US | $2.99 | USD |
| 19 | PropertyROI | com.propertyroi.us.calculator | US | $2.99 | USD |
| 20 | MortgageExtraPayment | com.calqwise.mortgageextrapayment | US | $2.99 | USD |
| 21 | RentalROI | com.rentalroi.us.calculator | US | $2.99 | USD |
| 22 | CapRate | com.caprate.us.calculator | US | $2.99 | USD |
| 23 | LandlordCashFlow | com.landlord.cashflow.calculator | US | $2.99 | USD |
| 24 | BRRRRCalc | com.brrrr.us.calculator | US | $2.99 | USD |
| 25 | HouseFlip | com.houseflip.us.calculator | US | $2.99 | USD |
| 26 | RentalExpenses | com.rentalexpenses.us.calculator | US | $2.99 | USD |
| 27 | AffordabilityCA* | com.affordabilityca.calculator | CA | $3.99 | CAD |

> *AffordabilityCA not found in /d/mob/ directory — verify package and path before submission.
> AutoLoan multi-flavor: set price per flavor's market in respective Play Console listing.

---

## SCREENSHOT SPEC

> Size: 1080×1920 px (portrait) — minimum. 1242×2208 also accepted.
> Format: PNG or JPEG. No alpha channel for JPEG.
> No device frame needed — Play Console adds its own.
> Capture on a real Android device or use Android Studio emulator at correct resolution.
> Tip: Use `adb shell screencap -p /sdcard/screen.png && adb pull /sdcard/screen.png` to pull screenshots.

### Standard 5-Screen Set for Calculator Apps

| # | Screen | What to Show |
|---|--------|-------------|
| 1 | Main calculator with result | Input a realistic value (e.g. $75,000 salary or $45,000 mortgage). The full result card is visible — all breakdown fields populated. No empty state. |
| 2 | History screen | 3–5 saved calculations listed. Each row shows the key inputs and result. If free tier shows a "Upgrade for unlimited" banner, include it — it signals premium value. |
| 3 | Premium / Paywall | The UnlockBottomSheet or soft paywall dialog. Show the price, the 3–4 bullet benefits, and the "Watch Ad — 1h Free Access" secondary button. This converts browsers. |
| 4 | Settings screen | Language toggle, Premium status, Restore Purchase, Privacy Policy, and app version visible. |
| 5 | Feature highlight | Varies by app: PDF export share sheet (SalaryApp / RideProfit), deal quality badge or amortization chart (MortgageUS), Reality Check dashboard (RideProfit), province selector with chart (TaxeCA). Show the unique differentiator. |

### Tips for High-Converting Screenshots
- Use a clean, fully charged battery bar (or hide status bar with `adb shell settings put global sysui_demo_allowed 1`)
- Fill all input fields — never show an empty calculator
- Use round, believable numbers (e.g. $65,000, not $64,837)
- Dark theme screenshots stand out in Finance category (most competitors use white)
- Add text overlay captions in a design tool (Canva, Figma) for screens 1 and 5

---

## BUILD COMMANDS

### Flutter Apps (SalaryApp, RideProfit, MortgageUS, MortgageCA, MortgageUK, AffordabilityUS, AutoLoan, HELOCApp, LoanPayoffUS, RentBuyUS, RefinanceApp, CreditCardAPR, StudentLoan, PropertyROI, MortgageExtraPayment, RentalROI, CapRate, LandlordCashFlow, BRRRRCalc, HouseFlip, RentalExpenses)

```bash
# Single flavor (most apps):
flutter build appbundle --release

# Multi-flavor (SalaryApp):
flutter build appbundle --release --flavor us    # com.salary.us.calculator
flutter build appbundle --release --flavor ca    # com.salary.ca.calculator
flutter build appbundle --release --flavor uk    # com.salary.uk.calculator

# Output path:
# build/app/outputs/bundle/[flavor]Release/app-[flavor]-release.aab
```

### Kotlin/Gradle Apps (TaxeCA, TaxUS, TaxeUK)

```bash
# From the app's root directory (e.g. D:/mob/TaxeCA/):
./gradlew bundleRelease

# Output path:
# app/build/outputs/bundle/release/app-release.aab
```

### Keystore configuration (all apps)

Ensure `key.properties` (Flutter) or `local.properties` (Kotlin) exists in the Android subfolder:

**Flutter — `android/key.properties`:**
```properties
keyAlias=taxeca
keyPassword=<your-key-password>
storeFile=D:/mob/keystore/release.jks
storePassword=<your-store-password>
```

**Kotlin — verify `app/build.gradle.kts` reads from `key.properties` at project root.**

### Verify AAB is signed correctly:
```bash
# Using bundletool:
java -jar bundletool.jar validate --bundle=app-release.aab

# Or check with apksigner (from Android SDK build-tools):
apksigner verify --verbose app-release.aab
```

---

## ADMOB IDS TO REPLACE

### Where to find IDs in AdMob Console
1. Sign in at https://admob.google.com
2. Apps → select app → App settings → **App ID** (format: `ca-app-pub-XXXXXXXX~XXXXXXXXXX`)
3. Ad units → select unit → **Ad unit ID** (format: `ca-app-pub-XXXXXXXX/XXXXXXXXXX`)

### Placeholder format in codebase
All apps use `XXXXXXXXXX` as the placeholder for unregistered IDs. Before release, confirm zero occurrences:

```bash
# Flutter apps:
grep -r "XXXXXXXXXX" lib/ android/app/src/main/AndroidManifest.xml

# Kotlin apps:
grep -r "XXXXXXXXXX" app/src/main/
```

### Where to update per app type

**Flutter apps — `lib/config/ad_config.dart`:**
```dart
static const String bannerAdUnitId      = 'ca-app-pub-XXXXX/XXXXX';  // <-- replace
static const String interstitialAdUnitId = 'ca-app-pub-XXXXX/XXXXX'; // <-- replace
static const String rewardedAdUnitId     = 'ca-app-pub-XXXXX/XXXXX'; // <-- replace
```

**Flutter apps — `android/app/src/main/AndroidManifest.xml`:**
```xml
<meta-data
    android:name="com.google.android.gms.ads.APPLICATION_ID"
    android:value="ca-app-pub-XXXXX~XXXXX"/>  <!-- <-- replace App ID here -->
```

**Kotlin apps (TaxeCA, TaxUS, TaxeUK) — `app/src/main/AndroidManifest.xml`:**
```xml
<meta-data
    android:name="com.google.android.gms.ads.APPLICATION_ID"
    android:value="${admobAppId}"/>
```
App ID injected via `local.properties`:
```properties
admob.appId=ca-app-pub-XXXXX~XXXXX
```

### Publisher Account
All apps use publisher ID: `ca-app-pub-5379540026739666`
Real Ad Unit IDs are all `ca-app-pub-5379540026739666/XXXXXXXXXX` — the `XXXXXXXXXX` suffix is what must be replaced per unit.
Full list of 45 IDs to fill: see `/d/mob/AdMob_Unit_IDs_Spreadsheet.csv`

---

## SUBMISSION ORDER RECOMMENDATION

Submit in this order to maximize early revenue signal for AdMob RPM optimization:

### Wave 1 — Highest-value markets (submit first)
1. MortgageUS (`com.mortgageus.calculator`) — Tier-S US, highest search volume
2. Salary Calculator US (`com.salary.us.calculator`) — Tier-A US, very high intent
3. RideProfit (`com.rideprofit.app`) — unique EN+ES niche, no competition
4. TaxeCA (`com.taxeca.calculator`) — already in Closed Testing, promote to Production

### Wave 2 — Strong US real estate
5. PropertyROI
6. CapRate
7. RentalROI
8. LandlordCashFlow
9. HouseFlip
10. BRRRRCalc

### Wave 3 — Finance / Loan calculators
11. HELOCApp
12. LoanPayoffUS
13. RentBuyUS
14. RefinanceApp
15. StudentLoan
16. MortgageExtraPayment

### Wave 4 — CA/UK + remaining
17. MortgageCA
18. MortgageUK
19. Salary Calculator Canada
20. Salary Calculator UK
21. TaxUS
22. TaxeUK
23. AffordabilityUS
24. AutoLoan
25. CreditCardAPR
26. RentalExpenses
27. AffordabilityCA

---

## QUICK REFERENCE — ALL 27 APPS

| # | App | Package ID | Market | IAP Price | Build Type | STORE_LISTING.md |
|---|-----|-----------|--------|-----------|-----------|-----------------|
| 1 | Salary App US | com.salary.us.calculator | US | $2.99 | Flutter (flavor: us) | D:/mob/SalaryApp/STORE_LISTING.md |
| 2 | Salary App CA | com.salary.ca.calculator | CA | CA$3.99 | Flutter (flavor: ca) | D:/mob/SalaryApp/STORE_LISTING.md |
| 3 | Salary App UK | com.salary.uk.calculator | UK | £1.99 | Flutter (flavor: uk) | D:/mob/SalaryApp/STORE_LISTING.md |
| 4 | RideProfit | com.rideprofit.app | US | $2.99 | Flutter | D:/mob/rideprofit/STORE_LISTING.md |
| 5 | TaxeCA | com.taxeca.calculator | CA | CA$3.99 | Kotlin | D:/mob/TaxeCA/ (create) |
| 6 | TaxUS | com.taxus.calculator | US | $2.99 | Kotlin | D:/mob/TaxUS/ (create) |
| 7 | TaxeUK | com.taxeuk.calculator | UK | £1.99 | Kotlin | D:/mob/TaxeUK/ (create) |
| 8 | MortgageUS | com.mortgageus.calculator | US | $2.99 | Flutter | D:/mob/MortgageUS/ (create) |
| 9 | MortgageCA | com.mortgageca.calculator | CA | CA$3.99 | Flutter | D:/mob/MortgageCA/ (create) |
| 10 | MortgageUK | com.mortgageuk.calculator | UK | £1.99 | Flutter | D:/mob/MortgageUK/ (create) |
| 11 | AffordabilityUS | com.affordability.us.calculator | US | $2.99 | Flutter | D:/mob/AffordabilityUS/ (create) |
| 12 | AutoLoan | com.autoloan.ca.calculator | Multi | varies | Flutter | D:/mob/AutoLoan/ (create) |
| 13 | HELOCApp | com.heloc.us.calculator | US | $2.99 | Flutter | D:/mob/HELOCApp/ (create) |
| 14 | LoanPayoffUS | com.loanpayoff.us.calculator | US | $2.99 | Flutter | D:/mob/LoanPayoffUS/ (create) |
| 15 | RentBuyUS | com.rentbuy.us.calculator | US | $2.99 | Flutter | D:/mob/RentBuyUS/ (create) |
| 16 | RefinanceApp | com.refinance.us.calculator | US | $2.99 | Flutter | D:/mob/RefinanceApp/ (create) |
| 17 | CreditCardAPR | com.creditcard.us.calculator | US | $1.99 | Flutter | D:/mob/CreditCardAPR/ (create) |
| 18 | StudentLoan | com.studentloan.us.calculator | US | $2.99 | Flutter | D:/mob/StudentLoan/ (create) |
| 19 | PropertyROI | com.propertyroi.us.calculator | US | $2.99 | Flutter | D:/mob/PropertyROI/ (create) |
| 20 | MortgageExtraPayment | com.calqwise.mortgageextrapayment | US | $2.99 | Flutter | D:/mob/MortgageExtraPayment/ (create) |
| 21 | RentalROI | com.rentalroi.us.calculator | US | $2.99 | Flutter | D:/mob/RentalROI/ (create) |
| 22 | CapRate | com.caprate.us.calculator | US | $2.99 | Flutter | D:/mob/CapRate/ (create) |
| 23 | LandlordCashFlow | com.landlord.cashflow.calculator | US | $2.99 | Flutter | D:/mob/LandlordCashFlow/ (create) |
| 24 | BRRRRCalc | com.brrrr.us.calculator | US | $2.99 | Flutter | D:/mob/BRRRRCalc/ (create) |
| 25 | HouseFlip | com.houseflip.us.calculator | US | $2.99 | Flutter | D:/mob/HouseFlip/ (create) |
| 26 | RentalExpenses | com.rentalexpenses.us.calculator | US | $2.99 | Flutter | D:/mob/RentalExpenses/ (create) |
| 27 | AffordabilityCA | com.affordabilityca.calculator | CA | CA$3.99 | Flutter | D:/mob/AffordabilityCA/ (create) |

> Apps marked "(create)" need a `STORE_LISTING.md` file written before submission.
> SalaryApp has 3 flavors = 3 separate Play Console listings = 3 rows above (rows 1–3).
> Total Play Console listings: 27 (SalaryApp counts as 3).
