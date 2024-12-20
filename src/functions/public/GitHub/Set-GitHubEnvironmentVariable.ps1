﻿function Set-GitHubEnvironmentVariable {
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
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute(
        'PSUseShouldProcessForStateChangingFunctions', '', Scope = 'Function',
        Justification = 'Does not change system state significantly'
    )]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute(
        'PSAvoidUsingWriteHost', '',
        Justification = 'Write-Host is used to group log messages.'
    )]
    [CmdletBinding()]
    param (
        # Name of the variable
        [Parameter(Mandatory)]
        [string] $Name,

        # Value of the variable
        [Parameter(Mandatory)]
        [string] $Value
    )
    Write-Verbose (@{ $Name = $Value } | Format-Table -Wrap -AutoSize | Out-String)
    Write-Host "$Name=$Value" | Out-File -FilePath $env:GITHUB_ENV -Encoding utf8 -Append
}
