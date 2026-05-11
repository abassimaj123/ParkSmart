# Batch fix Colors.grey → slate palette constants across all Flutter apps
# Safe replacements: const values → Color constants (no context needed)

$replacements = @(
    # shade values → slate palette
    @{ from = 'Colors\.grey\.shade50\b';  to = 'const Color(0xFFF8FAFC)' },
    @{ from = 'Colors\.grey\.shade100\b'; to = 'const Color(0xFFF1F5F9)' },
    @{ from = 'Colors\.grey\.shade200\b'; to = 'const Color(0xFFE2E8F0)' },
    @{ from = 'Colors\.grey\.shade300\b'; to = 'const Color(0xFFCBD5E1)' },
    @{ from = 'Colors\.grey\.shade400\b'; to = 'const Color(0xFF94A3B8)' },
    @{ from = 'Colors\.grey\.shade500\b'; to = 'const Color(0xFF64748B)' },
    @{ from = 'Colors\.grey\.shade600\b'; to = 'const Color(0xFF475569)' },
    @{ from = 'Colors\.grey\.shade700\b'; to = 'const Color(0xFF334155)' },
    @{ from = 'Colors\.grey\.shade800\b'; to = 'const Color(0xFF1E293B)' },
    @{ from = 'Colors\.grey\.shade900\b'; to = 'const Color(0xFF0F172A)' },
    # bracket notation
    @{ from = 'Colors\.grey\[50\]';  to = 'const Color(0xFFF8FAFC)' },
    @{ from = 'Colors\.grey\[100\]'; to = 'const Color(0xFFF1F5F9)' },
    @{ from = 'Colors\.grey\[200\]'; to = 'const Color(0xFFE2E8F0)' },
    @{ from = 'Colors\.grey\[300\]'; to = 'const Color(0xFFCBD5E1)' },
    @{ from = 'Colors\.grey\[400\]'; to = 'const Color(0xFF94A3B8)' },
    @{ from = 'Colors\.grey\[500\]'; to = 'const Color(0xFF64748B)' },
    @{ from = 'Colors\.grey\[600\]'; to = 'const Color(0xFF475569)' },
    @{ from = 'Colors\.grey\[700\]'; to = 'const Color(0xFF334155)' },
    @{ from = 'Colors\.grey\[800\]'; to = 'const Color(0xFF1E293B)' },
    @{ from = 'Colors\.grey\[900\]'; to = 'const Color(0xFF0F172A)' },
    # bare Colors.grey (NOT followed by . or [)
    @{ from = 'Colors\.grey(?![.\[])'; to = 'const Color(0xFF64748B)' }
)

$apps = Get-ChildItem 'D:\mob' -Directory | Select-Object -ExpandProperty Name
$totalFixed = 0

foreach ($app in $apps) {
    $libPath = "D:\mob\$app\lib"
    if (-not (Test-Path $libPath)) { continue }

    $dartFiles = Get-ChildItem -Path $libPath -Recurse -Include '*.dart' -ErrorAction SilentlyContinue
    foreach ($f in $dartFiles) {
        $content = Get-Content -Path $f.FullName -Raw -ErrorAction SilentlyContinue
        if (-not $content) { continue }
        # Skip PDF service files (PdfColors.grey is different)
        if ($content -like '*PdfColors*' -and $f.Name -like '*pdf*') { continue }

        $changed = $false
        $newContent = $content
        foreach ($r in $replacements) {
            $orig = $newContent
            $newContent = [regex]::Replace($newContent, $r.from, $r.to)
            if ($newContent -ne $orig) { $changed = $true }
        }

        if ($changed) {
            # Remove redundant 'const' before 'const Color'
            $newContent = $newContent -replace 'const const Color', 'const Color'
            # Fix TextStyle const issues: 'const TextStyle(..., const Color(...)' → remove inner const
            $newContent = $newContent -replace '(?<=TextStyle\([^)]*color:\s*)const Color', 'Color'
            Set-Content -Path $f.FullName -Value $newContent -NoNewline
            $totalFixed++
            Write-Output "FIXED: $($f.FullName)"
        }
    }
}
Write-Output "--- Total: $totalFixed files fixed ---"
