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

    $manifestContent = Get-Content -Path $Path
    $manifestContent = $manifestContent | ForEach-Object { $_ -replace '#.*' }
    $manifestContent = $manifestContent | ForEach-Object { $_.TrimEnd() }
    $manifestContent = $manifestContent | Where-Object { $_ | IsNotNullOrEmpty }
    $manifestContent | Out-File -FilePath $Path -Encoding utf8BOM -Force
    $manifestContent = Get-Content -Path $Path -Raw

    Invoke-Formatter -ScriptDefinition $manifestContent | Out-File -FilePath $Path -Encoding utf8BOM -Force

}
