# Uninstall all portfolio apps then reinstall fresh APKs

$packages = @(
    'com.affordability.us.calculator',
    'com.autoloan.ca.calculator',
    'com.autoloan.uk.calculator',
    'com.autoloan.us.calculator',
    'com.brrrr.us.calculator',
    'com.calqwise.mortgageextrapayment',
    'com.caprate.us.calculator',
    'com.creditcard.us.calculator',
    'com.heloc.us.calculator',
    'com.houseflip.us.calculator',
    'com.landlord.cashflow.calculator',
    'com.loanpayoff.us.calculator',
    'com.mortgageca.calculator',
    'com.mortgageus.calculator',
    'com.mortgageuk.calculator',
    'com.parksmart.app',
    'com.propertyroi.us.calculator',
    'com.refinance.us.calculator',
    'com.rentalexpenses.us.calculator',
    'com.rentalroi.us.calculator',
    'com.rentbuy.us.calculator',
    'com.rideprofit.app',
    'com.salary.ca.calculator',
    'com.salary.uk.calculator',
    'com.salary.us.calculator',
    'com.studentloan.us.calculator',
    'com.taxca.calculator',
    'com.taxeuk.calculator',
    'com.taxus.calculator'
)

Write-Host "=== UNINSTALLING ==="
foreach ($pkg in $packages) {
    $r = adb uninstall $pkg 2>&1 | Out-String
    if ($r -like '*Success*') { Write-Host "  REMOVED: $pkg" }
    else { Write-Host "  SKIP: $pkg (not installed)" }
}

Write-Host ""
Write-Host "=== INSTALLING ==="

$apks = @(
    'D:\mob\AffordabilityUS\build\app\outputs\flutter-apk\app-debug.apk',
    'D:\mob\AutoLoan\build\app\outputs\flutter-apk\app-us-debug.apk',
    'D:\mob\AutoLoan\build\app\outputs\flutter-apk\app-ca-debug.apk',
    'D:\mob\AutoLoan\build\app\outputs\flutter-apk\app-uk-debug.apk',
    'D:\mob\BRRRRCalc\build\app\outputs\flutter-apk\app-debug.apk',
    'D:\mob\CapRate\build\app\outputs\flutter-apk\app-debug.apk',
    'D:\mob\CreditCardAPR\build\app\outputs\flutter-apk\app-debug.apk',
    'D:\mob\HELOCApp\build\app\outputs\flutter-apk\app-debug.apk',
    'D:\mob\HouseFlip\build\app\outputs\flutter-apk\app-debug.apk',
    'D:\mob\LandlordCashFlow\build\app\outputs\flutter-apk\app-debug.apk',
    'D:\mob\LoanPayoffUS\build\app\outputs\flutter-apk\app-debug.apk',
    'D:\mob\MortgageCA\build\app\outputs\flutter-apk\app-debug.apk',
    'D:\mob\MortgageExtraPayment\build\app\outputs\flutter-apk\app-debug.apk',
    'D:\mob\MortgageUK\build\app\outputs\flutter-apk\app-debug.apk',
    'D:\mob\MortgageUS\build\app\outputs\flutter-apk\app-debug.apk',
    'D:\mob\ParkSmart\build\app\outputs\flutter-apk\app-debug.apk',
    'D:\mob\PropertyROI\build\app\outputs\flutter-apk\app-debug.apk',
    'D:\mob\RefinanceApp\build\app\outputs\flutter-apk\app-debug.apk',
    'D:\mob\RentalExpenses\build\app\outputs\flutter-apk\app-debug.apk',
    'D:\mob\RentalROI\build\app\outputs\flutter-apk\app-debug.apk',
    'D:\mob\RentBuyUS\build\app\outputs\flutter-apk\app-debug.apk',
    'D:\mob\rideprofit\build\app\outputs\flutter-apk\app-debug.apk',
    'D:\mob\SalaryApp\build\app\outputs\flutter-apk\app-us-debug.apk',
    'D:\mob\SalaryApp\build\app\outputs\flutter-apk\app-ca-debug.apk',
    'D:\mob\SalaryApp\build\app\outputs\flutter-apk\app-uk-debug.apk',
    'D:\mob\StudentLoan\build\app\outputs\flutter-apk\app-debug.apk'
)

$ok = 0; $fail = 0; $skip = 0
foreach ($apk in $apks) {
    $name = (Split-Path $apk -Leaf)
    $app  = Split-Path (Split-Path (Split-Path (Split-Path (Split-Path $apk -Parent) -Parent) -Parent) -Parent) -Leaf
    if (-not (Test-Path $apk)) { Write-Host "  SKIP (no APK): $app/$name"; $skip++; continue }
    $r = adb install $apk 2>&1 | Out-String
    if ($r -like '*Success*') { Write-Host "  OK: $app/$name"; $ok++ }
    else { Write-Host "  FAIL: $app/$name => $($r.Trim())"; $fail++ }
}

Write-Host ""
Write-Host "=== DONE: $ok installed, $fail failed, $skip skipped ==="
