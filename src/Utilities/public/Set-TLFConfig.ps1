function Set-TLSConfig {
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
