# PowerShell Browser Tools (Educational Forensics)

A collection of PowerShell scripts designed to detect installed browsers and extract browser history/bookmarks for **educational and forensic purposes**.

⚠️ **Important:**  
These scripts are meant for cybersecurity labs, DFIR learning, and personal research.  
Do NOT use on any system you do not own or have explicit permission to analyze.

---
Influenced by @I_am_Jackoby

## Scripts Included

### ✅ Get-InstalledBrowsers.ps1
Detects which web browsers are installed by checking:
- Registry locations
- Program Files paths
- User data directories

Returns a clean list such as:

```
chrome
edge
firefox
```

---

### ✅ Get-BrowserData.ps1
Collects browser history & bookmark data from:
- Chrome
- Edge
- Firefox

Parses:
- History SQLite databases  
- Bookmark JSON files  
- User profiles  

---

### ✅ Get-Browsers-And-Data.ps1
A combined tool that when run locally:
- Detects installed browsers  
- Extracts browser history/bookmarks  
- Outputs structured results  

Useful for:
- DFIR training  
- Digital investigations  
- Forensic lab exercises  

---

## Usage Example

```powershell
pwsh Get-InstalledBrowsers.ps1
pwsh Get-BrowserData.ps1
pwsh Get-Browsers-And-Data.ps1
```

---

## License
This project is released under the **MIT License**.  
You are free to modify and use the scripts with attribution.

---

## Disclaimer
These tools are strictly for:
- Digital Forensics learning
- Cybersecurity training
- Personal research
- Lab environments

The author is **not responsible** for misuse.
