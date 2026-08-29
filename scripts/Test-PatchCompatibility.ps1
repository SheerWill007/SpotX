# SpotX Patch Compatibility Test Script
# Tests patch compatibility with a specific Spotify version

param(
    [Parameter(Mandatory=$true)]
    [string]$SpotifyVersion
)

$ErrorActionPreference = 'Continue'

$patchesPath = Join-Path $PSScriptRoot '..\patches\patches.json'

if (-not (Test-Path $patchesPath)) {
    Write-Host "ERROR: patches.json not found at $patchesPath" -ForegroundColor Red
    exit 1
}

$patches = Get-Content $patchesPath -Raw | ConvertFrom-Json
$version = [version]($SpotifyVersion -replace '\.g[0-9a-f]{8}$', '')

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "   SpotX Patch Compatibility Test" -ForegroundColor Cyan
Write-Host "========================================`n" -ForegroundColor Cyan

Write-Host "Spotify Version: $SpotifyVersion" -ForegroundColor Yellow
Write-Host "Parsed Version: $version`n" -ForegroundColor Yellow

function Test-PatchVersionRange {
    param($patch, $patchName)
    
    if (-not $patch.version) { return $true }
    
    $frVersion = [version]($patch.version.fr -replace '\.g[0-9a-f]{8}$', '')
    
    if ($patch.version.to -eq "") {
        # Patch has no end version - should work
        return $version -ge $frVersion
    }
    
    $toVersion = [version]($patch.version.to -replace '\.g[0-9a-f]{8}$', '')
    
    $isCompatible = ($version -ge $frVersion) -and ($version -le $toVersion)
    
    if (-not $isCompatible) {
        Write-Warning "Patch '$patchName' not compatible with version $SpotifyVersion"
        Write-Host "  Supported range: $($patch.version.fr) to $($patch.version.to)" -ForegroundColor Yellow
    }
    
    return $isCompatible
}

$totalPatches = 0
$compatiblePatches = 0
$incompatiblePatches = @()

foreach ($category in $patches.PSObject.Properties) {
    Write-Host "`nCategory: $($category.Name)" -ForegroundColor Cyan
    $categoryCompatible = 0
    $categoryTotal = 0
    
    foreach ($patchGroup in $category.Value.PSObject.Properties) {
        foreach ($patch in $patchGroup.Value.PSObject.Properties) {
            $totalPatches++
            $categoryTotal++
            
            if (Test-PatchVersionRange -patch $patch.Value -patchName $patch.Name) {
                $compatiblePatches++
                $categoryCompatible++
            }
            else {
                $incompatiblePatches += [PSCustomObject]@{
                    Category = $category.Name
                    Patch = $patch.Name
                    FromVersion = $patch.Value.version.fr
                    ToVersion = $patch.Value.version.to
                }
            }
        }
    }
    
    $catPercentage = [math]::Round(($categoryCompatible / $categoryTotal) * 100, 2)
    Write-Host "  $categoryCompatible / $categoryTotal patches ($catPercentage%)" -ForegroundColor $(
        if($catPercentage -ge 95){'Green'}
        elseif($catPercentage -ge 80){'Yellow'}
        else{'Red'}
    )
}

Write-Host "`n========================================" -ForegroundColor Cyan
Write-Host "Compatibility Summary:" -ForegroundColor Yellow
Write-Host "Compatible Patches: $compatiblePatches / $totalPatches"
$percentage = [math]::Round(($compatiblePatches / $totalPatches) * 100, 2)
Write-Host "Coverage: $percentage%" -ForegroundColor $(
    if($percentage -gt 90){'Green'}
    elseif($percentage -gt 70){'Yellow'}
    else{'Red'}
)

if ($incompatiblePatches.Count -gt 0) {
    Write-Host "`nIncompatible Patches:" -ForegroundColor Red
    $incompatiblePatches | Format-Table -AutoSize
    Write-Host "Note: These patches may need version range updates or may be outdated" -ForegroundColor Yellow
}

Write-Host "`n========================================`n" -ForegroundColor Cyan

# Return exit code based on compatibility
if ($percentage -ge 80) {
    exit 0
}
else {
    exit 1
}
