[CmdletBinding()]
Param(
    # Path to the module to test.
    [Parameter()]
    [string] $Path
)

Describe 'Merge-Hashtable' {
    It 'Merges two hashtable' {
        $Main = @{
            Action   = ''
            Location = 'Main'
            Mode     = 'Main'
        }
        $Override = @{
            Action   = ''
            Location = ''
            Mode     = 'Override'
        }
        $Result = Merge-Hashtable -Main $Main -Overrides $Override

        $Result.Action | Should -Be ''
        $Result.Location | Should -Be 'Main'
        $Result.Mode | Should -Be 'Override'
    }

    It 'Merges three hashtable' {
        $Main = @{
            Action   = ''
            Location = 'Main'
            Mode     = 'Main'
            Name     = 'Main'
        }
        $Override1 = @{
            Action   = ''
            Location = ''
            Mode     = 'Override1'
            Name     = 'Override1'
        }
        $Override2 = @{
            Action   = ''
            Location = ''
            Mode     = ''
            Name     = 'Override2'
        }
        $Result = Merge-Hashtable -Main $Main -Overrides $Override1, $Override2

        $Result.Action | Should -Be ''
        $Result.Location | Should -Be 'Main'
        $Result.Mode | Should -Be 'Override1'
        $Result.Name | Should -Be 'Override2'
    }
}
