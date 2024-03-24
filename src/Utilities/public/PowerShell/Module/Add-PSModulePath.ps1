function Add-PSModulePath {
    <#
        .SYNOPSIS
        Adds a path to the PSModulePath environment variable.

        .DESCRIPTION
        Adds a path to the PSModulePath environment variable.
        For Linux and MacOS, the path delimiter is ':' and for Windows it is ';'.

        .EXAMPLE
        Add-PSModulePath -Path 'C:\Users\user\Documents\WindowsPowerShell\Modules'

        Adds the path 'C:\Users\user\Documents\WindowsPowerShell\Modules' to the PSModulePath environment variable.
    #>
    [CmdletBinding()]
    param(
        # Path to the folder where the module source code is located.
        [Parameter(Mandatory)]
        [string] $Path
    )

    if ([System.Environment]::OSVersion.Platform -eq 'Win32NT') {
        $PSModulePathSeparator = ';'
    } else {
        $PSModulePathSeparator = ':'
    }
    $env:PSModulePath += "$PSModulePathSeparator$Path"

    Write-Verbose 'PSModulePath:'
    $env:PSModulePath.Split($PSModulePathSeparator) | ForEach-Object {
        Write-Verbose " - [$_]"
    }
}
