function Restore-PSCredential {
    <#
        .SYNOPSIS
        Restores a PSCredential from a file.

        .DESCRIPTION
        Takes in a UserName and restores a PSCredential from a file.

        .EXAMPLE
        Restore-PSCredential -UserName "Admin"

        This restores the PSCredential from the default location of $env:HOMEPATH\.creds\Admin.cred

        .EXAMPLE
        Restore-PSCredential -UserName "Admin" -Path "C:\Temp"

        This restores the PSCredential from the location of C:\Temp\Admin.cred
    #>
    [OutputType([System.Management.Automation.PSCredential])]
    [CmdletBinding()]
    param(
        # The username of the PSCredential
        [Parameter(Mandatory)]
        [string] $UserName,

        # The folder path to restore the PSCredential from.
        [Parameter()]
        [string] $Path = "$env:HOMEPATH\.creds"
    )

    $fileName = "$UserName.cred"
    $credFilePath = Join-Path -Path $Path -ChildPath $fileName
    $credFilePathExists = Test-Path $credFilePath

    if ($credFilePathExists) {
        $secureString = Get-Content $credFilePath | ConvertTo-SecureString
        $credential = New-Object -TypeName System.Management.Automation.PSCredential($UserName, $secureString)
    } else {
        throw "Unable to locate a credential file for $($Username)"
    }
    return $credential
}
