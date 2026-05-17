#!/usr/bin/env bash
ROOT="/d/mob"

APPS=(
  AutoLoan CreditCardAPR HELOCApp JobOfferUS LoanPayoffUS
  MortgageCA MortgageUK MortgageUS ParkSmart PropertyROISuite
  RentBuyUS RentalExpenses rideprofit SalaryApp StudentLoan
)

GREEN="\033[0;32m"; RED="\033[0;31m"; RESET="\033[0m"
PASSED=0; FAILED=0; TOTAL=${#APPS[@]}

echo ""
echo "══════════════════════════════════════════════════════"
echo "  Phase 2 Audit — Warnings + Format"
echo "══════════════════════════════════════════════════════"
echo ""

for app in "${APPS[@]}"; do
  dir="$ROOT/$app"
  cd "$dir" || continue

  # Warnings check
  warn_count=$(flutter analyze --no-pub 2>&1 | grep -cE "^  • warning|warning •" || true)

  # Format check — use exit code (0 = already clean, non-zero = would change files)
  dart format --set-exit-if-changed lib/ test/ > /dev/null 2>&1
  fmt_exit=$?

  if [[ $warn_count -gt 0 || $fmt_exit -ne 0 ]]; then
    echo -e "${RED}❌${RESET}  $app  warn:$warn_count  fmt:$fmt_exit"
    (( FAILED++ ))
  else
    echo -e "${GREEN}✅${RESET}  $app  warn:0  fmt:OK"
    (( PASSED++ ))
  fi
done

echo ""
echo "══════════════════════════════════════════════════════"
echo -e "  ${GREEN}${PASSED}${RESET}/${TOTAL} clean   ${RED}${FAILED}${RESET} need attention"
echo "══════════════════════════════════════════════════════"
echo ""
[[ $FAILED -gt 0 ]] && exit 1; exit 0
