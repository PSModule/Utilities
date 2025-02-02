function Join-Uri {
    <#
        .SYNOPSIS
        Join a base URI with a child paths.

        .DESCRIPTION
        Join a base URI with a child paths to create a new URI.
        The child paths are normalized before joining with the base URI.

        .EXAMPLE
        Join-Uri -Path 'https://example.com' -ChildPath 'foo' -AdditionalChildPath 'bar'
        https://example.com/foo/bar

        Joins the base URI <https://example.com> with the child paths 'foo' and 'bar' to create the URI <https://example.com/foo/bar>.

        .EXAMPLE
        Join-Uri 'https://example.com' '/foo/' '/bar/' '//baz/something/' '/test/'

        <https://example.com/foo/bar/baz/something/test>

        Combines the base URI <https://example.com> with the child paths '/foo/', '/bar/', '//baz/something/', and '/test/'.

    #>
    [OutputType([uri])]
    [CmdletBinding()]
    param (
        # The base URI to join with the child path.
        [Parameter(Mandatory)]
        [uri]$Path,

        # The child path to join with the base URI.
        [Parameter(Mandatory)]
        [string] $ChildPath,

        # Additional child paths to join with the base URI.
        [Parameter(ValueFromRemainingArguments)]
        [string[]] $AdditionalChildPath
    )

    $segments = $ChildPath, $AdditionalChildPath
    $normalizedSegments = $segments | ForEach-Object { $_.Trim('/') }
    $uri = $Path.ToString().TrimEnd('/') + '/' + ($normalizedSegments -join '/')
    $uri
}
