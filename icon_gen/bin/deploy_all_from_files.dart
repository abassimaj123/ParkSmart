import 'dart:io';
import 'package:image/image.dart' as img;

const src = 'D:/test/voir/files';
const base = 'D:/mob';

final densities = {
  'mipmap-mdpi':    48,
  'mipmap-hdpi':    72,
  'mipmap-xhdpi':   96,
  'mipmap-xxhdpi':  144,
  'mipmap-xxxhdpi': 192,
};

// Resize + write to Flutter app path (android/app/src/main/res/)
void deployFlutter(String srcFile, String appPath) {
  final bytes = File('$src/$srcFile').readAsBytesSync();
  final src512 = img.decodeImage(bytes)!;
  for (final e in densities.entries) {
    final resized = img.copyResize(src512, width: e.value, height: e.value,
        interpolation: img.Interpolation.cubic);
    final dir = Directory('$base/$appPath/android/app/src/main/res/${e.key}');
    dir.createSync(recursive: true);
    final out = img.encodePng(resized);
    File('${dir.path}/ic_launcher.png').writeAsBytesSync(out);
    File('${dir.path}/ic_launcher_round.png').writeAsBytesSync(out);
  }
  print('  ✓ $appPath');
}

// Resize + write to Flutter app flavor path (android/app/src/<flavor>/res/)
void deployFlavor(String srcFile, String appPath, String flavor) {
  final bytes = File('$src/$srcFile').readAsBytesSync();
  final src512 = img.decodeImage(bytes)!;
  for (final e in densities.entries) {
    final resized = img.copyResize(src512, width: e.value, height: e.value,
        interpolation: img.Interpolation.cubic);
    final dir = Directory('$base/$appPath/android/app/src/$flavor/res/${e.key}');
    dir.createSync(recursive: true);
    final out = img.encodePng(resized);
    File('${dir.path}/ic_launcher.png').writeAsBytesSync(out);
    File('${dir.path}/ic_launcher_round.png').writeAsBytesSync(out);
  }
  print('  ✓ $appPath [$flavor]');
}

// Resize + write to native Android app path (app/src/main/res/)
void deployNative(String srcFile, String appPath) {
  final bytes = File('$src/$srcFile').readAsBytesSync();
  final src512 = img.decodeImage(bytes)!;
  for (final e in densities.entries) {
    final resized = img.copyResize(src512, width: e.value, height: e.value,
        interpolation: img.Interpolation.cubic);
    final dir = Directory('$base/$appPath/app/src/main/res/${e.key}');
    dir.createSync(recursive: true);
    final out = img.encodePng(resized);
    File('${dir.path}/ic_launcher.png').writeAsBytesSync(out);
    File('${dir.path}/ic_launcher_round.png').writeAsBytesSync(out);
  }
  print('  ✓ $appPath (native)');
}

void main() {
  print('==============================');
  print(' Deploy ALL icons from files');
  print('==============================\n');

  // ── Mortgage ──
  deployFlutter('MortgageUS_512.png',            'MortgageUS');
  deployFlutter('MortgageUK_512.png',            'MortgageUK');
  deployFlutter('MortgageCA_512.png',            'MortgageCA');
  deployFlutter('MortgageExtra_Payment_512.png', 'MortgageExtraPayment');

  // ── AutoLoan (3 flavors) ──
  deployFlavor('AutoLoan_CA_512.png', 'AutoLoan', 'ca');
  deployFlavor('AutoLoan_UK_512.png', 'AutoLoan', 'uk');
  deployFlavor('AutoLoan_US_512.png', 'AutoLoan', 'us');

  // ── Affordability (même icône pour les 3 marchés) ──
  deployFlutter('Affordability_US_512.png', 'AffordabilityUS');
  deployFlutter('Affordability_US_512.png', 'AffordabilityCA');
  deployFlutter('Affordability_US_512.png', 'AffordabilityUK');

  // ── Salary (CA / UK / US) ──
  deployFlutter('SalaryUS_512.png', 'SalaryApp');

  // ── Real estate ──
  deployFlutter('RentVsBuy_US_512.png',          'RentBuyUS');
  deployFlutter('LoanPayoff_US_512.png',          'LoanPayoffUS');
  deployFlutter('Refinance_US_512.png',           'RefinanceApp');
  deployFlutter('HELOC_US_512.png',               'HELOCApp');
  deployFlutter('PropertyROI_512.png',            'PropertyROI');
  deployFlutter('RentalProperty_ROI_512.png',     'RentalROI');
  deployFlutter('Landlord_CashFlow_512.png',      'LandlordCashFlow');
  deployFlutter('HouseFlip_Calculator_512.png',   'HouseFlip');
  deployFlutter('CapRate_Calculator_512.png',     'CapRate');
  deployFlutter('BRRRR_Calculator_512.png',       'BRRRRCalc');
  deployFlutter('RentalExpenses_Tracker_512.png', 'RentalExpenses');

  // ── Other ──
  deployFlutter('StudentLoan_US_512.png', 'StudentLoan');
  deployFlutter('CreditCard_APR_512.png', 'CreditCardAPR');
  deployFlutter('RideProfit_512.png',     'rideprofit');

  // ── Native Android ──
  deployNative('TaxUS_512.png', 'TaxUS');

  print('\n==============================');
  print(' ✅ Done!');
  print('\n⚠️  SalaryCA_512.png → ?');
  print('⚠️  SalaryUK_512.png → ?');
  print('⚠️  TaxAU   → pas de fichier dédié');
  print('⚠️  TaxeUK  → pas de fichier dédié');
  print('==============================');
}
