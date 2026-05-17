#!/usr/bin/env bash
ROOT="/d/mob"

APPS=(
  AutoLoan CreditCardAPR HELOCApp JobOfferUS LoanPayoffUS
  MortgageCA MortgageUK MortgageUS ParkSmart PropertyROISuite
  RentBuyUS RentalExpenses rideprofit SalaryApp StudentLoan
)

GREEN="\033[0;32m"; RED="\033[0;31m"; YELLOW="\033[0;33m"; RESET="\033[0m"
PASSED=0; FAILED=0; TOTAL=${#APPS[@]}

echo ""
echo "══════════════════════════════════════════════════════"
echo "  Phase 3 Audit — flutter test (all apps)"
echo "══════════════════════════════════════════════════════"
echo ""

for app in "${APPS[@]}"; do
  dir="$ROOT/$app"
  cd "$dir" || continue

  output=$(flutter test --no-pub 2>&1)
  last=$(echo "$output" | tail -3)

  if echo "$last" | grep -qi "failed\|exception\|error"; then
    # Extract failure summary line
    summary=$(echo "$output" | grep -E "^\+.*:.*failed|Some tests failed" | tail -1)
    [[ -z "$summary" ]] && summary=$(echo "$last" | head -1)
    echo -e "${RED}❌${RESET}  $app — $summary"
    (( FAILED++ ))
  else
    count=$(echo "$output" | grep -oE '\+[0-9]+' | tail -1 | tr -d '+')
    echo -e "${GREEN}✅${RESET}  $app — ${count:-?} tests passed"
    (( PASSED++ ))
  fi
done

echo ""
echo "══════════════════════════════════════════════════════"
echo -e "  ${GREEN}${PASSED}${RESET}/${TOTAL} passing   ${RED}${FAILED}${RESET} failing"
echo "══════════════════════════════════════════════════════"
echo ""
[[ $FAILED -gt 0 ]] && exit 1; exit 0
