filter ConvertTo-Boolean {
    <#
        .SYNOPSIS
        Convert string to boolean.

        .DESCRIPTION
        Convert string to boolean.

        .EXAMPLE
        ConvertTo-Boolean -String 'true'

        True

        Convert string to boolean.
    #>
    [OutputType([bool])]
    [CmdletBinding()]
    param(
        # The string to be converted to boolean.
        [Parameter(
            Mandatory,
            ValueFromPipeline,
            ValueFromPipelineByPropertyName
        )]
        [string] $String
    )

    switch -regex ($String.Trim()) {
        '^(1|true|yes|on|enabled)$' { $true }
        default { $false }
    }
}

#SkipTest:FunctionTest:Will add a test for this function in a future PR
