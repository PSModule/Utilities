function Show-FileContent {
    <#
        .SYNOPSIS
        Prints the content of a file with line numbers in front of each line.

        .DESCRIPTION
        Prints the content of a file with line numbers in front of each line.

        .EXAMPLE
        $Path = 'C:\Utilities\Show-FileContent.ps1'
        Show-FileContent -Path $Path

        Shows the content of the file with line numbers in front of each line.
    #>
    [CmdletBinding()]
    param (
        # The path to the file to show the content of.
        [Parameter(Mandatory)]
        [string] $Path
    )

    $content = Get-Content -Path $Path
    $lineNumber = 1
    $columnSize = $content.Count.ToString().Length
    # Foreach line print the line number in front of the line with [    ] around it.
    # The linenumber should dynamically adjust to the number of digits with the length of the file.
    foreach ($line in $content) {
        $lineNumberFormatted = $lineNumber.ToString().PadLeft($columnSize)
        Write-Host "[$lineNumberFormatted] $line"
        $lineNumber++
    }
}

#SkipTest:FunctionTest:Will add a test for this function in a future PR
