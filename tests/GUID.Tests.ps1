[CmdletBinding()]
Param(
    # Path to the module to test.
    [Parameter()]
    [string] $Path
)

Describe "Search-GUID" {
    It "Should return a GUID" {
        $GUID = '123e4567-e89b-12d3-a456-426655440000' | Search-GUID
        $GUID | Should -Be "123e4567-e89b-12d3-a456-426655440000"
    }
}

Describe "Test-GUID" {
    It "Should return a GUID" {
        $GUID = '123e4567-e89b-12d3-a456-426655440000' | Test-IsGUID
        $guid | Should -BeTrue
    }
}
