function Get-MSGraphToken {
    [CmdletBinding()]
    param (
        [Parameter()]
        [string] $TenantID,
        [Parameter()]
        [string] $AppID,
        [Parameter()]
        [string] $AppSecret,
        [Parameter()]
        [string] $Scope = 'https://graph.microsoft.com/.default'
    )

    # API Reference
    # https://docs.github.com/en/rest/reference/users#get-the-authenticated-user
    $APICall = @{
        Uri         = "https://login.microsoftonline.com/$TenantID/oauth2/v2.0/token"
        Headers     = @{}
        Method      = 'POST'
        ContentType = 'application/x-www-form-urlencoded'
        Body        = @{
            'tenant'        = $TenantID
            'client_id'     = $AppID
            'scope'         = $Scope
            'client_secret' = $AppSecret
            'grant_type'    = 'client_credentials'
        }
    }
    try {
        $Response = Invoke-RestMethod @APICall
    } catch {
        throw $_
    }
    return $Response.access_token
}
