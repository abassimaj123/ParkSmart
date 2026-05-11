#!/bin/bash
for app in MortgageUS TaxeCA RentalROI AffordabilityUS CreditCardAPR SalaryApp StudentLoan MortgageCA HELOCApp PropertyROI RefinanceApp; do
  # Extract primary color from Dart
  dart_color=$(grep "static const.*primary.*Color(" "$app/lib/core/theme/app_theme.dart" 2>/dev/null | head -1 | sed 's/.*Color(0x//' | sed 's/).*//')
  
  # Extract splash_bg from colors.xml
  xml_color=$(grep "splash_bg" "$app/android/app/src/main/res/values/colors.xml" 2>/dev/null | sed 's/.*#//' | sed 's/<.*//')
  
  if [ -z "$dart_color" ]; then
    echo "$app: NO PRIMARY COLOR FOUND"
  else
    if [ "$dart_color" = "$xml_color" ]; then
      echo "$app: ✓ MATCH (FF$dart_color)"
    else
      echo "$app: ❌ MISMATCH - Dart: FF$dart_color, XML: $xml_color"
    fi
  fi
done
