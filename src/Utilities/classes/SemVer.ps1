class SemVer : System.Object, System.IComparable, System.IEquatable[Object] {
    hidden static [string] $semVerPattern = '(0|[1-9]\d*)\.(0|[1-9]\d*)\.(0|[1-9]\d*)' +
    '(?:-((?:0|[1-9]\d*|\d*[a-zA-Z-][0-9a-zA-Z-]*)(?:\.(?:0|[1-9]\d*|\d*[a-zA-Z-][0-9a-zA-Z-]*))*))?' +
    '(?:\+([0-9a-zA-Z-]+(?:\.[0-9a-zA-Z-]+)*))?$'
    [int]$Major
    [int]$Minor
    [int]$Patch
    [string]$Prerelease
    [string]$BuildMetadata

    SemVer() {
        $this.Major = 0
        $this.Minor = 0
        $this.Patch = 0
        $this.Prerelease = ''
        $this.BuildMetadata = ''
    }

    SemVer([int]$Major) {
        $this.Major = $Major
        $this.Minor = 0
        $this.Patch = 0
        $this.Prerelease = ''
        $this.BuildMetadata = ''
    }

    SemVer([int]$Major, [int]$Minor) {
        $this.Major = $Major
        $this.Minor = $Minor
        $this.Patch = 0
        $this.Prerelease = ''
        $this.BuildMetadata = ''
    }

    SemVer([int]$Major, [int]$Minor, [int]$Patch) {
        $this.Major = $Major
        $this.Minor = $Minor
        $this.Patch = $Patch
        $this.Prerelease = ''
        $this.BuildMetadata = ''
    }

    SemVer([int]$Major, [int]$Minor, [int]$Patch, [string]$PreReleaseLabel) {
        $this.Major = $Major
        $this.Minor = $Minor
        $this.Patch = $Patch
        $this.Prerelease = $PreReleaseLabel
        $this.BuildMetadata = ''
    }

    SemVer([int]$Major, [int]$Minor, [int]$Patch, [string]$PreReleaseLabel, [string]$BuildLabel) {
        $this.Major = $Major
        $this.Minor = $Minor
        $this.Patch = $Patch
        $this.Prerelease = $PreReleaseLabel
        $this.BuildMetadata = $BuildLabel
    }

    SemVer([string]$version) {
        if ($version -match [SemVer]::SemVerPattern) {
            $this.Major = [int]$Matches[1]
            $this.Minor = [int]$Matches[2]
            $this.Patch = [int]$Matches[3]
            $this.Prerelease = $Matches[4]
            $this.BuildMetadata = $Matches[5]
        } else {
            # Coerce the string to a Semver object
            $sections = $version -split '[-+]', 3
            $this.Major, $this.Minor, $this.Patch = $sections[0] -split '\.', 3
            $this.Prerelease = $sections[1]
            $this.BuildMetadata = $sections[2]
        }
    }

    SemVer([version]$version) {
        $this.Major = $version.Major
        $this.Minor = $version.Minor
        $this.Patch = $version.Build
        $this.Prerelease = ''
        $this.BuildMetadata = ''
    }

    [string] ToString() {
        $output = "$($this.Major).$($this.Minor).$($this.Patch)"

        if (-not [string]::IsNullOrEmpty($this.Prerelease)) {
            $output += "-$($this.Prerelease)"
        }
        if (-not [string]::IsNullOrEmpty($this.BuildMetadata)) {
            $output += "+$($this.BuildMetadata)"
        }
        return $output
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

    [void] SetBuildMetadata([string]$label) {
        $this.BuildMetadata = $label
    }

    [semver] Parse([string]$string) {
        return [SemVer]::new($string)
    }

    [int] CompareTo([Object]$other) {
        if (-not $other -is [SemVer]) {
            throw [ArgumentException]::new('The argument must be of type SemVer')
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
        if ($this.Prerelease -lt $other.Prerelease) {
            return -1
        }
        if ($this.Prerelease -gt $other.Prerelease) {
            return 1
        }
        if ($this.BuildMetadata -lt $other.BuildMetadata) {
            return -1
        }
        if ($this.BuildMetadata -gt $other.BuildMetadata) {
            return 1
        }
        return 0
    }

    [bool] Equals([Object]$other) {
        if (-not $other -is [SemVer]) {
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
}
