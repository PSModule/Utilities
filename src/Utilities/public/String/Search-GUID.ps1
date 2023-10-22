function Search-GUID {
    <#
        .SYNOPSIS
        Search a string for a GUID

        .DESCRIPTION
        Search a string for a GUID

        .EXAMPLE
        '123e4567-e89b-12d3-a456-426655440000' | Search-GUID
    #>
    [Cmdletbinding()]
    [OutputType([guid])]
    param(
        # The string to search
        [Parameter(
            Mandatory,
            ValueFromPipeline,
            ValueFromPipelineByPropertyName
        )]
        [string] $String
    )
    Write-Verbose "Looking for a GUID in $String"
    $GUID = $String.ToLower() |
        Select-String -Pattern '[0-9a-f]{8}\-[0-9a-f]{4}\-[0-9a-f]{4}\-[0-9a-f]{4}\-[0-9a-f]{12}' |
        Select-Object -ExpandProperty Matches |
        Select-Object -ExpandProperty Value
    Write-Verbose "Found GUID: $GUID"
    $GUID
}
