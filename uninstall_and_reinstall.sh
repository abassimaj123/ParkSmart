#!/bin/bash
device="RFCX20661WW"

echo "🗑️  Désinstall complète + réinstall..."

# Liste des packages à désinstaller
packages=(
  "com.affordability.us.calculator"
  "com.autoloan.ca.calculator"
  "com.autoloan.us.calculator"
  "com.autoloan.uk.calculator"
  "com.brrrr.us.calculator"
  "com.caprate.us.calculator"
  "com.creditcard.us.calculator"
  "com.heloc.us.calculator"
  "com.houseflip.us.calculator"
  "com.landlord.cashflow.calculator"
  "com.loanpayoff.us.calculator"
  "com.mortgageca.calculator"
  "com.calqwise.mortgageextrapayment"
  "com.mortgageuk.calculator"
  "com.mortgageus.calculator"
  "com.parksmart.montreal"
  "com.propertyroi.us.calculator"
  "com.refinance.us.calculator"
  "com.rentbuy.us.calculator"
  "com.rentalexpenses.us.calculator"
  "com.rentalroi.us.calculator"
  "com.studentloan.us.calculator"
  "com.taxus.calculator"
  "com.taxeca.calculator"
  "com.taxeuk.calculator"
)

echo "UNINSTALLING..."
for pkg in "${packages[@]}"; do
  adb -s "$device" uninstall "$pkg" > /dev/null 2>&1 && echo "✓ Uninstalled $pkg" || true
done

echo ""
echo "REINSTALLING..."

apks=(
  "AffordabilityUS/build/app/outputs/apk/release/app-release.apk"
  "AutoLoan/build/app/outputs/apk/ca/release/app-ca-release.apk"
  "AutoLoan/build/app/outputs/apk/us/release/app-us-release.apk"
  "AutoLoan/build/app/outputs/apk/uk/release/app-uk-release.apk"
  "BRRRRCalc/build/app/outputs/apk/release/app-release.apk"
  "CapRate/build/app/outputs/apk/release/app-release.apk"
  "CreditCardAPR/build/app/outputs/apk/release/app-release.apk"
  "HELOCApp/build/app/outputs/apk/release/app-release.apk"
  "HouseFlip/build/app/outputs/apk/release/app-release.apk"
  "LandlordCashFlow/build/app/outputs/apk/release/app-release.apk"
  "LoanPayoffUS/build/app/outputs/apk/release/app-release.apk"
  "MortgageCA/build/app/outputs/apk/release/app-release.apk"
  "MortgageExtraPayment/build/app/outputs/apk/release/app-release.apk"
  "MortgageUK/build/app/outputs/apk/release/app-release.apk"
  "MortgageUS/build/app/outputs/apk/release/app-release.apk"
  "ParkSmart/build/app/outputs/apk/release/app-release.apk"
  "PropertyROI/build/app/outputs/apk/release/app-release.apk"
  "RefinanceApp/build/app/outputs/apk/release/app-release.apk"
  "RentBuyUS/build/app/outputs/apk/release/app-release.apk"
  "RentalExpenses/build/app/outputs/apk/release/app-release.apk"
  "RentalROI/build/app/outputs/apk/release/app-release.apk"
  "StudentLoan/build/app/outputs/apk/release/app-release.apk"
  "TaxUS/app/build/outputs/apk/release/app-release.apk"
  "TaxeCA/app/build/outputs/apk/release/app-release.apk"
  "TaxeUK/app/build/outputs/apk/release/app-release.apk"
)

count=0
success=0
for apk in "${apks[@]}"; do
  if [ -f "$apk" ]; then
    count=$((count + 1))
    app_name=$(echo "$apk" | cut -d'/' -f1)
    if adb -s "$device" install "$apk" > /dev/null 2>&1; then
      echo "✓ [$count] $app_name"
      success=$((success + 1))
    else
      echo "✗ [$count] $app_name FAILED"
    fi
  fi
done

echo ""
echo "✅ $success/$count installées!"
