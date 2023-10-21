function Reset-GitRepo {
    <#
        .SYNOPSIS
        Reset a Git repository to the upstream branch

        .DESCRIPTION
        Reset a Git repository to the upstream branch

        .EXAMPLE
        Reset-GitRepo

        Reset a Git repository to the upstream branch
    #>
    [OutputType([void])]
    [CmdletBinding()]
    param(
        # The upstream repository to reset to
        [Parameter()]
        [string] $Upstream = 'upstream',

        # The branch to reset
        [Parameter()]
        [string] $Branch = 'main',

        # Whether to push the reset
        [Parameter()]
        [switch] $Push
    )

    git fetch $Upstream
    git checkout $Branch
    git reset --hard $Upstream/$Branch

    if ($Push) {
        git push origin $Branch --force
    }
}
Set-Alias -Name Reset -Value Reset-Repo
