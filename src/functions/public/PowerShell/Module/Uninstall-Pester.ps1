function Uninstall-Pester {
    <#
        .SYNOPSIS
        Uninstall Pester 3 from Program Files and Program Files (x86)

        .DESCRIPTION
        Uninstall Pester 3 from Program Files and Program Files (x86). This is useful
        when you want to install Pester 4 and you have Pester 3 installed.

        .PARAMETER All

        .EXAMPLE
        Uninstall-Pester

        Uninstall Pester 3 from Program Files and Program Files (x86).

        .EXAMPLE
        Uninstall-Pester -All

        Completely remove all built-in Pester 3 installations.
    #>
    [OutputType([String])]
    [CmdletBinding()]
    param (
        # Completely remove all built-in Pester 3 installations
        [Parameter()]
        [switch] $All
    )

    $pesterPaths = foreach ($programFiles in ($env:ProgramFiles, ${env:ProgramFiles(x86)})) {
        $path = "$programFiles\WindowsPowerShell\Modules\Pester"
        if ($null -ne $programFiles -and (Test-Path $path)) {
            if ($All) {
                Get-Item $path
            } else {
                Get-ChildItem "$path\3.*"
            }
        }
    }

    if (-not $pesterPaths) {
        "There are no Pester$(if (-not $all) {' 3'}) installations in Program Files and Program Files (x86) doing nothing."
        return
    }

    foreach ($pesterPath in $pesterPaths) {
        takeown /F $pesterPath /A /R
        icacls $pesterPath /reset
        # grant permissions to Administrators group, but use SID to do
        # it because it is localized on non-us installations of Windows
        icacls $pesterPath /grant '*S-1-5-32-544:F' /inheritance:d /T
        Remove-Item -Path $pesterPath -Recurse -Force -Confirm:$false
    }
}
