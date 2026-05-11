$apps = Get-ChildItem 'D:\mob' -Directory | Select-Object -ExpandProperty Name
$fixed = 0
$correct_xml = @"
<?xml version="1.0" encoding="utf-8"?>
<layer-list xmlns:android="http://schemas.android.com/apk/res/android">
    <item android:drawable="@color/splash_bg" />
</layer-list>
"@
foreach ($app in $apps) {
    $resPath = "D:\mob\$app\android\app\src\main\res"
    if (-not (Test-Path $resPath)) { continue }
    $colorsFile = "$resPath\values\colors.xml"
    if (-not (Test-Path $colorsFile)) { continue }
    if ((Get-Content $colorsFile -Raw) -notlike '*splash_bg*') { continue }
    $drawableFiles = Get-ChildItem -Path $resPath -Recurse -Filter 'launch_background.xml' -ErrorAction SilentlyContinue
    foreach ($f in $drawableFiles) {
        $content = Get-Content -Path $f.FullName -Raw
        $needsFix = ($content -like '*@android:color/white*') -or
                    ($content -like '*?android:colorBackground*' -and $content -like '*layer-list*') -or
                    ($content -like '*@drawable/background*')
        if ($needsFix) {
            Set-Content -Path $f.FullName -Value $correct_xml -NoNewline
            Write-Output "FIXED: $($f.FullName)"
            $fixed++
        }
    }
}
Write-Output "--- Done: $fixed drawable files fixed ---"
