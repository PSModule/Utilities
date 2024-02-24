function New-PSSemVer {
    <#
        .SYNOPSIS
        Creates a new PSSemVer object.

        .DESCRIPTION
        This function creates a new PSSemVer object.

        .EXAMPLE
        New-PSSemVer -Version '1.2.3-alpha.1+001'

        Major         : 1
        Minor         : 2
        Patch         : 3
        Prerelease    : alpha.1
        BuildMetadata : 001

        .EXAMPLE
        New-PSSemVer -Major 1 -Minor 2 -Patch 3 -Prerelease 'alpha.1' -BuildMetadata '001'

        Major         : 1
        Minor         : 2
        Patch         : 3
        Prerelease    : alpha.1
        BuildMetadata : 001

        .NOTES
        Compatible with [PSSemVer 2.0.0](https://PSSemVer.org/).
    #>
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute(
        'PSUseShouldProcessForStateChangingFunctions', '',
        Justification = 'Does not change system state, but creates a new object.'
    )]
    [OutputType([PSSemVer])]
    [CmdletBinding(DefaultParameterSetName = 'String')]
    param (
        # The major version.
        [Parameter(ParameterSetName = 'Values')]
        [int] $Major = 0,

        # The minor version.
        [Parameter(ParameterSetName = 'Values')]
        [int] $Minor = 0,

        # The patch version.
        [Parameter(ParameterSetName = 'Values')]
        [int] $Patch = 0,

        # The prerelease version.
        [Parameter(ParameterSetName = 'Values')]
        [Alias('PreReleaseLabel')]
        [string] $Prerelease = '',

        # The build metadata.
        [Parameter(ParameterSetName = 'Values')]
        [Alias('Build', 'BuildLabel')]
        [string] $BuildMetadata = '',

        # The version as a string.
        [Parameter(ParameterSetName = 'String')]
        [string] $Version = ''
    )

    switch ($PSCmdlet.ParameterSetName) {
        'String' {
            return [PSSemVer]::New($Version)
        }
        'Values' {
            return [PSSemVer]::New($Major, $Minor, $Patch, $Prerelease, $BuildMetadata)
        }
    }
}
