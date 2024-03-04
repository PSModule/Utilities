function Export-PowerShellDataFile {
    <#
        .SYNOPSIS
        Export a hashtable to a .psd1 file.

        .DESCRIPTION
        This function exports a hashtable to a .psd1 file. It also formats the .psd1 file using the Format-ModuleManifest cmdlet.

        .EXAMPLE
        Export-PowerShellDataFile -Hashtable @{ Name = 'MyModule'; ModuleVersion = '1.0.0' } -Path 'MyModule.psd1'
    #>
    [CmdletBinding()]
    param (
        # The hashtable to export to a .psd1 file.
        [Parameter(Mandatory)]
        [hashtable] $Hashtable,

        # The path of the .psd1 file to export.
        [Parameter(Mandatory)]
        [string] $Path,

        # Force the export, even if the file already exists.
        [Parameter()]
        [switch] $Force
    )

    $content = Convert-HashtableToString -Hashtable $Hashtable
    $content | Out-File -FilePath $Path -Force:$Force
    Format-ModuleManifest -Path $Path
}
