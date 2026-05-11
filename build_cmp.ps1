param()

$apps = @(
    @{ path='D:\mob\AffordabilityUS';     pkg=@('com.affordability.us.calculator');     apks=@('app-debug.apk') },
    @{ path='D:\mob\BRRRRCalc';           pkg=@('com.brrrr.us.calculator');             apks=@('app-debug.apk') },
    @{ path='D:\mob\CapRate';             pkg=@('com.caprate.us.calculator');           apks=@('app-debug.apk') },
    @{ path='D:\mob\CreditCardAPR';       pkg=@('com.creditcard.us.calculator');        apks=@('app-debug.apk') },
    @{ path='D:\mob\HELOCApp';            pkg=@('com.heloc.us.calculator');             apks=@('app-debug.apk') },
    @{ path='D:\mob\HouseFlip';           pkg=@('com.houseflip.us.calculator');         apks=@('app-debug.apk') },
    @{ path='D:\mob\LandlordCashFlow';    pkg=@('com.landlord.cashflow.calculator');    apks=@('app-debug.apk') },
    @{ path='D:\mob\LoanPayoffUS';        pkg=@('com.loanpayoff.us.calculator');        apks=@('app-debug.apk') },
    @{ path='D:\mob\MortgageCA';          pkg=@('com.mortgageca.calculator');           apks=@('app-debug.apk') },
    @{ path='D:\mob\MortgageExtraPayment';pkg=@('com.calqwise.mortgageextrapayment');   apks=@('app-debug.apk') },
    @{ path='D:\mob\MortgageUK';          pkg=@('com.mortgageuk.calculator');           apks=@('app-debug.apk') },
    @{ path='D:\mob\MortgageUS';          pkg=@('com.mortgageus.calculator');           apks=@('app-debug.apk') },
    @{ path='D:\mob\PropertyROI';         pkg=@('com.propertyroi.us.calculator');       apks=@('app-debug.apk') },
    @{ path='D:\mob\RefinanceApp';        pkg=@('com.refinance.us.calculator');         apks=@('app-debug.apk') },
    @{ path='D:\mob\RentalExpenses';      pkg=@('com.rentalexpenses.us.calculator');    apks=@('app-debug.apk') },
    @{ path='D:\mob\RentalROI';           pkg=@('com.rentalroi.us.calculator');         apks=@('app-debug.apk') },
    @{ path='D:\mob\SalaryApp';           pkg=@('com.salary.us.calculator','com.salary.ca.calculator','com.salary.uk.calculator'); apks=@('app-us-debug.apk','app-ca-debug.apk','app-uk-debug.apk') },
    @{ path='D:\mob\StudentLoan';         pkg=@('com.studentloan.us.calculator');       apks=@('app-debug.apk') },
    @{ path='D:\mob\rideprofit';          pkg=@('com.rideprofit.app');                  apks=@('app-debug.apk') }
)

Write-Host "========================================"
Write-Host "  BUILD + INSTALL - CMP CONSENT BATCH"
Write-Host "========================================"

$ok = 0; $fail = 0

foreach ($app in $apps) {
    $name = Split-Path $app.path -Leaf
    Write-Host ""
    Write-Host "--- $name ---"

    $buildOut = & powershell -NoProfile -Command "
        Set-Location '$($app.path)'
        flutter build apk --debug 2>&1
    " | Out-String

    $apkRoot = $app.path + '\build\app\outputs\flutter-apk'
    $found = $false
    foreach ($a in $app.apks) {
        if (Test-Path ($apkRoot + '\' + $a)) { $found = $true; break }
    }

    if (-not $found) {
        $errLine = ($buildOut -split "`n" | Where-Object { $_ -match 'error|Error' } | Select-Object -Last 1)
        Write-Host "FAIL: $name  $($errLine.Trim())"
        $fail++
        continue
    }

    Write-Host "BUILD OK: $name"
    $ok++

    foreach ($pkg in $app.pkg) {
        adb uninstall $pkg 2>&1 | Out-Null
    }

    foreach ($a in $app.apks) {
        $full = $apkRoot + '\' + $a
        if (-not (Test-Path $full)) { Write-Host "  SKIP: $a"; continue }
        $r = adb install -r $full 2>&1 | Out-String
        if ($r -like '*Success*') { Write-Host "  INSTALLED: $a" }
        else { Write-Host "  FAIL: $a => $($r.Trim())" }
    }
}

Write-Host ""
Write-Host "========================================"
Write-Host "  RESULT: $ok OK, $fail FAILED"
Write-Host "========================================"
