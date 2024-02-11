filter ConvertTo-SemVer {
    <#
        .SYNOPSIS
        Converts a version string to a SemVer object.

        .DESCRIPTION
        This function takes a version string and converts it to a SemVer object.

        .EXAMPLE
        '1.2.3-alpha.1+001' | ConvertTo-SemVer

        Major         : 1
        Minor         : 2
        Patch         : 3
        Prerelease    : alpha.1
        BuildMetadata : 001

        .NOTES
        Compatible with [SemVer 2.0.0](https://semver.org/).
    #>
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute(
        'PSAvoidLongLines', '',
        Justification = 'Long regex pattern'
    )]
    [CmdletBinding()]
    param (
        # The version to convert.
        [Parameter(
            Mandatory,
            ValueFromPipeline,
            ValueFromPipelineByPropertyName)
        ]
        [AllowNull()]
        [AllowEmptyString()]
        [string] $Version
    )

    if ($Version | IsNullOrEmpty) {
        return New-SemVer
    }

    $semVerPattern = '(0|[1-9]\d*)\.(0|[1-9]\d*)\.(0|[1-9]\d*)(?:-((?:0|[1-9]\d*|\d*[a-zA-Z-][0-9a-zA-Z-]*)(?:\.(?:0|[1-9]\d*|\d*[a-zA-Z-][0-9a-zA-Z-]*))*))?(?:\+([0-9a-zA-Z-]+(?:\.[0-9a-zA-Z-]+)*))?$'

    if ($Version -match $semVerPattern) {
        [PSCustomObject]@{
            Major         = [int]$Matches[1]
            Minor         = [int]$Matches[2]
            Patch         = [int]$Matches[3]
            Prerelease    = $Matches[4]
            BuildMetadata = $Matches[5]
        }
    } else {
        throw 'Invalid semver format.'
    }
}
