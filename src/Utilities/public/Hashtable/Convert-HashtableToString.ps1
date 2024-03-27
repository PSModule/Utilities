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
        [object]$Hashtable,

        # The indentation level.
        [Parameter()]
        [int]$IndentLevel = 0
    )

    $lines = @()
    $lines += '@{'
    $indent = '    ' * $IndentLevel

    foreach ($key in $Hashtable.Keys) {
        Write-Verbose "Processing key: $key"
        $value = $Hashtable[$key]
        Write-Verbose "Processing value: $value"
        Write-Verbose "Value type: $($value.GetType().Name)"
        if (($value -is [System.Collections.Hashtable]) -or ($value -is [System.Collections.Specialized.OrderedDictionary])) {
            $nestedString = Convert-HashtableToString -Hashtable $value -IndentLevel ($IndentLevel + 1)
            $lines += "$indent    $key = $nestedString"
        } elseif ($value -is [System.Management.Automation.PSCustomObject]) {
            $nestedString = Convert-HashtableToString -Hashtable $value -IndentLevel ($IndentLevel + 1)
            $lines += "$indent    $key = $nestedString"
        } elseif ($value -is [System.Management.Automation.PSObject]) {
            $nestedString = Convert-HashtableToString -Hashtable $value -IndentLevel ($IndentLevel + 1)
            $lines += "$indent    $key = $nestedString"
        } elseif ($value -is [bool]) {
            $lines += "$indent    $key = `$$($value.ToString().ToLower())"
        } elseif ($value -is [int]) {
            $lines += "$indent    $key = $value"
        } elseif ($value -is [array]) {
            if ($value.Count -eq 0) {
                $lines += "$indent    $key = @()"
            } else {
                $lines += "$indent    $key = @("
                $value | ForEach-Object {
                    $nestedValue = $_
                    Write-Verbose "Processing array element: $_"
                    Write-Verbose "Element type: $($_.GetType().Name)"
                    if (($nestedValue -is [System.Collections.Hashtable]) -or ($nestedValue -is [System.Collections.Specialized.OrderedDictionary])) {
                        $nestedString = Convert-HashtableToString -Hashtable $nestedValue -IndentLevel ($IndentLevel + 1)
                        $lines += "$indent    $nestedString"
                    } elseif ($nestedValue -is [bool]) {
                        $lines += "$indent    `$$($nestedValue.ToString().ToLower())"
                    } elseif ($nestedValue -is [int]) {
                        $lines += "$indent    $nestedValue"
                    } else {
                        $lines += "$indent        '$nestedValue'"
                    }
                }
                $lines += "$indent    )"
            }
        } else {
            $lines += "$indent    $key = '$value'"
        }
    }

    $lines += "$indent}"
    return $lines -join "`n"
}
