filter Copy-Object {
    <#
        .SYNOPSIS
        Copy an object

        .DESCRIPTION
        Copy an object

        .EXAMPLE
        $Object | Copy-Object

        Copy an object
    #>
    [OutputType([object])]
    [CmdletBinding()]
    param (
        # Object to copy
        [Parameter(
            Mandatory,
            ValueFromPipeline
        )]
        [Object] $InputObject
    )

    $InputObject | ConvertTo-Json -Depth 100 | ConvertFrom-Json

}

#SkipTest:FunctionTest:Will add a test for this function in a future PR
