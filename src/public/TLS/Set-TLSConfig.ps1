function Set-TLSConfig {
    <#
        .SYNOPSIS
        Set the TLS configuration for the current PowerShell session

        .DESCRIPTION
        Set the TLS configuration for the current PowerShell session

        .EXAMPLE
        Set-TLSConfig -Protocol Tls12

        Set the TLS configuration for the current PowerShell session to TLS 1.2
    #>
    [OutputType([void])]
    [CmdletBinding(SupportsShouldProcess)]
    param(
        # The TLS protocol to enable
        [Parameter()]
        [Net.SecurityProtocolType[]] $Protocol = [Net.SecurityProtocolType]::Tls12
    )

    foreach ($protocolItem in $Protocol) {
        Write-Verbose "Enabling $protocolItem"
        if ($PSCmdlet.ShouldProcess("Security Protocol to [$Protocol]", "Set")) {
            [Net.ServicePointManager]::SecurityProtocol = [Net.ServicePointManager]::SecurityProtocol -bor $protocolItem
        }
    }
}
