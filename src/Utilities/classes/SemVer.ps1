class PSSemVer : System.Object, System.IComparable, System.IEquatable[Object] {
    hidden static [string] $PSSemVerPattern = '^(0|[1-9]\d*)\.(0|[1-9]\d*)\.(0|[1-9]\d*)(?:-((?:0|[1-9]\d*|\d*[a-zA-Z-][0-9a-zA-Z-]*)' +
    '(?:\.(?:0|[1-9]\d*|\d*[a-zA-Z-][0-9a-zA-Z-]*))*))?(?:\+([0-9a-zA-Z-]+(?:\.[0-9a-zA-Z-]+)*))?$'
    hidden static [string] $loosePSSemVerPattern = '^([0-9a-zA-Z-]+-?)?(0|[1-9]\d*)\.(0|[1-9]\d*)\.(0|[1-9]\d*)' +
    '(?:-((?:0|[1-9]\d*|\d*[a-zA-Z-][0-9a-zA-Z-]*)(?:\.(?:0|[1-9]\d*|\d*[a-zA-Z-][0-9a-zA-Z-]*))*))?(?:\+([0-9a-zA-Z-]+(?:\.[0-9a-zA-Z-]+)*))?$'

    [string] $Prefix
    [int] $Major
    [int] $Minor
    [int] $Patch
    [string] $Prerelease
    [string] $BuildMetadata

    PSSemVer() {
        $this.Prefix = ''
        $this.Major = 0
        $this.Minor = 0
        $this.Patch = 0
        $this.Prerelease = ''
        $this.BuildMetadata = ''
    }

    PSSemVer([int]$Major) {
        $this.Prefix = ''
        $this.Major = $Major
        $this.Minor = 0
        $this.Patch = 0
        $this.Prerelease = ''
        $this.BuildMetadata = ''
    }

    PSSemVer([int]$Major, [int]$Minor) {
        $this.Prefix = ''
        $this.Major = $Major
        $this.Minor = $Minor
        $this.Patch = 0
        $this.Prerelease = ''
        $this.BuildMetadata = ''
    }

    PSSemVer([int]$Major, [int]$Minor, [int]$Patch) {
        $this.Prefix = ''
        $this.Major = $Major
        $this.Minor = $Minor
        $this.Patch = $Patch
        $this.Prerelease = ''
        $this.BuildMetadata = ''
    }

    PSSemVer([int]$Major, [int]$Minor, [int]$Patch, [string]$PreReleaseLabel) {
        $this.Prefix = ''
        $this.Major = $Major
        $this.Minor = $Minor
        $this.Patch = $Patch
        $this.Prerelease = $PreReleaseLabel
        $this.BuildMetadata = ''
    }

    PSSemVer([int]$Major, [int]$Minor, [int]$Patch, [string]$PreReleaseLabel, [string]$BuildLabel) {
        $this.Prefix = ''
        $this.Major = $Major
        $this.Minor = $Minor
        $this.Patch = $Patch
        $this.Prerelease = $PreReleaseLabel
        $this.BuildMetadata = $BuildLabel
    }

    PSSemVer([string]$Prefix, [int]$Major) {
        $this.Prefix = $Prefix
        $this.Major = $Major
        $this.Minor = 0
        $this.Patch = 0
        $this.Prerelease = ''
        $this.BuildMetadata = ''
    }

    PSSemVer([string]$Prefix, [int]$Major, [int]$Minor) {
        $this.Prefix = $Prefix
        $this.Major = $Major
        $this.Minor = $Minor
        $this.Patch = 0
        $this.Prerelease = ''
        $this.BuildMetadata = ''
    }

    PSSemVer([string]$Prefix, [int]$Major, [int]$Minor, [int]$Patch) {
        $this.Prefix = $Prefix
        $this.Major = $Major
        $this.Minor = $Minor
        $this.Patch = $Patch
        $this.Prerelease = ''
        $this.BuildMetadata = ''
    }

    PSSemVer([string]$Prefix, [int]$Major, [int]$Minor, [int]$Patch, [string]$PreReleaseLabel) {
        $this.Prefix = $Prefix
        $this.Major = $Major
        $this.Minor = $Minor
        $this.Patch = $Patch
        $this.Prerelease = $PreReleaseLabel
        $this.BuildMetadata = ''
    }

    PSSemVer([string]$Prefix, [int]$Major, [int]$Minor, [int]$Patch, [string]$PreReleaseLabel, [string]$BuildLabel) {
        $this.Prefix = $Prefix
        $this.Major = $Major
        $this.Minor = $Minor
        $this.Patch = $Patch
        $this.Prerelease = $PreReleaseLabel
        $this.BuildMetadata = $BuildLabel
    }

    PSSemVer([string]$version) {
        if ($version -match [PSSemVer]::PSSemVerPattern) {
            $this.Major = [int]$Matches[1]
            $this.Minor = [int]$Matches[2]
            $this.Patch = [int]$Matches[3]
            $this.Prerelease = $Matches[4]
            $this.BuildMetadata = $Matches[5]
        } elseif ($version -match [PSSemVer]::LoosePSSemVerPattern) {
            $this.Prefix = $Matches[1]
            $this.Major = [int]$Matches[2]
            $this.Minor = [int]$Matches[3]
            $this.Patch = [int]$Matches[4]
            $this.Prerelease = $Matches[5]
            $this.BuildMetadata = $Matches[6]
        } else {
            # Coerce the string to a PSSemVer object
            $sections = $version -split '[-+]', 3
            $this.Major, $this.Minor, $this.Patch = $sections[0] -split '\.', 3
            $this.Prerelease = $sections[1]
            $this.BuildMetadata = $sections[2]
        }
    }

    PSSemVer([version]$version) {
        $this.Prefix = ''
        $this.Major = $version.Major
        $this.Minor = $version.Minor
        $this.Patch = $version.Build
        $this.Prerelease = ''
        $this.BuildMetadata = ''
    }

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

    [void] SetPrerelease([string]$label) {
        $this.Prerelease = $label
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

    static [PSSemVer] Parse([string]$string) {
        return [PSSemVer]::new($string)
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
        $thisPrereleaseArray = $this.Prerelease -split '\.'
        $otherPrereleaseArray = $other.Prerelease -split '\.'
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
}
