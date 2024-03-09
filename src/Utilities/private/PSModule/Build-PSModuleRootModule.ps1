#Requires -Modules PSScriptAnalyzer

function Build-PSModuleRootModule {
    <#
        .SYNOPSIS
        Compiles the module root module files.

        .DESCRIPTION
        This function will compile the modules root module from source files.
        It will copy the source files to the output folder and start compiling the module.
        During compilation, the source files are added to the root module file in the following order:

        1. Module header from header.ps1 file. Usually to suppress code analysis warnings/errors and to add [CmdletBinding()] to the module.
        2. Data files are added from source files. These are also tracked based on visibility/exportability based on folder location:
          1. private
          2. public
        3. Combines *.ps1 files from the following folders in alphabetical order from each folder:
          1. init
          2. classes
          3. private
          4. public
          5. Any remaining *.ps1 on module root.
        3. Export-ModuleMember by using the functions, cmdlets, variables and aliases found in the source files.
          - `Functions` will only contain functions that are from the `public` folder.
          - `Cmdlets` will only contain cmdlets that are from the `public` folder.
          - `Variables` will only contain variables that are from the `public` folder.
          - `Aliases` will only contain aliases that are from the functions from the `public` folder.

        .EXAMPLE
        Build-PSModuleRootModule -SourceFolderPath 'C:\MyModule\src\MyModule' -OutputFolderPath 'C:\MyModule\build\MyModule'
    #>
    [CmdletBinding()]
    param(
        # Folder where the built modules are outputted. 'outputs/modules/MyModule'
        [Parameter(Mandatory)]
        [System.IO.DirectoryInfo] $ModuleOutputFolder
    )

    #region Build root module
    Start-LogGroup 'Build root module'
    $moduleName = Split-Path -Path $ModuleOutputFolder -Leaf
    $rootModuleFile = New-Item -Path $ModuleOutputFolder -Name "$moduleName.psm1" -Force

    #region - Analyze source files
    $exports = @{
        Function = Get-PSModuleFunctionsToExport -SourceFolderPath $ModuleOutputFolder
        Cmdlet   = Get-PSModuleCmdletsToExport -SourceFolderPath $ModuleOutputFolder
        Variable = Get-PSModuleVariablesToExport -SourceFolderPath $ModuleOutputFolder
        Alias    = Get-PSModuleAliasesToExport -SourceFolderPath $ModuleOutputFolder
    }

    Write-Verbose ($exports | Out-String)
    #endregion - Analyze source files

    #region - Module header
    $headerFilePath = Join-Path -Path $ModuleOutputFolder -ChildPath 'header.ps1'
    if (Test-Path -Path $headerFilePath) {
        Get-Content -Path $headerFilePath -Raw | Add-Content -Path $rootModuleFile -Force
        $headerFilePath | Remove-Item -Force
    } else {
        Add-Content -Path $rootModuleFile -Force -Value @'
[CmdletBinding()]
param()
'@
    }
    #endregion - Module header

    #region - Module post-header
    Add-Content -Path $rootModuleFile -Force -Value @'
$scriptName = $MyInvocation.MyCommand.Name
Write-Verbose "[$scriptName] Importing module"

'@
    #endregion - Module post-header

    #region - Data and variables
    Add-Content -Path $rootModuleFile.FullName -Force -Value @'
#region - Data import
Write-Verbose "[$scriptName] - [data] - Processing folder"
$dataFolder = (Join-Path $PSScriptRoot 'data')
Write-Verbose "[$scriptName] - [data] - [$dataFolder]"
Get-ChildItem -Path "$dataFolder" -Recurse -Force -Include '*.psd1' -ErrorAction SilentlyContinue | ForEach-Object {
    Write-Verbose "[$scriptName] - [data] - [$($_.Name)] - Importing"
    New-Variable -Name $_.BaseName -Value (Import-PowerShellDataFile -Path $_.FullName) -Force
    Write-Verbose "[$scriptName] - [data] - [$($_.Name)] - Done"
}

Write-Verbose "[$scriptName] - [data] - Done"
#endregion - Data import

'@
    #endregion - Data and variables

    #region - Add content from subfolders
    $scriptFoldersToProcess = @(
        'private',
        'public'
    )

    foreach ($scriptFolder in $scriptFoldersToProcess) {
        $scriptFolder = Join-Path -Path $ModuleOutputFolder -ChildPath $scriptFolder
        if (-not (Test-Path -Path $scriptFolder)) {
            continue
        }
        Add-ContentFromItem -Path $scriptFolder -RootModuleFilePath $rootModuleFile -RootPath $ModuleOutputFolder
        Remove-Item -Path $scriptFolder -Force -Recurse
    }
    #endregion - Add content from subfolders

    #region - Add content from *.ps1 files on module root
    $files = $ModuleOutputFolder | Get-ChildItem -File -Force -Filter '*.ps1'
    foreach ($file in $files) {
        $relativePath = $file.FullName.Replace($ModuleOutputFolder, '').TrimStart($pathSeparator)
        Add-Content -Path $rootModuleFile -Force -Value @"
#region - From $relativePath
Write-Verbose "[`$scriptName] - [$relativePath] - Importing"

"@
        Get-Content -Path $file.FullName | Add-Content -Path $rootModuleFile -Force

        Add-Content -Path $rootModuleFile -Force -Value @"
Write-Verbose "[`$scriptName] - [$relativePath] - Done"
#endregion - From $relativePath

"@
        $file | Remove-Item -Force
    }
    #endregion - Add content from *.ps1 files on module root

    #region - Export-ModuleMember
    $exportsString = Convert-HashtableToString -Hashtable $exports

    Write-Verbose ($exportsString | Out-String)

    $params = @{
        Path  = $rootModuleFile
        Force = $true
        Value = @"
`$exports = $exportsString
Export-ModuleMember @exports
"@
    }
    Add-Content @params
    #endregion - Export-ModuleMember

    Stop-LogGroup
    #endregion Build root module

    #region Format root module
    Start-LogGroup 'Build root module - Format root module - Before format'
    Show-FileContent -Path $rootModuleFile
    Stop-LogGroup

    Start-LogGroup 'Build root module - Format root module - Format'
    $AllContent = Get-Content -Path $rootModuleFile -Raw
    $settings = (Join-Path -Path $PSScriptRoot 'PSScriptAnalyzer.Tests.psd1')
    Invoke-Formatter -ScriptDefinition $AllContent -Settings $settings |
        Out-File -FilePath $rootModuleFile -Encoding utf8BOM -Force
    Stop-LogGroup

    Start-LogGroup 'Build root module - Format root module - Result'
    Show-FileContent -Path $rootModuleFile
    Stop-LogGroup
    #endregion Format root module

    Start-LogGroup 'Build root module - Result'
    (Get-ChildItem -Path $ModuleOutputFolder -Recurse -Force).FullName | Sort-Object
    Stop-LogGroup
}
