function Set-GitHubEnv {
    <#
        .SYNOPSIS
        Set a GitHub environment variable

        .DESCRIPTION
        Set a GitHub environment variable

        .EXAMPLE
        Set-GitHubEnv -Name 'MyVariable' -Value 'MyValue'
    #>
    [OutputType([void])]
    [CmdletBinding()]
    param (
        # Name of the variable
        [Parameter(Mandatory)]
        [string] $Name,

        # Value of the variable
        [Parameter(Mandatory)]
        [string] $Value
    )
    if ($PSBoundParameters.ContainsKey('Verbose')) {
        @{ "$Name" = $Value } | Format-Table -HideTableHeaders -Wrap
    }
    Write-Output "$Name=$Value" | Out-File -FilePath $Env:GITHUB_ENV -Encoding utf8 -Append
}
