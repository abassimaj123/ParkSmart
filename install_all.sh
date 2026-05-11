#!/bin/bash
DEVICE="RFCX20661WW"
OK=()
FAIL=()

install_app() {
  local dir=$1
  local flavor=$2
  local label=${3:-$dir}
  echo ""
  echo "▶ Installing: $label"
  cd /d/mob/$dir || { FAIL+=("$label (cd failed)"); return; }
  if [ -n "$flavor" ]; then
    flutter install --debug -d $DEVICE --flavor $flavor 2>&1 | tail -5
  else
    flutter install --debug -d $DEVICE 2>&1 | tail -5
  fi
  local exit_code=${PIPESTATUS[0]}
  if [ $exit_code -eq 0 ]; then OK+=("$label"); else FAIL+=("$label"); fi
}

install_app MortgageUS      ""   "MortgageUS"
install_app MortgageUK      ""   "MortgageUK"
install_app MortgageCA      ""   "MortgageCA"
install_app RentBuyUS       ""   "RentBuyUS"
install_app LoanPayoffUS    ""   "LoanPayoffUS"
install_app RefinanceApp    ""   "RefinanceApp"
install_app MortgageExtraPayment "" "MortgageExtraPayment"
install_app AffordabilityUS ""   "AffordabilityUS"
install_app AffordabilityCA ""   "AffordabilityCA"
install_app AffordabilityUK ""   "AffordabilityUK"
install_app HELOCApp        ""   "HELOCApp"
install_app StudentLoan     ""   "StudentLoan"
install_app CreditCardAPR   ""   "CreditCardAPR"
install_app PropertyROI     ""   "PropertyROI"
install_app RentalROI       ""   "RentalROI"
install_app LandlordCashFlow "" "LandlordCashFlow"
install_app HouseFlip       ""   "HouseFlip"
install_app CapRate         ""   "CapRate"
install_app BRRRRCalc       ""   "BRRRRCalc"
install_app RentalExpenses  ""   "RentalExpenses"
install_app rideprofit      ""   "rideprofit"
install_app AutoLoan "ca" "AutoLoan-CA"
install_app AutoLoan "uk" "AutoLoan-UK"
install_app AutoLoan "us" "AutoLoan-US"
install_app SalaryApp "us" "SalaryApp-US"
install_app SalaryApp "uk" "SalaryApp-UK"
install_app SalaryApp "ca" "SalaryApp-CA"

echo ""
echo "========================================="
echo "✅ SUCCESS (${#OK[@]}): ${OK[*]}"
echo "❌ FAILED  (${#FAIL[@]}): ${FAIL[*]}"
echo "========================================="
