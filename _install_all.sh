#!/bin/bash
# Sequential build + install — all apps
# Runs one at a time to avoid crashing PC
# Logs to D:/mob/_install_log.txt

LOG="D:/mob/_install_log.txt"
echo "=== Install session $(date) ===" > "$LOG"

install_flutter() {
  local app=$1
  local pkg=$2
  local flavor=$3
  local apk_name=${4:-app-debug.apk}

  echo "" | tee -a "$LOG"
  echo ">>> Building $app ${flavor:+($flavor)}" | tee -a "$LOG"
  cd "D:/mob/$app" || { echo "ERROR: dir not found" | tee -a "$LOG"; return 1; }

  if [ -n "$flavor" ]; then
    flutter build apk --flavor "$flavor" --debug 2>&1 | tail -3 | tee -a "$LOG"
    APK="build/app/outputs/flutter-apk/$apk_name"
  else
    flutter build apk --debug 2>&1 | tail -3 | tee -a "$LOG"
    APK="build/app/outputs/flutter-apk/app-debug.apk"
  fi

  if [ ! -f "$APK" ]; then
    echo "FAILED: APK not found at $APK" | tee -a "$LOG"
    return 1
  fi

  echo ">>> Installing $pkg" | tee -a "$LOG"
  result=$(adb install -r "$APK" 2>&1)
  if echo "$result" | grep -q "INCOMPATIBLE\|INSTALL_FAILED"; then
    echo "Signature mismatch — uninstalling first..." | tee -a "$LOG"
    adb uninstall "$pkg" 2>&1 | tee -a "$LOG"
    adb install "$APK" 2>&1 | tee -a "$LOG"
  else
    echo "$result" | tee -a "$LOG"
  fi
}

install_kotlin() {
  local app=$1
  local pkg=$2

  echo "" | tee -a "$LOG"
  echo ">>> Building $app (Kotlin/Gradle)" | tee -a "$LOG"
  cd "D:/mob/$app" || { echo "ERROR: dir not found" | tee -a "$LOG"; return 1; }

  cmd.exe /c "gradlew.bat assembleDebug" 2>&1 | tail -5 | tee -a "$LOG"
  APK="app/build/outputs/apk/debug/app-debug.apk"

  if [ ! -f "$APK" ]; then
    echo "FAILED: APK not found" | tee -a "$LOG"
    return 1
  fi

  echo ">>> Installing $pkg" | tee -a "$LOG"
  result=$(adb install -r "$APK" 2>&1)
  if echo "$result" | grep -q "INCOMPATIBLE\|INSTALL_FAILED"; then
    adb uninstall "$pkg" 2>&1 | tee -a "$LOG"
    adb install "$APK" 2>&1 | tee -a "$LOG"
  else
    echo "$result" | tee -a "$LOG"
  fi
}

# ── Flutter apps ─────────────────────────────────────────────────────────────
install_flutter LandlordCashFlow   com.landlord.cashflow.calculator
install_flutter HELOCApp           com.heloc.us.calculator
install_flutter RefinanceApp       com.refinance.us.calculator
install_flutter RentBuyUS          com.rentbuy.us.calculator
# ── SalaryApp — 3 flavors ────────────────────────────────────────────────────
install_flutter SalaryApp com.salary.us.calculator us app-us-debug.apk
install_flutter SalaryApp com.salary.uk.calculator uk app-uk-debug.apk
install_flutter SalaryApp com.salary.ca.calculator ca app-ca-debug.apk
install_flutter MortgageCA         com.mortgageca.calculator
install_flutter MortgageUK         com.mortgageuk.calculator
install_flutter MortgageExtraPayment com.calqwise.mortgageextrapayment
install_flutter BRRRRCalc          com.brrrr.us.calculator
install_flutter CapRate            com.caprate.us.calculator
install_flutter HouseFlip          com.houseflip.us.calculator
install_flutter PropertyROI        com.propertyroi.us.calculator
install_flutter RentalROI          com.rentalroi.us.calculator
install_flutter AffordabilityUS    com.affordability.us.calculator
install_flutter CreditCardAPR      com.creditcard.us.calculator
install_flutter MortgageUS         com.mortgageus.calculator

install_flutter LoanPayoffUS       com.loanpayoff.us.calculator
install_flutter StudentLoan        com.studentloan.us.calculator
install_flutter RentalExpenses     com.rentalexpenses.us.calculator

# ── AutoLoan — 3 flavors ─────────────────────────────────────────────────────
install_flutter AutoLoan com.autoloan.ca.calculator ca app-ca-debug.apk
install_flutter AutoLoan com.autoloan.us.calculator us app-us-debug.apk
install_flutter AutoLoan com.autoloan.uk.calculator uk app-uk-debug.apk

# ── Kotlin / Android ─────────────────────────────────────────────────────────
install_kotlin TaxeCA  com.taxeca.calculator
install_kotlin TaxeUK  com.taxeuk.calculator
install_kotlin TaxUS   com.taxus.calculator

echo "" | tee -a "$LOG"
echo "=== ALL DONE $(date) ===" | tee -a "$LOG"
