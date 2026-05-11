// ── App Configuration Template — Copy per app ─────────────────────────────
// Replace all values marked with ← for each new app.

class AppConfig {
  AppConfig._();

  // ── App metadata ──────────────────────────────────────────────────────────
  static const String appName    = 'My Calculator';          // ← change
  static const String packageId  = 'com.myapp.calculator';  // ← change
  static const String appVersion = '1.0.0';

  // ── AdMob IDs (fill after creating units in AdMob console) ───────────────
  // Publisher: ca-app-pub-5379540026739666
  static const String bannerAdUnitId       = 'ca-app-pub-5379540026739666/XXXXXXXXXX'; // ← fill
  static const String interstitialAdUnitId = 'ca-app-pub-5379540026739666/XXXXXXXXXX'; // ← fill
  static const String rewardedAdUnitId     = 'ca-app-pub-5379540026739666/XXXXXXXXXX'; // ← fill

  // ── IAP ───────────────────────────────────────────────────────────────────
  static const String iapProductId = 'premium_upgrade'; // same for all apps

  // ── Regional pricing (display only — Play Console sets actual price) ──────
  static const Map<String, String> regionalPricing = {
    'US': r'$2.99',
    'UK': '£1.99',
    'CA': r'CA$3.99',
    'AU': r'A$4.49',
  };

  // ── Feature flags ─────────────────────────────────────────────────────────
  static const bool enableAds      = true;
  static const bool enableIAP      = true;
  static const bool enableRewarded = true;

  // ── Ad trigger thresholds ─────────────────────────────────────────────────
  static const int calcThreshold   = 5;  // interstitial every N calcs
  static const int cooldownMinutes = 5;  // min between interstitials
  static const int rewardMinutes   = 60; // rewarded ad-free duration

  // ── Paywall triggers ──────────────────────────────────────────────────────
  static const int softPaywallSession = 2; // show soft paywall at session N
  static const int hardPaywallCalcs   = 5; // show hard paywall every N calcs

  // ── Links ─────────────────────────────────────────────────────────────────
  static const String privacyPolicyUrl = 'https://calqwise.com/privacy';
  static const String calqwiseUrl      = 'https://calqwise.com';
}
