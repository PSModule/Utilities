#Requires -Modules PSScriptAnalyzer

function Build-PSModuleManifest {
    <#
        .SYNOPSIS
        Compiles the module manifest.

        .DESCRIPTION
        This function will compile the module manifest.
        It will generate the module manifest file and copy it to the output folder.

        .EXAMPLE
        Build-PSModuleManifest -SourceFolderPath 'C:\MyModule\src\MyModule' -OutputFolderPath 'C:\MyModule\build\MyModule'
    #>
    [CmdletBinding()]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute(
        'PSAvoidLongLines', '',
        Justification = 'No real reason. Just to get going.'
    )]
    param(
        # Folder where the built modules are outputted. 'outputs/modules/MyModule'
        [Parameter(Mandatory)]
        [System.IO.DirectoryInfo] $ModuleOutputFolder
    )

    #region Build manifest file
    Start-LogGroup 'Build manifest file'
    $moduleName = Split-Path -Path $ModuleOutputFolder -Leaf
    $manifestFileName = "$moduleName.psd1"
    $manifestOutputPath = Join-Path -Path $ModuleOutputFolder -ChildPath $manifestFileName
    $manifestFile = Get-Item -Path $manifestOutputPath
    Write-Verbose ($manifestFile | Format-List | Out-String)
    $manifest = Get-ModuleManifest -Path $manifestFile -Verbose:$false

    $rootModule = Get-PSModuleRootModule -SourceFolderPath $ModuleOutputFolder
    $manifest.RootModule = $rootModule
    $manifest.ModuleVersion = '0.0.1'

    $manifest.Author = $manifest.Keys -contains 'Author' ? ($manifest.Author | IsNotNullOrEmpty) ? $manifest.Author : $env:GITHUB_REPOSITORY_OWNER : $env:GITHUB_REPOSITORY_OWNER
    Write-Verbose "[Author] - [$($manifest.Author)]"

    $manifest.CompanyName = $manifest.Keys -contains 'CompanyName' ? ($manifest.CompanyName | IsNotNullOrEmpty) ? $manifest.CompanyName : $env:GITHUB_REPOSITORY_OWNER : $env:GITHUB_REPOSITORY_OWNER
    Write-Verbose "[CompanyName] - [$($manifest.CompanyName)]"

    $year = Get-Date -Format 'yyyy'
    $copyRightOwner = $manifest.CompanyName -eq $manifest.Author ? $manifest.Author : "$($manifest.Author) | $($manifest.CompanyName)"
    $copyRight = "(c) $year $copyRightOwner. All rights reserved."
    $manifest.CopyRight = $manifest.Keys -contains 'CopyRight' ? -not [string]::IsNullOrEmpty($manifest.CopyRight) ? $manifest.CopyRight : $copyRight : $copyRight
    Write-Verbose "[CopyRight] - [$($manifest.CopyRight)]"

    $repoDescription = gh repo view --json description | ConvertFrom-Json | Select-Object -ExpandProperty description
    $manifest.Description = $manifest.Keys -contains 'Description' ? ($manifest.Description | IsNotNullOrEmpty) ? $manifest.Description : $repoDescription : $repoDescription
    Write-Verbose "[Description] - [$($manifest.Description)]"

    $manifest.PowerShellHostName = $manifest.Keys -contains 'PowerShellHostName' ? -not [string]::IsNullOrEmpty($manifest.PowerShellHostName) ? $manifest.PowerShellHostName : $null : $null
    Write-Verbose "[PowerShellHostName] - [$($manifest.PowerShellHostName)]"

    $manifest.PowerShellHostVersion = $manifest.Keys -contains 'PowerShellHostVersion' ? -not [string]::IsNullOrEmpty($manifest.PowerShellHostVersion) ? $manifest.PowerShellHostVersion : $null : $null
    Write-Verbose "[PowerShellHostVersion] - [$($manifest.PowerShellHostVersion)]"

    $manifest.DotNetFrameworkVersion = $manifest.Keys -contains 'DotNetFrameworkVersion' ? -not [string]::IsNullOrEmpty($manifest.DotNetFrameworkVersion) ? $manifest.DotNetFrameworkVersion : $null : $null
    Write-Verbose "[DotNetFrameworkVersion] - [$($manifest.DotNetFrameworkVersion)]"

    $manifest.ClrVersion = $manifest.Keys -contains 'ClrVersion' ? -not [string]::IsNullOrEmpty($manifest.ClrVersion) ? $manifest.ClrVersion : $null : $null
    Write-Verbose "[ClrVersion] - [$($manifest.ClrVersion)]"

    $manifest.ProcessorArchitecture = $manifest.Keys -contains 'ProcessorArchitecture' ? -not [string]::IsNullOrEmpty($manifest.ProcessorArchitecture) ? $manifest.ProcessorArchitecture : 'None' : 'None'
    Write-Verbose "[ProcessorArchitecture] - [$($manifest.ProcessorArchitecture)]"

    # Get the path separator for the current OS
    $pathSeparator = [System.IO.Path]::DirectorySeparatorChar

    Write-Verbose '[FileList]'
    $files = $ModuleOutputFolder | Get-ChildItem -File -ErrorAction SilentlyContinue | Where-Object -Property Name -NotLike '*.ps1'
    $files += $ModuleOutputFolder | Get-ChildItem -Directory | Get-ChildItem -Recurse -File -ErrorAction SilentlyContinue
    $files = $files | Select-Object -ExpandProperty FullName | ForEach-Object { $_.Replace($ModuleOutputFolder, '').TrimStart($pathSeparator) }
    $fileList = $files | Where-Object { $_ -notLike 'public*' -and $_ -notLike 'private*' }
    $manifest.FileList = $fileList.count -eq 0 ? @() : @($fileList)
    $manifest.FileList | ForEach-Object { Write-Verbose "[FileList] - [$_]" }

    Write-Verbose '[RequiredAssemblies]'
    $requiredAssembliesFolderPath = Join-Path $ModuleOutputFolder 'assemblies'
    $requiredAssemblies = Get-ChildItem -Path $RequiredAssembliesFolderPath -Recurse -File -ErrorAction SilentlyContinue -Filter '*.dll' |
        Select-Object -ExpandProperty FullName |
        ForEach-Object { $_.Replace($ModuleOutputFolder, '').TrimStart($pathSeparator) }
    $manifest.RequiredAssemblies = $requiredAssemblies.count -eq 0 ? @() : @($requiredAssemblies)
    $manifest.RequiredAssemblies | ForEach-Object { Write-Verbose "[RequiredAssemblies] - [$_]" }

    Write-Verbose '[NestedModules]'
    $nestedModulesFolderPath = Join-Path $ModuleOutputFolder 'modules'
    $nestedModules = Get-ChildItem -Path $nestedModulesFolderPath -Recurse -File -ErrorAction SilentlyContinue -Include '*.psm1', '*.ps1' |
        Select-Object -ExpandProperty FullName |
        ForEach-Object { $_.Replace($ModuleOutputFolder, '').TrimStart($pathSeparator) }
    $manifest.NestedModules = $nestedModules.count -eq 0 ? @() : @($nestedModules)
    $manifest.NestedModules | ForEach-Object { Write-Verbose "[NestedModules] - [$_]" }

    Write-Verbose '[ScriptsToProcess]'
    $allScriptsToProcess = @('scripts', 'classes') | ForEach-Object {
        Write-Verbose "[ScriptsToProcess] - Processing [$_]"
        $scriptsFolderPath = Join-Path $ModuleOutputFolder $_
        $scriptsToProcess = Get-ChildItem -Path $scriptsFolderPath -Recurse -File -ErrorAction SilentlyContinue -Include '*.ps1' |
            Select-Object -ExpandProperty FullName |
            ForEach-Object { $_.Replace($ModuleOutputFolder, '').TrimStart($pathSeparator) }
            $scriptsToProcess
        }
        $manifest.ScriptsToProcess = $allScriptsToProcess.count -eq 0 ? @() : @($allScriptsToProcess)
        $manifest.ScriptsToProcess | ForEach-Object { Write-Verbose "[ScriptsToProcess] - [$_]" }

        Write-Verbose '[TypesToProcess]'
        $typesToProcess = Get-ChildItem -Path $ModuleOutputFolder -Recurse -File -ErrorAction SilentlyContinue -Include '*.Types.ps1xml' |
            Select-Object -ExpandProperty FullName |
            ForEach-Object { $_.Replace($ModuleOutputFolder, '').TrimStart($pathSeparator) }
    $manifest.TypesToProcess = $typesToProcess.count -eq 0 ? @() : @($typesToProcess)
    $manifest.TypesToProcess | ForEach-Object { Write-Verbose "[TypesToProcess] - [$_]" }

    Write-Verbose '[FormatsToProcess]'
    $formatsToProcess = Get-ChildItem -Path $ModuleOutputFolder -Recurse -File -ErrorAction SilentlyContinue -Include '*.Format.ps1xml' |
        Select-Object -ExpandProperty FullName |
        ForEach-Object { $_.Replace($ModuleOutputFolder, '').TrimStart($pathSeparator) }
    $manifest.FormatsToProcess = $formatsToProcess.count -eq 0 ? @() : @($formatsToProcess)
    $manifest.FormatsToProcess | ForEach-Object { Write-Verbose "[FormatsToProcess] - [$_]" }

    Write-Verbose '[DscResourcesToExport]'
    $dscResourcesToExportFolderPath = Join-Path $ModuleOutputFolder 'resources'
    $dscResourcesToExport = Get-ChildItem -Path $dscResourcesToExportFolderPath -Recurse -File -ErrorAction SilentlyContinue -Include '*.psm1' |
        Select-Object -ExpandProperty FullName |
        ForEach-Object { $_.Replace($ModuleOutputFolder, '').TrimStart($pathSeparator) }
    $manifest.DscResourcesToExport = $dscResourcesToExport.count -eq 0 ? @() : @($dscResourcesToExport)
    $manifest.DscResourcesToExport | ForEach-Object { Write-Verbose "[DscResourcesToExport] - [$_]" }

    $manifest.FunctionsToExport = Get-PSModuleFunctionsToExport -SourceFolderPath $ModuleOutputFolder
    $manifest.CmdletsToExport = Get-PSModuleCmdletsToExport -SourceFolderPath $ModuleOutputFolder
    $manifest.AliasesToExport = Get-PSModuleAliasesToExport -SourceFolderPath $ModuleOutputFolder
    $manifest.VariablesToExport = Get-PSModuleVariablesToExport -SourceFolderPath $ModuleOutputFolder

    Write-Verbose '[ModuleList]'
    $moduleList = Get-ChildItem -Path $ModuleOutputFolder -Recurse -File -ErrorAction SilentlyContinue -Include '*.psm1' | Where-Object -Property Name -NE $rootModule |
        Select-Object -ExpandProperty FullName |
        ForEach-Object { $_.Replace($ModuleOutputFolder, '').TrimStart($pathSeparator) }
    $manifest.ModuleList = $moduleList.count -eq 0 ? @() : @($moduleList)
    $manifest.ModuleList | ForEach-Object { Write-Verbose "[ModuleList] - [$_]" }


    Write-Verbose '[Gather]'
    $capturedModules = @()
    $capturedVersions = @()
    $capturedPSEdition = @()

    $files = $ModuleOutputFolder | Get-ChildItem -Recurse -File -ErrorAction SilentlyContinue
    Write-Verbose "[Gather] - Processing [$($files.Count)] files"
    foreach ($file in $files) {
        $relativePath = $file.FullName.Replace($ModuleOutputFolder, '').TrimStart($pathSeparator)
        Write-Verbose "[Gather] - [$relativePath]"

        if ($file.extension -in '.psm1', '.ps1') {
            $fileContent = Get-Content -Path $file

            switch -Regex ($fileContent) {
                # RequiredModules -> REQUIRES -Modules <Module-Name> | <Hashtable>, @() if not provided
                '^\s*#Requires -Modules (.+)$' {
                    # Add captured module name to array
                    $capturedMatches = $matches[1].Split(',').trim()
                    $capturedMatches | ForEach-Object {
                        Write-Verbose " - [#Requires -Modules] - [$_]"
                        $hashtable = '\@\s*\{[^\}]*\}'
                        if ($_ -match $hashtable) {
                            $modules = ConvertTo-Hashtable -InputString $_
                            Write-Verbose " - [#Requires -Modules] - [$_] - Hashtable"
                            $modules.Keys | ForEach-Object {
                                Write-Verbose "$($modules[$_])]"
                            }
                            $capturedModules += $modules
                        } else {
                            Write-Verbose " - [#Requires -Modules] - [$_] - String"
                            $capturedModules += $_
                        }
                    }
                }
                # PowerShellVersion -> REQUIRES -Version <N>[.<n>], $null if not provided
                '^\s*#Requires -Version (.+)$' {
                    Write-Verbose " - [#Requires -Version] - [$($matches[1])]"
                    # Add captured module name to array
                    $capturedVersions += $matches[1]
                }
                #CompatiblePSEditions -> REQUIRES -PSEdition <PSEdition-Name>, $null if not provided
                '^\s*#Requires -PSEdition (.+)$' {
                    Write-Verbose " - [#Requires -PSEdition] - [$($matches[1])]"
                    # Add captured module name to array
                    $capturedPSEdition += $matches[1]
                }
            }
        }
    }

    Write-Verbose '[RequiredModules]'
    $capturedModules = $capturedModules
    $manifest.RequiredModules = $capturedModules
    $manifest.RequiredModules | ForEach-Object { Write-Verbose "[RequiredModules] - [$_]" }

    Write-Verbose '[RequiredModulesUnique]'
    $manifest.RequiredModules = $manifest.RequiredModules | Sort-Object -Unique
    $manifest.RequiredModules | ForEach-Object { Write-Verbose "[RequiredModulesUnique] - [$_]" }

    Write-Verbose '[PowerShellVersion]'
    $capturedVersions = $capturedVersions | Sort-Object -Unique -Descending
    $capturedVersions | ForEach-Object { Write-Verbose "[PowerShellVersion] - [$_]" }
    $manifest.PowerShellVersion = $capturedVersions.count -eq 0 ? [version]'7.0' : [version]($capturedVersions | Select-Object -First 1)
    Write-Verbose '[PowerShellVersion] - Selecting version'
    Write-Verbose "[PowerShellVersion] - [$($manifest.PowerShellVersion)]"

    Write-Verbose '[CompatiblePSEditions]'
    $capturedPSEdition = $capturedPSEdition | Sort-Object -Unique
    if ($capturedPSEdition.count -eq 2) {
        throw 'The module is requires both Desktop and Core editions.'
    }
    $manifest.CompatiblePSEditions = $capturedPSEdition.count -eq 0 ? @('Core', 'Desktop') : @($capturedPSEdition)
    $manifest.CompatiblePSEditions | ForEach-Object { Write-Verbose "[CompatiblePSEditions] - [$_]" }

    Write-Verbose '[PrivateData]'
    $privateData = $manifest.Keys -contains 'PrivateData' ? $null -ne $manifest.PrivateData ? $manifest.PrivateData : @{} : @{}
    if ($manifest.Keys -contains 'PrivateData') {
        $manifest.Remove('PrivateData')
    }

    Write-Verbose '[HelpInfoURI]'
    $manifest.HelpInfoURI = $privateData.Keys -contains 'HelpInfoURI' ? $null -ne $privateData.HelpInfoURI ? $privateData.HelpInfoURI : '' : ''
    Write-Verbose "[HelpInfoURI] - [$($manifest.HelpInfoURI)]"
    if ([string]::IsNullOrEmpty($manifest.HelpInfoURI)) {
        $manifest.Remove('HelpInfoURI')
    }

    Write-Verbose '[DefaultCommandPrefix]'
    $manifest.DefaultCommandPrefix = $privateData.Keys -contains 'DefaultCommandPrefix' ? $null -ne $privateData.DefaultCommandPrefix ? $privateData.DefaultCommandPrefix : '' : ''
    Write-Verbose "[DefaultCommandPrefix] - [$($manifest.DefaultCommandPrefix)]"

    $PSData = $privateData.Keys -contains 'PSData' ? $null -ne $privateData.PSData ? $privateData.PSData : @{} : @{}

    Write-Verbose '[Tags]'
    try {
        $repoLabels = gh repo view --json repositoryTopics | ConvertFrom-Json | Select-Object -ExpandProperty repositoryTopics | Select-Object -ExpandProperty name
    } catch {
        $repoLabels = @()
    }
    $manifestTags = @()
    $manifestTags = $PSData.Keys -contains 'Tags' ? ($PSData.Tags).Count -gt 0 ? $PSData.Tags : $repoLabels : $repoLabels
    # Add tags for compatability mode. https://docs.microsoft.com/en-us/powershell/scripting/developer/module/how-to-write-a-powershell-module-manifest?view=powershell-7.1#compatibility-tags
    if ($manifest.CompatiblePSEditions -contains 'Desktop') {
        if ($manifestTags -notcontains 'PSEdition_Desktop') {
            $manifestTags += 'PSEdition_Desktop'
        }
    }
    if ($manifest.CompatiblePSEditions -contains 'Core') {
        if ($manifestTags -notcontains 'PSEdition_Core') {
            $manifestTags += 'PSEdition_Core'
        }
    }
    $manifestTags | ForEach-Object { Write-Verbose "[Tags] - [$_]" }
    $manifest.Tags = $manifestTags

    if ($PSData.Tags -contains 'PSEdition_Core' -and $manifest.PowerShellVersion -lt '6.0') {
        throw "[Tags] - Cannot be PSEdition = 'Core' and PowerShellVersion < 6.0"
    }
    <#
        Windows: Packages that are compatible with the Windows Operating System
        Linux: Packages that are compatible with Linux Operating Systems
        MacOS: Packages that are compatible with the Mac Operating System
        https://learn.microsoft.com/en-us/powershell/gallery/concepts/package-manifest-affecting-ui?view=powershellget-2.x#tag-details
    #>

    Write-Verbose '[LicenseUri]'
    $licenseUri = "https://github.com/$env:GITHUB_REPOSITORY_OWNER/$env:GITHUB_REPOSITORY_NAME/blob/main/LICENSE"
    $manifest.LicenseUri = $PSData.Keys -contains 'LicenseUri' ? $null -ne $PSData.LicenseUri ? $PSData.LicenseUri : $licenseUri : $licenseUri
    Write-Verbose "[LicenseUri] - [$($manifest.LicenseUri)]"
    if ([string]::IsNullOrEmpty($manifest.LicenseUri)) {
        $manifest.Remove('LicenseUri')
    }

    Write-Verbose '[ProjectUri]'
    $projectUri = gh repo view --json url | ConvertFrom-Json | Select-Object -ExpandProperty url
    $manifest.ProjectUri = $PSData.Keys -contains 'ProjectUri' ? $null -ne $PSData.ProjectUri ? $PSData.ProjectUri : $projectUri : $projectUri
    Write-Verbose "[ProjectUri] - [$($manifest.ProjectUri)]"
    if ([string]::IsNullOrEmpty($manifest.ProjectUri)) {
        $manifest.Remove('ProjectUri')
    }

    Write-Verbose '[IconUri]'
    $iconUri = "https://raw.githubusercontent.com/$env:GITHUB_REPOSITORY_OWNER/$env:GITHUB_REPOSITORY_NAME/main/icon/icon.png"
    $manifest.IconUri = $PSData.Keys -contains 'IconUri' ? $null -ne $PSData.IconUri ? $PSData.IconUri : $iconUri : $iconUri
    Write-Verbose "[IconUri] - [$($manifest.IconUri)]"
    if ([string]::IsNullOrEmpty($manifest.IconUri)) {
        $manifest.Remove('IconUri')
    }

    Write-Verbose '[ReleaseNotes]'
    $manifest.ReleaseNotes = $PSData.Keys -contains 'ReleaseNotes' ? $null -ne $PSData.ReleaseNotes ? $PSData.ReleaseNotes : '' : ''
    Write-Verbose "[ReleaseNotes] - [$($manifest.ReleaseNotes)]"
    if ([string]::IsNullOrEmpty($manifest.ReleaseNotes)) {
        $manifest.Remove('ReleaseNotes')
    }

    Write-Verbose '[PreRelease]'
    # $manifest.PreRelease = ""
    # Is managed by the publish action

    Write-Verbose '[RequireLicenseAcceptance]'
    $manifest.RequireLicenseAcceptance = $PSData.Keys -contains 'RequireLicenseAcceptance' ? $null -ne $PSData.RequireLicenseAcceptance ? $PSData.RequireLicenseAcceptance : $false : $false
    Write-Verbose "[RequireLicenseAcceptance] - [$($manifest.RequireLicenseAcceptance)]"
    if ($manifest.RequireLicenseAcceptance -eq $false) {
        $manifest.Remove('RequireLicenseAcceptance')
    }

    Write-Verbose '[ExternalModuleDependencies]'
    $manifest.ExternalModuleDependencies = $PSData.Keys -contains 'ExternalModuleDependencies' ? $null -ne $PSData.ExternalModuleDependencies ? $PSData.ExternalModuleDependencies : @() : @()
    if (($manifest.ExternalModuleDependencies).count -eq 0) {
        $manifest.Remove('ExternalModuleDependencies')
    } else {
        $manifest.ExternalModuleDependencies | ForEach-Object { Write-Verbose "[ExternalModuleDependencies] - [$_]" }
    }

    Write-Verbose 'Creating new manifest file in outputs folder'
    $outputManifestPath = Join-Path -Path $ModuleOutputFolder $manifestFileName
    Write-Verbose "OutputManifestPath - [$outputManifestPath]"
    New-ModuleManifest -Path $outputManifestPath @manifest
    Stop-LogGroup
    #endregion Build manifest file

    #region Format manifest file
    Start-LogGroup 'Format manifest file - Before format'
    Show-FileContent -Path $outputManifestPath
    Stop-LogGroup

    Start-LogGroup 'Format manifest file - After'
    Set-ModuleManifest -Path $outputManifestPath
    Show-FileContent -Path $outputManifestPath
    Stop-LogGroup

    Start-LogGroup 'Format manifest file - Result'
    Show-FileContent -Path $outputManifestPath
    Stop-LogGroup
    #endregion Format manifest file
}
