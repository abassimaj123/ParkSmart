#!/bin/bash
DEVICE="RFCX20661WW"
OK=0; FAIL=0

# ── Step 1: Uninstall all existing apps ──────────────────────────────────────
echo "=============================="
echo " STEP 1 — Uninstall all apps"
echo "=============================="
packages=(
  com.mortgageus.calculator
  com.mortgageuk.calculator
  com.mortgageca.calculator
  com.autoloan.ca.calculator
  com.autoloan.uk.calculator
  com.autoloan.us.calculator
  com.affordability.us.calculator
  com.affordability.uk.calculator
  com.affordabilityca.calculator
  com.heloc.us.calculator
  com.rentbuy.us.calculator
  com.loanpayoff.us.calculator
  com.refinance.us.calculator
  com.propertyroi.us.calculator
  com.studentloan.us.calculator
  com.rideprofit.app
  com.creditcard.us.calculator
  com.salary.us.calculator
  com.rentalroi.us.calculator
  com.landlord.cashflow.calculator
  com.houseflip.us.calculator
  com.caprate.us.calculator
  com.brrrr.us.calculator
  com.rentalexpenses.us.calculator
  com.taxus.calculator
  com.taxau.calculator
  com.taxeuk.calculator
)
for pkg in "${packages[@]}"; do
  result=$(adb -s $DEVICE uninstall $pkg 2>&1)
  echo "  uninstall $pkg → $result"
done

# ── Step 2: Build + Install Flutter apps ─────────────────────────────────────
echo ""
echo "=============================="
echo " STEP 2 — Build + Install"
echo "=============================="

build_install_flutter() {
  local app=$1
  local apk_path="build/app/outputs/flutter-apk/app-release.apk"
  echo ""
  echo ">>> Flutter: $app"
  cd /d/mob/$app || { echo "  SKIP — no folder"; ((FAIL++)); return; }
  flutter build apk --release 2>&1 | grep -E "Built|error:|FAILURE" | head -3
  if [ -f "$apk_path" ]; then
    result=$(adb -s $DEVICE install "$apk_path" 2>&1)
    if echo "$result" | grep -q "Success"; then
      echo "  ✓ INSTALLED $app"; ((OK++))
    else
      echo "  ✗ ADB FAILED: $result"; ((FAIL++))
    fi
  else
    echo "  ✗ BUILD FAILED (no APK)"; ((FAIL++))
  fi
}

build_install_native() {
  local app=$1
  echo ""
  echo ">>> Native: $app"
  cd /d/mob/$app || { echo "  SKIP — no folder"; ((FAIL++)); return; }
  ./gradlew assembleRelease 2>&1 | grep -E "BUILD|error:" | head -3
  apk=$(find . -name "*release*.apk" -not -path "*/intermediates/*" | head -1)
  if [ -n "$apk" ]; then
    result=$(adb -s $DEVICE install "$apk" 2>&1)
    if echo "$result" | grep -q "Success"; then
      echo "  ✓ INSTALLED $app"; ((OK++))
    else
      echo "  ✗ ADB FAILED: $result"; ((FAIL++))
    fi
  else
    echo "  ✗ BUILD FAILED (no APK)"; ((FAIL++))
  fi
}

build_install_autoloan() {
  local flavor=$1
  echo ""
  echo ">>> AutoLoan [$flavor]"
  cd /d/mob/AutoLoan || { echo "  SKIP"; ((FAIL++)); return; }
  flutter build apk --release --flavor $flavor 2>&1 | grep -E "Built|error:|FAILURE" | head -3
  apk="build/app/outputs/flutter-apk/app-$flavor-release.apk"
  if [ -f "$apk" ]; then
    result=$(adb -s $DEVICE install "$apk" 2>&1)
    if echo "$result" | grep -q "Success"; then
      echo "  ✓ INSTALLED AutoLoan-$flavor"; ((OK++))
    else
      echo "  ✗ ADB FAILED: $result"; ((FAIL++))
    fi
  else
    echo "  ✗ BUILD FAILED (no APK)"; ((FAIL++))
  fi
}

# Flutter apps
build_install_flutter MortgageUS
build_install_flutter MortgageUK
build_install_flutter MortgageCA
build_install_flutter MortgageExtraPayment
build_install_flutter AffordabilityUS
build_install_flutter AffordabilityUK
build_install_flutter AffordabilityCA
build_install_flutter HELOCApp
build_install_flutter RentBuyUS
build_install_flutter LoanPayoffUS
build_install_flutter RefinanceApp
build_install_flutter PropertyROI
build_install_flutter StudentLoan
build_install_flutter rideprofit
build_install_flutter CreditCardAPR
build_install_flutter SalaryApp
build_install_flutter RentalROI
build_install_flutter LandlordCashFlow
build_install_flutter HouseFlip
build_install_flutter CapRate
build_install_flutter BRRRRCalc
build_install_flutter RentalExpenses

# AutoLoan flavors
build_install_autoloan ca
build_install_autoloan uk
build_install_autoloan us

# Native apps
build_install_native TaxUS
build_install_native TaxAU
build_install_native TaxeUK

echo ""
echo "=============================="
echo " ✓ Installed : $OK"
echo " ✗ Failed    : $FAIL"
echo "=============================="
