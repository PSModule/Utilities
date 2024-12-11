function Test-Base64 {
    <#
        .SYNOPSIS
        Test if a string is a valid base64 string.

        .DESCRIPTION
        Test if a string is a valid base64 string.

        .EXAMPLE
        Test-Base64 -Base64String 'U29tZSBkYXRh'
        True

        Returns $true as the string is a valid base64 string.
    #>
    [OutputType([bool])]
    [CmdletBinding()]
    param (
        # The base64 encoded string to test.
        [Parameter(Mandatory)]
        [string] $Base64String
    )
    try {
        $null = [Convert]::FromBase64String($Base64String)
        return $true
    } catch {
        return $false
    }
}
