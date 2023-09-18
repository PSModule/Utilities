function Squash-Branch {
    git reset $(git merge-base master $(git branch --show-current))
}
Set-Alias -Name squash -Value Squash-Branch
