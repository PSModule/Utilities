
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
