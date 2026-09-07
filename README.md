<p align="center">
  <a href="https://github.com/SpotX-Official/SpotX/releases">
    <img src="https://spotx-official.github.io/images/logos/logo.png" alt="SpotX Logo" width="180" />
  </a>
</p>

<h1 align="center">SpotX</h1>
<p align="center"><b>An Ad-Blocking and Theming Patcher for the Spotify Desktop Client on Windows</b></p>

<p align="center">
  <a href="https://t.me/spotify_windows_mod"><img src="https://spotx-official.github.io/images/shields/SpotX_Channel.svg" alt="Telegram Channel"></a>
  <a href="https://t.me/SpotxCommunity"><img src="https://spotx-official.github.io/images/shields/SpotX_Community.svg" alt="Telegram Community"></a>
  <a href="https://github.com/SpotX-Official/SpotX-Bash"><img src="https://spotx-official.github.io/images/shields/SpotX_for_Mac&Linux.svg" alt="Mac & Linux Version"></a>
  <a href="https://telegra.ph/SpotX-FAQ-09-19"><img src="https://spotx-official.github.io/images/shields/faq.svg" alt="FAQ"></a>
</p>

<p align="center">
  <a href="#requirements">Requirements</a> •
  <a href="#features">Features</a> •
  <a href="#installation--update">Installation</a> •
  <a href="#uninstall">Uninstall</a> •
  <a href="#faq">FAQ</a> •
  <a href="#contributors">Contributors</a> •
  <a href="#disclaimer">Disclaimer</a>
</p>

---

## Table of Contents

- [Requirements](#requirements)
- [Features](#features)
- [Installation / Update](#installation--update)
- [Uninstall](#uninstall)
- [FAQ](#faq)
- [Community](#community)
- [Contributors](#contributors)
- [Disclaimer](#disclaimer)

---

## Requirements

| Component  | Minimum Version                                                                 |
|------------|----------------------------------------------------------------------------------|
| OS         | Windows 7 – 11                                                                   |
| Spotify    | [Official desktop client](https://loadspot.vercel.app/) (Microsoft Store version not supported) |
| PowerShell | 5.1 or later                                                                     |

---

## Features

- Blocks banner, video, and audio advertisements in the client, including newer ad formats (HTML display ads, in-player video ads, sponsored playlist placements)
- Optionally hides podcasts, episodes, and audiobooks from the homepage
- Optionally blocks automatic Spotify updates
- Theme customization, with a choice between the new and classic UI layouts
- Custom lyrics color schemes (28 options)
- Advanced installation options — see [installation parameters](https://github.com/SpotX-Official/SpotX/discussions/60)

---

## Installation / Update

Choose the installation type that best fits your needs.

<details>
<summary><b>Standard Installation (New Theme)</b></summary>
<br>

Includes the redesigned interface (new sidebars, updated cover art) and all [experimental features](https://github.com/SpotX-Official/SpotX/discussions/50). Requires confirming a few prompts during setup.

**Option 1 — Download and run:**
[Install_New_theme.bat](https://raw.githack.com/amd64fox/SpotX/main/Install_New_theme.bat)

**Option 2 — Run in PowerShell:**
```powershell
iex "& { $(iwr -useb 'https://raw.githubusercontent.com/SpotX-Official/SpotX/refs/heads/main/run.ps1') } -new_theme"
```

**Mirror:**
```powershell
iex "& { $(iwr -useb 'https://spotx-official.github.io/SpotX/run.ps1') } -m -new_theme"
```
</details>

<details>
<summary><b>Standard Installation (Old Theme)</b></summary>
<br>

Includes:
- Forced install of version `1.2.13` (the old theme was removed in later releases)
- Classic UI theme
- Automatic blocking of Spotify updates
- All [experimental features](https://github.com/SpotX-Official/SpotX/discussions/50)

**Option 1 — Download and run:**
[Install_Old_theme.bat](https://raw.githack.com/amd64fox/SpotX/main/Install_Old_theme.bat)

**Option 2 — Run in PowerShell:**
```powershell
iex "& { $(iwr -useb 'https://raw.githubusercontent.com/SpotX-Official/SpotX/refs/heads/main/run.ps1') } -v 1.2.13.661.ga588f749 -confirm_spoti_recomended_over -block_update_on"
```

**Mirror:**
```powershell
iex "& { $(iwr -useb 'https://spotx-official.github.io/SpotX/run.ps1') } -m -v 1.2.13.661.ga588f749 -confirm_spoti_recomended_over -block_update_on"
```
</details>

<details>
<summary><b>Full Installation (No Prompts)</b></summary>
<br>

A hands-off install that performs the following automatically:

- Activates the new theme (updated sidebars, cover art)
- Hides podcasts, episodes, and audiobooks from the homepage
- Applies the [static lyrics theme](https://github.com/SpotX-Official/SpotX/discussions/50#discussioncomment-4096066) (`spotify`)
- Hides [ad-like sections](https://github.com/SpotX-Official/SpotX/discussions/50#discussioncomment-4478943)
- Enables all [experimental features](https://github.com/SpotX-Official/SpotX/discussions/50)
- Installs the recommended Spotify version
- Blocks future Spotify updates
- Automatically launches Spotify once installation completes

**Option 1 — Download and run:**
[Install_Auto.bat](https://raw.githack.com/amd64fox/SpotX/main/scripts/Install_Auto.bat)

**Option 2 — Run in PowerShell:**
```powershell
iex "& { $(iwr -useb 'https://raw.githubusercontent.com/SpotX-Official/SpotX/refs/heads/main/run.ps1') } -confirm_uninstall_ms_spoti -confirm_spoti_recomended_over -podcasts_off -block_update_on -start_spoti -new_theme -adsections_off -lyrics_stat spotify"
```

**Mirror:**
```powershell
iex "& { $(iwr -useb 'https://spotx-official.github.io/SpotX/run.ps1') } -m -confirm_uninstall_ms_spoti -confirm_spoti_recomended_over -podcasts_off -block_update_on -start_spoti -new_theme -adsections_off -lyrics_stat spotify"
```
</details>

<details>
<summary><b>Other Installation Types</b></summary>
<br>

<details>
<summary><b>Premium Installation</b></summary>
<br>

For Premium account holders. This option skips the ad-blocking logic, which is not needed on paid accounts, and only reduces podcast audio ads.

**Option 1 — Download and run:**
[Install_Prem.bat](https://raw.githack.com/amd64fox/SpotX/main/scripts/Install_Prem.bat)

**Option 2 — Run in PowerShell:**
```powershell
iex "& { $(iwr -useb 'https://raw.githubusercontent.com/SpotX-Official/SpotX/refs/heads/main/run.ps1') } -premium -new_theme"
```

**Mirror:**
```powershell
iex "& { $(iwr -useb 'https://spotx-official.github.io/SpotX/run.ps1') } -m -premium -new_theme"
```
</details>

<details>
<summary><b>Custom Installation with Parameters</b></summary>
<br>

For more granular control over the install, see the full list of available flags in the [parameters guide](https://github.com/SpotX-Official/SpotX/discussions/60).
</details>

</details>

---

## Uninstall

**Option 1 — Run the uninstaller:**
[Uninstall.bat](https://raw.githack.com/amd64fox/SpotX/main/Uninstall.bat)

**Option 2 — Reinstall Spotify:**
A clean reinstall also removes SpotX. For a complete removal, use the [Uninstall-Spotify](https://github.com/amd64fox/Uninstall-Spotify) tool first.

---

## FAQ

Common questions and troubleshooting steps are covered in the [SpotX FAQ](https://telegra.ph/SpotX-FAQ-09-19).

---

## Community

| Platform | Link |
|---|---|
| Telegram Channel | [spotify_windows_mod](https://t.me/spotify_windows_mod) |
| Telegram Community | [SpotxCommunity](https://t.me/SpotxCommunity) |
| macOS / Linux Version | [SpotX-Bash](https://github.com/SpotX-Official/SpotX-Bash) |

---

## Contributors

| Name | Role | Portfolio |
|---|---|---|
| William Law | Author / Maintainer | [willx.tech](https://willx.tech/) |
| William | Contributor | [willx.tech](https://willx.tech/) |

---

## Disclaimer

SpotX modifies the official Spotify desktop client and is provided as-is, for evaluation purposes, without warranty of any kind. Use it at your own risk, and be aware that it may conflict with Spotify's Terms of Service.