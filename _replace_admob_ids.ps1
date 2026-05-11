# =============================================================================
# _replace_admob_ids.ps1
# Replace placeholder AdMob IDs with real production IDs across all 17 Flutter apps.
#
# INSTRUCTIONS:
#   1. Go to https://admob.google.com and create ad units for each app.
#   2. Fill in EVERY "REPLACE_ME" value below before running this script.
#   3. Run in PowerShell:  .\D:\mob\_replace_admob_ids.ps1
#
# ID FORMAT:
#   App ID        → ca-app-pub-XXXXXXXXXXXXXXXX~NNNNNNNNNN   (tilde ~)
#   Ad unit IDs   → ca-app-pub-XXXXXXXXXXXXXXXX/NNNNNNNNNN   (slash /)
#
# Publisher account: ca-app-pub-5379540026739666
# =============================================================================

# ── FILL IN YOUR REAL IDs HERE ───────────────────────────────────────────────

$apps = [ordered]@{

    # ── Mortgage calculators ──────────────────────────────────────────────────

    "MortgageUS" = @{
        # MortgageUS uses a flat AdConfig class (no flavors).
        # Its ad IDs live as individual const strings in the file.
        AdConfigPath       = "D:\mob\MortgageUS\lib\core\ads\ad_config.dart"
        Format             = "flat"
        AndroidAppId       = "ca-app-pub-REPLACE_ME~REPLACE_ME"
        iOSAppId           = "ca-app-pub-REPLACE_ME~REPLACE_ME"
        BannerAndroid      = "ca-app-pub-REPLACE_ME/REPLACE_ME"
        InterstitialAndroid= "ca-app-pub-REPLACE_ME/REPLACE_ME"
        RewardedAndroid    = "ca-app-pub-REPLACE_ME/REPLACE_ME"
        BanneriOS          = "ca-app-pub-REPLACE_ME/REPLACE_ME"
        InterstitialiOS    = "ca-app-pub-REPLACE_ME/REPLACE_ME"
        RewardediOS        = "ca-app-pub-REPLACE_ME/REPLACE_ME"
    }

    "MortgageCA" = @{
        AdConfigPath       = "D:\mob\MortgageCA\lib\core\ads\ad_config.dart"
        Format             = "kReleaseMode"
        AndroidAppId       = "ca-app-pub-REPLACE_ME~REPLACE_ME"
        iOSAppId           = "ca-app-pub-REPLACE_ME~REPLACE_ME"
        BannerAndroid      = "ca-app-pub-REPLACE_ME/REPLACE_ME"
        InterstitialAndroid= "ca-app-pub-REPLACE_ME/REPLACE_ME"
        RewardedAndroid    = "ca-app-pub-REPLACE_ME/REPLACE_ME"
        BanneriOS          = "ca-app-pub-REPLACE_ME/REPLACE_ME"
        InterstitialiOS    = "ca-app-pub-REPLACE_ME/REPLACE_ME"
        RewardediOS        = "ca-app-pub-REPLACE_ME/REPLACE_ME"
    }

    "MortgageUK" = @{
        # MortgageUK uses '$_pub/XXXXXXXXXX' style (single-line getters).
        AdConfigPath        = "D:\mob\MortgageUK\lib\core\ads\ad_config.dart"
        Format              = "pubSlash"
        BannerAdUnitId      = "ca-app-pub-REPLACE_ME/REPLACE_ME"
        InterstitialAdUnitId= "ca-app-pub-REPLACE_ME/REPLACE_ME"
        RewardedAdUnitId    = "ca-app-pub-REPLACE_ME/REPLACE_ME"
    }

    # ── Loan calculators ──────────────────────────────────────────────────────

    "AutoLoan" = @{
        # AutoLoan uses per-flavor IDs: CA, UK, US — 12 ad unit IDs + 1 app ID.
        AdConfigPath   = "D:\mob\AutoLoan\lib\core\config\ad_config.dart"
        Format         = "autoloan"
        AppId          = "ca-app-pub-REPLACE_ME~REPLACE_ME"   # shared app ID (or split per flavor)
        BannerCA       = "ca-app-pub-REPLACE_ME/REPLACE_ME"
        BannerUK       = "ca-app-pub-REPLACE_ME/REPLACE_ME"
        BannerUS       = "ca-app-pub-REPLACE_ME/REPLACE_ME"
        InterCA        = "ca-app-pub-REPLACE_ME/REPLACE_ME"
        InterUK        = "ca-app-pub-REPLACE_ME/REPLACE_ME"
        InterUS        = "ca-app-pub-REPLACE_ME/REPLACE_ME"
        RewardedCA     = "ca-app-pub-REPLACE_ME/REPLACE_ME"
        RewardedUK     = "ca-app-pub-REPLACE_ME/REPLACE_ME"
        RewardedUS     = "ca-app-pub-REPLACE_ME/REPLACE_ME"
        AppOpenCA      = "ca-app-pub-REPLACE_ME/REPLACE_ME"
        AppOpenUK      = "ca-app-pub-REPLACE_ME/REPLACE_ME"
        AppOpenUS      = "ca-app-pub-REPLACE_ME/REPLACE_ME"
    }

    "CreditCardAPR" = @{
        AdConfigPath       = "D:\mob\CreditCardAPR\lib\core\ads\ad_config.dart"
        Format             = "kReleaseMode"
        AndroidAppId       = "ca-app-pub-REPLACE_ME~REPLACE_ME"
        iOSAppId           = "ca-app-pub-REPLACE_ME~REPLACE_ME"
        BannerAndroid      = "ca-app-pub-REPLACE_ME/REPLACE_ME"
        InterstitialAndroid= "ca-app-pub-REPLACE_ME/REPLACE_ME"
        RewardedAndroid    = "ca-app-pub-REPLACE_ME/REPLACE_ME"
        BanneriOS          = "ca-app-pub-REPLACE_ME/REPLACE_ME"
        InterstitialiOS    = "ca-app-pub-REPLACE_ME/REPLACE_ME"
        RewardediOS        = "ca-app-pub-REPLACE_ME/REPLACE_ME"
    }

    "HELOCApp" = @{
        AdConfigPath       = "D:\mob\HELOCApp\lib\core\ads\ad_config.dart"
        Format             = "kReleaseMode"
        AndroidAppId       = "ca-app-pub-REPLACE_ME~REPLACE_ME"
        iOSAppId           = "ca-app-pub-REPLACE_ME~REPLACE_ME"
        BannerAndroid      = "ca-app-pub-REPLACE_ME/REPLACE_ME"
        InterstitialAndroid= "ca-app-pub-REPLACE_ME/REPLACE_ME"
        RewardedAndroid    = "ca-app-pub-REPLACE_ME/REPLACE_ME"
        BanneriOS          = "ca-app-pub-REPLACE_ME/REPLACE_ME"
        InterstitialiOS    = "ca-app-pub-REPLACE_ME/REPLACE_ME"
        RewardediOS        = "ca-app-pub-REPLACE_ME/REPLACE_ME"
    }

    "StudentLoan" = @{
        AdConfigPath       = "D:\mob\StudentLoan\lib\core\ads\ad_config.dart"
        Format             = "kReleaseMode"
        AndroidAppId       = "ca-app-pub-REPLACE_ME~REPLACE_ME"
        iOSAppId           = "ca-app-pub-REPLACE_ME~REPLACE_ME"
        BannerAndroid      = "ca-app-pub-REPLACE_ME/REPLACE_ME"
        InterstitialAndroid= "ca-app-pub-REPLACE_ME/REPLACE_ME"
        RewardedAndroid    = "ca-app-pub-REPLACE_ME/REPLACE_ME"
        BanneriOS          = "ca-app-pub-REPLACE_ME/REPLACE_ME"
        InterstitialiOS    = "ca-app-pub-REPLACE_ME/REPLACE_ME"
        RewardediOS        = "ca-app-pub-REPLACE_ME/REPLACE_ME"
    }

    "LoanPayoffUS" = @{
        # LoanPayoffUS embeds IDs directly in ad_service.dart (no ad_config.dart).
        AdConfigPath  = "D:\mob\LoanPayoffUS\lib\core\ads\ad_service.dart"
        Format        = "adService"
        BannerId      = "ca-app-pub-REPLACE_ME/REPLACE_ME"
        InterstitialId= "ca-app-pub-REPLACE_ME/REPLACE_ME"
        RewardedId    = "ca-app-pub-REPLACE_ME/REPLACE_ME"
    }

    # ── Real estate calculators ───────────────────────────────────────────────

    "PropertyROISuite" = @{
        AdConfigPath       = "D:\mob\PropertyROISuite\lib\core\ads\ad_config.dart"
        Format             = "kReleaseMode"
        AndroidAppId       = "ca-app-pub-REPLACE_ME~REPLACE_ME"
        iOSAppId           = "ca-app-pub-REPLACE_ME~REPLACE_ME"
        BannerAndroid      = "ca-app-pub-REPLACE_ME/REPLACE_ME"
        InterstitialAndroid= "ca-app-pub-REPLACE_ME/REPLACE_ME"
        RewardedAndroid    = "ca-app-pub-REPLACE_ME/REPLACE_ME"
        BanneriOS          = "ca-app-pub-REPLACE_ME/REPLACE_ME"
        InterstitialiOS    = "ca-app-pub-REPLACE_ME/REPLACE_ME"
        RewardediOS        = "ca-app-pub-REPLACE_ME/REPLACE_ME"
    }

    "RentalExpenses" = @{
        # RentalExpenses has Android-only IDs (no iOS yet).
        AdConfigPath       = "D:\mob\RentalExpenses\lib\config\ad_config.dart"
        Format             = "androidOnly"
        BannerAndroid      = "ca-app-pub-REPLACE_ME/REPLACE_ME"
        InterstitialAndroid= "ca-app-pub-REPLACE_ME/REPLACE_ME"
        RewardedAndroid    = "ca-app-pub-REPLACE_ME/REPLACE_ME"
    }

    "RentBuyUS" = @{
        # RentBuyUS — no ad_config.dart found; placeholder IDs may be in a service file.
        # Update this path once the file is located.
        AdConfigPath  = "D:\mob\RentBuyUS\lib\core\ads\ad_config.dart"
        Format        = "kReleaseMode"
        AndroidAppId       = "ca-app-pub-REPLACE_ME~REPLACE_ME"
        iOSAppId           = "ca-app-pub-REPLACE_ME~REPLACE_ME"
        BannerAndroid      = "ca-app-pub-REPLACE_ME/REPLACE_ME"
        InterstitialAndroid= "ca-app-pub-REPLACE_ME/REPLACE_ME"
        RewardedAndroid    = "ca-app-pub-REPLACE_ME/REPLACE_ME"
        BanneriOS          = "ca-app-pub-REPLACE_ME/REPLACE_ME"
        InterstitialiOS    = "ca-app-pub-REPLACE_ME/REPLACE_ME"
        RewardediOS        = "ca-app-pub-REPLACE_ME/REPLACE_ME"
    }

    # ── Salary / income calculators ───────────────────────────────────────────

    "SalaryApp" = @{
        AdConfigPath       = "D:\mob\SalaryApp\lib\core\ads\ad_config.dart"
        Format             = "kReleaseMode"
        AndroidAppId       = "ca-app-pub-REPLACE_ME~REPLACE_ME"
        iOSAppId           = "ca-app-pub-REPLACE_ME~REPLACE_ME"
        BannerAndroid      = "ca-app-pub-REPLACE_ME/REPLACE_ME"
        InterstitialAndroid= "ca-app-pub-REPLACE_ME/REPLACE_ME"
        RewardedAndroid    = "ca-app-pub-REPLACE_ME/REPLACE_ME"
        BanneriOS          = "ca-app-pub-REPLACE_ME/REPLACE_ME"
        InterstitialiOS    = "ca-app-pub-REPLACE_ME/REPLACE_ME"
        RewardediOS        = "ca-app-pub-REPLACE_ME/REPLACE_ME"
    }

    # ── Gig economy / tracking ────────────────────────────────────────────────

    "rideprofit" = @{
        # rideprofit uses a different pattern: _useTestIds boolean + bare XXXXXXXXXX.
        AdConfigPath  = "D:\mob\rideprofit\lib\config\ad_config.dart"
        Format        = "rideprofit"
        AppId         = "ca-app-pub-REPLACE_ME~REPLACE_ME"
        BannerId      = "ca-app-pub-REPLACE_ME/REPLACE_ME"
        InterstitialId= "ca-app-pub-REPLACE_ME/REPLACE_ME"
        RewardedId    = "ca-app-pub-REPLACE_ME/REPLACE_ME"
    }

    "ParkSmart" = @{
        # ParkSmart — no ad_config.dart found; AdMob may not be integrated yet.
        # Update this path once the file is located.
        AdConfigPath  = "D:\mob\ParkSmart\lib\core\ads\ad_config.dart"
        Format        = "kReleaseMode"
        AndroidAppId       = "ca-app-pub-REPLACE_ME~REPLACE_ME"
        iOSAppId           = "ca-app-pub-REPLACE_ME~REPLACE_ME"
        BannerAndroid      = "ca-app-pub-REPLACE_ME/REPLACE_ME"
        InterstitialAndroid= "ca-app-pub-REPLACE_ME/REPLACE_ME"
        RewardedAndroid    = "ca-app-pub-REPLACE_ME/REPLACE_ME"
        BanneriOS          = "ca-app-pub-REPLACE_ME/REPLACE_ME"
        InterstitialiOS    = "ca-app-pub-REPLACE_ME/REPLACE_ME"
        RewardediOS        = "ca-app-pub-REPLACE_ME/REPLACE_ME"
    }
}

# ─────────────────────────────────────────────────────────────────────────────
# VALIDATION — abort if any REPLACE_ME is still present
# ─────────────────────────────────────────────────────────────────────────────

Write-Host ""
Write-Host "=== AdMob ID Replacement Script ===" -ForegroundColor Cyan
Write-Host ""

$missingCount = 0
foreach ($appName in $apps.Keys) {
    $cfg = $apps[$appName]
    foreach ($key in $cfg.Keys) {
        if ($key -eq "AdConfigPath" -or $key -eq "Format") { continue }
        if ($cfg[$key] -match "REPLACE_ME") {
            Write-Host "  [MISSING] $appName :: $key" -ForegroundColor Red
            $missingCount++
        }
    }
}

if ($missingCount -gt 0) {
    Write-Host ""
    Write-Host "ERROR: $missingCount ID(s) still contain REPLACE_ME." -ForegroundColor Red
    Write-Host "Fill in all IDs at the top of this script before running." -ForegroundColor Yellow
    Write-Host ""
    exit 1
}

Write-Host "All IDs filled in. Proceeding with replacements..." -ForegroundColor Green
Write-Host ""

# ─────────────────────────────────────────────────────────────────────────────
# HELPER: replace a single placeholder string in a file
# ─────────────────────────────────────────────────────────────────────────────

function Replace-InFile {
    param(
        [string]$FilePath,
        [string]$OldValue,
        [string]$NewValue,
        [ref]$Changes
    )
    $content = Get-Content $FilePath -Raw -Encoding UTF8
    if ($content -match [regex]::Escape($OldValue)) {
        $content = $content -replace [regex]::Escape($OldValue), $NewValue
        Set-Content $FilePath $content -Encoding UTF8 -NoNewline
        $Changes.Value++
    }
}

# ─────────────────────────────────────────────────────────────────────────────
# MAIN LOOP
# ─────────────────────────────────────────────────────────────────────────────

$results = @()

foreach ($appName in $apps.Keys) {
    $cfg  = $apps[$appName]
    $path = $cfg["AdConfigPath"]
    $fmt  = $cfg["Format"]

    $status = "OK"
    $detail = ""
    $changes = 0

    # Check file exists
    if (-not (Test-Path $path)) {
        $results += [PSCustomObject]@{
            App    = $appName
            Status = "SKIP"
            Detail = "File not found: $path"
        }
        continue
    }

    try {
        switch ($fmt) {

            # ── flat ─────────────────────────────────────────────────────────
            # MortgageUS: const String androidAppId = '...TEST...'; etc.
            "flat" {
                $content = Get-Content $path -Raw -Encoding UTF8

                # App IDs — replace TEST app IDs
                $content = $content -replace "ca-app-pub-3940256099942544~3347511713", $cfg["AndroidAppId"]
                $content = $content -replace "ca-app-pub-3940256099942544~1458002511", $cfg["iOSAppId"]

                # Ad unit IDs — replace TEST unit IDs
                $content = $content -replace "ca-app-pub-3940256099942544/6300978111", $cfg["BannerAndroid"]
                $content = $content -replace "ca-app-pub-3940256099942544/1033173712", $cfg["InterstitialAndroid"]
                $content = $content -replace "ca-app-pub-3940256099942544/5224354917", $cfg["RewardedAndroid"]
                $content = $content -replace "ca-app-pub-3940256099942544/2934735716", $cfg["BanneriOS"]
                $content = $content -replace "ca-app-pub-3940256099942544/4411468910", $cfg["InterstitialiOS"]
                $content = $content -replace "ca-app-pub-3940256099942544/1712485313", $cfg["RewardediOS"]

                Set-Content $path $content -Encoding UTF8 -NoNewline
                $changes = 8
            }

            # ── kReleaseMode ─────────────────────────────────────────────────
            # Pattern: kReleaseMode ? 'ca-app-pub-5379540026739666/XXXXXXXXXX' : '...test...'
            # Also replaces the TEST app IDs in androidAppId / iosAppId const strings.
            "kReleaseMode" {
                $content = Get-Content $path -Raw -Encoding UTF8

                # Replace app IDs (TEST → real)
                if ($cfg.ContainsKey("AndroidAppId")) {
                    $content = $content -replace "ca-app-pub-3940256099942544~3347511713", $cfg["AndroidAppId"]
                }
                if ($cfg.ContainsKey("iOSAppId")) {
                    $content = $content -replace "ca-app-pub-3940256099942544~1458002511", $cfg["iOSAppId"]
                }

                # Replace placeholder unit IDs — we target the specific kReleaseMode branch.
                # Pattern matches: 'ca-app-pub-5379540026739666/XXXXXXXXXX'
                # We do targeted replacements per getter using the property value.

                # Android
                $content = $content -replace (
                    "(?<=(bannerAndroid[^?]*\?[^']*'))" + "ca-app-pub-5379540026739666/XXXXXXXXXX",
                    $cfg["BannerAndroid"]
                )
                $content = $content -replace (
                    "(?<=(interstitialAndroid[^?]*\?[^']*'))" + "ca-app-pub-5379540026739666/XXXXXXXXXX",
                    $cfg["InterstitialAndroid"]
                )
                $content = $content -replace (
                    "(?<=(rewardedAndroid[^?]*\?[^']*'))" + "ca-app-pub-5379540026739666/XXXXXXXXXX",
                    $cfg["RewardedAndroid"]
                )

                # iOS
                if ($cfg.ContainsKey("BanneriOS")) {
                    $content = $content -replace (
                        "(?<=(banneriOS[^?]*\?[^']*'))" + "ca-app-pub-5379540026739666/XXXXXXXXXX",
                        $cfg["BanneriOS"]
                    )
                    $content = $content -replace (
                        "(?<=(interstitialiOS[^?]*\?[^']*'))" + "ca-app-pub-5379540026739666/XXXXXXXXXX",
                        $cfg["InterstitialiOS"]
                    )
                    $content = $content -replace (
                        "(?<=(rewardediOS[^?]*\?[^']*'))" + "ca-app-pub-5379540026739666/XXXXXXXXXX",
                        $cfg["RewardediOS"]
                    )
                }

                # Fallback: if any XXXXXXXXXX remain (simpler files without named getters),
                # replace each remaining occurrence in order.
                $remaining = ([regex]::Matches($content, "ca-app-pub-5379540026739666/XXXXXXXXXX")).Count
                if ($remaining -gt 0) {
                    # Replace remaining occurrences in sequence: Banner, Interstitial, Rewarded
                    $ordered = @("BannerAndroid","InterstitialAndroid","RewardedAndroid","BanneriOS","InterstitialiOS","RewardediOS")
                    foreach ($key in $ordered) {
                        if (-not $cfg.ContainsKey($key)) { continue }
                        $remaining2 = ([regex]::Matches($content, "ca-app-pub-5379540026739666/XXXXXXXXXX")).Count
                        if ($remaining2 -eq 0) { break }
                        $content = $content -replace "ca-app-pub-5379540026739666/XXXXXXXXXX", $cfg[$key], 1
                    }
                }

                Set-Content $path $content -Encoding UTF8 -NoNewline
                $changes = 1  # approximate
            }

            # ── androidOnly ───────────────────────────────────────────────────
            # RentalExpenses: Android getters only, no iOS, no app ID consts.
            "androidOnly" {
                $content = Get-Content $path -Raw -Encoding UTF8

                $order = @("BannerAndroid","InterstitialAndroid","RewardedAndroid")
                foreach ($key in $order) {
                    $remaining = ([regex]::Matches($content, "ca-app-pub-5379540026739666/XXXXXXXXXX")).Count
                    if ($remaining -eq 0) { break }
                    $content = $content -replace "ca-app-pub-5379540026739666/XXXXXXXXXX", $cfg[$key], 1
                }

                Set-Content $path $content -Encoding UTF8 -NoNewline
                $changes = 3
            }

            # ── pubSlash ──────────────────────────────────────────────────────
            # MortgageUK: static const _pub = '...'; getters use '$_pub/XXXXXXXXXX'
            "pubSlash" {
                $content = Get-Content $path -Raw -Encoding UTF8

                # Replace the publisher constant with full IDs (expand to explicit strings)
                $content = $content -replace (
                    "(?<=(bannerAdUnitId[^?]*\?[^']*'\`$_pub/))" + "XXXXXXXXXX",
                    $cfg["BannerAdUnitId"] -replace "ca-app-pub-[^/]+/", ""
                )
                $content = $content -replace (
                    "(?<=(interstitialAdUnitId[^?]*\?[^']*'\`$_pub/))" + "XXXXXXXXXX",
                    $cfg["InterstitialAdUnitId"] -replace "ca-app-pub-[^/]+/", ""
                )
                $content = $content -replace (
                    "(?<=(rewardedAdUnitId[^?]*\?[^']*'\`$_pub/))" + "XXXXXXXXXX",
                    $cfg["RewardedAdUnitId"] -replace "ca-app-pub-[^/]+/", ""
                )

                # Fallback: sequential replacement of remaining XXXXXXXXXX
                $order = @("BannerAdUnitId","InterstitialAdUnitId","RewardedAdUnitId")
                foreach ($key in $order) {
                    $remaining = ([regex]::Matches($content, "XXXXXXXXXX")).Count
                    if ($remaining -eq 0) { break }
                    $unitNum = $cfg[$key] -replace "ca-app-pub-[^/]+/", ""
                    $content = $content -replace "XXXXXXXXXX", $unitNum, 1
                }

                Set-Content $path $content -Encoding UTF8 -NoNewline
                $changes = 3
            }

            # ── autoloan ──────────────────────────────────────────────────────
            # AutoLoan: per-flavor constants _bannerCA, _bannerUK, _bannerUS etc.
            "autoloan" {
                $content = Get-Content $path -Raw -Encoding UTF8

                # App ID
                $content = $content -replace (
                    "(?<=(appId[^']*'))" + "ca-app-pub-5379540026739666~XXXXXXXXXX",
                    $cfg["AppId"]
                )

                # Per-flavor replacements (each constant appears once)
                $flavorMap = @{
                    "_bannerCA"   = "BannerCA"
                    "_bannerUK"   = "BannerUK"
                    "_bannerUS"   = "BannerUS"
                    "_interCA"    = "InterCA"
                    "_interUK"    = "InterUK"
                    "_interUS"    = "InterUS"
                    "_rewardedCA" = "RewardedCA"
                    "_rewardedUK" = "RewardedUK"
                    "_rewardedUS" = "RewardedUS"
                    "_appOpenCA"  = "AppOpenCA"
                    "_appOpenUK"  = "AppOpenUK"
                    "_appOpenUS"  = "AppOpenUS"
                }

                foreach ($constName in $flavorMap.Keys) {
                    $cfgKey = $flavorMap[$constName]
                    # Match: static const _bannerCA = 'ca-app-pub-5379540026739666/XXXXXXXXXX';
                    $pattern     = "(?<=$([regex]::Escape($constName))\s*=\s*')" + "ca-app-pub-5379540026739666/XXXXXXXXXX"
                    $replacement = $cfg[$cfgKey]
                    $content = $content -replace $pattern, $replacement
                }

                Set-Content $path $content -Encoding UTF8 -NoNewline
                $changes = 13
            }

            # ── adService ─────────────────────────────────────────────────────
            # LoanPayoffUS: IDs embedded in ad_service.dart using '$_pub/XXXXXXXXXX'
            "adService" {
                $content = Get-Content $path -Raw -Encoding UTF8

                $order = @("BannerId","InterstitialId","RewardedId")
                foreach ($key in $order) {
                    $remaining = ([regex]::Matches($content, "XXXXXXXXXX")).Count
                    if ($remaining -eq 0) { break }
                    $unitNum = $cfg[$key] -replace "ca-app-pub-[^/]+/", ""
                    $content = $content -replace "XXXXXXXXXX", $unitNum, 1
                }

                Set-Content $path $content -Encoding UTF8 -NoNewline
                $changes = 3
            }

            # ── rideprofit ────────────────────────────────────────────────────
            # rideprofit: bare XXXXXXXXXX strings (no publisher prefix in the file).
            "rideprofit" {
                $content = Get-Content $path -Raw -Encoding UTF8

                # App ID: 'XXXXXXXXXX' (the first bare XXXXXXXXXX in the file)
                $content = $content -replace "'XXXXXXXXXX'", ("'" + $cfg["AppId"] + "'"), 1

                # Ad units: bare 'XXXXXXXXXX'
                $order = @("BannerId","InterstitialId","RewardedId")
                foreach ($key in $order) {
                    $remaining = ([regex]::Matches($content, "'XXXXXXXXXX'")).Count
                    if ($remaining -eq 0) { break }
                    $content = $content -replace "'XXXXXXXXXX'", ("'" + $cfg[$key] + "'"), 1
                }

                Set-Content $path $content -Encoding UTF8 -NoNewline
                $changes = 4
            }
        }

        # Verify no XXXXXXXXXX remain in the file
        $verify = Get-Content $path -Raw -Encoding UTF8
        if ($verify -match "XXXXXXXXXX") {
            $status = "WARN"
            $detail = "Some XXXXXXXXXX remain — check file manually"
        } else {
            $status = "OK"
            $detail = "Updated ($changes field(s) processed)"
        }

    } catch {
        $status = "ERROR"
        $detail = $_.Exception.Message
    }

    $results += [PSCustomObject]@{
        App    = $appName
        Status = $status
        Detail = $detail
    }
}

# ─────────────────────────────────────────────────────────────────────────────
# REPORT
# ─────────────────────────────────────────────────────────────────────────────

Write-Host "=== Results ===" -ForegroundColor Cyan
Write-Host ""

$okCount    = 0
$warnCount  = 0
$skipCount  = 0
$errorCount = 0

foreach ($r in $results) {
    switch ($r.Status) {
        "OK"    { Write-Host ("  [OK]    " + $r.App.PadRight(20) + " " + $r.Detail) -ForegroundColor Green;  $okCount++ }
        "WARN"  { Write-Host ("  [WARN]  " + $r.App.PadRight(20) + " " + $r.Detail) -ForegroundColor Yellow; $warnCount++ }
        "SKIP"  { Write-Host ("  [SKIP]  " + $r.App.PadRight(20) + " " + $r.Detail) -ForegroundColor Gray;   $skipCount++ }
        "ERROR" { Write-Host ("  [ERROR] " + $r.App.PadRight(20) + " " + $r.Detail) -ForegroundColor Red;    $errorCount++ }
    }
}

Write-Host ""
Write-Host ("  Total: " + $results.Count + " apps — OK: $okCount  WARN: $warnCount  SKIP: $skipCount  ERROR: $errorCount") -ForegroundColor Cyan
Write-Host ""

if ($warnCount -gt 0 -or $errorCount -gt 0) {
    Write-Host "Action required: review WARN/ERROR apps above." -ForegroundColor Yellow
} else {
    Write-Host "All done! Remember to also update AndroidManifest.xml and Info.plist with the new App IDs." -ForegroundColor Green
}

Write-Host ""
