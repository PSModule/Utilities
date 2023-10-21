filter ConvertTo-Base64String {
    <#
        .SYNOPSIS
        Convert a string to Base64

        .DESCRIPTION
        Convert a string to Base64

        .EXAMPLE
        'Hello World' | ConvertTo-Base64String

        SABlAGwAbABvACAAVwBvAHIAbABkAA==

        Converts the string 'Hello World' to Base64.
    #>
    [OutputType([string])]
    [CmdletBinding()]
    param(
        # The string to convert to Base64
        [Parameter(
            Mandatory,
            ValueFromPipeline,
            ValueFromPipelineByPropertyName
        )]
        [string] $Text
    )
    $Bytes = [System.Text.Encoding]::Unicode.GetBytes($Text)
    $EncodedText = [System.Convert]::ToBase64String($Bytes)
    #$ADOToken = [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(":$($PAT)"))
    $EncodedText
}
