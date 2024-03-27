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
    It "Can correctly read 'Pester.psd1'" {
        $originalFilePath = Join-Path -Path $PSScriptRoot -ChildPath 'manifests/Pester.psd1'
        $tempFilePath = Join-Path -Path $PSScriptRoot -ChildPath 'manifests' 'Pester.tmp.psd1'
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

Describe 'Set-ModuleManifest' {
    It 'Sets the module manifest' {
        $originalFilePath = Join-Path -Path $PSScriptRoot 'manifests/Pester.psd1'
        $tempFilePath = Join-Path -Path $PSScriptRoot 'manifests/Pester.tmp.psd1'
        Copy-Item -Path $originalFilePath -Destination $tempFilePath -Force
        Set-ModuleManifest -Path $tempFilePath -RootModule 'Pester.psm1' -ModuleVersion '10.0.0'
        $tempManifest = Import-PowerShellDataFile -Path $tempFilePath
        $tempManifest.PrivateData.PSData.ProjectUri | Should -Be 'https://github.com/Pester/Pester'
    }
}
