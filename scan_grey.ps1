$apps = Get-ChildItem 'D:\mob' -Directory | Select-Object -ExpandProperty Name
foreach ($app in $apps) {
    $libPath = "D:\mob\$app\lib"
    if (-not (Test-Path $libPath)) { continue }
    $matches = Get-ChildItem -Path $libPath -Recurse -Include '*.dart' -ErrorAction SilentlyContinue |
        Select-String -Pattern 'Colors\.grey' |
        Where-Object { $_.Line -notlike '*PdfColors*' -and $_.Line -notlike '//*' }
    if ($matches -and $matches.Count -gt 0) {
        Write-Output "--- $app ($($matches.Count) violations) ---"
        $matches | ForEach-Object { Write-Output "  $($_.Filename):$($_.LineNumber) => $($_.Line.Trim())" }
    }
}
