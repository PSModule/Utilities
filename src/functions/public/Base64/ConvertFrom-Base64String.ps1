filter ConvertFrom-Base64String {
    <#
        .SYNOPSIS
        Convert to string from base64

        .DESCRIPTION
        Convert to string from base64

        .EXAMPLE
        ConvertFrom-Base64String -String 'SABlAGwAbABvACAAVwBvAHIAbABkAA=='

        Hello World

        Converts the string from base64 to a regular string.
    #>
    [CmdletBinding()]
    param (
        # The string to convert from base64
        [Parameter(
            Mandatory,
            ValueFromPipeline,
            ValueFromPipelineByPropertyName
        )]
        [string] $String
    )
    $ConvertedString = [System.Convert]::FromBase64String($String)
    $DecodedText = [System.Text.Encoding]::Unicode.GetString($ConvertedString)
    $DecodedText
}
