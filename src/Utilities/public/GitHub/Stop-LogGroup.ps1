function Stop-LogGroup {
    <#
        .SYNOPSIS
        Stops a log group.

        .DESCRIPTION
        Stops a log group.

        .EXAMPLE
        Stop-LogGroup

        .NOTES
        [Azure DevOps - Formatting commands](https://learn.microsoft.com/en-us/azure/devops/pipelines/scripts/logging-commands?view=azure-devops&tabs=bash#formatting-commands)
        [GitHub - Grouping log lines](https://docs.github.com/en/actions/using-workflows/workflow-commands-for-github-actions#grouping-log-lines)
    #>
    [CmdletBinding()]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute(
        'PSAvoidUsingWriteHost', '',
        Justification = 'Write-Host is used to group log messages.'
    )]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute(
        'PSUseShouldProcessForStateChangingFunctions', '', Scope = 'Function',
        Justification = 'This function does not change state. It only logs messages.'
    )]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute(
        'PSAvoidLongLines', '', Justification = 'Contains long links.'
    )]
    param ()

    if ($env:GITHUB_ACTIONS) {
        Write-Host '::endgroup::'
    } elseif ( $env:SYSTEM_TEAMFOUNDATIONCOLLECTIONURI ) {
        Write-Host '##[endgroup]'
    } else {
        Write-Host "-------- $Name --------"
    }
}
