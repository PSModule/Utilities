function Invoke-CleanWingetApps {
    <#
        .SYNOPSIS
        Remove bloat-ware using winget

        .DESCRIPTION
        Remove bloat-ware using winget

        .EXAMPLE
        Invoke-CleanWingetApps

        Remove bloat-ware using winget
    #>
    [Alias('Clean-WingetApps')]
    [OutputType([void])]
    [CmdletBinding()]
    param ()

    winget source update
    winget uninstall --id Microsoft.549981C3F5F10_8wekyb3d8bbwe
    winget uninstall --id Microsoft.Getstarted_8wekyb3d8bbwe
    winget uninstall --id Microsoft.BingNews_8wekyb3d8bbwe
    winget uninstall --id Microsoft.BingWeather_8wekyb3d8bbwe
    winget uninstall --id Microsoft.GetHelp_8wekyb3d8bbwe
    winget uninstall --id Microsoft.PowerAutomateDesktop_8wekyb3d8bbwe
    winget uninstall --id Microsoft.WindowsFeedbackHub_8wekyb3d8bbwe
    winget uninstall --id Microsoft.ZuneMusic_8wekyb3d8bbwe
    winget uninstall --id Microsoft.YourPhone_8wekyb3d8bbwe
    winget uninstall --id Microsoft.People_8wekyb3d8bbwe
    winget uninstall --id Microsoft.MicrosoftEdge.Stable_8wekyb3d8bbwe
    winget uninstall --id Microsoft.GamingApp_8wekyb3d8bbwe
    winget uninstall --id Microsoft.XboxGamingOverlay_8wekyb3d8bbwe
    winget uninstall --id Microsoft.XboxGameOverlay_8wekyb3d8bbwe
    winget uninstall --id Microsoft.XboxSpeechToTextOverlay_8wekyb3d8bbwe
    winget uninstall --id Microsoft.XboxIdentityProvider_8wekyb3d8bbwe
    winget uninstall --id Microsoft.Xbox.TCUI_8wekyb3d8bbwe
    winget uninstall --id MicrosoftTeams_8wekyb3d8bbwe
    winget uninstall --id Clipchamp.Clipchamp_yxz26nhyzhsrt
    winget uninstall --id microsoft.windowscommunicationsapps_8wekyb3d8bbwe
}
