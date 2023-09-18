Function ConvertFrom-Base64String {
    [CmdletBinding()]
    param (
        [Parameter(
            Mandatory,
            ValueFromPipeline,
            ValueFromPipelineByPropertyName)]
        [string]
        $Text
    )
    $ConvertedString = [System.Convert]::FromBase64String($Text)
    $DecodedText = [System.Text.Encoding]::Unicode.GetString($ConvertedString)
    return $DecodedText
}
