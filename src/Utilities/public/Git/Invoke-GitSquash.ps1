function Invoke-GitSquash {
    [CmdletBinding()]
    [Alias('Squash-Main')]
    param(
        [Parameter()]
        [string] $CommitMessage = 'Squash',

        [Parameter()]
        [string] $BranchName = 'main'
    )
    git fetch --all --prune
    $gitHightFrom2ndCommit = [int](git rev-list --count --first-parent $BranchName) - 1
    git reset HEAD~$gitHightFrom2ndCommit
    git commit -am "$CommitMessage"
    git push --force
}
