function Get-PSModuleRootModule {
    <#
        .SYNOPSIS
        Gets the root module to export from the module manifest.

        .DESCRIPTION
        This function will get the root module to export from the module manifest.

        .EXAMPLE
        Get-PSModuleRootModule -SourceFolderPath 'C:\MyModule\src\MyModule'
    #>
    [CmdletBinding()]
    param(
        # Path to the folder where the module source code is located.
        [Parameter(Mandatory)]
        [string] $SourceFolderPath
    )

    $rootModuleExtensions = '.psm1', '.ps1', '.dll', '.cdxml', '.xaml'
    $candidateFiles = Get-ChildItem -Path $SourceFolderPath -File | Where-Object { ($_.BaseName -like $_.Directory.BaseName) -and ($_.Extension -in $rootModuleExtensions) }

    Write-Verbose "Looking for root modules, matching extensions in order [$($rootModuleExtensions -join ', ')]" -Verbose
    :ext foreach ($ext in $rootModuleExtensions) {
        Write-Verbose "Looking for [$ext] files"
        foreach ($file in $candidateFiles) {
            Write-Verbose " - [$($file.Name)]"
            if ($file.Extension -eq $ext) {
                Write-Verbose " - [$($file.Name)] - RootModule found!"
                $rootModule = $file.Name
                break ext
            }
        }
    }

    if (-not $rootModule) {
        Write-Verbose 'No RootModule found'
    }

    $moduleType = switch -Regex ($RootModule) {
        '\.(ps1|psm1)$' { 'Script' }
        '\.dll$' { 'Binary' }
        '\.cdxml$' { 'CIM' }
        '\.xaml$' { 'Workflow' }
        default { 'Manifest' }
    }
    Write-Verbose "[$manifestPropertyName] - [$moduleType]"

    $supportedModuleTypes = @('Script', 'Manifest')
    if ($moduleType -notin $supportedModuleTypes) {
        Write-Warning "[$moduleType] - Module type not supported"
    }

    $rootModule
}
