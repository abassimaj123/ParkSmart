#!/bin/bash
DEVICE="RFCX20661WW"
cd /d/mob/AutoLoan
echo "▶ AutoLoan CA"
flutter build apk --debug --flavor ca --dart-define=FLAVOR=ca 2>&1 | tail -5
adb -s $DEVICE install -r build/app/outputs/flutter-apk/app-ca-debug.apk 2>&1 | tail -2
echo "▶ AutoLoan UK"
flutter build apk --debug --flavor uk --dart-define=FLAVOR=uk 2>&1 | tail -5
adb -s $DEVICE install -r build/app/outputs/flutter-apk/app-uk-debug.apk 2>&1 | tail -2
echo "▶ AutoLoan US"
flutter build apk --debug --flavor us --dart-define=FLAVOR=us 2>&1 | tail -5
adb -s $DEVICE install -r build/app/outputs/flutter-apk/app-us-debug.apk 2>&1 | tail -2
echo "✅ AutoLoan done"
