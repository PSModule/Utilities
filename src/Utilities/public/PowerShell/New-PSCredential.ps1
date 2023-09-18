Function New-PSCredential {
    <#
.SYNOPSIS
Creates a PSCredential

.DESCRIPTION
Takes in a ID and a plain text password and creates a PSCredential

.PARAMETER ID
The ID or username of the PSCredential

.PARAMETER Secret
The plain text password of the PSCredential

.EXAMPLE
New-PSCredential -ID "Admin" -Secret "P@ssw0rd!"

This creates a PSCredential with username "Admin" and password "P@ssw0rd!"

#>
    [Cmdletbinding()]
    [OutputType([System.Management.Automation.PSCredential])]
    param(
        [Parameter(Mandatory)]
        [String]
        $ID,
        [Parameter(Mandatory)]
        [String]
        $Secret
    )
    Try {
        $PW = $Secret | ConvertTo-SecureString -AsPlainText -Force
        $Credential = New-Object -TypeName System.Management.Automation.PSCredential($ID, $PW)
    } Catch {
        Write-Error 'Something went wrong when creating a PSCredential'
    }
    return $Credential
}
