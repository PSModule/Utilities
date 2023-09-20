function Save-PSCredential {
    <#
        .SYNOPSIS
        Saves a PSCredential to a file.

        .DESCRIPTION
        Takes in a PSCredential and saves it to a file.

        .EXAMPLE
        $Credential = New-PSCredential -UserName "Admin" -Password "P@ssw0rd!"
        Save-PSCredential -Credential $Credential

        This saves the PSCredential to the default location of $env:HOMEPATH\.creds\Admin.cred

        .EXAMPLE
        $Credential = New-PSCredential -UserName "Admin" -Password "P@ssw0rd!"
        Save-PSCredential -Credential $Credential -Path "C:\Temp"

        This saves the PSCredential to the location of C:\Temp\Admin.cred
    #>
    [OutputType([void])]
    [CmdletBinding()]
    param(
        # The PSCredential to save.
        [Parameter(
            Mandatory,
            ValueFromPipeline
        )]
        [System.Management.Automation.PSCredential] $Credential,

        # The folder path to save the PSCredential to.
        [Parameter()]
        [string] $Path = "$env:HOMEPATH\.creds"
    )

    $fileName = "$($Credential.UserName).cred"
    $credFilePath = Join-Path -Path $Path -ChildPath $fileName
    $credFilePathExists = Test-Path $credFilePath
    if (-not $credFilePathExists) {
        try {
            $null = New-Item -ItemType File -Path $credFilePath -ErrorAction Stop -Force
        } catch {
            throw $_.Exception.Message
        }
    }
    $Credential.Password | ConvertFrom-SecureString | Out-File $credFilePath -Force
}


# $SecurePassword = ConvertTo-SecureString $PlainPassword -AsPlainText -Force
# $BSTR = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($SecurePassword)
# $UnsecurePassword = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto($BSTR)
# [Runtime.InteropServices.Marshal]::ZeroFreeBSTR($BSTR)
