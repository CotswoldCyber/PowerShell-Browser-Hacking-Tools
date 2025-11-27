
function Get-InstalledBrowsers {
    param (
    [string]$DataType = 'history'  # Accepts 'history' or 'bookmarks'
)

    $browserkeys = [System.Collections.Generic.List[string]]::new()
    $browserkeys.Add('HKLM:\SOFTWARE\Clients\StartMenuInternet') # system wide
    $browserkeys.Add('HKLM:\SOFTWARE\WOW6432Node\Clients\StartMenuInternet') # 32 bit on 64 bit
    $browserkeys.add('HKCU:\SOFTWARE\Clients\StartMenuInternet') # current user

    $knownBrowsers = @('chrome', 'edge', 'firefox', 'brave', 'opera')
    $installedBrowsers = [System.Collections.Generic.List[string]]::new()

    foreach ($key in $browserkeys) {
        if (Test-Path $key) {
            Get-ChildItem -Path $key | ForEach-Object {
                $browsername = $_.PSChildName.ToLower()
                foreach ($browser in $knownBrowsers) {
                    if ($browsername -like "*$browser*") {
                        $installedBrowsers.Add($browser)
                    }
                }
            }
        }
    }

    return $installedBrowsers | Sort-Object -Unique
}

function Get-BrowserData {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [string]$browser,

        [Parameter(Mandatory)]
        [string]$DataType
    )

    $regex = 'https?://([\w-]+\.)+[\w-]+(/[^\s]*)?'
    $key = "$browser-$DataType"

    switch ($key) {
        'edge-history' {
            $path = "$env:USERPROFILE\AppData\Local\Microsoft\Edge\User Data\Default\History"
        }
        'edge-bookmarks' {
            $path = "$env:USERPROFILE\AppData\Local\Microsoft\Edge\User Data\Default\Bookmarks"
        }
        'chrome-history' {
            $path = "$env:USERPROFILE\AppData\Local\Google\Chrome\User Data\Default\History"
        }
        'chrome-bookmarks' {
            $path = "$env:USERPROFILE\AppData\Local\Google\Chrome\User Data\Default\Bookmarks"
        }
        'brave-history'{
            $path = "$env:USERPROFILE\AppData\Local\BraveSoftware\Brave-Browser\User Data\Default\Bookmarks"
        }
        'brave-bookmarks' {
            $path = "$env:USERPROFILE\AppData\Local\BraveSoftware\Brave-Browser\User Data\Default\Bookmarks"
        }
        'firefox-history' {
        $path = "$env:APPDATA\Mozilla\Firefox\Profiles\*\places.sqlite"
        }
        'firefox-bookmarks' {
            $path = "$env:APPDATA\Mozilla\Firefox\Profiles\*\places.sqlite"
        }
        default {
            Write-Warning "Unsupported browser/data type combination: $key"
            return
        }
    }

    if (-not (Test-Path $path)) {
        Write-Warning "Path not found: $path"
        return
    }

    Get-Content -Path $path -ErrorAction SilentlyContinue |
        Select-String -AllMatches $regex |
        ForEach-Object { $_.Matches.Value } |
        Sort-Object -Unique |
        ForEach-Object {
            $cleaned = $_.TrimEnd('"', ',')
            [pscustomobject]@{
                Browser  = $browser
                DataType = $DataType
                Data     = $cleaned
            }
        }
}

# 🔹 Run the full workflow
$installed = Get-InstalledBrowsers

Write-Host "`nInstalled browsers:" 
$installed | ForEach-Object { Write-Host " - $_" }

$choice = Read-Host "Do you want 'history' or 'bookmarks' for all installed browsers?"

if ($choice -notin @('history','bookmarks')) {
    Write-Host "Invalid choice. Please run the script again and choose 'history' or 'bookmarks'." -ForegroundColor Red
    return
}


foreach ($browser in $installed) {
    Get-BrowserData -browser $browser -DataType $choice
}