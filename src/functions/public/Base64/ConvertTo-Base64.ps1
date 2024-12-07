function ConvertTo-Base64 {
    <#
        .SYNOPSIS
        Converts a string to a Base64 encoded string.

        .DESCRIPTION
        Converts a string to a Base64 encoded string.

        .EXAMPLE
        ConvertTo-Base64 -String 'ThisIsANiceString'
        VGhpc0lzQU5pY2VTdHJpbmc=

        Converts the string 'ThisIsANiceString' to a Base64 encoded string.
    #>
    [OutputType([string])]
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [string] $String
    )

    [Convert]::ToBase64String([System.Text.Encoding]::UTF8.GetBytes($String))
}
