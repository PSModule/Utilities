filter Test-IsNullOrEmpty {
    <#
        .SYNOPSIS
        Test if an object is null or empty

        .DESCRIPTION
        Test if an object is null or empty

        .EXAMPLE
        '' | IsNullOrEmpty

        True
    #>
    [OutputType([bool])]
    [Cmdletbinding()]
    [Alias('IsNullOrEmpty')]
    param(
        # The object to test
        [Parameter(
            ValueFromPipeline,
            ValueFromPipelineByPropertyName
        )]
        [AllowNull()]
        [object] $Object
    )

    try {
        if (-not ($PSBoundParameters.ContainsKey('Object'))) {
            Write-Debug 'Object was never passed, meaning its empty or null.'
            return $true
        }
        if ($null -eq $Object) {
            Write-Debug 'Object is null'
            return $true
        }
        Write-Debug "Object is: $($Object.GetType().Name)"
        if ($Object -eq 0) {
            Write-Debug 'Object is 0'
            return $true
        }
        if ($Object.Length -eq 0) {
            Write-Debug 'Object is empty array or string'
            return $true
        }
        if ($Object.GetType() -eq [string]) {
            if ([string]::IsNullOrWhiteSpace($Object)) {
                Write-Debug 'Object is empty string'
                return $true
            } else {
                Write-Debug 'Object is not an empty string'
                return $false
            }
        }
        if ($Object.Count -eq 0) {
            Write-Debug 'Object count is 0'
            return $true
        }
        if (-not $Object) {
            Write-Debug 'Object evaluates to false'
            return $true
        }
        if (($Object.GetType().Name -ne 'PSCustomObject')) {
            Write-Debug 'Casting object to PSCustomObject'
            $Object = [PSCustomObject]$Object
        }
        if (($Object.GetType().Name -eq 'PSCustomObject')) {
            Write-Debug 'Object is PSCustomObject'
            if ($Object -eq (New-Object -TypeName PSCustomObject)) {
                Write-Debug 'Object is similar to empty PSCustomObject'
                return $true
            }
            if (($Object.psobject.Properties).Count | Test-IsNullOrEmpty) {
                Write-Debug 'Object has no properties'
                return $true
            }
        }
    } catch {
        Write-Debug 'Object triggered exception'
        return $true
    }

    Write-Debug 'Object is not null or empty'
    return $false
}
