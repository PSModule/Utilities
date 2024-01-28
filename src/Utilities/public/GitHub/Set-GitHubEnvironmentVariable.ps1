function Set-GitHubEnvironmentVariable {
    <#
        .SYNOPSIS
        Set a GitHub environment variable

        .DESCRIPTION
        Set a GitHub environment variable

        .EXAMPLE
        Set-GitHubEnv -Name 'MyVariable' -Value 'MyValue'
    #>
    [OutputType([void])]
    [Alias('Set-GitHubEnv')]
    [CmdletBinding(SupportsShouldProcess)]
    param (
        # Name of the variable
        [Parameter(Mandatory)]
        [string] $Name,

        # Value of the variable
        [Parameter(Mandatory)]
        [string] $Value
    )
    Write-Verbose (@{ $Name = $Value } | Format-Table -HideTableHeaders -Wrap -AutoSize | Out-String) -Verbose
    if ($PSCmdlet.ShouldProcess("GitHub variable [$Name]=[$Value]", "Set")) {
        Write-Output "$Name=$Value" | Out-File -FilePath $Env:GITHUB_ENV -Encoding utf8 -Append
    }
}
