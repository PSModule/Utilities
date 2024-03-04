function Set-ModuleManifest {
    <#
        .SYNOPSIS
        Sets the values of a module manifest file.

        .DESCRIPTION
        This function sets the values of a module manifest file.
        Very much like the Update-ModuleManifest function, but allows values to be missing.

        .EXAMPLE
        Set-ModuleManifest -Path 'C:\MyModule\MyModule.psd1' -ModuleVersion '1.0.0'
    #>
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute(
        'PSUseShouldProcessForStateChangingFunctions', '',
        Justification = 'Function does not change state.'
    )]
    [CmdletBinding()]
    param(
        # Path to the module manifest file.
        [Parameter(Mandatory)]
        [string] $Path,

        #Script module or binary module file associated with this manifest.
        [Parameter()]
        [string] $RootModule,

        #Version number of this module.
        [Parameter()]
        [Version] $ModuleVersion,

        # Supported PSEditions.
        [Parameter()]
        [string[]] $CompatiblePSEditions,

        # ID used to uniquely identify this module.
        [Parameter()]
        [guid] $GUID,

        # Author of this module.
        [Parameter()]
        [string] $Author,

        # Company or vendor of this module.
        [Parameter()]
        [string] $CompanyName,

        # Copyright statement for this module.
        [Parameter()]
        [string] $Copyright,

        # Description of the functionality provided by this module.
        [Parameter()]
        [string] $Description,

        # Minimum version of the PowerShell engine required by this module.
        [Parameter()]
        [Version] $PowerShellVersion,

        # Name of the PowerShell host required by this module.
        [Parameter()]
        [string] $PowerShellHostName,

        # Minimum version of the PowerShell host required by this module.
        [Parameter()]
        [version] $PowerShellHostVersion,

        # Minimum version of Microsoft .NET Framework required by this module.
        # This prerequisite is valid for the PowerShell Desktop edition only.
        [Parameter()]
        [Version] $DotNetFrameworkVersion,

        # Minimum version of the common language runtime (CLR) required by this module.
        # This prerequisite is valid for the PowerShell Desktop edition only.
        [Parameter()]
        [Version] $ClrVersion,

        # Processor architecture (None,X86, Amd64) required by this module
        [Parameter()]
        [System.Reflection.ProcessorArchitecture] $ProcessorArchitecture,

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

        # A URL to the license for this module.
        [Parameter()]
        [uri] $LicenseUri,

        # A URL to the main website for this project.
        [Parameter()]
        [uri] $ProjectUri,

        # A URL to an icon representing this module.
        [Parameter()]
        [uri] $IconUri,

        # ReleaseNotes of this module.
        [Parameter()]
        [string] $ReleaseNotes,

        # Prerelease string of this module.
        [Parameter()]
        [string] $Prerelease,

        # Flag to indicate whether the module requires explicit user acceptance for install/update/save.
        [Parameter()]
        [bool] $RequireLicenseAcceptance,

        # External dependent modules of this module.
        [Parameter()]
        [string[]] $ExternalModuleDependencies,

        # HelpInfo URI of this module.
        [Parameter()]
        [String] $HelpInfoURI,

        # Default prefix for commands exported from this module. Override the default prefix using Import-Module -Prefix.
        [Parameter()]
        [string] $DefaultCommandPrefix,

        # Private data to pass to the module specified in RootModule/ModuleToProcess.
        # This may also contain a PSData hashtable with additional module metadata used by PowerShell.
        [Parameter()]
        [object] $PrivateData
    )

    $outManifest = [ordered]@{}
    $outPSData = [ordered]@{}
    $outPrivateData = [ordered]@{}
    $tempManifest = Get-ModuleManifest -Path $Path
    if ($tempManifest.Keys.Contains('PrivateData')) {
        $tempPrivateData = $tempManifest.PrivateData
        if ($tempPrivateData.Keys.Contains('PSData')) {
            $tempPSData = $tempPrivateData.PSData
            $tempPrivateData.Remove('PSData')
        }
    }

    $psdataOrder = @(
        'Tags'
        'LicenseUri'
        'ProjectUri'
        'IconUri'
        'ReleaseNotes'
        'Prerelease'
        'RequireLicenseAcceptance'
        'ExternalModuleDependencies'
    )
    foreach ($key in $psdataOrder) {
        if ($tempPSData.Keys.Contains($key)) {
            $outPSData.$key = $tempPSData.$key
        }
        if ($PSBoundParameters.Keys.Contains($key)) {
            $outPSData.$key = $PSBoundParameters.$key
        }
    }

    foreach ($key in $tempPrivateData.Keys) {
        $outPrivateData.$key = $tempPrivateData.$key
    }
    if ($outPSData.Count -gt 0) {
        $outPrivateData.PSData = $outPSData
    }
    foreach ($key in $PrivateData.Keys) {
        $outPrivateData.$key = $PrivateData.$key
    }

    $manifestOrder = @(
        'RootModule'
        'ModuleVersion'
        'CompatiblePSEditions'
        'GUID'
        'Author'
        'CompanyName'
        'Copyright'
        'Description'
        'PowerShellVersion'
        'PowerShellHostName'
        'PowerShellHostVersion'
        'DotNetFrameworkVersion'
        'ClrVersion'
        'ProcessorArchitecture'
        'RequiredModules'
        'RequiredAssemblies'
        'ScriptsToProcess'
        'TypesToProcess'
        'FormatsToProcess'
        'NestedModules'
        'FunctionsToExport'
        'CmdletsToExport'
        'VariablesToExport'
        'AliasesToExport'
        'DscResourcesToExport'
        'ModuleList'
        'FileList'
        'HelpInfoURI'
        'DefaultCommandPrefix'
        'PrivateData'
    )
    foreach ($key in $manifestOrder) {
        if ($tempManifest.Keys.Contains($key)) {
            $outManifest.$key = $tempManifest.$key
        }
        if ($PSBoundParameters.Keys.Contains($key)) {
            $outManifest.$key = $PSBoundParameters.$key
        }
    }
    if ($outPrivateData.Count -gt 0) {
        $outManifest.PrivateData = $outPrivateData
    } else {
        $outManifest.Remove('PrivateData')
    }

    Remove-Item -Path $Path -Force
    Export-PowerShellDataFile -Hashtable $outManifest -Path $Path
}
