Import-Module posh-git
Import-Module oh-my-posh
Set-PoshPrompt -Theme aliens

#if ($env:TERM_PROGRAM -eq 'vscode' ) {
#    Set-PSReadLineOption -PredictionViewStyle ListView
#} else {
#    Set-PSReadLineOption -PredictionViewStyle InlineView
#}
#Set-PSReadLineOption -PredictionSource History


if (Get-Command code-insiders -ErrorAction SilentlyContinue) {
    Set-Alias code code-insiders
}

Function Get-PublicIP {
    #Invoke-RestMethod -Uri https://api.myip.com/
    Invoke-RestMethod -Uri https://ipinfo.io/json
}

Function Get-IPConfig {
    $PublicIP = Get-PublicIP
    $Time = Get-Date -Format yyyyMMdd-hhmmss.fffff
    $Location = Get-GeoLocation
    $LocalIPConfig = Get-NetIPAddress -AddressFamily IPv4 -Type Unicast | Where-Object PrefixOrigin -Match dhcp
    $IPObj = [ordered]@{
        PublicIP  = $PublicIP.IP
        PrivateIP = $LocalIPConfig.IPv4Address
        PCName    = $ENV:COMPUTERNAME
        Time      = $Time
        Latitude  = $Location.Latitude
        Longitude = $Location.Longitude
    }
    return $IPObj
}

$IPConfigFilePath = "$([Environment]::GetFolderPath('MyDocuments'))\IPConfig.json"

Function Save-IPConfig {
    $IPConfig = @()
    $RestoredIPConfig = Restore-IPConfig
    if ($null -ne $RestoredIPConfig) {
        $IPConfig += $RestoredIPConfig
    }
    $CurrentIPConfig = Get-IPConfig

    # Check if recent and current ip is the same
    if ($IPConfig[-1].PublicIP -eq $CurrentIPConfig.PublicIP) {

    } else {
        "Public IP has changed since $($IPConfig[-1].Time)"
        "Old PIP: $($IPConfig[-1].PublicIP)"
        "New PIP: $($CurrentIPConfig.PublicIP)"
        $IPConfig += $CurrentIPConfig

        if (-not (Test-Path -Path $IPConfigFilePath)) {
            New-Item -Path $IPConfigFilePath -Force | Out-Null
        }

        $IPConfig | ConvertTo-Json -AsArray | Set-Content -Path $IPConfigFilePath -Force
    }
}

Function Restore-IPConfig {
    if (Test-Path -Path $IPConfigFilePath) {
        return Get-Content -Path $IPConfigFilePath | ConvertFrom-Json
    }
}

Function Get-GeoLocation {
    Add-Type -AssemblyName System.Device #Required to access System.Device.Location namespace
    $GeoWatcher = New-Object System.Device.Location.GeoCoordinateWatcher #Create the required object
    $GeoWatcher.Start() #Begin resolving current locaton

    while (($GeoWatcher.Status -ne 'Ready') -and ($GeoWatcher.Permission -ne 'Denied')) {
        Start-Sleep -Milliseconds 100 #Wait for discovery.
    }
    if ($GeoWatcher.Permission -eq 'Denied') {
        Write-Error 'Access Denied for Location Information'
    } else {
        $Location = $GeoWatcher.Position.Location | Select-Object Latitude, Longitude #Select the relevent results.
    }
    $GeoWatcher.Stop()
    return $Location
}

function Clear-GitRepo {
    (git branch).Trim() | Where-Object { $_ -notmatch 'main|\*' } | ForEach-Object { git branch $_ -d -f }
}

Save-IPConfig
