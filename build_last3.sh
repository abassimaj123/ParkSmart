#!/bin/bash
DEVICE="RFCX20661WW"
for app in LandlordCashFlow BRRRRCalc RentalExpenses; do
  echo "▶ $app"
  cd /d/mob/$app
  flutter build apk --debug 2>&1 | tail -4
  APK=$(find build/app/outputs -name "app-debug.apk" | head -1)
  [ -n "$APK" ] && adb -s $DEVICE install -r "$APK" 2>&1 | tail -2 || echo "Build failed"
done
echo "✅ Done"
