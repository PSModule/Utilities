function Format-ModuleManifest {
    <#
        .SYNOPSIS
        Formats a module manifest file.

        .DESCRIPTION
        This function formats a module manifest file, by removing comments and empty lines,
        and then formatting the file using the `Invoke-Formatter` function.

        .EXAMPLE
        Format-ModuleManifest -Path 'C:\MyModule\MyModule.psd1'
    #>
    [CmdletBinding()]
    param(
        # Path to the module manifest file.
        [Parameter(Mandatory)]
        [string] $Path
    )

    $Utf8BomEncoding = New-Object System.Text.UTF8Encoding $true

    $manifestContent = Get-Content -Path $Path
    $manifestContent = $manifestContent | ForEach-Object { $_ -replace '#.*' }
    $manifestContent = $manifestContent | ForEach-Object { $_.TrimEnd() }
    $manifestContent = $manifestContent | Where-Object { $_ | IsNotNullOrEmpty }
    [System.IO.File]::WriteAllLines($Path, $manifestContent, $Utf8BomEncoding)
    $manifestContent = Get-Content -Path $Path -Raw

    $content = Invoke-Formatter -ScriptDefinition $manifestContent

    # Ensure exactly one empty line at the end
    $content = $content.TrimEnd("`r", "`n") + "`r`n"

    [System.IO.File]::WriteAllText($Path, $content, $Utf8BomEncoding)

}
