#!/bin/bash
DEVICE="RFCX20661WW"
OK=()
FAIL=()

bai() {  # build_and_install
  local dir=$1; local label=$2; local extra="${@:3}"
  echo ""; echo "▶ $label"
  cd /d/mob/$dir || { FAIL+=("$label"); return; }
  eval "flutter build apk --debug $extra" 2>&1 | tail -3
  local apk
  if echo "$extra" | grep -q "flavor ca"; then apk="build/app/outputs/flutter-apk/app-ca-debug.apk"
  elif echo "$extra" | grep -q "flavor uk"; then apk="build/app/outputs/flutter-apk/app-uk-debug.apk"
  elif echo "$extra" | grep -q "flavor us"; then apk="build/app/outputs/flutter-apk/app-us-debug.apk"
  else apk="build/app/outputs/flutter-apk/app-debug.apk"
  fi
  if [ ! -f "$apk" ]; then echo "  ✗ Build failed"; FAIL+=("$label"); return; fi
  adb -s $DEVICE install -r "$apk" 2>&1 | tail -1
  if [ $? -eq 0 ] || adb -s $DEVICE shell pm list packages 2>/dev/null | grep -q "."; then OK+=("$label"); else FAIL+=("$label"); fi
}

# Fixed apps to rebuild+reinstall
bai MortgageExtraPayment "MortgageExtraPayment"
bai BRRRRCalc             "BRRRRCalc"
bai RentalExpenses        "RentalExpenses"
bai MortgageUS            "MortgageUS"        # nav tab fix
bai MortgageUK            "MortgageUK"        # AppBar fix
bai RentBuyUS             "RentBuyUS"         # bottom nav fix
bai RefinanceApp          "RefinanceApp"

# AutoLoan with dart-define for flavor detection
bai AutoLoan "AutoLoan-CA" "--flavor ca --dart-define=FLAVOR=ca"
bai AutoLoan "AutoLoan-UK" "--flavor uk --dart-define=FLAVOR=uk"
bai AutoLoan "AutoLoan-US" "--flavor us --dart-define=FLAVOR=us"

# SalaryApp with dart-define
bai SalaryApp "SalaryApp-US" "--flavor us --dart-define=FLAVOR=us"
bai SalaryApp "SalaryApp-UK" "--flavor uk --dart-define=FLAVOR=uk"
bai SalaryApp "SalaryApp-CA" "--flavor ca --dart-define=FLAVOR=ca"

echo ""; echo "========================================="
echo "✅ (${#OK[@]}): ${OK[*]}"
echo "❌ (${#FAIL[@]}): ${FAIL[*]}"
echo "========================================="
