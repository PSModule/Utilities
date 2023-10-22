function Sync-GitRepo {
    <#
        .SYNOPSIS
        Sync a Git repository with upstream

        .DESCRIPTION
        Sync a Git repository with upstream

        .EXAMPLE
        Sync-GitRepo
    #>
    [OutputType([void])]
    [CmdletBinding()]
    param()
    git fetch upstream --prune
    git pull
    git push
}
Set-Alias -Name sync -Value Sync-Git
