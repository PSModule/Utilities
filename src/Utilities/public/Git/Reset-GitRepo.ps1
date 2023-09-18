function Reset-Repo {
    param(
        $Upstream = 'upstream',
        $Branch = 'main',
        [bool]$Push = $true
    )
    git fetch $Upstream
    git checkout $Branch
    git reset --hard $Upstream/$Branch
    if ($Push) {
        git push origin $Branch --force
    }
}
Set-Alias -Name Reset -Value Reset-Repo
