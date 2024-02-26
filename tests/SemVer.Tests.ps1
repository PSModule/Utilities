Describe 'New-SemVer' {
    It "Setting Major to 1, Minor to 2, and Patch to 3. Returns a '1.2.3' version." {
        $PSSemVer = New-SemVer -Major 1 -Minor 2 -Patch 3
        $PSSemVer.Major | Should -Be 1
        $PSSemVer.Minor | Should -Be 2
        $PSSemVer.Patch | Should -Be 3
        $PSSemVer.Prerelease | Should -BeNullOrEmpty
        $PSSemVer.BuildMetadata | Should -BeNullOrEmpty
    }
    It "Setting Prerelease to 'alpha'" {
        $PSSemVer = New-SemVer -Major 1 -Minor 2 -Patch 3 -Prerelease 'alpha'
        $PSSemVer.Prerelease | Should -Be 'alpha'
    }
    It "Setting BuildMetadata to '654646554'" {
        $PSSemVer = New-SemVer -Major 1 -Minor 2 -Patch 3 -Build '654646554'
        $PSSemVer.BuildMetadata | Should -Be '654646554'
    }
    It "With no parameters it returns a '0.0.0' version." {
        $PSSemVer = New-SemVer
        $PSSemVer.Major | Should -Be 0
        $PSSemVer.Minor | Should -Be 0
        $PSSemVer.Patch | Should -Be 0
        $PSSemVer.Prerelease | Should -BeNullOrEmpty
        $PSSemVer.BuildMetadata | Should -BeNullOrEmpty
    }
    It "Takes a string '1.2.3' and returns a '1.2.3' version." {
        $PSSemVer = New-SemVer -Version '1.2.3'
        $PSSemVer.Major | Should -Be 1
        $PSSemVer.Minor | Should -Be 2
        $PSSemVer.Patch | Should -Be 3
        $PSSemVer.Prerelease | Should -BeNullOrEmpty
        $PSSemVer.BuildMetadata | Should -BeNullOrEmpty
    }
}

Describe 'ConvertTo-SemVer' {
    It "Converts '1.2.3' to PSSemVer using parameters." {
        $PSSemVer = ConvertTo-SemVer -Version '1.2.3'
        $PSSemVer.Major | Should -Be 1
        $PSSemVer.Minor | Should -Be 2
        $PSSemVer.Patch | Should -Be 3
    }
    It "Converts '1.2.3' to PSSemVer using pipeline." {
        $PSSemVer = '1.2.3' | ConvertTo-SemVer
        $PSSemVer.Major | Should -Be 1
        $PSSemVer.Minor | Should -Be 2
        $PSSemVer.Patch | Should -Be 3
    }
    It "Converts '1.2.3-alpha.1+1' to PSSemVer using parameters." {
        $PSSemVer = ConvertTo-SemVer -Version '1.2.3-alpha.1+1'
        $PSSemVer.Major | Should -Be 1
        $PSSemVer.Minor | Should -Be 2
        $PSSemVer.Patch | Should -Be 3
        $PSSemVer.Prerelease | Should -Be 'alpha.1'
        $PSSemVer.BuildMetadata | Should -Be '1'
    }
    It "Converts null to '0.0.0'." {
        $PSSemVer = $null | ConvertTo-SemVer
        $PSSemVer.Major | Should -Be 0
        $PSSemVer.Minor | Should -Be 0
        $PSSemVer.Patch | Should -Be 0
        $PSSemVer.Prerelease | Should -BeNullOrEmpty
        $PSSemVer.BuildMetadata | Should -BeNullOrEmpty
    }
    It "Converts '' to '0.0.0'." {
        $PSSemVer = '' | ConvertTo-SemVer
        $PSSemVer.Major | Should -Be 0
        $PSSemVer.Minor | Should -Be 0
        $PSSemVer.Patch | Should -Be 0
        $PSSemVer.Prerelease | Should -BeNullOrEmpty
        $PSSemVer.BuildMetadata | Should -BeNullOrEmpty
    }
}

Describe 'Class: ToString()' {
    It "Returns '1.2.3'." {
        $PSSemVer = New-SemVer -Major 1 -Minor 2 -Patch 3
        Write-Verbose ($PSSemVer.ToString()) -Verbose
        $PSSemVer.ToString() | Should -Be '1.2.3'
    }
    It "Returns '1.2.3-alpha.1+001'." {
        $PSSemVer = New-SemVer -Major 1 -Minor 2 -Patch 3 -Prerelease 'alpha.1' -Build '001'
        Write-Verbose ($PSSemVer.ToString())
        $PSSemVer.ToString() | Should -Be '1.2.3-alpha.1+001'
    }
    It "Returns '1.2.3-alpha.1'." {
        $PSSemVer = New-SemVer -Major 1 -Minor 2 -Patch 3 -Prerelease 'alpha.1'
        Write-Verbose ($PSSemVer.ToString())
        $PSSemVer.ToString() | Should -Be '1.2.3-alpha.1'
    }
    It "Returns '1.2.3+001'." {
        $PSSemVer = New-SemVer -Major 1 -Minor 2 -Patch 3 -Build '001'
        Write-Verbose ($PSSemVer.ToString())
        $PSSemVer.ToString() | Should -Be '1.2.3+001'
    }
    It "Returns '1.2.3-alpha.1'." {
        $PSSemVer = New-SemVer -Major 1 -Minor 2 -Patch 3 -Prerelease 'alpha.1' -Build '001'
        $PSSemVer.SetBuildLabel('')
        Write-Verbose ($PSSemVer.ToString())
        $PSSemVer.ToString() | Should -Be '1.2.3-alpha.1'
    }
    It "Returns '1.2.3+001'." {
        $PSSemVer = New-SemVer -Major 1 -Minor 2 -Patch 3 -Prerelease 'alpha.1' -Build '001'
        $PSSemVer.SetPreReleaseLabel('')
        Write-Verbose ($PSSemVer.ToString())
        $PSSemVer.ToString() | Should -Be '1.2.3+001'
    }
    It "Returns '1.2.3'." {
        $PSSemVer = New-SemVer -Major 1 -Minor 2 -Patch 3 -Prerelease 'alpha.1' -Build '001'
        $PSSemVer.SetPreReleaseLabel('')
        $PSSemVer.SetBuildLabel('')
        Write-Verbose ($PSSemVer.ToString())
        $PSSemVer.ToString() | Should -Be '1.2.3'
    }
}

Describe 'Class: Bump versions' {
    It 'Bumps the Major version from 1 to 2.' {
        $PSSemVer = New-SemVer -Major 1 -Minor 2 -Patch 3
        $PSSemVer.BumpMajor()
        $PSSemVer.Major | Should -Be 2
        $PSSemVer.Minor | Should -Be 0
        $PSSemVer.Patch | Should -Be 0
    }
    It 'Bumps the Minor version from 1 to 2.' {
        $PSSemVer = New-SemVer -Major 2 -Minor 1 -Patch 2
        $PSSemVer.BumpMinor()
        $PSSemVer.Major | Should -Be 2
        $PSSemVer.Minor | Should -Be 2
        $PSSemVer.Patch | Should -Be 0
    }
    It 'Bumps the Patch version from 1 to 2.' {
        $PSSemVer = New-SemVer -Major 2 -Minor 1 -Patch 1
        $PSSemVer.BumpPatch()
        $PSSemVer.Major | Should -Be 2
        $PSSemVer.Minor | Should -Be 1
        $PSSemVer.Patch | Should -Be 2
    }
    It "Bumps the Prerelease version from 'alpha' to 'alpha.1'." {
        $PSSemVer = New-SemVer -Major 2 -Minor 1 -Patch 1 -Prerelease 'alpha'
        $PSSemVer.BumpPrereleaseNumber()
        $PSSemVer.Major | Should -Be 2
        $PSSemVer.Minor | Should -Be 1
        $PSSemVer.Patch | Should -Be 1
        $PSSemVer.Prerelease | Should -Be 'alpha.1'
    }
    It "Bumps the Prerelease version from 'alpha.1' to 'alpha.2'." {
        $PSSemVer = New-SemVer -Major 2 -Minor 1 -Patch 1 -Prerelease 'alpha.1'
        $PSSemVer.BumpPrereleaseNumber()
        $PSSemVer.Major | Should -Be 2
        $PSSemVer.Minor | Should -Be 1
        $PSSemVer.Patch | Should -Be 1
        $PSSemVer.Prerelease | Should -Be 'alpha.2'
    }
}

Describe 'Class: Set prerelease and metadata' {
    It "Sets the Prerelease version to 'alpha'." {
        $PSSemVer = New-SemVer
        $PSSemVer.SetPreRelease('alpha')
        $PSSemVer.Major | Should -Be 0
        $PSSemVer.Minor | Should -Be 0
        $PSSemVer.Patch | Should -Be 0
        $PSSemVer.Prerelease | Should -Be 'alpha'
        $PSSemVer.BuildMetadata | Should -BeNullOrEmpty
    }
    It "Sets the BuildMetadata to '001'." {
        $PSSemVer = New-SemVer
        $PSSemVer.SetBuildLabel('001')
        $PSSemVer.Major | Should -Be 0
        $PSSemVer.Minor | Should -Be 0
        $PSSemVer.Patch | Should -Be 0
        $PSSemVer.Prerelease | Should -BeNullOrEmpty
        $PSSemVer.BuildMetadata | Should -Be '001'
    }
    It "Sets the Prerelease version to ''." {
        $PSSemVer = New-SemVer -Prerelease 'alpha'
        $PSSemVer.SetPreReleaseLabel('')
        $PSSemVer.Major | Should -Be 0
        $PSSemVer.Minor | Should -Be 0
        $PSSemVer.Patch | Should -Be 0
        $PSSemVer.Prerelease | Should -BeNullOrEmpty
        $PSSemVer.BuildMetadata | Should -BeNullOrEmpty
    }
    It "Sets the Prerelease version to '`$null'." {
        $PSSemVer = New-SemVer -Prerelease 'alpha'
        $PSSemVer.SetPreReleaseLabel($null)
        $PSSemVer.Major | Should -Be 0
        $PSSemVer.Minor | Should -Be 0
        $PSSemVer.Patch | Should -Be 0
        $PSSemVer.Prerelease | Should -BeNullOrEmpty
        $PSSemVer.BuildMetadata | Should -BeNullOrEmpty
    }
    It "Sets the BuildMetadata to ''." {
        $PSSemVer = New-SemVer -Build '001'
        $PSSemVer.SetBuildLabel('')
        $PSSemVer.Major | Should -Be 0
        $PSSemVer.Minor | Should -Be 0
        $PSSemVer.Patch | Should -Be 0
        $PSSemVer.Prerelease | Should -BeNullOrEmpty
        $PSSemVer.BuildMetadata | Should -BeNullOrEmpty
    }
    It "Sets the BuildMetadata to '`$null'." {
        $PSSemVer = New-SemVer -Build '001'
        $PSSemVer.SetBuildLabel($null)
        $PSSemVer.Major | Should -Be 0
        $PSSemVer.Minor | Should -Be 0
        $PSSemVer.Patch | Should -Be 0
        $PSSemVer.Prerelease | Should -BeNullOrEmpty
        $PSSemVer.BuildMetadata | Should -BeNullOrEmpty
    }
}

Describe 'Class: Parse' {
    It "Parses '1.2.3' to PSSemVer." {
        $PSSemVer = [PSSemVer]::Parse('1.2.3')
        $PSSemVer.Major | Should -Be 1
        $PSSemVer.Minor | Should -Be 2
        $PSSemVer.Patch | Should -Be 3
    }

    It "Parses '1.2.3-alpha.1+001' to PSSemVer." {
        $PSSemVer = [PSSemVer]::Parse('1.2.3-alpha.1+001')
        $PSSemVer.Major | Should -Be 1
        $PSSemVer.Minor | Should -Be 2
        $PSSemVer.Patch | Should -Be 3
        $PSSemVer.Prerelease | Should -Be 'alpha.1'
        $PSSemVer.BuildMetadata | Should -Be '001'
    }

    It "Parses '1.2.3-alpha.1+001' to PSSemVer." {
        $PSSemVer = [PSSemVer]::Parse('1.2.3-alpha.1+001')
        $PSSemVer.Major | Should -Be 1
        $PSSemVer.Minor | Should -Be 2
        $PSSemVer.Patch | Should -Be 3
        $PSSemVer.Prerelease | Should -Be 'alpha.1'
        $PSSemVer.BuildMetadata | Should -Be '001'
    }

    It "Constructs [PSSemVer]'1.2.3-alpha.1+001' to PSSemVer." {
        $PSSemVer = [PSSemVer]'1.2.3-alpha.1+001'
        $PSSemVer.Major | Should -Be 1
        $PSSemVer.Minor | Should -Be 2
        $PSSemVer.Patch | Should -Be 3
        $PSSemVer.Prerelease | Should -Be 'alpha.1'
        $PSSemVer.BuildMetadata | Should -Be '001'
    }
}

Describe 'Class: Comparison' {
    It "Compares '1.2.3' as less than '1.2.4'." {
        $PSSemVer1 = [PSSemVer]::Parse('1.2.3')
        $PSSemVer2 = [PSSemVer]::Parse('1.2.4')
        $PSSemVer1 -lt $PSSemVer2 | Should -BeTrue
    }
    It "Compares '1.2.3' as greater than '1.2.2'." {
        $PSSemVer1 = [PSSemVer]::Parse('1.2.3')
        $PSSemVer2 = [PSSemVer]::Parse('1.2.2')
        $PSSemVer1 -gt $PSSemVer2 | Should -BeTrue
    }
    It "Compares '1.2.3' as equal to '1.2.3'." {
        $PSSemVer1 = [PSSemVer]::Parse('1.2.3')
        $PSSemVer2 = [PSSemVer]::Parse('1.2.3')
        $PSSemVer1 -eq $PSSemVer2 | Should -BeTrue
    }
    It "Compares '1.2.3' as not equal to '1.2.4'." {
        $PSSemVer1 = [PSSemVer]::Parse('1.2.3')
        $PSSemVer2 = [PSSemVer]::Parse('1.2.4')
        $PSSemVer1 -ne $PSSemVer2 | Should -BeTrue
    }
    It "Compares '1.2.3' as less than or equal to '1.2.3'." {
        $PSSemVer1 = [PSSemVer]::Parse('1.2.3')
        $PSSemVer2 = [PSSemVer]::Parse('1.2.3')
        $PSSemVer1 -le $PSSemVer2 | Should -BeTrue
    }
    It "Compares '1.2.3' as greater than or equal to '1.2.3'." {
        $PSSemVer1 = [PSSemVer]::Parse('1.2.3')
        $PSSemVer2 = [PSSemVer]::Parse('1.2.3')
        $PSSemVer1 -ge $PSSemVer2 | Should -BeTrue
    }
    It "Compares '1.2.3' as less than or equal to '1.2.4'." {
        $PSSemVer1 = [PSSemVer]::Parse('1.2.3')
        $PSSemVer2 = [PSSemVer]::Parse('1.2.4')
        $PSSemVer1 -le $PSSemVer2 | Should -BeTrue
    }

    It "Compares '1.0.0' as less than '2.0.0'." {
        $PSSemVer1 = [PSSemVer]::Parse('1.0.0')
        $PSSemVer2 = [PSSemVer]::Parse('2.0.0')
        $PSSemVer1 -lt $PSSemVer2 | Should -BeTrue
    }

    It "Compares '2.0.0' as less than '2.1.0'." {
        $PSSemVer1 = [PSSemVer]::Parse('2.0.0')
        $PSSemVer2 = [PSSemVer]::Parse('2.1.0')
        $PSSemVer1 -lt $PSSemVer2 | Should -BeTrue
    }

    It "Compares '2.1.0' as less than '2.1.1'." {
        $PSSemVer1 = [PSSemVer]::Parse('2.1.0')
        $PSSemVer2 = [PSSemVer]::Parse('2.1.1')
        $PSSemVer1 -lt $PSSemVer2 | Should -BeTrue
    }

    It "Compares '1.0.0-alpha' as less than '1.0.0-alpha.1'." {
        $PSSemVer1 = [PSSemVer]::Parse('1.0.0-alpha')
        $PSSemVer2 = [PSSemVer]::Parse('1.0.0-alpha.1')
        $PSSemVer1 -lt $PSSemVer2 | Should -BeTrue
    }

    It "Compares '1.0.0-alpha.1' as less than '1.0.0-alpha.beta'." {
        $PSSemVer1 = [PSSemVer]::Parse('1.0.0-alpha.1')
        $PSSemVer2 = [PSSemVer]::Parse('1.0.0-alpha.beta')
        $PSSemVer1 -lt $PSSemVer2 | Should -BeTrue
    }

    It "Compares '1.0.0-alpha.beta' as less than '1.0.0-beta'." {
        $PSSemVer1 = [PSSemVer]::Parse('1.0.0-alpha.beta')
        $PSSemVer2 = [PSSemVer]::Parse('1.0.0-beta')
        $PSSemVer1 -lt $PSSemVer2 | Should -BeTrue
    }

    It "Compares '1.0.0-beta' as less than '1.0.0-beta.2'." {
        $PSSemVer1 = [PSSemVer]::Parse('1.0.0-beta')
        $PSSemVer2 = [PSSemVer]::Parse('1.0.0-beta.2')
        $PSSemVer1 -lt $PSSemVer2 | Should -BeTrue
    }

    It "Compares '1.0.0-beta.2' as less than '1.0.0-beta.11'." {
        $PSSemVer1 = [PSSemVer]::Parse('1.0.0-beta.2')
        $PSSemVer2 = [PSSemVer]::Parse('1.0.0-beta.11')
        $PSSemVer1 -lt $PSSemVer2 | Should -BeTrue
    }

    It "Compares '1.0.0-beta.11' as less than '1.0.0-rc.1'." {
        $PSSemVer1 = [PSSemVer]::Parse('1.0.0-beta.11')
        $PSSemVer2 = [PSSemVer]::Parse('1.0.0-rc.1')
        $PSSemVer1 -lt $PSSemVer2 | Should -BeTrue
    }

    It "Compares '1.0.0-rc.1' as less than '1.0.0'." {
        $PSSemVer1 = [PSSemVer]::Parse('1.0.0-rc.1')
        $PSSemVer2 = [PSSemVer]::Parse('1.0.0')
        $PSSemVer1 -lt $PSSemVer2 | Should -BeTrue
    }
}

Describe 'Class: Handles prefix' {
    It "Parses 'v1.2.3' to PSSemVer." {
        $PSSemVer = [PSSemVer]::Parse('v1.2.3')
        $PSSemVer.Prefix | Should -Be 'v'
        $PSSemVer.Major | Should -Be 1
        $PSSemVer.Minor | Should -Be 2
        $PSSemVer.Patch | Should -Be 3
    }
    It "Parses 'v1.2.3-alpha.1+001' to PSSemVer." {
        $PSSemVer = [PSSemVer]::Parse('v1.2.3-alpha.1+001')
        $PSSemVer.Prefix | Should -Be 'v'
        $PSSemVer.Major | Should -Be 1
        $PSSemVer.Minor | Should -Be 2
        $PSSemVer.Patch | Should -Be 3
        $PSSemVer.Prerelease | Should -Be 'alpha.1'
        $PSSemVer.BuildMetadata | Should -Be '001'
    }
    It "Parses 'v-1.2.3-alpha.1+001' to PSSemVer." {
        $PSSemVer = [PSSemVer]::Parse('v-1.2.3-alpha.1+001')
        $PSSemVer.Prefix | Should -Be 'v'
        $PSSemVer.Major | Should -Be 1
        $PSSemVer.Minor | Should -Be 2
        $PSSemVer.Patch | Should -Be 3
        $PSSemVer.Prerelease | Should -Be 'alpha.1'
        $PSSemVer.BuildMetadata | Should -Be '001'
    }
    It "Parses 'v1.2.3-alpha.1+001' to PSSemVer." {
        $PSSemVer = [PSSemVer]::Parse('v1.2.3-alpha.1+001')
        $PSSemVer.Prefix | Should -Be 'v'
        $PSSemVer.Major | Should -Be 1
        $PSSemVer.Minor | Should -Be 2
        $PSSemVer.Patch | Should -Be 3
        $PSSemVer.Prerelease | Should -Be 'alpha.1'
        $PSSemVer.BuildMetadata | Should -Be '001'
    }
    It "Parses 'v10.2.3-alpha.1+001' to PSSemVer." {
        $PSSemVer = [PSSemVer]::Parse('v1.2.3-alpha.1+001')
        $PSSemVer.Prefix | Should -Be 'v'
        $PSSemVer.Major | Should -Be 10
        $PSSemVer.Minor | Should -Be 2
        $PSSemVer.Patch | Should -Be 3
        $PSSemVer.Prerelease | Should -Be 'alpha.1'
        $PSSemVer.BuildMetadata | Should -Be '001'
    }
    It "Parses 'vca10.2.3-alpha.1+001' to PSSemVer." {
        $PSSemVer = [PSSemVer]::Parse('v1.2.3-alpha.1+001')
        $PSSemVer.Prefix | Should -Be 'vca'
        $PSSemVer.Major | Should -Be 1
        $PSSemVer.Minor | Should -Be 2
        $PSSemVer.Patch | Should -Be 3
        $PSSemVer.Prerelease | Should -Be 'alpha.1'
        $PSSemVer.BuildMetadata | Should -Be '001'
    }
    It "Compares 'v1.2.3' as less than 'v1.2.4'." {
        $PSSemVer1 = [PSSemVer]::Parse('v1.2.3')
        $PSSemVer2 = [PSSemVer]::Parse('v1.2.4')
        $PSSemVer1 -lt $PSSemVer2 | Should -BeTrue
    }
    It "Compares 'v1.2.3' as greater than 'v1.2.2'." {
        $PSSemVer1 = [PSSemVer]::Parse('v1.2.3')
        $PSSemVer2 = [PSSemVer]::Parse('v1.2.2')
        $PSSemVer1 -gt $PSSemVer2 | Should -BeTrue
    }
}
