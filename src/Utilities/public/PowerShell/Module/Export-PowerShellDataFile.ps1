function Export-PowerShellDataFile {
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
}
