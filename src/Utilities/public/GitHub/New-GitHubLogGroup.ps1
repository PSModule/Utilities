function New-GitHubLogGroup {
    <#
        .SYNOPSIS
        Create a new log group in GitHub Actions

        .DESCRIPTION
        Create a new log group in GitHub Actions

        .EXAMPLE
        New-GitHubLogGroup -Title 'My log group'
    #>
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute(
        'PSAvoidUsingWriteHost', '',
        Justification = 'GitHub Actions functions uses stdout as control mechanism.'
    )]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute(
        'PSUseShouldProcessForStateChangingFunctions', '',
        Justification = 'GitHub Actions functions uses stdout as control mechanism.'
    )]
    [OutputType([void])]
    [CmdletBinding()]
    param (
        # Title of the log group
        [Parameter()]
        [string] $Title
    )
    Write-Host "::group::$Title"
}
