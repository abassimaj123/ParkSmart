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

void deployFromFile(String srcFile, String appPath) {
  final bytes = File(srcFile).readAsBytesSync();
  final src512 = img.decodeImage(bytes)!;
  for (final e in densities.entries) {
    final resized = img.copyResize(src512, width: e.value, height: e.value,
        interpolation: img.Interpolation.cubic);
    final dir = Directory('$appPath/android/app/src/main/res/${e.key}');
    dir.createSync(recursive: true);
    final out = img.encodePng(resized);
    File('${dir.path}/ic_launcher.png').writeAsBytesSync(out);
    File('${dir.path}/ic_launcher_round.png').writeAsBytesSync(out);
    print('  ✓ ${e.key} (${e.value}px)');
  }
}

void main() {
  final apps = {
    'MortgageCA': '$src/MortgageCA_512.png',
    'MortgageUS': '$src/MortgageUS_512.png',
    'MortgageUK': '$src/MortgageUK_512.png',
  };

  for (final entry in apps.entries) {
    print('\n>>> ${entry.key}');
    deployFromFile(entry.value, '$base/${entry.key}');
  }
  print('\n✅ Done — MortgageCA/US/UK icons replaced.');
}
