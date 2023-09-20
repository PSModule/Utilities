function New-PSCredential {
    <#
        .SYNOPSIS
        Creates a PSCredential

        .DESCRIPTION
        Takes in a UserName and a plain text password and creates a PSCredential

        .EXAMPLE
        New-PSCredential -UserName "Admin" -Password "P@ssw0rd!"

        This creates a PSCredential with username "Admin" and password "P@ssw0rd!"

        .EXAMPLE
        New-PSCredential -UserName "Admin" -Password (Read-Host -Prompt "Enter Password" -AsSecureString)

        This creates a PSCredential with username "Admin" and password by prompting the user for the password

        .EXAMPLE
        $SecretPassword = "P@ssw0rd!" | ConvertTo-SecureString -AsPlainText -Force
        New-PSCredential -UserName "Admin" -Password $SecretPassword

    #>
    [OutputType([System.Management.Automation.PSCredential])]
    [Cmdletbinding()]
    param(
        # The username of the PSCredential
        [Parameter(Mandatory)]
        [string] $UserName = (Read-Host -Prompt 'Enter a UserName'),

        # The plain text password of the PSCredential
        [Parameter(Mandatory)]
        [ValidateScript({ ($_ -is [System.Security.SecureString]) -or ($_ -is [System.String]) })]
        [object] $Password = (Read-Host -Prompt 'Enter Password' -AsSecureString)
    )

    try {
        if ($Password -is [System.String]) {
            $Password = $Password | ConvertTo-SecureString -AsPlainText -Force
        }
        $credential = New-Object -TypeName System.Management.Automation.PSCredential($UserName, $Password)
    } catch {
        throw $_.Exception.Message
    }
    return $credential
}
