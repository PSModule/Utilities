function Set-GitHubEnv {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [string] $Name,
        [Parameter(Mandatory)]
        [string] $Value
    )
    if ($PSBoundParameters.ContainsKey('Verbose')) {
        @{ "$Name" = $Value } | Format-Table -HideTableHeaders -Wrap
    }
    Write-Output "$Name=$Value" | Out-File -FilePath $Env:GITHUB_ENV -Encoding utf8 -Append
}
