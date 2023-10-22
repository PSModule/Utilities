<#
'' | IsNullOrEmpty -Verbose
'' | IsNotNullOrEmpty -Verbose

' ' | IsNullOrEmpty -Verbose
' ' | IsNotNullOrEmpty -Verbose

'a' | IsNullOrEmpty -Verbose
'a' | IsNotNullOrEmpty -Verbose

@'
'@ | IsNullOrEmpty -Verbose
@'
'@ | IsNotNullOrEmpty -Verbose

@'

'@ | IsNullOrEmpty -Verbose
@'

'@ | IsNotNullOrEmpty -Verbose

@'
Test
'@ | IsNullOrEmpty -Verbose
@'
Test
'@ | IsNotNullOrEmpty -Verbose


$null | IsNullOrEmpty -Verbose
$null | IsNotNullOrEmpty -Verbose
@{} | IsNullOrEmpty -Verbose
@{} | IsNotNullOrEmpty -Verbose

@{
    Test = 'Test'
} | IsNullOrEmpty -Verbose

@{
    Test = 'Test'
} | IsNotNullOrEmpty -Verbose

@{
    Test = $null
    Null = ''
} | IsNullOrEmpty -Verbose
@{
    Test = $null
    Null = ''
} | IsNotNullOrEmpty -Verbose

$Object = [pscustomobject]@{}
$Object | IsNullOrEmpty -Verbose
$Object | IsNotNullOrEmpty -Verbose

$Object = [pscustomobject]@{ Something = Get-Date }
$Object | IsNullOrEmpty -Verbose
$Object | IsNotNullOrEmpty -Verbose
#>
