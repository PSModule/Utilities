Describe 'IsNullOrEmpty' {
    It 'Returns true for $null' {
        ($null | IsNullOrEmpty -Verbose) | Should -BeTrue
    }
    It 'Returns true for empty string' {
        ('' | IsNullOrEmpty -Verbose) | Should -BeTrue
    }
    It 'Returns true for space string' {
        (' ' | IsNullOrEmpty -Verbose) | Should -BeTrue
    }
    It 'Returns true for empty here-string' {
        (@'
'@ | IsNullOrEmpty -Verbose) | Should -BeTrue
    }
    It 'Returns true for spaced here-string' {
        (@'

'@ | IsNullOrEmpty -Verbose) | Should -BeTrue
    }
    It 'Returns false for non-empty string' {
        ('test' | IsNullOrEmpty -Verbose) | Should -BeFalse
    }
    It 'Returns false for content in here-string' {
        (@'
Test
'@ | IsNullOrEmpty -Verbose) | Should -BeFalse
    }
    It 'Returns true for empty array' {
        (@() | IsNullOrEmpty -Verbose) | Should -BeTrue
    }
    It 'Returns false for non-empty array' {
        (@('test') | IsNullOrEmpty -Verbose) | Should -BeFalse
    }
    It 'Returns true for empty hashtable' {
        (@{} | IsNullOrEmpty -Verbose) | Should -BeTrue
    }
    It 'Returns false for non-empty hashtable' {
        (@{ Test = 'Test' } | IsNullOrEmpty -Verbose) | Should -BeFalse
    }
    It 'Returns true for empty PSCustomObject' {
        ([pscustomobject]@{} | IsNullOrEmpty -Verbose) | Should -BeTrue
    }
    It 'Returns false for non-empty PSCustomObject' {
        ([pscustomobject]@{ Test = 'Test' } | IsNullOrEmpty -Verbose) | Should -BeFalse
    }
}
