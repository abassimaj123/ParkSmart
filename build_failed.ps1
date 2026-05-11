$apps = @(
    'AutoLoan','HELOCApp','HouseFlip','LandlordCashFlow',
    'LoanPayoffUS','PropertyROI','RefinanceApp','RentalExpenses',
    'RentalROI','SalaryApp','StudentLoan'
)

$built = @()
$failed = @()

foreach ($app in $apps) {
    $appPath = "D:\mob\$app"
    Write-Host "--- BUILD: $app ---"
    $result = & powershell -NoProfile -Command "Set-Location '$appPath'; flutter build apk --debug 2>&1" | Out-String
    if ($result -like '*Built build*' -or $result -like '*build\app\outputs*') {
        Write-Host "OK: $app"
        $built += $app
    } else {
        # Extract last error line
        $lines = $result -split "`n"
        $errLine = ($lines | Where-Object { $_ -like '*Error*' -or $_ -like '*failed*' } | Select-Object -Last 1)
        Write-Host "FAIL: $app => $errLine"
        $failed += $app
    }
}

Write-Host ""
Write-Host "=== SUMMARY ==="
Write-Host "Built ($($built.Count)): $($built -join ', ')"
Write-Host "Failed ($($failed.Count)): $($failed -join ', ')"
