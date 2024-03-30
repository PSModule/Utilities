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
        $hideFileExt = if ($ShowFileExtension) { 0 } else { 1 }
        Set-ItemProperty -Path $path -Name HideFileExt -Value $hideFileExt
    }

    if ($PSCmdlet.ShouldProcess("'ShowHiddenFiles' to [$ShowFileExtension]", 'Set')) {
        $hiddenFiles = if ($ShowHiddenFiles) { 1 } else { 2 }
        Set-ItemProperty -Path $path -Name Hidden -Value $hiddenFiles
    }

    # Refresh File Explorer
    $Shell = New-Object -ComObject Shell.Application
    $Shell.Windows() | ForEach-Object { $_.Refresh() }
}
