$apps = @('CreditCardAPR','RefinanceApp','RentalROI','AutoLoan','SalaryApp')

foreach ($app in $apps) {
    $path = "D:\mob\$app"
    Write-Host "--- BUILD: $app ---"
    $result = & powershell -NoProfile -Command "Set-Location '$path'; flutter build apk --debug 2>&1" | Out-String
    if ($result -like '*Built build*' -or $result -like '*flutter-apk*') {
        Write-Host "OK: $app"
    } else {
        $err = ($result -split "`n" | Where-Object { $_ -like '*error*' -or $_ -like '*Error*' } | Select-Object -Last 1)
        Write-Host "CHECK: $app (may use flavors)"
    }
}

Write-Host ""
Write-Host "--- INSTALLING ---"

$apks = @(
    'D:\mob\CreditCardAPR\build\app\outputs\flutter-apk\app-debug.apk',
    'D:\mob\RefinanceApp\build\app\outputs\flutter-apk\app-debug.apk',
    'D:\mob\RentalROI\build\app\outputs\flutter-apk\app-debug.apk',
    'D:\mob\AutoLoan\build\app\outputs\flutter-apk\app-us-debug.apk',
    'D:\mob\AutoLoan\build\app\outputs\flutter-apk\app-ca-debug.apk',
    'D:\mob\AutoLoan\build\app\outputs\flutter-apk\app-uk-debug.apk',
    'D:\mob\SalaryApp\build\app\outputs\flutter-apk\app-us-debug.apk',
    'D:\mob\SalaryApp\build\app\outputs\flutter-apk\app-ca-debug.apk',
    'D:\mob\SalaryApp\build\app\outputs\flutter-apk\app-uk-debug.apk'
)

foreach ($apk in $apks) {
    $name = Split-Path $apk -Leaf
    if (-not (Test-Path $apk)) { Write-Host "SKIP: $name"; continue }
    $r = adb install -r $apk 2>&1 | Out-String
    if ($r -like '*Success*') { Write-Host "INSTALLED: $name" }
    else { Write-Host "FAILED: $name => $($r.Trim())" }
}
Write-Host "--- DONE ---"
