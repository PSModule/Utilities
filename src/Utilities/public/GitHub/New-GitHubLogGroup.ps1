function New-GitHubLogGroup {
    <#
        .SYNOPSIS
        Create a new log group in GitHub Actions

        .DESCRIPTION
        Create a new log group in GitHub Actions

        .EXAMPLE
        New-GitHubLogGroup -Title 'My log group'
    #>
    [OutputType([void])]
    [CmdletBinding()]
    param (
        # Title of the log group
        [Parameter()]
        [string] $Title
    )
    Write-Host "::group::$Title"
}
