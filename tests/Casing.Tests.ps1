# Save the function Get-StringCasingStyle in a file named Get-StringCasingStyle.ps1
# Then dot-source the file to load the function into the current session
. .\Get-StringCasingStyle.ps1

# Define the Pester tests
Describe 'Get-StringCasingStyle' {
    It 'Detects lowercase' {
        'testtesttest' | Get-StringCasingStyle | Should -Be 'lowercase'
    }

    It 'Detects UPPERCASE' {
        'TESTTESTTEST' | Get-StringCasingStyle | Should -Be 'UPPERCASE'
    }

    It 'Detects Sentencecase' {
        'Testtesttest' | Get-StringCasingStyle | Should -Be 'Sentencecase'
    }

    It 'Detects PascalCase' {
        'TestTestTest' | Get-StringCasingStyle | Should -Be 'PascalCase'
    }

    It 'Detects camelCase' {
        'testTestTest' | Get-StringCasingStyle | Should -Be 'camelCase'
    }

    It 'Detects kebab-case' {
        'test-test-test' | Get-StringCasingStyle | Should -Be 'kebab-case'
    }

    It 'Detects UPPER-KEBAB-CASE' {
        'TEST-TEST-TEST' | Get-StringCasingStyle | Should -Be 'UPPER-KEBAB-CASE'
    }

    It 'Detects snake_case' {
        'test_test_test' | Get-StringCasingStyle | Should -Be 'snake_case'
    }

    It 'Detects UPPER_SNAKE_CASE' {
        'TEST_TEST_TEST' | Get-StringCasingStyle | Should -Be 'UPPER_SNAKE_CASE'
    }

    It 'Detects Title Case' {
        'Test Test Test' | Get-StringCasingStyle | Should -Be 'Title Case'
    }

    It 'Detects Unknown for mixed cases 1' {
        'Test_teSt-Test' | Get-StringCasingStyle | Should -Be 'Unknown'
    }

    It 'Detects Unknown for mixed cases 2' {
        'Test-Test_test' | Get-StringCasingStyle | Should -Be 'Unknown'
    }

    It 'Detects PascalCase for multiple words' {
        'ThisIsAMultiWordPascalString' | Get-StringCasingStyle | Should -Be 'PascalCase'
    }

    It 'Detects Sentencecase for single uppercase letter' {
        'T' | Get-StringCasingStyle | Should -Be 'Sentencecase'
    }

    It 'Detects UPPERCASE for single uppercase letter repeated' {
        'TTTT' | Get-StringCasingStyle | Should -Be 'UPPERCASE'
    }

    It 'Detects lowercase for single lowercase letter' {
        't' | Get-StringCasingStyle | Should -Be 'lowercase'
    }

    It 'Detects lowercase for single lowercase letter repeated' {
        'tttt' | Get-StringCasingStyle | Should -Be 'lowercase'
    }

    It 'Detects camelCase for short string' {
        'tT' | Get-StringCasingStyle | Should -Be 'camelCase'
    }

    It 'Detects kebab-case for short string' {
        't-t' | Get-StringCasingStyle | Should -Be 'kebab-case'
    }

    It 'Detects UPPER-KEBAB-CASE for short string' {
        'T-T' | Get-StringCasingStyle | Should -Be 'UPPER-KEBAB-CASE'
    }

    It 'Detects snake_case for short string' {
        't_t' | Get-StringCasingStyle | Should -Be 'snake_case'
    }
}
