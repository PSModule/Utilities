function IsGUID {
    [Cmdletbinding()]
    [OutputType([bool])]
    param (
        [Parameter( Mandatory = $true,
            Position = 0,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true)]
        [string] $String
    )

    [regex]$guidRegex = '(?im)^[{(]?[0-9A-F]{8}[-]?(?:[0-9A-F]{4}[-]?){3}[0-9A-F]{12}[)}]?$'

    # Check GUID against regex
    return $String -match $guidRegex
}

function Search-GUID {
    [Cmdletbinding()]
    [OutputType([guid])]
    param(
        [Parameter( Mandatory = $true,
            Position = 0,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true)]
        [string] $String
    )
    Write-Verbose "Looking for a GUID in $String"
    $GUID = $String.ToLower() |
        Select-String -Pattern '[0-9a-f]{8}\-[0-9a-f]{4}\-[0-9a-f]{4}\-[0-9a-f]{4}\-[0-9a-f]{12}' |
        Select-Object -ExpandProperty Matches |
        Select-Object -ExpandProperty Value
    Write-Verbose "Found GUID: $GUID"
    return $GUID
}

function Get-FileInfo {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string] $Path
    )

    if (-not (Test-Path -Path $Path)) {
        Write-Error 'Path does not exist' -ErrorAction Stop
    }

    $Item = Get-Item -Path $Path

    #If item is directory, fail
    if ($Item.PSIsContainer) {
        Write-Error 'Path is a directory' -ErrorAction Stop
    }

    $shell = New-Object -ComObject Shell.Application
    $shellFolder = $shell.Namespace($Item.Directory.FullName)
    $shellFile = $shellFolder.ParseName($Item.name)

    $fileDetails = New-Object pscustomobject

    foreach ($i in 0..1000) {
        $propertyName = $shellfolder.GetDetailsOf($null, $i)
        $propertyValue = $shellfolder.GetDetailsOf($shellfile, $i)
        if (-not [string]::IsNullOrEmpty($propertyValue)) {
            Write-Verbose "[$propertyName] - [$propertyValue]"
            $fileDetails | Add-Member -MemberType NoteProperty -Name $propertyName -Value $propertyValue
        }
    }
    return $fileDetails
}

function IsNullOrEmpty {
    [Cmdletbinding()]
    [OutputType([bool])]
    param(
        [Parameter( Position = 0,
            ValueFromPipeline = $true)]
        $Object
    )

    if ($PSBoundParameters.Keys.Contains('Verbose')) {
        Write-Output 'Received object:'
        $Object
        Write-Output "Length is: $($Object.Length)" -ea continue
        Write-Output "Count is: $($Object.Count)" -ea continue
        try {
            Write-Output "Enumerator: $($Object.GetEnumerator())" -ea continue
        } catch {}

        'PSObject'
        $Object.PSObject
        'PSObject  --   BaseObject'
        $Object.PSObject.BaseObject

        'PSObject  --   BaseObject  --   BaseObject'
        $Object.PSObject.BaseObject.PSObject.BaseObject

        'PSObject  --   BaseObject  --   Properties'
        $Object.PSObject.BaseObject.PSObject.Properties | Select-Object Name, @{n = 'Type'; e = { $_.TypeNameOfValue } }, Value | Format-Table -AutoSize
        'PSObject  --   Properties'
        $Object.PSObject.Properties | Select-Object Name, @{n = 'Type'; e = { $_.TypeNameOfValue } }, Value | Format-Table -AutoSize
    }

    try {
        if ($null -eq $Object) {
            Write-Verbose 'Object is null'
            return $true
        }
        if ($Object -eq 0) {
            Write-Verbose 'Object is 0'
            return $true
        }
        if ($Object.GetType() -eq [string]) {
            if ([String]::IsNullOrWhiteSpace($Object)) {
                Write-Verbose 'Object is empty string'
                return $true
            } else {
                return $false
            }
        }
        if ($Object.count -eq 0) {
            Write-Verbose 'Object count is 0'
            return $true
        }
        if (-not $Object) {
            Write-Verbose 'Object evaluates to false'
            return $true
        }

        #Evaluate Empty objects
        if (($Object.GetType().Name -ne 'pscustomobject') -or $Object.GetType() -ne [pscustomobject]) {
            Write-Verbose 'Casting object to PSCustomObject'
            $Object = [pscustomobject]$Object
        }

        if (($Object.GetType().Name -eq 'pscustomobject') -or $Object.GetType() -eq [pscustomobject]) {
            if ($Object -eq (New-Object -TypeName pscustomobject)) {
                Write-Verbose 'Object is similar to empty PSCustomObject'
                return $true
            }
            if ($Object.psobject.Properties | IsNullOrEmpty) {
                Write-Verbose 'Object has no properties'
                return $true
            }
        }
    } catch {
        Write-Verbose 'Object triggered exception'
        return $true
    }

    return $false
}

function IsNotNullOrEmpty {
    [Cmdletbinding()]
    [OutputType([bool])]
    param(
        [Parameter( Position = 0,
            ValueFromPipeline = $true)]
        $Object
    )
    return -not ($Object | IsNullOrEmpty)

    <#
'' | IsNullOrEmpty -Verbose
'' | IsNotNullOrEmpty -Verbose

' ' | IsNullOrEmpty -Verbose
' ' | IsNotNullOrEmpty -Verbose

'a' | IsNullOrEmpty -Verbose
'a' | IsNotNullOrEmpty -Verbose

@'
'@ | IsNullOrEmpty -Verbose
@'
'@ | IsNotNullOrEmpty -Verbose

@'

'@ | IsNullOrEmpty -Verbose
@'

'@ | IsNotNullOrEmpty -Verbose

@'
Test
'@ | IsNullOrEmpty -Verbose
@'
Test
'@ | IsNotNullOrEmpty -Verbose


$null | IsNullOrEmpty -Verbose
$null | IsNotNullOrEmpty -Verbose
@{} | IsNullOrEmpty -Verbose
@{} | IsNotNullOrEmpty -Verbose

@{
    Test = 'Test'
} | IsNullOrEmpty -Verbose

@{
    Test = 'Test'
} | IsNotNullOrEmpty -Verbose

@{
    Test = $null
    Null = ''
} | IsNullOrEmpty -Verbose
@{
    Test = $null
    Null = ''
} | IsNotNullOrEmpty -Verbose

$Object = [pscustomobject]@{}
$Object | IsNullOrEmpty -Verbose
$Object | IsNotNullOrEmpty -Verbose

$Object = [pscustomobject]@{ Something = Get-Date }
$Object | IsNullOrEmpty -Verbose
$Object | IsNotNullOrEmpty -Verbose
#>
}

function Merge-Hashtables {
    [CmdletBinding()]
    param (
        $Main,
        $Overrides
    )

    $Main = [Hashtable]$Main
    $Overrides = [Hashtable]$Overrides

    $Output = $Main.Clone()
    ForEach ($Key in $Overrides.Keys) {
        if (($Output.Keys) -notcontains $Key) {
            $Output.$Key = $Overrides.$Key
        }
        if ($Overrides.item($Key) | IsNotNullOrEmpty) {
            $Output.$Key = $Overrides.$Key
        }
    }
    return $Output

    <#

$env = [ordered]@{
    Action            = ''
    ResourceGroupName = 'env'
    Subscription      = 'env'
    ManagementGroupID = ''
    Location          = 'env'
    ModuleName        = ''
    ModuleVersion     = ''
}
Write-Output '`r`nEnvironment variables:'
$env

$inputs = [ordered]@{
    Action              = 'inputs'
    ResourceGroupName   = ''
    Subscription        = ''
    ManagementGroupID   = ''
    Location            = ''
    ModuleName          = 'inputs'
    ModuleVersion       = 'inputs'
    ParameterFilePath   = ''
    ParameterFolderPath = ''
    ParameterOverrides  = 'inputs'
}
Write-Output "`r`nEnvironment overrides:"
$inputs

$Params = Merge-Hashtables -Main $env -Overrides $inputs
Write-Output "`r`nFinal parameters:"
$Params
#>
}

function Set-GitHubEnv {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [string] $Name,
        [Parameter(Mandatory)]
        [string] $Value
    )
    if ($PSBoundParameters.ContainsKey('Verbose')) {
        @{ "$Name" = $Value } | Format-Table -HideTableHeaders -Wrap
    }
    Write-Output "$Name=$Value" | Out-File -FilePath $Env:GITHUB_ENV -Encoding utf8 -Append
}

function New-GitHubLogGroup {
    [CmdletBinding()]
    param (
        [Parameter()]
        [string]
        $Title
    )
    Write-Output "::group::$Title"
}

function Import-Variables {
    [CmdletBinding()]
    param (
        [Parameter(
            Mandatory,
            Position = 0,
            ValueFromPipeline = $true)]
        [string] $Path
    )
    Write-Output "$($MyInvocation.MyCommand) - $Path - Processing"
    if (-not (Test-Path -Path $Path)) {
        throw "$($MyInvocation.MyCommand) - $Path - File not found"
    }

    $Variables = Get-Content -Path $Path -Raw -Force | ConvertFrom-Json

    $NestedVariablesFilePaths = ($Variables.PSObject.Properties | Where-Object Name -EQ 'VariablesFilePaths').Value
    foreach ($NestedVariablesFilePath in $NestedVariablesFilePaths) {
        Write-Output "$($MyInvocation.MyCommand) - $Path - Nested variable files - $NestedVariablesFilePath"
        $NestedVariablesFilePath | Import-Variables
    }

    Write-Output "$($MyInvocation.MyCommand) - $Path - Loading variables"
    foreach ($Property in $Variables.PSObject.Properties) {
        if ($Property -match 'VariablesFilePaths') {
            continue
        }
        Set-GitHubEnv -Name $Property.Name -Value $Property.Value -Verbose
    }
    Write-Output "$($MyInvocation.MyCommand) - $Path - Done"
}

function ConvertTo-Boolean {
    [CmdletBinding()]
    param(
        [Parameter(
            Position = 0,
            ValueFromPipeline = $true)]
        [string] $String
    )
    switch -regex ($String.Trim()) {
        '^(1|true|yes|on|enabled)$' { $true }

        default { $false }
    }
}

<#
.SYNOPSIS
Removes empty folders under the folder specified

.DESCRIPTION
Long description

.PARAMETER Path
The path to the folder to be cleaned

.EXAMPLE
Remove-EmptyFolder -Path . -Verbose

Removes empty folders under the current path and outputs the results to the console.

#>
Function Remove-EmptyFolder {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string]
        $Path
    )

    Get-ChildItem -Path $Path -Recurse -Directory | ForEach-Object {
        if ($null -eq (Get-ChildItem $_.FullName)) {
            Write-Verbose "Removing empty folder: $_.FullName"
            Remove-Item $_.FullName -Force
        }
    }
}

Function ConvertTo-Base64String {
    param(
        # Parameter help description
        [Parameter(
            Mandatory,
            ValueFromPipeline,
            ValueFromPipelineByPropertyName)]
        [string]
        $Text
    )
    $Bytes = [System.Text.Encoding]::Unicode.GetBytes($Text)
    $EncodedText = [System.Convert]::ToBase64String($Bytes)

    #$ADOToken = [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(":$($PAT)"))

    return $EncodedText
}

Function ConvertFrom-Base64String {
    [CmdletBinding()]
    param (
        [Parameter(
            Mandatory,
            ValueFromPipeline,
            ValueFromPipelineByPropertyName)]
        [string]
        $Text
    )
    $ConvertedString = [System.Convert]::FromBase64String($Text)
    $DecodedText = [System.Text.Encoding]::Unicode.GetString($ConvertedString)
    return $DecodedText
}

function Get-MSGraphToken {
    [CmdletBinding()]
    param (
        [Parameter()]
        [string] $TenantID,
        [Parameter()]
        [string] $AppID,
        [Parameter()]
        [string] $AppSecret,
        [Parameter()]
        [string] $Scope = 'https://graph.microsoft.com/.default'
    )

    # API Reference
    # https://docs.github.com/en/rest/reference/users#get-the-authenticated-user
    $APICall = @{
        Uri         = "https://login.microsoftonline.com/$TenantID/oauth2/v2.0/token"
        Headers     = @{}
        Method      = 'POST'
        ContentType = 'application/x-www-form-urlencoded'
        Body        = @{
            'tenant'        = $TenantID
            'client_id'     = $AppID
            'scope'         = $Scope
            'client_secret' = $AppSecret
            'grant_type'    = 'client_credentials'
        }
    }
    try {
        $Response = Invoke-RestMethod @APICall
    } catch {
        throw $_
    }
    return $Response.access_token
}

function Add-EnvPath {
    param(
        [Parameter(Mandatory = $true)]
        [string] $Path,

        [ValidateSet('Machine', 'User', 'Session')]
        [string] $Container = 'Session'
    )

    if ($Container -ne 'Session') {
        $containerMapping = @{
            Machine = [EnvironmentVariableTarget]::Machine
            User    = [EnvironmentVariableTarget]::User
        }
        $containerType = $containerMapping[$Container]

        $persistedPaths = [Environment]::GetEnvironmentVariable('Path', $containerType) -split ';'
        if ($persistedPaths -notcontains $Path) {
            $persistedPaths = $persistedPaths + $Path | Where-Object { $_ }
            [Environment]::SetEnvironmentVariable('Path', $persistedPaths -join ';', $containerType)
        }
    }

    $envPaths = $env:Path -split ';'
    if ($envPaths -notcontains $Path) {
        $envPaths = $envPaths + $Path | Where-Object { $_ }
        $env:Path = $envPaths -join ';'
    }
}

function Clear-GitRepo {
    (git branch).Trim() | Where-Object { $_ -notmatch 'main|\*' } | ForEach-Object { git branch $_ -d -f }
}

<#
.SYNOPSIS
    Test if the current user is an administrator.
.DESCRIPTION
    Test if the current user is an administrator.
.OUTPUTS
    Boolean
.EXAMPLE
    Test-Administrator

    Returns true if the current user is an administrator.
#>
function Test-Administrator {
    [OutputType([Boolean])]
    $user = [Security.Principal.WindowsIdentity]::GetCurrent()
    $principal = New-Object Security.Principal.WindowsPrincipal($user)
    $isAdmin = $principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
    return $isAdmin
}

Function New-PSDynamicParameter {
    <#
.Synopsis
Create a PowerShell dynamic parameter
.Description
This command will create the code for a dynamic parameter that you can insert into your PowerShell script file.
.Link
about_Functions_Advanced_Parameters

#>

    [cmdletbinding()]
    [alias('ndp')]
    [outputtype([System.String[]])]
    Param(
        [Parameter(Position = 0, Mandatory, HelpMessage = "Enter the name of your dynamic parameter.`nThis is a required value.")]
        [ValidateNotNullOrEmpty()]
        [alias('Name')]
        [string[]]$ParameterName,
        [Parameter(Mandatory, HelpMessage = "Enter an expression that evaluates to True or False.`nThis is code that will go inside an IF statement.`nIf using variables, wrap this in single quotes.`nYou can also enter a placeholder like '`$True' and edit it later.`nThis is a required value.")]
        [ValidateNotNullOrEmpty()]
        [string]$Condition,
        [Parameter(HelpMessage = 'Is this dynamic parameter mandatory?')]
        [switch]$Mandatory,
        [Parameter(HelpMessage = 'Enter an optional default value.')]
        [object[]]$DefaultValue,
        [Parameter(HelpMessage = "Enter an optional parameter alias.`nSpecify multiple aliases separated by commas.")]
        [string[]]$Alias,
        [Parameter(HelpMessage = "Enter the parameter value type such as String or Int32.`nUse a value like string[] to indicate an array.")]
        [type]$ParameterType = 'string',
        [Parameter(HelpMessage = 'Enter an optional help message.')]
        [ValidateNotNullOrEmpty()]
        [string]$HelpMessage,
        [Parameter(HelpMessage = 'Does this dynamic parameter take pipeline input by property name?')]
        [switch]$ValueFromPipelineByPropertyName,
        [Parameter(HelpMessage = 'Enter an optional parameter set name.')]
        [ValidateNotNullOrEmpty()]
        [string]$ParameterSetName,
        [Parameter(HelpMessage = "Enter an optional comment for your dynamic parameter.`nIt will be inserted into your code as a comment.")]
        [ValidateNotNullOrEmpty()]
        [string]$Comment,
        [Parameter(HelpMessage = 'Validate that the parameter is not NULL or empty.')]
        [switch]$ValidateNotNullOrEmpty,
        [Parameter(HelpMessage = "Enter a minimum and maximum string length for this parameter value`nas an array of comma-separated set values.")]
        [ValidateNotNullOrEmpty()]
        [int[]]$ValidateLength,
        [Parameter(HelpMessage = 'Enter a set of parameter validations values')]
        [ValidateNotNullOrEmpty()]
        [object[]]$ValidateSet,
        [Parameter(HelpMessage = "Enter a set of parameter range validations values as a`ncomma-separated list from minimum to maximum")]
        [ValidateNotNullOrEmpty()]
        [int[]]$ValidateRange,
        [Parameter(HelpMessage = "Enter a set of parameter count validations values as a`ncomma-separated list from minimum to maximum")]
        [ValidateNotNullOrEmpty()]
        [int[]]$ValidateCount,
        [Parameter(HelpMessage = 'Enter a parameter validation regular expression pattern')]
        [ValidateNotNullOrEmpty()]
        [string]$ValidatePattern,
        [Parameter(HelpMessage = "Enter a parameter validation scriptblock.`nIf using the form, enter the scriptblock text.")]
        [ValidateNotNullOrEmpty()]
        [scriptblock]$ValidateScript
    )

    Begin {
        Write-Verbose "[$((Get-Date).TimeofDay) BEGIN  ] Starting $($myinvocation.mycommand)"
        $out = @"
    DynamicParam {
    $(If ($comment) { "$([char]35) $comment"})
        If ($Condition) {

        `$paramDictionary = New-Object -Type System.Management.Automation.RuntimeDefinedParameterDictionary

"@

    } #begin

    Process {
        if (-Not $($PSBoundParameters.ContainsKey('ParameterSetName'))) {
            $PSBoundParameters.Add('ParameterSetName', '__AllParameterSets')
        }

        #get validation tests
        $Validations = $PSBoundParameters.GetEnumerator().Where({ $_.key -match '^Validate' })

        #this is structured for future development where you might need to create
        #multiple dynamic parameters. This feature is incomplete at this time
        Foreach ($Name in $ParameterName) {
            Write-Verbose "[$((Get-Date).TimeofDay) PROCESS] Defining dynamic parameter $Name [$($parametertype.name)]"
            $out += "`n        # Defining parameter attributes`n"
            $out += "        `$attributeCollection = New-Object -Type System.Collections.ObjectModel.Collection[System.Attribute]`n"
            $out += "        `$attributes = New-Object System.Management.Automation.ParameterAttribute`n"
            #add attributes
            $attributeProperties = 'ParameterSetName', 'Mandatory', 'ValueFromPipeline', 'ValueFromPipelineByPropertyName', 'ValueFromRemainingArguments', 'HelpMessage'
            foreach ($item in $attributeProperties) {
                if ($PSBoundParameters.ContainsKey($item)) {
                    Write-Verbose "[$((Get-Date).TimeofDay) PROCESS] Defining $item"
                    if ( $PSBoundParameters[$item] -is [string]) {
                        $value = "'$($PSBoundParameters[$item])'"
                    } else {
                        $value = "`$$($PSBoundParameters[$item])"
                    }

                    $out += "        `$attributes.$item = $value`n"
                }
            }

            #add parameter validations
            if ($validations) {
                Write-Verbose "[$((Get-Date).TimeofDay) PROCESS] Processing validations"
                foreach ($validation in $Validations) {
                    Write-Verbose "[$((Get-Date).TimeofDay) PROCESS] ... $($validation.key)"
                    $out += "`n        # Adding $($validation.key) parameter validation`n"
                    Switch ($Validation.key) {
                        'ValidateNotNullOrEmpty' {
                            $out += "        `$v = New-Object System.Management.Automation.ValidateNotNullOrEmptyAttribute`n"
                            $out += "        `$AttributeCollection.Add(`$v)`n"
                        }
                        'ValidateLength' {
                            $out += "        `$value = @($($Validation.Value[0]),$($Validation.Value[1]))`n"
                            $out += "        `$v = New-Object System.Management.Automation.ValidateLengthAttribute(`$value)`n"
                            $out += "        `$AttributeCollection.Add(`$v)`n"
                        }
                        'ValidateSet' {
                            $join = "'$($Validation.Value -join "','")'"
                            $out += "        `$value = @($join) `n"
                            $out += "        `$v = New-Object System.Management.Automation.ValidateSetAttribute(`$value)`n"
                            $out += "        `$AttributeCollection.Add(`$v)`n"
                        }
                        'ValidateRange' {
                            $out += "        `$value = @($($Validation.Value[0]),$($Validation.Value[1]))`n"
                            $out += "        `$v = New-Object System.Management.Automation.ValidateRangeAttribute(`$value)`n"
                            $out += "        `$AttributeCollection.Add(`$v)`n"
                        }
                        'ValidatePattern' {
                            $out += "        `$value = '$($Validation.value)'`n"
                            $out += "        `$v = New-Object System.Management.Automation.ValidatePatternAttribute(`$value)`n"
                            $out += "        `$AttributeCollection.Add(`$v)`n"
                        }
                        'ValidateScript' {
                            $out += "        `$value = {$($Validation.value)}`n"
                            $out += "        `$v = New-Object System.Management.Automation.ValidateScriptAttribute(`$value)`n"
                            $out += "        `$AttributeCollection.Add(`$v)`n"
                        }
                        'ValidateCount' {
                            $out += "        `$value = @($($Validation.Value[0]),$($Validation.Value[1]))`n"
                            $out += "        `$v = New-Object System.Management.Automation.ValidateCountAttribute(`$value)`n"
                            $out += "        `$AttributeCollection.Add(`$v)`n"
                        }
                    } #close switch
                } #foreach validation
            } #validations

            $out += "        `$attributeCollection.Add(`$attributes)`n"

            if ($Alias) {
                Write-Verbose "[$((Get-Date).TimeofDay) PROCESS] Adding parameter alias $($alias -join ',')"
                Foreach ($item in $alias) {
                    $out += "`n        # Adding a parameter alias`n"
                    $out += "        `$dynalias = New-Object System.Management.Automation.AliasAttribute -ArgumentList '$Item'`n"
                    $out += "        `$attributeCollection.Add(`$dynalias)`n"
                }
            }

            $out += "`n        # Defining the runtime parameter`n"

            #handle the Switch parameter since it uses a slightly different name
            if ($ParameterType.Name -match 'Switch') {
                $paramType = 'Switch'
            } else {
                $paramType = $ParameterType.Name
            }

            $out += "        `$dynParam1 = New-Object -Type System.Management.Automation.RuntimeDefinedParameter('$Name', [$paramType], `$attributeCollection)`n"
            if ($DefaultValue) {
                Write-Verbose "[$((Get-Date).TimeofDay) PROCESS] Using default value $($DefaultValue)"
                if ( $DefaultValue[0] -is [string]) {
                    $value = "'$($DefaultValue)'"
                } else {
                    $value = "`$$($DefaultValue)"
                }
                $out += "        `$dynParam1.Value = $value`n"
            }
            $Out += @"
        `$paramDictionary.Add('$Name', `$dynParam1)


"@
        } #foreach dynamic parameter name

    }
    End {
        $out += @"
        return `$paramDictionary
    } # end if
} #end DynamicParam
"@
        $out
        Write-Verbose "[$((Get-Date).TimeofDay) END    ] Ending $($myinvocation.mycommand)"
    } #end
}

Export-ModuleMember -Function '*' -Cmdlet '*' -Alias '*' -Variable '*'
