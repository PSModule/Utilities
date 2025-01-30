#Requires -Modules @{ ModuleName = 'Admin'; ModuleVersion = '1.1.3' }

function Invoke-ReinstallModule {
    <#
        .SYNOPSIS
        Reinstalls module into a given scope.

        .DESCRIPTION
        Reinstalls module into a given scope. This is useful when you want to reinstall or clean up your module versions.
        With this command you always get the newest available version of the module and all the previous version wiped out.

        .PARAMETER Name
        The name of the module to be reinstalled. Wildcards are supported.

        .PARAMETER Scope
        The scope of the module to will be reinstalled to.

        .EXAMPLE
        Reinstall-Module -Name Pester -Scope CurrentUser

        Reinstall Pester module for the current user.

        .EXAMPLE
        Reinstall-Module -Scope CurrentUser

        Reinstall all reinstallable modules into the current user.
    #>
    [CmdletBinding()]
    [Alias('Reinstall-Module')]
    param (
        # Name of the module(s) to reinstall
        [Parameter()]
        [SupportsWildcards()]
        [string[]] $Name = '*',

        # Scope of the module(s) to reinstall
        [Parameter()]
        [ValidateSet('CurrentUser', 'AllUsers')]
        [string[]] $Scope = 'CurrentUser'
    )

    if ($Scope -eq 'AllUsers' -and -not (IsAdmin)) {
        $message = 'Administrator rights are required to uninstall modules for all users. Please run the command again with' +
        " elevated rights (Run as Administrator) or provide '-Scope CurrentUser' to your command."

        throw $message
    }

    $modules = Get-InstalledModule | Where-Object Name -Like "$Name"
    Write-Verbose "Found [$($modules.Count)] modules"

    $modules | ForEach-Object {
        if ($_.name -eq 'Pester') {
            Uninstall-Pester -All
            continue
        }
        Uninstall-Module -Name $_ -AllVersions -Force -ErrorAction SilentlyContinue
    }

    $modules.Name | ForEach-Object {
        Install-Module -Name $_ -Scope $Scope -Force
    }
}
