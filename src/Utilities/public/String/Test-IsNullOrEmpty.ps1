filter Test-IsNullOrEmpty {
    <#
        .SYNOPSIS
        Test if an object is null or empty

        .DESCRIPTION
        Test if an object is null or empty

        .EXAMPLE
        '' | IsNullOrEmpty -Verbose

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

    Write-Verbose "Object is: $($Object.GetType().Name)"

    try {
        if (-not ($PSBoundParameters.ContainsKey('Object'))) {
            Write-Verbose 'Object was never passed, meaning its empty or null.'
            return $true
        }
        if ($null -eq $Object) {
            Write-Verbose 'Object is null'
            return $true
        }
        if ($Object -eq 0) {
            Write-Verbose 'Object is 0'
            return $true
        }
        if ($Object.Length -eq 0) {
            Write-Verbose 'Object is empty array or string'
            return $true
        }
        if ($Object.GetType() -eq [string]) {
            if ([string]::IsNullOrWhiteSpace($Object)) {
                Write-Verbose 'Object is empty string'
                return $true
            } else {
                Write-Verbose 'Object is not an empty string'
                return $false
            }
        }
        if ($Object.Count -eq 0) {
            Write-Verbose 'Object count is 0'
            return $true
        }
        if (-not $Object) {
            Write-Verbose 'Object evaluates to false'
            return $true
        }
        if (($Object.GetType().Name -ne 'PSCustomObject')) {
            Write-Verbose 'Casting object to PSCustomObject'
            $Object = [PSCustomObject]$Object
        }
        if (($Object.GetType().Name -eq 'PSCustomObject')) {
            Write-Verbose 'Object is PSCustomObject'
            if ($Object -eq (New-Object -TypeName PSCustomObject)) {
                Write-Verbose 'Object is similar to empty PSCustomObject'
                return $true
            }
            if (($Object.psobject.Properties).Count | Test-IsNullOrEmpty) {
                Write-Verbose 'Object has no properties'
                return $true
            }
        }
    } catch {
        Write-Verbose 'Object triggered exception'
        return $true
    }

    Write-Verbose 'Object is not null or empty'
    return $false
}
