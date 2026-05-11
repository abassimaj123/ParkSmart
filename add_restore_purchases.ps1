$files = @(
    'D:\mob\rideprofit\lib\widgets\paywall_hard.dart',
    'D:\mob\LoanPayoffUS\lib\presentation\widgets\paywall_hard.dart',
    'D:\mob\BRRRRCalc\lib\widgets\paywall_hard.dart',
    'D:\mob\AffordabilityUS\lib\widgets\paywall_hard.dart',
    'D:\mob\AutoLoan\lib\widgets\paywall_hard.dart',
    'D:\mob\CapRate\lib\widgets\paywall_hard.dart',
    'D:\mob\CreditCardAPR\lib\widgets\paywall_hard.dart',
    'D:\mob\HELOCApp\lib\widgets\paywall_hard.dart',
    'D:\mob\HouseFlip\lib\widgets\paywall_hard.dart',
    'D:\mob\LandlordCashFlow\lib\widgets\paywall_hard.dart',
    'D:\mob\MortgageCA\lib\widgets\paywall_hard.dart',
    'D:\mob\MortgageExtraPayment\lib\widgets\paywall_hard.dart',
    'D:\mob\MortgageUK\lib\presentation\widgets\paywall_hard.dart',
    'D:\mob\MortgageUS\lib\presentation\widgets\paywall_hard.dart',
    'D:\mob\PropertyROI\lib\widgets\paywall_hard.dart',
    'D:\mob\RefinanceApp\lib\widgets\paywall_hard.dart',
    'D:\mob\RentalExpenses\lib\widgets\paywall_hard.dart',
    'D:\mob\RentalROI\lib\widgets\paywall_hard.dart',
    'D:\mob\RentBuyUS\lib\presentation\widgets\paywall_hard.dart',
    'D:\mob\SalaryApp\lib\widgets\paywall_hard.dart',
    'D:\mob\StudentLoan\lib\widgets\paywall_hard.dart'
)

$count = 0
foreach ($file in $files) {
    if (-not (Test-Path $file)) { Write-Host "MISSING: $file"; continue }

    $content = [System.IO.File]::ReadAllText($file, [System.Text.Encoding]::UTF8)

    # Skip if Restore Purchases already present
    if ($content -match 'Restore Purchases') {
        Write-Host "SKIP (already done): $(Split-Path $file -Leaf)"
        continue
    }

    # Detect line ending style
    $nl = if ($content -match '\r\n') { "`r`n" } else { "`n" }

    # Find the LAST ], in the file — this is always the Column children closing bracket
    $lastBracketIdx = $content.LastIndexOf("],")
    if ($lastBracketIdx -lt 0) { Write-Host "ERROR no ], found: $file"; continue }

    # Position of the start of that line (character after the last \n before ],)
    $newlineIdx = $content.LastIndexOf("`n", $lastBracketIdx)
    $lineStart = if ($newlineIdx -ge 0) { $newlineIdx + 1 } else { 0 }

    # Extract indent of the ], line (= the spaces before ],)
    $indent = $content.Substring($lineStart, $lastBracketIdx - $lineStart)
    # Children are indented 2 more spaces than their parent ],
    $ci = $indent + "  "

    # Build the Restore Purchases TextButton block
    $btn  = "${ci}TextButton(${nl}"
    $btn += "${ci}  onPressed: () => IAPService.instance.restore(),${nl}"
    $btn += "${ci}  child: const Text(${nl}"
    $btn += "${ci}    'Restore Purchases',${nl}"
    $btn += "${ci}    style: TextStyle(color: Color(0xFF94A3B8), fontSize: 12),${nl}"
    $btn += "${ci}  ),${nl}"
    $btn += "${ci}),${nl}"

    # Insert the block immediately before the last ], line
    $newContent = $content.Substring(0, $lineStart) + $btn + $content.Substring($lineStart)

    [System.IO.File]::WriteAllText($file, $newContent, [System.Text.Encoding]::UTF8)
    $count++
    Write-Host "DONE: $(Split-Path $file -Leaf)"
}

Write-Host ""
Write-Host "=== Restore Purchases button added to $count / $($files.Count) files ==="
