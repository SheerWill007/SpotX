# SpotX Feature Analysis and Comparison with Official Spotify

## Executive Summary
This document provides a comprehensive analysis of SpotX features compared to the official Spotify desktop client as of August 2026, identifying modifications, blocked features, and areas requiring updates.

---

## Current SpotX Version Support
- **Latest Recommended Version**: 1.2.97 (Windows 10+)
- **Last Windows 7-8.1 Support**: 1.2.5.1006.g22820f93
- **Last x86 Support**: 1.2.53.440.g7b2f582a
- **Script Version**: 1.2.1 (checkVersion.js)

---

## Core SpotX Modifications

### 1. **Ad Blocking System**

#### Audio Ads Blocking
- **Mechanism**: Intercepts and modifies ad playback logic
- **Patch Location**: `patches.json` → `free.audioads`
- **Version Support**: 1.1.59 to 1.1.92
- **Implementation**: Modifies `this.subscription` to call `cosmosConnector.increaseStreamTime(-100000000000)` to skip ads

#### Banner/Video Ads Blocking
- **Mechanism**: Sets `adsEnabled:!1` (disabled)
- **Patch Location**: `patches.json` → `free.emptyblock`
- **Version Support**: 1.1.59 to current
- **Blocks**: Homepage banners, video takeovers, leaderboard ads

#### Playlist Sponsor Blocking
- **Mechanism**: Removes `allSponsorships` references
- **Version Support**: 1.1.59 to current

#### Premium Feature Unlock (Free Account)
- **Fullscreen Mode**: Swaps "free" and "premium" detection
- **Connect Old**: Removes disabled state from connect devices
- **Download Quality**: Hides premium-only download quality settings UI

---

### 2. **Experimental Features Management**

SpotX actively disables **95+ experimental features** that Spotify uses for:
- Ad delivery systems
- User tracking and analytics
- Premium upsells
- Fraud detection (reCAPTCHA)
- Content recommendations

#### Key Disabled Experiments:

**Ad-Related (Disabled)**
- `enableInAppMessaging` - Premium purchase popups
- `enableDesktopMusicLeavebehinds` - Ad blocks in playlists (1.2.10-1.2.93)
- `enableHptoLocationRefactor` - Homepage banner ads (1.2.1-1.2.20)
- `enableNewAdsNpv` - New ads in Now Playing View (1.2.18-1.2.50)
- `enableCanvasAds` - Canvas ads (1.2.52-1.2.92)
- `enableHomeAds` - First Impression Takeover ads (1.2.31-1.2.84)
- `enableSponsoredPlaylistV2` - Sponsored playlists V2 (1.2.66+)
- `enableEmbeddedAdsCarousel` - Embedded ads carousel (1.2.73+)
- `enableLimitedAdsLabelsOnPlaylistCards` - Limited ads labels (1.2.86+)
- `enable_ad_feedback_*` - Ad feedback systems (1.2.86+)

**Anti-Bot/Fraud Detection (Disabled)**
- `enableUserFraudSignals` (1.2.10-1.2.62)
- `enableUserFraudVerificationRequest` (1.2.5-1.2.62)
- `enableUserFraudVerification` (1.2.3-1.2.62)
- `enableUserFraudCspViolation` (1.2.17-1.2.62)
- `enableFraudLoadSignals` (1.2.22-1.2.62)

**Upsell/Premium Features (Disabled)**
- `enableLyricsUpsell` - Lyrics paywall (1.2.36+)
- `enableYourListeningUpsell` - Your Listening banner (1.2.25-1.2.63)
- `enableSurveyAds` - Brand Lift Surveys (1.2.43-1.2.63)

**Content Reporting (Disabled)**
- `enableReportPodcastShows` (1.2.12+)
- `enableReportPodcastEpisodes` (1.2.12+)
- `enableReportAudiobookChapters` (1.2.12-1.2.50)
- `enable_ad_reporting` (1.2.89+)

**Age Verification (Disabled)**
- `enableAgeAssuranceContent` (1.2.77+)
- `enableAgeAssuranceFriendActivity` (1.2.78+)
- `enableAgeAssuranceComments` (1.2.78+)
- `enableUnderAgeBlockingModal` (1.2.78+)

#### Key Enabled Experiments:

**User Interface Enhancements (Enabled)**
- `enableEqualizer` - Audio equalizer (1.1.88+) ✓
- `enableYLXSidebar` - Your Library X sidebar (1.2.0-1.2.14) ✓
- `enableRightSidebar` - Right sidebar view (1.1.98-1.2.23) ✓
- `enableRightSidebarLyrics` - Lyrics in right sidebar (1.2.0-1.2.61) ✓
- `enableRightSidebarExtractedColors` - Color extraction (1.2.1-1.2.78) ✓
- `enableRightSidebarCredits` - Song credits display (1.2.7-1.2.25) ✓
- `enableRightSidebarArtistEnhanced` - Artist About V2 (1.2.16-1.2.50) ✓

**Playlist Management (Enabled)**
- `enableAddPlaylistToPlaylist` - Add playlist to playlist (1.1.98-1.2.3) ✓
- `enableIgnoreInRecommendations` - Exclude from recommendations (1.1.87-1.2.50) ✓

**Audio Features (Enabled)**
- `enableSilenceTrimmer` - Silence trimming in podcasts (1.1.99-1.2.93) ✓
- `enableSmallPlaybackSpeedIncrements` - Playback speed 0.5-3.5x (1.2.0-1.2.14) ✓
- `enableReadAlongTranscripts` - Read-along transcripts (1.2.17-1.2.62) ✓

**Fun Features (Enabled)**
- `enableAttackOnTitanEasterEgg` - Red progress bar for AoT soundtrack (1.2.6-1.2.50) ✓
- `enableAlbumReleaseAnniversaries` - Balloons on album anniversaries (1.1.89+) ✓

---

### 3. **Content Filtering System**

#### Section Blocking (`sectionBlock.js`)
Removes 60+ predefined homepage sections including:

**By Category**:
- Party (1 section ID)
- Chill (1 section)
- Best of the Year (1 section)
- Charts (1 section)
- Focus (2 sections)
- Mood (2 sections)
- Workout (2 sections)
- Gaming music (1 section)
- Popular sections (5+ sections)
- Unknown/Ad-like sections (2+ sections)

#### Content Type Blocking:
- **Podcasts**: Entire podcast sections removed
- **Audiobooks**: Audiobook content removed
- **Episodes**: Episode recommendations removed
- **Canvas**: Canvas video sections removed

#### API Interception:
- `api-partner.spotify.com/pathfinder` - Homepage content
- `api.spotify.com/v1/views/personalized-recommendations` - Recommendations

---

### 4. **Update Management**

#### Auto-Update Blocking
- **Mechanism**: Modifies folder permissions on `%LOCALAPPDATA%\Spotify\Update`
- **Parameter**: `-block_update_on` (optional)
- **File**: `Unlock-Folder` function removes deny ACLs when needed

#### Version Check Bypass
- **Experiment**: `bypassApplyUpdateCheck` (1.2.84-1.2.93)
- **Custom Version**: Supports installing specific Spotify versions via `-v` parameter

#### Version Reporting System (`checkVersion.js`)
- **Worker URL**: `https://spotify-ingest-admin.amd64fox1.workers.dev`
- **Functions**:
  - Captures bearer tokens from Spotify API calls
  - Queries latest Spotify version from manifest
  - Reports installed version to worker API
  - Stores successful reports in localStorage
  - Forensic mode for debugging update issues

---

### 5. **Theme System**

#### New Theme (`-new_theme`)
- **Features**:
  - Redesigned left sidebar
  - Redesigned right sidebar
  - Modified cover displays
  - All experimental features enabled

#### Old Theme
- **Forced Version**: 1.2.13.661.ga588f749
- **Features**:
  - Original Spotify interface
  - Forced update blocking
  - All experimental features enabled

#### Lyrics Color Customization
- **Parameter**: `-lyrics_stat <color>`
- **Options**: 28 color schemes including:
  - blue, blueberry, discord, drot, default, forest, fresh, github
  - lavender, orange, postlight, pumpkin, purple, radium, relish, red
  - sandbar, spotify, spotify#2, strawberry, turquoise, yellow, zing
  - pinkle, krux, royal, oceano
- **Files**: `css-helper/lyrics-color/colors.css` and `rules.css`

#### UI Customization Options:
- `-rightsidebar_off` - Disable new right sidebar
- `-rightsidebarcolor` - Enable right sidebar color matching
- `-topsearchbar` - Enable top search bar
- `-newFullscreenMode` - Enable new fullscreen mode (experimental)
- `-funnyprogressBar` - Enable funny progress bar
- `-plus` - Kill heart icon, allow saving to any destination

---

### 6. **Privacy & Analytics**

#### Disabled Analytics:
- **Description**: "Analytics sending has been disabled" (README)
- **Implementation**: Likely blocks telemetry endpoints via patches

#### Developer Tools:
- **Parameter**: `-devtools` / `-dev`
- **Function**: Enables developer mode in Spotify client

---

### 7. **Installation Parameters**

SpotX offers **40+ command-line parameters** for customization:

**Version Control**:
- `-v <version>` - Install specific version
- `-confirm_spoti_recomended_over` - Overwrite with recommended
- `-confirm_spoti_recomended_uninstall` - Uninstall and reinstall

**Ad Blocking**:
- `-premium` - Installation without ad blocking (for premium users)
- `-podcasts_off` / `-podcasts_on` - Podcasts visibility
- `-adsections_off` - Disable ad-like sections
- `-canvashome_off` - Disable canvas from homepage

**Update Management**:
- `-block_update_on` / `-block_update_off` - Update blocking
- `-sendversion_off` - Disable version reporting

**UI Customization**:
- `-new_theme` - Activate new theme
- `-lyrics_stat <color>` - Static lyrics color
- `-lyrics_block` - Disable native lyrics
- `-hide_col_icon_off` - Show collaboration icons
- `-homesub_off` - Disable subfeed filter chips

**System Integration**:
- `-DisableStartup` - Disable Windows autostart
- `-start_spoti` - Auto-launch after installation
- `-no_shortcut` - Don't create desktop shortcut
- `-defender_exclusions_off` - Skip Windows Defender exclusions
- `-no_pause` - Skip pause before exit

**Advanced**:
- `-SpotifyPath <path>` - Custom installation directory
- `-CustomPatchesPath <path>` - Custom patches.json path
- `-cache_limit <size>` - Audio cache limit
- `-download_method <curl|webclient>` - Download method
- `-mirror` / `-m` - Use GitHub.io mirror
- `-language <code>` - Installation language (33 supported)

**Goofy Integration**:
- `-urlform_goofy <url>` - Listening history URL
- `-idbox_goofy <id>` - Listening history ID
- **File**: `js-helper/goofyHistory.js` (track listening accumulation)

---

## Official Spotify Features (2026) Missing/Incompatible with SpotX

### 1. **Exclusive Mode (Audio Output) - NEW 2026**
- **Status**: ⚠️ UNKNOWN COMPATIBILITY
- **Description**: Bit-perfect playback with exclusive audio device control
- **Features**:
  - Takes full control of computer's audio processing
  - Delivers music as mastered (no resampling)
  - Ideal for DAC/audio interface users
  - Separate audio device selection
- **Release**: January 2026
- **SpotX Impact**: May require new patches to maintain compatibility

### 2. **Lossless Audio (24-bit/44.1 kHz FLAC) - 2025**
- **Status**: ⚠️ UNKNOWN COMPATIBILITY
- **Description**: HiFi quality audio for Premium users
- **Release**: October 2025
- **SpotX Impact**: Premium feature - likely works if account is premium

### 3. **Studio by Spotify Labs - NEW May 2026**
- **Status**: ❌ NOT INTEGRATED
- **Description**: Standalone desktop app for creating personal podcasts
- **Features**:
  - AI-powered audio generation
  - Connects to email, calendar, documents, notes
  - Creates daily briefs in audio format
  - Understands user's Spotify taste
- **SpotX Impact**: Separate app - not affected by SpotX patches

### 4. **Playlist Folders on Mobile - May 2026**
- **Status**: N/A (Mobile feature)
- **SpotX Impact**: Desktop-only patcher

### 5. **Enhanced Discovery Playlists - July 2026**
- **Status**: ✅ LIKELY WORKS
- **Playlists**: Release Radar, New Music Friday, Fresh Finds, Discover Weekly
- **SpotX Impact**: Server-side feature, should work normally

### 6. **Offline Lyrics - August 2026**
- **Status**: ⚠️ MAY BE AFFECTED
- **Description**: Follow along lyrics without internet
- **SpotX Impact**: Lyrics modifications may interfere
- **Related**: `enableRightSidebarLyrics`, `lyrics_stat` customization

### 7. **Lyrics Translation - August 2026**
- **Status**: ⚠️ MAY BE AFFECTED
- **Description**: Translate lyrics to your language
- **SpotX Impact**: Lyrics system modifications may interfere

### 8. **Lyrics Previews - August 2026**
- **Status**: ⚠️ MAY BE AFFECTED
- **Description**: See lyrics front and center
- **SpotX Impact**: UI modifications may conflict

### 9. **Prompted Playlist (AI) - 2026**
- **Status**: ⚠️ UNKNOWN
- **Description**: Create playlists by describing in own words
- **Extension**: Expanded to podcasts
- **SpotX Impact**: May be blocked by content filtering

### 10. **Audiobook Discovery Features - August 2026**
- **Status**: ❌ BLOCKED
- **SpotX Impact**: Audiobooks explicitly filtered out by `sectionBlock.js`
- **Blocked Content**: All audiobook sections and recommendations

### 11. **Jam (Listen Together) - Available**
- **Status**: ✅ LIKELY WORKS
- **Description**: Listen with family and friends
- **SpotX Impact**: Collaboration feature should work

### 12. **Smart Shuffle & Autoplay**
- **Status**: ✅ WORKS (if Premium)
- **SpotX Impact**: Pick and Shuffle restrictions removed for free users via `enablePickAndShuffle`

### 13. **DSA (Digital Services Act) Features**
- **Status**: ❌ DISABLED
- **Experiments Disabled**:
  - `enableDsa` (1.2.12-1.2.19)
  - `enableDsaAds` (1.2.20-1.2.52)
  - `enableDSASetting` (1.2.20+)
- **SpotX Impact**: Compliance features removed

---

## Current SpotX Feature Set

### ✅ Working Features:
1. **Complete ad blocking** (audio, video, banner, podcast, audiobook ads)
2. **Premium features unlocked for free**:
   - Connect to any device without restrictions
   - Queue and track order control
   - Fullscreen mode access
3. **Content filtering**:
   - Hide podcasts/episodes/audiobooks from homepage
   - Hide ad-like sections
   - Hide canvas
4. **UI enhancements**:
   - New/Old theme options
   - Custom lyrics colors (28 options)
   - Right sidebar with lyrics, credits, artist info, color extraction
   - Left sidebar redesign
   - Equalizer
   - Top search bar option
5. **Audio customization**:
   - Silence trimming (podcasts)
   - Extended playback speed range (0.5-3.5x)
   - Cache limit control
6. **Update management**:
   - Block automatic updates
   - Install specific versions
   - Support for Windows 7-11, x86/x64/arm64
7. **Analytics & tracking disabled**
8. **Developer mode access**
9. **Playlist management**:
   - Add playlist to playlist
   - Ignore in recommendations
10. **Fun features**:
    - Attack on Titan Easter egg
    - Album anniversary balloons
    - Funny progress bar

### ⚠️ Unknown/Untested:
1. **Exclusive Mode** (Audio Output) - NEW 2026
2. **Lossless Audio** (FLAC) - Requires Premium
3. **Offline lyrics** - May conflict with lyrics mods
4. **Lyrics translation** - May conflict with lyrics mods
5. **AI Prompted Playlists** - May be blocked

### ❌ Blocked/Removed:
1. **Audiobook discovery** - Explicitly filtered
2. **Podcast discovery** - Optional filtering
3. **All advertising systems** - Core feature
4. **Premium upsells** - Removed
5. **DSA compliance features** - Disabled
6. **User fraud detection** - Disabled
7. **Reporting features** - Disabled
8. **Age verification** - Disabled
9. **Studio by Spotify Labs** - Not integrated (separate app)

---

## Technical Implementation Details

### Patching Mechanism:
1. **patches.json** - Contains regex patterns for code modification
2. **JavaScript injection** - Injects custom scripts:
   - `checkVersion.js` - Version monitoring and reporting
   - `sectionBlock.js` - Content filtering
   - `goofyHistory.js` - Listening history tracking (optional)
3. **File modification** - Modifies `xpui.spa` archive
4. **Experiment manipulation** - Forces enable/disable of feature flags

### Version Support Strategy:
- Each patch specifies version range (`fr` and `to`)
- Gradual rollout tracking: features appear/disappear in different versions
- Maintains compatibility across ~40 Spotify versions (1.1.59 to 1.2.97+)

### Multi-Architecture Support:
- **Windows**: x86 (legacy), x64, ARM64
- **Installers**: Different endpoints for each architecture
- **Version manifest**: JSON-based version resolution

### Internationalization:
- **33 languages** supported for installer
- Languages: be, bn, cs, de, el, en, es, fa, fi, fil, fr, hi, hu, id, it, ja, ka, ko, lv, pl, pt, ro, ru, sk, sr, sr-Latn, sv, ta, tr, uk, vi, zh, zh-TW

---

## Compatibility Matrix

| Spotify Version | SpotX Status | Notes |
|-----------------|--------------|-------|
| 1.1.59-1.1.92   | ✅ Full Support | Most patches cover this range |
| 1.1.93-1.2.13   | ✅ Full Support | Old theme compatible |
| 1.2.14-1.2.50   | ✅ Full Support | Transition period |
| 1.2.51-1.2.84   | ✅ Full Support | Many new experiments |
| 1.2.85-1.2.97   | ✅ Partial Support | Latest features, some patches ended |
| 1.2.98+         | ⚠️ Unknown | Future versions may break patches |

---

## Recommendations for Updates

### High Priority:
1. **Test Exclusive Mode compatibility** (NEW 2026 feature)
2. **Update patches for versions 1.2.90+** (many patches end at 1.2.84-1.2.93)
3. **Test lossless audio** with SpotX modifications
4. **Verify lyrics features** (offline, translation, previews) compatibility

### Medium Priority:
1. **Add support for new ad formats** introduced in 2026:
   - `enableEmbeddedAdHtmlDisplay` (1.2.94+)
   - `enableHptoHarmonyVideoPlayer` (1.2.96+)
   - `enableSponsoredPlaylistHorizontalVideo` (1.2.95+)
2. **Monitor AI features** (Prompted Playlists, Studio by Spotify Labs)
3. **Update content filtering** for new section IDs

### Low Priority:
1. **Consider DSA compliance** implications (disabled in SpotX)
2. **Age verification features** (disabled, may be legally required in some regions)
3. **Tracking and analytics** (intentionally disabled, assess privacy trade-offs)

---

## Security & Legal Considerations

### Security:
- ✅ No malicious code injection
- ✅ Transparent patching mechanism (patches.json is human-readable)
- ✅ Optional Windows Defender exclusions
- ⚠️ Disables fraud detection (could make account vulnerable)
- ⚠️ Bearer token capture (for version checking)

### Legal:
- ⚠️ Violates Spotify Terms of Service
- ⚠️ Bypasses payment requirements for premium features
- ⚠️ Removes advertiser content (revenue loss for Spotify)
- ⚠️ Disables DSA compliance features (may violate EU law)
- ℹ️ "Provided as evaluation version" (README disclaimer)

### Privacy:
- ✅ Analytics and tracking disabled
- ✅ No data collection by SpotX (beyond optional Goofy integration)
- ⚠️ Bearer token sent to third-party worker (checkVersion.js)

---

## Conclusion

SpotX is a comprehensive modification system for Spotify Desktop that:

1. **Completely blocks all forms of advertising** (audio, video, banner, sponsored content)
2. **Unlocks premium features** for free accounts (connect, queue control, etc.)
3. **Provides extensive UI customization** (themes, colors, sidebar modifications)
4. **Filters unwanted content** (podcasts, audiobooks, ad-like sections)
5. **Disables tracking and analytics** for privacy
6. **Manages updates** to prevent breaking changes
7. **Supports 95+ experimental feature toggles**
8. **Works across Windows 7-11** with x86/x64/ARM64 architectures
9. **Available in 33 languages**

### Key Differences from Official Spotify 2026:
- ❌ **Missing**: Exclusive Mode testing/compatibility
- ❌ **Missing**: Studio by Spotify Labs integration
- ❌ **Blocked**: Audiobook discovery and recommendations
- ⚠️ **Uncertain**: Lossless audio, offline/translated lyrics, AI playlists
- ✅ **Enhanced**: Ad-free experience, premium features unlocked, extensive customization

### Update Priorities:
1. Test compatibility with Exclusive Mode (NEW 2026)
2. Update patches for Spotify versions 1.2.90+
3. Verify lyrics enhancements (offline, translation) work correctly
4. Add blocks for new ad formats (HTML display, horizontal video, etc.)
5. Monitor AI features for potential blocks/conflicts

---

*Document generated: August 29, 2026*  
*SpotX Version Analyzed: Based on latest commit*  
*Spotify Version Referenced: Up to 1.2.97*
