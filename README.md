# Google Dork Generator

<h4 align="center">A fast and interactive Google Dorking toolkit for cybersecurity research and authorized penetration testing.</h4>

<p align="center">
  <a href="#features">Features</a> •
  <a href="#installation">Installation</a> •
  <a href="#usage">Usage</a> •
  <a href="#dork-categories">Dork Categories</a> •
  <a href="#notes">Notes</a>
</p>

---

**Google Dork Generator** is a Bash-based interactive CLI tool that generates structured Google search URLs across multiple vulnerability categories. Built for security researchers, it helps surface exposed assets, misconfigurations, and sensitive data through targeted search queries — without executing anything automatically.

---

## Features

- Simple and modular Bash script — easy to read, extend, and contribute to
- Fast and fully interactive — browse, copy, open, or export dorks on the fly
- Supports **9 predefined dork categories** covering the most common attack surfaces
- Smart **domain scoping** — target a specific site or run global searches
- **Advanced Dork Builder** for composing custom queries interactively
- **Bulk export** — dump all dorks with their URLs to a file for offline use
- Maintains a **search history log** for tracking executed searches
- Cross-platform support: Linux, macOS, Windows (Git Bash / Cygwin)
- Optional clipboard integration via `xclip`, `xsel`, or `pbcopy`

---

## Supported Probes

| Category | Default | Category | Default |
|---|---|---|---|
| Sensitive Files | ✅ | Admin Panels | ✅ |
| Config Exposure | ✅ | Directory Listings | ✅ |
| SQL / DB Errors | ✅ | Vulnerabilities (SQLi/LFI/SSRF params) | ✅ |
| Cloud Storage (S3/Azure/GCS) | ✅ | Webcams & IoT | ✅ |
| Network Devices | ✅ | Custom / Advanced Builder | ✅ |

---

## Installation

```bash
git clone https://github.com/yourusername/google-dork-generator.git
cd google-dork-generator
chmod +x google_dorker.sh
```

**Requirements:**
- Bash 4.0+
- Browser opener in PATH: `xdg-open` (Linux), `open` (macOS), `start` (Windows — auto-detected)
- Optional clipboard support: `xclip` / `xsel` (Linux) or `pbcopy` (macOS, built-in)

---

## Usage

```bash
./google_dorker.sh
```

This will display the interactive menu. Here are all available options.

```
Google Dork Generator — Interactive Security Research Toolkit

Usage:
  ./google_dorker.sh

Menu Options:
  [1]   Sensitive Files & Documents
  [2]   Admin Panels & Login Pages
  [3]   Configuration Files & Exposure
  [4]   Potential Vulnerabilities
  [5]   Directory Listings
  [6]   Cloud Storage & S3 Buckets
  [7]   Error Messages & Debug Info
  [8]   Webcams & IoT Devices
  [9]   Network Devices & Infrastructure
  [10]  Custom Search
  [11]  Advanced Dork Builder
  [12]  Generate All Dorks to File
  [13]  View Search History
  [0]   Exit
```

---

## Dork Categories

### 1. Sensitive Files
Finds exposed documents, dumps, and credentials:
```
filetype:pdf confidential
filetype:env DB_PASSWORD
filetype:sql "MySQL dump"
filetype:xlsx password
filetype:json api_key
```

### 2. Admin Panels & Login Pages
Locates administrative interfaces and backend access points:
```
inurl:admin
inurl:phpmyadmin
inurl:wp-admin
intitle:"login" "admin"
inurl:dashboard
```

### 3. Configuration Files & Exposure
Finds exposed server and application config files:
```
filetype:env
filetype:yaml
filetype:conf
ext:bak
ext:old
```

### 4. Potential Vulnerabilities
Surfaces URLs with injectable parameters (SQLi, LFI, SSRF):
```
inurl:index.php?id=
inurl:file.php?file=
inurl:redirect=
inurl:download.php?file=
inurl:path=
```

### 5. Directory Listings
Finds open server directories with sensitive folder names:
```
intitle:"index of" "parent directory"
intitle:"index of" "backup"
intitle:"index of" "config"
intitle:"index of" "password"
```

### 6. Cloud Storage & S3 Buckets
Discovers misconfigured cloud storage endpoints:
```
site:s3.amazonaws.com
site:blob.core.windows.net
site:storage.googleapis.com
site:s3.amazonaws.com confidential
```

### 7. Error Messages & Debug Info
Surfaces stack traces, DB errors, and debug output:
```
"PHP Fatal error"
"MySQL error"
"error in your SQL syntax"
"Warning: mysql_"
"ORA-00933"
```

### 8. Webcams & IoT Devices
Locates publicly accessible camera feeds and IoT panels:
```
inurl:viewerframe?mode=motion
intitle:"Live View / - AXIS"
intitle:"webcamXP 5"
inurl:view/view.shtml
```

### 9. Network Devices & Infrastructure
Finds exposed routers, firewalls, switches, and printers:
```
intitle:"Router" "login"
intitle:"Cisco" "login"
intitle:"Fortinet" "login"
intitle:"SonicWall" "login"
```

---

## Per-Dork Actions

For every generated dork, the following interactive options are available:

```
[o]  Open in browser
[c]  Copy URL to clipboard
[d]  Copy raw DORK to clipboard
[s]  Skip to next dork
[q]  Quit current category
```

---

## Advanced Dork Builder

Select option `[11]` to compose a dork interactively using guided prompts:

```
[1]  Add site/domain filter       →  site:example.com
[2]  Add filetype filter          →  filetype:pdf
[3]  Add inurl filter             →  inurl:admin
[4]  Add intitle filter           →  intitle:"login"
[5]  Add intext filter            →  intext:password
[6]  Add exclude term             →  -term
[7]  Add OR condition             →  |term
[8]  Preview and Execute
[9]  Clear and Start Over
[0]  Back to main menu
```

---

## Output Files

| File | Description |
|---|---|
| `google_dorks_history.txt` | Timestamped log of all dorks opened in browser |
| `dorks_list.txt` *(or custom name)* | Bulk export of all dorks and their search URLs |

---

## Running Google Dork Generator

**Probe a specific domain:**
```bash
./google_dorker.sh
# Select category → Enter target domain: example.com
```

**Global search (no domain scope):**
```bash
./google_dorker.sh
# Select category → Leave domain empty, press Enter
```

**Export all dorks to file:**
```bash
./google_dorker.sh
# Select [12] → Enter domain (optional) → Enter output filename
```

---

## Notes

- By default, all dorks are **generated only** — nothing opens automatically. You explicitly choose when to execute a search.
- Domain scoping prepends `site:example.com` to every dork in the selected category.
- History is only logged when you choose `[o]` (open in browser) for a dork.
- The Advanced Dork Builder supports chaining multiple operators before executing.
- The following categories work best with a **specific target domain**:
  - Sensitive Files, Admin Panels, Config Exposure, Directory Listings
- The following are more effective as **global searches**:
  - Webcams & IoT, Cloud Storage, Network Devices
- Burp Suite XML exports are not supported as input — this tool is dork-generation focused.
- Custom resolver or proxy support is not built-in; route traffic through your preferred proxy manually.

---

## ⚠️ Disclaimer

This tool is for **educational and authorized security testing purposes only**. Unauthorized access to computer systems is illegal. Always obtain proper written authorization before conducting any security assessment. The author is not responsible for any misuse or damage caused by this tool.

---

## Acknowledgement

Inspired by the work of the open-source security research community.  
Google Dork Generator is made with 💙 by **Muneeb Umer**.
