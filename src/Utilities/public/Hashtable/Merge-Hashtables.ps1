function Merge-Hashtables {
    [CmdletBinding()]
    param (
        $Main,
        $Overrides
    )

    $Main = [Hashtable]$Main
    $Overrides = [Hashtable]$Overrides

    $Output = $Main.Clone()
    ForEach ($Key in $Overrides.Keys) {
        if (($Output.Keys) -notcontains $Key) {
            $Output.$Key = $Overrides.$Key
        }
        if ($Overrides.item($Key) | IsNotNullOrEmpty) {
            $Output.$Key = $Overrides.$Key
        }
    }
    return $Output

    <#

$env = [ordered]@{
    Action            = ''
    ResourceGroupName = 'env'
    Subscription      = 'env'
    ManagementGroupID = ''
    Location          = 'env'
    ModuleName        = ''
    ModuleVersion     = ''
}
Write-Output '`r`nEnvironment variables:'
$env

$inputs = [ordered]@{
    Action              = 'inputs'
    ResourceGroupName   = ''
    Subscription        = ''
    ManagementGroupID   = ''
    Location            = ''
    ModuleName          = 'inputs'
    ModuleVersion       = 'inputs'
    ParameterFilePath   = ''
    ParameterFolderPath = ''
    ParameterOverrides  = 'inputs'
}
Write-Output "`r`nEnvironment overrides:"
$inputs

$Params = Merge-Hashtables -Main $env -Overrides $inputs
Write-Output "`r`nFinal parameters:"
$Params
#>
}
