filter Test-IsGUID {
    <#
        .SYNOPSIS
        Test if a string is a GUID

        .DESCRIPTION
        Test if a string is a GUID

        .EXAMPLE
        '123e4567-e89b-12d3-a456-426655440000' | Test-IsGUID

        True
    #>
    [Cmdletbinding()]
    [Alias('IsGUID')]
    [OutputType([bool])]
    param (
        # The string to test
        [Parameter(
            Mandatory,
            ValueFromPipeline,
            ValueFromPipelineByPropertyName
        )]
        [string] $String
    )

    [regex]$guidRegex = '(?im)^[{(]?[0-9A-F]{8}[-]?(?:[0-9A-F]{4}[-]?){3}[0-9A-F]{12}[)}]?$'

    # Check GUID against regex
    $String -match $guidRegex
}
