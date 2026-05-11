#!/bin/bash
echo "==== FINAL VALIDATION ===="
echo ""

flutter_apps=0
color_match=0
color_mismatch=0
icon_declared=0
icon_missing=0

for app in AffordabilityUS AutoLoan BRRRRCalc CapRate CreditCardAPR HELOCApp HouseFlip LandlordCashFlow LoanPayoffUS MortgageCA MortgageExtraPayment MortgageUK MortgageUS ParkSmart PropertyROI RefinanceApp RentalExpenses RentalROI RentBuyUS rideprofit SalaryApp StudentLoan; do
  
  test -f "$app/pubspec.yaml" || continue
  ((flutter_apps++))
  
  # Colors check
  dart_color=$(grep "static const.*primary.*Color(" "$app/lib/core/theme/app_theme.dart" 2>/dev/null | sed 's/.*Color(0x//;s/).*//' | head -1)
  xml_color=$(grep "splash_bg" "$app/android/app/src/main/res/values/colors.xml" 2>/dev/null | sed 's/.*#//' | sed 's/<.*//')
  
  if [ "$dart_color" = "$xml_color" ] 2>/dev/null; then
    ((color_match++))
  else
    ((color_mismatch++))
    echo "❌ $app color mismatch"
  fi
  
  # Icons check
  if grep -q "image_path\|adaptive_icon" "$app/pubspec.yaml" 2>/dev/null; then
    ((icon_declared++))
  else
    ((icon_missing++))
  fi
done

echo ""
echo "RÉSUMÉ :"
echo "Flutter apps scanned: $flutter_apps"
echo "Color matches: $color_match ✓"
echo "Color mismatches: $color_mismatch ❌"
echo "Icon declarations: $icon_declared ✓"
echo "Missing icons config: $icon_missing ⚠️"
