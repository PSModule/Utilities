function Invoke-GitSquash {
    <#
        .SYNOPSIS
        Squash all commits on a branch into a single commit

        .DESCRIPTION
        Squash all commits on a branch into a single commit

        .EXAMPLE
        Invoke-GitSquash

        Squash all commits on a branch into a single commit
    #>
    [OutputType([void])]
    [CmdletBinding()]
    [Alias('Squash-Main')]
    param(
        # The commit message to use for the squashed commit
        [Parameter()]
        [string] $CommitMessage = 'Squash',

        # The branch to squash
        [Parameter()]
        [string] $BranchName = 'main',

        # Temporary branch name
        [Parameter()]
        [string] $TempBranchName = 'init'
    )

    git fetch --all --prune
    $gitHightFrom2ndCommit = [int](git rev-list --count --first-parent $BranchName) - 1
    git reset HEAD~$gitHightFrom2ndCommit
    git checkout -b $TempBranchName
    git add .
    git commit -m "$CommitMessage"
    git push --set-upstream origin $TempBranchName
    git checkout $BranchName
    git push --force
    git checkout $TempBranchName
}
