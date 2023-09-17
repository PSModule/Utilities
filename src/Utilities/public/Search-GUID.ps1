function Search-GUID {
    [Cmdletbinding()]
    [OutputType([guid])]
    param(
        [Parameter( Mandatory = $true,
            Position = 0,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true)]
        [string] $String
    )
    Write-Verbose "Looking for a GUID in $String"
    $GUID = $String.ToLower() |
        Select-String -Pattern '[0-9a-f]{8}\-[0-9a-f]{4}\-[0-9a-f]{4}\-[0-9a-f]{4}\-[0-9a-f]{12}' |
        Select-Object -ExpandProperty Matches |
        Select-Object -ExpandProperty Value
    Write-Verbose "Found GUID: $GUID"
    return $GUID
}
