#!/bin/bash
set -e

# 25 Flutter apps
flutter_apps=(
  "AffordabilityUS" "AutoLoan" "BRRRRCalc" "CapRate" "CreditCardAPR" "HELOCApp"
  "HouseFlip" "LandlordCashFlow" "LoanPayoffUS" "MortgageCA" "MortgageExtraPayment"
  "MortgageUK" "MortgageUS" "ParkSmart" "PropertyROI" "RefinanceApp"
  "RentBuyUS" "RentalExpenses" "RentalROI" "SalaryApp" "StudentLoan" "rideprofit"
)

multi_flavor=("AutoLoan" "SalaryApp")
flavors=("ca" "us" "uk")

echo "📱 BUILDING SEQUENTIALLY (1 app at a time)..."
count=0
total=$((${#flutter_apps[@]} + 6 + 3))

# Flutter simple apps
for app in "${flutter_apps[@]}"; do
  count=$((count + 1))
  echo ""
  echo "[$count/$total] 🔨 $app..."
  cd "$app"
  flutter clean > /dev/null 2>&1
  if flutter build apk --release > /dev/null 2>&1; then
    echo "  ✓ SUCCESS"
  else
    echo "  ✗ FAILED"
  fi
  cd ..
done

# Multi-flavor apps
for app in "${multi_flavor[@]}"; do
  for flavor in "${flavors[@]}"; do
    count=$((count + 1))
    echo ""
    echo "[$count/$total] 🔀 $app ($flavor)..."
    cd "$app"
    if flutter build apk --release --flavor "$flavor" > /dev/null 2>&1; then
      echo "  ✓ SUCCESS"
    else
      echo "  ✗ FAILED"
    fi
    cd ..
  done
done

# Kotlin apps
kotlin_apps=("TaxUS" "TaxeCA" "TaxeUK")
for app in "${kotlin_apps[@]}"; do
  count=$((count + 1))
  echo ""
  echo "[$count/$total] 🔧 $app (Kotlin)..."
  cd "$app"
  if ./gradlew assembleRelease > /dev/null 2>&1; then
    echo "  ✓ SUCCESS"
  else
    echo "  ✗ FAILED"
  fi
  cd ..
done

echo ""
echo "✅ BUILD COMPLETE!"
