function Sync-Repo {
    git checkout main
    git pull
    git remote update origin --prune
    git branch -vv | Select-String -Pattern ': gone]' | ForEach-Object { $_.toString().Trim().Split(' ')[0] } | ForEach-Object { git branch -D $_ }
}
