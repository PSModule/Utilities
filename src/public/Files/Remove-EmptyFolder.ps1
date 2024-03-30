Function Remove-EmptyFolder {
    <#
        .SYNOPSIS
        Removes empty folders under the folder specified

        .DESCRIPTION
        Removes empty folders under the folder specified

        .EXAMPLE
        Remove-EmptyFolder -Path .

        Removes empty folders under the current path and outputs the results to the console.
    #>
    [OutputType([void])]
    [CmdletBinding(SupportsShouldProcess)]
    param(
        # The path to the folder to be cleaned
        [Parameter(Mandatory)]
        [string] $Path
    )

    Get-ChildItem -Path $Path -Recurse -Directory | ForEach-Object {
        if ($null -eq (Get-ChildItem $_.FullName -Force -Recurse)) {
            Write-Verbose "Removing empty folder: [$($_.FullName)]"
            if ($PSCmdlet.ShouldProcess("folder [$($_.FullName)]", 'Remove')) {
                Remove-Item $_.FullName -Force
            }
        }
    }
}
