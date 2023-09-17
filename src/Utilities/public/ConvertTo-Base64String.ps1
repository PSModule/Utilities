Function ConvertTo-Base64String {
    param(
        # Parameter help description
        [Parameter(
            Mandatory,
            ValueFromPipeline,
            ValueFromPipelineByPropertyName)]
        [string]
        $Text
    )
    $Bytes = [System.Text.Encoding]::Unicode.GetBytes($Text)
    $EncodedText = [System.Convert]::ToBase64String($Bytes)

    #$ADOToken = [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(":$($PAT)"))

    return $EncodedText
}
