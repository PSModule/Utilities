function New-SemVer {
    <#
        .SYNOPSIS
        Creates a new SemVer object.

        .DESCRIPTION
        This function creates a new SemVer object.

        .EXAMPLE
        New-SemVer -Version '1.2.3-alpha.1+001'

        Major         : 1
        Minor         : 2
        Patch         : 3
        Prerelease    : alpha.1
        BuildMetadata : 001

        .EXAMPLE
        New-SemVer -Major 1 -Minor 2 -Patch 3 -Prerelease 'alpha.1' -BuildMetadata '001'

        Major         : 1
        Minor         : 2
        Patch         : 3
        Prerelease    : alpha.1
        BuildMetadata : 001

        .NOTES
        Compatible with [SemVer 2.0.0](https://semver.org/).
    #>
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute(
        'PSUseShouldProcessForStateChangingFunctions', '',
        Justification = 'Does not change system state, but creates a new object.'
    )]
    [OutputType([SemVer])]
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
            return [SemVer]::New($Version)
        }
        'Values' {
            return [SemVer]::New($Major, $Minor, $Patch, $Prerelease, $BuildMetadata)
        }
    }
}
