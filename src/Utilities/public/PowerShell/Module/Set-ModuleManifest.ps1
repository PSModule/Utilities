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
        [Parameter(
            Mandatory,
            ValueFromPipeline,
            ValueFromPipelineByPropertyName
        )]
        [string] $Path,

        #Script module or binary module file associated with this manifest.
        [Parameter()]
        [AllowNull()]
        [string] $RootModule,

        #Version number of this module.
        [Parameter()]
        [AllowNull()]
        [Version] $ModuleVersion,

        # Supported PSEditions.
        [Parameter()]
        [AllowNull()]
        [string[]] $CompatiblePSEditions,

        # ID used to uniquely identify this module.
        [Parameter()]
        [AllowNull()]
        [guid] $GUID,

        # Author of this module.
        [Parameter()]
        [AllowNull()]
        [string] $Author,

        # Company or vendor of this module.
        [Parameter()]
        [AllowNull()]
        [string] $CompanyName,

        # Copyright statement for this module.
        [Parameter()]
        [AllowNull()]
        [string] $Copyright,

        # Description of the functionality provided by this module.
        [Parameter()]
        [AllowNull()]
        [string] $Description,

        # Minimum version of the PowerShell engine required by this module.
        [Parameter()]
        [AllowNull()]
        [Version] $PowerShellVersion,

        # Name of the PowerShell host required by this module.
        [Parameter()]
        [AllowNull()]
        [string] $PowerShellHostName,

        # Minimum version of the PowerShell host required by this module.
        [Parameter()]
        [AllowNull()]
        [version] $PowerShellHostVersion,

        # Minimum version of Microsoft .NET Framework required by this module.
        # This prerequisite is valid for the PowerShell Desktop edition only.
        [Parameter()]
        [AllowNull()]
        [Version] $DotNetFrameworkVersion,

        # Minimum version of the common language runtime (CLR) required by this module.
        # This prerequisite is valid for the PowerShell Desktop edition only.
        [Parameter()]
        [AllowNull()]
        [Version] $ClrVersion,

        # Processor architecture (None,X86, Amd64) required by this module
        [Parameter()]
        [AllowNull()]
        [System.Reflection.ProcessorArchitecture] $ProcessorArchitecture,

        # Modules that must be imported into the global environment prior to importing this module.
        [Parameter()]
        [AllowNull()]
        [Object[]] $RequiredModules,

        # Assemblies that must be loaded prior to importing this module.
        [Parameter()]
        [AllowNull()]
        [string[]] $RequiredAssemblies,

        # Script files (.ps1) that are run in the caller's environment prior to importing this module.
        [Parameter()]
        [AllowNull()]
        [string[]] $ScriptsToProcess,

        # Type files (.ps1xml) to be loaded when importing this module.
        [Parameter()]
        [AllowNull()]
        [string[]] $TypesToProcess,

        # Format files (.ps1xml) to be loaded when importing this module.
        [Parameter()]
        [AllowNull()]
        [string[]] $FormatsToProcess,

        # Modules to import as nested modules of the module specified in RootModule/ModuleToProcess.
        [Parameter()]
        [AllowNull()]
        [Object[]] $NestedModules,

        # Functions to export from this module, for best performance, do not use wildcards and do not
        # delete the entry, use an empty array if there are no functions to export.
        [Parameter()]
        [AllowNull()]
        [string[]] $FunctionsToExport,

        # Cmdlets to export from this module, for best performance, do not use wildcards and do not
        # delete the entry, use an empty array if there are no cmdlets to export.
        [Parameter()]
        [AllowNull()]
        [string[]] $CmdletsToExport,

        # Variables to export from this module.
        [Parameter()]
        [AllowNull()]
        [string[]] $VariablesToExport,

        # Aliases to export from this module, for best performance, do not use wildcards and do not
        # delete the entry, use an empty array if there are no aliases to export.
        [Parameter()]
        [AllowNull()]
        [string[]] $AliasesToExport,

        # DSC resources to export from this module.
        [Parameter()]
        [AllowNull()]
        [string[]] $DscResourcesToExport,

        # List of all modules packaged with this module.
        [Parameter()]
        [AllowNull()]
        [Object[]] $ModuleList,

        # List of all files packaged with this module.
        [Parameter()]
        [AllowNull()]
        [string[]] $FileList,

        # Tags applied to this module. These help with module discovery in online galleries.
        [Parameter()]
        [AllowNull()]
        [string[]] $Tags,

        # A URL to the license for this module.
        [Parameter()]
        [AllowNull()]
        [uri] $LicenseUri,

        # A URL to the main website for this project.
        [Parameter()]
        [AllowNull()]
        [uri] $ProjectUri,

        # A URL to an icon representing this module.
        [Parameter()]
        [AllowNull()]
        [uri] $IconUri,

        # ReleaseNotes of this module.
        [Parameter()]
        [AllowNull()]
        [string] $ReleaseNotes,

        # Prerelease string of this module.
        [Parameter()]
        [AllowNull()]
        [string] $Prerelease,

        # Flag to indicate whether the module requires explicit user acceptance for install/update/save.
        [Parameter()]
        [AllowNull()]
        [bool] $RequireLicenseAcceptance,

        # External dependent modules of this module.
        [Parameter()]
        [AllowNull()]
        [string[]] $ExternalModuleDependencies,

        # HelpInfo URI of this module.
        [Parameter()]
        [AllowNull()]
        [String] $HelpInfoURI,

        # Default prefix for commands exported from this module. Override the default prefix using Import-Module -Prefix.
        [Parameter()]
        [AllowNull()]
        [string] $DefaultCommandPrefix,

        # Private data to pass to the module specified in RootModule/ModuleToProcess.
        # This may also contain a PSData hashtable with additional module metadata used by PowerShell.
        [Parameter()]
        [AllowNull()]
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
        if (($null -ne $tempPSData) -and $tempPSData.Keys.Contains($key)) {
            $outPSData.$key = $tempPSData.$key
        }
        if ($PSBoundParameters.Keys.Contains($key)) {
            if ($null -eq $PSBoundParameters.$key) {
                $outPSData.Remove($key)
            } else {
                $outPSData.$key = $PSBoundParameters.$key
            }
        }
    }

    if ($outPSData.Count -gt 0) {
        $outPrivateData.PSData = $outPSData
    } else {
        $outPrivateData.Remove('PSData')
    }
    foreach ($key in $tempPrivateData.Keys) {
        $outPrivateData.$key = $tempPrivateData.$key
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
            if ($null -eq $PSBoundParameters.$key) {
                $outManifest.Remove($key)
            } else {
                $outManifest.$key = $PSBoundParameters.$key
            }
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
