import 'dart:ui';
import 'package:calcwise_core/calcwise_core.dart' show themeModeService;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'core/freemium/freemium_service.dart';
import 'core/ads/ad_service.dart';
import 'core/services/analytics_service.dart';
import 'core/language/language_notifier.dart';
import 'core/theme/app_theme.dart';
import 'screens/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };
  await MobileAds.instance.initialize();
  await AdService.instance.initialize();
  await freemiumService.initialize();
  await AnalyticsService.instance.logAppOpen();
  await themeModeService.initialize();

  // EN/ES: saved preference first, then system locale detection
  {
    final locales = PlatformDispatcher.instance.locales;
    final systemLang = locales.isNotEmpty ? locales.first.languageCode : 'en';
    final prefs = await SharedPreferences.getInstance();
    final savedLang = prefs.getString('language');
    isSpanishNotifier.value = (savedLang ?? systemLang) == 'es';
  }

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.light,
    systemNavigationBarColor: Color(0xFF0D0B1E),
    systemNavigationBarIconBrightness: Brightness.light,
  ));

  runApp(const JobOfferApp());
}

class JobOfferApp extends StatelessWidget {
  const JobOfferApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: isSpanishNotifier,
      builder: (_, isSpanish, __) => ValueListenableBuilder<ThemeMode>(
        valueListenable: themeModeService.notifier,
        builder: (_, themeMode, __) => MaterialApp(
          title: isSpanish ? 'Comparar Ofertas' : 'Job Offer US',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.theme,
          darkTheme: AppTheme.dark,
          themeMode: themeMode,
          home: const SplashScreen(),
        ),
      ),
    );
  }
}
