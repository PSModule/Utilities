﻿function Add-PSModulePath {
    <#
        .SYNOPSIS
        Adds a path to the PSModulePath environment variable.

        .DESCRIPTION
        Adds a path to the PSModulePath environment variable.
        For Linux and macOS, the path delimiter is ':' and for Windows it is ';'.

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
    $PSModulePathSeparator = [System.IO.Path]::PathSeparator

    $env:PSModulePath += "$PSModulePathSeparator$Path"

    Write-Verbose 'PSModulePath:'
    $env:PSModulePath.Split($PSModulePathSeparator) | ForEach-Object {
        Write-Verbose " - [$_]"
    }
}

#SkipTest:FunctionTest:Will add a test for this function in a future PR
