filter ConvertTo-Base64String {
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
