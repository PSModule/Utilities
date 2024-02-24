using module Utilities

Describe 'New-SemVer' {
    It "Setting Major to 1, Minor to 2, and Patch to 3. Returns a '1.2.3' version." {
        $semver = New-SemVer -Major 1 -Minor 2 -Patch 3
        $semver.Major | Should -Be 1
        $semver.Minor | Should -Be 2
        $semver.Patch | Should -Be 3
        $semver.Prerelease | Should -BeNullOrEmpty
        $semver.BuildMetadata | Should -BeNullOrEmpty
    }
    It "Setting Prerelease to 'alpha'" {
        $semver = New-SemVer -Major 1 -Minor 2 -Patch 3 -Prerelease 'alpha'
        $semver.Prerelease | Should -Be 'alpha'
    }
    It "Setting BuildMetadata to '654646554'" {
        $semver = New-SemVer -Major 1 -Minor 2 -Patch 3 -Build '654646554'
        $semver.BuildMetadata | Should -Be '654646554'
    }
    It "With no parameters it returns a '0.0.0' version." {
        $semver = New-SemVer
        $semver.Major | Should -Be 0
        $semver.Minor | Should -Be 0
        $semver.Patch | Should -Be 0
        $semver.Prerelease | Should -BeNullOrEmpty
        $semver.BuildMetadata | Should -BeNullOrEmpty
    }
}

Describe 'ConvertTo-SemVer' {
    It "Converts '1.2.3' to SemVer using parameters." {
        $semver = ConvertTo-SemVer -Version '1.2.3'
        $semver.Major | Should -Be 1
        $semver.Minor | Should -Be 2
        $semver.Patch | Should -Be 3
    }
    It "Converts '1.2.3' to SemVer using pipeline." {
        $semver = '1.2.3' | ConvertTo-SemVer
        $semver.Major | Should -Be 1
        $semver.Minor | Should -Be 2
        $semver.Patch | Should -Be 3
    }
    It "Converts '1.2.3-alpha.1+1' to SemVer using parameters." {
        $semver = ConvertTo-SemVer -Version '1.2.3-alpha.1+1'
        $semver.Major | Should -Be 1
        $semver.Minor | Should -Be 2
        $semver.Patch | Should -Be 3
        $semver.Prerelease | Should -Be 'alpha.1'
        $semver.BuildMetadata | Should -Be '1'
    }
    It "Converts null to '0.0.0'." {
        $semver = $null | ConvertTo-SemVer
        $semver.Major | Should -Be 0
        $semver.Minor | Should -Be 0
        $semver.Patch | Should -Be 0
        $semver.Prerelease | Should -BeNullOrEmpty
        $semver.BuildMetadata | Should -BeNullOrEmpty
    }
    It "Converts '' to '0.0.0'." {
        $semver = '' | ConvertTo-SemVer
        $semver.Major | Should -Be 0
        $semver.Minor | Should -Be 0
        $semver.Patch | Should -Be 0
        $semver.Prerelease | Should -BeNullOrEmpty
        $semver.BuildMetadata | Should -BeNullOrEmpty
    }
}

Describe 'Class: ToString()' {
    It "Returns '1.2.3'." {
        $semver = New-SemVer -Major 1 -Minor 2 -Patch 3
        Write-Verbose ($semver.ToString()) -Verbose
        $semver.ToString() | Should -Be '1.2.3'
    }
    It "Returns '1.2.3-alpha.1+001'." {
        $semver = New-SemVer -Major 1 -Minor 2 -Patch 3 -Prerelease 'alpha.1' -Build '001'
        Write-Verbose ($semver.ToString())
        $semver.ToString() | Should -Be '1.2.3-alpha.1+001'
    }
    It "Returns '1.2.3-alpha.1'." {
        $semver = New-SemVer -Major 1 -Minor 2 -Patch 3 -Prerelease 'alpha.1'
        Write-Verbose ($semver.ToString())
        $semver.ToString() | Should -Be '1.2.3-alpha.1'
    }
    It "Returns '1.2.3+001'." {
        $semver = New-SemVer -Major 1 -Minor 2 -Patch 3 -Build '001'
        Write-Verbose ($semver.ToString())
        $semver.ToString() | Should -Be '1.2.3+001'
    }
    It "Returns '1.2.3-alpha.1'." {
        $semver = New-SemVer -Major 1 -Minor 2 -Patch 3 -Prerelease 'alpha.1' -Build '001'
        $semver.SetBuildLabel('')
        Write-Verbose ($semver.ToString())
        $semver.ToString() | Should -Be '1.2.3-alpha.1'
    }
    It "Returns '1.2.3+001'." {
        $semver = New-SemVer -Major 1 -Minor 2 -Patch 3 -Prerelease 'alpha.1' -Build '001'
        $semver.SetPreReleaseLabel('')
        Write-Verbose ($semver.ToString())
        $semver.ToString() | Should -Be '1.2.3+001'
    }
    It "Returns '1.2.3'." {
        $semver = New-SemVer -Major 1 -Minor 2 -Patch 3 -Prerelease 'alpha.1' -Build '001'
        $semver.SetPreReleaseLabel('')
        $semver.SetBuildLabel('')
        Write-Verbose ($semver.ToString())
        $semver.ToString() | Should -Be '1.2.3'
    }
}

Describe 'Class: Bump versions' {
    It "Bumps the Major version from 1 to 2." {
        $semver = New-SemVer -Major 1 -Minor 2 -Patch 3
        $semver.BumpMajor()
        $semver.Major | Should -Be 2
        $semver.Minor | Should -Be 0
        $semver.Patch | Should -Be 0
    }
    It "Bumps the Minor version from 1 to 2." {
        $semver = New-SemVer -Major 2 -Minor 1 -Patch 2
        $semver.BumpMinor()
        $semver.Major | Should -Be 2
        $semver.Minor | Should -Be 2
        $semver.Patch | Should -Be 0
    }
}

Describe 'Class: Set prerelease and metadata' {
    It "Bumps the Patch version from 1 to 2." {
        $semver = New-SemVer -Major 2 -Minor 1 -Patch 1
        $semver.BumpPatch()
        $semver.Major | Should -Be 2
        $semver.Minor | Should -Be 1
        $semver.Patch | Should -Be 2
    }
    It "Sets the Prerelease version to 'alpha'." {
        $semver = New-SemVer
        $semver.SetPreRelease('alpha')
        $semver.Major | Should -Be 0
        $semver.Minor | Should -Be 0
        $semver.Patch | Should -Be 0
        $semver.Prerelease | Should -Be 'alpha'
        $semver.BuildMetadata | Should -BeNullOrEmpty
    }
    It "Sets the BuildMetadata to '001'." {
        $semver = New-SemVer
        $semver.SetBuildLabel('001')
        $semver.Major | Should -Be 0
        $semver.Minor | Should -Be 0
        $semver.Patch | Should -Be 0
        $semver.Prerelease | Should -BeNullOrEmpty
        $semver.BuildMetadata | Should -Be '001'
    }
    It "Sets the Prerelease version to ''." {
        $semver = New-SemVer -Prerelease 'alpha'
        $semver.SetPreReleaseLabel('')
        $semver.Major | Should -Be 0
        $semver.Minor | Should -Be 0
        $semver.Patch | Should -Be 0
        $semver.Prerelease | Should -BeNullOrEmpty
        $semver.BuildMetadata | Should -BeNullOrEmpty
    }
    It "Sets the BuildMetadata to ''." {
        $semver = New-SemVer -Build '001'
        $semver.SetBuildLabel('')
        $semver.Major | Should -Be 0
        $semver.Minor | Should -Be 0
        $semver.Patch | Should -Be 0
        $semver.Prerelease | Should -BeNullOrEmpty
        $semver.BuildMetadata | Should -BeNullOrEmpty
    }
}

Describe 'Class: Parse' {
    It "Parses '1.2.3' to SemVer." {
        $semver = [PSSemVer]::Parse('1.2.3')
        $semver.Major | Should -Be 1
        $semver.Minor | Should -Be 2
        $semver.Patch | Should -Be 3
    }

    It "Parses '1.2.3-alpha.1+001' to SemVer." {
        $semver = [PSSemVer]::Parse('1.2.3-alpha.1+001')
        $semver.Major | Should -Be 1
        $semver.Minor | Should -Be 2
        $semver.Patch | Should -Be 3
        $semver.Prerelease | Should -Be 'alpha.1'
        $semver.BuildMetadata | Should -Be '001'
    }

    It "Parses '1.2.3-alpha.1+001' to SemVer." {
        $semver = [PSSemVer]::Parse('1.2.3-alpha.1+001')
        $semver.Major | Should -Be 1
        $semver.Minor | Should -Be 2
        $semver.Patch | Should -Be 3
        $semver.Prerelease | Should -Be 'alpha.1'
        $semver.BuildMetadata | Should -Be '001'
    }

    It "Compares '1.2.3' to '1.2.3'." {
        $semver1 = [PSSemVer]::Parse('1.2.3')
        $semver2 = [PSSemVer]::Parse('1.2.3')
        $semver1.CompareTo($semver2) | Should -Be 0
    }
}

Describe "Class: Comparison" {
    It "Compares '1.2.3' as less than '1.2.4'." {
        $semver1 = [PSSemVer]::Parse('1.2.3')
        $semver2 = [PSSemVer]::Parse('1.2.4')
        $semver1 -lt $semver2 | Should -BeTrue
    }
    It "Compares '1.2.3' as greater than '1.2.2'." {
        $semver1 = [PSSemVer]::Parse('1.2.3')
        $semver2 = [PSSemVer]::Parse('1.2.2')
        $semver1 -gt $semver2 | Should -BeTrue
    }
    It "Compares '1.2.3' as equal to '1.2.3'." {
        $semver1 = [PSSemVer]::Parse('1.2.3')
        $semver2 = [PSSemVer]::Parse('1.2.3')
        $semver1 -eq $semver2 | Should -BeTrue
    }
    It "Compares '1.2.3' as not equal to '1.2.4'." {
        $semver1 = [PSSemVer]::Parse('1.2.3')
        $semver2 = [PSSemVer]::Parse('1.2.4')
        $semver1 -ne $semver2 | Should -BeTrue
    }
    It "Compares '1.2.3' as less than or equal to '1.2.3'." {
        $semver1 = [PSSemVer]::Parse('1.2.3')
        $semver2 = [PSSemVer]::Parse('1.2.3')
        $semver1 -le $semver2 | Should -BeTrue
    }
    It "Compares '1.2.3' as greater than or equal to '1.2.3'." {
        $semver1 = [PSSemVer]::Parse('1.2.3')
        $semver2 = [PSSemVer]::Parse('1.2.3')
        $semver1 -ge $semver2 | Should -BeTrue
    }
    It "Compares '1.2.3' as less than or equal to '1.2.4'." {
        $semver1 = [PSSemVer]::Parse('1.2.3')
        $semver2 = [PSSemVer]::Parse('1.2.4')
        $semver1 -le $semver2 | Should -BeTrue
    }
}
