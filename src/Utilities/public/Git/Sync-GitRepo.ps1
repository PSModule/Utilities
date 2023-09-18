function Sync-Git {
    git fetch upstream --prune
    git pull
    git push
}
Set-Alias -Name sync -Value Sync-Git
