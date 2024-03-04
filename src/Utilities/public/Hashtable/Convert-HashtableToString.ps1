function Convert-HashtableToString {
    <#
        .SYNOPSIS
        Converts a hashtable to its code representation.

        .DESCRIPTION
        Recursively converts a hashtable to its code representation.
        This function is useful for exporting hashtables to .psd1 files.

        .EXAMPLE
        $hashtable = @{
            Key1 = 'Value1'
            Key2 = @{
                NestedKey1 = 'NestedValue1'
                NestedKey2 = 'NestedValue2'
            }
            Key3 = @(1, 2, 3)
            Key4 = $true
        }
        Convert-HashtableToString -Hashtable $hashtable

        This will return the following string:
        @{
            Key1 = 'Value1'
            Key2 = @{
                NestedKey1 = 'NestedValue1'
                NestedKey2 = 'NestedValue2'
            }
            Key3 = @(1, 2, 3)
            Key4 = $true
        }

        .NOTES
        General notes
    #>
    [CmdletBinding()]
    param (
        # The hashtable to convert to a string.
        [Parameter(Mandatory)]
        [hashtable]$Hashtable,

        # The indentation level.
        [Parameter()]
        [int]$IndentLevel = 0
    )

    $lines = @()
    $lines += '@{'
    $indent = '    ' * $IndentLevel

    foreach ($key in $Hashtable.Keys) {
        $value = $Hashtable[$key]
        if ($value -is [hashtable]) {
            $nestedString = Convert-HashtableToString -Hashtable $value -IndentLevel ($IndentLevel + 1)
            $lines += "$indent    $key = $nestedString"
        } elseif ($value -is [System.Management.Automation.PSCustomObject]) {
            $nestedString = Convert-HashtableToString -Hashtable $value -IndentLevel ($IndentLevel + 1)
            $lines += "$indent    $key = $nestedString"
        } elseif ($value -is [System.Management.Automation.PSObject]) {
            $nestedString = Convert-HashtableToString -Hashtable $value -IndentLevel ($IndentLevel + 1)
            $lines += "$indent    $key = $nestedString"
        } elseif ($value -is [array]) {
            $lines += "$indent    $key = @("
            $value | ForEach-Object { $lines += "$indent        '$_'" }
            $lines += "$indent    )"
        } elseif ($value -is [bool]) {
            $lines += "$indent    $key = `$$($value.ToString().ToLower())"
        } elseif ($value -is [int]) {
            $lines += "$indent    $key = $value"
        } else {
            $lines += "$indent    $key = '$value'"
        }
    }

    $lines += "$indent}"
    return $lines -join "`n"
}
