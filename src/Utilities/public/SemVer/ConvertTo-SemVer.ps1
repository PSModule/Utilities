filter ConvertTo-SemVer {
    <#
        .SYNOPSIS
        Converts a version string to a PSSemVer object.

        .DESCRIPTION
        This function takes a version string and converts it to a PSSemVer object.

        .EXAMPLE
        '1.2.3-alpha.1+001' | ConvertTo-SemVer

        Major         : 1
        Minor         : 2
        Patch         : 3
        Prerelease    : alpha.1
        BuildMetadata : 001

        .NOTES
        Compatible with [PSSemVer 2.0.0](https://PSSemVer.org/).
    #>
    [OutputType([PSSemVer])]
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
        $PSSemVer = [PSSemVer]::new($Version)
        return $PSSemVer
    } catch {
        throw "Failed to convert '$Version' to PSSemVer."
    }
}
