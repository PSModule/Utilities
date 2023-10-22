function Show-HiddenFiles {
    <#
        .SYNOPSIS
        Show or hide hidden files in Windows Explorer

        .DESCRIPTION
        Show or hide hidden files in Windows Explorer

        .EXAMPLE
        Show-HiddenFiles -On

        Show hidden files in Windows Explorer

        .EXAMPLE
        Show-HiddenFiles -Off

        Hide hidden files in Windows Explorer
    #>
    [CmdletBinding(DefaultParameterSetName = 'On')]
    Param (
        # Show hidden files in Windows Explorer
        [Parameter(
            Mandatory,
            ParameterSetName = 'On'
        )]
        [switch] $On,

        # Dont show hidden files in Windows Explorer
        [Parameter(
            Mandatory,
            ParameterSetName = 'Off'
        )]
        [switch] $Off
    )
    Process {
        # Set a variable with the value we want to set on the registry value/subkey.
        if ($On) { $Value = 1 }
        if ($Off) { $Value = 2 }

        # Define the path to the registry key that contains the registry value/subkey
        $Path = 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced'
        # Set the registry value/subkey.
        Set-ItemProperty -Path $Path -Name Hidden -Value $Value

        # Refresh open Explorer windows.
        # You will need to refresh the window if you have none currently open.
        # Create the Shell.Application ComObject
        $Shell = New-Object -ComObject Shell.Application
        # For each one of the open windows, refresh it.
        $Shell.Windows() | ForEach-Object { $_.Refresh() }
    }
}
