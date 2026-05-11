#!/bin/bash
DEVICE="RFCX20661WW"
OK=0; FAIL=0

flutter_apps=(
  MortgageUS MortgageUK MortgageCA
  AutoLoan
  AffordabilityUS AffordabilityUK AffordabilityCA
  HELOCApp RentBuyUS LoanPayoffUS RefinanceApp
  PropertyROI StudentLoan rideprofit CreditCardAPR
  SalaryApp RentalROI LandlordCashFlow HouseFlip
  CapRate BRRRRCalc RentalExpenses MortgageExtraPayment
)

native_apps=(TaxUS TaxAU TaxeUK)

echo "=============================="
echo " BUILD + INSTALL — $(date)"
echo "=============================="

for app in "${flutter_apps[@]}"; do
  echo ""
  echo ">>> $app"
  cd /d/mob/$app || { echo "  SKIP — folder not found"; ((FAIL++)); continue; }
  
  flutter build apk --release 2>&1 | grep -E "Built|Error|error|FAILURE|Exception" | head -3
  apk="build/app/outputs/flutter-apk/app-release.apk"
  
  if [ -f "$apk" ]; then
    result=$(adb -s $DEVICE install -r "$apk" 2>&1)
    echo "  adb: $result"
    if echo "$result" | grep -q "Success"; then
      echo "  ✓ INSTALLED $app"
      ((OK++))
    else
      echo "  ✗ ADB FAILED $app"
      ((FAIL++))
    fi
  else
    echo "  ✗ BUILD FAILED $app (no APK)"
    ((FAIL++))
  fi
done

for app in "${native_apps[@]}"; do
  echo ""
  echo ">>> $app (native)"
  cd /d/mob/$app || { echo "  SKIP — folder not found"; ((FAIL++)); continue; }
  
  ./gradlew assembleRelease -q 2>&1 | tail -3
  apk=$(find . -name "*release*.apk" -not -path "*/intermediates/*" | head -1)
  
  if [ -n "$apk" ]; then
    result=$(adb -s $DEVICE install -r "$apk" 2>&1)
    echo "  adb: $result"
    if echo "$result" | grep -q "Success"; then
      echo "  ✓ INSTALLED $app"
      ((OK++))
    else
      echo "  ✗ ADB FAILED $app"
      ((FAIL++))
    fi
  else
    echo "  ✗ BUILD FAILED $app (no APK)"
    ((FAIL++))
  fi
done

echo ""
echo "=============================="
echo " ✓ Installed : $OK"
echo " ✗ Failed    : $FAIL"
echo "=============================="
