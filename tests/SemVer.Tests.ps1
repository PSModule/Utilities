Describe 'New-SemVer' {
    It "Setting Major to 1, Minor to 2, and Patch to 3. Returns a '1.2.3' version." {
        $SemVer = New-SemVer -Major 1 -Minor 2 -Patch 3
        $SemVer.Major | Should -Be 1
        $SemVer.Minor | Should -Be 2
        $SemVer.Patch | Should -Be 3
        $SemVer.Prerelease | Should -BeNullOrEmpty
        $SemVer.BuildMetadata | Should -BeNullOrEmpty
    }
    It "Setting Prerelease to 'alpha'" {
        $SemVer = New-SemVer -Major 1 -Minor 2 -Patch 3 -Prerelease 'alpha'
        $SemVer.Prerelease | Should -Be 'alpha'
    }
    It "Setting BuildMetadata to '654646554'" {
        $SemVer = New-SemVer -Major 1 -Minor 2 -Patch 3 -Build '654646554'
        $SemVer.BuildMetadata | Should -Be '654646554'
    }
    It "With no parameters it returns a '0.0.0' version." {
        $SemVer = New-SemVer
        $SemVer.Major | Should -Be 0
        $SemVer.Minor | Should -Be 0
        $SemVer.Patch | Should -Be 0
        $SemVer.Prerelease | Should -BeNullOrEmpty
        $SemVer.BuildMetadata | Should -BeNullOrEmpty
    }
    It "Takes a string '1.2.3' and returns a '1.2.3' version." {
        $SemVer = New-SemVer -Version '1.2.3'
        $SemVer.Major | Should -Be 1
        $SemVer.Minor | Should -Be 2
        $SemVer.Patch | Should -Be 3
        $SemVer.Prerelease | Should -BeNullOrEmpty
        $SemVer.BuildMetadata | Should -BeNullOrEmpty
    }
}

Describe 'ConvertTo-SemVer' {
    It "Converts '1.2.3' to SemVer using parameters." {
        $SemVer = ConvertTo-SemVer -Version '1.2.3'
        $SemVer.Major | Should -Be 1
        $SemVer.Minor | Should -Be 2
        $SemVer.Patch | Should -Be 3
    }
    It "Converts '1.2.3' to SemVer using pipeline." {
        $SemVer = '1.2.3' | ConvertTo-SemVer
        $SemVer.Major | Should -Be 1
        $SemVer.Minor | Should -Be 2
        $SemVer.Patch | Should -Be 3
    }
    It "Converts '1.2.3-alpha.1+1' to SemVer using parameters." {
        $SemVer = ConvertTo-SemVer -Version '1.2.3-alpha.1+1'
        $SemVer.Major | Should -Be 1
        $SemVer.Minor | Should -Be 2
        $SemVer.Patch | Should -Be 3
        $SemVer.Prerelease | Should -Be 'alpha.1'
        $SemVer.BuildMetadata | Should -Be '1'
    }
    It "Converts null to '0.0.0'." {
        $SemVer = $null | ConvertTo-SemVer
        $SemVer.Major | Should -Be 0
        $SemVer.Minor | Should -Be 0
        $SemVer.Patch | Should -Be 0
        $SemVer.Prerelease | Should -BeNullOrEmpty
        $SemVer.BuildMetadata | Should -BeNullOrEmpty
    }
    It "Converts '' to '0.0.0'." {
        $SemVer = '' | ConvertTo-SemVer
        $SemVer.Major | Should -Be 0
        $SemVer.Minor | Should -Be 0
        $SemVer.Patch | Should -Be 0
        $SemVer.Prerelease | Should -BeNullOrEmpty
        $SemVer.BuildMetadata | Should -BeNullOrEmpty
    }
}

Describe 'Class: ToString()' {
    It "Returns '1.2.3'." {
        $SemVer = New-SemVer -Major 1 -Minor 2 -Patch 3
        Write-Verbose ($SemVer.ToString()) -Verbose
        $SemVer.ToString() | Should -Be '1.2.3'
    }
    It "Returns '1.2.3-alpha.1+001'." {
        $SemVer = New-SemVer -Major 1 -Minor 2 -Patch 3 -Prerelease 'alpha.1' -Build '001'
        Write-Verbose ($SemVer.ToString())
        $SemVer.ToString() | Should -Be '1.2.3-alpha.1+001'
    }
    It "Returns '1.2.3-alpha.1'." {
        $SemVer = New-SemVer -Major 1 -Minor 2 -Patch 3 -Prerelease 'alpha.1'
        Write-Verbose ($SemVer.ToString())
        $SemVer.ToString() | Should -Be '1.2.3-alpha.1'
    }
    It "Returns '1.2.3+001'." {
        $SemVer = New-SemVer -Major 1 -Minor 2 -Patch 3 -Build '001'
        Write-Verbose ($SemVer.ToString())
        $SemVer.ToString() | Should -Be '1.2.3+001'
    }
    It "Returns '1.2.3-alpha.1'." {
        $SemVer = New-SemVer -Major 1 -Minor 2 -Patch 3 -Prerelease 'alpha.1' -Build '001'
        $SemVer.SetBuildLabel('')
        Write-Verbose ($SemVer.ToString())
        $SemVer.ToString() | Should -Be '1.2.3-alpha.1'
    }
    It "Returns '1.2.3+001'." {
        $SemVer = New-SemVer -Major 1 -Minor 2 -Patch 3 -Prerelease 'alpha.1' -Build '001'
        $SemVer.SetPreReleaseLabel('')
        Write-Verbose ($SemVer.ToString())
        $SemVer.ToString() | Should -Be '1.2.3+001'
    }
    It "Returns '1.2.3'." {
        $SemVer = New-SemVer -Major 1 -Minor 2 -Patch 3 -Prerelease 'alpha.1' -Build '001'
        $SemVer.SetPreReleaseLabel('')
        $SemVer.SetBuildLabel('')
        Write-Verbose ($SemVer.ToString())
        $SemVer.ToString() | Should -Be '1.2.3'
    }
}

Describe 'Class: Bump versions' {
    It "Bumps the Major version from 1 to 2." {
        $SemVer = New-SemVer -Major 1 -Minor 2 -Patch 3
        $SemVer.BumpMajor()
        $SemVer.Major | Should -Be 2
        $SemVer.Minor | Should -Be 0
        $SemVer.Patch | Should -Be 0
    }
    It "Bumps the Minor version from 1 to 2." {
        $SemVer = New-SemVer -Major 2 -Minor 1 -Patch 2
        $SemVer.BumpMinor()
        $SemVer.Major | Should -Be 2
        $SemVer.Minor | Should -Be 2
        $SemVer.Patch | Should -Be 0
    }
}

Describe 'Class: Set prerelease and metadata' {
    It "Bumps the Patch version from 1 to 2." {
        $SemVer = New-SemVer -Major 2 -Minor 1 -Patch 1
        $SemVer.BumpPatch()
        $SemVer.Major | Should -Be 2
        $SemVer.Minor | Should -Be 1
        $SemVer.Patch | Should -Be 2
    }
    It "Sets the Prerelease version to 'alpha'." {
        $SemVer = New-SemVer
        $SemVer.SetPreRelease('alpha')
        $SemVer.Major | Should -Be 0
        $SemVer.Minor | Should -Be 0
        $SemVer.Patch | Should -Be 0
        $SemVer.Prerelease | Should -Be 'alpha'
        $SemVer.BuildMetadata | Should -BeNullOrEmpty
    }
    It "Sets the BuildMetadata to '001'." {
        $SemVer = New-SemVer
        $SemVer.SetBuildLabel('001')
        $SemVer.Major | Should -Be 0
        $SemVer.Minor | Should -Be 0
        $SemVer.Patch | Should -Be 0
        $SemVer.Prerelease | Should -BeNullOrEmpty
        $SemVer.BuildMetadata | Should -Be '001'
    }
    It "Sets the Prerelease version to ''." {
        $SemVer = New-SemVer -Prerelease 'alpha'
        $SemVer.SetPreReleaseLabel('')
        $SemVer.Major | Should -Be 0
        $SemVer.Minor | Should -Be 0
        $SemVer.Patch | Should -Be 0
        $SemVer.Prerelease | Should -BeNullOrEmpty
        $SemVer.BuildMetadata | Should -BeNullOrEmpty
    }
    It "Sets the BuildMetadata to ''." {
        $SemVer = New-SemVer -Build '001'
        $SemVer.SetBuildLabel('')
        $SemVer.Major | Should -Be 0
        $SemVer.Minor | Should -Be 0
        $SemVer.Patch | Should -Be 0
        $SemVer.Prerelease | Should -BeNullOrEmpty
        $SemVer.BuildMetadata | Should -BeNullOrEmpty
    }
}

Describe 'Class: Parse' {
    It "Parses '1.2.3' to SemVer." {
        $SemVer = [SemVer]::Parse('1.2.3')
        $SemVer.Major | Should -Be 1
        $SemVer.Minor | Should -Be 2
        $SemVer.Patch | Should -Be 3
    }

    It "Parses '1.2.3-alpha.1+001' to SemVer." {
        $SemVer = [SemVer]::Parse('1.2.3-alpha.1+001')
        $SemVer.Major | Should -Be 1
        $SemVer.Minor | Should -Be 2
        $SemVer.Patch | Should -Be 3
        $SemVer.Prerelease | Should -Be 'alpha.1'
        $SemVer.BuildMetadata | Should -Be '001'
    }

    It "Parses '1.2.3-alpha.1+001' to SemVer." {
        $SemVer = [SemVer]::Parse('1.2.3-alpha.1+001')
        $SemVer.Major | Should -Be 1
        $SemVer.Minor | Should -Be 2
        $SemVer.Patch | Should -Be 3
        $SemVer.Prerelease | Should -Be 'alpha.1'
        $SemVer.BuildMetadata | Should -Be '001'
    }

    It "Compares '1.2.3' to '1.2.3'." {
        $SemVer1 = [SemVer]::Parse('1.2.3')
        $SemVer2 = [SemVer]::Parse('1.2.3')
        $SemVer1.CompareTo($SemVer2) | Should -Be 0
    }
}

Describe "Class: Comparison" {
    It "Compares '1.2.3' as less than '1.2.4'." {
        $SemVer1 = [SemVer]::Parse('1.2.3')
        $SemVer2 = [SemVer]::Parse('1.2.4')
        $SemVer1 -lt $SemVer2 | Should -BeTrue
    }
    It "Compares '1.2.3' as greater than '1.2.2'." {
        $SemVer1 = [SemVer]::Parse('1.2.3')
        $SemVer2 = [SemVer]::Parse('1.2.2')
        $SemVer1 -gt $SemVer2 | Should -BeTrue
    }
    It "Compares '1.2.3' as equal to '1.2.3'." {
        $SemVer1 = [SemVer]::Parse('1.2.3')
        $SemVer2 = [SemVer]::Parse('1.2.3')
        $SemVer1 -eq $SemVer2 | Should -BeTrue
    }
    It "Compares '1.2.3' as not equal to '1.2.4'." {
        $SemVer1 = [SemVer]::Parse('1.2.3')
        $SemVer2 = [SemVer]::Parse('1.2.4')
        $SemVer1 -ne $SemVer2 | Should -BeTrue
    }
    It "Compares '1.2.3' as less than or equal to '1.2.3'." {
        $SemVer1 = [SemVer]::Parse('1.2.3')
        $SemVer2 = [SemVer]::Parse('1.2.3')
        $SemVer1 -le $SemVer2 | Should -BeTrue
    }
    It "Compares '1.2.3' as greater than or equal to '1.2.3'." {
        $SemVer1 = [SemVer]::Parse('1.2.3')
        $SemVer2 = [SemVer]::Parse('1.2.3')
        $SemVer1 -ge $SemVer2 | Should -BeTrue
    }
    It "Compares '1.2.3' as less than or equal to '1.2.4'." {
        $SemVer1 = [SemVer]::Parse('1.2.3')
        $SemVer2 = [SemVer]::Parse('1.2.4')
        $SemVer1 -le $SemVer2 | Should -BeTrue
    }

    It "Compares '1.0.0' as less than '2.0.0'." {
        $SemVer1 = [SemVer]::Parse('1.0.0')
        $SemVer2 = [SemVer]::Parse('2.0.0')
        $SemVer1 -lt $SemVer2 | Should -BeTrue
    }

    It "Compares '2.0.0' as less than '2.1.0'." {
        $SemVer1 = [SemVer]::Parse('2.0.0')
        $SemVer2 = [SemVer]::Parse('2.1.0')
        $SemVer1 -lt $SemVer2 | Should -BeTrue
    }

    It "Compares '2.1.0' as less than '2.1.1'." {
        $SemVer1 = [SemVer]::Parse('2.1.0')
        $SemVer2 = [SemVer]::Parse('2.1.1')
        $SemVer1 -lt $SemVer2 | Should -BeTrue
    }

    It "Compares '1.0.0-alpha' as less than '1.0.0-alpha.1'." {
        $SemVer1 = [SemVer]::Parse('1.0.0-alpha')
        $SemVer2 = [SemVer]::Parse('1.0.0-alpha.1')
        $SemVer1 -lt $SemVer2 | Should -BeTrue
    }

    It "Compares '1.0.0-alpha.1' as less than '1.0.0-alpha.beta'." {
        $SemVer1 = [SemVer]::Parse('1.0.0-alpha.1')
        $SemVer2 = [SemVer]::Parse('1.0.0-alpha.beta')
        $SemVer1 -lt $SemVer2 | Should -BeTrue
    }

    It "Compares '1.0.0-alpha.beta' as less than '1.0.0-beta'." {
        $SemVer1 = [SemVer]::Parse('1.0.0-alpha.beta')
        $SemVer2 = [SemVer]::Parse('1.0.0-beta')
        $SemVer1 -lt $SemVer2 | Should -BeTrue
    }

    It "Compares '1.0.0-beta' as less than '1.0.0-beta.2'." {
        $SemVer1 = [SemVer]::Parse('1.0.0-beta')
        $SemVer2 = [SemVer]::Parse('1.0.0-beta.2')
        $SemVer1 -lt $SemVer2 | Should -BeTrue
    }

    It "Compares '1.0.0-beta.2' as less than '1.0.0-beta.11'." {
        $SemVer1 = [SemVer]::Parse('1.0.0-beta.2')
        $SemVer2 = [SemVer]::Parse('1.0.0-beta.11')
        $SemVer1 -lt $SemVer2 | Should -BeTrue
    }

    It "Compares '1.0.0-beta.11' as less than '1.0.0-rc.1'." {
        $SemVer1 = [SemVer]::Parse('1.0.0-beta.11')
        $SemVer2 = [SemVer]::Parse('1.0.0-rc.1')
        $SemVer1 -lt $SemVer2 | Should -BeTrue
    }

    It "Compares '1.0.0-rc.1' as less than '1.0.0'." {
        $SemVer1 = [SemVer]::Parse('1.0.0-rc.1')
        $SemVer2 = [SemVer]::Parse('1.0.0')
        $SemVer1 -lt $SemVer2 | Should -BeTrue
    }
}

Describe "Class: Handles prefix" {
    It "Parses 'v1.2.3' to SemVer." {
        $SemVer = [SemVer]::Parse('v1.2.3')
        $SemVer.Prefix | Should -Be 'v'
        $SemVer.Major | Should -Be 1
        $SemVer.Minor | Should -Be 2
        $SemVer.Patch | Should -Be 3
    }
    It "Parses 'v1.2.3-alpha.1+001' to SemVer." {
        $SemVer = [SemVer]::Parse('v1.2.3-alpha.1+001')
        $SemVer.Prefix | Should -Be 'v'
        $SemVer.Major | Should -Be 1
        $SemVer.Minor | Should -Be 2
        $SemVer.Patch | Should -Be 3
        $SemVer.Prerelease | Should -Be 'alpha.1'
        $SemVer.BuildMetadata | Should -Be '001'
    }
    It "Parses 'v1.2.3-alpha.1+001' to SemVer." {
        $SemVer = [SemVer]::Parse('v1.2.3-alpha.1+001')
        $SemVer.Prefix | Should -Be 'v'
        $SemVer.Major | Should -Be 1
        $SemVer.Minor | Should -Be 2
        $SemVer.Patch | Should -Be 3
        $SemVer.Prerelease | Should -Be 'alpha.1'
        $SemVer.BuildMetadata | Should -Be '001'
    }
    It "Compares 'v1.2.3' as less than 'v1.2.4'." {
        $SemVer1 = [SemVer]::Parse('v1.2.3')
        $SemVer2 = [SemVer]::Parse('v1.2.4')
        $SemVer1 -lt $SemVer2 | Should -BeTrue
    }
    It "Compares 'v1.2.3' as greater than 'v1.2.2'." {
        $SemVer1 = [SemVer]::Parse('v1.2.3')
        $SemVer2 = [SemVer]::Parse('v1.2.2')
        $SemVer1 -gt $SemVer2 | Should -BeTrue
    }
}
