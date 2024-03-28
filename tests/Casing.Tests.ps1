[CmdletBinding()]
Param(
    # Path to the module to test.
    [Parameter()]
    [string] $Path
)

Describe 'Get-StringCasingStyle' {
    It "Detects 'testtesttest' as lowercase" {
        'testtesttest' | Get-StringCasingStyle | Should -Be 'lowercase'
    }

    It "Detects 'TESTTESTTEST' as UPPERCASE" {
        'TESTTESTTEST' | Get-StringCasingStyle | Should -Be 'UPPERCASE'
    }

    It "Detects 'Testtesttest' as Sentencecase" {
        'Testtesttest' | Get-StringCasingStyle | Should -Be 'Sentencecase'
    }

    It "Detects 'TestTestTest' as PascalCase" {
        'TestTestTest' | Get-StringCasingStyle | Should -Be 'PascalCase'
    }

    It "Detects 'testTestTest' as camelCase" {
        'testTestTest' | Get-StringCasingStyle | Should -Be 'camelCase'
    }

    It "Detects 'test-test-test' as kebab-case" {
        'test-test-test' | Get-StringCasingStyle | Should -Be 'kebab-case'
    }

    It "Detects 'TEST-TEST-TEST' as UPPER-KEBAB-CASE" {
        'TEST-TEST-TEST' | Get-StringCasingStyle | Should -Be 'UPPER-KEBAB-CASE'
    }

    It "Detects 'test_test_test' as snake_case" {
        'test_test_test' | Get-StringCasingStyle | Should -Be 'snake_case'
    }

    It "Detects 'TEST_TEST_TEST' as UPPER_SNAKE_CASE" {
        'TEST_TEST_TEST' | Get-StringCasingStyle | Should -Be 'UPPER_SNAKE_CASE'
    }

    It "Detects 'Test Test Test' as Title Case" {
        'Test Test Test' | Get-StringCasingStyle | Should -Be 'Title Case'
    }

    It "Detects 'Test_teSt-Test' as Unknown" {
        'Test_teSt-Test' | Get-StringCasingStyle | Should -Be 'Unknown'
    }

    It "Detects 'Test-Test_test' as Unknown" {
        'Test-Test_test' | Get-StringCasingStyle | Should -Be 'Unknown'
    }

    It "Detects 'ThisIsAMultiWordPascalString' as PascalCase" {
        'ThisIsAMultiWordPascalString' | Get-StringCasingStyle | Should -Be 'PascalCase'
    }

    It "Detects 'T' as UPPERCASE" {
        'T' | Get-StringCasingStyle | Should -Be 'UPPERCASE'
    }

    It "Detects 'TTTT' UPPERCASE" {
        'TTTT' | Get-StringCasingStyle | Should -Be 'UPPERCASE'
    }

    It "Detects 't' as lowercase" {
        't' | Get-StringCasingStyle | Should -Be 'lowercase'
    }

    It "Detects 'tttt' as lowercase" {
        'tttt' | Get-StringCasingStyle | Should -Be 'lowercase'
    }

    It "Detects 'tT' as camelCase" {
        'tT' | Get-StringCasingStyle | Should -Be 'camelCase'
    }

    It "Detects 't-t' as kebab-case" {
        't-t' | Get-StringCasingStyle | Should -Be 'kebab-case'
    }

    It "Detects 'T-T' as UPPER-KEBAB-CASE" {
        'T-T' | Get-StringCasingStyle | Should -Be 'UPPER-KEBAB-CASE'
    }

    It "Detects 't_t' as snake_case" {
        't_t' | Get-StringCasingStyle | Should -Be 'snake_case'
    }
}
