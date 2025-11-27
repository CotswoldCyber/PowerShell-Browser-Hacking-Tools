
function Get-InstalledBrowsers {
    $browserkeys = [System.Collections.Generic.List[object]]::new()

    $browserkeys.Add('HKLM:\SOFTWARE\Clients\StartMenuInternet')
    $browserkeys.add('HKLM:\Software\WOW6432Node\Clients\StartMenuInternet')
    $browserkeys.Add('HKCU:\SOFTWARE\Clients\StartMenuInternet')
    
    $knownBrowsers = @('chrome', 'edge', 'firefox', 'brave', 'opera')
    $installedBrowsers = [System.Collections.Generic.list[object]]::new()

    foreach ($key in $browserkeys) {
        if (Test-Path $key) {
            Get-ChildItem -Path $key | foreach-object { $browsername = $_.pschildname
            foreach ($browser in $knownBrowsers) {
                if ($browsername -like "*$browser*") {
            

            $installedBrowsers.add($browser)
            }
        }
    }
}
    }

    return $installedBrowsers | Sort-Object -Unique
}     

Get-InstalledBrowsers