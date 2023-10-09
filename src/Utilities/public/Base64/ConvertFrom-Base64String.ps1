filter ConvertFrom-Base64String {
    [CmdletBinding()]
    param (
        # The string to convert from Base64
        [Parameter(
            Mandatory,
            ValueFromPipeline,
            ValueFromPipelineByPropertyName
        )]
        [string] $Text
    )
    $ConvertedString = [System.Convert]::FromBase64String($Text)
    $DecodedText = [System.Text.Encoding]::Unicode.GetString($ConvertedString)
    $DecodedText
}
