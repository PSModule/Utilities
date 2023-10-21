function Get-TLSConfig {
    [OutputType([Net.SecurityProtocolType[]])]
    [CmdletBinding()]
    param(
        [Parameter()]
        [switch] $ListAvailable
    )
    if ($ListAvailable) {
        return [enum]::GetValues([Net.SecurityProtocolType])
    }
    return [Net.ServicePointManager]::SecurityProtocol
}
