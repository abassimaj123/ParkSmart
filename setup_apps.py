#!/usr/bin/env python3
"""
Setup boilerplate for 9 new Flutter apps.
Uses real Firebase project android-app-54282 — package names must match exactly.
"""
import os
import shutil

BASE = "D:/mob"
REF  = f"{BASE}/MortgageCA"
GOOGLE_SERVICES_SRC = f"{REF}/android/app/google-services.json"

# ── Firebase constants (shared project) ──────────────────────────────────────
FB_PROJECT     = "android-app-54282"
FB_NUMBER      = "385086392226"
FB_API_KEY     = "AIzaSyAVdM2OBORjb4fgCtWiqCwOJkkc5yhPRSY"
FB_BUCKET      = "android-app-54282.firebasestorage.app"

# ── App catalogue ─────────────────────────────────────────────────────────────
# pkg must match what is registered in google-services.json
APPS = [
    {
        "dir":            "CreditCardAPR",
        "pkg":            "com.creditcard.us.calculator",
        "firebase_id":    "1:385086392226:android:16e93649c7737a87a6d4fb",
        "dart_name":      "credit_card_apr",
        "color_hex":      "#1565C0",
        "color_dart":     "0xFF1565C0",
        "label":          "Credit Card APR Calculator",
        "tagline":        "Calculate APR & Interest",
        "premium_price":  "$2.99",
        "langs":          ["en", "es"],
    },
    {
        "dir":            "PropertyROI",
        "pkg":            "com.propertyroi.us.calculator",
        "firebase_id":    "1:385086392226:android:10bd8bd48776d8dda6d4fb",
        "dart_name":      "property_roi",
        "color_hex":      "#2E7D32",
        "color_dart":     "0xFF2E7D32",
        "label":          "Property ROI Calculator",
        "tagline":        "Analyze Real Estate Returns",
        "premium_price":  "$2.99",
        "langs":          ["en", "es"],
    },
    {
        "dir":            "SalaryApp",
        "pkg":            "com.salary.us.calculator",   # base/default flavor
        "firebase_id":    "1:385086392226:android:d4437b5c04dce5f1a6d4fb",
        "dart_name":      "salary_app",
        "color_hex":      "#E65100",
        "color_dart":     "0xFFE65100",
        "label":          "Salary Calculator",
        "tagline":        "Net Pay & Tax Estimator",
        "premium_price":  "$2.99",
        "langs":          ["en", "es", "fr"],
        "flavors": [
            {"id": "us", "pkg": "com.salary.us.calculator",
             "firebase_id": "1:385086392226:android:d4437b5c04dce5f1a6d4fb",
             "label": "Salary Calculator US"},
            {"id": "uk", "pkg": "com.salary.uk.calculator",
             "firebase_id": "1:385086392226:android:73809f040788c1a4a6d4fb",
             "label": "Salary Calculator UK"},
            {"id": "ca", "pkg": "com.salary.ca.calculator",
             "firebase_id": "1:385086392226:android:837bfb4b27a729b3a6d4fb",
             "label": "Salary Calculator CA"},
        ],
    },
    {
        "dir":            "StudentLoan",
        "pkg":            "com.studentloan.us.calculator",
        "firebase_id":    "1:385086392226:android:1ea6b97ef1af713fa6d4fb",
        "dart_name":      "student_loan",
        "color_hex":      "#4A148C",
        "color_dart":     "0xFF4A148C",
        "label":          "Student Loan Calculator",
        "tagline":        "Repayment & Payoff Planner",
        "premium_price":  "$2.99",
        "langs":          ["en", "es"],
    },
    {
        "dir":            "HELOCApp",
        "pkg":            "com.heloc.us.calculator",
        "firebase_id":    "1:385086392226:android:5653cef2050827e1a6d4fb",
        "dart_name":      "heloc_app",
        "color_hex":      "#00695C",
        "color_dart":     "0xFF00695C",
        "label":          "HELOC Calculator",
        "tagline":        "Home Equity Line of Credit",
        "premium_price":  "$2.99",
        "langs":          ["en", "es"],
    },
    {
        "dir":            "RefinanceApp",
        "pkg":            "com.refinance.us.calculator",
        "firebase_id":    "1:385086392226:android:277418ca605328eca6d4fb",
        "dart_name":      "refinance_app",
        "color_hex":      "#01579B",
        "color_dart":     "0xFF01579B",
        "label":          "Refinance Calculator",
        "tagline":        "Mortgage Savings & Breakeven",
        "premium_price":  "$2.99",
        "langs":          ["en", "es"],
    },
    {
        "dir":            "AffordabilityUK",
        "pkg":            "com.affordability.uk.calculator",
        "firebase_id":    "1:385086392226:android:558215fb5cec408ca6d4fb",
        "dart_name":      "affordability_uk",
        "color_hex":      "#0D47A1",
        "color_dart":     "0xFF0D47A1",
        "label":          "Affordability Calculator UK",
        "tagline":        "UK Property Affordability",
        "premium_price":  "£1.99",
        "langs":          ["en"],
    },
    {
        "dir":            "AffordabilityUS",
        "pkg":            "com.affordability.us.calculator",
        "firebase_id":    "1:385086392226:android:ab89bc3b87b218b9a6d4fb",
        "dart_name":      "affordability_us",
        "color_hex":      "#B71C1C",
        "color_dart":     "0xFFB71C1C",
        "label":          "Affordability Calculator US",
        "tagline":        "US Home Affordability",
        "premium_price":  "$2.99",
        "langs":          ["en", "es"],
    },
    {
        "dir":            "AffordabilityCA",
        "pkg":            "com.affordabilityca.calculator",
        # Not yet in google-services.json — add in Firebase Console
        "firebase_id":    None,
        "dart_name":      "affordability_ca",
        "color_hex":      "#C8102E",
        "color_dart":     "0xFFC8102E",
        "label":          "Affordability Calculator CA",
        "tagline":        "Canadian Home Affordability",
        "premium_price":  "$3.99",
        "langs":          ["en", "fr"],
    },
]


# ─────────────────────────────────────────────────────────────────────────────

def ensure_dirs(app_dir):
    for d in [
        "lib/config", "lib/core/ads", "lib/core/freemium",
        "lib/core/firebase", "lib/core/services", "lib/core/db",
        "lib/core/theme", "lib/screens", "lib/widgets", "lib/l10n",
        "assets/images", "assets/branding", "test",
    ]:
        os.makedirs(f"{app_dir}/{d}", exist_ok=True)


def write(path, content):
    os.makedirs(os.path.dirname(path), exist_ok=True)
    with open(path, "w", encoding="utf-8") as f:
        f.write(content)
    print(f"  WROTE {path}")


def copy_file(src, dst):
    if os.path.exists(src):
        os.makedirs(os.path.dirname(dst), exist_ok=True)
        shutil.copy2(src, dst)
        print(f"  COPIED {dst}")
    else:
        print(f"  MISSING {src}")


# ─────────────────────────────────────────────────────────────────────────────
# pubspec.yaml
# ─────────────────────────────────────────────────────────────────────────────

def write_pubspec(app):
    d, name, label, color = app["dir"], app["dart_name"], app["label"], app["color_hex"]
    write(f"{BASE}/{d}/pubspec.yaml", f'''name: {name}
description: {label}
publish_to: 'none'
version: 1.0.0+1

environment:
  sdk: '>=3.0.0 <4.0.0'

dependencies:
  flutter:
    sdk: flutter
  intl: ^0.19.0
  fl_chart: ^0.68.0
  google_mobile_ads: ^5.1.0
  shared_preferences: ^2.2.3
  in_app_purchase: ^3.2.0
  sqflite: ^2.3.3
  path: ^1.9.0
  pdf: ^3.11.1
  printing: ^5.13.1
  collection: ^1.18.0
  firebase_core: ^3.6.0
  firebase_analytics: ^11.3.3
  firebase_crashlytics: ^4.1.3
  url_launcher: ^6.3.0

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^3.0.0
  flutter_launcher_icons: ^0.14.3
  flutter_native_splash: ^2.4.3

flutter_launcher_icons:
  android: true
  ios: false
  image_path: "assets/branding/icon_1024.png"
  min_sdk_android: 21

flutter_native_splash:
  color: "{color}"
  android_12:
    color: "{color}"
    icon_background_color: "{color}"
  android: true
  ios: false

flutter:
  uses-material-design: true
  assets:
    - assets/images/
    - assets/branding/
''')


# ─────────────────────────────────────────────────────────────────────────────
# Android
# ─────────────────────────────────────────────────────────────────────────────

def write_android_build(app):
    d, pkg = app["dir"], app["pkg"]
    flavors = app.get("flavors")
    flavor_block = ""
    if flavors:
        flavor_block = "\n    flavorDimensions += \"market\"\n    productFlavors {\n"
        for f in flavors:
            flavor_block += f'        create("{f["id"]}") {{\n'
            flavor_block += f'            dimension = "market"\n'
            flavor_block += f'            applicationId = "{f["pkg"]}"\n'
            flavor_block += f'        }}\n'
        flavor_block += "    }\n"

    write(f"{BASE}/{d}/android/app/build.gradle.kts", f'''import java.util.Properties

plugins {{
    id("com.android.application")
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
    id("com.google.gms.google-services")
    id("com.google.firebase.crashlytics")
}}

android {{
    namespace = "{pkg}"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {{
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }}

    kotlinOptions {{
        jvmTarget = JavaVersion.VERSION_17.toString()
    }}

    val keystoreProperties = Properties()
    val keystoreFile = rootProject.file("key.properties")
    if (keystoreFile.exists()) keystoreProperties.load(keystoreFile.inputStream())

    signingConfigs {{
        create("release") {{
            keyAlias      = keystoreProperties["keyAlias"]      as String
            keyPassword   = keystoreProperties["keyPassword"]   as String
            storeFile     = file(keystoreProperties["storeFile"] as String)
            storePassword = keystoreProperties["storePassword"] as String
        }}
    }}

    defaultConfig {{
        applicationId = "{pkg}"
        minSdk = flutter.minSdkVersion
        targetSdk = 34
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }}
{flavor_block}
    buildTypes {{
        debug {{
            signingConfig = signingConfigs.getByName("debug")
        }}
        release {{
            signingConfig = signingConfigs.getByName("release")
            isMinifyEnabled = true
            isShrinkResources = true
            proguardFiles(
                getDefaultProguardFile("proguard-android-optimize.txt"),
                "proguard-rules.pro"
            )
        }}
    }}
}}

flutter {{
    source = "../.."
}}
''')


def write_android_manifest(app):
    d, label = app["dir"], app["label"]
    write(f"{BASE}/{d}/android/app/src/main/AndroidManifest.xml", f'''<manifest xmlns:android="http://schemas.android.com/apk/res/android">
    <uses-permission android:name="android.permission.INTERNET"/>
    <uses-permission android:name="com.android.vending.BILLING"/>
    <application
        android:label="{label}"
        android:name="${{applicationName}}"
        android:icon="@mipmap/ic_launcher">
        <activity
            android:name=".MainActivity"
            android:exported="true"
            android:launchMode="singleTop"
            android:taskAffinity=""
            android:theme="@style/LaunchTheme"
            android:configChanges="orientation|keyboardHidden|keyboard|screenSize|smallestScreenSize|locale|layoutDirection|fontScale|screenLayout|density|uiMode"
            android:hardwareAccelerated="true"
            android:windowSoftInputMode="adjustResize">
            <meta-data
              android:name="io.flutter.embedding.android.NormalTheme"
              android:resource="@style/NormalTheme"/>
            <intent-filter>
                <action android:name="android.intent.action.MAIN"/>
                <category android:name="android.intent.category.LAUNCHER"/>
            </intent-filter>
        </activity>
        <!-- AdMob App ID — TEST. Replace ca-app-pub-3940256099942544~3347511713 with real ID -->
        <meta-data
            android:name="com.google.android.gms.ads.APPLICATION_ID"
            android:value="ca-app-pub-3940256099942544~3347511713"/>
        <meta-data
            android:name="com.google.android.gms.ads.DELAY_APP_MEASUREMENT_INIT"
            android:value="true"/>
        <meta-data android:name="flutterEmbedding" android:value="2"/>
    </application>
    <queries>
        <intent>
            <action android:name="android.intent.action.PROCESS_TEXT"/>
            <data android:mimeType="text/plain"/>
        </intent>
    </queries>
</manifest>
''')


# ─────────────────────────────────────────────────────────────────────────────
# Firebase
# ─────────────────────────────────────────────────────────────────────────────

def write_firebase_options(app):
    d     = app["dir"]
    fid   = app["firebase_id"]
    pkg   = app["pkg"]

    if fid is None:
        # AffordabilityCA — needs to be registered in Firebase Console first
        write(f"{BASE}/{d}/lib/core/firebase/firebase_options.dart", f'''// TODO: Register {pkg} in Firebase Console (project android-app-54282)
// then replace this placeholder with the generated file.
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart' show defaultTargetPlatform, TargetPlatform;

class DefaultFirebaseOptions {{
  static FirebaseOptions get currentPlatform {{
    if (defaultTargetPlatform == TargetPlatform.android) return android;
    throw UnsupportedError('Unsupported platform');
  }}
  static const FirebaseOptions android = FirebaseOptions(
    apiKey: '{FB_API_KEY}',
    appId: '1:{FB_NUMBER}:android:PLACEHOLDER_ADD_{d.upper()}_TO_FIREBASE',
    messagingSenderId: '{FB_NUMBER}',
    projectId: '{FB_PROJECT}',
    storageBucket: '{FB_BUCKET}',
  );
}}
''')
        return

    write(f"{BASE}/{d}/lib/core/firebase/firebase_options.dart", f'''// Auto-generated from google-services.json — project {FB_PROJECT}
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart' show defaultTargetPlatform, TargetPlatform;

class DefaultFirebaseOptions {{
  static FirebaseOptions get currentPlatform {{
    if (defaultTargetPlatform == TargetPlatform.android) return android;
    throw UnsupportedError('Unsupported platform');
  }}
  static const FirebaseOptions android = FirebaseOptions(
    apiKey: '{FB_API_KEY}',
    appId: '{fid}',
    messagingSenderId: '{FB_NUMBER}',
    projectId: '{FB_PROJECT}',
    storageBucket: '{FB_BUCKET}',
  );
}}
''')


def copy_google_services(app):
    d = app["dir"]
    dst = f"{BASE}/{d}/android/app/google-services.json"
    if app["firebase_id"] is not None:
        copy_file(GOOGLE_SERVICES_SRC, dst)
    else:
        print(f"  SKIP google-services.json for {d} (not registered yet)")


# ─────────────────────────────────────────────────────────────────────────────
# AdMob config
# ─────────────────────────────────────────────────────────────────────────────

def write_ad_config(app):
    write(f"{BASE}/{app['dir']}/lib/config/ad_config.dart", '''// AdMob — publisher ca-app-pub-5379540026739666
// BEFORE RELEASE: replace XXXXXXXXXX with real unit IDs from AdMob console.
import 'package:flutter/foundation.dart';

class AdConfig {
  AdConfig._();
  static const bool adsEnabled = true;
  static const int calcThreshold  = 5;   // interstitial every N calcs
  static const int cooldownMinutes = 5;  // min gap between interstitials

  static String get bannerAndroid => kReleaseMode
      ? 'ca-app-pub-5379540026739666/XXXXXXXXXX'
      : 'ca-app-pub-3940256099942544/6300978111';
  static String get interstitialAndroid => kReleaseMode
      ? 'ca-app-pub-5379540026739666/XXXXXXXXXX'
      : 'ca-app-pub-3940256099942544/1033173712';
  static String get rewardedAndroid => kReleaseMode
      ? 'ca-app-pub-5379540026739666/XXXXXXXXXX'
      : 'ca-app-pub-3940256099942544/5224354917';
}
''')


# ─────────────────────────────────────────────────────────────────────────────
# Theme
# ─────────────────────────────────────────────────────────────────────────────

def write_theme(app):
    c = app["color_dart"]
    write(f"{BASE}/{app['dir']}/lib/core/theme/app_theme.dart", f'''import 'package:flutter/material.dart';

class AppTheme {{
  static const primary    = Color({c});
  static const background = Color(0xFFF8FAFC);
  static const cardWhite  = Colors.white;
  static const success    = Color(0xFF34C759);
  static const warning    = Color(0xFFFFA500);
  static const labelGray  = Color(0xFF64748B);
  static const divider    = Color(0xFFE2E8F0);

  static ThemeData get theme => ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: primary),
        scaffoldBackgroundColor: background,
        cardTheme: CardThemeData(
          elevation: 0,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16)),
          color: cardWhite,
          surfaceTintColor: Colors.transparent,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: primary,
          foregroundColor: Colors.white,
          elevation: 0,
          centerTitle: false,
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: const Color(0xFFF1F5F9),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: primary, width: 2),
          ),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: primary,
            foregroundColor: Colors.white,
            minimumSize: const Size(double.infinity, 52),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14)),
            elevation: 0,
          ),
        ),
        textTheme: const TextTheme(
          titleLarge: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
          titleMedium: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          bodyLarge: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          bodyMedium: TextStyle(fontSize: 14, color: labelGray),
        ),
        navigationBarTheme: NavigationBarThemeData(
          backgroundColor: cardWhite,
          indicatorColor: primary.withValues(alpha: 0.12),
          labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        ),
      );

  static LinearGradient get primaryGradient => LinearGradient(
    colors: [primary, Color.lerp(primary, Colors.black, 0.15)!],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}}
''')


# ─────────────────────────────────────────────────────────────────────────────
# Splash screen
# ─────────────────────────────────────────────────────────────────────────────

def write_splash(app):
    c, label, tagline = app["color_dart"], app["label"], app["tagline"]
    write(f"{BASE}/{app['dir']}/lib/screens/splash_screen.dart", f'''import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SplashScreen extends StatefulWidget {{
  const SplashScreen({{super.key}});
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {{
  static const _bg = Color({c});
  late AnimationController _ctrl;
  late Animation<double> _scaleAnim;

  @override
  void initState() {{
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: _bg,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: _bg,
    ));
    _ctrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 800))
      ..forward();
    _scaleAnim = CurvedAnimation(parent: _ctrl, curve: Curves.elasticOut);
    Future.delayed(const Duration(milliseconds: 1500), () {{
      if (mounted) Navigator.of(context).pushReplacementNamed('/home');
    }});
  }}

  @override
  void dispose() {{
    _ctrl.dispose();
    super.dispose();
  }}

  @override
  Widget build(BuildContext context) {{
    return Scaffold(
      backgroundColor: _bg,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ScaleTransition(
              scale: _scaleAnim,
              child: Container(
                width: 110,
                height: 110,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(28),
                ),
                child: const Icon(Icons.calculate_outlined,
                    size: 62, color: Colors.white),
              ),
            ),
            const SizedBox(height: 32),
            const Text('{label}',
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.3)),
            const SizedBox(height: 8),
            Text('{tagline}',
                style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.75), fontSize: 14)),
            const SizedBox(height: 56),
            const _Dots(),
          ],
        ),
      ),
    );
  }}
}}

class _Dots extends StatefulWidget {{
  const _Dots();
  @override
  State<_Dots> createState() => _DotsState();
}}

class _DotsState extends State<_Dots> with SingleTickerProviderStateMixin {{
  late AnimationController _c;
  @override
  void initState() {{
    super.initState();
    _c = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1200))
      ..repeat();
  }}
  @override
  void dispose() {{ _c.dispose(); super.dispose(); }}
  @override
  Widget build(BuildContext context) {{
    return AnimatedBuilder(
      animation: _c,
      builder: (_, __) => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(3, (i) {{
          final t = (_c.value - i * 0.15) % 1.0;
          final op = (t < 0.5 ? t * 2 : (1 - t) * 2).clamp(0.3, 1.0);
          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 4),
            width: 7, height: 7,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: op),
              shape: BoxShape.circle,
            ),
          );
        }}),
      ),
    );
  }}
}}
''')


# ─────────────────────────────────────────────────────────────────────────────
# Widgets
# ─────────────────────────────────────────────────────────────────────────────

def write_banner_widget(app):
    write(f"{BASE}/{app['dir']}/lib/widgets/banner_ad_widget.dart", '''import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../config/ad_config.dart';
import '../core/freemium/freemium_service.dart';

class BannerAdWidget extends StatefulWidget {
  const BannerAdWidget({super.key});
  @override
  State<BannerAdWidget> createState() => _BannerAdWidgetState();
}

class _BannerAdWidgetState extends State<BannerAdWidget> {
  BannerAd? _ad;
  bool _loaded = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  void _load() {
    _ad = BannerAd(
      adUnitId: AdConfig.bannerAndroid,
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (_) => setState(() => _loaded = true),
        onAdFailedToLoad: (_, __) { _ad?.dispose(); _ad = null; },
      ),
    )..load();
  }

  @override
  void dispose() { _ad?.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    if (!AdConfig.adsEnabled) return const SizedBox.shrink();
    return ValueListenableBuilder<bool>(
      valueListenable: freemiumService.isPremiumNotifier,
      builder: (_, isPremium, __) {
        if (isPremium) return const SizedBox.shrink();
        return ValueListenableBuilder<bool>(
          valueListenable: freemiumService.isRewardedNotifier,
          builder: (_, isRewarded, __) {
            if (isRewarded) return const SizedBox.shrink();
            if (!_loaded || _ad == null) return const SizedBox(height: 50);
            return SizedBox(
              width: _ad!.size.width.toDouble(),
              height: _ad!.size.height.toDouble(),
              child: AdWidget(ad: _ad!),
            );
          },
        );
      },
    );
  }
}
''')


def write_premium_cta(app):
    price = app["premium_price"]
    write(f"{BASE}/{app['dir']}/lib/widgets/premium_cta_widget.dart", f'''import 'package:flutter/material.dart';
import '../core/freemium/iap_service.dart';
import '../core/theme/app_theme.dart';

class PremiumCtaWidget extends StatelessWidget {{
  final String feature;
  final bool compact;
  const PremiumCtaWidget({{super.key, required this.feature, this.compact = false}});

  @override
  Widget build(BuildContext context) {{
    return Container(
      margin: EdgeInsets.all(compact ? 8 : 16),
      decoration: BoxDecoration(
        gradient: AppTheme.primaryGradient,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primary.withValues(alpha: 0.25),
            blurRadius: 12, offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => IAPService.instance.buy(),
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: EdgeInsets.all(compact ? 14 : 20),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.star_rounded, color: Colors.white, size: 26),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Unlock $feature',
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.bold)),
                      const SizedBox(height: 2),
                      const Text('No ads · Unlimited · PDF export',
                          style: TextStyle(color: Colors.white70, fontSize: 12)),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text('{price}',
                      style: TextStyle(
                          color: AppTheme.primary,
                          fontWeight: FontWeight.bold,
                          fontSize: 13)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }}
}}
''')


def write_result_card(app):
    """A reusable result/metric card widget."""
    c = app["color_dart"]
    write(f"{BASE}/{app['dir']}/lib/widgets/result_card.dart", f'''import 'package:flutter/material.dart';
import '../core/theme/app_theme.dart';

class ResultCard extends StatelessWidget {{
  final String label;
  final String value;
  final String? subtitle;
  final IconData? icon;
  final bool highlight;

  const ResultCard({{
    super.key,
    required this.label,
    required this.value,
    this.subtitle,
    this.icon,
    this.highlight = false,
  }});

  @override
  Widget build(BuildContext context) {{
    if (highlight) {{
      return Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: AppTheme.primaryGradient,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: AppTheme.primary.withValues(alpha: 0.2),
              blurRadius: 10, offset: const Offset(0, 4),
            ),
          ],
        ),
        child: _content(Colors.white, Colors.white70),
      );
    }}
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: _content(Theme.of(context).textTheme.titleLarge!.color!, AppTheme.labelGray),
      ),
    );
  }}

  Widget _content(Color primary, Color secondary) {{
    return Row(
      children: [
        if (icon != null) ...[
          Icon(icon, color: primary.withValues(alpha: 0.8), size: 22),
          const SizedBox(width: 12),
        ],
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: TextStyle(color: secondary, fontSize: 12, fontWeight: FontWeight.w500)),
              const SizedBox(height: 2),
              Text(value, style: TextStyle(color: primary, fontSize: 22, fontWeight: FontWeight.bold)),
              if (subtitle != null)
                Text(subtitle!, style: TextStyle(color: secondary, fontSize: 12)),
            ],
          ),
        ),
      ],
    );
  }}
}}


class MetricRow extends StatelessWidget {{
  final String label;
  final String value;
  final Color? valueColor;

  const MetricRow({{super.key, required this.label, required this.value, this.valueColor}});

  @override
  Widget build(BuildContext context) {{
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: AppTheme.labelGray, fontSize: 14)),
          Text(value,
              style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                  color: valueColor ?? Theme.of(context).textTheme.bodyLarge!.color)),
        ],
      ),
    );
  }}
}}
''')


# ─────────────────────────────────────────────────────────────────────────────
# Localization strings
# ─────────────────────────────────────────────────────────────────────────────

def write_strings_en(app):
    label = app["label"]
    write(f"{BASE}/{app['dir']}/lib/l10n/strings_en.dart", f'''class AppStringsEN {{
  static const appName         = '{label}';
  static const calculator      = 'Calculator';
  static const history         = 'History';
  static const settings        = 'Settings';
  static const calculate       = 'Calculate';
  static const reset           = 'Reset';
  static const results         = 'Results';
  static const comparison      = 'Comparison';
  static const premium         = 'Premium';
  static const getPremium      = 'Get Premium';
  static const restorePurchase = 'Restore Purchase';
  static const privacyPolicy   = 'Privacy Policy';
  static const contactSupport  = 'Contact Support';
  static const discover        = 'Discover';
  static const historyEmpty    = 'No history yet. Run a calculation!';
  static const historyLimit    = 'Free limit (3). Upgrade for unlimited.';
  static const exportPdf       = 'Export PDF';
  static const exportLocked    = 'PDF export requires Premium.';
  static const adFree60        = 'Ad-free for 60 min';
  static const watchAd         = 'Watch Ad';
  static const premiumActive   = 'Premium Active';
  static const premiumDesc     = 'Unlimited · No ads · PDF export';
  static const calqwise        = 'Financial Calculators Suite';
}}
''')


def write_strings_es(app):
    label = app["label"]
    write(f"{BASE}/{app['dir']}/lib/l10n/strings_es.dart", f'''class AppStringsES {{
  static const appName         = '{label}';
  static const calculator      = 'Calculadora';
  static const history         = 'Historial';
  static const settings        = 'Configuración';
  static const calculate       = 'Calcular';
  static const reset           = 'Restablecer';
  static const results         = 'Resultados';
  static const comparison      = 'Comparación';
  static const premium         = 'Premium';
  static const getPremium      = 'Obtener Premium';
  static const restorePurchase = 'Restaurar Compra';
  static const privacyPolicy   = 'Política de Privacidad';
  static const contactSupport  = 'Contactar Soporte';
  static const discover        = 'Descubrir';
  static const historyEmpty    = 'Sin historial. ¡Haz un cálculo!';
  static const historyLimit    = 'Límite gratuito (3). Actualiza para más.';
  static const exportPdf       = 'Exportar PDF';
  static const exportLocked    = 'Exportar PDF requiere Premium.';
  static const adFree60        = 'Sin anuncios 60 min';
  static const watchAd         = 'Ver anuncio';
  static const premiumActive   = 'Premium Activo';
  static const premiumDesc     = 'Ilimitado · Sin anuncios · PDF';
  static const calqwise        = 'Suite de Calculadoras Financieras';
}}
''')


def write_strings_fr(app):
    label = app["label"]
    write(f"{BASE}/{app['dir']}/lib/l10n/strings_fr.dart", f'''class AppStringsFR {{
  static const appName         = '{label}';
  static const calculator      = 'Calculateur';
  static const history         = 'Historique';
  static const settings        = 'Paramètres';
  static const calculate       = 'Calculer';
  static const reset           = 'Réinitialiser';
  static const results         = 'Résultats';
  static const comparison      = 'Comparaison';
  static const premium         = 'Premium';
  static const getPremium      = 'Obtenir Premium';
  static const restorePurchase = "Restaurer l'achat";
  static const privacyPolicy   = 'Confidentialité';
  static const contactSupport  = 'Contacter le support';
  static const discover        = 'Découvrir';
  static const historyEmpty    = 'Aucun historique. Lancez un calcul !';
  static const historyLimit    = 'Limite gratuite (3). Passez à Premium.';
  static const exportPdf       = 'Exporter PDF';
  static const exportLocked    = "L'export PDF requiert Premium.";
  static const adFree60        = 'Sans pub 60 min';
  static const watchAd         = 'Voir une pub';
  static const premiumActive   = 'Premium Actif';
  static const premiumDesc     = 'Illimité · Sans pub · PDF';
  static const calqwise        = 'Suite de Calculatrices Financières';
}}
''')


# ─────────────────────────────────────────────────────────────────────────────
# Core services (copied verbatim from MortgageCA)
# ─────────────────────────────────────────────────────────────────────────────

CORE_COPIES = [
    "lib/core/ads/ad_service.dart",
    "lib/core/freemium/freemium_service.dart",
    "lib/core/freemium/iap_service.dart",
    "lib/core/services/crashlytics_service.dart",
]


def setup_app(app):
    d = app["dir"]
    app_dir = f"{BASE}/{d}"
    print(f"\n{'='*60}\n  {d}\n{'='*60}")
    ensure_dirs(app_dir)
    write_pubspec(app)
    write_android_build(app)
    write_android_manifest(app)
    write_ad_config(app)
    write_firebase_options(app)
    copy_google_services(app)
    write_theme(app)
    write_splash(app)
    write_banner_widget(app)
    write_premium_cta(app)
    write_result_card(app)
    for rel in CORE_COPIES:
        copy_file(f"{REF}/{rel}", f"{app_dir}/{rel}")
    # Localization
    write_strings_en(app)
    langs = app.get("langs", ["en"])
    if "es" in langs: write_strings_es(app)
    if "fr" in langs: write_strings_fr(app)
    print(f"  ✓ boilerplate done")


if __name__ == "__main__":
    print("Setting up 9 Flutter apps …")
    for app in APPS:
        setup_app(app)
    print("\n✓  All boilerplate written.")
    print("   Next: agents write app-specific engines + screens.")
    print()
    print("   AffordabilityCA NOTE:")
    print("   → Register com.affordabilityca.calculator in Firebase Console")
    print("     (project android-app-54282) then update firebase_options.dart")
