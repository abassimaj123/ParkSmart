// ── main.dart Template — Copy per app ─────────────────────────────────────
// Replace MyApp, MyAppName, and screen imports.

import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'core/ads/ad_service.dart';
import 'core/freemium/freemium_service.dart';
import 'core/freemium/iap_service.dart';
import 'core/freemium/paywall_service.dart';
import 'core/theme/app_theme.dart';
import 'screens/calculator_screen.dart';
import 'screens/settings_screen.dart';

// Global language notifier — false = English, true = Spanish (or French for CA apps)
final ValueNotifier<bool> isSpanishNotifier = ValueNotifier<bool>(false);

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await freemiumService.initialize();
  await IAPService.instance.initialize();
  await paywallService.init();

  try {
    await MobileAds.instance.initialize();
    await AdService.instance.initialize();
  } catch (_) {}

  // Detect system locale
  final locale = PlatformDispatcher.instance.locales.first;
  isSpanishNotifier.value = locale.languageCode == 'es';

  // Respect saved preference
  final prefs = await SharedPreferences.getInstance();
  final savedLang = prefs.getString('language');
  if (savedLang != null) isSpanishNotifier.value = savedLang == 'es';

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  // Soft paywall trigger
  final showSoft = await paywallService.recordSession();

  runApp(MyApp(showSoftPaywallOnStart: showSoft));
}

class MyApp extends StatelessWidget {
  final bool showSoftPaywallOnStart;
  const MyApp({super.key, this.showSoftPaywallOnStart = false});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: isSpanishNotifier,
      builder: (_, __, ___) => MaterialApp(
        title: 'My App Name', // ← change
        theme: AppTheme.theme,
        debugShowCheckedModeBanner: false,
        home: MainShell(showSoftPaywallOnStart: showSoftPaywallOnStart),
      ),
    );
  }
}

class MainShell extends StatefulWidget {
  final bool showSoftPaywallOnStart;
  const MainShell({super.key, this.showSoftPaywallOnStart = false});
  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _index = 0;

  @override
  void initState() {
    super.initState();
    if (widget.showSoftPaywallOnStart) {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        await Future.delayed(const Duration(seconds: 2));
        if (mounted) {
          // import and call PaywallSoft.show(context);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _index,
        children: const [
          CalculatorScreen(),
          SettingsScreen(),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (i) => setState(() => _index = i),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.calculate_outlined),
            selectedIcon: Icon(Icons.calculate),
            label: 'Calculator',
          ),
          NavigationDestination(
            icon: Icon(Icons.settings_outlined),
            selectedIcon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}
