$apps = @(
    'AffordabilityUS','AutoLoan','CapRate','CreditCardAPR',
    'HELOCApp','HouseFlip','LandlordCashFlow','LoanPayoffUS',
    'MortgageCA','MortgageExtraPayment','MortgageUK','MortgageUS',
    'ParkSmart','PropertyROI','RefinanceApp','RentalExpenses',
    'RentalROI','RentBuyUS','rideprofit','SalaryApp',
    'StudentLoan','TaxeCA'
)

$built = @()
$failed = @()

foreach ($app in $apps) {
    $appPath = "D:\mob\$app"
    if (-not (Test-Path "$appPath\pubspec.yaml")) {
        Write-Output "SKIP (no pubspec): $app"
        continue
    }
    Write-Output "--- BUILD: $app ---"
    $result = & powershell -Command "Set-Location '$appPath'; flutter build apk --debug 2>&1" | Out-String
    if ($LASTEXITCODE -eq 0 -or $result -like '*Built build*') {
        Write-Output "OK: $app"
        $built += $app
    } else {
        Write-Output "FAIL: $app => $($result[-200..-1] -join '')"
        $failed += $app
    }
}

Write-Output ""
Write-Output "=== SUMMARY ==="
Write-Output "Built ($($built.Count)): $($built -join ', ')"
Write-Output "Failed ($($failed.Count)): $($failed -join ', ')"
