function Clear-GitRepo {
    <#
        .SYNOPSIS
        Deletes all branches except main and the current branch
    #>

    git fetch --all --prune
    (git branch).Trim() | Where-Object { $_ -notmatch 'main|\*' } | ForEach-Object { git branch $_ --delete --force }
}
