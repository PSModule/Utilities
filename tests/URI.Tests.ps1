[CmdletBinding()]
Param(
    # Path to the module to test.
    [Parameter()]
    [string] $Path
)

Describe 'Join-URI' {
    It "Join-Uri -Path 'https://example.com' -ChildPath 'foo' -AdditionalChildPath 'bar'" {
        $uri = Join-Uri -Path 'https://example.com' -ChildPath 'foo' -AdditionalChildPath 'bar'
        Write-Verbose $uri -Verbose
        Write-Verbose "Should -Be 'https://example.com/foo/bar'" -Verbose
        $uri | Should -Be 'https://example.com/foo/bar'
    }

    It "Join-Uri 'https://example.com/foo' '/bar/' '//baz/something/' '/test/'" {
        $uri = Join-Uri 'https://example.com/foo' '/bar/' '//baz/something/' '/test/'
        Write-Verbose $uri -Verbose
        Write-Verbose "Should -Be 'https://example.com/foo/bar/baz/something/test'" -Verbose
        $uri | Should -Be 'https://example.com/foo/bar/baz/something/test'
    }
}
