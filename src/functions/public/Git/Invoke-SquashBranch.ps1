function Invoke-SquashBranch {
    <#
        .SYNOPSIS
        Squash a branch to a single commit

        .DESCRIPTION
        Squash a branch to a single commit

        .EXAMPLE
        Invoke-SquashBranch
    #>
    [Alias('Squash-Branch')]
    [CmdletBinding()]
    param(
        # The name of the branch to squash
        [Parameter()]
        [string] $BranchName = 'main'
    )
    git reset $(git merge-base $BranchName $(git branch --show-current))
}

#SkipTest:FunctionTest:Will add a test for this function in a future PR
