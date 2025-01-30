function Set-ScriptFileRequirement {
    <#
        .SYNOPSIS
        Sets the correct module requirements for PowerShell scripts based on used commands/functions.

        .DESCRIPTION
        This function scans all .ps1 files within a specified path (recursively). It parses each script's AST to discover:
        - Which commands are used
        - Which locally defined functions exist (to avoid marking them as unresolved)
        - Which modules (from Get-InstalledPSResource) provide those commands

        It removes any existing #Requires -Module lines at the top, injects new #Requires lines (sorted alphabetically),
        and flags any commands not found locally or in installed modules with #FIX comments. For unresolved commands, it
        uses Find-Command to provide potential module suggestions inline, sorted by their published date (newest first).

        It also inserts a single blank line after the #Requires statements, removes extra leading/trailing blank lines,
        and prevents duplication or misalignment of #FIX comments.

        .EXAMPLE
        PS> Set-ScriptFileRequirement -Path "C:\MyScripts" -Verbose

        Scans C:\MyScripts, updates #Requires lines in each .ps1 file, and provides verbose output.

        .EXAMPLE
        PS> Set-ScriptFileRequirement -Path "./Scripts" -Debug

        Scans ./Scripts, displaying debug messages with internal processing details.
    #>
    [CmdletBinding(SupportsShouldProcess)]
    param(
        # Specifies the root directory to be scanned recursively for PowerShell .ps1 files.
        [Parameter(Mandatory)]
        [string]$Path
    )

    # Validate the given path
    if (-not (Test-Path -Path $Path)) {
        Throw "Path '$Path' does not exist."
    }

    Write-Verbose "Collecting all *.ps1 files from '$Path' recursively..."
    $ps1Files = Get-ChildItem -Path $Path -Filter *.ps1 -File -Recurse

    Write-Verbose 'Gathering local function names from all scripts...'
    $localFunctions = New-Object System.Collections.Generic.HashSet[string] ([System.StringComparer]::OrdinalIgnoreCase)

    foreach ($file in $ps1Files) {
        # Parse the file to locate function definitions
        $parseErrors = $null
        $tokens = $null
        $ast = [System.Management.Automation.Language.Parser]::ParseFile($file.FullName, [ref]$tokens, [ref]$parseErrors)

        if ($parseErrors) {
            Write-Verbose "Skipping function collection from '$($file.FullName)' due to parse errors."
            continue
        }

        # Find all function definitions (FunctionDefinitionAst)
        $funcDefs = $ast.FindAll({
                param($node)
                $node -is [System.Management.Automation.Language.FunctionDefinitionAst]
            }, $true)

        foreach ($fd in $funcDefs) {
            if (-not [string]::IsNullOrWhiteSpace($fd.Name)) {
                [void]$localFunctions.Add($fd.Name)
            }
        }

        Write-Debug ("File '{0}' has '{1}' local function definitions." -f $file.FullName, $funcDefs.Count)
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

    Write-Verbose 'Processing each .ps1 file to set #Requires statements and flag unresolved commands...'

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
            # Attempt to find the command in the current session
            $foundCommands = Get-Command $commandName -ErrorAction SilentlyContinue

            if ($foundCommands) {
                # If found, see if it's from an installed module
                foreach ($fc in $foundCommands) {
                    if ($fc.ModuleName -and $installedModuleLookup.ContainsKey($fc.ModuleName)) {
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
                    }
                }
            } else {
                # Not found by Get-Command in this session
                # Check if it's a local function
                if (-not $localFunctions.Contains($commandName)) {
                    # Truly unresolved, find suggestions
                    $foundSuggestions = Find-Command -Name $commandName -ErrorAction SilentlyContinue

                    if ($foundSuggestions) {
                        # Sort suggestions by PublishedDate (descending)
                        $sortedSuggestions = $foundSuggestions | Sort-Object {
                            if ($_ -and $_.PSGetModuleInfo -and $_.PSGetModuleInfo.PublishedDate) {
                                return $_.PSGetModuleInfo.PublishedDate
                            } else {
                                return [datetime]::MinValue
                            }
                        } -Descending

                        # Extract unique module names in that order
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
                # Always remove any existing #FIX comment before re-adding
                $finalLines[$newIndex] = $finalLines[$newIndex] -replace '(?i)(#FIX:\s+Unresolved module dependency.*)', ''

                # Build the updated #FIX comment
                $comment = " #FIX: Unresolved module dependency ($($unresolved.Suggestion))"

                # Append the new #FIX comment (this ensures it's always refreshed)
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
        $requiresToAdd = @($requiresToAdd)  # ensure array

        if ($requiresToAdd.Count -gt 0) {
            Write-Debug ("Adding {0} #Requires lines to file '{1}'." -f $requiresToAdd.Count, $file.FullName)

            # Prepend them plus one blank line
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

        # Write updates to file
        Write-Verbose "Updating file: $($file.FullName)"
        if ($PSCmdlet.ShouldProcess("file [$($file.FullName)]", 'Write changes')) {
            $finalLines | Out-File -LiteralPath $file.FullName -Encoding utf8BOM
        }
    }

    Write-Verbose 'All .ps1 files processed.'
}
