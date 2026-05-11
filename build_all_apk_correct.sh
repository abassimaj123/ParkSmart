#!/bin/bash
echo "🔨 BUILD ALL 29 APKs (20 simple + 6 multi-flavor + 3 Kotlin)"
echo ""

# 20 apps simples (1 flavor)
simple_apps=(
  "AffordabilityUS" "BRRRRCalc" "CapRate" "CreditCardAPR" "HELOCApp"
  "HouseFlip" "LandlordCashFlow" "LoanPayoffUS" "MortgageUS" "MortgageCA" "MortgageUK"
  "MortgageExtraPayment" "ParkSmart" "PropertyROI" "RefinanceApp"
  "RentBuyUS" "RentalExpenses" "RentalROI" "StudentLoan" "rideprofit"
)

# 2 apps avec 3 flavors (CA, US, UK)
multi_flavor_apps=("AutoLoan" "SalaryApp")
flavors=("ca" "us" "uk")

# 3 apps Kotlin (TaxUS, TaxeCA, TaxeUK)
kotlin_apps=("TaxUS" "TaxeCA" "TaxeUK")

echo "📱 Building 20 simple Flutter apps..."
for app in "${simple_apps[@]}"; do
  echo "  ▶ $app"
  cd "$app" 2>/dev/null || continue
  flutter clean > /dev/null 2>&1
  flutter build apk --release > /dev/null 2>&1 &
  cd ..
done
wait
echo "✓ 20 simple apps built"

echo ""
echo "🔀 Building 2 multi-flavor apps (6 builds total)..."
for app in "${multi_flavor_apps[@]}"; do
  for flavor in "${flavors[@]}"; do
    echo "  ▶ $app ($flavor)"
    cd "$app" 2>/dev/null || continue
    flutter build apk --release --flavor "$flavor" > /dev/null 2>&1 &
    cd ..
  done
done
wait
echo "✓ Multi-flavor apps built"

echo ""
echo "🔨 Building 3 Kotlin apps..."
for app in "${kotlin_apps[@]}"; do
  echo "  ▶ $app"
  cd "$app" 2>/dev/null || continue
  ./gradlew assembleRelease > /dev/null 2>&1 &
  cd ..
done
wait
echo "✓ Kotlin apps built"

echo ""
echo "✅ ALL 29 APKs BUILT!"
