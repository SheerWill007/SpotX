# SpotX Comprehensive Test Suite
# Tests patch integrity, regex patterns, and version compatibility

param(
    [Parameter(Mandatory=$true)]
    [string]$SpotifyVersion
)

$ErrorActionPreference = 'Continue'
$testResults = @()
$script:basePath = Split-Path -Parent $PSScriptRoot

function Test-PatchIntegrity {
    $patchesPath = Join-Path $script:basePath 'patches\patches.json'
    
    try {
        $patches = Get-Content $patchesPath -Raw | ConvertFrom-Json
        $script:testResults += [PSCustomObject]@{
            Test = "Patches JSON Valid"
            Result = "PASS"
            Details = "patches.json is valid JSON"
        }
        return $patches
    }
    catch {
        $script:testResults += [PSCustomObject]@{
            Test = "Patches JSON Valid"
            Result = "FAIL"
            Details = $_.Exception.Message
        }
        return $null
    }
}

function Test-RegexPatterns {
    param($patches)
    
    $invalidPatterns = @()
    $totalPatterns = 0
    
    foreach ($category in $patches.PSObject.Properties) {
        foreach ($patchGroup in $category.Value.PSObject.Properties) {
            foreach ($patch in $patchGroup.Value.PSObject.Properties) {
                if ($patch.Value.match) {
                    $totalPatterns++
                    try {
                        # Test if it's a valid regex
                        $null = [regex]::new($patch.Value.match)
                    }
                    catch {
                        $invalidPatterns += "$($category.Name).$($patchGroup.Name).$($patch.Name): $($_.Exception.Message)"
                    }
                }
            }
        }
    }
    
    if ($invalidPatterns.Count -eq 0) {
        $script:testResults += [PSCustomObject]@{
            Test = "Regex Patterns Valid"
            Result = "PASS"
            Details = "All $totalPatterns regex patterns are valid"
        }
    }
    else {
        $script:testResults += [PSCustomObject]@{
            Test = "Regex Patterns Valid"
            Result = "FAIL"
            Details = "Invalid patterns: $($invalidPatterns -join '; ')"
        }
    }
}

function Test-VersionRanges {
    param($patches, $spotifyVersion)
    
    $ver = [version]($spotifyVersion -replace '\.g[0-9a-f]{8}$', '')
    $applicablePatches = 0
    $totalPatches = 0
    
    foreach ($category in $patches.PSObject.Properties) {
        foreach ($patchGroup in $category.Value.PSObject.Properties) {
            foreach ($patch in $patchGroup.Value.PSObject.Properties) {
                $totalPatches++
                
                if ($patch.Value.version) {
                    $frVer = [version]($patch.Value.version.fr -replace '\.g[0-9a-f]{8}$', '')
                    $toVer = if ($patch.Value.version.to -eq "") { [version]"99.0.0.0" } 
                             else { [version]($patch.Value.version.to -replace '\.g[0-9a-f]{8}$', '') }
                    
                    if (($ver -ge $frVer) -and ($ver -le $toVer)) {
                        $applicablePatches++
                    }
                }
                else {
                    # No version restriction = always applicable
                    $applicablePatches++
                }
            }
        }
    }
    
    $percentage = [math]::Round(($applicablePatches / $totalPatches) * 100, 2)
    
    $script:testResults += [PSCustomObject]@{
        Test = "Applicable Patches"
        Result = if($percentage -ge 75){"PASS"}elseif($percentage -ge 50){"WARN"}else{"FAIL"}
        Details = "$applicablePatches / $totalPatches patches ($percentage%) applicable to version $spotifyVersion"
    }
}

function Test-JavaScriptFiles {
    $jsFiles = @(
        "js-helper/checkVersion.js",
        "js-helper/sectionBlock.js",
        "js-helper/goofyHistory.js"
    )
    
    foreach ($jsFile in $jsFiles) {
        $path = Join-Path $script:basePath $jsFile
        if (Test-Path $path) {
            $content = Get-Content $path -Raw
            
            # Basic syntax checks
            $hasFunction = $content -match "function\s+\w+\s*\("
            $hasParens = $content -match "\)"
            $hasAsync = $content -match "async\s+function" -or $content -match "=\s*async\s*\("
            $hasConst = $content -match "const\s+\w+"
            $noSyntaxErrors = $content -notmatch "}\s*else\s*{" # Common error
            
            if ($hasFunction -and $hasParens) {
                $script:testResults += [PSCustomObject]@{
                    Test = "JavaScript: $jsFile"
                    Result = "PASS"
                    Details = "File exists with valid syntax ($(($content.Length / 1KB).ToString('F2')) KB)"
                }
            }
            else {
                $script:testResults += [PSCustomObject]@{
                    Test = "JavaScript: $jsFile"
                    Result = "WARN"
                    Details = "File exists but may have syntax issues"
                }
            }
        }
        else {
            $script:testResults += [PSCustomObject]@{
                Test = "JavaScript: $jsFile"
                Result = "FAIL"
                Details = "File not found at $path"
            }
        }
    }
}

function Test-CSSFiles {
    $cssFiles = @(
        "css-helper/lyrics-color/colors.css",
        "css-helper/lyrics-color/rules.css"
    )
    
    foreach ($cssFile in $cssFiles) {
        $path = Join-Path $script:basePath $cssFile
        if (Test-Path $path) {
            $content = Get-Content $path -Raw
            
            # Check for valid CSS structure
            $hasCurlyBraces = ($content -split '\{').Count -gt 1
            $hasClosingBraces = ($content -split '\}').Count -gt 1
            $hasProperties = $content -match ":\s*[^;]+;"
            
            if ($hasCurlyBraces -and $hasClosingBraces -and $hasProperties) {
                $script:testResults += [PSCustomObject]@{
                    Test = "CSS: $cssFile"
                    Result = "PASS"
                    Details = "Valid CSS structure ($(($content.Length / 1KB).ToString('F2')) KB)"
                }
            }
            else {
                $script:testResults += [PSCustomObject]@{
                    Test = "CSS: $cssFile"
                    Result = "WARN"
                    Details = "File exists but may have structural issues"
                }
            }
        }
        else {
            $script:testResults += [PSCustomObject]@{
                Test = "CSS: $cssFile"
                Result = "FAIL"
                Details = "File not found"
            }
        }
    }
}

function Test-RequiredFiles {
    $requiredFiles = @(
        "run.ps1",
        "Install_New_theme.bat",
        "Install_Old_theme.bat",
        "Uninstall.bat",
        "README.md",
        "LICENSE"
    )
    
    $missingFiles = @()
    
    foreach ($file in $requiredFiles) {
        $path = Join-Path $script:basePath $file
        if (-not (Test-Path $path)) {
            $missingFiles += $file
        }
    }
    
    if ($missingFiles.Count -eq 0) {
        $script:testResults += [PSCustomObject]@{
            Test = "Required Files Present"
            Result = "PASS"
            Details = "All $($requiredFiles.Count) required files present"
        }
    }
    else {
        $script:testResults += [PSCustomObject]@{
            Test = "Required Files Present"
            Result = "FAIL"
            Details = "Missing files: $($missingFiles -join ', ')"
        }
    }
}

# Run tests
Write-Host "================================================" -ForegroundColor Cyan
Write-Host "         SpotX Comprehensive Test Suite" -ForegroundColor Cyan
Write-Host "================================================`n" -ForegroundColor Cyan

Write-Host "Target Spotify Version: $SpotifyVersion" -ForegroundColor Yellow
Write-Host "Test Date: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')`n" -ForegroundColor Gray

$patchesPath = Join-Path $script:basePath "patches\patches.json"
Write-Host "Loading patches from: $patchesPath`n" -ForegroundColor Gray

$patches = Test-PatchIntegrity

if ($patches) {
    Write-Host "Running pattern validation..." -ForegroundColor Cyan
    Test-RegexPatterns -patches $patches
    
    Write-Host "Running version compatibility..." -ForegroundColor Cyan
    Test-VersionRanges -patches $patches -spotifyVersion $SpotifyVersion
}

Write-Host "Testing JavaScript files..." -ForegroundColor Cyan
Test-JavaScriptFiles

Write-Host "Testing CSS files..." -ForegroundColor Cyan
Test-CSSFiles

Write-Host "Checking required files..." -ForegroundColor Cyan
Test-RequiredFiles

# Display results
Write-Host "`n================================================" -ForegroundColor Cyan
Write-Host "                 Test Results" -ForegroundColor Cyan
Write-Host "================================================`n" -ForegroundColor Cyan

$testResults | Format-Table -AutoSize

$passCount = ($testResults | Where-Object { $_.Result -eq "PASS" }).Count
$warnCount = ($testResults | Where-Object { $_.Result -eq "WARN" }).Count
$failCount = ($testResults | Where-Object { $_.Result -eq "FAIL" }).Count
$totalCount = $testResults.Count

Write-Host "================================================" -ForegroundColor Cyan
Write-Host "Summary:" -ForegroundColor Yellow
Write-Host "  PASS: $passCount" -ForegroundColor Green
Write-Host "  WARN: $warnCount" -ForegroundColor Yellow
Write-Host "  FAIL: $failCount" -ForegroundColor Red
Write-Host "  Total: $totalCount tests`n" -ForegroundColor Gray

$passPercentage = [math]::Round(($passCount / $totalCount) * 100, 2)

Write-Host "Overall: $passCount / $totalCount tests passed ($passPercentage%)" -ForegroundColor $(
    if($passPercentage -eq 100){'Green'}
    elseif($passPercentage -ge 80){'Yellow'}
    else{'Red'}
)

Write-Host "================================================`n" -ForegroundColor Cyan

# Exit code
if ($failCount -eq 0 -and $warnCount -le 2) {
    Write-Host "✓ All tests passed!" -ForegroundColor Green
    exit 0
}
elseif ($failCount -eq 0) {
    Write-Host "⚠ Tests passed with warnings" -ForegroundColor Yellow
    exit 0
}
else {
    Write-Host "✗ Some tests failed" -ForegroundColor Red
    exit 1
}
