function Get-ModuleManifest {
    <#
        .SYNOPSIS
        Get the module manifest.

        .DESCRIPTION
        Get the module manifest as a path, file info, content, or hashtable.

        .EXAMPLE
        Get-PSModuleManifest -Path 'src/PSModule/PSModule.psd1' -As Hashtable
    #>
    [OutputType([string], [System.IO.FileInfo], [System.Collections.Hashtable], [ordered])]
    [CmdletBinding()]
    param(
        # Path to the module manifest file.
        [Parameter(Mandatory)]
        [string] $Path,

        # The format of the output.
        [Parameter()]
        [ValidateSet('FileInfo', 'Content', 'Hashtable')]
        [string] $As = 'Hashtable'
    )

    if (-not (Test-Path -Path $Path)) {
        Write-Warning 'No manifest file found.'
        return $null
    }
    Write-Verbose "Found manifest file [$Path]"

    switch ($As) {
        'FileInfo' {
            return Get-Item -Path $Path
        }
        'Content' {
            return Get-Content -Path $Path
        }
        'Hashtable' {
            $manifest = [ordered]@{}
            $psData = [ordered]@{}
            $privateData = [ordered]@{}
            $tempManifest = Import-PowerShellDataFile -Path $Path
            if ($tempManifest.ContainsKey('PrivateData')) {
                $tempPrivateData = $tempManifest.PrivateData
                if ($tempPrivateData.ContainsKey('PSData')) {
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
                if (($null -ne $tempPSData) -and ($tempPSData.ContainsKey($key))) {
                    $psData.$key = $tempPSData.$key
                }
            }
            if ($psData.Count -gt 0) {
                $privateData.PSData = $psData
            } else {
                $privateData.Remove('PSData')
            }
            foreach ($key in $tempPrivateData.Keys) {
                $privateData.$key = $tempPrivateData.$key
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
                if ($tempManifest.ContainsKey($key)) {
                    $manifest.$key = $tempManifest.$key
                }
            }
            if ($privateData.Count -gt 0) {
                $manifest.PrivateData = $privateData
            } else {
                $manifest.Remove('PrivateData')
            }

            return $manifest
        }
    }
}
