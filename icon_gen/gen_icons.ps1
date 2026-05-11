Add-Type -AssemblyName System.Drawing

$fontPath = "C:\Users\DALI\AppData\Local\Pub\Cache\hosted\pub.dev\provider-6.1.5+1\extension\devtools\build\assets\fonts\MaterialIcons-Regular.otf"

# Load font
$pfc = New-Object System.Drawing.Text.PrivateFontCollection
$pfc.AddFontFile($fontPath)
$family = $pfc.Families[0]

# Icon unicode codepoints
# home_work = 0xE9C3, monetization_on = 0xE263
$icons = @{
    "rentbuy"  = @{ char = [char]0xE9C3; bg1 = "0,137,123"; bg2 = "0,77,64";   path = "D:\mob\RentBuyUS" }
    "loanpayoff" = @{ char = [char]0xE263; bg1 = "81,45,168"; bg2 = "49,27,146"; path = "D:\mob\LoanPayoffUS" }
}

$densities = @{
    "mipmap-mdpi"    = 48
    "mipmap-hdpi"    = 72
    "mipmap-xhdpi"   = 96
    "mipmap-xxhdpi"  = 144
    "mipmap-xxxhdpi" = 192
}

function Make-RoundedRect {
    param($g, $x, $y, $w, $h, $r, $brush)
    $path = New-Object System.Drawing.Drawing2D.GraphicsPath
    $path.AddArc($x, $y, $r*2, $r*2, 180, 90)
    $path.AddArc($x+$w-$r*2, $y, $r*2, $r*2, 270, 90)
    $path.AddArc($x+$w-$r*2, $y+$h-$r*2, $r*2, $r*2, 0, 90)
    $path.AddArc($x, $y+$h-$r*2, $r*2, $r*2, 90, 90)
    $path.CloseFigure()
    $g.FillPath($brush, $path)
    $path.Dispose()
}

function Generate-Icon {
    param($size, $charCode, $bg1Str, $bg2Str)

    $bmp = New-Object System.Drawing.Bitmap($size, $size, [System.Drawing.Imaging.PixelFormat]::Format32bppArgb)
    $g = [System.Drawing.Graphics]::FromImage($bmp)
    $g.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::AntiAlias
    $g.TextRenderingHint = [System.Drawing.Text.TextRenderingHint]::AntiAliasGridFit
    $g.Clear([System.Drawing.Color]::Transparent)

    # Gradient background
    $c1parts = $bg1Str -split ","
    $c2parts = $bg2Str -split ","
    $c1 = [System.Drawing.Color]::FromArgb(255, [int]$c1parts[0], [int]$c1parts[1], [int]$c1parts[2])
    $c2 = [System.Drawing.Color]::FromArgb(255, [int]$c2parts[0], [int]$c2parts[1], [int]$c2parts[2])

    $gradBrush = New-Object System.Drawing.Drawing2D.LinearGradientBrush(
        [System.Drawing.Point]::new(0, 0),
        [System.Drawing.Point]::new($size, $size),
        $c1, $c2)

    $radius = [int]($size * 0.22)
    Make-RoundedRect $g 0 0 $size $size $radius $gradBrush
    $gradBrush.Dispose()

    # White icon glyph centered
    $iconSize = [int]($size * 0.62)
    $font = New-Object System.Drawing.Font($family, $iconSize, [System.Drawing.GraphicsUnit]::Pixel)
    $brush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::White)

    $sf = New-Object System.Drawing.StringFormat
    $sf.Alignment = [System.Drawing.StringAlignment]::Center
    $sf.LineAlignment = [System.Drawing.StringAlignment]::Center

    $rect = New-Object System.Drawing.RectangleF(0, 0, $size, $size)
    $g.DrawString([string]$charCode, $font, $brush, $rect, $sf)

    $font.Dispose()
    $brush.Dispose()
    $g.Dispose()
    return $bmp
}

foreach ($appKey in $icons.Keys) {
    $info = $icons[$appKey]
    Write-Host "Generating $appKey icons..."

    foreach ($density in $densities.Keys) {
        $size = $densities[$density]
        $bmp = Generate-Icon $size $info.char $info.bg1 $info.bg2

        $outDir = "$($info.path)\android\app\src\main\res\$density"
        if (-not (Test-Path $outDir)) { New-Item -ItemType Directory -Path $outDir | Out-Null }

        $bmp.Save("$outDir\ic_launcher.png", [System.Drawing.Imaging.ImageFormat]::Png)
        $bmp.Save("$outDir\ic_launcher_round.png", [System.Drawing.Imaging.ImageFormat]::Png)
        $bmp.Dispose()
        Write-Host "  $density ($size x $size)"
    }

    # 512px splash icon
    $big = Generate-Icon 512 $info.char $info.bg1 $info.bg2
    $big.Save("$($info.path)\android\app\src\main\res\drawable\ic_splash.png",
              [System.Drawing.Imaging.ImageFormat]::Png)
    $big.Dispose()
    Write-Host "  ic_splash.png (512x512)"
}

Write-Host "`nDone!"
