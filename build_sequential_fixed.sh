#!/bin/bash
set -e

# 20 apps simples (AutoLoan et SalaryApp EXCLUS - ils sont multi-flavor)
flutter_apps=(
  "AffordabilityUS" "BRRRRCalc" "CapRate" "CreditCardAPR" "HELOCApp"
  "HouseFlip" "LandlordCashFlow" "LoanPayoffUS" "MortgageCA" "MortgageExtraPayment"
  "MortgageUK" "MortgageUS" "ParkSmart" "PropertyROI" "RefinanceApp"
  "RentBuyUS" "RentalExpenses" "RentalROI" "StudentLoan" "rideprofit"
)

multi_flavor=("AutoLoan" "SalaryApp")
flavors=("ca" "us" "uk")
kotlin_apps=("TaxUS" "TaxeCA" "TaxeUK")

echo "📱 BUILDING 29 APKs SEQUENTIALLY..."
count=0
total=29

# 20 simple
for app in "${flutter_apps[@]}"; do
  count=$((count + 1))
  echo "[$count/$total] 🔨 $app..."
  cd "$app" 2>/dev/null
  flutter clean > /dev/null 2>&1
  flutter build apk --release > /dev/null 2>&1 && echo "  ✓" || echo "  ✗"
  cd ..
done

# 6 multi-flavor
for app in "${multi_flavor[@]}"; do
  for flavor in "${flavors[@]}"; do
    count=$((count + 1))
    echo "[$count/$total] 🔀 $app ($flavor)..."
    cd "$app" 2>/dev/null
    flutter build apk --release --flavor "$flavor" > /dev/null 2>&1 && echo "  ✓" || echo "  ✗"
    cd ..
  done
done

# 3 Kotlin
for app in "${kotlin_apps[@]}"; do
  count=$((count + 1))
  echo "[$count/$total] 🔧 $app..."
  cd "$app" 2>/dev/null
  ./gradlew assembleRelease > /dev/null 2>&1 && echo "  ✓" || echo "  ✗"
  cd ..
done

echo ""
echo "✅ 29 APKs BUILT!"
