# AdMob Setup Guide — Complete
**Publisher:** ca-app-pub-5379540026739666
**Date:** 2026-04-21
**Portfolio:** 26 apps (CalqWise)

---

## Step 1: Access AdMob Console

1. Go to **https://admob.google.com**
2. Sign in with Google Account linked to publisher ca-app-pub-5379540026739666
3. Left menu → **Apps**

---

## Step 2: Create Ad Units (Per App)

For EACH of 26 apps, create 3 ad units:

### 1. Banner Ad Unit
- Format: **Banner (320×50)**
- Name: `{app_name}_banner_us` (e.g. `mortgageus_banner_us`)
- Ad type: Display

### 2. Interstitial Ad Unit
- Format: **Interstitial** (full screen)
- Name: `{app_name}_interstitial_us`
- Ad type: Display

### 3. Rewarded Ad Unit
- Format: **Rewarded Video**
- Name: `{app_name}_rewarded_us`
- Reward item: `1 coin` (arbitrary — not used in code)
- Ad type: Video

---

## Step 3: Naming Convention

Format: `{app_slug}_{type}_{market}`

| App | App Slug | Market |
|-----|---------|--------|
| RentalROI | `rentalroi` | `us` |
| CapRate | `caprate` | `us` |
| LandlordCashFlow | `landlord` | `us` |
| BRRRRCalc | `brrrr` | `us` |
| HouseFlip | `houseflip` | `us` |
| RentalExpenses | `rentalexpenses` | `us` |
| MortgageUS | `mortgageus` | `us` |
| MortgageUK | `mortgageuk` | `uk` |
| MortgageCA | `mortgageca` | `ca` |
| AffordabilityCA | `affordabilityca` | `ca` |
| AffordabilityUK | `affordabilityuk` | `uk` |
| AffordabilityUS | `affordabilityus` | `us` |
| HELOCApp | `heloc` | `us` |
| PropertyROI | `propertyroi` | `us` |
| SalaryApp | `salary` | `us` |
| StudentLoan | `studentloan` | `us` |
| LoanPayoffUS | `loanpayoff` | `us` |
| RentBuyUS | `rentbuy` | `us` |
| RefinanceApp | `refinance` | `us` |
| CreditCardAPR | `creditcard` | `us` |
| AutoLoan | `autoloan` | `multi` |

---

## Step 4: Update ad_config.dart (Per App)

After creating IDs, update `lib/config/ad_config.dart`:

```dart
static String get bannerAndroid => kReleaseMode
    ? 'ca-app-pub-5379540026739666/REAL_BANNER_ID'   // ← fill this
    : 'ca-app-pub-3940256099942544/6300978111';       // keep test ID

static String get interstitialAndroid => kReleaseMode
    ? 'ca-app-pub-5379540026739666/REAL_INTER_ID'    // ← fill this
    : 'ca-app-pub-3940256099942544/1033173712';

static String get rewardedAndroid => kReleaseMode
    ? 'ca-app-pub-5379540026739666/REAL_REWARD_ID'   // ← fill this
    : 'ca-app-pub-3940256099942544/5224354917';
```

---

## Step 5: Update AndroidManifest.xml (Per App)

```xml
<meta-data
    android:name="com.google.android.gms.ads.APPLICATION_ID"
    android:value="ca-app-pub-5379540026739666~REAL_APP_ID" />
```

> ⚠️ App ID (`~YYYY`) ≠ Ad Unit ID (`/ZZZZ`)

---

## Step 6: Link to Firebase (Optional)

Only if app uses Firebase Analytics:
1. Firebase Console → Project Settings → Integrations → AdMob
2. Link AdMob publisher account
3. Confirm publisher ID matches

---

## Test IDs (Use in Debug ONLY — Never Ship)

| Type | Android Test ID |
|------|----------------|
| Banner | `ca-app-pub-3940256099942544/6300978111` |
| Interstitial | `ca-app-pub-3940256099942544/1033173712` |
| Rewarded | `ca-app-pub-3940256099942544/5224354917` |

**NEVER ship test IDs to production!** All apps use `kReleaseMode` guard in `ad_config.dart`.

---

## Step 7: Verify on Real Device

1. `flutter build apk --release`
2. Install on physical device (NOT emulator)
3. Open app → wait 1-2 minutes for first ad
4. AdMob Console → Reports → Today → check impressions
5. Impressions visible within 24h of first real traffic

---

## Timeline

- **J+0:** Create units → 45-90 min activation delay
- **J+1:** First impressions visible in Reports
- **J+7:** eCPM stabilized, revenue estimates available
- **J+30:** First payment (if $100+ threshold reached)

---

## CalqWise Ad Rules (Mandatory)

- ❌ **Never App Open Ads** — kills retention
- ✅ **Banner** → permanent bottom of every calculator screen
- ✅ **Interstitial** → every 5 calculations, min 5-min cooldown
- ✅ **Rewarded** → optional, 60-min ad-free session
- ✅ **Premium ($2.99/$1.99/CA$3.99)** → disables ALL ads forever
- ✅ **Test IDs in `kDebugMode`** — always. Real IDs in release only.
