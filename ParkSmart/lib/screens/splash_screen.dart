import 'package:flutter/material.dart';
import 'package:calcwise_core/calcwise_core.dart';
import '../core/theme/app_theme.dart';
import 'map_screen.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) => CalcwiseSplash(
    appName:    'Park',
    appSuffix:  'Smart',
    tagline:    'Never overpay for parking again',
    chips:      ['Hourly Rates', 'Daily Cap', 'Comparisons'],
    badgeSymbol: 'P+',
    badgeIcon: Icons.local_parking_rounded,
    backgroundColor: AppTheme.primary,
    onComplete: () => Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const MapScreen()),
    ),
  );
}
