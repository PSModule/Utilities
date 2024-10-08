function Merge-Hashtable {
    <#
        .SYNOPSIS
        Merge two hashtables, with the second hashtable overriding the first

        .DESCRIPTION
        Merge two hashtables, with the second hashtable overriding the first

        .EXAMPLE
        $Main = [ordered]@{
            Action   = ''
            Location = 'Main'
            Name     = 'Main'
            Mode     = 'Main'
        }
        $Override1 = [ordered]@{
            Action   = ''
            Location = ''
            Name     = 'Override1'
            Mode     = 'Override1'
        }
        $Override2 = [ordered]@{
            Action   = ''
            Location = ''
            Name     = 'Override1'
            Mode     = 'Override2'
        }
        Merge-Hashtables -Main $Main -Overrides $Override1, $Override2
    #>
    [OutputType([Hashtable])]
    [Alias('Merge-Hashtables')]
    [CmdletBinding()]
    param (
        # Main hashtable
        [Parameter(Mandatory)]
        [object] $Main,

        # Hashtable with overrides.
        # Providing a list of overrides will apply them in order.
        # Last write wins.
        [Parameter(Mandatory)]
        [object[]] $Overrides
    )
    $Output = $Main.Clone()
    foreach ($Override in $Overrides) {
        foreach ($Key in $Override.Keys) {
            if (($Output.Keys) -notcontains $Key) {
                $Output.$Key = $Override.$Key
            }
            if ($Override.item($Key) | IsNotNullOrEmpty) {
                $Output.$Key = $Override.$Key
            }
        }
    }
    return $Output
}
