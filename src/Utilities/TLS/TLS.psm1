using namespace System.Net

function Enable-TLS {
    [CmdletBinding()]
    param(
        [Parameter()]
        [Net.SecurityProtocolType[]] $Protocol = [Net.SecurityProtocolType]::Tls12
    )
    foreach ($protocolItem in $Protocol) {
        Write-Verbose "Enabling $protocolItem"
        [Net.ServicePointManager]::SecurityProtocol = [Net.ServicePointManager]::SecurityProtocol -bor $protocolItem
    }
}

function Get-TLS {
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
