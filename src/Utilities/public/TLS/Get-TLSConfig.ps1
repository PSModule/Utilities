function Get-TLSConfig {
    [OutputType(ParameterSetName = 'Default',[Net.SecurityProtocolType])]
    [OutputType(ParameterSetName = 'ListAvailable',[Array])]
    [CmdletBinding(DefaultParameterSetName = 'Default')]
    param(
        [Parameter(ParameterSetName = 'ListAvailable')]
        [switch] $ListAvailable
    )
    if ($ListAvailable) {
        return [enum]::GetValues([Net.SecurityProtocolType])
    }
    return [Net.ServicePointManager]::SecurityProtocol
}
