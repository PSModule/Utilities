function Import-Variables {
    [CmdletBinding()]
    param (
        [Parameter(
            Mandatory,
            Position = 0,
            ValueFromPipeline = $true)]
        [string] $Path
    )
    Write-Output "$($MyInvocation.MyCommand) - $Path - Processing"
    if (-not (Test-Path -Path $Path)) {
        throw "$($MyInvocation.MyCommand) - $Path - File not found"
    }

    $Variables = Get-Content -Path $Path -Raw -Force | ConvertFrom-Json

    $NestedVariablesFilePaths = ($Variables.PSObject.Properties | Where-Object Name -EQ 'VariablesFilePaths').Value
    foreach ($NestedVariablesFilePath in $NestedVariablesFilePaths) {
        Write-Output "$($MyInvocation.MyCommand) - $Path - Nested variable files - $NestedVariablesFilePath"
        $NestedVariablesFilePath | Import-Variables
    }

    Write-Output "$($MyInvocation.MyCommand) - $Path - Loading variables"
    foreach ($Property in $Variables.PSObject.Properties) {
        if ($Property -match 'VariablesFilePaths') {
            continue
        }
        Set-GitHubEnv -Name $Property.Name -Value $Property.Value -Verbose
    }
    Write-Output "$($MyInvocation.MyCommand) - $Path - Done"
}
