# Install all APKs - force reinstall (uninstall first if signature mismatch)
$apkPaths = @(
    'D:\mob\AffordabilityUS\build\app\outputs\flutter-apk\app-debug.apk',
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
    'D:\mob\SalaryApp\build\app\outputs\flutter-apk\app-debug.apk',
    'D:\mob\StudentLoan\build\app\outputs\flutter-apk\app-debug.apk',
    # AutoLoan flavors
    'D:\mob\AutoLoan\build\app\outputs\flutter-apk\app-us-debug.apk',
    'D:\mob\AutoLoan\build\app\outputs\flutter-apk\app-ca-debug.apk',
    'D:\mob\AutoLoan\build\app\outputs\flutter-apk\app-uk-debug.apk',
    # SalaryApp flavors
    'D:\mob\SalaryApp\build\app\outputs\flutter-apk\app-us-debug.apk',
    'D:\mob\SalaryApp\build\app\outputs\flutter-apk\app-ca-debug.apk',
    'D:\mob\SalaryApp\build\app\outputs\flutter-apk\app-uk-debug.apk'
)

$installed = 0
$failed = 0
$skipped = 0

foreach ($apk in $apkPaths) {
    $name = Split-Path $apk -Leaf
    $app  = (Split-Path (Split-Path (Split-Path (Split-Path $apk -Parent) -Parent) -Parent) -Parent) | Split-Path -Leaf
    if (-not (Test-Path $apk)) {
        Write-Host "SKIP: $app/$name"
        $skipped++
        continue
    }
    $result = adb install -r $apk 2>&1 | Out-String
    if ($result -like '*Success*') {
        Write-Host "INSTALLED: $app/$name"
        $installed++
    } elseif ($result -like '*INCOMPATIBLE*' -or $result -like '*signatures do not match*') {
        # Signature mismatch: uninstall first (need package name from result)
        $pkg = [regex]::Match($result, "Package ([^\s]+) ").Groups[1].Value
        if (-not $pkg) {
            # Try getting pkg from path pattern
            Write-Host "SIG MISMATCH - need manual uninstall: $app/$name"
            $failed++
        } else {
            adb uninstall $pkg 2>&1 | Out-Null
            $r2 = adb install $apk 2>&1 | Out-String
            if ($r2 -like '*Success*') { Write-Host "INSTALLED (after uninstall): $app/$name"; $installed++ }
            else { Write-Host "FAILED: $app/$name => $($r2.Trim())"; $failed++ }
        }
    } else {
        Write-Host "FAILED: $app/$name => $($result.Trim())"
        $failed++
    }
}
Write-Host ""
Write-Host "=== DONE: $installed installed, $failed failed, $skipped skipped ==="
