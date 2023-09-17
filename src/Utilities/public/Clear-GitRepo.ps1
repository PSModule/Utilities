function Clear-GitRepo {
    (git branch).Trim() | Where-Object { $_ -notmatch 'main|\*' } | ForEach-Object { git branch $_ -d -f }
}
