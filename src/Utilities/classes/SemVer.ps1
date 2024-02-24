class SemVer : System.Object, System.IComparable, System.IEquatable[Object] {
    hidden static [string] $semVerPattern = '(0|[1-9]\d*)\.(0|[1-9]\d*)\.(0|[1-9]\d*)(?:-((?:0|[1-9]\d*|\d*[a-zA-Z-][0-9a-zA-Z-]*)' +
    '(?:\.(?:0|[1-9]\d*|\d*[a-zA-Z-][0-9a-zA-Z-]*))*))?(?:\+([0-9a-zA-Z-]+(?:\.[0-9a-zA-Z-]+)*))?$'
    hidden static [string] $looseSemVerPattern = '^([0-9a-zA-Z-]+-?)?(0|[1-9]\d*)\.(0|[1-9]\d*)\.(0|[1-9]\d*)' +
    '(?:-((?:0|[1-9]\d*|\d*[a-zA-Z-][0-9a-zA-Z-]*)(?:\.(?:0|[1-9]\d*|\d*[a-zA-Z-][0-9a-zA-Z-]*))*))?(?:\+([0-9a-zA-Z-]+(?:\.[0-9a-zA-Z-]+)*))?$'

    [string] $Prefix
    [int] $Major
    [int] $Minor
    [int] $Patch
    [string] $Prerelease
    [string] $BuildMetadata

    SemVer() {
        $this.Prefix = ''
        $this.Major = 0
        $this.Minor = 0
        $this.Patch = 0
        $this.Prerelease = ''
        $this.BuildMetadata = ''
    }

    SemVer([int]$Major) {
        $this.Prefix = ''
        $this.Major = $Major
        $this.Minor = 0
        $this.Patch = 0
        $this.Prerelease = ''
        $this.BuildMetadata = ''
    }

    SemVer([int]$Major, [int]$Minor) {
        $this.Prefix = ''
        $this.Major = $Major
        $this.Minor = $Minor
        $this.Patch = 0
        $this.Prerelease = ''
        $this.BuildMetadata = ''
    }

    SemVer([int]$Major, [int]$Minor, [int]$Patch) {
        $this.Prefix = ''
        $this.Major = $Major
        $this.Minor = $Minor
        $this.Patch = $Patch
        $this.Prerelease = ''
        $this.BuildMetadata = ''
    }

    SemVer([int]$Major, [int]$Minor, [int]$Patch, [string]$PreReleaseLabel) {
        $this.Prefix = ''
        $this.Major = $Major
        $this.Minor = $Minor
        $this.Patch = $Patch
        $this.Prerelease = $PreReleaseLabel
        $this.BuildMetadata = ''
    }

    SemVer([int]$Major, [int]$Minor, [int]$Patch, [string]$PreReleaseLabel, [string]$BuildLabel) {
        $this.Prefix = ''
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
        } elseif ($version -match [SemVer]::LooseSemVerPattern) {
            $this.Prefix = $Matches[1]
            $this.Major = [int]$Matches[2]
            $this.Minor = [int]$Matches[3]
            $this.Patch = [int]$Matches[4]
            $this.Prerelease = $Matches[5]
            $this.BuildMetadata = $Matches[6]
        } else {
            # Coerce the string to a SemVer object
            $sections = $version -split '[-+]', 3
            $this.Major, $this.Minor, $this.Patch = $sections[0] -split '\.', 3
            $this.Prerelease = $sections[1]
            $this.BuildMetadata = $sections[2]
        }
    }

    SemVer([version]$version) {
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

    static [SemVer] Parse([string]$string) {
        return [SemVer]::new($string)
    }

    [int] CompareTo([Object]$other) {
        if (-not $other -is [SemVer]) {
            throw [ArgumentException]::new('The argument must be of type SemVer')
        }
        if ($this.Major -lt $other.Major) {
            Write-Verbose "$($this.Major) < $($other.Major)"
            return -1
        }
        if ($this.Major -gt $other.Major) {
            Write-Verbose "$($this.Major) > $($other.Major)"
            return 1
        }
        if ($this.Minor -lt $other.Minor) {
            Write-Verbose "$($this.Minor) < $($other.Minor)"
            return -1
        }
        if ($this.Minor -gt $other.Minor) {
            Write-Verbose "$($this.Minor) > $($other.Minor)"
            return 1
        }
        if ($this.Patch -lt $other.Patch) {
            Write-Verbose "$($this.Patch) < $($other.Patch)"
            return -1
        }
        if ($this.Patch -gt $other.Patch) {
            Write-Verbose "$($this.Patch) > $($other.Patch)"
            return 1
        }
        $prereleaseArray = $this.Prerelease -split '\.'
        $otherPrereleaseArray = $other.Prerelease -split '\.'
        for ($i = 0; $i -lt [Math]::Max($prereleaseArray.Length, $otherPrereleaseArray.Length); $i++) {
            if ($i -ge $prereleaseArray.Length) {
                Write-Verbose 'end of prerelease array' -Verbose
                Write-Verbose "$($this.Prerelease) < $($other.Prerelease)" -Verbose
                return -1
            }
            if ($i -ge $otherPrereleaseArray.Length) {
                Write-Verbose 'end of other prerelease array' -Verbose
                Write-Verbose "$($this.Prerelease) > $($other.Prerelease)" -Verbose
                return 1
            }
            if ($prereleaseArray[$i] -eq $otherPrereleaseArray[$i]) {
                Write-Verbose 'Same prerelease label' -Verbose
                Write-Verbose "$($prereleaseArray[$i]) = $($otherPrereleaseArray[$i])" -Verbose
                continue
            }
            if ($prereleaseArray[$i] -match '^\d+$' -and $otherPrereleaseArray[$i] -match '^\d+$') {
                Write-Verbose 'Numeric prerelease label' -Verbose
                Write-Verbose "$($prereleaseArray[$i]) - $($otherPrereleaseArray[$i])" -Verbose
                return [int]$prereleaseArray[$i] - [int]$otherPrereleaseArray[$i]
            }
            if ($prereleaseArray[$i] -match '^\d+$' -and $otherPrereleaseArray[$i] -notmatch '^\d+$') {
                Write-Verbose 'Non-numeric prerelease label wins' -Verbose
                Write-Verbose "$($prereleaseArray[$i]) < $($otherPrereleaseArray[$i])" -Verbose
                return -1
            }
            if ($prereleaseArray[$i] -notmatch '^\d+$' -and $otherPrereleaseArray[$i] -match '^\d+$') {
                Write-Verbose 'Non-numeric prerelease label wins' -Verbose
                Write-Verbose "$($prereleaseArray[$i]) > $($otherPrereleaseArray[$i])" -Verbose
                return 1
            }
            $comp = $prereleaseArray[$i].CompareTo($otherPrereleaseArray[$i])
            Write-Verbose 'String comparison' -Verbose
            Write-Verbose "$($prereleaseArray[$i]) Comp $($otherPrereleaseArray[$i]) = $comp" -Verbose
            return $prereleaseArray[$i].CompareTo($otherPrereleaseArray[$i])
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

    [string] ToString() {
        [string]$output = "$($this.Major).$($this.Minor).$($this.Patch)"

        if (-not [string]::IsNullOrEmpty($this.Prerelease)) {
            $output += "-$($this.Prerelease)"
        }
        if (-not [string]::IsNullOrEmpty($this.BuildMetadata)) {
            $output += "+$($this.BuildMetadata)"
        }
        return $output
    }
}
