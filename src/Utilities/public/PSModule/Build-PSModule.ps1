function Build-PSModule {
    <#
        .SYNOPSIS
        Builds a module.

        .DESCRIPTION
        Builds a module.
    #>
    [CmdletBinding()]
    param(
        # Path to the folder where the modules are located.
        [Parameter(Mandatory)]
        [string] $ModuleSourceFolderPath,

        # Path to the folder where the built modules are outputted.
        [Parameter(Mandatory)]
        [string] $ModulesOutputFolderPath,

        # Path to the folder where the documentation is outputted.
        [Parameter(Mandatory)]
        [string] $DocsOutputFolderPath
    )

    $moduleName = Split-Path -Path $ModuleSourceFolderPath -Leaf

    Start-LogGroup "Building module [$moduleName]"
    Write-Verbose "Source path:          [$ModuleSourceFolderPath]"
    if (-not (Test-Path -Path $ModuleSourceFolderPath)) {
        Write-Error "Source folder not found at [$ModuleSourceFolderPath]"
        exit 1
    }
    $moduleSourceFolder = Get-Item -Path $ModuleSourceFolderPath

    $moduleOutputFolder = New-Item -Path $ModulesOutputFolderPath -Name $moduleName -ItemType Directory -Force
    Write-Verbose "Module output folder: [$ModulesOutputFolderPath]"

    $docsOutputFolder = New-Item -Path $DocsOutputFolderPath -Name $moduleName -ItemType Directory -Force
    Write-Verbose "Docs output folder:   [$DocsOutputFolderPath]"
    Stop-LogGroup

    Build-PSModuleBase -ModuleSourceFolder $moduleSourceFolder -ModuleOutputFolder $moduleOutputFolder
    Build-PSModuleManifest -ModuleOutputFolder $moduleOutputFolder
    Build-PSModuleRootModule -ModuleOutputFolder $moduleOutputFolder
    Build-PSModuleDocumentation -ModuleOutputFolder $moduleOutputFolder -DocsOutputFolder $docsOutputFolder
}
