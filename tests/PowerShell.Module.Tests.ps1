﻿Describe "Export-PowerShellDataFile" {
    It "Exports a hashtable to a .psd1 file" {
        $hashtable = @{
            Key1 = 'Value1'
            Key2 = @{
                NestedKey1 = 'NestedValue1'
                NestedKey2 = 'NestedValue2'
            }
            Key3 = @(1, 2, 3)
            Key4 = $true
        }
        $filePath = Join-Path $PSScriptRoot 'tmp.psd1'
        Export-PowerShellDataFile -Hashtable $hashtable -Path $filePath
        $test = Import-PowerShellDataFile -Path $filePath
        $test | Should -Be $hashtable
        $test.Key1 | Should -Be 'Value1'
        $test.Key2 | Should -Be @{NestedKey1 = 'NestedValue1'; NestedKey2 = 'NestedValue2'}
        $test.Key3 | Should -Be @(1, 2, 3)
        $test.Key4 | Should -Be $true
    }
    It "Can correctly read 'Pester.psd1'" {
        $originalFilePath = Join-Path $PSScriptRoot 'manifests' 'Pester.psd1'
        $tempFilePath = Join-Path $PSScriptRoot 'manifests' 'Pester.tmp.psd1'
        $hashtable = Import-PowerShellDataFile -Path $originalFilePath
        Export-PowerShellDataFile -Hashtable $hashtable -Path $tempFilePath
        $test = Import-PowerShellDataFile -Path $tempFilePath
        $test.Author | Should -Be 'Pester Team'
        $test.ModuleVersion | Should -Be '5.5.0'
        $test.AliasesToExport | Should -Contain 'Add-AssertionOperator'
        $test.FunctionsToExport | Should -Contain 'Describe'
        $test.FormatsToProcess | Should -Contain 'Pester.Format.ps1xml'
        $test.VariablesToExport | Should -Be @()
        $test.PrivateData.PSData.Category | Should -Be 'Scripting Techniques'
        $test.PrivateData.PSData.Tags | Should -Contain 'bdd'
        $test.PrivateData.RequiredAssemblyVersion | Should -Be '5.5.0'
    }
}
