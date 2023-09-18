function New-GitHubLogGroup {
    [CmdletBinding()]
    param (
        [Parameter()]
        [string]
        $Title
    )
    Write-Output "::group::$Title"
}
