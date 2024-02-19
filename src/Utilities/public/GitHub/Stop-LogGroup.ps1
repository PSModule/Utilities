function Stop-LogGroup {
    <#
        .SYNOPSIS
        Stops a log group.

        .DESCRIPTION
        Stops a log group.

        .EXAMPLE
        Stop-LogGroup
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
    param ()

    Write-Host "##[endgroup]"
}
