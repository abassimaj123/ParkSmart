#!/bin/bash
DEVICE="RFCX20661WW"
SUCCESS=(); FAILED=()

build_install() {
  local name=$1; local dir=$2; local extra=$3
  echo "▶ $name"
  cd "$dir" || { FAILED+=("$name"); return; }
  flutter build apk --debug $extra 2>&1 | tail -4
  local rc=${PIPESTATUS[0]}
  [ $rc -ne 0 ] && { FAILED+=("$name"); return; }
  APK=$(find build/app/outputs -name "app-debug.apk" -o -name "app-${extra##*--flavor }-debug.apk" 2>/dev/null | head -1)
  [ -z "$APK" ] && APK=$(find build/app/outputs -name "*.apk" | head -1)
  adb -s $DEVICE install -r "$APK" 2>&1 | tail -2
  SUCCESS+=("$name")
}

build_install "HELOCApp"     "/d/mob/HELOCApp"
build_install "AutoLoan-CA"  "/d/mob/AutoLoan" "--flavor ca --dart-define=FLAVOR=ca"
build_install "AutoLoan-UK"  "/d/mob/AutoLoan" "--flavor uk --dart-define=FLAVOR=uk"
build_install "AutoLoan-US"  "/d/mob/AutoLoan" "--flavor us --dart-define=FLAVOR=us"
build_install "rideprofit"   "/d/mob/rideprofit"

echo ""
echo "✅ (${#SUCCESS[@]}): ${SUCCESS[*]}"
echo "❌ (${#FAILED[@]}): ${FAILED[*]}"
