#!/bin/bash
# Build and install all portfolio apps to Android emulator
# Updated: Uses emulator-5554 (your current emulator)
# Logs to /d/mob/install_emulator.log

set -e  # Exit on error

EMULATOR="emulator-5554"
LOG="/d/mob/install_emulator.log"
ERRORS=0

log() {
  echo "[$(date '+%H:%M:%S')] $1" | tee -a "$LOG"
}

error() {
  echo "[$(date '+%H:%M:%S')] ❌ $1" | tee -a "$LOG"
  ((ERRORS++))
}

success() {
  echo "[$(date '+%H:%M:%S')] ✅ $1" | tee -a "$LOG"
}

# Initialize log
echo "=== Portfolio Install Session $(date) ===" > "$LOG"

log "Checking emulator status..."
if ! adb devices | grep -q "$EMULATOR"; then
  error "Emulator $EMULATOR not found! Start it in Android Studio."
  exit 1
fi

success "Emulator $EMULATOR is connected"

# ── FLUTTER APPS ─────────────────────────────────────────────────────────────

flutter_install() {
  local app=$1
  local flavor=${2:-""}

  log ">>> Building Flutter: $app${flavor:+ ($flavor)}"
  cd "/d/mob/$app" || { error "Directory not found: $app"; return 1; }

  if [ -n "$flavor" ]; then
    if ! flutter build apk --flavor "$flavor" --debug > /tmp/build.log 2>&1; then
      error "$app ($flavor) build failed"
      tail -10 /tmp/build.log >> "$LOG"
      return 1
    fi
    APK="build/app/outputs/flutter-apk/app-${flavor}-debug.apk"
  else
    if ! flutter build apk --debug > /tmp/build.log 2>&1; then
      error "$app build failed"
      tail -10 /tmp/build.log >> "$LOG"
      return 1
    fi
    APK="build/app/outputs/flutter-apk/app-debug.apk"
  fi

  if [ ! -f "$APK" ]; then
    error "$app${flavor:+ ($flavor)}: APK not found at $APK"
    return 1
  fi

  log ">>> Installing: $app${flavor:+ ($flavor)}"
  if adb -s "$EMULATOR" install -r "$APK" > /dev/null 2>&1; then
    success "$app${flavor:+ ($flavor)}"
  else
    error "$app${flavor:+ ($flavor)} installation failed"
    return 1
  fi
}

# Single-flavor apps
flutter_install AutoLoan ca
flutter_install AutoLoan uk
flutter_install AutoLoan us
flutter_install CreditCardAPR
flutter_install HELOCApp
flutter_install JobOfferUS
flutter_install LoanPayoffUS
flutter_install MortgageCA
flutter_install MortgageUK
flutter_install MortgageUS
flutter_install ParkSmart
flutter_install PropertyROISuite
flutter_install RentBuyUS
flutter_install RentalExpenses
flutter_install rideprofit
flutter_install SalaryApp ca
flutter_install SalaryApp uk
flutter_install SalaryApp us
flutter_install StudentLoan

# ── KOTLIN/ANDROID APPS ──────────────────────────────────────────────────────

kotlin_install() {
  local app=$1

  log ">>> Building Kotlin: $app"
  cd "/d/mob/$app" || { error "Directory not found: $app"; return 1; }

  if ! cmd.exe /c "gradlew.bat assembleDebug" > /tmp/gradle.log 2>&1; then
    error "$app gradle build failed"
    tail -10 /tmp/gradle.log >> "$LOG"
    return 1
  fi

  APK="app/build/outputs/apk/debug/app-debug.apk"
  if [ ! -f "$APK" ]; then
    error "$app: APK not found at $APK"
    return 1
  fi

  log ">>> Installing: $app"
  if adb -s "$EMULATOR" install -r "$APK" > /dev/null 2>&1; then
    success "$app"
  else
    error "$app installation failed"
    return 1
  fi
}

kotlin_install TaxeCA
kotlin_install TaxUS
kotlin_install TaxeUK

# ── SUMMARY ──────────────────────────────────────────────────────────────────

log ""
if [ $ERRORS -eq 0 ]; then
  log "=== ALL APPS INSTALLED SUCCESSFULLY ==="
  log "Check your emulator - all 22 apps should now be installed!"
else
  log "=== INSTALLATION COMPLETE WITH $ERRORS ERRORS ==="
  log "Review errors above and retry failed apps"
fi

log "Log saved to: $LOG"
