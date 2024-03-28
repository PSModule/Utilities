[Diagnostics.CodeAnalysis.SuppressMessageAttribute(
    'PSAvoidUsingConvertToSecureStringWithPlainText', '', Justification = 'Test code only'
)]
[CmdletBinding()]
Param(
    # Path to the module to test.
    [Parameter()]
    [string] $Path
)

Write-Verbose "Path to the module: [$Path]" -Verbose

Describe 'Utilities' {
    Context 'Module' {
        It 'The module should be available' {
            Get-Module -Name 'Utilities' -ListAvailable | Should -Not -BeNullOrEmpty
            Write-Verbose (Get-Module -Name 'Utilities' -ListAvailable | Out-String) -Verbose
        }
        It 'The module should be importable' {
            { Import-Module -Name 'Utilities' -Verbose -RequiredVersion 999.0.0 -Force } | Should -Not -Throw
        }
    }
}

Describe 'Join-URI' {
    It "Join-Uri -Path 'https://example.com' -ChildPath 'foo' -AdditionalChildPath 'bar'" {
        $uri = Join-Uri -Path 'https://example.com' -ChildPath 'foo' -AdditionalChildPath 'bar'
        Write-Verbose $uri -Verbose
        Write-Verbose "Should -Be 'https://example.com/foo/bar'" -Verbose
        $uri | Should -Be 'https://example.com/foo/bar'
    }

    It "Join-Uri 'https://example.com/foo' '/bar/' '//baz/something/' '/test/'" {
        $uri = Join-Uri 'https://example.com/foo' '/bar/' '//baz/something/' '/test/'
        Write-Verbose $uri -Verbose
        Write-Verbose "Should -Be 'https://example.com/foo/bar/baz/something/test'" -Verbose
        $uri | Should -Be 'https://example.com/foo/bar/baz/something/test'
    }
}


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
    It 'Returns true for empty string in an array' {
        (@('') | IsNullOrEmpty -Verbose) | Should -BeTrue
    }
    It 'Returns true for empty array' {
        (IsNullOrEmpty -Object @() -Verbose) | Should -BeTrue
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

Describe 'Export-PowerShellDataFile' {
    It 'Exports a hashtable to a .psd1 file' {
        $hashtable = @{
            Key1 = 'Value1'
            Key2 = @{
                NestedKey1 = 'NestedValue1'
                NestedKey2 = 'NestedValue2'
            }
            Key3 = @(1, 2, 3)
            Key4 = $true
        }
        $filePath = Join-Path -Path $PSScriptRoot -ChildPath 'tmp.psd1'
        Export-PowerShellDataFile -Hashtable $hashtable -Path $filePath
        $test = Import-PowerShellDataFile -Path $filePath
        $test.Key1 | Should -Be 'Value1'
        $test.Key2.NestedKey1 | Should -Be 'NestedValue1'
        $test.Key2.NestedKey2 | Should -Be 'NestedValue2'
        $test.Key3 | Should -Be @(1, 2, 3)
        $test.Key4 | Should -Be $true
    }
    It "Can correctly read 'Pester.psd1' after importing and exporting it" {
        $originalFilePath = Join-Path -Path $PSScriptRoot -ChildPath 'manifests/Pester.psd1'
        $tempFilePath = Join-Path -Path $PSScriptRoot -ChildPath 'manifests/Pester.tmp.psd1'
        $hashtable = Import-PowerShellDataFile -Path $originalFilePath
        Export-PowerShellDataFile -Hashtable $hashtable -Path $tempFilePath
        Write-Verbose (Get-Content -Path $tempFilePath | Out-String) -Verbose
        $test = Import-PowerShellDataFile -Path $tempFilePath
        $test.RootModule | Should -Be 'Pester.psm1'
        $test.ModuleVersion | Should -Be '5.5.0'
        $test.GUID | Should -Be 'a699dea5-2c73-4616-a270-1f7abb777e71'
        $test.Author | Should -Be 'Pester Team'
        $test.CompanyName | Should -Be 'Pester'
        $test.CopyRight | Should -Be 'Copyright (c) 2021 by Pester Team, licensed under Apache 2.0 License.'
        $test.PowerShellVersion | Should -Be '3.0'
        $test.TypesToProcess | Should -Be @()
        $test.FormatsToProcess | Should -Be @()
        $test.AliasesToExport | Should -Contain 'Add-AssertionOperator'
        $test.FunctionsToExport | Should -Contain 'Describe'
        $test.CmdletsToExport | Should -Be ''
        $test.VariablesToExport | Should -Be @()
        $test.FormatsToProcess | Should -Be @()
        $test.PrivateData.PSData.Category | Should -Be 'Scripting Techniques'
        $test.PrivateData.PSData.Tags | Should -Contain 'bdd'
        $test.PrivateData.PSData.IconUri | Should -Be 'https://raw.githubusercontent.com/pester/Pester/main/images/pester.PNG'
        $test.PrivateData.PSData.ProjectUri | Should -Be 'https://github.com/Pester/Pester'
        $test.PrivateData.PSData.LicenseUri | Should -Be 'https://www.apache.org/licenses/LICENSE-2.0.html'
        $test.PrivateData.PSData.ReleaseNotes | Should -Be 'https://github.com/pester/Pester/releases/tag/5.5.0'
        $test.PrivateData.PSData.preRelease | Should -Be ''
        $test.PrivateData.RequiredAssemblyVersion | Should -Be '5.5.0'
    }
}

Describe 'Set-ModuleManifest' {
    It 'Sets the module manifest' {
        $filePath = Join-Path -Path $PSScriptRoot 'manifests/Pester.psd1'
        Set-ModuleManifest -Path $filePath -RootModule 'Pester.psm1' -ModuleVersion '10.0.0'
        $manifest = Import-PowerShellDataFile -Path $filePath
        Write-Verbose (Get-Content -Path $filePath | Out-String) -Verbose
        $manifest.PrivateData.PSData.ProjectUri | Should -Be 'https://github.com/Pester/Pester'
    }
}

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

Describe 'Search-GUID' {
    It 'Should return a GUID' {
        $GUID = '123e4567-e89b-12d3-a456-426655440000' | Search-GUID
        $GUID | Should -Be '123e4567-e89b-12d3-a456-426655440000'
    }
}

Describe 'Test-GUID' {
    It 'Should return a GUID' {
        $GUID = '123e4567-e89b-12d3-a456-426655440000' | Test-IsGUID
        $guid | Should -BeTrue
    }
}


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
