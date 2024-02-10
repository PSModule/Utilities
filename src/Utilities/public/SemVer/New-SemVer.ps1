Function New-SemVer {
    <#
        .SYNOPSIS
        Creates a new SemVer object.

        .DESCRIPTION
        This function creates a new SemVer object.

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
    [CmdletBinding()]
    param (
        # The major version.
        [Parameter()]
        [int] $Major = 0,

        # The minor version.
        [Parameter()]
        [int] $Minor = 0,

        # The patch version.
        [Parameter()]
        [int] $Patch = 0,

        # The prerelease version.
        [Parameter()]
        [string] $Prerelease = '',

        # The build metadata.
        [Parameter()]
        [string] $BuildMetadata = ''
    )
    process {
        [PSCustomObject]@{
            Major         = $Major
            Minor         = $Minor
            Patch         = $Patch
            Prerelease    = $Prerelease
            BuildMetadata = $BuildMetadata
        }
    }
}
