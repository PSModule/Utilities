﻿class PSSemVer : System.Object, System.IComparable, System.IEquatable[Object] {
    hidden static [string] $semVerPattern = '(0|[1-9]\d*)\.(0|[1-9]\d*)\.(0|[1-9]\d*)' +
    '(?:-((?:0|[1-9]\d*|\d*[a-zA-Z-][0-9a-zA-Z-]*)(?:\.(?:0|[1-9]\d*|\d*[a-zA-Z-][0-9a-zA-Z-]*))*))?' +
    '(?:\+([0-9a-zA-Z-]+(?:\.[0-9a-zA-Z-]+)*))?$'
    [int]$Major
    [int]$Minor
    [int]$Patch
    [string]$Prerelease
    [string]$BuildMetadata

    PSSemVer() {
        $this.Major = 0
        $this.Minor = 0
        $this.Patch = 0
        $this.Prerelease = ''
        $this.BuildMetadata = ''
    }

    PSSemVer([int]$Major) {
        $this.Major = $Major
        $this.Minor = 0
        $this.Patch = 0
        $this.Prerelease = ''
        $this.BuildMetadata = ''
    }

    PSSemVer([int]$Major, [int]$Minor) {
        $this.Major = $Major
        $this.Minor = $Minor
        $this.Patch = 0
        $this.Prerelease = ''
        $this.BuildMetadata = ''
    }

    PSSemVer([int]$Major, [int]$Minor, [int]$Patch) {
        $this.Major = $Major
        $this.Minor = $Minor
        $this.Patch = $Patch
        $this.Prerelease = ''
        $this.BuildMetadata = ''
    }

    PSSemVer([int]$Major, [int]$Minor, [int]$Patch, [string]$PreReleaseLabel) {
        $this.Major = $Major
        $this.Minor = $Minor
        $this.Patch = $Patch
        $this.Prerelease = $PreReleaseLabel
        $this.BuildMetadata = ''
    }

    PSSemVer([int]$Major, [int]$Minor, [int]$Patch, [string]$PreReleaseLabel, [string]$BuildLabel) {
        $this.Major = $Major
        $this.Minor = $Minor
        $this.Patch = $Patch
        $this.Prerelease = $PreReleaseLabel
        $this.BuildMetadata = $BuildLabel
    }

    PSSemVer([string]$version) {
        if ($version -match [PSSemVer]::SemVerPattern) {
            $this.Major = [int]$Matches[1]
            $this.Minor = [int]$Matches[2]
            $this.Patch = [int]$Matches[3]
            $this.Prerelease = $Matches[4]
            $this.BuildMetadata = $Matches[5]
        } else {
            # Coerce the string to a PSSemVer object
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

    [void] SetBuildMetadata([string]$label) {
        $this.BuildMetadata = $label
    }

    [PSSemVer] Parse([string]$string) {
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

# Define the types to export with type accelerators.
$ExportableTypes = @(
    [PSSemVer]
)
# Get the internal TypeAccelerators class to use its static methods.
$TypeAcceleratorsClass = [psobject].Assembly.GetType(
    'System.Management.Automation.TypeAccelerators'
)
# Ensure none of the types would clobber an existing type accelerator.
# If a type accelerator with the same name exists, throw an exception.
$ExistingTypeAccelerators = $TypeAcceleratorsClass::Get
foreach ($Type in $ExportableTypes) {
    if ($Type.FullName -in $ExistingTypeAccelerators.Keys) {
        $Message = @(
            "Unable to register type accelerator '$($Type.FullName)'"
            'Accelerator already exists.'
        ) -join ' - '

        throw [System.Management.Automation.ErrorRecord]::new(
            [System.InvalidOperationException]::new($Message),
            'TypeAcceleratorAlreadyExists',
            [System.Management.Automation.ErrorCategory]::InvalidOperation,
            $Type.FullName
        )
    }
}
# Add type accelerators for every exportable type.
foreach ($Type in $ExportableTypes) {
    $TypeAcceleratorsClass::Add($Type.FullName, $Type)
}
# Remove type accelerators when the module is removed.
$MyInvocation.MyCommand.ScriptBlock.Module.OnRemove = {
    foreach ($Type in $ExportableTypes) {
        $TypeAcceleratorsClass::Remove($Type.FullName)
    }
}.GetNewClosure()
