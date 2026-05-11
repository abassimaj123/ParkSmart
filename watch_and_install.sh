#!/bin/bash
DEVICE="RFCX20661WW"

install_when_ready() {
  local name=$1; local apk=$2; local installed_flag="/tmp/installed_$name"
  [ -f "$installed_flag" ] && return
  [ ! -f "$apk" ] && return
  echo "▶ Installing: $name"
  adb -s $DEVICE install -r "$apk" 2>&1 | tail -2
  touch "$installed_flag"
}

while true; do
  install_when_ready "RentalROI"       "/d/mob/RentalROI/build/app/outputs/apk/debug/app-debug.apk"
  install_when_ready "LandlordCashFlow" "/d/mob/LandlordCashFlow/build/app/outputs/apk/debug/app-debug.apk"
  install_when_ready "CapRate"          "/d/mob/CapRate/build/app/outputs/apk/debug/app-debug.apk"
  install_when_ready "BRRRRCalc"       "/d/mob/BRRRRCalc/build/app/outputs/apk/debug/app-debug.apk"
  install_when_ready "RentalExpenses"   "/d/mob/RentalExpenses/build/app/outputs/apk/debug/app-debug.apk"
  install_when_ready "SalaryApp-US"     "/d/mob/SalaryApp/build/app/outputs/flutter-apk/app-us-debug.apk"
  install_when_ready "SalaryApp-UK"     "/d/mob/SalaryApp/build/app/outputs/flutter-apk/app-uk-debug.apk"
  install_when_ready "rideprofit"       "/d/mob/rideprofit/build/app/outputs/flutter-apk/app-debug.apk"

  # Check if all done
  all_done=true
  for f in RentalROI LandlordCashFlow CapRate BRRRRCalc RentalExpenses SalaryApp-US SalaryApp-UK rideprofit; do
    [ ! -f "/tmp/installed_$f" ] && all_done=false
  done
  $all_done && { echo "All done!"; break; }
  sleep 30
done
