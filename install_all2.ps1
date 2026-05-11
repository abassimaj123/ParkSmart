$apps = @(
    'AffordabilityUS','BRRRRCalc','CapRate','CreditCardAPR',
    'HELOCApp','HouseFlip','LandlordCashFlow','LoanPayoffUS',
    'MortgageCA','MortgageExtraPayment','MortgageUK','MortgageUS',
    'ParkSmart','PropertyROI','RefinanceApp','RentalExpenses',
    'RentalROI','RentBuyUS','rideprofit','SalaryApp',
    'StudentLoan','AutoLoan'
)

$installed = @()
$failed = @()
$skipped = @()

foreach ($app in $apps) {
    $apk = "D:\mob\$app\build\app\outputs\flutter-apk\app-debug.apk"
    if (-not (Test-Path $apk)) {
        Write-Host "SKIP (no APK): $app"
        $skipped += $app
        continue
    }

    # Uninstall existing (ignore errors)
    $pkgLine = & aapt dump badging $apk 2>&1 | Select-String "^package:"
    if ($pkgLine) {
        $pkg = [regex]::Match($pkgLine, "name='([^']+)'").Groups[1].Value
        if ($pkg) {
            adb uninstall $pkg 2>&1 | Out-Null
            Write-Host "UNINSTALLED: $pkg"
        }
    }

    $result = adb install -r $apk 2>&1 | Out-String
    if ($result -like '*Success*') {
        Write-Host "INSTALLED: $app"
        $installed += $app
    } else {
        Write-Host "FAILED: $app => $($result.Trim())"
        $failed += $app
    }
}

Write-Host ""
Write-Host "=== INSTALL SUMMARY ==="
Write-Host "Installed ($($installed.Count)): $($installed -join ', ')"
Write-Host "Failed    ($($failed.Count)):    $($failed -join ', ')"
Write-Host "Skipped   ($($skipped.Count)):   $($skipped -join ', ')"
