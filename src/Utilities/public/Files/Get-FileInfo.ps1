function Get-FileInfo {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string] $Path
    )

    if (-not (Test-Path -Path $Path)) {
        Write-Error 'Path does not exist' -ErrorAction Stop
    }

    $Item = Get-Item -Path $Path

    #If item is directory, fail
    if ($Item.PSIsContainer) {
        Write-Error 'Path is a directory' -ErrorAction Stop
    }

    $shell = New-Object -ComObject Shell.Application
    $shellFolder = $shell.Namespace($Item.Directory.FullName)
    $shellFile = $shellFolder.ParseName($Item.name)

    $fileDetails = New-Object pscustomobject

    foreach ($i in 0..1000) {
        $propertyName = $shellfolder.GetDetailsOf($null, $i)
        $propertyValue = $shellfolder.GetDetailsOf($shellfile, $i)
        if (-not [string]::IsNullOrEmpty($propertyValue)) {
            Write-Verbose "[$propertyName] - [$propertyValue]"
            $fileDetails | Add-Member -MemberType NoteProperty -Name $propertyName -Value $propertyValue
        }
    }
    return $fileDetails
}
