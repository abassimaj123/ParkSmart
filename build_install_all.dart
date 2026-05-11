/// Build (debug APK) + install all 9 apps on connected device.
/// Run: dart D:/mob/build_install_all.dart
///
/// SalaryApp has 3 flavors → builds 3 separate APKs.
import 'dart:io';

const base = 'D:/mob';
const device = 'RFCX20661WW';

/// Single-app entry
class AppBuild {
  final String dir;
  final String? flavor;
  final String apkPath;
  AppBuild(this.dir, {this.flavor, required this.apkPath});
}

final builds = <AppBuild>[
  AppBuild('CreditCardAPR',  apkPath: 'build/app/outputs/flutter-apk/app-debug.apk'),
  AppBuild('PropertyROI',    apkPath: 'build/app/outputs/flutter-apk/app-debug.apk'),
  AppBuild('SalaryApp', flavor: 'us', apkPath: 'build/app/outputs/flutter-apk/app-us-debug.apk'),
  AppBuild('SalaryApp', flavor: 'uk', apkPath: 'build/app/outputs/flutter-apk/app-uk-debug.apk'),
  AppBuild('SalaryApp', flavor: 'ca', apkPath: 'build/app/outputs/flutter-apk/app-ca-debug.apk'),
  AppBuild('StudentLoan',    apkPath: 'build/app/outputs/flutter-apk/app-debug.apk'),
  AppBuild('HELOCApp',       apkPath: 'build/app/outputs/flutter-apk/app-debug.apk'),
  AppBuild('RefinanceApp',   apkPath: 'build/app/outputs/flutter-apk/app-debug.apk'),
  AppBuild('AffordabilityUK', apkPath: 'build/app/outputs/flutter-apk/app-debug.apk'),
  AppBuild('AffordabilityUS', apkPath: 'build/app/outputs/flutter-apk/app-debug.apk'),
  AppBuild('AffordabilityCA', apkPath: 'build/app/outputs/flutter-apk/app-debug.apk'),
];

Future<bool> run(String cmd, List<String> args, String workDir) async {
  print('  > $cmd ${args.join(' ')}');
  final result = await Process.run(cmd, args,
      workingDirectory: workDir.replaceAll('/', Platform.pathSeparator),
      runInShell: true);
  if (result.stdout.toString().isNotEmpty) print(result.stdout);
  if (result.stderr.toString().isNotEmpty) print(result.stderr);
  return result.exitCode == 0;
}

Future<void> main() async {
  // Check device
  final adb = await Process.run('adb', ['devices'], runInShell: true);
  if (!adb.stdout.toString().contains(device)) {
    print('ERROR: device $device not found. Connect device and retry.');
    exit(1);
  }
  print('✓ Device $device connected\n');

  // Track which dirs need pub get (deduplicate SalaryApp)
  final pubGetDirs = <String>{};
  for (final b in builds) pubGetDirs.add(b.dir);

  // Step 1: flutter pub get for all unique dirs
  print('=== Step 1: flutter pub get ===');
  for (final dir in pubGetDirs) {
    final appDir = '$base/$dir';
    print('\n[pub get] $dir');
    final ok = await run('flutter', ['pub', 'get'], appDir);
    if (!ok) { print('FAILED pub get: $dir'); exit(1); }
  }

  // Step 2: build APKs
  print('\n=== Step 2: flutter build apk ===');
  for (final b in builds) {
    final appDir = '$base/${b.dir}';
    final label = b.flavor != null ? '${b.dir} (${b.flavor})' : b.dir;
    print('\n[build] $label');
    final args = ['build', 'apk', '--debug'];
    if (b.flavor != null) args.addAll(['--flavor', b.flavor!, '--dart-define=FLAVOR=${b.flavor}']);
    final ok = await run('flutter', args, appDir);
    if (!ok) { print('FAILED build: $label'); exit(1); }
  }

  // Step 3: install on device
  print('\n=== Step 3: adb install ===');
  for (final b in builds) {
    final apk = '$base/${b.dir}/${b.apkPath}'.replaceAll('/', Platform.pathSeparator);
    final label = b.flavor != null ? '${b.dir} (${b.flavor})' : b.dir;
    if (!File(apk).existsSync()) {
      print('MISSING APK: $apk');
      continue;
    }
    print('\n[install] $label');
    final ok = await run('adb', ['-s', device, 'install', '-r', apk], base);
    if (!ok) print('WARN: install failed for $label (may already exist, continuing)');
  }

  print('\n✓ All done. Check device for installed apps.');
}
