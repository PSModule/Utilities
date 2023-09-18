function Restore-Repo {
    git remote add upstream https://github.com/Azure/ResourceModules.git
    git fetch upstream
    git restore --source upstream/main * ':!*global.variables.*' ':!settings.json*'
}
