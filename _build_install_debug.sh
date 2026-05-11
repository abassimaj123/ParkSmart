#!/bin/bash
# Sequential debug build + install for all portfolio apps
# Fix: removed --no-pub (not valid for flutter install)

DEVICE="RFCX20661WW"
LOG="D:/mob/_build_install_debug.log"

log() { echo "[$(date '+%H:%M:%S')] $1" | tee -a "$LOG"; }

log "=== MortgageUS ==="
cd "D:/mob/MortgageUS" && flutter install --debug -d "$DEVICE" && log "MortgageUS ✓" || log "MortgageUS ✗"

log "=== MortgageCA ==="
cd "D:/mob/MortgageCA" && flutter install --debug -d "$DEVICE" && log "MortgageCA ✓" || log "MortgageCA ✗"

log "=== MortgageUK ==="
cd "D:/mob/MortgageUK" && flutter install --debug -d "$DEVICE" && log "MortgageUK ✓" || log "MortgageUK ✗"

log "=== StudentLoan ==="
cd "D:/mob/StudentLoan" && flutter install --debug -d "$DEVICE" && log "StudentLoan ✓" || log "StudentLoan ✗"

log "=== LoanPayoffUS ==="
cd "D:/mob/LoanPayoffUS" && flutter install --debug -d "$DEVICE" && log "LoanPayoffUS ✓" || log "LoanPayoffUS ✗"

log "=== CreditCardAPR ==="
cd "D:/mob/CreditCardAPR" && flutter install --debug -d "$DEVICE" && log "CreditCardAPR ✓" || log "CreditCardAPR ✗"

log "=== HELOCApp ==="
cd "D:/mob/HELOCApp" && flutter install --debug -d "$DEVICE" && log "HELOCApp ✓" || log "HELOCApp ✗"

log "=== AutoLoan US ==="
cd "D:/mob/AutoLoan" && flutter install --debug --flavor us -d "$DEVICE" && log "AutoLoan US ✓" || log "AutoLoan US ✗"

log "=== AutoLoan CA ==="
cd "D:/mob/AutoLoan" && flutter install --debug --flavor ca -d "$DEVICE" && log "AutoLoan CA ✓" || log "AutoLoan CA ✗"

log "=== AutoLoan UK ==="
cd "D:/mob/AutoLoan" && flutter install --debug --flavor uk -d "$DEVICE" && log "AutoLoan UK ✓" || log "AutoLoan UK ✗"

log "=== RentBuyUS ==="
cd "D:/mob/RentBuyUS" && flutter install --debug -d "$DEVICE" && log "RentBuyUS ✓" || log "RentBuyUS ✗"

log "=== RentalExpenses ==="
cd "D:/mob/RentalExpenses" && flutter install --debug -d "$DEVICE" && log "RentalExpenses ✓" || log "RentalExpenses ✗"

log "=== PropertyROISuite ==="
cd "D:/mob/PropertyROISuite" && flutter install --debug -d "$DEVICE" && log "PropertyROISuite ✓" || log "PropertyROISuite ✗"

log "=== SalaryApp US ==="
cd "D:/mob/SalaryApp" && flutter install --debug --flavor us -d "$DEVICE" && log "SalaryApp US ✓" || log "SalaryApp US ✗"

log "=== SalaryApp CA ==="
cd "D:/mob/SalaryApp" && flutter install --debug --flavor ca -d "$DEVICE" && log "SalaryApp CA ✓" || log "SalaryApp CA ✗"

log "=== SalaryApp UK ==="
cd "D:/mob/SalaryApp" && flutter install --debug --flavor uk -d "$DEVICE" && log "SalaryApp UK ✓" || log "SalaryApp UK ✗"

log "=== ParkSmart ==="
cd "D:/mob/ParkSmart" && flutter install --debug -d "$DEVICE" && log "ParkSmart ✓" || log "ParkSmart ✗"

log "=== rideprofit ==="
cd "D:/mob/rideprofit" && flutter install --debug -d "$DEVICE" && log "rideprofit ✓" || log "rideprofit ✗"

log "=== JobOfferUS ==="
cd "D:/mob/JobOfferUS" && flutter install --debug -d "$DEVICE" && log "JobOfferUS ✓" || log "JobOfferUS ✗"

log "=== ALL FLUTTER DONE ==="
