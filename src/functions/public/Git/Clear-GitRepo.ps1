function Clear-GitRepo {
    <#
        .SYNOPSIS
        Clear a Git repository of all branches except main

        .DESCRIPTION
        Clear a Git repository of all branches except main

        .EXAMPLE
        Clear-GitRepo

        Clear a Git repository of all branches except main
    #>
    [OutputType([void])]
    [CmdletBinding()]
    param()

    git fetch --all --prune
    (git branch).Trim() | Where-Object { $_ -notmatch 'main|\*' } | ForEach-Object { git branch $_ --delete --force }
}

#SkipTest:FunctionTest:Will add a test for this function in a future PR
