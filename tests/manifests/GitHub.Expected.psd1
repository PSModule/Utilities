﻿@{
    RootModule            = 'GitHub.psm1'
    ModuleVersion         = '0.15.5'
    CompatiblePSEditions  = @(
        'Core'
        'Desktop'
    )
    GUID                  = 'd32d0c65-f7fb-46d6-b18d-8b815b0b65db'
    Author                = 'PSModule'
    CompanyName           = 'PSModule'
    Copyright             = '(c) 2025 PSModule. All rights reserved.'
    Description           = 'A PowerShell module to interact with GitHub, both interactively and via automation.'
    PowerShellVersion     = '5.1'
    ProcessorArchitecture = 'None'
    RequiredModules       = @(
        @{
            ModuleName      = 'CasingStyle'
            RequiredVersion = '1.0.2'
        }
        'Context'
        @{
            ModuleName      = 'DynamicParams'
            RequiredVersion = '1.1.8'
        }
        @{
            ModuleName      = 'Hashtable'
            RequiredVersion = '1.1.5'
        }
        @{
            ModuleName      = 'Uri'
            RequiredVersion = '1.1.0'
        }
    )
    TypesToProcess        = @()
    FormatsToProcess      = @(
        'formats/GitHubContext.Format.ps1xml'
        'formats/GitHubWebhook.Format.ps1xml'
        'formats/GitHubWebhookRedelivery.Format.ps1xml'
    )
    FunctionsToExport     = @(
        'Add-GitHubAppInstallationRepositoryAccess'
        'Add-GitHubMask'
        'Add-GitHubReleaseAsset'
        'Add-GitHubSystemPath'
        'Add-GitHubUserEmail'
        'Add-GitHubUserFollowing'
        'Add-GitHubUserGpgKey'
        'Add-GitHubUserKey'
        'Add-GitHubUserSigningKey'
        'Add-GitHubUserSocial'
        'Block-GitHubUser'
        'Connect-GitHubAccount'
        'Connect-GitHubApp'
        'ConvertFrom-IssueForm'
        'Disable-GitHubCommand'
        'Disable-GitHubRepositoryPrivateVulnerabilityReporting'
        'Disable-GitHubRepositorySecurityFix'
        'Disable-GitHubRepositoryVulnerabilityAlert'
        'Disable-GitHubWorkflow'
        'Disconnect-GitHubAccount'
        'Enable-GitHubCommand'
        'Enable-GitHubRepositoryPrivateVulnerabilityReporting'
        'Enable-GitHubRepositorySecurityFix'
        'Enable-GitHubRepositoryVulnerabilityAlert'
        'Enable-GitHubWorkflow'
        'Get-GitHubApiVersion'
        'Get-GitHubApp'
        'Get-GitHubAppAccessibleRepository'
        'Get-GitHubAppInstallableOrganization'
        'Get-GitHubAppInstallation'
        'Get-GitHubAppInstallationRepositoryAccess'
        'Get-GitHubAppJSONWebToken'
        'Get-GitHubAppWebhookConfiguration'
        'Get-GitHubAppWebhookDelivery'
        'Get-GitHubBlockedUser'
        'Get-GitHubConfig'
        'Get-GitHubContext'
        'Get-GitHubEmoji'
        'Get-GitHubEnterpriseOrganization'
        'Get-GitHubEventData'
        'Get-GitHubGitConfig'
        'Get-GitHubGitignore'
        'Get-GitHubLicense'
        'Get-GitHubMarkdown'
        'Get-GitHubMarkdownRaw'
        'Get-GitHubMeta'
        'Get-GitHubOctocat'
        'Get-GitHubOrganization'
        'Get-GitHubOrganizationMember'
        'Get-GitHubOrganizationPendingInvitation'
        'Get-GitHubOutput'
        'Get-GitHubRateLimit'
        'Get-GitHubRelease'
        'Get-GitHubReleaseAsset'
        'Get-GitHubRepoBranch'
        'Get-GitHubRepository'
        'Get-GitHubRepositoryActivity'
        'Get-GitHubRepositoryAutolink'
        'Get-GitHubRepositoryCodeownersError'
        'Get-GitHubRepositoryContributor'
        'Get-GitHubRepositoryCustomProperty'
        'Get-GitHubRepositoryFork'
        'Get-GitHubRepositoryLanguage'
        'Get-GitHubRepositoryRuleSuite'
        'Get-GitHubRepositoryRuleSuiteById'
        'Get-GitHubRepositoryRuleSuiteList'
        'Get-GitHubRepositorySecurityFix'
        'Get-GitHubRepositoryTag'
        'Get-GitHubRepositoryTagProtection'
        'Get-GitHubRepositoryTeam'
        'Get-GitHubRepositoryTopic'
        'Get-GitHubRoot'
        'Get-GitHubRunnerData'
        'Get-GitHubScheduledMaintenance'
        'Get-GitHubStatus'
        'Get-GitHubStatusComponent'
        'Get-GitHubStatusIncident'
        'Get-GitHubTeam'
        'Get-GitHubUser'
        'Get-GitHubUserEmail'
        'Get-GitHubUserFollower'
        'Get-GitHubUserFollowing'
        'Get-GitHubUserGpgKey'
        'Get-GitHubUserKey'
        'Get-GitHubUserSigningKey'
        'Get-GitHubViewer'
        'Get-GitHubWorkflow'
        'Get-GitHubWorkflowRun'
        'Get-GitHubWorkflowUsage'
        'Get-GitHubZen'
        'Install-GitHubApp'
        'Invoke-GitHubAPI'
        'Invoke-GitHubAppWebhookReDelivery'
        'Invoke-GitHubGraphQLQuery'
        'Move-GitHubRepository'
        'New-GitHubAppInstallationAccessToken'
        'New-GitHubOrganizationInvitation'
        'New-GitHubRelease'
        'New-GitHubReleaseNote'
        'New-GitHubRepository'
        'New-GitHubRepositoryAutolink'
        'New-GitHubRepositoryTagProtection'
        'New-GitHubTeam'
        'Remove-GitHubAppInstallationRepositoryAccess'
        'Remove-GitHubConfig'
        'Remove-GitHubOrganization'
        'Remove-GitHubOrganizationInvitation'
        'Remove-GitHubRelease'
        'Remove-GitHubReleaseAsset'
        'Remove-GitHubRepository'
        'Remove-GitHubRepositoryAutolink'
        'Remove-GitHubRepositoryTagProtection'
        'Remove-GitHubTeam'
        'Remove-GitHubUserEmail'
        'Remove-GitHubUserFollowing'
        'Remove-GitHubUserGpgKey'
        'Remove-GitHubUserKey'
        'Remove-GitHubUserSigningKey'
        'Remove-GitHubUserSocial'
        'Remove-GitHubWorkflowRun'
        'Reset-GitHubConfig'
        'Restart-GitHubWorkflowRun'
        'Set-GitHubConfig'
        'Set-GitHubDefaultContext'
        'Set-GitHubEnvironmentVariable'
        'Set-GitHubGitConfig'
        'Set-GitHubLogGroup'
        'Set-GitHubNoCommandGroup'
        'Set-GitHubOutput'
        'Set-GitHubRelease'
        'Set-GitHubReleaseAsset'
        'Set-GitHubRepositoryTopic'
        'Set-GitHubStepSummary'
        'Start-GitHubLogGroup'
        'Start-GitHubRepositoryEvent'
        'Start-GitHubWorkflow'
        'Stop-GitHubLogGroup'
        'Stop-GitHubWorkflowRun'
        'Test-GitHubBlockedUser'
        'Test-GitHubRepositoryVulnerabilityAlert'
        'Test-GitHubUserFollowing'
        'Unblock-GitHubUser'
        'Uninstall-GitHubApp'
        'Update-GitHubAppInstallationRepositoryAccess'
        'Update-GitHubAppWebhookConfiguration'
        'Update-GitHubOrganization'
        'Update-GitHubOrganizationSecurityFeature'
        'Update-GitHubRepository'
        'Update-GitHubTeam'
        'Update-GitHubUser'
        'Update-GitHubUserEmailVisibility'
        'Write-GitHubDebug'
        'Write-GitHubError'
        'Write-GitHubNotice'
        'Write-GitHubWarning'
    )
    CmdletsToExport       = @()
    VariablesToExport     = @()
    AliasesToExport       = @(
        'Add-GitHubUserSocials'
        'Add-Mask'
        'Cancel-GitHubWorkflowRun'
        'Connect-GitHub'
        'Debug'
        'Disable-GitHubRepositorySecurityFixes'
        'Disable-GitHubRepositoryVulnerabilityAlerts'
        'Disconnect-GitHub'
        'Enable-GitHubRepositorySecurityFixes'
        'Enable-GitHubRepositoryVulnerabilityAlerts'
        'Error'
        'Follow-GitHubUser'
        'Generate-GitHubReleaseNotes'
        'Get-GitHubAppJWT'
        'Get-GitHubRepoSecurityFixes'
        'Get-GitHubRepositoryAutolinks'
        'Get-GitHubRepositoryCustomProperties'
        'Get-GitHubRepositoryLanguages'
        'Get-GitHubRepositoryTags'
        'Get-GitHubRepositoryTeams'
        'Get-GitHubStatusComponents'
        'Get-GitHubStatusIncidents'
        'LogGroup'
        'Mask'
        'New-GitHubReleaseNotes'
        'NoLogGroup'
        'Notice'
        'Redeliver-GitHubAppWebhookDelivery'
        'Remove-GitHubUserSocials'
        'Set-GitHubEnv'
        'Start-LogGroup'
        'Stop-LogGroup'
        'Summary'
        'Test-GitHubRepositoryVulnerabilityAlerts'
        'Test-GitHubUserFollows'
        'Unfollow-GitHubUser'
        'Warning'
    )
    ModuleList            = @()
    FileList              = @(
        'formats/GitHubContext.Format.ps1xml'
        'formats/GitHubWebhook.Format.ps1xml'
        'formats/GitHubWebhookRedelivery.Format.ps1xml'
        'GitHub.psm1'
    )
    PrivateData           = @{
        PSData = @{
            Tags       = @(
                'GitHub'
                'Linux'
                'MacOS'
                'PSEdition_Core'
                'PSEdition_Desktop'
                'PSModule'
                'Windows'
            )
            LicenseUri = 'https://github.com/PSModule/GitHub/blob/main/LICENSE'
            ProjectUri = 'https://github.com/PSModule/GitHub'
            IconUri    = 'https://raw.githubusercontent.com/PSModule/GitHub/main/icon/icon.png'
        }
    }
}
