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
        New-PSCredential -UserName "Admin"

        Prompts user for password and creates a PSCredential with username "Admin" and password the user provided.

        .EXAMPLE
        $SecretPassword = "P@ssw0rd!" | ConvertTo-SecureString -Force
        New-PSCredential -UserName "Admin" -Password $SecretPassword

    #>
    [OutputType([System.Management.Automation.PSCredential])]
    [Cmdletbinding()]
    param(
        # The username of the PSCredential
        [Parameter()]
        [string] $Username = (Read-Host -Prompt 'Enter a username'),

        # The plain text password of the PSCredential
        [Parameter()]
        [SecureString] $Password = (Read-Host -Prompt 'Enter Password' -AsSecureString)
    )

    $credential = New-Object -TypeName System.Management.Automation.PSCredential($Username, $Password)

    return $credential
}
