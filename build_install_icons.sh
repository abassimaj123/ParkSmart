#!/bin/bash
# Build and install all apps with new icons (except TaxeCA)

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

# Flutter apps
for app in "${flutter_apps[@]}"; do
  echo ""
  echo ">>> Flutter: $app"
  cd /d/mob/$app || { echo "SKIP $app (no folder)"; ((FAIL++)); continue; }

  flutter build apk --release -q 2>&1 | tail -2
  if [ $? -eq 0 ]; then
    adb -s $DEVICE install -r build/app/outputs/flutter-apk/app-release.apk 2>&1 | tail -1
    ((OK++))
    echo "  INSTALLED $app"
  else
    echo "  BUILD FAILED $app"
    ((FAIL++))
  fi
done

# Native Android apps
for app in "${native_apps[@]}"; do
  echo ""
  echo ">>> Native: $app"
  cd /d/mob/$app || { echo "SKIP $app (no folder)"; ((FAIL++)); continue; }

  ./gradlew assembleRelease -q 2>&1 | tail -2
  apk=$(find . -name "*release*.apk" | head -1)
  if [ -n "$apk" ]; then
    adb -s $DEVICE install -r "$apk" 2>&1 | tail -1
    ((OK++))
    echo "  INSTALLED $app"
  else
    echo "  BUILD FAILED $app"
    ((FAIL++))
  fi
done

echo ""
echo "=============================="
echo " DONE: $OK installed, $FAIL failed"
echo "=============================="
