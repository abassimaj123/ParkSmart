#!/bin/bash
echo "📲 Installing all APKs to device RFCX20661WW..."
echo ""

device="RFCX20661WW"
apks=()

# Collect all APKs
find . -path "*/build/app/outputs/apk/*/release/*.apk" -o \
       -path "*/build/app/outputs/bundle/*/release/app.apk" -o \
       -path "*/app/build/outputs/apk/release/*.apk" | while read apk; do
  if [ -f "$apk" ]; then
    echo "Found: $apk"
    adb -s "$device" install -r "$apk" 2>&1 | grep -E "Success|Failure|error"
  fi
done

echo ""
echo "✅ Installation complete!"
adb -s "$device" shell pm list packages | grep -E "affordability|autoloan|mortgage|rental|salary|tax|parksmart|rideprofit" | wc -l
echo "apps installed"
