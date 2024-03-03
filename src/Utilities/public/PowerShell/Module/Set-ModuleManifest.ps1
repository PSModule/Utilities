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
        [string] $ModuleVersion,

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
        [string] $PowerShellVersion,

        # Name of the PowerShell host required by this module.
        [Parameter()]
        [string] $PowerShellHostName,

        # Minimum version of the PowerShell host required by this module.
        [Parameter()]
        [string] $PowerShellHostVersion,

        # Minimum version of Microsoft .NET Framework required by this module.
        # This prerequisite is valid for the PowerShell Desktop edition only.
        [Parameter()]
        [string] $DotNetFrameworkVersion,

        # Minimum version of the common language runtime (CLR) required by this module.
        # This prerequisite is valid for the PowerShell Desktop edition only.
        [Parameter()]
        [string] $ClrVersion,

        # Processor architecture (None,X86, Amd64) required by this module
        [Parameter()]
        [string] $ProcessorArchitecture,

        # Modules that must be imported into the global environment prior to importing this module.
        [Parameter()]
        [string[]] $RequiredModules,

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
        [string[]] $NestedModules,

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
        [string[]] $VariablesToExport = '*',

        # Aliases to export from this module, for best performance, do not use wildcards and do not
        # delete the entry, use an empty array if there are no aliases to export.
        [Parameter()]
        [string[]] $AliasesToExport,

        # DSC resources to export from this module.
        [Parameter()]
        [string[]] $DscResourcesToExport,

        # List of all modules packaged with this module.
        [Parameter()]
        [string[]] $ModuleList,

        # List of all files packaged with this module.
        [Parameter()]
        [string[]] $FileList,

        # Tags applied to this module. These help with module discovery in online galleries.
        [Parameter()]
        [string[]] $Tags,

        # A URL to the license for this module.
        [Parameter()]
        [string[]] $LicenseUri,

        # A URL to the main website for this project.
        [Parameter()]
        [string] $ProjectUri,

        # A URL to an icon representing this module.
        [Parameter()]
        [string] $IconUri,

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
        [string] $HelpInfoURI,

        # Default prefix for commands exported from this module. Override the default prefix using Import-Module -Prefix.
        [Parameter()]
        [string] $DefaultCommandPrefix,

        # Private data to pass to the module specified in RootModule/ModuleToProcess.
        # This may also contain a PSData hashtable with additional module metadata used by PowerShell.
        [hashtable] $PrivateData
    )

    $data = Get-ModuleManifest -Path $Path

    if ($PSBoundParameters.Contains('RootModule')) { $data.RootModule = $RootModule }
    if ($PSBoundParameters.Contains('ModuleVersion')) { $data.ModuleVersion = $ModuleVersion }
    if ($PSBoundParameters.Contains('CompatiblePSEditions')) { $data.CompatiblePSEditions = $CompatiblePSEditions }
    if ($PSBoundParameters.Contains('GUID')) { $data.GUID = $GUID }
    if ($PSBoundParameters.Contains('Author')) { $data.Author = $Author }
    if ($PSBoundParameters.Contains('CompanyName')) { $data.CompanyName = $CompanyName }
    if ($PSBoundParameters.Contains('Copyright')) { $data.Copyright = $Copyright }
    if ($PSBoundParameters.Contains('Description')) { $data.Description = $Description }
    if ($PSBoundParameters.Contains('PowerShellVersion')) { $data.PowerShellVersion = $PowerShellVersion }
    if ($PSBoundParameters.Contains('PowerShellHostName')) { $data.PowerShellHostName = $PowerShellHostName }
    if ($PSBoundParameters.Contains('PowerShellHostVersion')) { $data.PowerShellHostVersion = $PowerShellHostVersion }
    if ($PSBoundParameters.Contains('DotNetFrameworkVersion')) { $data.DotNetFrameworkVersion = $DotNetFrameworkVersion }
    if ($PSBoundParameters.Contains('ClrVersion')) { $data.ClrVersion = $ClrVersion }
    if ($PSBoundParameters.Contains('ProcessorArchitecture')) { $data.ProcessorArchitecture = $ProcessorArchitecture }
    if ($PSBoundParameters.Contains('RequiredModules')) { $data.RequiredModules = $RequiredModules }
    if ($PSBoundParameters.Contains('RequiredAssemblies')) { $data.RequiredAssemblies = $RequiredAssemblies }
    if ($PSBoundParameters.Contains('ScriptsToProcess')) { $data.ScriptsToProcess = $ScriptsToProcess }
    if ($PSBoundParameters.Contains('TypesToProcess')) { $data.TypesToProcess = $TypesToProcess }
    if ($PSBoundParameters.Contains('FormatsToProcess')) { $data.FormatsToProcess = $FormatsToProcess }
    if ($PSBoundParameters.Contains('NestedModules')) { $data.NestedModules = $NestedModules }
    if ($PSBoundParameters.Contains('FunctionsToExport')) { $data.FunctionsToExport = $FunctionsToExport }
    if ($PSBoundParameters.Contains('CmdletsToExport')) { $data.CmdletsToExport = $CmdletsToExport }
    if ($PSBoundParameters.Contains('VariablesToExport')) { $data.VariablesToExport = $VariablesToExport }
    if ($PSBoundParameters.Contains('AliasesToExport')) { $data.AliasesToExport = $AliasesToExport }
    if ($PSBoundParameters.Contains('DscResourcesToExport')) { $data.DscResourcesToExport = $DscResourcesToExport }
    if ($PSBoundParameters.Contains('ModuleList')) { $data.ModuleList = $ModuleList }
    if ($PSBoundParameters.Contains('FileList')) { $data.FileList = $FileList }
    if ($PSBoundParameters.Contains('Tags')) { $data.Tags = $Tags }
    if ($PSBoundParameters.Contains('LicenseUri')) { $data.LicenseUri = $LicenseUri }
    if ($PSBoundParameters.Contains('ProjectUri')) { $data.ProjectUri = $ProjectUri }
    if ($PSBoundParameters.Contains('IconUri')) { $data.IconUri = $IconUri }
    if ($PSBoundParameters.Contains('ReleaseNotes')) { $data.ReleaseNotes = $ReleaseNotes }
    if ($PSBoundParameters.Contains('Prerelease')) { $data.Prerelease = $Prerelease }
    if ($PSBoundParameters.Contains('RequireLicenseAcceptance')) { $data.RequireLicenseAcceptance = $RequireLicenseAcceptance }
    if ($PSBoundParameters.Contains('ExternalModuleDependencies')) { $data.ExternalModuleDependencies = $ExternalModuleDependencies }
    if ($PSBoundParameters.Contains('HelpInfoURI')) { $data.HelpInfoURI = $HelpInfoURI }
    if ($PSBoundParameters.Contains('DefaultCommandPrefix')) { $data.DefaultCommandPrefix = $DefaultCommandPrefix }

    $tempPrivateData = $data.PrivateData
    $data.Remove('PrivateData')
    $data += $tempPrivateData.PSData
    $tempPrivateData.Remove('PSData')
    $data.PrivateData = $tempPrivateData

    if ($PSBoundParameters.Contains('PrivateData')) { $data.PrivateData = $tempPrivateData }

    Remove-Item -Path $Path -Force
    New-ModuleManifest -Path $Path @data
    Format-ModuleManifest -Path $Path
}
