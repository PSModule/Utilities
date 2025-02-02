#Requires -Modules @{ ModuleName = 'AST'; RequiredVersion = '0.2.3' }

function Set-ScriptFileRequirement {
    <#
        .SYNOPSIS
        Sets correct module requirements for PowerShell scripts, ignoring local functions, [Alias()] attributes,
        Set-Alias-based aliases, and the '.' or '&' operators in the same folder.

        .DESCRIPTION
        This function can process either a single .ps1 file or an entire folder (recursively).
        It uses two phases:

        Phase 1 (Collection):
        - Parse each file to gather local function names, [Alias("...")] attributes, and Set-Alias definitions.

        Phase 2 (Analysis):
        - Parse each file again to find commands that need external modules.
        - Skips:
          * Locally defined functions
          * Aliases that map to local functions
          * Module paths that reside in the same folder
          * Special operators '.' and '&'
        - Inserts `#Requires` lines for any truly external modules.
        - Appends `#FIX:` comments for commands that are not resolved.

        .EXAMPLE
        PS> Set-ScriptFileRequirement -Path "C:\MyScripts" -Verbose
        Recursively scans C:\MyScripts, updates #Requires lines in each .ps1 file,
        and provides verbose output.

        .EXAMPLE
        PS> Set-ScriptFileRequirement -Path "./Scripts/Deploy.ps1" -Debug
        Processes only the Deploy.ps1 file, displaying debug messages with internal
        processing details.

        .NOTES
        - Operators '.' (dot-sourcing) and '&' (call operator) are explicitly ignored,
        since they are not actual commands that map to modules.
    #>
    [CmdletBinding(SupportsShouldProcess)]
    param(
        # A path to either a single .ps1 file or a folder.
        [Parameter(Mandatory)]
        [ValidateScript({ Test-Path -Path $_ })]
        [string] $Path
    )

    # Check if folder or file
    $item = Get-Item -Path $Path
    $isDirectory = $item.PSIsContainer
    if ($isDirectory) {
        Write-Verbose "Collecting all '*.ps1' and '*.psm1' files from directory '$Path' recursively..."
        $ps1Files = Get-ChildItem -Path $Path -Include '*.ps1', '*.psm1' -File -Recurse
        $rootFolderPath = (Resolve-Path -Path $Path).ProviderPath
    } else {
        if ([IO.Path]::GetExtension($Path) -ne '.ps1') {
            Throw "Path '$Path' does not reference a .ps1 file or directory."
        }
        $ps1Files = @( $item )
        Write-Verbose "Processing single file: $Path"
        $rootFolderPath = Split-Path -Path (Resolve-Path -Path $Path).ProviderPath
    }

    Write-Verbose 'Gathering local functions and aliases from the script(s)...'
    $localFunctions = @()
    $localAliases = @()

    foreach ($file in $ps1Files) {
        Write-Verbose "Gathering info from file: [$($file.FullName)]"
        $functionName = Get-FunctionName -Path $file.FullName
        Write-Verbose " - Name: $functionName"
        $localFunctions += $functionName
        Get-FunctionAlias -Path $file.FullName | Select-Object -ExpandProperty Alias | ForEach-Object {
            $functionAlias = $_
            Write-Verbose " - Alias: $functionAlias"
            $localAliases += $functionAlias
        }
    }

    Write-Verbose 'Gathering built-in modules'
    $builtInModule = Get-Module -ListAvailable | Where-Object { $_.ModuleBase -like "$($PSHOME)\Modules*" }

    Write-Verbose 'Gathering installed modules via Get-InstalledPSResource'
    $installedResources = Get-InstalledPSResource

    Write-Verbose 'Analyzing commands in files'
    # $file = $ps1Files[6]
    foreach ($file in $ps1Files) {
        $requiredModules = @{}

        Write-Verbose "Analyzing file: [$($file.FullName)]"
        $functionNames = Get-FunctionName -Path $file.FullName
        $scriptCommands = Get-ScriptCommand -Path $file.FullName
        Write-Verbose " - Found $($scriptCommands.Count) commands"
        # $command = $scriptCommands[0]
        foreach ($command in $scriptCommands) {
            $commandName = $command.Name
            $lineNumber = $command.StartLineNumber
            Write-Verbose "   - Command: $commandName (L:$lineNumber)"

            # Skip if the command is a call to self (recursive)
            if ($functionNames -contains $commandName ) {
                Write-Verbose "     - Skipping - $commandName is a function in the file"
                continue
            }

            # Skip if it's a local function or alias
            if ($localFunctions -contains $commandName -or $localAliases -contains $commandName) {
                Write-Verbose "     - Skipping - $commandName is a local function or alias"
                continue
            }

            # Attempt external resolution
            $foundCommands = Get-Command $commandName -ErrorAction SilentlyContinue
            Write-Verbose "     - Found $($foundCommands.Count) matches"

            if ($foundCommands.Count -eq 0) {
                Write-Verbose ' - Command not found, attempting to resolve...'

                $foundSuggestions = Find-Command -Name $commandName -ErrorAction SilentlyContinue -Debug:$false -Verbose:$false
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
                    $suggestText = 'Suggestions: ' + ($moduleNamesOrdered -join ', ')
                } else {
                    $suggestText = '(No suggestions found)'
                }

                # Write a comment to the line so that it can be fixed manually
                $fileLines = Get-Content -Path $file.FullName
                $fileLines[$lineNumber] = $fileLines[$lineNumber] -replace ($fileLines[$lineNumber] | Get-LineComment)
                $fileLines[$lineNumber] = $fileLines[$lineNumber].TrimEnd()
                $comment = " #FIXME: Add requires for [$commandName] $suggestText"
                $fileLines[$newIndex] += $comment
                $fileLines | Set-Content -Path $file.FullName
            }
            # $foundCommand = $foundCommands[0]
            foreach ($foundCommand in $foundCommands) {
                Write-Verbose "     - Found command: $($foundCommand.Name) in module: $($foundCommand.ModuleName)@$($foundCommand.Version)"

                # Skip if it is a built-in module
                if ($foundCommand.ModuleName -in $builtInModule.Name) {
                    Write-Verbose "     - Skipping - $commandName is a built-in command"
                    continue
                }

                # If module is running locally, find the verison and add it to the requiredModules list
                if ($installedResources.Name -contains $foundCommand.ModuleName) {
                    $possibleVersions = $installedResources | Where-Object { $_.Name -eq $foundCommand.ModuleName } | Sort-Object Version -Descending
                    $highestVersion = $possibleVersions[0].Version.ToString()

                    Write-Debug "Found module '$($foundCommand.ModuleName)' with version '$highestVersion'"

                    # Check if module is already in requiredModules, if not add it, if it is, check if the version is higher
                    if (-not $requiredModules.ContainsKey($foundCommand.ModuleName)) {
                        $requiredModules[$foundCommand.ModuleName] = $highestVersion
                        continue
                    }

                    $existingVersion = [Version]$requiredModules[$foundCommand.ModuleName]
                    $newVersion = [Version]$highestVersion
                    if ($newVersion -gt $existingVersion) {
                        $requiredModules[$foundCommand.ModuleName] = $newVersion.ToString()
                    }
                } else {
                    Write-Debug ("Module '{0}' is inside '{1}', skipping as local." -f $foundCommand.ModuleName, $rootFolderPath)
                }
            }
        }

        # Read the content and remove lines that match "#Requires -Modules"
        $content = Get-Content $file.FullName | Where-Object { $_ -notmatch '^#Requires\s+-Modules' }

        # Remove leading and trailing empty lines
        $trimmedContent = $content -join "`n" -replace '^\s*\n+', '' -replace '\n+\s*$', '' -split "`n"

        # Write the cleaned content back to the file
        $trimmedContent | Set-Content $file.FullName

        # Build #Requires lines (alphabetically)
        $requiresToAdd = foreach ($moduleName in ($requiredModules.Keys | Sort-Object)) {
            $modVersion = $requiredModules[$moduleName]
            "#Requires -Modules @{ ModuleName = '$moduleName'; RequiredVersion = '$modVersion' }"
        }
        $requiresToAdd = @($requiresToAdd)

        $fileLines = Get-Content -Path $file.FullName
        $mergedList = [System.Collections.ArrayList]::new()

        if ($requiresToAdd.Count -gt 0) {
            Write-Debug ("Adding {0} #Requires lines to file '{1}'." -f $requiresToAdd.Count, $file.FullName)
            $mergedList.AddRange($requiresToAdd)
            $mergedList.Add('')
        }

        $mergedList.AddRange($fileLines)
        $finalLines = $mergedList

        Write-Verbose "Updating file: $($file.FullName)"
        if ($PSCmdlet.ShouldProcess('file', 'Write changes')) {
            $finalLines | Out-File -LiteralPath $file.FullName -Encoding utf8BOM
        }
    }

    Write-Verbose 'All .ps1 files processed.'
}
