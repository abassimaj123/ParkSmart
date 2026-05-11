import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/foundation.dart';

/// Centralized Firebase Analytics wrapper for ParkSmart.
class AnalyticsService {
  AnalyticsService._();
  static final AnalyticsService instance = AnalyticsService._();

  final _fa = FirebaseAnalytics.instance;

  // ── Lifecycle ─────────────────────────────────────────────────────────────

  Future<void> logAppOpen() => _log('app_open');

  // ── Map & Navigation ──────────────────────────────────────────────────────

  Future<void> logMapLoaded()           => _log('map_loaded');
  Future<void> logSegmentTapped()       => _log('segment_tapped');
  Future<void> logSearchUsed()          => _log('search_used');
  Future<void> logLayerToggled(String layer) => _log('layer_toggled', {'layer': layer});

  // ── Session ───────────────────────────────────────────────────────────────

  Future<void> logParkingSessionStarted({int? maxMinutes}) =>
      _log('session_started', {
        if (maxMinutes != null) 'max_minutes': maxMinutes,
      });

  Future<void> logParkingSessionEnded({required int durationMinutes}) =>
      _log('session_ended', {'duration_minutes': durationMinutes});

  Future<void> logParkingCalculated({
    required String ruleType, // free | meter | restricted | amd | nettoyage
    required int    durationMinutes,
  }) =>
      _log('parking_calculated', {
        'rule_type':        ruleType,
        'duration_minutes': durationMinutes,
      });

  // ── Paywall ───────────────────────────────────────────────────────────────

  Future<void> logPaywallShown(String type) =>
      _log('paywall_shown', {'type': type}); // soft | hard

  Future<void> logPremiumShown()          => _log('premium_shown');
  Future<void> logPurchaseStarted()       => _log('purchase_started');
  Future<void> logPurchaseCompleted()     => _log('purchase_completed');
  Future<void> logPurchaseRestored()      => _log('purchase_restored');
  Future<void> logPurchaseFailed()        => _log('purchase_failed');
  Future<void> logPaywallDismissed()      => _log('paywall_dismissed');
  Future<void> logRewardedAdWatched()     => _log('rewarded_ad_watched');
  Future<void> logRewardedAdFailed()      => _log('rewarded_ad_failed');
  Future<void> logBannerFailed()          => _log('banner_ad_failed');

  // ── Features ─────────────────────────────────────────────────────────────

  Future<void> logPdfExported()           => _log('pdf_exported');
  Future<void> logShareUsed()             => _log('share_used');
  Future<void> logCrossPromoTapped(String dest) =>
      _log('cross_promo_tapped', {'destination': dest});

  // ── User property ─────────────────────────────────────────────────────────

  Future<void> setUserPremium(bool isPremium) =>
      _fa.setUserProperty(
          name: 'is_premium', value: isPremium ? 'true' : 'false');

  // ── Internals ─────────────────────────────────────────────────────────────

  Future<void> _log(String name, [Map<String, Object>? params]) async {
    final merged = <String, Object>{'app_name': 'ParkSmart', ...?params};
    if (kDebugMode) {
      debugPrint('[Analytics] $name $merged');
      return;
    }
    await _fa.logEvent(name: name, parameters: merged);
  }
}
