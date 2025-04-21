#Requires -Modules @{ ModuleName = 'Admin'; RequiredVersion = '1.1.3' }

function Invoke-PruneModule {
    <#
        .SYNOPSIS
        Remove all but the newest version of a module

        .DESCRIPTION
        Remove all but the newest version of a module

        .EXAMPLE
        Invoke-PruneModule -Name 'Az.*' -Scope CurrentUser
    #>
    [OutputType([void])]
    [CmdletBinding()]
    [Alias('Prune-Module')]
    param (
        # Name of the module(s) to prune
        [Parameter()]
        [string[]] $Name = '*',

        # Scope of the module(s) to prune
        [Parameter()]
        [ValidateSet('CurrentUser', 'AllUsers')]
        [string[]] $Scope = 'CurrentUser'
    )

    if ($Scope -eq 'AllUsers' -and -not (IsAdmin)) {
        $message = 'Administrator rights are required to uninstall modules for all users. Please run the command again with' +
        " elevated rights (Run as Administrator) or provide '-Scope CurrentUser' to your command."

        throw $message
    }

    $UpdateableModules = Get-InstalledModule | Where-Object Name -Like "$Name"
    $UpdateableModuleNames = $UpdateableModules.Name | Sort-Object -Unique
    foreach ($UpdateableModuleName in $UpdateableModuleNames) {
        $UpdateableModule = $UpdateableModules | Where-Object Name -EQ $UpdateableModuleName | Sort-Object -Property Version -Descending
        Write-Verbose "[$($UpdateableModuleName)] - Found [$($UpdateableModule.Count)]"

        $NewestModule = $UpdateableModule | Select-Object -First 1
        Write-Verbose "[$($UpdateableModuleName)] - Newest [$($NewestModule.Version -join ', ')]"

        $OutdatedModules = $UpdateableModule | Select-Object -Skip 1
        Write-Verbose "[$($UpdateableModuleName)] - Outdated [$($OutdatedModules.Version -join ', ')]"

        foreach ($OutdatedModule in $OutdatedModules) {
            Write-Verbose "[$($UpdateableModuleName)] - [$($OutdatedModule.Version)] - Removing"
            $OutdatedModule | Remove-Module -Force
            Write-Verbose "[$($UpdateableModuleName)] - [$($OutdatedModule.Version)] - Uninstalling"
            Uninstall-Module -Name $OutdatedModule.Name -RequiredVersion -Force
            try {
                $OutdatedModule.ModuleBase | Remove-Item -Force -Recurse -ErrorAction Stop
            } catch {
                Write-Warning "[$($UpdateableModuleName)] - [$($OutdatedModule.Version)] - Failed to remove [$($OutdatedModule.ModuleBase)]"
                continue
            }
        }
    }
}

#SkipTest:FunctionTest:Will add a test for this function in a future PR
