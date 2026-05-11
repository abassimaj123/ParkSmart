$apps = @(
    'LoanPayoffUS','MortgageUS','AffordabilityUS','AutoLoan',
    'MortgageCA','MortgageUK','StudentLoan','RentalExpenses',
    'RentBuyUS','LandlordCashFlow','MortgageExtraPayment','PropertyROI',
    'ParkSmart','RefinanceApp','RentalROI'
)
foreach ($app in $apps) {
    $apk = "D:\mob\$app\build\app\outputs\flutter-apk\app-debug.apk"
    if (Test-Path $apk) {
        $result = adb install -r $apk 2>&1 | Out-String
        if ($result -like '*Success*') {
            Write-Output "INSTALLED: $app"
        } else {
            Write-Output "FAILED: $app => $result"
        }
    } else {
        Write-Output "SKIPPED (no APK): $app"
    }
}
