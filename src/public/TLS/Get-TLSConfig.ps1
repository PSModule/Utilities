﻿function Get-TLSConfig {
    <#
        .SYNOPSIS
        Get the TLS configuration of the current session

        .DESCRIPTION
        Get the TLS configuration of the current session

        .EXAMPLE
        Get-TLSConfig

        Gets the TLS configuration of the current session

        .EXAMPLE
        Get-TLSConfig -ListAvailable

        Gets the available TLS configurations
    #>
    [OutputType(ParameterSetName = 'Default', [System.Net.SecurityProtocolType])]
    [OutputType(ParameterSetName = 'ListAvailable', [Array])]
    [CmdletBinding(DefaultParameterSetName = 'Default')]
    param(
        # List available TLS configurations
        [Parameter(ParameterSetName = 'ListAvailable')]
        [switch] $ListAvailable
    )
    if ($ListAvailable) {
        return [enum]::GetValues([System.Net.SecurityProtocolType])
    }
    return [System.Net.ServicePointManager]::SecurityProtocol
}
