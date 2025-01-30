function Set-ScriptFileRequirement {
    <#
        .SYNOPSIS
        Sets the correct module requirements for PowerShell scripts based on used commands/functions,
        ignoring any local functions or aliases in the same folder.

        .DESCRIPTION
        This function can process either a single .ps1 file or an entire folder (recursively).
        It parses the script(s) to discover:
        - Which functions are defined locally
        - Which aliases (via Set-Alias) point to a locally defined function
        - Which modules (from Get-InstalledPSResource) provide commands

        It removes any existing #Requires -Module lines at the top, injects new #Requires lines (sorted alphabetically),
        and flags any commands not found locally or in installed modules with #FIX comments. For unresolved commands,
        it uses Find-Command to provide potential module suggestions inline, sorted by their published date (newest first).

        It also inserts a single blank line after the #Requires statements, removes extra leading/trailing blank lines,
        and prevents duplication or misalignment of #FIX comments.

        If a command is found in a module whose files are located inside the same folder structure being processed,
        that module is considered local and will not be added as a requirement.

        If a command name matches a local function or a local alias to a local function (possibly for self/recursive calls),
        we skip analyzing it for external requirements.

        .EXAMPLE
        PS> Set-ScriptFileRequirement -Path "C:\MyScripts" -Verbose
        Recursively scans C:\MyScripts, updates #Requires lines in each .ps1 file,
        and provides verbose output.

        .EXAMPLE
        PS> Set-ScriptFileRequirement -Path "./Scripts/Deploy.ps1" -Debug
        Processes only the Deploy.ps1 file, displaying debug messages with internal
        processing details.
    #>
    [CmdletBinding(SupportsShouldProcess)]
    param(
        # A path to either a single .ps1 file or a folder.
        # - If a file is specified, that single file is processed.
        # - If a folder is specified, all .ps1 files in it (recursively) are processed.
        [Parameter(Mandatory)]
        [string]$Path
    )

    # Validate that path exists
    if (-not (Test-Path -Path $Path)) {
        Throw "Path '$Path' does not exist."
    }

    # Decide if Path is a file or a directory
    $item = Get-Item -Path $Path
    $isDirectory = $item.PSIsContainer

    if ($isDirectory) {
        Write-Verbose "Collecting all *.ps1 files from directory '$Path' recursively..."
        $ps1Files = Get-ChildItem -Path $Path -Filter *.ps1 -File -Recurse
        # For matching subfolder paths, we'll compare full paths against $Path
        $rootFolderPath = (Resolve-Path -Path $Path).ProviderPath
    } else {
        # Assume it's a single file (validate that it's .ps1)
        if ([IO.Path]::GetExtension($Path) -ne '.ps1') {
            Throw "Path '$Path' does not reference a .ps1 file or directory."
        }
        $ps1Files = @( $item )
        Write-Verbose "Processing single file: $Path"
        # For a single file, use its directory as the "root folder" for local module checks
        $rootFolderPath = Split-Path -Path (Resolve-Path -Path $Path).ProviderPath
    }

    Write-Verbose 'Gathering local functions and aliases from the script(s)...'
    # localFunctions = set of function names
    $localFunctions = New-Object System.Collections.Generic.HashSet[string] ([System.StringComparer]::OrdinalIgnoreCase)
    # localAliases   = set of alias names that point to local functions
    $localAliases = New-Object System.Collections.Generic.HashSet[string] ([System.StringComparer]::OrdinalIgnoreCase)

    # Parse each file to discover local function definitions and alias definitions
    foreach ($file in $ps1Files) {
        $parseErrors = $null
        $tokens = $null
        $ast = [System.Management.Automation.Language.Parser]::ParseFile($file.FullName, [ref]$tokens, [ref]$parseErrors)

        if ($parseErrors) {
            Write-Verbose "Skipping function/alias collection from '$($file.FullName)' due to parse errors."
            continue
        }

        # 1) Find function definitions
        $funcDefs = $ast.FindAll({
                param($node)
                $node -is [System.Management.Automation.Language.FunctionDefinitionAst]
            }, $true)

        foreach ($fd in $funcDefs) {
            if (-not [string]::IsNullOrWhiteSpace($fd.Name)) {
                [void]$localFunctions.Add($fd.Name)
            }
        }

        # 2) Find any "Set-Alias" commands that define local aliases for local functions
        # We look for CommandAst where CommandName is 'Set-Alias'
        $aliasDefs = $ast.FindAll({
                param($node)
                if ($node -is [System.Management.Automation.Language.CommandAst]) {
                    $commandName = $node.GetCommandName()
                    return $commandName -eq 'Set-Alias'
                }
                return $false
            }, $true)

        foreach ($aliasAst in $aliasDefs) {
            # We want to parse out the -Name (or positional 1) and -Value (or positional 2) from the command’s arguments
            # Typically:  Set-Alias [-Name] <string> [[-Value] <string>]
            # We'll do a simple approach to find them:

            [string]$aliasName = $null
            [string]$targetName = $null

            $aliasParams = $aliasAst.CommandElements | Select-Object -Skip 1 # skip 'Set-Alias' itself

            # We'll parse them in pairs or detect them by name
            # For simple usage: Set-Alias MyAlias MyFunction
            #  - aliasParams[0] = 'MyAlias'
            #  - aliasParams[1] = 'MyFunction'
            # For named usage: Set-Alias -Name MyAlias -Value MyFunction
            # We'll do a quick approach to parse all elements.

            $i = 0
            while ($i -lt $aliasParams.Count) {
                $arg = $aliasParams[$i].Extent.Text

                if ($arg -like '-Name') {
                    if (($i + 1) -lt $aliasParams.Count) {
                        $aliasName = $aliasParams[$i + 1].Extent.Text
                        $i += 2
                        continue
                    }
                } elseif ($arg -like '-Value') {
                    if (($i + 1) -lt $aliasParams.Count) {
                        $targetName = $aliasParams[$i + 1].Extent.Text
                        $i += 2
                        continue
                    }
                } elseif ($arg -notmatch '^-') {
                    # positional usage
                    if (-not $aliasName) {
                        $aliasName = $arg
                    } elseif (-not $targetName) {
                        $targetName = $arg
                    }
                }
                $i++
            }

            # Now if $targetName is in localFunctions, that means $aliasName is effectively a local alias
            if ($aliasName -and $targetName -and $localFunctions.Contains($targetName)) {
                [void]$localAliases.Add($aliasName)
                Write-Debug "Found local alias '$aliasName' referencing local function '$targetName' in file '$($file.FullName)'."
            }
        }

        Write-Debug ("File '{0}' has '{1}' local function definitions and '{2}' local alias definitions." -f
            $file.FullName,
            $funcDefs.Count,
            $aliasDefs.Count)
    }

    Write-Verbose 'Gathering installed modules via Get-InstalledPSResource...'
    $installedResources = Get-InstalledPSResource

    # Build a lookup: moduleName -> all installed versions
    $installedModuleLookup = @{}
    foreach ($resource in $installedResources) {
        if (-not $installedModuleLookup.ContainsKey($resource.Name)) {
            $installedModuleLookup[$resource.Name] = @()
        }
        $installedModuleLookup[$resource.Name] += $resource
    }

    Write-Debug ('Installed modules found: {0}' -f ($installedModuleLookup.Keys -join ', '))

    # Process each .ps1 file
    foreach ($file in $ps1Files) {
        Write-Verbose "Processing file: $($file.FullName)"

        # Read original content
        $rawFileContent = Get-Content -Path $file.FullName -Raw
        $originalLines = $rawFileContent -split "`r?`n"

        # Parse AST for this script
        $parseErrors = $null
        $tokens = $null
        $ast = [System.Management.Automation.Language.Parser]::ParseFile($file.FullName, [ref]$tokens, [ref]$parseErrors)

        if ($parseErrors) {
            Write-Warning "Skipping file '$($file.FullName)' due to parse errors."
            $parseErrors | ForEach-Object { Write-Warning $_.Message }
            continue
        }

        # Gather all CommandAst nodes
        $commandAsts = $ast.FindAll({
                param($node)
                $node -is [System.Management.Automation.Language.CommandAst] -and
                $node.CommandElements.Count -gt 0
            }, $true)

        # Store unresolved commands with line+suggestions
        $unresolvedCommands = New-Object System.Collections.Generic.List[object]
        # Map moduleName -> highest version needed
        $requiredModules = @{}

        foreach ($commandAst in $commandAsts) {
            $commandName = $commandAst.CommandElements[0].Extent.Text

            # Skip if it's a local function or a local alias
            if ($localFunctions.Contains($commandName) -or $localAliases.Contains($commandName)) {
                Write-Debug ("Skipping command '{0}' because it's a local function or local alias." -f $commandName)
                continue
            }

            # Attempt to resolve in the current session
            $foundCommands = Get-Command $commandName -ErrorAction SilentlyContinue
            if ($foundCommands) {
                foreach ($fc in $foundCommands) {
                    if ($fc.ModuleName -and $installedModuleLookup.ContainsKey($fc.ModuleName)) {
                        # Check if the module path is under the same folder => skip if so
                        $isLocalModule = $false

                        if ($null -ne $fc.Module) {
                            try {
                                $modulePath = (Resolve-Path -Path $fc.Module.Path).ProviderPath
                            } catch {
                                $modulePath = $fc.Module.Path
                            }

                            if ($modulePath -and ($modulePath.ToLower() -like ($rootFolderPath.ToLower() + '*'))) {
                                $isLocalModule = $true
                            }
                        }

                        if (-not $isLocalModule) {
                            # Among all installed versions, pick the highest
                            $possibleVersions = $installedModuleLookup[$fc.ModuleName] | Sort-Object Version -Descending
                            $highestVersion = $possibleVersions[0].Version.ToString()

                            if (-not $requiredModules.ContainsKey($fc.ModuleName)) {
                                $requiredModules[$fc.ModuleName] = $highestVersion
                            } else {
                                $existingVersion = [Version]$requiredModules[$fc.ModuleName]
                                $newVersion = [Version]$highestVersion
                                if ($newVersion -gt $existingVersion) {
                                    $requiredModules[$fc.ModuleName] = $newVersion.ToString()
                                }
                            }
                        } else {
                            Write-Debug ("Skipping module '{0}' because its path '{1}' is inside '{2}'" -f
                                $fc.ModuleName,
                                $fc.Module.Path,
                                $rootFolderPath)
                        }
                    }
                }
            } else {
                # Not found => unresolved
                $foundSuggestions = Find-Command -Name $commandName -ErrorAction SilentlyContinue
                if ($foundSuggestions) {
                    $sortedSuggestions = $foundSuggestions | Sort-Object {
                        if ($_ -and $_.PSGetModuleInfo -and $_.PSGetModuleInfo.PublishedDate) {
                            return $_.PSGetModuleInfo.PublishedDate
                        } else {
                            return [datetime]::MinValue
                        }
                    } -Descending

                    $moduleNamesOrdered = New-Object System.Collections.Generic.List[string]
                    foreach ($suggestion in $sortedSuggestions) {
                        if (-not $moduleNamesOrdered.Contains($suggestion.ModuleName)) {
                            [void]$moduleNamesOrdered.Add($suggestion.ModuleName)
                        }
                    }
                    $suggestText = 'Possible module(s), newest first: ' + ($moduleNamesOrdered -join ', ')
                } else {
                    $suggestText = 'No module found via Find-Command'
                }

                $unresolvedCommands.Add([PSCustomObject]@{
                        LineNumber  = $commandAst.Extent.StartLineNumber
                        CommandName = $commandName
                        Suggestion  = $suggestText
                    })
            }
        }

        Write-Debug ("File '{0}' requires '{1}' modules; has '{2}' unresolved commands." -f
            $file.FullName,
            $requiredModules.Keys.Count,
            $unresolvedCommands.Count)

        # Create a modifiable array list of lines
        $finalLines = [System.Collections.ArrayList]@($originalLines)

        # Remove top #Requires -Module lines, then leading blank lines
        $topRemoved = 0
        while ($finalLines.Count -gt 0 -and $finalLines[0] -match '^\s*#Requires\s+-Module') {
            $finalLines.RemoveAt(0)
            $topRemoved++
        }
        while ($finalLines.Count -gt 0 -and [string]::IsNullOrWhiteSpace($finalLines[0])) {
            $finalLines.RemoveAt(0)
            $topRemoved++
        }

        # Insert or update #FIX comments for unresolved commands
        foreach ($unresolved in $unresolvedCommands) {
            $newIndex = ($unresolved.LineNumber - 1) - $topRemoved
            if (($newIndex -ge 0) -and ($newIndex -lt $finalLines.Count)) {
                # Remove any existing #FIX before appending new
                $finalLines[$newIndex] = $finalLines[$newIndex] -replace '(?i)(#FIX:\s+Unresolved module dependency.*)', ''
                $comment = " #FIX: Unresolved module dependency ($($unresolved.Suggestion))"
                $finalLines[$newIndex] += $comment
            } else {
                Write-Debug ("Unresolved command '{0}' at line '{1}' was removed or out-of-range." -f
                    $unresolved.CommandName,
                    $unresolved.LineNumber)
            }
        }

        # Build #Requires lines (alphabetically by module name)
        $requiresToAdd = foreach ($moduleName in ($requiredModules.Keys | Sort-Object)) {
            $modVersion = $requiredModules[$moduleName]
            "#Requires -Modules @{ ModuleName = '$moduleName'; ModuleVersion = '$modVersion' }"
        }
        $requiresToAdd = @($requiresToAdd)

        if ($requiresToAdd.Count -gt 0) {
            Write-Debug ("Adding {0} #Requires lines to file '{1}'." -f $requiresToAdd.Count, $file.FullName)
            $mergedList = [System.Collections.ArrayList]::new()
            $mergedList.AddRange($requiresToAdd)
            $mergedList.Add('')
            $mergedList.AddRange($finalLines)
            $finalLines = $mergedList
        }

        # Remove trailing blank lines
        while ($finalLines.Count -gt 0 -and [string]::IsNullOrWhiteSpace($finalLines[$finalLines.Count - 1])) {
            $finalLines.RemoveAt($finalLines.Count - 1)
        }

        Write-Verbose "Updating file: $($file.FullName)"
        if ($PSCmdlet.ShouldProcess("file [$($file.FullName)]", 'Write changes')) {
            $finalLines | Out-File -LiteralPath $file.FullName -Encoding utf8BOM
        }
    }

    Write-Verbose 'All .ps1 files processed.'
}
