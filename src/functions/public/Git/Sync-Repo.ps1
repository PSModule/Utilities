function Sync-Repo {
    <#
        .SYNOPSIS
        Sync a Git repository with upstream

        .DESCRIPTION
        Sync a Git repository with upstream

        .EXAMPLE
        Sync-Repo
    #>
    [OutputType([void])]
    [CmdletBinding()]
    param()
    git checkout main
    git pull
    git remote update origin --prune
    git branch -vv | Select-String -Pattern ': gone]' | ForEach-Object { $_.toString().Trim().Split(' ')[0] } | ForEach-Object { git branch -D $_ }
}

#SkipTest:FunctionTest:Will add a test for this function in a future PR
