# Integration Checklist — CalqWise 26-App Portfolio
> Per-app checklist. Tick off before submitting each app to Play Console.

---

## App: _____________________ | Package: _____________________ | Date: _____

---

## AdMob Setup
- [ ] App registered in AdMob console (admob.google.com)
- [ ] Banner Ad Unit ID created → `lib/config/ad_config.dart` updated
- [ ] Interstitial Ad Unit ID created → `lib/config/ad_config.dart` updated
- [ ] Rewarded Ad Unit ID created → `lib/config/ad_config.dart` updated
- [ ] AdMob App ID updated in `android/app/src/main/AndroidManifest.xml`
- [ ] No `XXXXXXXXXX` remaining in release build paths

## Monetization — Code
- [ ] `FreemiumService` / `freemiumService.initialize()` called in `main()`
- [ ] `IAPService.instance.initialize()` called in `main()`
- [ ] `AdService.instance.initialize()` called in `main()`
- [ ] `BannerAdWidget` at bottom of all calculator screens
- [ ] `AdService.instance.onCalculation()` called after each calc
- [ ] `PaywallService` initialized in `main()` — `paywallService.init()`
- [ ] Soft paywall triggers after session 2 or 3
- [ ] Hard paywall triggers after every 5th calculation

## IAP / Premium
- [ ] Product `premium_upgrade` created in Play Console → Monetize → In-app products
- [ ] Price set per market: US=$2.99 / UK=£1.99 / CA=$3.99 / AU=A$4.49
- [ ] "Get Premium" button visible in Settings
- [ ] "Restore Purchase" button visible in Settings
- [ ] Purchase tested with Google Play test account
- [ ] Premium disables all ads (banner + interstitial)
- [ ] Rewarded 60-min timer works and hides ads

## Testing (Real Device Only — Not Emulator)
- [ ] Banner ad renders correctly at screen bottom
- [ ] Interstitial fires after 5 calculations (count is per-session)
- [ ] 5-min cooldown between interstitials verified
- [ ] Rewarded video loads and plays to completion
- [ ] Rewarded callback activates 60-min ad-free period
- [ ] History limited to 3 for free users
- [ ] History unlimited for premium users
- [ ] No crash on cold start (Firebase Crashlytics if integrated)
- [ ] Language toggle works correctly (EN/ES or EN/FR)

## Build
- [ ] `kReleaseMode` = true → real AdMob IDs used (not test IDs)
- [ ] No `debugUnlockPremium()` or `kDebugMode` overrides left active
- [ ] `flutter analyze` → 0 errors
- [ ] `flutter build appbundle --release` → exit 0
- [ ] AAB signed with correct keystore
- [ ] `versionCode` incremented from previous release
- [ ] `versionName` set correctly (e.g. `1.0.0`)

## Store Listing
- [ ] App title: ≤ 50 characters, includes main keyword
- [ ] Short description: ≤ 80 characters
- [ ] Long description: 4000 chars max, benefit-focused bullet points
- [ ] Privacy Policy URL: `https://calqwise.com/privacy`
- [ ] Feature graphic: 1024×500 px (JPEG or PNG)
- [ ] Screenshots: 5+ portrait (min 1080×1920)
- [ ] Category: Finance
- [ ] Content rating: Everyone (PEGI 3)
- [ ] "CalqWise" or "CalqWise Apps" as developer name

## Play Console
- [ ] AAB uploaded to new release (Internal/Closed Testing → Production)
- [ ] Data safety section completed (collects: purchases, device IDs for ads)
- [ ] Release notes added (EN + other language if app supports it)
- [ ] No blocking pre-launch report warnings

## Post-Launch Monitoring (J+1)
- [ ] AdMob dashboard: first impressions visible
- [ ] Firebase Crashlytics: no critical crashes
- [ ] Play Console: rating/reviews tab checked
- [ ] AdMob eCPM target after 48h: US/CA >$1.50, UK >$1.00

---

## Quick Reference — All 26 Apps

### New Apps (Built 2026-04-21)
| App | Package | Market | Price | Status |
|-----|---------|--------|-------|--------|
| RentalROI | com.rentalroi.us.calculator | US | $2.99 | READY TO BUILD |
| CapRate | com.caprate.us.calculator | US | $2.99 | READY TO BUILD |
| LandlordCashFlow | com.landlord.cashflow.calculator | US | $2.99 | READY TO BUILD |
| BRRRRCalc | com.brrrr.us.calculator | US | $2.99 | READY TO BUILD |
| HouseFlip | com.houseflip.us.calculator | US | $2.99 | READY TO BUILD |
| RentalExpenses | com.rentalexpenses.us.calculator | US | $2.99 | READY TO BUILD |

### Existing Apps (AdMob IDs needed)
| App | Package | Market | Price | Status |
|-----|---------|--------|-------|--------|
| AffordabilityCA | com.affordabilityca.calculator | CA | CA$3.99 | AdMob IDs pending |
| AffordabilityUK | com.affordability.uk.calculator | UK | £1.99 | AdMob IDs pending |
| AffordabilityUS | com.affordability.us.calculator | US | $2.99 | AdMob IDs pending |
| HELOCApp | com.heloc.us.calculator | US | $2.99 | AdMob IDs pending |
| PropertyROI | com.propertyroi.us.calculator | US | $2.99 | AdMob IDs pending |
| SalaryApp | com.salary.us.calculator | US | $2.99 | AdMob IDs pending |
| StudentLoan | com.studentloan.us.calculator | US | $2.99 | AdMob IDs pending |
| MortgageCA | com.mortgageca.calculator | CA | CA$3.99 | AdMob IDs pending |
| MortgageUK | com.mortgageuk.calculator | UK | £1.99 | AdMob IDs pending |
| MortgageUS | com.mortgageus.calculator | US | $2.99 | AdMob IDs pending |
| AutoLoan | com.autoloan.auto_loan | Multi | varies | AdMob IDs pending |
| LoanPayoffUS | com.loanpayoff.us.calculator | US | $2.99 | AdMob IDs pending |
| RentBuyUS | com.rentbuy.us.calculator | US | $2.99 | AdMob IDs pending |
| RefinanceApp | com.refinance.us.calculator | US | $2.99 | AdMob IDs pending |
| CreditCardAPR | com.creditcard.us.calculator | US | $2.99 | AdMob IDs pending |
| TaxeCA | com.taxeca.calculator | CA | — | CLOSED TESTING (exp 2026-05-04) |

> See `AdMob_Unit_IDs_Spreadsheet.csv` for all 45 IDs to fill in.
