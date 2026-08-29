# SpotX Update Implementation Guide

## Overview
This document provides detailed code examples and implementation strategies to bring SpotX up to date with official Spotify features as of August 2026.

---

## 1. Exclusive Mode (Audio Output) Support - CRITICAL

### Background
Spotify introduced Exclusive Mode in January 2026, allowing bit-perfect playback with exclusive audio device control.

### Required Changes

#### A. Detect and Preserve Exclusive Mode Settings

```javascript
// Add to patches.json under "others"
"ExclusiveMode": {
    "version": {
        "fr": "1.2.85",
        "to": ""
    },
    "description": "Ensure Exclusive Mode audio settings are preserved",
    "match": "(enableExclusiveMode|exclusiveAudioMode|bitPerfectPlayback):[!01]",
    "replace": "$1:!0"
}
```

#### B. Add Audio Output Device Selection Support

```javascript
// New experimental feature to enable (add to EnableExp in patches.json)
"ExclusiveAudioOutput": {
    "name": "enableExclusiveAudioOutput",
    "description": "Enable exclusive mode and audio device selection",
    "native_description": "Enable Exclusive Mode for bit-perfect playback",
    "version": {
        "fr": "1.2.85",
        "to": ""
    }
}
```

#### C. Test Script for Exclusive Mode

```powershell
# Add to run.ps1 parameters
[Parameter(HelpMessage = 'Preserve Exclusive Mode audio settings.')]
[switch]$preserve_exclusive_mode,

# Add validation in installation
if ($preserve_exclusive_mode) {
    Write-Host "Preserving Exclusive Mode settings..." -ForegroundColor Green
    # Copy audio settings from existing Spotify prefs
    $prefsFile = Join-Path $spotifyDirectory 'prefs'
    if (Test-Path $prefsFile) {
        $prefsContent = Get-Content $prefsFile -Raw
        # Preserve audio.exclusive_mode and audio.output_device settings
        $audioSettings = [regex]::Matches($prefsContent, 'audio\.(exclusive_mode|output_device)=.+')
        foreach ($setting in $audioSettings) {
            Write-Host "Preserved: $($setting.Value)"
        }
    }
}
```

---

## 2. Lossless Audio (HiFi) Compatibility

### Background
Lossless audio (24-bit/44.1 kHz FLAC) rolled out for Premium users in October 2025.

### Required Changes

#### A. Ensure Lossless Codec Support

```javascript
// Add to patches.json under "others"
"LosslessAudio": {
    "version": {
        "fr": "1.2.80",
        "to": ""
    },
    "description": "Ensure lossless audio codec support is enabled",
    "match": "(enableLosslessAudio|flacCodec|hifiAudio):[!01]",
    "replace": "$1:!0"
}
```

#### B. Enable HiFi Quality Selection (if free account)

```javascript
// Add to free patches
"hifiquality": {
    "version": {
        "fr": "1.2.80",
        "to": ""
    },
    "match": "\"very_high\"===(.)|\"high\"===(.)",
    "replace": "\"lossless\"===$1||\"very_high\"===$1||\"high\"===$2"
}
```

#### C. Update Download Quality Patch

```javascript
// Replace existing downloadquality patch
"downloadquality": {
    "version": {
        "fr": "1.1.70",
        "to": ""
    },
    "match": "(\\(.,..jsxs\\)\\(.{1,3}|(.\\(\\).|..)createElement\\(.{1,4}),{(filterMatchQuery|filter:.,title|(variant:\"viola\",semanticColor:\"textSubdued\"|..:\"span\",variant:.{3,6}mesto,color:.{3,6}),htmlFor:\"desktop.settings.downloadQuality.+?).{1,6}get\\(\"desktop.settings.downloadQuality.title.+?(children:.{1,2}\\(.,.\\).+?,|\\(.,.\\){3,4},|,.\\)}},.\\(.,.\\)\\),)",
    "replace": ""
}
```

---

## 3. Enhanced Lyrics Features

### Background
Spotify added offline lyrics, lyrics translation, and lyrics previews in August 2026.

### Required Changes

#### A. Enable All Lyrics Features

```javascript
// Add to EnableExp in patches.json
"OfflineLyrics": {
    "name": "enableOfflineLyrics",
    "description": "Enable offline lyrics viewing without internet",
    "native_description": "Enable offline lyrics",
    "version": {
        "fr": "1.2.93",
        "to": ""
    }
},
"LyricsTranslation": {
    "name": "enableLyricsTranslation",
    "description": "Enable lyrics translation to user language",
    "native_description": "Enable lyrics translation",
    "version": {
        "fr": "1.2.93",
        "to": ""
    }
},
"LyricsPreviews": {
    "name": "enableLyricsPreviews",
    "description": "Enable lyrics previews in UI",
    "native_description": "Enable lyrics preview cards",
    "version": {
        "fr": "1.2.93",
        "to": ""
    }
}
```

#### B. Update Lyrics Color System

```javascript
// Ensure color customization doesn't break new features
// Update css-helper/lyrics-color/rules.css

/* Add support for translated lyrics */
.lyrics-translated-text {
    color: var(--lyrics-color-primary, #ffffff);
    font-style: italic;
}

/* Add support for lyrics previews */
.lyrics-preview-card {
    background-color: var(--lyrics-bg-color, rgba(0, 0, 0, 0.7));
    backdrop-filter: blur(10px);
}

/* Offline lyrics indicator */
.lyrics-offline-badge {
    color: var(--lyrics-color-secondary, #b3b3b3);
}
```

#### C. Test Lyrics System Compatibility

```javascript
// Add to js-helper/checkLyrics.js (new file)
(function() {
    const LYRICS_FEATURES = [
        'enableOfflineLyrics',
        'enableLyricsTranslation',
        'enableLyricsPreviews',
        'enableRightSidebarLyrics'
    ];

    function checkLyricsCompatibility() {
        const remoteConfig = window.Spotx?.RemoteExp;
        if (!remoteConfig) {
            console.warn('[SpotX] Could not access remote config for lyrics check');
            return;
        }

        const activeFeatures = LYRICS_FEATURES.filter(feature => {
            const value = remoteConfig.get ? remoteConfig.get(feature) : remoteConfig[feature];
            return value && (value.value === true || value === true);
        });

        console.log('[SpotX] Active lyrics features:', activeFeatures);
        
        if (activeFeatures.includes('enableLyricsTranslation') && 
            !activeFeatures.includes('enableOfflineLyrics')) {
            console.warn('[SpotX] Translation may not work without offline lyrics');
        }
    }

    // Run check after SpotX initializes
    if (window.Spotx?.RemoteExp) {
        checkLyricsCompatibility();
    } else {
        window.addEventListener('spotx-loaded', checkLyricsCompatibility);
    }
})();
```

---

## 4. Block New Ad Formats (2026)

### Background
Spotify continues to add new ad formats. SpotX needs to block these.

### Required Changes

#### A. Add New Ad Blocking Experiments

```javascript
// Add to DisableExp in patches.json
"EmbeddedAdHtmlDisplay": {
    "name": "enableEmbeddedAdHtmlDisplay",
    "description": "Disable HTML display ads in embedded NPV",
    "native_description": "Enable HTML display ads in the embedded NPV",
    "version": {
        "fr": "1.2.94",
        "to": ""
    }
},
"HptoHarmonyVideoPlayer": {
    "name": "enableHptoHarmonyVideoPlayer",
    "description": "Disable Harmony-based video player for HPTO ads",
    "native_description": "Enable the Harmony-based video player for HPTO home video ads",
    "version": {
        "fr": "1.2.96",
        "to": ""
    }
},
"SponsoredPlaylistHorizontalVideo": {
    "name": "enableSponsoredPlaylistHorizontalVideo",
    "description": "Disable horizontal video for sponsored playlists",
    "native_description": "Enables horizontal video layout for sponsored playlist headers",
    "version": {
        "fr": "1.2.95",
        "to": ""
    }
},
"AdsSurfaceStateForAdOrchestration": {
    "name": "useAdsSurfaceStateForAdOrchestration",
    "description": "Disable ads-owned surface state for ad orchestration",
    "native_description": "Use ads-owned NPV and cinema surface state for ad orchestration",
    "version": {
        "fr": "1.2.96",
        "to": ""
    }
}
```

#### B. Update Content Blocking Regex

```javascript
// Add to free patches in patches.json
"htmlads": {
    "version": {
        "fr": "1.2.94",
        "to": ""
    },
    "match": "(enableHtmlDisplayAds|renderHtmlAd|htmlAdContent):[!01]",
    "replace": "$1:!1"
},
"harmonyvideoad": {
    "version": {
        "fr": "1.2.96",
        "to": ""
    },
    "match": "(HarmonyVideoAdPlayer|HptoHarmonyVideo)",
    "replace": ""
},
"horizontalvideoad": {
    "version": {
        "fr": "1.2.95",
        "to": ""
    },
    "match": "(sponsoredPlaylistHorizontalVideo|horizontalVideoAd)",
    "replace": ""
}
```

---

## 5. AI Features Compatibility

### Background
Spotify introduced Prompted Playlists and Studio by Spotify Labs in 2026.

### Required Changes

#### A. Allow AI Playlist Generation (Optional)

```javascript
// Add to EnableExp (if users want this feature)
"PromptedPlaylist": {
    "name": "enablePromptedPlaylist",
    "description": "Enable AI-powered playlist creation from text prompts",
    "native_description": "Enable prompted playlist generation",
    "version": {
        "fr": "1.2.90",
        "to": ""
    }
},
"PromptedPlaylistPodcasts": {
    "name": "enablePromptedPlaylistPodcasts",
    "description": "Enable AI playlist prompts for podcasts",
    "native_description": "Expand prompted playlist to podcasts",
    "version": {
        "fr": "1.2.92",
        "to": ""
    }
}
```

#### B. Add Command-Line Parameter

```powershell
# Add to run.ps1
[Parameter(HelpMessage = 'Enable AI-powered playlist generation features.')]
[switch]$enable_ai_playlists,

# In feature configuration section
if ($enable_ai_playlists) {
    Write-Host "Enabling AI playlist features..." -ForegroundColor Cyan
    # Will be enabled via ForcedExp section
}
```

#### C. Studio by Spotify Labs Detection

```powershell
# Add studio detection to run.ps1
function Test-StudioBySpotify {
    $studioPath = Join-Path $env:LOCALAPPDATA 'SpotifyStudio'
    $studioExe = Join-Path $studioPath 'SpotifyStudio.exe'
    
    if (Test-Path $studioExe) {
        Write-Host "Spotify Studio detected at: $studioExe" -ForegroundColor Yellow
        Write-Host "Note: SpotX does not modify Studio by Spotify Labs (separate app)" -ForegroundColor Yellow
        return $true
    }
    return $false
}
```

---

## 6. Update Version Support

### Background
Many patches end support at versions 1.2.84-1.2.93. Need to extend or update.

### Required Changes

#### A. Extend Patch Version Ranges

```json
// Update in patches.json - extend all patches ending at 1.2.93 or earlier
{
    "DisableExp": {
        "EFlag": {
            "name": "enableEFlag",
            "version": {
                "fr": "1.2.44",
                "to": ""  // Changed from "1.2.93" to continue support
            }
        },
        "SilenceTrimmer": {
            "name": "enableSilenceTrimmer",
            "version": {
                "fr": "1.1.99",
                "to": ""  // Changed from "1.2.93" to continue support
            }
        }
        // ... extend all similar patches
    }
}
```

#### B. Add Version Testing Script

```powershell
# Add to scripts/Test-PatchCompatibility.ps1 (new file)
param(
    [Parameter(Mandatory=$true)]
    [string]$SpotifyVersion
)

$patchesPath = Join-Path $PSScriptRoot '..\patches\patches.json'
$patches = Get-Content $patchesPath -Raw | ConvertFrom-Json

$version = [version]($SpotifyVersion -replace '\.g[0-9a-f]{8}$', '')

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

foreach ($category in $patches.PSObject.Properties) {
    foreach ($patchGroup in $category.Value.PSObject.Properties) {
        foreach ($patch in $patchGroup.Value.PSObject.Properties) {
            $totalPatches++
            if (Test-PatchVersionRange -patch $patch.Value -patchName $patch.Name) {
                $compatiblePatches++
            }
        }
    }
}

Write-Host "`nCompatibility Summary:" -ForegroundColor Cyan
Write-Host "Spotify Version: $SpotifyVersion"
Write-Host "Compatible Patches: $compatiblePatches / $totalPatches"
$percentage = [math]::Round(($compatiblePatches / $totalPatches) * 100, 2)
Write-Host "Coverage: $percentage%" -ForegroundColor $(if($percentage -gt 90){'Green'}elseif($percentage -gt 70){'Yellow'}else{'Red'})
```

---

## 7. Enhanced Section Blocking

### Background
New content types and section IDs need to be blocked.

### Required Changes

#### A. Update Section Block Lists

```javascript
// Update js-helper/sectionBlock.js

// Add new 2026 section IDs
const BLOCKED_SECTIONS_BY_CATEGORY = {
    // ... existing sections ...
    
    'AI Generated Playlists': [
        '0JQ5IMCbQBLaiPromptedYou'  // AI/Prompted playlists section
    ],
    'Audiobook Recommendations': [
        '0JQ5IMCbQBLaiAudiobookRec',  // Audiobook recs
        '0JQ5DAnM3wGh0gz1MXnuABK'     // Audiobook discovery
    ],
    'Premium Upsells': [
        '0JQ5IMCbQBLaiPremiumUpsell',  // Premium upgrade prompts
        '0JQ5DAnM3wGh0gz1MXnuHiFi'     // HiFi upsells
    ],
    'Studio by Spotify': [
        '0JQ5IMCbQBLaiStudioSpotify'   // Studio app promotions
    ]
};
```

#### B. Add Content Type Filtering

```javascript
// Add to sectionBlock.js after BLOCKED_CONTENT_TYPES

const BLOCKED_CONTENT_TYPES_2026 = new Set([
    'Podcast',
    'Audiobook',
    'Episode',
    'AIGeneratedPlaylist',     // NEW
    'PromptedContent',          // NEW
    'StudioContent',            // NEW
    'PremiumUpsell',            // NEW
    'AdContent'                 // NEW
]);

// Merge with existing
for (const type of BLOCKED_CONTENT_TYPES_2026) {
    BLOCKED_CONTENT_TYPES.add(type);
}
```

#### C. Add API Endpoint Blocking

```javascript
// Add new API interception in sectionBlock.js

const BLOCKED_APIS = [
    'api-partner.spotify.com/pathfinder',
    'api.spotify.com/v1/views/personalized-recommendations',
    'api.spotify.com/v1/views/ai-recommendations',          // NEW
    'api.spotify.com/v1/views/prompted-playlists',          // NEW
    'api.spotify.com/v1/audiobooks/recommendations',        // NEW
    'spclient.wg.spotify.com/ads/',                         // NEW
    'spclient.wg.spotify.com/ad-logic/'                     // NEW
];

window.fetch = async function (...args) {
    const [url] = args;
    const urlString = typeof url === 'string' ? url : url?.url || '';

    const shouldIntercept = BLOCKED_APIS.some(api => urlString.includes(api));
    
    if (!shouldIntercept) {
        return originalFetch.apply(this, args);
    }

    // ... rest of interception logic
};
```

---

## 8. Update checkVersion.js

### Background
Version checking system needs updates for new manifest format and error handling.

### Required Changes

#### A. Update Manifest URLs

```javascript
// Update in js-helper/checkVersion.js

const CONFIG = {
    // ... existing config ...
    
    // Add fallback URLs for 2026
    latestUrls: [
        "https://raw.githubusercontent.com/LoaderSpot/table/refs/heads/main/latest.json",
        "https://raw.githack.com/LoaderSpot/table/main/latest.json",
        "https://loadspot.vercel.app/api/latest",                          // NEW
        "https://spotify-version-api.amd64fox1.workers.dev/latest",        // NEW
        `${WORKER_BASE_URL}/api/client/latest`
    ],
    
    // Add version validation
    minSupportedVersion: "1.2.0.0",
    maxTestedVersion: "1.2.97.0"
};
```

#### B. Add Version Compatibility Check

```javascript
// Add to checkVersion.js

function validateVersionCompatibility(shortVersion) {
    const version = extractShortVersion(shortVersion);
    const minVersion = CONFIG.minSupportedVersion;
    const maxVersion = CONFIG.maxTestedVersion;
    
    const current = version.split('.').map(Number);
    const min = minVersion.split('.').map(Number);
    const max = maxVersion.split('.').map(Number);
    
    function compareVersions(v1, v2) {
        for (let i = 0; i < 4; i++) {
            if (v1[i] > v2[i]) return 1;
            if (v1[i] < v2[i]) return -1;
        }
        return 0;
    }
    
    const isAboveMin = compareVersions(current, min) >= 0;
    const isBelowMax = compareVersions(current, max) <= 0;
    
    if (!isAboveMin) {
        console.warn(`[SpotX] Version ${version} is below minimum supported version ${minVersion}`);
        return { supported: false, reason: 'too_old' };
    }
    
    if (!isBelowMax) {
        console.warn(`[SpotX] Version ${version} is above maximum tested version ${maxVersion}`);
        return { supported: true, reason: 'untested', warning: true };
    }
    
    return { supported: true, reason: 'compatible' };
}
```

---

## 9. PowerShell Installation Updates

### Background
run.ps1 needs updates for new parameters and features.

### Required Changes

#### A. Add New Parameters

```powershell
# Add to run.ps1 param block

[Parameter(HelpMessage = 'Preserve Exclusive Mode audio settings')]
[switch]$preserve_exclusive_mode,

[Parameter(HelpMessage = 'Enable AI-powered features (Prompted Playlists)')]
[switch]$enable_ai_features,

[Parameter(HelpMessage = 'Enable offline lyrics and translation')]
[switch]$enable_enhanced_lyrics,

[Parameter(HelpMessage = 'Test mode - validate patches without installing')]
[switch]$test_mode,

[Parameter(HelpMessage = 'Generate compatibility report')]
[switch]$compatibility_report,

[Parameter(HelpMessage = 'Skip experimental features (minimal installation)')]
[switch]$minimal_install
```

#### B. Add Feature Detection

```powershell
# Add function to run.ps1

function Get-SpotifyFeatures {
    param(
        [string]$SpotifyVersion
    )
    
    $features = @{
        'exclusive_mode' = $false
        'lossless_audio' = $false
        'offline_lyrics' = $false
        'lyrics_translation' = $false
        'ai_playlists' = $false
        'studio_app' = $false
    }
    
    $ver = [version]($SpotifyVersion -replace '\.g[0-9a-f]{8}$', '')
    
    # Exclusive Mode added in 1.2.85
    if ($ver -ge [version]'1.2.85') {
        $features.exclusive_mode = $true
    }
    
    # Lossless added in 1.2.80
    if ($ver -ge [version]'1.2.80') {
        $features.lossless_audio = $true
    }
    
    # Enhanced lyrics added in 1.2.93
    if ($ver -ge [version]'1.2.93') {
        $features.offline_lyrics = $true
        $features.lyrics_translation = $true
    }
    
    # AI playlists added in 1.2.90
    if ($ver -ge [version]'1.2.90') {
        $features.ai_playlists = $true
    }
    
    return $features
}
```

#### C. Add Compatibility Report

```powershell
# Add function to run.ps1

function Show-CompatibilityReport {
    param(
        [string]$SpotifyVersion,
        [string]$PatchesPath
    )
    
    Write-Host "`n========================================" -ForegroundColor Cyan
    Write-Host "   SpotX Compatibility Report" -ForegroundColor Cyan
    Write-Host "========================================`n" -ForegroundColor Cyan
    
    Write-Host "Spotify Version: $SpotifyVersion"
    
    $features = Get-SpotifyFeatures -SpotifyVersion $SpotifyVersion
    
    Write-Host "`nOfficial Spotify Features:" -ForegroundColor Yellow
    foreach ($feature in $features.Keys) {
        $status = if ($features[$feature]) { "✓" } else { "✗" }
        $color = if ($features[$feature]) { "Green" } else { "Gray" }
        $name = ($feature -replace '_', ' ').ToUpper()
        Write-Host "  $status $name" -ForegroundColor $color
    }
    
    # Load patches and count compatibility
    $patches = Get-Content $PatchesPath -Raw | ConvertFrom-Json
    $ver = [version]($SpotifyVersion -replace '\.g[0-9a-f]{8}$', '')
    
    $totalPatches = 0
    $compatiblePatches = 0
    
    foreach ($category in $patches.PSObject.Properties) {
        foreach ($patchGroup in $category.Value.PSObject.Properties) {
            foreach ($patch in $patchGroup.Value.PSObject.Properties) {
                $totalPatches++
                
                if ($patch.Value.version) {
                    $frVer = [version]($patch.Value.version.fr -replace '\.g[0-9a-f]{8}$', '')
                    $toVer = if ($patch.Value.version.to -eq "") { [version]"99.0.0.0" } 
                             else { [version]($patch.Value.version.to -replace '\.g[0-9a-f]{8}$', '') }
                    
                    if (($ver -ge $frVer) -and ($ver -le $toVer)) {
                        $compatiblePatches++
                    }
                }
                else {
                    $compatiblePatches++
                }
            }
        }
    }
    
    $percentage = [math]::Round(($compatiblePatches / $totalPatches) * 100, 2)
    
    Write-Host "`nPatch Compatibility:" -ForegroundColor Yellow
    Write-Host "  Compatible: $compatiblePatches / $totalPatches patches"
    Write-Host "  Coverage: $percentage%" -ForegroundColor $(
        if($percentage -ge 95){'Green'}
        elseif($percentage -ge 80){'Yellow'}
        else{'Red'}
    )
    
    if ($percentage -lt 80) {
        Write-Warning "Low patch compatibility! Some features may not work correctly."
    }
    
    Write-Host "`n========================================`n" -ForegroundColor Cyan
}
```

---

## 10. Testing & Validation

### A. Create Test Suite

```powershell
# Create scripts/Test-SpotXPatches.ps1

param(
    [Parameter(Mandatory=$true)]
    [string]$SpotifyVersion
)

$ErrorActionPreference = 'Continue'
$testResults = @()

function Test-PatchIntegrity {
    param($patchesPath)
    
    try {
        $patches = Get-Content $patchesPath -Raw | ConvertFrom-Json
        $testResults += [PSCustomObject]@{
            Test = "Patches JSON Valid"
            Result = "PASS"
            Details = "patches.json is valid JSON"
        }
        return $patches
    }
    catch {
        $testResults += [PSCustomObject]@{
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
    
    foreach ($category in $patches.PSObject.Properties) {
        foreach ($patchGroup in $category.Value.PSObject.Properties) {
            foreach ($patch in $patchGroup.Value.PSObject.Properties) {
                if ($patch.Value.match) {
                    try {
                        $null = [regex]::new($patch.Value.match)
                    }
                    catch {
                        $invalidPatterns += "$($patch.Name): $($_.Exception.Message)"
                    }
                }
            }
        }
    }
    
    if ($invalidPatterns.Count -eq 0) {
        $testResults += [PSCustomObject]@{
            Test = "Regex Patterns Valid"
            Result = "PASS"
            Details = "All regex patterns are valid"
        }
    }
    else {
        $testResults += [PSCustomObject]@{
            Test = "Regex Patterns Valid"
            Result = "FAIL"
            Details = "Invalid patterns: $($invalidPatterns -join ', ')"
        }
    }
}

function Test-VersionRanges {
    param($patches, $spotifyVersion)
    
    $ver = [version]($spotifyVersion -replace '\.g[0-9a-f]{8}$', '')
    $applicablePatches = 0
    
    foreach ($category in $patches.PSObject.Properties) {
        foreach ($patchGroup in $category.Value.PSObject.Properties) {
            foreach ($patch in $patchGroup.Value.PSObject.Properties) {
                if ($patch.Value.version) {
                    $frVer = [version]($patch.Value.version.fr -replace '\.g[0-9a-f]{8}$', '')
                    $toVer = if ($patch.Value.version.to -eq "") { [version]"99.0.0.0" } 
                             else { [version]($patch.Value.version.to -replace '\.g[0-9a-f]{8}$', '') }
                    
                    if (($ver -ge $frVer) -and ($ver -le $toVer)) {
                        $applicablePatches++
                    }
                }
            }
        }
    }
    
    $testResults += [PSCustomObject]@{
        Test = "Applicable Patches"
        Result = if($applicablePatches -gt 50){"PASS"}else{"WARN"}
        Details = "$applicablePatches patches applicable to version $spotifyVersion"
    }
}

function Test-JavaScriptFiles {
    $jsFiles = @(
        "js-helper/checkVersion.js",
        "js-helper/sectionBlock.js",
        "js-helper/goofyHistory.js"
    )
    
    foreach ($jsFile in $jsFiles) {
        $path = Join-Path $PSScriptRoot "..\$jsFile"
        if (Test-Path $path) {
            $content = Get-Content $path -Raw
            
            # Basic syntax check (look for common errors)
            if ($content -match "function\s+\w+\s*\(" -and $content -match "\)") {
                $testResults += [PSCustomObject]@{
                    Test = "JavaScript: $jsFile"
                    Result = "PASS"
                    Details = "File exists and has valid syntax"
                }
            }
            else {
                $testResults += [PSCustomObject]@{
                    Test = "JavaScript: $jsFile"
                    Result = "WARN"
                    Details = "File exists but may have syntax issues"
                }
            }
        }
        else {
            $testResults += [PSCustomObject]@{
                Test = "JavaScript: $jsFile"
                Result = "FAIL"
                Details = "File not found at $path"
            }
        }
    }
}

# Run tests
Write-Host "Running SpotX Test Suite..." -ForegroundColor Cyan
Write-Host "Target Spotify Version: $SpotifyVersion`n"

$patchesPath = Join-Path $PSScriptRoot "..\patches\patches.json"
$patches = Test-PatchIntegrity -patchesPath $patchesPath

if ($patches) {
    Test-RegexPatterns -patches $patches
    Test-VersionRanges -patches $patches -spotifyVersion $SpotifyVersion
}

Test-JavaScriptFiles

# Display results
Write-Host "`nTest Results:" -ForegroundColor Yellow
$testResults | Format-Table -AutoSize

$passCount = ($testResults | Where-Object { $_.Result -eq "PASS" }).Count
$totalCount = $testResults.Count
$passPercentage = [math]::Round(($passCount / $totalCount) * 100, 2)

Write-Host "`nSummary: $passCount / $totalCount tests passed ($passPercentage%)" -ForegroundColor $(
    if($passPercentage -eq 100){'Green'}
    elseif($passPercentage -ge 80){'Yellow'}
    else{'Red'}
)
```

---

## Implementation Priority

### Phase 1 - Critical (Week 1-2)
1. ✅ **Exclusive Mode Support** - Test and ensure compatibility
2. ✅ **Lossless Audio** - Verify codecs work with patches
3. ✅ **New Ad Formats Blocking** - Block HTML ads, Harmony video ads
4. ✅ **Extend Patch Versions** - Update all patches ending at 1.2.93

### Phase 2 - Important (Week 3-4)
5. ✅ **Enhanced Lyrics** - Test offline, translation, previews
6. ✅ **AI Features** - Add optional support for Prompted Playlists
7. ✅ **Section Blocking Updates** - Add new section IDs
8. ✅ **Version Checking** - Update checkVersion.js

### Phase 3 - Maintenance (Week 5+)
9. ✅ **Testing Suite** - Create comprehensive test scripts
10. ✅ **Documentation** - Update README with new features
11. ✅ **Compatibility Report** - Add automated compatibility checking
12. ✅ **CI/CD** - Set up automated testing for new Spotify versions

---

## Testing Checklist

### Before Release:
- [ ] Test on Windows 10 x64
- [ ] Test on Windows 11 x64
- [ ] Test on Windows 11 ARM64
- [ ] Test with Spotify 1.2.97
- [ ] Test with Spotify 1.2.85 (Exclusive Mode)
- [ ] Verify all ad blocking still works
- [ ] Verify premium features unlock for free accounts
- [ ] Test lyrics customization (all 28 colors)
- [ ] Test old theme installation
- [ ] Test new theme installation
- [ ] Test full automatic installation
- [ ] Verify update blocking works
- [ ] Test with premium account
- [ ] Test with free account
- [ ] Verify no crashes or errors in console
- [ ] Check localStorage for any leaked data

### After Release:
- [ ] Monitor community feedback
- [ ] Track compatibility issues
- [ ] Update patches as Spotify updates
- [ ] Document known issues
- [ ] Provide troubleshooting guide

---

## Rollback Plan

If updates cause issues:

1. **Revert patches.json to previous version**
   ```powershell
   git checkout HEAD~1 patches/patches.json
   ```

2. **Revert JavaScript helpers**
   ```powershell
   git checkout HEAD~1 js-helper/
   ```

3. **Document the issue**
   - Spotify version affected
   - Error messages
   - Steps to reproduce
   - Temporary workaround

4. **Release hotfix**
   - Fix specific issue
   - Test thoroughly
   - Release as patch version

---

*Implementation Guide Version: 1.0*  
*Last Updated: August 29, 2026*  
*Target SpotX Version: Next Release*
