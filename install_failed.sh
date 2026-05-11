#!/bin/bash
DEVICE="RFCX20661WW"
OK=()
FAIL=()

build_and_install() {
  local dir=$1
  local flavor=$2
  local label=${3:-$dir}
  echo ""
  echo "▶ Building: $label"
  cd /d/mob/$dir || { FAIL+=("$label(cd)"); return; }
  
  if [ -n "$flavor" ]; then
    flutter build apk --debug --flavor $flavor 2>&1 | tail -3
    apk="build/app/outputs/flutter-apk/app-${flavor}-debug.apk"
  else
    flutter build apk --debug 2>&1 | tail -3
    apk="build/app/outputs/flutter-apk/app-debug.apk"
  fi
  
  if [ ! -f "$apk" ]; then
    echo "  ✗ Build failed: $label"
    FAIL+=("$label")
    return
  fi
  
  echo "  Installing $label..."
  adb -s $DEVICE install -r "$apk" 2>&1 | tail -2
  if [ ${PIPESTATUS[0]} -eq 0 ] || adb -s $DEVICE shell pm list packages 2>/dev/null | grep -q "$(grep applicationId android/app/build.gradle.kts 2>/dev/null | head -1 | sed 's/.*= "//;s/".*//')"; then
    OK+=("$label")
  else
    FAIL+=("$label")
  fi
}

# All 16 that failed
build_and_install RefinanceApp      ""   "RefinanceApp"
build_and_install MortgageExtraPayment "" "MortgageExtraPayment"
build_and_install AffordabilityUS   ""   "AffordabilityUS"
build_and_install AffordabilityCA   ""   "AffordabilityCA"
build_and_install AffordabilityUK   ""   "AffordabilityUK"
build_and_install HELOCApp          ""   "HELOCApp"
build_and_install StudentLoan       ""   "StudentLoan"
build_and_install RentalROI         ""   "RentalROI"
build_and_install LandlordCashFlow  ""   "LandlordCashFlow"
build_and_install HouseFlip         ""   "HouseFlip"
build_and_install CapRate           ""   "CapRate"
build_and_install BRRRRCalc         ""   "BRRRRCalc"
build_and_install RentalExpenses    ""   "RentalExpenses"
build_and_install SalaryApp "us" "SalaryApp-US"
build_and_install SalaryApp "uk" "SalaryApp-UK"
build_and_install SalaryApp "ca" "SalaryApp-CA"

echo ""
echo "========================================="
echo "✅ SUCCESS (${#OK[@]}): ${OK[*]}"
echo "❌ FAILED  (${#FAIL[@]}): ${FAIL[*]}"
echo "========================================="
