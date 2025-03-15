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
        @{
            ModuleName      = 'Context'
            RequiredVersion = '7.0.2'
        }
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
        'formats/GitHubWebhookRedelivery.Format.ps1xml'
        'formats/GitHubContext.Format.ps1xml'
        'formats/GitHubWebhook.Format.ps1xml'
    )
    FunctionsToExport     = @(
        'Get-GitHubEventData'
        'Get-GitHubRunnerData'
        'Disable-GitHubWorkflow'
        'Enable-GitHubWorkflow'
        'Get-GitHubWorkflow'
        'Get-GitHubWorkflowUsage'
        'Start-GitHubWorkflow'
        'Get-GitHubWorkflowRun'
        'Remove-GitHubWorkflowRun'
        'Restart-GitHubWorkflowRun'
        'Stop-GitHubWorkflowRun'
        'Invoke-GitHubAPI'
        'Get-GitHubApp'
        'Get-GitHubAppInstallableOrganization'
        'Get-GitHubAppJSONWebToken'
        'Install-GitHubApp'
        'New-GitHubAppInstallationAccessToken'
        'Uninstall-GitHubApp'
        'Add-GitHubAppInstallationRepositoryAccess'
        'Get-GitHubAppAccessibleRepository'
        'Get-GitHubAppInstallation'
        'Get-GitHubAppInstallationRepositoryAccess'
        'Remove-GitHubAppInstallationRepositoryAccess'
        'Update-GitHubAppInstallationRepositoryAccess'
        'Get-GitHubAppWebhookConfiguration'
        'Get-GitHubAppWebhookDelivery'
        'Invoke-GitHubAppWebhookReDelivery'
        'Update-GitHubAppWebhookConfiguration'
        'Get-GitHubContext'
        'Set-GitHubDefaultContext'
        'Connect-GitHubAccount'
        'Connect-GitHubApp'
        'Disconnect-GitHubAccount'
        'Get-GitHubViewer'
        'Get-GitHubRepoBranch'
        'Add-GitHubMask'
        'Add-GitHubSystemPath'
        'Disable-GitHubCommand'
        'Enable-GitHubCommand'
        'Get-GitHubOutput'
        'Set-GitHubEnvironmentVariable'
        'Set-GitHubLogGroup'
        'Set-GitHubNoCommandGroup'
        'Set-GitHubOutput'
        'Set-GitHubStepSummary'
        'Start-GitHubLogGroup'
        'Stop-GitHubLogGroup'
        'Write-GitHubDebug'
        'Write-GitHubError'
        'Write-GitHubNotice'
        'Write-GitHubWarning'
        'Get-GitHubConfig'
        'Remove-GitHubConfig'
        'Reset-GitHubConfig'
        'Set-GitHubConfig'
        'Get-GitHubEmoji'
        'Get-GitHubEnterpriseOrganization'
        'Get-GitHubGitConfig'
        'Set-GitHubGitConfig'
        'Get-GitHubGitignore'
        'Invoke-GitHubGraphQLQuery'
        'ConvertFrom-IssueForm'
        'Get-GitHubLicense'
        'Get-GitHubMarkdown'
        'Get-GitHubMarkdownRaw'
        'Get-GitHubApiVersion'
        'Get-GitHubMeta'
        'Get-GitHubOctocat'
        'Get-GitHubRoot'
        'Get-GitHubZen'
        'Get-GitHubOrganizationMember'
        'Get-GitHubOrganizationPendingInvitation'
        'New-GitHubOrganizationInvitation'
        'Remove-GitHubOrganizationInvitation'
        'Get-GitHubOrganization'
        'Remove-GitHubOrganization'
        'Update-GitHubOrganization'
        'Update-GitHubOrganizationSecurityFeature'
        'Get-GitHubRateLimit'
        'Add-GitHubReleaseAsset'
        'Get-GitHubReleaseAsset'
        'Remove-GitHubReleaseAsset'
        'Set-GitHubReleaseAsset'
        'Get-GitHubRelease'
        'New-GitHubRelease'
        'New-GitHubReleaseNote'
        'Remove-GitHubRelease'
        'Set-GitHubRelease'
        'Get-GitHubRepositoryAutolink'
        'New-GitHubRepositoryAutolink'
        'Remove-GitHubRepositoryAutolink'
        'Get-GitHubRepositoryCustomProperty'
        'Disable-GitHubRepositoryPrivateVulnerabilityReporting'
        'Disable-GitHubRepositorySecurityFix'
        'Disable-GitHubRepositoryVulnerabilityAlert'
        'Enable-GitHubRepositoryPrivateVulnerabilityReporting'
        'Enable-GitHubRepositorySecurityFix'
        'Enable-GitHubRepositoryVulnerabilityAlert'
        'Get-GitHubRepository'
        'Get-GitHubRepositoryActivity'
        'Get-GitHubRepositoryCodeownersError'
        'Get-GitHubRepositoryContributor'
        'Get-GitHubRepositoryFork'
        'Get-GitHubRepositoryLanguage'
        'Get-GitHubRepositorySecurityFix'
        'Get-GitHubRepositoryTag'
        'Get-GitHubRepositoryTeam'
        'Get-GitHubRepositoryTopic'
        'Move-GitHubRepository'
        'New-GitHubRepository'
        'Remove-GitHubRepository'
        'Set-GitHubRepositoryTopic'
        'Start-GitHubRepositoryEvent'
        'Test-GitHubRepositoryVulnerabilityAlert'
        'Update-GitHubRepository'
        'Get-GitHubRepositoryRuleSuite'
        'Get-GitHubRepositoryRuleSuiteById'
        'Get-GitHubRepositoryRuleSuiteList'
        'Get-GitHubRepositoryTagProtection'
        'New-GitHubRepositoryTagProtection'
        'Remove-GitHubRepositoryTagProtection'
        'Get-GitHubScheduledMaintenance'
        'Get-GitHubStatus'
        'Get-GitHubStatusComponent'
        'Get-GitHubStatusIncident'
        'Get-GitHubTeam'
        'New-GitHubTeam'
        'Remove-GitHubTeam'
        'Update-GitHubTeam'
        'Block-GitHubUser'
        'Get-GitHubBlockedUser'
        'Test-GitHubBlockedUser'
        'Unblock-GitHubUser'
        'Add-GitHubUserEmail'
        'Get-GitHubUserEmail'
        'Remove-GitHubUserEmail'
        'Update-GitHubUserEmailVisibility'
        'Add-GitHubUserFollowing'
        'Get-GitHubUserFollower'
        'Get-GitHubUserFollowing'
        'Remove-GitHubUserFollowing'
        'Test-GitHubUserFollowing'
        'Add-GitHubUserGpgKey'
        'Get-GitHubUserGpgKey'
        'Remove-GitHubUserGpgKey'
        'Add-GitHubUserKey'
        'Get-GitHubUserKey'
        'Remove-GitHubUserKey'
        'Add-GitHubUserSocial'
        'Remove-GitHubUserSocial'
        'Add-GitHubUserSigningKey'
        'Get-GitHubUserSigningKey'
        'Remove-GitHubUserSigningKey'
        'Get-GitHubUser'
        'Update-GitHubUser'
    )
    CmdletsToExport       = @()
    VariablesToExport     = @()
    AliasesToExport       = @(
        'Cancel-GitHubWorkflowRun'
        'Get-GitHubAppJWT'
        'Redeliver-GitHubAppWebhookDelivery'
        'Connect-GitHub'
        'Disconnect-GitHub'
        'Mask'
        'Add-Mask'
        'Set-GitHubEnv'
        'LogGroup'
        'NoLogGroup'
        'Summary'
        'Start-LogGroup'
        'Stop-LogGroup'
        'Debug'
        'Error'
        'Notice'
        'Warning'
        'Generate-GitHubReleaseNotes'
        'New-GitHubReleaseNotes'
        'Get-GitHubRepositoryAutolinks'
        'Get-GitHubRepositoryCustomProperties'
        'Disable-GitHubRepositorySecurityFixes'
        'Disable-GitHubRepositoryVulnerabilityAlerts'
        'Enable-GitHubRepositorySecurityFixes'
        'Enable-GitHubRepositoryVulnerabilityAlerts'
        'Get-GitHubRepositoryLanguages'
        'Get-GitHubRepoSecurityFixes'
        'Get-GitHubRepositoryTags'
        'Get-GitHubRepositoryTeams'
        'Test-GitHubRepositoryVulnerabilityAlerts'
        'Get-GitHubStatusComponents'
        'Get-GitHubStatusIncidents'
        'Follow-GitHubUser'
        'Unfollow-GitHubUser'
        'Test-GitHubUserFollows'
        'Add-GitHubUserSocials'
        'Remove-GitHubUserSocials'
    )
    ModuleList            = @()
    FileList              = @(
        'GitHub.psm1'
        'formats/GitHubContext.Format.ps1xml'
        'formats/GitHubWebhook.Format.ps1xml'
        'formats/GitHubWebhookRedelivery.Format.ps1xml'
    )
    PrivateData           = @{
        PSData = @{
            Tags       = @(
                'GitHub'
                'PSModule'
                'Windows'
                'Linux'
                'MacOS'
                'PSEdition_Desktop'
                'PSEdition_Core'
            )
            LicenseUri = 'https://github.com/PSModule/GitHub/blob/main/LICENSE'
            ProjectUri = 'https://github.com/PSModule/GitHub'
            IconUri    = 'https://raw.githubusercontent.com/PSModule/GitHub/main/icon/icon.png'
        }
    }
}

