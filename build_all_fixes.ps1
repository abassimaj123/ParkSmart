param()

$flutterApps = @(
    'D:\mob\CreditCardAPR',
    'D:\mob\RefinanceApp',
    'D:\mob\RentalROI',
    'D:\mob\RentalExpenses',
    'D:\mob\AutoLoan',
    'D:\mob\SalaryApp',
    'D:\mob\BRRRRCalc',
    'D:\mob\AffordabilityUS',
    'D:\mob\CapRate',
    'D:\mob\HELOCApp',
    'D:\mob\HouseFlip',
    'D:\mob\LandlordCashFlow',
    'D:\mob\LoanPayoffUS',
    'D:\mob\MortgageCA',
    'D:\mob\MortgageExtraPayment',
    'D:\mob\MortgageUK',
    'D:\mob\MortgageUS',
    'D:\mob\PropertyROI',
    'D:\mob\RentBuyUS',
    'D:\mob\StudentLoan',
    'D:\mob\rideprofit',
    'D:\mob\ParkSmart'
)

$pkgMap = @{
    'CreditCardAPR'       = @{ pkg=@('com.creditcard.us.calculator');        apks=@('app-debug.apk') }
    'RefinanceApp'        = @{ pkg=@('com.refinance.us.calculator');         apks=@('app-debug.apk') }
    'RentalROI'           = @{ pkg=@('com.rentalroi.us.calculator');         apks=@('app-debug.apk') }
    'RentalExpenses'      = @{ pkg=@('com.rentalexpenses.us.calculator');    apks=@('app-debug.apk') }
    'AutoLoan'            = @{ pkg=@('com.autoloan.us.calculator','com.autoloan.ca.calculator','com.autoloan.uk.calculator'); apks=@('app-us-debug.apk','app-ca-debug.apk','app-uk-debug.apk') }
    'SalaryApp'           = @{ pkg=@('com.salary.us.calculator','com.salary.ca.calculator','com.salary.uk.calculator');      apks=@('app-us-debug.apk','app-ca-debug.apk','app-uk-debug.apk') }
    'BRRRRCalc'           = @{ pkg=@('com.brrrr.us.calculator');             apks=@('app-debug.apk') }
    'AffordabilityUS'     = @{ pkg=@('com.affordability.us.calculator');     apks=@('app-debug.apk') }
    'CapRate'             = @{ pkg=@('com.caprate.us.calculator');           apks=@('app-debug.apk') }
    'HELOCApp'            = @{ pkg=@('com.heloc.us.calculator');             apks=@('app-debug.apk') }
    'HouseFlip'           = @{ pkg=@('com.houseflip.us.calculator');         apks=@('app-debug.apk') }
    'LandlordCashFlow'    = @{ pkg=@('com.landlord.cashflow.calculator');    apks=@('app-debug.apk') }
    'LoanPayoffUS'        = @{ pkg=@('com.loanpayoff.us.calculator');        apks=@('app-debug.apk') }
    'MortgageCA'          = @{ pkg=@('com.mortgageca.calculator');           apks=@('app-debug.apk') }
    'MortgageExtraPayment'= @{ pkg=@('com.calqwise.mortgageextrapayment');   apks=@('app-debug.apk') }
    'MortgageUK'          = @{ pkg=@('com.mortgageuk.calculator');           apks=@('app-debug.apk') }
    'MortgageUS'          = @{ pkg=@('com.mortgageus.calculator');           apks=@('app-debug.apk') }
    'PropertyROI'         = @{ pkg=@('com.propertyroi.us.calculator');       apks=@('app-debug.apk') }
    'RentBuyUS'           = @{ pkg=@('com.rentbuy.us.calculator');           apks=@('app-debug.apk') }
    'StudentLoan'         = @{ pkg=@('com.studentloan.us.calculator');       apks=@('app-debug.apk') }
    'rideprofit'          = @{ pkg=@('com.rideprofit.app');                  apks=@('app-debug.apk') }
    'ParkSmart'           = @{ pkg=@('com.parksmart.app');                   apks=@('app-debug.apk') }
}

Write-Host "=========================================="
Write-Host "  BUILD + INSTALL -- ALL FIXED APPS"
Write-Host "=========================================="

$buildOk = 0; $buildFail = 0

foreach ($appPath in $flutterApps) {
    $name = Split-Path $appPath -Leaf
    Write-Host ""
    Write-Host "--- BUILD: $name ---"

    $buildResult = & powershell -NoProfile -Command "
        Set-Location '$appPath'
        flutter build apk --debug 2>&1
    " | Out-String

    $apkRoot = $appPath + '\build\app\outputs\flutter-apk'
    $info = $pkgMap[$name]
    $anyApk = $false
    foreach ($apk in $info.apks) {
        if (Test-Path ($apkRoot + '\' + $apk)) { $anyApk = $true; break }
    }

    if (-not $anyApk) {
        Write-Host "BUILD FAILED: $name"
        $lines = $buildResult -split "`n" | Where-Object { $_ -match 'error|Error' }
        if ($lines.Count -gt 0) { Write-Host "  $($lines[-1].Trim())" }
        $buildFail++
        continue
    }

    Write-Host "BUILD OK: $name"
    $buildOk++

    # Uninstall old
    foreach ($pkg in $info.pkg) {
        $u = adb uninstall $pkg 2>&1 | Out-String
        Write-Host "  UNINSTALL $pkg : $($u.Trim())"
    }

    # Install new
    foreach ($apk in $info.apks) {
        $full = $apkRoot + '\' + $apk
        if (-not (Test-Path $full)) { Write-Host "  SKIP (missing): $apk"; continue }
        $r = adb install -r $full 2>&1 | Out-String
        if ($r -like '*Success*') { Write-Host "  INSTALLED: $apk" }
        else { Write-Host "  INSTALL FAIL: $apk => $($r.Trim())" }
    }
}

Write-Host ""
Write-Host "=========================================="
Write-Host "  DONE: $buildOk built OK, $buildFail failed"
Write-Host "=========================================="
Write-Host "  Kotlin apps (build manually if needed):"
Write-Host "    TaxUS:  cd D:\mob\TaxUS  && .\gradlew assembleDebug"
Write-Host "    TaxeUK: cd D:\mob\TaxeUK && .\gradlew assembleDebug"
