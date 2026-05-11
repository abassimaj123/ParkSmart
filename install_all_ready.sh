#!/bin/bash
DEVICE="RFCX20661WW"
SUCCESS=()
FAILED=()

install_apk() {
  local name=$1
  local apk=$2
  if [ ! -f "$apk" ]; then
    echo "  ⚠ APK not found: $apk"
    FAILED+=("$name")
    return
  fi
  echo "▶ Installing: $name"
  adb -s $DEVICE install -r "$apk" 2>&1 | tail -2
  [ $? -eq 0 ] && SUCCESS+=("$name") || FAILED+=("$name")
}

# Already built
install_apk "StudentLoan"        "/d/mob/StudentLoan/build/app/outputs/apk/debug/app-debug.apk"
install_apk "HouseFlip"          "/d/mob/HouseFlip/build/app/outputs/apk/debug/app-debug.apk"
install_apk "MortgageExtraPayment" "/d/mob/MortgageExtraPayment/build/app/outputs/apk/debug/app-debug.apk"
install_apk "AutoLoan-CA"        "/d/mob/AutoLoan/build/app/outputs/flutter-apk/app-ca-debug.apk"
install_apk "AutoLoan-UK"        "/d/mob/AutoLoan/build/app/outputs/flutter-apk/app-uk-debug.apk"
install_apk "AutoLoan-US"        "/d/mob/AutoLoan/build/app/outputs/flutter-apk/app-us-debug.apk"
install_apk "SalaryApp-CA"       "/d/mob/SalaryApp/build/app/outputs/flutter-apk/app-ca-debug.apk"

# From build_all_missing.sh (will be ready after that script finishes)
install_apk "HELOCApp"           "/d/mob/HELOCApp/build/app/outputs/flutter-apk/app-debug.apk"
install_apk "RentalROI"          "/d/mob/RentalROI/build/app/outputs/apk/debug/app-debug.apk"
install_apk "LandlordCashFlow"   "/d/mob/LandlordCashFlow/build/app/outputs/apk/debug/app-debug.apk"
install_apk "CapRate"            "/d/mob/CapRate/build/app/outputs/apk/debug/app-debug.apk"
install_apk "BRRRRCalc"         "/d/mob/BRRRRCalc/build/app/outputs/apk/debug/app-debug.apk"
install_apk "RentalExpenses"     "/d/mob/RentalExpenses/build/app/outputs/apk/debug/app-debug.apk"
install_apk "SalaryApp-US"       "/d/mob/SalaryApp/build/app/outputs/flutter-apk/app-us-debug.apk"
install_apk "SalaryApp-UK"       "/d/mob/SalaryApp/build/app/outputs/flutter-apk/app-uk-debug.apk"
install_apk "rideprofit"         "/d/mob/rideprofit/build/app/outputs/flutter-apk/app-debug.apk"

echo ""
echo "========================================="
echo "✅ SUCCESS (${#SUCCESS[@]}): ${SUCCESS[*]}"
echo "❌ FAILED  (${#FAILED[@]}): ${FAILED[*]}"
echo "========================================="
