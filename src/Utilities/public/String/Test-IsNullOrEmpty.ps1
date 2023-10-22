function Test-IsNullOrEmpty {
    <#
        .SYNOPSIS
        Test if an object is null or empty

        .DESCRIPTION
        Test if an object is null or empty

        .EXAMPLE
        '' | IsNullOrEmpty -Verbose

        True
    #>
    [alias('IsNullOrEmpty')]
    [OutputType([bool])]
    [Cmdletbinding()]
    param(
        # The object to test
        [Parameter(
            Mandatory,
            ValueFromPipeline
        )]
        [object] $Object
    )

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
