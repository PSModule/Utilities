function Restore-GitRepo {
    <#
        .SYNOPSIS
        Restore a Git repository with upstream

        .DESCRIPTION
        Restore a Git repository with upstream

        .EXAMPLE
        Restore-GitRepo
    #>
    [OutputType([void])]
    [CmdletBinding()]
    param(
        # The name of the branch to squash
        [Parameter()]
        [string] $BranchName = 'main'
    )

    git remote add upstream https://github.com/Azure/ResourceModules.git
    git fetch upstream
    git restore --source upstream/$BranchName * ':!*global.variables.*' ':!settings.json*'
}
