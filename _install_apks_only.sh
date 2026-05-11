#!/bin/bash
# Install all pre-built APKs — no rebuild needed
# Run this once the phone is connected and authorized
# Usage: bash _install_apks_only.sh

DEVICE=$(adb devices | grep -v "List of" | grep "device$" | awk '{print $1}' | head -1)
if [ -z "$DEVICE" ]; then
  echo "❌ No device found. Check USB connection and accept debugging authorization on phone."
  exit 1
fi
echo "📱 Device: $DEVICE"

install_apk() {
  local app=$1
  local pkg=$2
  local apk=$3

  echo ""
  echo ">>> Installing $app ($pkg)"

  if [ ! -f "$apk" ]; then
    echo "  SKIP: APK not found at $apk"
    return
  fi

  result=$(adb -s "$DEVICE" install -r "$apk" 2>&1)
  if echo "$result" | grep -q "INCOMPATIBLE\|INSTALL_FAILED_UPDATE_INCOMPATIBLE"; then
    echo "  Signature conflict — uninstalling first..."
    adb -s "$DEVICE" uninstall "$pkg" 2>&1
    adb -s "$DEVICE" install "$apk" 2>&1
  elif echo "$result" | grep -q "Success"; then
    echo "  ✅ Installed"
  else
    echo "  ❌ $result"
  fi
}

# ── Flutter apps (single APK) ────────────────────────────────────────────────
install_apk LandlordCashFlow    com.landlord.cashflow.calculator \
  "D:/mob/LandlordCashFlow/build/app/outputs/flutter-apk/app-debug.apk"

install_apk HELOCApp            com.heloc.us.calculator \
  "D:/mob/HELOCApp/build/app/outputs/flutter-apk/app-debug.apk"

install_apk RefinanceApp        com.refinance.us.calculator \
  "D:/mob/RefinanceApp/build/app/outputs/flutter-apk/app-debug.apk"

install_apk RentBuyUS           com.rentbuy.us.calculator \
  "D:/mob/RentBuyUS/build/app/outputs/flutter-apk/app-debug.apk"

install_apk MortgageCA          com.mortgageca.calculator \
  "D:/mob/MortgageCA/build/app/outputs/flutter-apk/app-debug.apk"

install_apk MortgageUK          com.mortgageuk.calculator \
  "D:/mob/MortgageUK/build/app/outputs/flutter-apk/app-debug.apk"

install_apk MortgageExtraPayment com.calqwise.mortgageextrapayment \
  "D:/mob/MortgageExtraPayment/build/app/outputs/flutter-apk/app-debug.apk"

install_apk BRRRRCalc           com.brrrr.us.calculator \
  "D:/mob/BRRRRCalc/build/app/outputs/flutter-apk/app-debug.apk"

install_apk CapRate             com.caprate.us.calculator \
  "D:/mob/CapRate/build/app/outputs/flutter-apk/app-debug.apk"

install_apk HouseFlip           com.houseflip.us.calculator \
  "D:/mob/HouseFlip/build/app/outputs/flutter-apk/app-debug.apk"

install_apk PropertyROI         com.propertyroi.us.calculator \
  "D:/mob/PropertyROI/build/app/outputs/flutter-apk/app-debug.apk"

install_apk RentalROI           com.rentalroi.us.calculator \
  "D:/mob/RentalROI/build/app/outputs/flutter-apk/app-debug.apk"

install_apk AffordabilityUS     com.affordability.us.calculator \
  "D:/mob/AffordabilityUS/build/app/outputs/flutter-apk/app-debug.apk"

install_apk CreditCardAPR       com.creditcard.us.calculator \
  "D:/mob/CreditCardAPR/build/app/outputs/flutter-apk/app-debug.apk"

install_apk MortgageUS          com.mortgageus.calculator \
  "D:/mob/MortgageUS/build/app/outputs/flutter-apk/app-debug.apk"

install_apk LoanPayoffUS        com.loanpayoff.us.calculator \
  "D:/mob/LoanPayoffUS/build/app/outputs/flutter-apk/app-debug.apk"

install_apk StudentLoan         com.studentloan.us.calculator \
  "D:/mob/StudentLoan/build/app/outputs/flutter-apk/app-debug.apk"

install_apk RentalExpenses      com.rentalexpenses.us.calculator \
  "D:/mob/RentalExpenses/build/app/outputs/flutter-apk/app-debug.apk"

# ── SalaryApp — 3 flavors ─────────────────────────────────────────────────────
install_apk "SalaryApp (US)" com.salary.us.calculator \
  "D:/mob/SalaryApp/build/app/outputs/flutter-apk/app-us-debug.apk"

install_apk "SalaryApp (UK)" com.salary.uk.calculator \
  "D:/mob/SalaryApp/build/app/outputs/flutter-apk/app-uk-debug.apk"

install_apk "SalaryApp (CA)" com.salary.ca.calculator \
  "D:/mob/SalaryApp/build/app/outputs/flutter-apk/app-ca-debug.apk"

# ── AutoLoan — 3 flavors ─────────────────────────────────────────────────────
install_apk "AutoLoan (CA)" com.autoloan.ca.calculator \
  "D:/mob/AutoLoan/build/app/outputs/flutter-apk/app-ca-debug.apk"

install_apk "AutoLoan (US)" com.autoloan.us.calculator \
  "D:/mob/AutoLoan/build/app/outputs/flutter-apk/app-us-debug.apk"

install_apk "AutoLoan (UK)" com.autoloan.uk.calculator \
  "D:/mob/AutoLoan/build/app/outputs/flutter-apk/app-uk-debug.apk"

# ── Kotlin apps ───────────────────────────────────────────────────────────────
install_apk TaxeCA  com.taxeca.calculator \
  "D:/mob/TaxeCA/app/build/outputs/apk/debug/app-debug.apk"

install_apk TaxeUK  com.taxeuk.calculator \
  "D:/mob/TaxeUK/app/build/outputs/apk/debug/app-debug.apk"

install_apk TaxUS   com.taxus.calculator \
  "D:/mob/TaxUS/app/build/outputs/apk/debug/app-debug.apk"

echo ""
echo "=== ALL 27 APKs INSTALL DONE ==="
