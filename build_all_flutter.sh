#!/bin/bash
flutter_apps=(
  "AffordabilityUS" "AutoLoan" "BRRRRCalc" "CapRate" "CreditCardAPR" "HELOCApp"
  "HouseFlip" "LandlordCashFlow" "LoanPayoffUS" "MortgageCA" "MortgageExtraPayment"
  "MortgageUK" "MortgageUS" "ParkSmart" "PropertyROI" "RefinanceApp"
  "RentBuyUS" "RentalExpenses" "RentalROI" "SalaryApp" "StudentLoan" "rideprofit"
)

echo "Building 22 Flutter apps (RELEASE)..."
for app in "${flutter_apps[@]}"; do
  echo ""
  echo "▶ $app..."
  cd "$app"
  flutter clean
  flutter build apk --release 2>&1 | grep -E "✓|✗|error|Error|Signing" || echo "Build in progress..."
  cd ..
done
echo ""
echo "✓ All Flutter builds completed"
