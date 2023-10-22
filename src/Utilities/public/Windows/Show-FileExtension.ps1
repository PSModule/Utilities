filter Show-FileExtension {
    <#
        .SYNOPSIS
        Show or hide file extensions in Windows Explorer

        .DESCRIPTION
        Show or hide file extensions in Windows Explorer

        .EXAMPLE
        Show-FileExtension -On

        Show file extensions in Windows Explorer

        .EXAMPLE
        Show-FileExtension -Off

        Hide file extensions in Windows Explorer

        .NOTES
        Supported OS: Windows
    #>
    [CmdletBinding(DefaultParameterSetName = 'On')]
    Param (
        # Show file extensions in Windows Explorer
        [Parameter(
            Mandatory,
            ParameterSetName = 'On'
        )]
        [switch] $On,

        # Hide file extensions in Windows Explorer
        [Parameter(
            Mandatory,
            ParameterSetName = 'Off'
        )]
        [switch] $Off
    )

    # Set a variable with the value we want to set on the registry value/subkey.
    if ($PSCmdlet.ParameterSetName -eq 'On') { $Value = 0 }
    if ($PSCmdlet.ParameterSetName -eq 'Off') { $Value = 1 }

    # Define the path to the registry key that contains the registry value/subkey
    $Path = 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced'
    # Set the registry value/subkey.
    Set-ItemProperty -Path $Path -Name HideFileExt -Value $Value

    # Refresh open Explorer windows.
    # You will need to refresh the window if you have none currently open.
    # Create the Shell.Application ComObject
    $Shell = New-Object -ComObject Shell.Application
    # For each one of the open windows, refresh it.
    $Shell.Windows() | ForEach-Object { $_.Refresh() }
}
