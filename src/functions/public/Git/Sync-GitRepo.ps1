function Sync-GitRepo {
    <#
        .SYNOPSIS
        Sync a Git repository with upstream

        .DESCRIPTION
        Sync a Git repository with upstream

        .EXAMPLE
        Sync-GitRepo
    #>
    [Alias('Sync-Git')]
    [OutputType([void])]
    [CmdletBinding()]
    param()
    git fetch upstream --prune
    git pull
    git push
}

#SkipTest:FunctionTest:Will add a test for this function in a future PR
