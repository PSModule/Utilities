function Sync-GitRepo {
    git fetch upstream --prune
    git pull
    git push
}
Set-Alias -Name sync -Value Sync-Git
