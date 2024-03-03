function Get-ModuleManifest {
    <#
        .SYNOPSIS
        Get the module manifest.

        .DESCRIPTION
        Get the module manifest as a path, file info, content, or hashtable.

        .EXAMPLE
        Get-PSModuleManifest -Path 'src/PSModule/PSModule.psd1' -As Hashtable
    #>
    [OutputType([string], [System.IO.FileInfo], [System.Collections.Hashtable])]
    [CmdletBinding()]
    param(
        # Path to the module manifest file.
        [Parameter(Mandatory)]
        [string] $Path,

        # The format of the output.
        [Parameter()]
        [ValidateSet('FileInfo', 'Content', 'Hashtable')]
        [string] $As = 'Hashtable'
    )

    if (-not (Test-Path -Path $Path)) {
        Write-Warning "No manifest file found."
        return $null
    }
    Write-Verbose "Found manifest file [$Path]"

    switch ($As) {
        'FileInfo' {
            return Get-Item -Path $manifestFilePath
        }
        'Content' {
            return Get-Content -Path $manifestFilePath
        }
        'Hashtable' {
            return Import-PowerShellDataFile -Path $manifestFilePath
        }
    }
}
