function Build-PSModuleBase {
    <#
        .SYNOPSIS
        Compiles the base module files.

        .DESCRIPTION
        This function will compile the base module files.
        It will copy the source files to the output folder and remove the files that are not needed.

        .EXAMPLE
        Build-PSModuleBase -SourceFolderPath 'C:\MyModule\src\MyModule' -OutputFolderPath 'C:\MyModule\build\MyModule'
    #>
    [CmdletBinding()]
    param(
        # Path to the folder where the module source code is located.
        [Parameter(Mandatory)]
        [System.IO.DirectoryInfo] $ModuleSourceFolder,

        # Path to the folder where the built modules are outputted.
        [Parameter(Mandatory)]
        [System.IO.DirectoryInfo] $ModuleOutputFolder
    )

    Start-LogGroup 'Build base'

    Write-Verbose "Copying files from [$ModuleSourceFolder] to [$ModuleOutputFolder]"
    Copy-Item -Path "$ModuleSourceFolder\*" -Destination $ModuleOutputFolder -Recurse -Force -Verbose
    Stop-LogGroup

    Start-LogGroup 'Build base - Result'
    (Get-ChildItem -Path $ModuleOutputFolder -Recurse -Force).FullName | Sort-Object
    Stop-LogGroup
}
