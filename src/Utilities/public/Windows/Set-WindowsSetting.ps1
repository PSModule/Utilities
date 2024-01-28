filter Set-WindowsSetting {
    <#
        .SYNOPSIS
        Set a Windows setting

        .DESCRIPTION
        Set a or multiple Windows setting(s).

        .NOTES
        Supported OS: Windows
    #>
    [CmdletBinding(SupportsShouldProcess)]
    Param (
        # Show file extensions in Windows Explorer
        [Parameter()]
        [switch] $ShowFileExtension,

        # Show hidden files in Windows Explorer
        [Parameter()]
        [switch] $ShowHiddenFiles
    )

    $path = 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced'
    if ($PSCmdlet.ShouldProcess("'ShowFileExtension' to [$ShowFileExtension]", 'Set')) {
        Set-ItemProperty -Path $path -Name HideFileExt -Value ($ShowFileExtension ? 0 : 1)
    }

    if ($PSCmdlet.ShouldProcess("'ShowHiddenFiles' to [$ShowFileExtension]", 'Set')) {
        Set-ItemProperty -Path $path -Name Hidden -Value ($ShowHiddenFiles ? 1 : 2)
    }

    # Refresh File Explorer
    $Shell = New-Object -ComObject Shell.Application
    $Shell.Windows() | ForEach-Object { $_.Refresh() }
}
