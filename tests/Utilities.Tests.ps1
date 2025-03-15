[Diagnostics.CodeAnalysis.SuppressMessageAttribute(
    'PSAvoidUsingConvertToSecureStringWithPlainText', '', Justification = 'Test code only'
)]
[CmdletBinding()]
param()

Describe 'Utilities' {
    Describe 'Function: IsNullOrEmpty' {
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
            $manifest.FunctionsToExport[0] | Should -Be 'Add-ShouldOperator'
            $manifest.PrivateData.PSData.Tags[0] | Should -Be 'Linux'
            $manifest.PrivateData.PSData.ProjectUri | Should -Be 'https://github.com/Pester/Pester'
        }
    }
}
