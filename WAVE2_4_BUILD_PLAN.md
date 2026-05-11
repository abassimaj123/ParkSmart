# Wave 2–4 Build Plan & Compilation Fixes

This document outlines the remaining compilation fixes needed for the 13 apps in Wave 2–4, based on systematic error patterns identified during Wave 1 AAB builds.

---

## Wave 2: 5 Apps (June 2–4)

Target: **MortgageCA, HELOCApp, CreditCardAPR, LoanPayoffUS, MortgageUK**

### Build Status Check

Each app in Wave 2 likely exhibits the **same 4 systemic compilation errors** as Wave 1 apps:

1. **ValueNotifier import missing** (lib/core/freemium/iap_service.dart)
   - Error: `Type 'ValueNotifier' not found`
   - Fix: Add `import 'package:flutter/foundation.dart' show ValueNotifier;`

2. **AnalyticsService type mismatch** (lib/core/freemium/iap_service.dart)
   - Error: `The argument type 'AnalyticsService' can't be assigned to the parameter type 'CalcwiseAnalytics'`
   - Fix: Replace `analytics: AnalyticsService.instance,` with `analytics: CalcwiseAnalytics(appName: '[app_name]'),`
   - Remove: `import '../../services/analytics_service.dart';` (no longer needed)

3. **intl dependency version conflict** (pubspec.yaml)
   - Error: `Because auto_loan depends on intl ^0.19.0, intl ^0.20.0 is required...`
   - Fix: Update all Flutter app pubspec.yaml to `intl: ^0.20.0` (matches calcwise_core)

4. **FreemiumService.freeHistoryLimit → MonetizationConfig.freeCalculationLimit**
   - Error: `Undefined name 'FreemiumService'` or `freeHistoryLimit` doesn't exist
   - Pattern: Search for `FreemiumService.free` and replace with `MonetizationConfig.freeCalculationLimit`
   - Locations: Typically in lib/screens/history_screen.dart, lib/core/db/database_service.dart

### Wave 2 Apps: Expected Errors & Fixes

#### 1. MortgageCA

**Location:** `/d/mob/MortgageCA/`

**Expected Errors:**
- [ ] ValueNotifier import missing
- [ ] AnalyticsService type mismatch
- [ ] intl ^0.19.0 → ^0.20.0
- [ ] FreemiumService.freeHistoryLimit references
- [ ] CalcwiseTheme/CalcwiseStaggerItem import restrictions

**Estimated Fix Time:** 10–15 min

**Commands:**
```bash
cd D:/mob/MortgageCA
flutter clean && flutter pub get
flutter analyze  # Identify remaining errors
flutter build appbundle --release
```

---

#### 2. HELOCApp

**Location:** `/d/mob/HELOCApp/`

**Expected Errors:**
- [ ] ValueNotifier import missing
- [ ] AnalyticsService type mismatch
- [ ] intl dependency conflict
- [ ] FreemiumService references
- [ ] Possibly missing CalcwiseTheme in screens

**Estimated Fix Time:** 15–20 min (likely more complex app with home equity logic)

**Commands:**
```bash
cd D:/mob/HELOCApp
flutter clean && flutter pub get
flutter analyze
flutter build appbundle --release
```

---

#### 3. CreditCardAPR

**Location:** `/d/mob/CreditCardAPR/`

**Expected Errors:**
- [ ] ValueNotifier import missing
- [ ] AnalyticsService type mismatch
- [ ] intl version conflict
- [ ] FreemiumService references

**Estimated Fix Time:** 10–15 min

**Commands:**
```bash
cd D:/mob/CreditCardAPR
flutter clean && flutter pub get
flutter analyze
flutter build appbundle --release
```

---

#### 4. LoanPayoffUS

**Location:** `/d/mob/LoanPayoffUS/`

**Expected Errors:**
- [ ] ValueNotifier import missing
- [ ] AnalyticsService type mismatch
- [ ] intl dependency conflict
- [ ] FreemiumService references

**Estimated Fix Time:** 10–15 min

**Commands:**
```bash
cd D:/mob/LoanPayoffUS
flutter clean && flutter pub get
flutter analyze
flutter build appbundle --release
```

---

#### 5. MortgageUK

**Location:** `/d/mob/MortgageUK/`

**Expected Errors:**
- [ ] ValueNotifier import missing
- [ ] AnalyticsService type mismatch
- [ ] intl version conflict
- [ ] FreemiumService references
- [ ] Possibly UK-specific mortgage calculation errors (if LTV logic present)

**Estimated Fix Time:** 15–20 min

**Commands:**
```bash
cd D:/mob/MortgageUK
flutter clean && flutter pub get
flutter analyze
flutter build appbundle --release
```

---

## Wave 3: 5 Apps (June 9–11)

Target: **JobOfferUS, ParkSmart, RentalExpenses, PropertyROISuite, RentBuyUS**

### Build Status

These apps were flagged as INCOMPLETE in Phase 2 or required monetization fixes. Expect the **same 4 systemic errors** plus potentially:

- Missing ad_service.dart
- Incomplete database_helper.dart
- Missing i18n strings files
- Graph library integration issues (fl_chart, syncfusion)

#### 1. JobOfferUS

**Status:** Fixed in Phase 2 (CRITICAL). Should build.

**Expected Errors:**
- [ ] ValueNotifier import
- [ ] AnalyticsService type mismatch
- [ ] intl version conflict
- [ ] FreemiumService references

**Build Test:**
```bash
cd D:/mob/JobOfferUS
flutter clean && flutter pub get
flutter build appbundle --release
```

---

#### 2. ParkSmart

**Status:** Fixed in Phase 2 (CRITICAL). Verify ad_service + database_helper added.

**Expected Errors:**
- [ ] ValueNotifier import
- [ ] AnalyticsService type mismatch
- [ ] intl version conflict
- [ ] FreemiumService references
- [ ] Possibly missing GoogleMobileAds.initialize() call

**Build Test:**
```bash
cd D:/mob/ParkSmart
flutter clean && flutter pub get
flutter analyze
flutter build appbundle --release
```

---

#### 3. RentalExpenses

**Status:** Fixed in Phase 2 (i18n strings added). Verify compile.

**Expected Errors:**
- [ ] ValueNotifier import
- [ ] AnalyticsService type mismatch
- [ ] intl version conflict
- [ ] FreemiumService references
- [ ] Possibly missing property expense domain logic

**Build Test:**
```bash
cd D:/mob/RentalExpenses
flutter clean && flutter pub get
flutter analyze
flutter build appbundle --release
```

---

#### 4. PropertyROISuite

**Status:** UI/UX tested (Phase 3A) — should compile. Verify graph library integration.

**Expected Errors:**
- [ ] ValueNotifier import
- [ ] AnalyticsService type mismatch
- [ ] intl version conflict
- [ ] FreemiumService references
- [ ] fl_chart version mismatch (may need ^0.69.0 minimum)

**Build Test:**
```bash
cd D:/mob/PropertyROISuite
flutter clean && flutter pub get
flutter analyze
flutter build appbundle --release
```

---

#### 5. RentBuyUS

**Status:** UI/UX tested (Phase 3A) — should compile. Verify graph rendering.

**Expected Errors:**
- [ ] ValueNotifier import
- [ ] AnalyticsService type mismatch
- [ ] intl version conflict
- [ ] FreemiumService references
- [ ] fl_chart or comparison chart library integration

**Build Test:**
```bash
cd D:/mob/RentBuyUS
flutter clean && flutter pub get
flutter analyze
flutter build appbundle --release
```

---

## Wave 4: 5 Apps (June 16–18)

Target: **TaxUS, TaxeCA, TaxeUK, SalaryApp, rideprofit**

### Build Status

Wave 4 includes **3 Kotlin/Native apps** (TaxUS, TaxeCA, TaxeUK) and **2 final Flutter apps** (SalaryApp, rideprofit).

**Kotlin apps:** Already validated in Phase 3B — focus on AAB build verification.

**Flutter apps:** Expect standard systemic errors + app-specific issues.

#### 1. TaxUS (Kotlin/Native)

**Status:** Kotlin verified in Phase 3B. Build AAB via Gradle.

**Build Command:**
```bash
cd D:/mob/TaxUS
./gradlew bundleRelease
```

**Expected Issues:**
- [ ] AndroidManifest.xml permissions (INTERNET, etc.)
- [ ] Firebase config (google-services.json)
- [ ] AdMob IDs in Gradle buildConfig
- [ ] Verify API level 26+ compatibility

---

#### 2. TaxeCA (Kotlin/Native)

**Status:** Kotlin verified in Phase 3B (Quebec French tax rules). Build AAB.

**Build Command:**
```bash
cd D:/mob/TaxeCA
./gradlew bundleRelease
```

**Expected Issues:**
- [ ] Verify French localization (res/values-fr/)
- [ ] Quebec-specific tax calculations (provincial rates)
- [ ] Firebase Analytics appName: "taxeca"
- [ ] Verify signing key configured

---

#### 3. TaxeUK (Kotlin/Native)

**Status:** Kotlin verified in Phase 3B (HMRC compliance). Build AAB.

**Build Command:**
```bash
cd D:/mob/TaxeUK
./gradlew bundleRelease
```

**Expected Issues:**
- [ ] Verify UK-specific tax rules (HMRC rates)
- [ ] Ensure API level compatibility (target SDK 34+)
- [ ] Firebase Crashlytics linked
- [ ] AdMob integration verified

---

#### 4. SalaryApp (Flutter)

**Status:** UI/UX tested (Phase 3A). Expect standard Flutter errors.

**Expected Errors:**
- [ ] ValueNotifier import
- [ ] AnalyticsService type mismatch
- [ ] intl version conflict
- [ ] FreemiumService references
- [ ] Salary breakdown chart rendering (fl_chart integration)

**Build Test:**
```bash
cd D:/mob/SalaryApp
flutter clean && flutter pub get
flutter analyze
flutter build appbundle --release
```

---

#### 5. rideprofit (Flutter)

**Status:** Mentioned as already complete in Phase 2. Verify compile.

**Expected Errors:**
- [ ] ValueNotifier import
- [ ] AnalyticsService type mismatch
- [ ] intl version conflict
- [ ] FreemiumService references
- [ ] GPS mileage tracking logic (if present)

**Build Test:**
```bash
cd D:/mob/rideprofit
flutter clean && flutter pub get
flutter analyze
flutter build appbundle --release
```

---

## Common Fix Patterns (Apply to All 13 Apps)

### Fix Pattern 1: iap_service.dart (All Flutter apps)

```dart
// BEFORE (broken)
import 'package:calcwise_core/calcwise_core.dart';
import '../../services/analytics_service.dart';

ValueNotifier<String?> get localizedPrice => _iap.localizedPrice;

Future<void> initialize() async {
  _iap = CalcwiseIAP(
    productId: productId,
    freemium: freemiumService,
    analytics: AnalyticsService.instance,
  );
  ...
}

// AFTER (fixed)
import 'package:flutter/foundation.dart' show ValueNotifier;
import 'package:calcwise_core/calcwise_core.dart';

ValueNotifier<String?> get localizedPrice => _iap.localizedPrice;

Future<void> initialize() async {
  _iap = CalcwiseIAP(
    productId: productId,
    freemium: freemiumService,
    analytics: CalcwiseAnalytics(appName: '[app_name]'),
  );
  ...
}
```

### Fix Pattern 2: pubspec.yaml (All Flutter apps)

```yaml
# BEFORE
intl: ^0.19.0

# AFTER
intl: ^0.20.0
```

### Fix Pattern 3: history_screen.dart & database_service.dart

```dart
// BEFORE
import 'package:calcwise_core/calcwise_core.dart' show MonetizationConfig;

final limit = FreemiumService.freeHistoryLimit;  // ❌ undefined

// AFTER
import 'package:calcwise_core/calcwise_core.dart' show MonetizationConfig;

final limit = MonetizationConfig.freeCalculationLimit;  // ✅ correct
```

### Fix Pattern 4: Import Restrictions (screens)

```dart
// BEFORE
import 'package:calcwise_core/calcwise_core.dart' show PaywallTrigger;

// If using CalcwiseTheme or CalcwiseStaggerItem:
Text(
  'Content',
  style: TextStyle(color: CalcwiseTheme.of(context).primary),  // ❌ Error
)

// AFTER
import 'package:calcwise_core/calcwise_core.dart' show PaywallTrigger, CalcwiseTheme, CalcwiseStaggerItem;

Text(
  'Content',
  style: TextStyle(color: CalcwiseTheme.of(context).primary),  // ✅ OK
)
```

---

## Execution Timeline

| Phase | Wave | Apps | Target Dates | Status |
|-------|------|------|--------------|--------|
| 4A | 1 | MortgageUS, StudentLoan, AutoLoan | May 19–21 | ✅ COMPLETE |
| 4B | 2 | MortgageCA, HELOCApp, CreditCardAPR, LoanPayoffUS, MortgageUK | May 26–28 | ⏳ Ready |
| 4C | 3 | JobOfferUS, ParkSmart, RentalExpenses, PropertyROISuite, RentBuyUS | June 4–5 | ⏳ Ready |
| 4D | 4 | TaxUS, TaxeCA, TaxeUK, SalaryApp, rideprofit | June 10–12 | ⏳ Ready |

---

## Build Verification Checklist (Per App)

- [ ] `flutter clean && flutter pub get` succeeds
- [ ] `flutter analyze` has no critical errors
- [ ] `flutter build appbundle --release` completes (>30 MB AAB generated)
- [ ] AAB size within expected range (51–150 MB depending on app complexity)
- [ ] No "undefined" or "not found" errors in console output
- [ ] For Kotlin apps: `./gradlew bundleRelease` completes successfully

---

## Rollback & Troubleshooting

If a build fails unexpectedly:

1. **Check git status** — ensure no uncommitted changes interfere
2. **Run flutter clean** — remove stale build artifacts
3. **Check Dart version** — ensure >= 3.0.0 (check `flutter --version`)
4. **Compare to reference** — check MortgageUS for correct pattern
5. **Ask for help** — document error message + file path for debugging

---

## Next Steps (After All Waves Built)

1. Capture screenshots (8 per app) from emulator/device
2. Create feature graphics (1024x500 px) per app
3. Generate Play Store listing copy for Wave 2–4 (update PLAYSTORE_LISTINGS.md)
4. Submit data safety forms (DATA_SAFETY_FORMS.md template reusable)
5. Submit each Wave to Google Play Console per staggered timeline
6. Monitor crash reports and user ratings post-launch

---

*Last updated: 2026-05-11*
