#!/bin/bash
device="RFCX20661WW"

echo "📲 Installation 29 APKs uniques sur device..."
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
for apk in "${apks[@]}"; do
  if [ -f "$apk" ]; then
    count=$((count + 1))
    name=$(basename $(dirname $(dirname "$apk")))
    echo "[$count] Installing: $name"
    adb -s "$device" install -r "$apk" 2>&1 | grep -E "Success|Failure" || echo "OK"
  fi
done

echo ""
echo "✅ Installation complétée!"
