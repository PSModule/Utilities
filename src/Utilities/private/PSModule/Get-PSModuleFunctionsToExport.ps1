function Get-PSModuleFunctionsToExport {
    <#
        .SYNOPSIS
        Gets the functions to export from the module manifest.

        .DESCRIPTION
        This function will get the functions to export from the module manifest.

        .EXAMPLE
        Get-PSModuleFunctionsToExport -SourceFolderPath 'C:\MyModule\src\MyModule'
    #>
    [CmdletBinding()]
    [OutputType([array])]
    param(
        # Path to the folder where the module source code is located.
        [Parameter(Mandatory)]
        [string] $SourceFolderPath
    )

    $manifestPropertyName = 'FunctionsToExport'

    Write-Verbose "[$manifestPropertyName]"
    Write-Verbose "[$manifestPropertyName] - Checking path for functions and filters"

    $publicFolderPath = Join-Path $SourceFolderPath 'public'
    Write-Verbose "[$manifestPropertyName] - [$publicFolderPath]"
    $functionsToExport = [Collections.Generic.List[string]]::new()
    $scriptFiles = Get-ChildItem -Path $publicFolderPath -Recurse -File -ErrorAction SilentlyContinue -Include '*.ps1'
    Write-Verbose "[$manifestPropertyName] - [$($scriptFiles.Count)]"
    foreach ($file in $scriptFiles) {
        $fileContent = Get-Content -Path $file.FullName -Raw
        $containsFunction = ($fileContent -match 'function ') -or ($fileContent -match 'filter ')
        Write-Verbose "[$manifestPropertyName] - [$($file.BaseName)] - [$containsFunction]"
        if ($containsFunction) {
            $functionsToExport.Add($file.BaseName)
        }
    }

    [array]$functionsToExport
}
