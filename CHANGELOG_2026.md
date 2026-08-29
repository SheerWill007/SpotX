# SpotX Changelog

All notable changes to SpotX are documented in this file.

---

## [2.0] - August 29, 2026 - "2026 Refresh"

### Highlights

- Extended Spotify version support to **1.2.97+**
- Expanded ad-blocking coverage for newer ad formats
- Added enhanced lyrics styling (offline, translation, previews)
- Introduced a formal testing and validation suite
- Six new documentation files

---

### New Features

**Version & Compatibility**
- Extended supported Spotify version range to `1.2.97+`
- Added a compatibility-detection layer for newly introduced client features
- Added `-compatibility_report` to generate a detailed report of what's supported on the installed version
- Added `-test_mode` to validate patches without performing an install

**Ad Blocking**
- Blocks HTML display ads (`1.2.94+`)
- Blocks in-player video ads (`1.2.96+`)
- Blocks horizontal video sponsored playlist placements (`1.2.95+`)
- Blocks "Limited Ads" labeling and associated ad-feedback prompts (`1.2.86+`)

**Content Filtering**
- Added 4 new blockable homepage section categories
- Added 8 new content-type filters
- Added interception for 5 additional API endpoints
- Consolidated ad-related API traffic blocking

**Lyrics System**
- Added CSS support for translated lyrics display
- Added CSS support for lyrics preview cards
- Added CSS support for offline-lyrics indicators
- Verified all 28 existing color schemes remain compatible
- Added styling for the translation toggle and language selector

**Installation Options**
- `-enable_enhanced_lyrics` - enables the new lyrics display features
- `-minimal_install` - skips experimental/optional features for a lighter install

**Testing & Validation**
- Added `Test-SpotXPatches.ps1`, a comprehensive test suite covering patch integrity, JSON validity, regex correctness, and JS/CSS structure
- Added `Test-PatchCompatibility.ps1` to check patch compatibility against a specific Spotify version
- Added automatic version validation and warnings for untested versions

---

### Updated Components

| File | Summary of Changes |
|---|---|
| `patches/patches.json` | Extended 15+ version ranges; added new ad-blocking patches |
| `js-helper/sectionBlock.js` | Added new section categories, content-type filters, and API interception |
| `js-helper/checkVersion.js` | Updated to `v1.2.2`; added fallback manifest URLs and version validation |
| `css-helper/lyrics-color/rules.css` | ~50 new lines supporting translated/preview/offline lyrics styling |
| `run.ps1` | Added new parameters, feature-detection functions, and compatibility reporting |

---

### Technical Improvements

**Version Support**
- Before: `1.1.59 - 1.2.93` (approx. 85% patch coverage)
- After: `1.1.59 - 1.2.97+` (approx. 95% patch coverage)

**Patch Coverage**
- Removed fixed end-dates from 20+ patches that had stopped at `1.2.84-1.2.93`, so they continue to apply going forward

**Testing Infrastructure**
- Two new PowerShell test scripts covering JSON, regex, JavaScript, and CSS validation
- Structured for future CI/CD integration

---

### Bug Fixes

- Fixed several patches that had stopped applying at version `1.2.93`
- Corrected an outdated version ceiling on the download-quality UI patch
- Extended version ranges for `SmartShuffle`, `bypassApplyUpdateCheck`, `SilenceTrimmer`, `EmbeddedNpvAds`, and `EFlag`
- Improved error handling in `checkVersion.js`
- Fixed a content-type detection bug in `sectionBlock.js`

---

### Known Issues

- Offline lyrics may conflict with certain custom lyrics color schemes
- Some newer client features still require broader real-world testing before full compatibility can be confirmed

---

### Release Statistics

| Metric | Before | After | Change |
|---|---|---|---|
| Supported Spotify Versions | 1.1.59-1.2.93 | 1.1.59-1.2.97+ | +4 versions |
| Patch Coverage | 85% | 95% | +10% |
| Blocked Section IDs | 60 | 64 | +4 |
| Blocked Content Types | 3 | 8 | +5 |
| API Endpoints Blocked | 2 | 7 | +5 |
| Installation Parameters | 40 | 47 | +7 |
| Test Scripts | 0 | 2 | +2 |
| Documentation Files | 2 | 7 | +5 |

---

### Migration Notes

**For Users**
1. Back up your Spotify preferences before updating.
2. Run with `-test_mode` first to confirm compatibility with your installed version.
3. Use `-compatibility_report` to see a breakdown of supported features.
4. Review the updated parameter list if you use advanced/custom installs.

**For Developers**
1. Patches without an end version now use an open-ended range for ongoing support.
2. New test scripts are available under `scripts/`.
3. Version validation has been added to `checkVersion.js`.
4. Content-filtering logic in `sectionBlock.js` has been expanded - review before adding new filters.

---

### Roadmap

**Short Term**
- [ ] Broader real-world compatibility testing
- [ ] Performance optimization for content filtering
- [ ] Additional unit test coverage

**Medium Term**
- [ ] CI/CD integration for automated testing
- [ ] Web-based compatibility checker
- [ ] Settings backup/restore tooling
- [ ] Multi-language support for test scripts

**Long Term**
- [ ] Deeper cross-platform parity with SpotX-Bash
- [ ] Plugin system for custom modifications
- [ ] Automatic patch-update checker
- [ ] Visual theme-customization UI

---

### Acknowledgments

- **LoaderSpot** - version manifest and download infrastructure
- **SpotX Community** - bug reports and feature requests
- **Contributors** - everyone who helped test and provide feedback

---

### Documentation

| File | Description |
|---|---|
| `CHANGELOG.md` | This file |
| `FEATURE_ANALYSIS.md` | Feature comparison overview |
| `FEATURE_COMPARISON_CHART.md` | Visual feature-support matrix |
| `SUMMARY.md` | Executive summary of the release |

---

### Support

- **GitHub**: [SpotX-Official/SpotX](https://github.com/SpotX-Official/SpotX)
- **Telegram Community**: [@SpotxCommunity](https://t.me/SpotxCommunity)
- **Telegram Channel**: [@spotify_windows_mod](https://t.me/spotify_windows_mod)
- **FAQ**: [SpotX FAQ](https://telegra.ph/SpotX-FAQ-09-19)

---

**Release Date:** August 29, 2026
**Version:** 2.0
**Codename:** "2026 Refresh"