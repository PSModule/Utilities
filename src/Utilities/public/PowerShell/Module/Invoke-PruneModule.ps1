function Invoke-PruneModule {
    [CmdletBinding()]
    [Alias('Prune-Module')]
    param (
        [Parameter(Mandatory = $false)]
        [string[]] $Name = '*',
        [Parameter(Mandatory = $false)]
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
        Write-Verbose "[$($UpdateableModuleName)] - Found [$($UpdateableModule.Count)]" -Verbose

        $NewestModule = $UpdateableModule | Select-Object -First 1
        Write-Verbose "[$($UpdateableModuleName)] - Newest [$($NewestModule.Version -join ', ')]" -Verbose

        $OutdatedModules = $UpdateableModule | Select-Object -Skip 1
        Write-Verbose "[$($UpdateableModuleName)] - Outdated [$($OutdatedModules.Version -join ', ')]" -Verbose

        foreach ($OutdatedModule in $OutdatedModules) {
            Write-Verbose "[$($UpdateableModuleName)] - [$($OutdatedModule.Version)] - Removing" -Verbose
            $OutdatedModule | Remove-Module -Force
            Write-Verbose "[$($UpdateableModuleName)] - [$($OutdatedModule.Version)] - Uninstalling" -Verbose
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
