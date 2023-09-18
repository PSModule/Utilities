function ConvertTo-Boolean {
    [CmdletBinding()]
    param(
        [Parameter(
            Position = 0,
            ValueFromPipeline = $true)]
        [string] $String
    )
    switch -regex ($String.Trim()) {
        '^(1|true|yes|on|enabled)$' { $true }

        default { $false }
    }
}
