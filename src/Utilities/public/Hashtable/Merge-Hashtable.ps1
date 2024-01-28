function Merge-Hashtable {
    <#
        .SYNOPSIS
        Merge two hashtables, with the second hashtable overriding the first

        .DESCRIPTION
        Merge two hashtables, with the second hashtable overriding the first

        .EXAMPLE
        $Main = [ordered]@{
            Action            = ''
            ResourceGroupName = 'Main'
            Subscription      = 'Main'
            ManagementGroupID = ''
            Location          = 'Main'
            ModuleName        = ''
            ModuleVersion     = ''
        }
        $Overrides = [ordered]@{
            Action            = 'overrides'
            ResourceGroupName = 'overrides'
            Subscription      = 'overrides'
            ManagementGroupID = ''
            Location          = 'overrides'
            ModuleName        = ''
            ModuleVersion     = ''
        }
        Merge-Hashtables -Main $Main -Overrides $Overrides
    #>
    [OutputType([Hashtable])]
    [Alias('Merge-Hashtables')]
    [CmdletBinding()]
    param (
        # Main hashtable
        [Parameter(Mandatory)]
        [hashtable] $Main,

        # Hashtable with overrides
        [Parameter(Mandatory)]
        [hashtable] $Overrides
    )
    $Output = $Main.Clone()
    foreach ($Key in $Overrides.Keys) {
        if (($Output.Keys) -notcontains $Key) {
            $Output.$Key = $Overrides.$Key
        }
        if ($Overrides.item($Key) | IsNotNullOrEmpty) {
            $Output.$Key = $Overrides.$Key
        }
    }
    return $Output
}
