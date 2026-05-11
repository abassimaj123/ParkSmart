#!/bin/bash
# Final fix installs — run after device reconnects
DEVICE="RFCX20661WW"

log() { echo "[$(date '+%H:%M:%S')] $1"; }

log "Waiting for device..."
adb -s $DEVICE wait-for-device

log "=== CreditCardAPR ===" && adb -s $DEVICE install -r D:/mob/CreditCardAPR/build/app/outputs/flutter-apk/app-debug.apk && log "✓" || log "✗"
log "=== HELOCApp ===" && adb -s $DEVICE install -r D:/mob/HELOCApp/build/app/outputs/flutter-apk/app-debug.apk && log "✓" || log "✗"
log "=== RentalExpenses ===" && adb -s $DEVICE install -r D:/mob/RentalExpenses/build/app/outputs/flutter-apk/app-debug.apk && log "✓" || log "✗"
log "=== PropertyROISuite ===" && adb -s $DEVICE install -r D:/mob/PropertyROISuite/build/app/outputs/flutter-apk/app-debug.apk && log "✓" || log "✗"
log "=== ParkSmart ===" && adb -s $DEVICE install -r D:/mob/ParkSmart/build/app/outputs/flutter-apk/app-debug.apk && log "✓" || log "✗"
log "=== AutoLoan US ===" && adb -s $DEVICE install -r D:/mob/AutoLoan/build/app/outputs/flutter-apk/app-us-debug.apk && log "✓" || log "✗"
log "=== AutoLoan CA ===" && adb -s $DEVICE install -r D:/mob/AutoLoan/build/app/outputs/flutter-apk/app-ca-debug.apk && log "✓" || log "✗"
log "=== AutoLoan UK ===" && adb -s $DEVICE install -r D:/mob/AutoLoan/build/app/outputs/flutter-apk/app-uk-debug.apk && log "✓" || log "✗"
log "=== SalaryApp US ===" && adb -s $DEVICE install -r D:/mob/SalaryApp/build/app/outputs/flutter-apk/app-us-debug.apk && log "✓" || log "✗"
log "=== SalaryApp CA ===" && adb -s $DEVICE install -r D:/mob/SalaryApp/build/app/outputs/flutter-apk/app-ca-debug.apk && log "✓" || log "✗"
log "=== SalaryApp UK ===" && adb -s $DEVICE install -r D:/mob/SalaryApp/build/app/outputs/flutter-apk/app-uk-debug.apk && log "✓" || log "✗"
log "=== ALL FINAL FIXES INSTALLED ==="
