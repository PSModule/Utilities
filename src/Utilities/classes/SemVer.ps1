class PSSemVer : System.Object, System.IComparable, System.IEquatable[Object] {
    #region Static properties
    hidden static [string] $PSSemVerPattern = '^(0|[1-9]\d*)\.(0|[1-9]\d*)\.(0|[1-9]\d*)(?:-((?:0|[1-9]\d*|\d*[a-zA-Z-][0-9a-zA-Z-]*)' +
    '(?:\.(?:0|[1-9]\d*|\d*[a-zA-Z-][0-9a-zA-Z-]*))*))?(?:\+([0-9a-zA-Z-]+(?:\.[0-9a-zA-Z-]+)*))?$'
    hidden static [string] $LoosePSSemVerPattern = '^([0-9a-zA-Z-]+-?)?(0|[1-9]\d*)\.(0|[1-9]\d*)\.(0|[1-9]\d*)' +
    '(?:-((?:0|[1-9]\d*|\d*[a-zA-Z-][0-9a-zA-Z-]*)(?:\.(?:0|[1-9]\d*|\d*[a-zA-Z-][0-9a-zA-Z-]*))*))?(?:\+([0-9a-zA-Z-]+(?:\.[0-9a-zA-Z-]+)*))?$'
    #endregion Static properties

    #region Properties
    [string] $Prefix
    [int] $Major
    [int] $Minor
    [int] $Patch
    [string] $Prerelease
    hidden [Nullable[int]] $PrereleaseNumber
    [string] $BuildMetadata
    #endregion Properties

    #region Constructors
    PSSemVer() {}

    PSSemVer([int]$Major) {
        $this.Major = $Major
    }

    PSSemVer([int]$Major, [int]$Minor) {
        $this.Major = $Major
        $this.Minor = $Minor
    }

    PSSemVer([int]$Major, [int]$Minor, [int]$Patch) {
        $this.Major = $Major
        $this.Minor = $Minor
        $this.Patch = $Patch
    }

    PSSemVer([int]$Major, [int]$Minor, [int]$Patch, [string]$PreReleaseLabel) {
        $this.Major = $Major
        $this.Minor = $Minor
        $this.Patch = $Patch
        $this.Prerelease = $PreReleaseLabel
        $this.PrereleaseNumber = [PSSemVer]::GetPrereleaseNumber($PreReleaseLabel)
    }

    PSSemVer([int]$Major, [int]$Minor, [int]$Patch, [string]$PreReleaseLabel, [int]$PreReleaseNumber) {
        $this.Major = $Major
        $this.Minor = $Minor
        $this.Patch = $Patch
        $this.Prerelease = "$PreReleaseLabel.$PreReleaseNumber"
        $this.PrereleaseNumber = $PreReleaseNumber
    }

    PSSemVer([int]$Major, [int]$Minor, [int]$Patch, [string]$PreReleaseLabel, [string]$BuildLabel) {
        $this.Major = $Major
        $this.Minor = $Minor
        $this.Patch = $Patch
        $this.Prerelease = [string]$PreReleaseLabel
        $this.PrereleaseNumber = [PSSemVer]::GetPrereleaseNumber($PreReleaseLabel)
        $this.BuildMetadata = $BuildLabel
    }

    PSSemVer([int]$Major, [int]$Minor, [int]$Patch, [string]$PreReleaseLabel, [int]$PreReleaseNumber, [string]$BuildLabel) {
        $this.Major = $Major
        $this.Minor = $Minor
        $this.Patch = $Patch
        $this.Prerelease = "$PreReleaseLabel.$PreReleaseNumber"
        $this.PrereleaseNumber = $PreReleaseNumber
        $this.BuildMetadata = $BuildLabel
    }

    PSSemVer([string]$Prefix, [int]$Major) {
        $this.Prefix = $Prefix
        $this.Major = $Major
    }

    PSSemVer([string]$Prefix, [int]$Major, [int]$Minor) {
        $this.Prefix = $Prefix
        $this.Major = $Major
        $this.Minor = $Minor
    }

    PSSemVer([string]$Prefix, [int]$Major, [int]$Minor, [int]$Patch) {
        $this.Prefix = $Prefix
        $this.Major = $Major
        $this.Minor = $Minor
        $this.Patch = $Patch
    }

    PSSemVer([string]$Prefix, [int]$Major, [int]$Minor, [int]$Patch, [string]$PreReleaseLabel) {
        $this.Prefix = $Prefix
        $this.Major = $Major
        $this.Minor = $Minor
        $this.Patch = $Patch
        $this.Prerelease = $PreReleaseLabel
        $this.PrereleaseNumber = [PSSemVer]::GetPrereleaseNumber($PreReleaseLabel)
    }

    PSSemVer([string]$Prefix, [int]$Major, [int]$Minor, [int]$Patch, [string]$PreReleaseLabel, [int]$PreReleaseNumber) {
        $this.Prefix = $Prefix
        $this.Major = $Major
        $this.Minor = $Minor
        $this.Patch = $Patch
        $this.Prerelease = "$PreReleaseLabel.$PreReleaseNumber"
        $this.PrereleaseNumber = $PreReleaseNumber
    }

    PSSemVer([string]$Prefix, [int]$Major, [int]$Minor, [int]$Patch, [string]$PreReleaseLabel, [string]$BuildLabel) {
        $this.Prefix = $Prefix
        $this.Major = $Major
        $this.Minor = $Minor
        $this.Patch = $Patch
        $this.Prerelease = $PreReleaseLabel
        $this.PrereleaseNumber = [PSSemVer]::GetPrereleaseNumber($PreReleaseLabel)
        $this.BuildMetadata = $BuildLabel
    }

    PSSemVer([string]$Prefix, [int]$Major, [int]$Minor, [int]$Patch, [string]$PreReleaseLabel, [int]$PreReleaseNumber, [string]$BuildLabel) {
        $this.Prefix = $Prefix
        $this.Major = $Major
        $this.Minor = $Minor
        $this.Patch = $Patch
        $this.Prerelease = "$PreReleaseLabel.$PreReleaseNumber"
        $this.PrereleaseNumber = $PreReleaseNumber
        $this.BuildMetadata = $BuildLabel
    }

    PSSemVer([string]$version) {
        if ($version -match [PSSemVer]::PSSemVerPattern) {
            Write-Host 'PSSemVerPattern'
            $this.Major = [int]$Matches[1]
            $this.Minor = [int]$Matches[2]
            $this.Patch = [int]$Matches[3]
            $this.Prerelease = $Matches[4]
            $this.PrereleaseNumber = [PSSemVer]::GetPrereleaseNumber($Matches[4])
            $this.BuildMetadata = $Matches[5]
        } elseif ($version -match [PSSemVer]::LoosePSSemVerPattern) {
            Write-Host 'LoosePSSemVerPattern'
            $this.Prefix = $Matches[1]
            $this.Major = [int]$Matches[2]
            $this.Minor = [int]$Matches[3]
            $this.Patch = [int]$Matches[4]
            $this.Prerelease = $Matches[5]
            $this.PrereleaseNumber = [PSSemVer]::GetPrereleaseNumber($Matches[5])
            $this.BuildMetadata = [int]$Matches[6]
        } else {
            Write-Host 'Coercion'
            $sections = $version -split '[-+]', 3
            $this.Major, $this.Minor, $this.Patch = $sections[0] -split '\.', 3
            $this.Prerelease = $sections[1]
            $this.BuildMetadata = $sections[2]
        }
    }

    PSSemVer([version]$version) {
        $this.Major = $version.Major
        $this.Minor = $version.Minor
        $this.Patch = $version.Build
    }
    #endregion Constructors

    #region Methods
    [void] BumpMajor() {
        $this.Major = $this.Major + 1
        $this.Minor = 0
        $this.Patch = 0
    }

    [void] BumpMinor() {
        $this.Minor = $this.Minor + 1
        $this.Patch = 0
    }

    [void] BumpPatch() {
        $this.Patch = $this.Patch + 1
    }

    [void] BumpPrereleaseNumber() {
        if (-not [string]::IsNullOrEmpty($this.Prerelease)) {
            $this.PrereleaseNumber = [PSSemVer]::GetPrereleaseNumber($this.Prerelease)
            if ([string]::IsNullOrEmpty($this.PrereleaseNumber)) {
                $this.PrereleaseNumber = 1
            } else {
                $this.PrereleaseNumber++
            }
            $this.PreRelease = "$([PSSemVer]::GetPrereleaseLabel($this.Prerelease)).$($this.PrereleaseNumber)"
        }
    }

    [void] SetPrerelease([string]$label) {
        $this.Prerelease = $label
        $this.PrereleaseNumber = [PSSemVer]::GetPrereleaseNumber($label)
    }

    [void] SetPrereleaseLabel([string]$label) {
        $this.SetPrerelease($label)
    }

    [void] SetBuild([string]$label) {
        $this.SetBuildMetadata($label)
    }

    [void] SetBuildLabel([string]$label) {
        $this.SetBuildMetadata($label)
    }

    [void] SetBuildMetadata([string]$label) {
        $this.BuildMetadata = $label
    }

    [int] CompareTo([Object]$other) {
        if (-not $other -is [PSSemVer]) {
            throw [ArgumentException]::new('The argument must be of type PSSemVer')
        }
        if ($this.Major -lt $other.Major) {
            return -1
        }
        if ($this.Major -gt $other.Major) {
            return 1
        }
        if ($this.Minor -lt $other.Minor) {
            return -1
        }
        if ($this.Minor -gt $other.Minor) {
            return 1
        }
        if ($this.Patch -lt $other.Patch) {
            return -1
        }
        if ($this.Patch -gt $other.Patch) {
            return 1
        }
        if ([string]::IsNullOrEmpty($this.Prerelease) -and [string]::IsNullOrEmpty($other.Prerelease)) {
            return 0
        }
        if ([string]::IsNullOrEmpty($this.Prerelease)) {
            return 1
        }
        if ([string]::IsNullOrEmpty($other.Prerelease)) {
            return -1
        }
        $thisPrereleaseArray = ($this.Prerelease -split '\.')
        $otherPrereleaseArray = ($other.Prerelease -split '\.')
        for ($i = 0; $i -lt [Math]::Max($thisPrereleaseArray.Length, $otherPrereleaseArray.Length); $i++) {
            if ($i -ge $thisPrereleaseArray.Length) {
                return -1
            }
            if ($i -ge $otherPrereleaseArray.Length) {
                return 1
            }
            if ($thisPrereleaseArray[$i] -eq $otherPrereleaseArray[$i]) {
                continue
            }
            if ($thisPrereleaseArray[$i] -match '^\d+$' -and $otherPrereleaseArray[$i] -match '^\d+$') {
                return [int]$thisPrereleaseArray[$i] - [int]$otherPrereleaseArray[$i]
            }
            if ($thisPrereleaseArray[$i] -match '^\d+$' -and $otherPrereleaseArray[$i] -notmatch '^\d+$') {
                return -1
            }
            if ($thisPrereleaseArray[$i] -notmatch '^\d+$' -and $otherPrereleaseArray[$i] -match '^\d+$') {
                return 1
            }
            return $thisPrereleaseArray[$i].CompareTo($otherPrereleaseArray[$i])
        }

        return 0
    }

    [bool] Equals([Object]$other) {
        if (-not $other -is [PSSemVer]) {
            return $false
        }
        if ($this.Major -ne $other.Major) {
            return $false
        }
        if ($this.Minor -ne $other.Minor) {
            return $false
        }
        if ($this.Patch -ne $other.Patch) {
            return $false
        }
        if ($this.Prerelease -ne $other.Prerelease) {
            return $false
        }
        if ($this.BuildMetadata -ne $other.BuildMetadata) {
            return $false
        }
        return $true
    }

    [string] ToString() {
        [string]$output = "$($this.Prefix)$($this.Major).$($this.Minor).$($this.Patch)"

        if (-not [string]::IsNullOrEmpty($this.Prerelease)) {
            $output += "-$($this.Prerelease)"
        }
        if (-not [string]::IsNullOrEmpty($this.BuildMetadata)) {
            $output += "+$($this.BuildMetadata)"
        }
        return $output
    }
    #endregion Methods

    #region Static Methods
    static [PSSemVer] Parse([string]$string) {
        return [PSSemVer]::new($string)
    }

    static [Nullable[int]] GetPrereleaseNumber([string]$string) {
        if ($string -match '^(.*?)(?:\.(\d+))?$') {
            return [Nullable[int]]$matches[2]
        }
        return $null
    }

    static [string] GetPrereleaseLabel([string]$string) {
        if ($string -match '^(.*?)(?:\.(\d+))?$') {
            return $matches[1]
        }
        return $null
    }
    #endregion Static Methods
}
