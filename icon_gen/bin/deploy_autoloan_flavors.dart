import 'dart:io';
import 'package:image/image.dart' as img;

const src = 'D:/test/voir/files';
const autoLoanBase = 'D:/mob/AutoLoan/android/app/src';

final densities = {
  'mipmap-mdpi':    48,
  'mipmap-hdpi':    72,
  'mipmap-xhdpi':   96,
  'mipmap-xxhdpi':  144,
  'mipmap-xxxhdpi': 192,
};

void deployFlavor(String srcFile, String flavorResPath) {
  final bytes = File(srcFile).readAsBytesSync();
  final src512 = img.decodeImage(bytes)!;
  for (final e in densities.entries) {
    final resized = img.copyResize(src512, width: e.value, height: e.value,
        interpolation: img.Interpolation.cubic);
    final dir = Directory('$flavorResPath/${e.key}');
    dir.createSync(recursive: true);
    final out = img.encodePng(resized);
    File('${dir.path}/ic_launcher.png').writeAsBytesSync(out);
    File('${dir.path}/ic_launcher_round.png').writeAsBytesSync(out);
    print('  ✓ ${e.key} (${e.value}px)');
  }
}

void main() {
  final flavors = {
    'ca': '$src/AutoLoan_CA_512.png',
    'uk': '$src/AutoLoan_UK_512.png',
    'us': '$src/AutoLoan_US_512.png',
  };

  for (final entry in flavors.entries) {
    print('\n>>> AutoLoan — flavor: ${entry.key.toUpperCase()}');
    deployFlavor(entry.value, '$autoLoanBase/${entry.key}/res');
  }
  print('\n✅ Done — AutoLoan CA/UK/US flavors iconified.');
}
