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
        Compatible with [SemVer 2.0.0](https://SemVer.org/).
    #>
    [OutputType([SemVer])]
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

    try {
        $SemVer = [SemVer]::new($Version)
        return $SemVer
    } catch {
        throw "Failed to convert '$Version' to SemVer."
    }
}
