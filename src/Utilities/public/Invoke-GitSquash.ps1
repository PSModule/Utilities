function Invoke-GitSquash {
    [CmdletBinding()]
    [Alias('Squash-Main')]
    param()
    $gitHightFrom2ndCommit = [int](git rev-list --count --first-parent main) - 1
    git reset HEAD~$gitHightFrom2ndCommit
    git add .
    git commit -m 'Reset'
    git push --force
}
