/// Freemium service — re-exports CalcwiseFreemium from library.
import 'package:calcwise_core/calcwise_core.dart';

final freemiumService = CalcwiseFreemium(
  appKey: 'parksmart',
  rewardedDurationMinutes: 60,
  maxRewardedPerDay: 2,  // ParkSmart uses 2 per day vs others use 3
  freeCalculationLimit: 5,
);
