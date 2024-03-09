function Get-PSModuleVariablesToExport {
    <#
        .SYNOPSIS
        Gets the variables to export from the module manifest.

        .DESCRIPTION
        This function will get the variables to export from the module manifest.

        .EXAMPLE
        Get-PSModuleVariablesToExport -SourceFolderPath 'C:\MyModule\src\MyModule'
    #>
    [CmdletBinding()]
    param(
        # Path to the folder where the module source code is located.
        [Parameter(Mandatory)]
        [string] $SourceFolderPath
    )

    $manifestPropertyName = 'VariablesToExport'

    $moduleName = Split-Path -Path $SourceFolderPath -Leaf
    $manifestFileName = "$moduleName.psd1"
    $manifestFilePath = Join-Path -Path $SourceFolderPath $manifestFileName

    $manifest = Get-ModuleManifest -Path $manifestFilePath -Verbose:$false

    Write-Verbose "[$manifestPropertyName]"

    $variablesToExport = (($manifest.VariablesToExport).count -eq 0) -or ($manifest.VariablesToExport | IsNullOrEmpty) ? '' : $manifest.VariablesToExport
    $variablesToExport | ForEach-Object {
        Write-Verbose "[$manifestPropertyName] - [$_]"
    }

    $variablesToExport
}
