#!/bin/bash
# Quick check of installed portfolio apps
echo "Checking installed apps on emulator..."
COUNT=$(adb -s emulator-5554 shell pm list packages | grep -cE "calculator|taxeca|taxus|taxeuk|mortgage|rentbuy|salary|autoloan|credit|heloc|loan|parking|student|property|profit|jobofferus")
echo "✅ $COUNT portfolio apps installed"
echo ""
echo "Installed apps:"
adb -s emulator-5554 shell pm list packages | grep -E "calculator|taxeca|taxus|taxeuk|mortgage|rentbuy|salary|autoloan|credit|heloc|loan|parking|student|property|profit|jobofferus" | sed 's/package:/  - /' | sort
