Function Remove-EmptyFolder {
    <#
.SYNOPSIS
Removes empty folders under the folder specified

.DESCRIPTION
Long description

.PARAMETER Path
The path to the folder to be cleaned

.EXAMPLE
Remove-EmptyFolder -Path . -Verbose

Removes empty folders under the current path and outputs the results to the console.

#>
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [Parameter(Mandatory = $true)]
        [string]
        $Path
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
