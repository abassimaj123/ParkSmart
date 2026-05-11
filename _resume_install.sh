#!/bin/bash
# Resume build+install — picks up from where _install_all.sh crashed
# Pre-built: LandlordCashFlow, HELOCApp, RefinanceApp, MortgageExtraPayment, BRRRRCalc, TaxeCA/UK/US
# To build: CapRate, HouseFlip, PropertyROI, RentalROI, AffordabilityUS, CreditCardAPR,
#           MortgageUS, LoanPayoffUS, StudentLoan, RentalExpenses, AutoLoan (CA/US/UK)

LOG="D:/mob/_install_log.txt"
DEVICE=$(adb devices | grep -v "List of" | grep "device$" | awk '{print $1}' | head -1)

echo "" | tee -a "$LOG"
echo "=== RESUME session $(date) ===" | tee -a "$LOG"
echo "📱 Device: $DEVICE" | tee -a "$LOG"

if [ -z "$DEVICE" ]; then
  echo "❌ No device found" | tee -a "$LOG"
  exit 1
fi

# ── Install pre-built APKs ───────────────────────────────────────────────────
install_prebuilt() {
  local app=$1
  local pkg=$2
  local apk=$3

  echo "" | tee -a "$LOG"
  echo ">>> Installing (pre-built) $app ($pkg)" | tee -a "$LOG"
  if [ ! -f "$apk" ]; then
    echo "  SKIP: APK missing at $apk" | tee -a "$LOG"
    return
  fi
  result=$(adb -s "$DEVICE" install -r "$apk" 2>&1)
  if echo "$result" | grep -q "INCOMPATIBLE\|INSTALL_FAILED_UPDATE_INCOMPATIBLE"; then
    echo "  Signature conflict — uninstalling first..." | tee -a "$LOG"
    adb -s "$DEVICE" uninstall "$pkg" 2>&1 | tee -a "$LOG"
    adb -s "$DEVICE" install "$apk" 2>&1 | tee -a "$LOG"
  else
    echo "$result" | tee -a "$LOG"
  fi
}

# ── Build + install Flutter ──────────────────────────────────────────────────
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
  result=$(adb -s "$DEVICE" install -r "$APK" 2>&1)
  if echo "$result" | grep -q "INCOMPATIBLE\|INSTALL_FAILED"; then
    echo "Signature mismatch — uninstalling first..." | tee -a "$LOG"
    adb -s "$DEVICE" uninstall "$pkg" 2>&1 | tee -a "$LOG"
    adb -s "$DEVICE" install "$APK" 2>&1 | tee -a "$LOG"
  else
    echo "$result" | tee -a "$LOG"
  fi
}

# ── Install Kotlin (pre-built) ───────────────────────────────────────────────
install_kotlin_prebuilt() {
  local app=$1
  local pkg=$2
  local apk="D:/mob/$app/app/build/outputs/apk/debug/app-debug.apk"
  install_prebuilt "$app" "$pkg" "$apk"
}

# ═══════════════════════════════════════════════════════════════════════════════
# PHASE 1 — Install pre-built APKs
# ═══════════════════════════════════════════════════════════════════════════════
install_prebuilt LandlordCashFlow  com.landlord.cashflow.calculator \
  "D:/mob/LandlordCashFlow/build/app/outputs/flutter-apk/app-debug.apk"

install_prebuilt HELOCApp          com.heloc.us.calculator \
  "D:/mob/HELOCApp/build/app/outputs/flutter-apk/app-debug.apk"

install_prebuilt RefinanceApp      com.refinance.us.calculator \
  "D:/mob/RefinanceApp/build/app/outputs/flutter-apk/app-debug.apk"

install_prebuilt MortgageExtraPayment com.calqwise.mortgageextrapayment \
  "D:/mob/MortgageExtraPayment/build/app/outputs/flutter-apk/app-debug.apk"

install_prebuilt BRRRRCalc         com.brrrr.us.calculator \
  "D:/mob/BRRRRCalc/build/app/outputs/flutter-apk/app-debug.apk"

install_kotlin_prebuilt TaxeCA  com.taxeca.calculator
install_kotlin_prebuilt TaxeUK  com.taxeuk.calculator
install_kotlin_prebuilt TaxUS   com.taxus.calculator

# ═══════════════════════════════════════════════════════════════════════════════
# PHASE 2 — Build + install remaining Flutter apps
# ═══════════════════════════════════════════════════════════════════════════════
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

# AutoLoan — 3 flavors
install_flutter AutoLoan com.autoloan.ca.calculator ca app-ca-debug.apk
install_flutter AutoLoan com.autoloan.us.calculator us app-us-debug.apk
install_flutter AutoLoan com.autoloan.uk.calculator uk app-uk-debug.apk

echo "" | tee -a "$LOG"
echo "=== RESUME DONE $(date) ===" | tee -a "$LOG"
