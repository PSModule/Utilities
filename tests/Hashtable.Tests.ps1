Describe 'Merge-Hashtable' {
    It 'Merges two hashtables' {
        $Main = [ordered]@{
            Action   = ''
            Location = 'Main'
            Mode     = 'Main'
        }
        $Override = [ordered]@{
            Action   = ''
            Location = ''
            Mode     = 'Override'
        }
        $Result = Merge-Hashtables -Main $Main -Overrides $Override

        $Result.Action | Should -Be ''
        $Result.Location | Should -Be 'Main'
        $Result.Mode | Should -Be 'Override'
    }

    It 'Merges three hashtables' {
        $Main = [ordered]@{
            Action   = ''
            Location = 'Main'
            Mode     = 'Main'
            Name     = 'Main'
        }
        $Override1 = [ordered]@{
            Action   = ''
            Location = ''
            Mode     = 'Override1'
            Name     = 'Override1'
        }
        $Override2 = [ordered]@{
            Action   = ''
            Location = ''
            Mode     = ''
            Name     = 'Override2'
        }
        $Result = Merge-Hashtables -Main $Main -Overrides $Override1, $Override2

        $Result.Action | Should -Be ''
        $Result.Location | Should -Be 'Main'
        $Result.Mode | Should -Be 'Override1'
        $Result.Name | Should -Be 'Override2'
    }
}
