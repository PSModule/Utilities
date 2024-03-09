function Add-ContentFromItem {
    <#
        .SYNOPSIS
        Add the content of a folder or file to the root module file.

        .DESCRIPTION
        This function will add the content of a folder or file to the root module file.

        .EXAMPLE
        Add-ContentFromItem -Path 'C:\MyModule\src\MyModule' -RootModuleFilePath 'C:\MyModule\src\MyModule.psm1' -RootPath 'C:\MyModule\src'
    #>
    param(
        # The path to the folder or file to process.
        [Parameter(Mandatory)]
        [string] $Path,

        # The path to the root module file.
        [Parameter(Mandatory)]
        [string] $RootModuleFilePath,

        # The root path of the module.
        [Parameter(Mandatory)]
        [string] $RootPath
    )
    $relativeFolderPath = $Path.Replace($RootPath, '').TrimStart($pathSeparator)

    Add-Content -Path $RootModuleFilePath -Force -Value @"
#region - From $relativeFolderPath
Write-Verbose "[`$scriptName] - [$relativeFolderPath] - Processing folder"

"@

    $subFolders = $Path | Get-ChildItem -Directory -Force | Sort-Object -Property Name
    foreach ($subFolder in $subFolders) {
        Add-ContentFromItem -Path $subFolder.FullName -RootModuleFilePath $RootModuleFilePath -RootPath $RootPath
    }

    $files = $Path | Get-ChildItem -File -Force -Filter '*.ps1' | Sort-Object -Property FullName
    foreach ($file in $files) {
        $relativeFilePath = $file.FullName.Replace($RootPath, '').TrimStart($pathSeparator)
        Add-Content -Path $RootModuleFilePath -Force -Value @"
#region - From $relativeFilePath
Write-Verbose "[`$scriptName] - [$relativeFilePath] - Importing"

"@
        Get-Content -Path $file.FullName | Add-Content -Path $RootModuleFilePath -Force
        Add-Content -Path $RootModuleFilePath -Value @"

Write-Verbose "[`$scriptName] - [$relativeFilePath] - Done"
#endregion - From $relativeFilePath
"@
    }
    Add-Content -Path $RootModuleFilePath -Force -Value @"

Write-Verbose "[`$scriptName] - [$relativeFolderPath] - Done"
#endregion - From $relativeFolderPath

"@
}
