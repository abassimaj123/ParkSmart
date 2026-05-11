param()

$mainDarts = @(
    'D:\mob\AffordabilityUS\lib\main.dart',
    'D:\mob\BRRRRCalc\lib\main.dart',
    'D:\mob\CapRate\lib\main.dart',
    'D:\mob\CreditCardAPR\lib\main.dart',
    'D:\mob\HELOCApp\lib\main.dart',
    'D:\mob\HouseFlip\lib\main.dart',
    'D:\mob\LandlordCashFlow\lib\main.dart',
    'D:\mob\LoanPayoffUS\lib\main.dart',
    'D:\mob\MortgageCA\lib\main.dart',
    'D:\mob\MortgageExtraPayment\lib\main.dart',
    'D:\mob\MortgageUK\lib\main.dart',
    'D:\mob\MortgageUS\lib\main.dart',
    'D:\mob\PropertyROI\lib\main.dart',
    'D:\mob\RefinanceApp\lib\main.dart',
    'D:\mob\RentalExpenses\lib\main.dart',
    'D:\mob\RentalROI\lib\main.dart',
    'D:\mob\SalaryApp\lib\main.dart',
    'D:\mob\StudentLoan\lib\main.dart',
    'D:\mob\rideprofit\lib\main.dart'
)

# Load the consent function template from the external .dart file
$consentFn = [System.IO.File]::ReadAllText('D:\mob\_consent_fn.dart', [System.Text.Encoding]::UTF8)

$count = 0

foreach ($file in $mainDarts) {
    if (-not (Test-Path $file)) { Write-Host "MISSING: $file"; continue }

    $content = [System.IO.File]::ReadAllText($file, [System.Text.Encoding]::UTF8)

    # Skip if already has consent
    if ($content -match '_requestConsent|ConsentInformation') {
        $appName = Split-Path (Split-Path (Split-Path $file -Parent) -Parent) -Leaf
        Write-Host "SKIP: $appName (already has consent)"
        continue
    }

    $nl = if ($content -match "`r`n") { "`r`n" } else { "`n" }
    $appName = Split-Path (Split-Path (Split-Path $file -Parent) -Parent) -Leaf

    # Step 1 - Add dart:async import if missing
    if ($content -notmatch "import 'dart:async'") {
        $firstImport = $content.IndexOf("import '")
        if ($firstImport -ge 0) {
            $importLine = "import 'dart:async';" + $nl
            $content = $content.Substring(0, $firstImport) + $importLine + $content.Substring($firstImport)
        }
    }

    # Step 2 - Insert 'await _requestConsent();' before AdMob init
    $inserted = $false

    $searchStr = "await MobileAds.instance.initialize()"
    $idx = $content.IndexOf($searchStr)
    if ($idx -ge 0) {
        $lineStart = $content.LastIndexOf("`n", $idx) + 1
        $indent = ""
        $p = $lineStart
        while ($p -lt $idx -and ($content[$p] -eq " " -or $content[$p] -eq "`t")) {
            $indent += $content[$p]
            $p++
        }
        $insertLine = $indent + "await _requestConsent();" + $nl
        $content = $content.Substring(0, $lineStart) + $insertLine + $content.Substring($lineStart)
        $inserted = $true
    }

    if (-not $inserted) {
        $searchStr2 = "await AdService.instance.initialize()"
        $idx2 = $content.IndexOf($searchStr2)
        if ($idx2 -ge 0) {
            $lineStart = $content.LastIndexOf("`n", $idx2) + 1
            $indent = ""
            $p = $lineStart
            while ($p -lt $idx2 -and ($content[$p] -eq " " -or $content[$p] -eq "`t")) {
                $indent += $content[$p]
                $p++
            }
            $insertLine = $indent + "await _requestConsent();" + $nl
            $content = $content.Substring(0, $lineStart) + $insertLine + $content.Substring($lineStart)
            $inserted = $true
        }
    }

    if (-not $inserted) {
        Write-Host "WARN: No AdMob init found in $appName - skipping"
        continue
    }

    # Step 3 - Append the _requestConsent() function to the end of the file
    $content = $content.TrimEnd() + $nl + $consentFn

    [System.IO.File]::WriteAllText($file, $content, [System.Text.Encoding]::UTF8)
    $count++
    Write-Host "DONE: $appName"
}

Write-Host ""
Write-Host "=== CMP consent added to $count of $($mainDarts.Count) files ==="
