# Input should be the path to the module manifest file
# Validate that the path exists and that it is a module manifest file
# input the name of a property that takes an array of strings
# input the values to add to the property
# Add-ModuleManifestData -Path $rootModuleFile -Property 'FunctionsToExport' -Value 'Get-MyModule'

function Add-ModuleManifestData {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [ValidateScript({ Test-Path -Path $_ -PathType Leaf })]
        [string]$Path,

        # Modules that must be imported into the global environment prior to importing this module.
        [Parameter()]
        [Object[]] $RequiredModules,

        # Assemblies that must be loaded prior to importing this module.
        [Parameter()]
        [string[]] $RequiredAssemblies,

        # Script files (.ps1) that are run in the caller's environment prior to importing this module.
        [Parameter()]
        [string[]] $ScriptsToProcess,

        # Type files (.ps1xml) to be loaded when importing this module.
        [Parameter()]
        [string[]] $TypesToProcess,

        # Format files (.ps1xml) to be loaded when importing this module.
        [Parameter()]
        [string[]] $FormatsToProcess,

        # Modules to import as nested modules of the module specified in RootModule/ModuleToProcess.
        [Parameter()]
        [Object[]] $NestedModules,

        # Functions to export from this module, for best performance, do not use wildcards and do not
        # delete the entry, use an empty array if there are no functions to export.
        [Parameter()]
        [string[]] $FunctionsToExport,

        # Cmdlets to export from this module, for best performance, do not use wildcards and do not
        # delete the entry, use an empty array if there are no cmdlets to export.
        [Parameter()]
        [string[]] $CmdletsToExport,

        # Variables to export from this module.
        [Parameter()]
        [string[]] $VariablesToExport,

        # Aliases to export from this module, for best performance, do not use wildcards and do not
        # delete the entry, use an empty array if there are no aliases to export.
        [Parameter()]
        [string[]] $AliasesToExport,

        # DSC resources to export from this module.
        [Parameter()]
        [string[]] $DscResourcesToExport,

        # List of all modules packaged with this module.
        [Parameter()]
        [Object[]] $ModuleList,

        # List of all files packaged with this module.
        [Parameter()]
        [string[]] $FileList,

        # Tags applied to this module. These help with module discovery in online galleries.
        [Parameter()]
        [string[]] $Tags,

        # External dependent modules of this module.
        [Parameter()]
        [string[]] $ExternalModuleDependencies
    )

    $moduleManifest = Get-ModuleManifest -Path $Path
    $changes = @{}

    if ($RequiredModules) {
        $RequiredModules += $moduleManifest.RequiredModules
        $changes.RequiredModules = $RequiredModules
    }
    if ($RequiredAssemblies) {
        $RequiredAssemblies += $moduleManifest.RequiredAssemblies
        $changes.RequiredAssemblies = $RequiredAssemblies
    }
    if ($ScriptsToProcess) {
        $ScriptsToProcess += $moduleManifest.ScriptsToProcess
        $changes.ScriptsToProcess = $ScriptsToProcess
    }
    if ($TypesToProcess) {
        $TypesToProcess += $moduleManifest.TypesToProcess
        $changes.TypesToProcess = $TypesToProcess
    }
    if ($FormatsToProcess) {
        $FormatsToProcess += $moduleManifest.FormatsToProcess
        $changes.FormatsToProcess = $FormatsToProcess
    }
    if ($NestedModules) {
        $NestedModules += $moduleManifest.NestedModules
        $changes.NestedModules = $NestedModules
    }
    if ($FunctionsToExport) {
        $FunctionsToExport += $moduleManifest.FunctionsToExport
        $changes.FunctionsToExport = $FunctionsToExport
    }
    if ($CmdletsToExport) {
        $CmdletsToExport += $moduleManifest.CmdletsToExport
        $changes.CmdletsToExport = $CmdletsToExport
    }
    if ($VariablesToExport) {
        $VariablesToExport += $moduleManifest.VariablesToExport
        $changes.VariablesToExport = $VariablesToExport
    }
    if ($AliasesToExport) {
        $AliasesToExport += $moduleManifest.AliasesToExport
        $changes.AliasesToExport = $AliasesToExport
    }
    if ($DscResourcesToExport) {
        $DscResourcesToExport += $moduleManifest.DscResourcesToExport
        $changes.DscResourcesToExport = $DscResourcesToExport
    }
    if ($ModuleList) {
        $ModuleList += $moduleManifest.ModuleList
        $changes.ModuleList = $ModuleList
    }
    if ($FileList) {
        $FileList += $moduleManifest.FileList
        $changes.FileList = $FileList
    }
    if ($Tags) {
        $Tags += $moduleManifest.PrivateData.PSData.Tags
        $changes.Tags = $Tags
    }
    if ($ExternalModuleDependencies) {
        $ExternalModuleDependencies += $moduleManifest.PrivateData.PSData.ExternalModuleDependencies
        $changes.ExternalModuleDependencies = $ExternalModuleDependencies
    }

    foreach ($key in $changes.GetEnumerator().Name) {
        $changes[$key] = $changes[$key] | Sort-Object -Unique | Where-Object { $_ | IsNotNullOrEmpty }
    }

    Set-ModuleManifest -Path $Path @changes

}
