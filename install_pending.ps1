param()
# Install the 3 apps that failed due to phone disconnect during CMP batch

$pending = @(
    'D:\mob\SalaryApp\build\app\outputs\flutter-apk\app-us-debug.apk',
    'D:\mob\SalaryApp\build\app\outputs\flutter-apk\app-ca-debug.apk',
    'D:\mob\SalaryApp\build\app\outputs\flutter-apk\app-uk-debug.apk',
    'D:\mob\StudentLoan\build\app\outputs\flutter-apk\app-debug.apk',
    'D:\mob\rideprofit\build\app\outputs\flutter-apk\app-debug.apk'
)

$devs = adb devices 2>&1 | Out-String
if ($devs -notmatch 'device') { Write-Host "No device connected. Reconnect USB and retry."; exit 1 }

foreach ($apk in $pending) {
    $name = Split-Path $apk -Leaf
    if (-not (Test-Path $apk)) { Write-Host "SKIP (missing): $name"; continue }
    $r = adb install -r $apk 2>&1 | Out-String
    if ($r -like '*Success*') { Write-Host "INSTALLED: $name" }
    else { Write-Host "FAIL: $name => $($r.Trim())" }
}
Write-Host "Done."
