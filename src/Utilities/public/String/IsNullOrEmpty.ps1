function IsNullOrEmpty {
    [OutputType([bool])]
    [Cmdletbinding()]
    param(
        [Parameter(
            Mandatory,
            ValueFromPipeline
        )]
        [object] $Object
    )

    if ($PSBoundParameters.Keys.Contains('Verbose')) {
        Write-Verbose 'Received object:'
        $Object
        Write-Verbose "Length is: $($Object.Length)"
        Write-Verbose "Count is: $($Object.Count)"
        try {
            Write-Verbose "Enumerator: $($Object.GetEnumerator())"
        } catch {}

        Write-Verbose 'PSObject'
        Write-Verbose $Object.PSObject
        Write-Verbose 'PSObject  --   BaseObject'
        Write-Verbose $Object.PSObject.BaseObject

        Write-Verbose 'PSObject  --   BaseObject  --   BaseObject'
        Write-Verbose $Object.PSObject.BaseObject.PSObject.BaseObject

        Write-Verbose 'PSObject  --   BaseObject  --   Properties'
        Write-Verbose ($Object.PSObject.BaseObject.PSObject.Properties | Select-Object Name, @{n = 'Type'; e = { $_.TypeNameOfValue } }, Value | Format-Table -AutoSize)

        Write-Verbose 'PSObject  --   Properties'
        Write-Verbose ($Object.PSObject.Properties | Select-Object Name, @{n = 'Type'; e = { $_.TypeNameOfValue } }, Value | Format-Table -AutoSize)
    }

    try {
        if ($null -eq $Object) {
            Write-Verbose 'Object is null'
            return $true
        }
        if ($Object -eq 0) {
            Write-Verbose 'Object is 0'
            return $true
        }
        if ($Object.GetType() -eq [string]) {
            if ([String]::IsNullOrWhiteSpace($Object)) {
                Write-Verbose 'Object is empty string'
                return $true
            } else {
                return $false
            }
        }
        if ($Object.count -eq 0) {
            Write-Verbose 'Object count is 0'
            return $true
        }
        if (-not $Object) {
            Write-Verbose 'Object evaluates to false'
            return $true
        }

        #Evaluate Empty objects
        if (($Object.GetType().Name -ne 'pscustomobject') -or $Object.GetType() -ne [pscustomobject]) {
            Write-Verbose 'Casting object to PSCustomObject'
            $Object = [pscustomobject]$Object
        }

        if (($Object.GetType().Name -eq 'pscustomobject') -or $Object.GetType() -eq [pscustomobject]) {
            if ($Object -eq (New-Object -TypeName pscustomobject)) {
                Write-Verbose 'Object is similar to empty PSCustomObject'
                return $true
            }
            if ($Object.psobject.Properties | IsNullOrEmpty) {
                Write-Verbose 'Object has no properties'
                return $true
            }
        }
    } catch {
        Write-Verbose 'Object triggered exception'
        return $true
    }

    return $false
}
