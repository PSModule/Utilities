function ConvertTo-Hashtable {
    param (
        [Parameter(Mandatory=$true, ValueFromPipeline=$true)]
        [PSObject]$InputObject
    )

    process {
        if ($InputObject -is [System.Collections.IEnumerable] -and $InputObject -notlike "*") {
            $array = @()
            foreach ($item in $InputObject) {
                $array += ConvertTo-Hashtable -InputObject $item
            }
            return $array
        } elseif ($InputObject.PSObject.Properties.Name.Count -gt 0) {
            $hashtable = @{}
            foreach ($property in $InputObject.PSObject.Properties) {
                $hashtable[$property.Name] = ConvertTo-Hashtable -InputObject $property.Value
            }
            return $hashtable
        } else {
            return $InputObject
        }
    }
}

$json = '{
    "key1": "value1",
    "key2": {
        "nestedKey1": "nestedValue1",
        "nestedKey2": [1, 2, 3]
    },
    "key3": ["item1", "item2"]
}'

$object = $json | ConvertFrom-Json
$hashtable = ConvertTo-Hashtable -InputObject $object

$hashtable
