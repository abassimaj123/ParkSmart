import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/foundation.dart';

/// Firebase Analytics for JobOfferUS.
class AnalyticsService {
  AnalyticsService._();
  static final AnalyticsService instance = AnalyticsService._();

  final _fa = FirebaseAnalytics.instance;

  // ── Lifecycle ──────────────────────────────────────────────────────────

  Future<void> logAppOpen() => _log('app_open');

  // ── Calculator ─────────────────────────────────────────────────────────

  Future<void> logOfferComparison({
    required double salary1,
    required double salary2,
    required String location,
  }) => _log('offer_comparison', {
    'salary_bucket_1': _salaryBucket(salary1),
    'salary_bucket_2': _salaryBucket(salary2),
    'location': location,
  });

  Future<void> logOfferSaved() => _log('offer_saved');

  Future<void> logOfferExported() => _log('offer_exported');

  // ── Paywall ────────────────────────────────────────────────────────────

  Future<void> logPaywallShown(String type) =>
      _log('paywall_shown', {'type': type});

  Future<void> logPurchaseStarted() => _log('purchase_started');

  Future<void> logPurchaseCompleted() async {
    await _log('purchase_completed');
    await _fa.logEvent(name: 'purchase', parameters: {
      'currency': 'USD',
      'value': 4.99,
      'items': 'premium_jobofferus',
    });
  }

  Future<void> logPurchaseFailed(String error) =>
      _log('purchase_failed', {'error': error});

  Future<void> logPurchaseRestored() => _log('purchase_restored');

  Future<void> logRewardedAdWatched() => _log('rewarded_ad_watched');

  Future<void> logRewardedAdFailed() => _log('rewarded_ad_failed');

  Future<void> logRewardedDailyLimit() => _log('rewarded_daily_limit');

  // ── Settings ───────────────────────────────────────────────────────────

  Future<void> logLanguageChanged(String language) =>
      _log('language_changed', {'language': language});

  Future<void> logThemeChanged(String theme) =>
      _log('theme_changed', {'theme': theme});

  // ── Internal ───────────────────────────────────────────────────────────

  Future<void> _log(String event, [Map<String, Object>? params]) async {
    final p = <String, Object>{
      'app_name': 'JobOfferUS',
      ...?params,
    };
    if (kDebugMode) print('[Analytics] $event: $p');
    await _fa.logEvent(name: event, parameters: p);
  }

  String _salaryBucket(double salary) {
    if (salary < 50000) return '<50k';
    if (salary < 75000) return '50-75k';
    if (salary < 100000) return '75-100k';
    if (salary < 150000) return '100-150k';
    return '>150k';
  }
}
