#!/bin/bash
SUCCESS=()
FAILED=()

build_apk() {
  local name=$1
  local dir=$2
  local extra=$3
  echo ""
  echo "▶ Building: $name"
  cd "$dir" || { FAILED+=("$name"); return; }
  flutter build apk --debug $extra 2>&1 | tail -5
  if [ ${PIPESTATUS[0]} -ne 0 ]; then
    echo "  ❌ Build failed"
    FAILED+=("$name")
  else
    SUCCESS+=("$name")
  fi
}

# Clean first to fix any cache issues
echo "Cleaning HELOCApp..."
flutter clean 2>&1 | tail -1

build_apk "HELOCApp"            "/d/mob/HELOCApp"
build_apk "RentalROI"           "/d/mob/RentalROI"
build_apk "LandlordCashFlow"    "/d/mob/LandlordCashFlow"
build_apk "CapRate"             "/d/mob/CapRate"
build_apk "BRRRRCalc"          "/d/mob/BRRRRCalc"
build_apk "RentalExpenses"      "/d/mob/RentalExpenses"
build_apk "SalaryApp-US"        "/d/mob/SalaryApp" "--flavor us --dart-define=FLAVOR=us"
build_apk "SalaryApp-UK"        "/d/mob/SalaryApp" "--flavor uk --dart-define=FLAVOR=uk"
build_apk "rideprofit"          "/d/mob/rideprofit"

echo ""
echo "========================================="
echo "✅ BUILT (${#SUCCESS[@]}): ${SUCCESS[*]}"
echo "❌ FAILED (${#FAILED[@]}): ${FAILED[*]}"
echo "========================================="
