import 'package:calcwise_core/calcwise_core.dart';

/// Firebase Analytics wrapper for ParkSmart.
/// Common events inherited from CalcwiseAnalytics.
/// ParkSmart-specific events (map, session, parking calc, cross promo) kept here.
class AnalyticsService extends CalcwiseAnalytics {
  AnalyticsService._() : super(appName: 'ParkSmart');
  static final AnalyticsService instance = AnalyticsService._();

  // ── Map & Navigation ──────────────────────────────────────────────────────

  Future<void> logMapLoaded() => log('map_loaded');
  Future<void> logSegmentTapped() => log('segment_tapped');
  Future<void> logSearchUsed() => log('search_used');
  Future<void> logLayerToggled(String layer) =>
      log('layer_toggled', {'layer': layer});

  // ── Session ───────────────────────────────────────────────────────────────

  Future<void> logParkingSessionStarted({int? maxMinutes}) =>
      log('session_started', {
        if (maxMinutes != null) 'max_minutes': maxMinutes,
      });

  Future<void> logParkingSessionEnded({required int durationMinutes}) =>
      log('session_ended', {'duration_minutes': durationMinutes});

  Future<void> logParkingCalculated({
    required String ruleType, // free | meter | restricted | amd | nettoyage
    required int durationMinutes,
  }) =>
      log('parking_calculated', {
        'rule_type': ruleType,
        'duration_minutes': durationMinutes,
      });

  // ── Paywall variants ──────────────────────────────────────────────────────

  Future<void> logPremiumShown() => log('premium_shown');

  // ── Features ─────────────────────────────────────────────────────────────

  Future<void> logShareUsed() => log('share_used');

  Future<void> logCrossPromoTapped(String dest) =>
      log('cross_promo_tapped', {'destination': dest});
}
