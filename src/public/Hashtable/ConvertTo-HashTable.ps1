filter ConvertTo-Hashtable {
    <#
    .SYNOPSIS
    Converts an object to a hashtable.

    .DESCRIPTION
    Recursively converts an object to a hashtable. This function is useful for converting complex objects
     to hashtables for serialization or other purposes.

    .EXAMPLE
    $object = [PSCustomObject]@{
        Name        = 'John Doe'
        Age         = 30
        Address     = [PSCustomObject]@{
            Street  = '123 Main St'
            City    = 'Somewhere'
            ZipCode = '12345'
        }
        Occupations = @(
            [PSCustomObject]@{
                Title   = 'Developer'
                Company = 'TechCorp'
            },
            [PSCustomObject]@{
                Title   = 'Consultant'
                Company = 'ConsultCorp'
            }
        )
    }
    $hashtable = ConvertTo-Hashtable -InputObject $object

    This will return a hashtable representation of the object.
    #>
    param (
        # The object to convert to a hashtable.
        [Parameter(
            Mandatory,
            ValueFromPipeline
        )]
        [PSObject] $InputObject
    )

    $hashtable = @{}

    # Iterate over each property of the object
    $InputObject.PSObject.Properties | ForEach-Object {
        $propertyName = $_.Name
        $propertyValue = $_.Value

        if ($propertyValue -is [PSObject]) {
            if ($propertyValue -is [Array] -or $propertyValue -is [System.Collections.IEnumerable]) {
                # Handle arrays and enumerables
                $hashtable[$propertyName] = @()
                foreach ($item in $propertyValue) {
                    $hashtable[$propertyName] += ConvertTo-HashtableRecursively -InputObject $item
                }
            } elseif ($propertyValue.PSObject.Properties.Count -gt 0) {
                # Handle nested objects
                $hashtable[$propertyName] = ConvertTo-HashtableRecursively -InputObject $propertyValue
            } else {
                # Handle simple properties
                $hashtable[$propertyName] = $propertyValue
            }
        } else {
            $hashtable[$propertyName] = $propertyValue
        }
    }

    return $hashtable
}
