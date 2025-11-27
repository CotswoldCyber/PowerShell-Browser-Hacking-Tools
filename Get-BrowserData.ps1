
param (
    [Parameter(Mandatory)]
    [string]$browser,
    [Parameter(Mandatory)]
    [string]$DataType
)

function Get-BrowserData {
    [cmdletbinding()]
    param (
        [Parameter (Mandatory)]
        [string]$browser,
        [Parameter (Mandatory)]
        [string]$DataType
    )

    $regex = 'https?://([\w-]+\.)+[\w-]+(/[^\s]*)?'

    $key = "$browser-$DataType"
    switch ($key) {
    'edge-history' {
            $path = "$env:USERPROFILE\AppData\local\microsoft\edge\user Data\default\History"
    }
    'edge-bookmarks' {
            $path = "$env:USERPROFILE\AppData\local\microsoft\edge\user Data\Default\Bookmarks"
    }
    'chrome-history' {
            $path = "$env:USERPROFILE\AppData\local\google\chrome\user Data\default\History"
    }
    'chrome-bookmarks' {
    $path = "$env:USERPROFILE\AppData\local\google\chrome\user Data\Default\Bookmarks"
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

    get-content -Path $path -ErrorAction SilentlyContinue | select-string -AllMatches $regex | ForEach-Object {$_.Matches.Value} | Sort-Object -Unique | ForEach-Object { $cleaned = $_.trimend('"', ',') 
        [pscustomobject]@{
        Browser = $browser
        DataType = $DataType
        Data = $cleaned
    }
}
}
   

Get-BrowserData -browser $browser -DataType $DataType