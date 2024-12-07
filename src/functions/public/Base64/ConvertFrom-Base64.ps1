function ConvertFrom-Base64 {
    <#
        .SYNOPSIS
        Converts a Base64 encoded string to a string.

        .DESCRIPTION
        Converts a Base64 encoded string to a string.

        .EXAMPLE
        ConvertFrom-Base64 -Base64String 'VGhpc0lzQU5pY2VTdHJpbmc='
        ThisIsANiceString

        Converts the Base64 encoded string 'VGhpc0lzQU5pY2VTdHJpbmc=' to a string.
    #>
    [OutputType([string])]
    [CmdletBinding()]
    param(
        # The Base64 encoded string to convert.
        [Parameter(Mandatory = $true)]
        [string] $Base64String
    )

    [System.Text.Encoding]::UTF8.GetString([Convert]::FromBase64String($Base64String))
}
