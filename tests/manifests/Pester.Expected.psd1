@{
    RootModule        = 'Pester.psm1'
    ModuleVersion     = '5.5.0'
    GUID              = 'a699dea5-2c73-4616-a270-1f7abb777e71'
    Author            = 'Pester Team'
    CompanyName       = 'Pester'
    Copyright         = 'Copyright (c) 2021 by Pester Team, licensed under Apache 2.0 License.'
    Description       = '
Pester provides a framework for running BDD style Tests to execute and validate PowerShell
commands inside of PowerShell and offers a powerful set of Mocking Functions that allow tests to mimic and Mock
the functionality of any command inside of a piece of PowerShell code being tested. Pester tests can execute any
command or script that is accessible to a pester test file. This can include functions, Cmdlets, Modules and scripts.
Pester can be run in ad hoc style in a console or it can be integrated into the Build scripts of a Continuous Integration system.'
    PowerShellVersion = '3.0'
    TypesToProcess    = @()
    FormatsToProcess  = @()
    FunctionsToExport = @(
        'Add-ShouldOperator'
        'AfterAll'
        'AfterEach'
        'Assert-MockCalled'
        'Assert-VerifiableMock'
        'BeforeAll'
        'BeforeDiscovery'
        'BeforeEach'
        'Context'
        'ConvertTo-JUnitReport'
        'ConvertTo-NUnitReport'
        'ConvertTo-Pester4Result'
        'Describe'
        'Export-JUnitReport'
        'Export-NUnitReport'
        'Get-ShouldOperator'
        'InModuleScope'
        'Invoke-Pester'
        'It'
        'Mock'
        'New-Fixture'
        'New-MockObject'
        'New-PesterConfiguration'
        'New-PesterContainer'
        'Set-ItResult'
        'Should'
    )
    CmdletsToExport   = @(
        ''
    )
    VariablesToExport = @()
    AliasesToExport   = @(
        'Add-AssertionOperator'
        'Get-AssertionOperator'
    )
    PrivateData       = @{
        PSData                  = @{
            Tags         = @(
                'bdd'
                'Linux'
                'MacOS'
                'mocking'
                'powershell'
                'PSEdition_Core'
                'PSEdition_Desktop'
                'tdd'
                'unit_testing'
                'Windows'
            )
            LicenseUri   = 'https://www.apache.org/licenses/LICENSE-2.0.html'
            ProjectUri   = 'https://github.com/Pester/Pester'
            IconUri      = 'https://raw.githubusercontent.com/pester/Pester/main/images/pester.PNG'
            ReleaseNotes = 'https://github.com/pester/Pester/releases/tag/5.5.0'
            Prerelease   = ''
        }
        RequiredAssemblyVersion = '5.5.0'
    }
}
