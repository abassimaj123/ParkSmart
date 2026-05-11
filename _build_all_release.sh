#!/bin/bash
LOG="D:/mob/_build_all_release.log"
echo "=== BUILD ALL START $(date) ===" > "$LOG"

build_app() {
  local app=$1
  local flavor=$2
  local dart_define=$3
  echo "" >> "$LOG"
  echo ">>> $app ${flavor:-} $(date)" >> "$LOG"
  if [ -n "$flavor" ]; then
    cd "D:/mob/$app" && flutter build apk --flavor "$flavor" --dart-define="FLAVOR=$dart_define" -t lib/main.dart --release >> "$LOG" 2>&1
  else
    cd "D:/mob/$app" && flutter build apk --release >> "$LOG" 2>&1
  fi
  if [ $? -eq 0 ]; then
    echo "  ✅ $app $flavor OK" >> "$LOG"
  else
    echo "  ❌ $app $flavor FAILED" >> "$LOG"
  fi
}

# Single-flavor apps
for app in BRRRRCalc CapRate RentalExpenses AffordabilityUS CreditCardAPR HELOCApp HouseFlip LandlordCashFlow MortgageCA MortgageExtraPayment MortgageUK MortgageUS ParkSmart PropertyROI RefinanceApp RentBuyUS RentalROI StudentLoan rideprofit; do
  build_app "$app"
done

# Multi-flavor: AutoLoan
build_app AutoLoan ca CA
build_app AutoLoan uk UK
build_app AutoLoan us US

# Multi-flavor: SalaryApp
build_app SalaryApp ca CA
build_app SalaryApp uk UK
build_app SalaryApp us US

echo "" >> "$LOG"
echo "=== BUILD ALL DONE $(date) ===" >> "$LOG"
grep -E "✅|❌" "$LOG"
