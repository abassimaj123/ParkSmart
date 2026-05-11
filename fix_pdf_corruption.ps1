# Fix: PdfColors.grey was incorrectly mangled by fix_grey.ps1
# PdfColors.grey300 → "Pdf" + "const Color(0xFF64748B)" + "300" = "Pdfconst Color(0xFF64748B)300"
# We revert them all back to PdfColors.greyXXX

$dartFiles = Get-ChildItem 'D:\mob' -Recurse -Include '*.dart' -ErrorAction SilentlyContinue

$totalFixed = 0
foreach ($f in $dartFiles) {
    $content = Get-Content -Path $f.FullName -Raw -ErrorAction SilentlyContinue
    if (-not $content) { continue }
    if ($content -notlike '*Pdfconst Color*') { continue }

    $orig = $content
    # Restore PdfColors.greyNNN (shade numbers)
    $content = [regex]::Replace($content, 'Pdfconst Color\(0xFF64748B\)(\d+)', 'PdfColors.grey$1')
    # Restore bare PdfColors.grey (not followed by digit)
    $content = [regex]::Replace($content, 'Pdfconst Color\(0xFF64748B\)(?!\d)', 'PdfColors.grey')

    if ($content -ne $orig) {
        Set-Content -Path $f.FullName -Value $content -NoNewline
        $totalFixed++
        Write-Output "FIXED: $($f.FullName)"
    }
}
Write-Output "--- Total: $totalFixed files restored ---"
