import 'dart:async';
import 'package:flutter/foundation.dart';
import '../models/parking_session.dart';
import '../models/street_segment.dart';
import '../models/parking_rule.dart';
import '../services/rule_engine.dart';

class SessionService extends ChangeNotifier {
  ParkingSession? _activeSession;
  Timer? _ticker;

  ParkingSession? get activeSession => _activeSession;
  bool get hasActiveSession => _activeSession != null;

  void startSession(StreetSegment segment, DateTime viewTime) {
    // Find maxMinutes from active meter or free rule
    final result = RuleEngine.evaluate(segment, viewTime);
    int? maxMins = result.activeRule?.maxMinutes;

    _activeSession = ParkingSession(
      segment: segment,
      startTime: DateTime.now(),
      maxMinutes: maxMins,
    );

    // Tick every 30 seconds to refresh UI
    _ticker?.cancel();
    _ticker = Timer.periodic(const Duration(seconds: 30), (_) {
      notifyListeners();
    });

    notifyListeners();
  }

  void endSession() {
    _activeSession = null;
    _ticker?.cancel();
    _ticker = null;
    notifyListeners();
  }

  @override
  void dispose() {
    _ticker?.cancel();
    super.dispose();
  }
}
