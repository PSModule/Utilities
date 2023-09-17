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
