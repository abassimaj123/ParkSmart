#!/bin/bash
DEVICE="RFCX20661WW"
SUCCESS=()
FAILED=()

build_install() {
  local name=$1
  local dir=$2
  local extra=$3
  echo ""
  echo "▶ $name"
  cd "$dir" || { FAILED+=("$name"); return; }
  flutter build apk --debug $extra 2>&1 | tail -5
  if [ ${PIPESTATUS[0]} -ne 0 ]; then
    FAILED+=("$name"); return
  fi
  APK=$(find build/app/outputs/flutter-apk -name "*.apk" | head -1)
  if [ -z "$APK" ]; then APK="build/app/outputs/apk/debug/app-debug.apk"; fi
  adb -s $DEVICE install -r "$APK" 2>&1 | tail -2
  SUCCESS+=("$name")
}

build_install "HELOCApp"            "/d/mob/HELOCApp"
build_install "StudentLoan"         "/d/mob/StudentLoan"
build_install "RentalROI"           "/d/mob/RentalROI"
build_install "LandlordCashFlow"    "/d/mob/LandlordCashFlow"
build_install "HouseFlip"           "/d/mob/HouseFlip"
build_install "CapRate"             "/d/mob/CapRate"
build_install "BRRRRCalc"           "/d/mob/BRRRRCalc"
build_install "RentalExpenses"      "/d/mob/RentalExpenses"
build_install "MortgageExtraPayment" "/d/mob/MortgageExtraPayment"
build_install "SalaryApp-US"        "/d/mob/SalaryApp" "--flavor us --dart-define=FLAVOR=us"
build_install "SalaryApp-UK"        "/d/mob/SalaryApp" "--flavor uk --dart-define=FLAVOR=uk"
build_install "SalaryApp-CA"        "/d/mob/SalaryApp" "--flavor ca --dart-define=FLAVOR=ca"

echo ""
echo "========================================="
echo "✅ SUCCESS (${#SUCCESS[@]}): ${SUCCESS[*]}"
echo "❌ FAILED  (${#FAILED[@]}): ${FAILED[*]}"
echo "========================================="
